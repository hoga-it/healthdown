library(leafdown)
# Run before uploading
#devtools::install_github("hoga-it/leafdown")

# Comment this when uploading
states <- readRDS("us1.RDS")
counties <- readRDS("us2.RDS")

us_health_states <- read.csv2("data/clean/us_health_states.csv")
us_health_counties <- read.csv2("data/clean/us_health_counties.csv")

# filter date for now
us_health_states_raw <- us_health_states %>% select(year, ST, Premature.death.YPLL.Rate, Poor.or.fair.health...Fair.Poor)
us_health_counties_raw <- us_health_counties %>% select(year, ST, NAME_2, Premature.death.YPLL.Rate, Poor.or.fair.health...Fair.Poor)

percent <- function(x, digits = 2, format = "f", ...) {      # Create user-defined function
  paste0(formatC(x * 100, format = format, digits = digits, ...), "%")
}

create_labels <- function(data, map_level) {
  labels <- sprintf(
    "<strong>%s</strong><br/>
    Premature death:YPLL Rate: %s<br/>
    Poor or fair health: Fair/Poor: %s<br/>
    </sup>",
    data[, paste0("NAME_", map_level)],
    percent(data$'Premature death:YPLL Rate'),
    percent(data$'Poor.or.fair.health...Fair.Poor')
  )
  labels %>% lapply(htmltools::HTML)
}

# Define server for leafdown app
server <- function(input, output) {
  # load the shapes for the two levels
  spdfs_list <- list(states, counties)

  # create leafdown object
  my_leafdown <- Leafdown$new(spdfs_list, "leafdown", input)

  rv <- reactiveValues()
  rv$update_leafdown <- 0

  # observers for the drilling buttons
  observeEvent(input$drill_down, {
    my_leafdown$drill_down()
    rv$update_leafdown <- rv$update_leafdown + 1
  })

  observeEvent(input$drill_up, {
    my_leafdown$drill_up()
    rv$update_leafdown <- rv$update_leafdown + 1
  })
  
  data <- reactive({
    req(rv$update_leafdown)
    # fetch the current metadata from the leafdown object
    data <- my_leafdown$curr_data
    # join the metadata with the election-data.
    # depending on the map_level we have different election-data so the 'by' columns for the join are different
    if(my_leafdown$curr_map_level == 2) {
      data$ST <- substr(data$HASC_2, 4, 5)
      # there are counties with the same name in different states so we have to join on both
      data <- overwrite_join(data, us_health_counties_raw %>% filter(year == input$year), by = c("NAME_2", "ST"))
    } else {
      data$ST <- substr(data$HASC_1, 4, 5)
      data <- overwrite_join(data, us_health_states_raw %>% filter(year == input$year), by = "ST")
    }
    
    # add the data back to the leafdown object
    my_leafdown$add_data(data)
    data
  })

  # this is where the leafdown magic happens
  output$leafdown <- renderLeaflet({
    req(spdfs_list)
    req(data)
    
    data <- data()
    
    # depending on the selected KPI in the dropdown we show different data
    if(input$prim_var == "Premature.death") {
      data$y <- data$'Premature.death.YPLL.Rate'
      fillcolor <- leaflet::colorNumeric("Greens", data$y)
      legend_title <- "Premature death:YPLL Rate"
    } else {
      data$y <- data$'Poor.or.fair.health...Fair.Poor'
      fillcolor <- leaflet::colorNumeric("Greens", data$y)
      legend_title <- "Poor or fair health:% Fair/Poor"
    }
    
    labels <- create_labels(data, my_leafdown$curr_map_level)
    # draw the leafdown object
    my_leafdown$draw_leafdown(
      fillColor = ~fillcolor(data$y),
      weight = 3, fillOpacity = 1, color = "white", label = labels) %>%
      # set the view to be center on the USA
      setView(-95, 39,  4)  %>%
      # add a nice legend
      addLegend(pal = fillcolor,
                values = ~data$y,
                title = legend_title,
                opacity = 1)
  })
  
  df <- data.frame(
    x = seq(50),
    y = rnorm(50, 10, 3),
    z = rnorm(50, 11, 2),
    w = rnorm(50, 9, 2)
  )
  
  output$line <- renderEcharts4r({
    req(df)
    
    df %>% 
      e_charts(x) %>% 
      e_line(z) %>% 
      e_area(w) %>% 
      e_title("Line and area charts")
  })
  
  output$scatter <- renderEcharts4r({
    df <- my_leafdown$curr_sel_data()
    
    if(nrow(df) > 0) {
      df %>% 
        group_by(ST) %>%
        e_charts(Premature.death.YPLL.Rate) %>% 
        e_scatter(Poor.or.fair.health...Fair.Poor, symbol_size = 15)
    }
  })
  
  output$bar <- renderEcharts4r({
    df <- my_leafdown$curr_sel_data()
    
    if(nrow(df) > 0) {
      df %>%
        e_charts(ST) %>%
        e_bar(Premature.death.YPLL.Rate) -> plot
      
      plot # normal
      e_flip_coords(plot)
    }
  })
  
  
  output$mytable = DT::renderDataTable({
    req(rv$update_leafdown)
    # fetch the current metadata from the leafdown object
    data <- data()
    data <- data[, c("ST", 'Premature.death.YPLL.Rate')]
    names(data) <- c("ST", "YPLL")
    data
  })
  
  
  overwrite_join <- function(x, y, by = NULL){
    bycols     <- which(colnames(x) %in% by) 
    commoncols <- which(colnames(x) %in% colnames(y))
    duplicatecols <- commoncols[!commoncols %in% bycols]
    
    if(length(duplicatecols) == 0) {
      duplicatecols <- c()
    }
    
    out <- x %>% select(-duplicatecols) %>% left_join(y, by = by)
    return(out)
  }
    
}
