mod_healthdown_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # we need shinyjs for the leafdown map
    useShinyjs(),
    fluidRow(
      class = "top-row",
      box(
        width = 2,
        actionButton(ns("view1"), "Map View", style = "width:100%;"),
        actionButton(ns("view2"), "Full Map", style = "width:100%;"),
        actionButton(ns("view3"), "Overview", style = "width:100%;"),
      ),
      box(
        width = 8,
        height = "100px",
        fluidRow(
          div(
            class = "spread3evenly",
            div(
              class = "var-dropdown",
              pickerInput(
                inputId = ns("year"),
                label = "Select the Year",
                choices = all_years,
                selected = max(all_years)
              )
            ),
            div(
              class = "var-dropdown",
              pickerInput(
                inputId = ns("prim_var"),
                label = "Select the Primary Variable",
                choices = all_vars,
                selected = all_vars[1]
              )
            ),
            div(
              class = "var-dropdown",
              pickerInput(
                inputId = ns("sec_var"),
                label = "Select the Secondary Variable",
                choices = all_vars,
                selected = all_vars[2]
              )
            )
          )
        )
      ),
      box(
        width = 2,
        class = "card-hexagon",
        div(style = "height: 100px; width: 100px", 
        img(src = "assets/images/hex-leafdown.png"),
        div(
          class = "card-hexagon-title",
          tags$a(
            "Leafdown", 
            tags$i(class = "fas fa-xs fa-external-link-alt"), 
            href = "https://github.com/hoga-it/leafdown", 
            target = "_blank", 
            style = "color: white;"
          )
        )
      )
      )
    ),
    # ---- second row
    grid_stack(
      grid_stack_item(
        w = 2, h = 10, x = 0, y = 0, id =  ns("c_table"),
        DT::dataTableOutput(ns("mytable"))
      ),
      grid_stack_item(
        w = 5, h = 5, x = 2, y = 0, id = ns("c_map"),
        actionButton(ns("drill_down"), "Drill Down", icon = icon("arrow-down"), class = "drill-button healthdown-button"),
        actionButton(ns("drill_up"), "Drill Up", icon = icon("arrow-up"), class = "drill-button healthdown-button"),
        leafletOutput(ns("leafdown"), height = "calc(100% - 50px)")
      ),
      grid_stack_item(
        w = 5, h = 5, x = 7, y = 0, id = ns("c_bar"),
        echarts4rOutput(outputId =  ns("bar"), height = "100%")
      ),
      grid_stack_item(
        w = 5, h = 5, x = 2, y = 5, id =  ns("c_line"),
        echarts4rOutput(outputId =  ns("line"), height = "100%")
      ),
      grid_stack_item(
        w = 5, h = 5, x = 7, y = 5, id =  ns("c_scatter"),
        echarts4rOutput(outputId =  ns("scatter"), height = "100%")
      )
    )
  )
}
