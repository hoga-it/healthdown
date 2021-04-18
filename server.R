server <- function(input, output, session) {

  # start introjs when button is pressed with custom options and events
  observeEvent(
    input$help,
    introjs(session, options = list(
      "nextLabel" = "Next",
      "prevLabel" = "Back",
      "skipLabel" = "Skip"
    ))
  )

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
    if (my_leafdown$curr_map_level == 2) {
      data$ST <- substr(data$HASC_2, 4, 5)
      # there are counties with the same name in different states so we have to join on both
      data <- overwrite_join(data, us_health_counties %>% filter(year == input$year), by = c("NAME_2", "ST"))
    } else {
      data$ST <- substr(data$HASC_1, 4, 5)
      data <- overwrite_join(data, us_health_states %>% filter(year == input$year), by = "ST")
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
    data$y <- data[, input$prim_var]
    fillcolor <- leaflet::colorNumeric("Greens", data$y)
    legend_title <- input$prim_var


    labels <- create_labels(data, my_leafdown$curr_map_level, input$prim_var, input$sec_var)
    # draw the leafdown object
    my_leafdown$draw_leafdown(
      fillColor = ~ fillcolor(data$y),
      weight = 3, fillOpacity = 1, color = "white", label = labels
    ) %>%
      # set the view to be center on the USA
      setView(-95, 39, 4) %>%
      # add a nice legend
      addLegend(
        pal = fillcolor,
        values = ~ data$y,
        title = legend_title,
        opacity = 1
      )
  })

  output$line <- renderEcharts4r({
    create_line_graph(
      us_health_all, my_leafdown$curr_sel_data(),
      input$prim_var, input$sec_var
    ) %>%
      e_group("grp") %>% # assign group
      e_connect_group("grp") # connect
  })

  output$scatter <- renderEcharts4r({
    create_scatter_plot(my_leafdown$curr_sel_data(), input$prim_var, input$sec_var) %>%
      e_group("grp") %>% # assign group
      e_connect_group("grp") # connect
  })

  output$bar <- renderEcharts4r({
    create_bar_chart(my_leafdown$curr_sel_data(), input$prim_var) %>%
      e_group("grp") %>% # assign group
      e_connect_group("grp") # connect
  })


  output$mytable <- DT::renderDataTable({
    all_data <- data()
    sel_data <- my_leafdown$curr_sel_data()
    map_level <- my_leafdown$curr_map_level
    create_mytable(all_data, sel_data, map_level, input$prim_var)
  })

  # (Un)select shapes in map when click on table
  observeEvent(input$mytable_row_last_clicked, {
    sel_row <- input$mytable_row_last_clicked
    sel_shape_id <- my_leafdown$curr_poly_ids[sel_row]
    my_leafdown$toggle_shape_select(sel_shape_id)
  })
  
 
  
}
