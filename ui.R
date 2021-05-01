library(bs4Dash)
library(shiny)
library(shinyjs)
library(leaflet)
library(leafdown)
library(echarts4r)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(shinyWidgets)
library(rintrojs)
library(readr)

ui = bs4DashPage(
  bs4DashSidebar(disable = TRUE),
  body = bs4DashBody(
    
    # set the background of the map-container to be white
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    # we need shinyjs for the leafdown map
    useShinyjs(),
    introjsUI(),
    fluidRow(
      class = "top-row",
      bs4Card(
        width = 2,
        class = "card-hexagon",
        img(src = "hex-healthdown.png"),
        div("Health Ranking", class = "card-hexagon-title")
      ),
      bs4Card(
        width = 8,
        height = "100px",
        introBox(
          fluidRow(
            div(
              class = "spread4evenly",
              div(
                class = "var-dropdown",
                pickerInput(
                  inputId = "year",
                  label = "Select the Year",
                  choices = all_years,
                  selected = max(all_years)
                )
              ),
              div(
                class = "var-dropdown",
                pickerInput(
                  inputId = "prim_var",
                  label = "Select the Primary Variable",
                  choices = all_vars,
                  selected = all_vars[1]
                )
              ),
              div(
                class = "var-dropdown",
                pickerInput(
                  inputId = "sec_var",
                  label = "Select the Secondary Variable",
                  choices = all_vars,
                  selected = all_vars[2]
                )
              ),
              div(
                actionButton("show_modal", "Explore", class = "learn-more"),
                style = "text-align: center; margin-top: 25px;"
              )
            )
          ),
          data.step = 4,
          data.intro = "Compare different features! <br> 
                        Use these dropdowns to change the features displayed in the map and graphs. <br>
                        The primary is displayed on the map and the graph and 
                          the secondary is used for the y-axis in the scatter plot."
        )
      ),
      bs4Card(
        width = 2,
        class = "card-hexagon",
        introBox(
          div(style = "height: 100px; width: 100px", 
          img(src = "hex-leafdown.png"),
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
        ),
        data.step = 5,
        data.intro = "Leafdown! <br> 
                          Check out our package to create your own awesome drillable maps!"
        )
      )
    ),
    fluidRow(
      bs4Card(
        width = 2,
        introBox(
          DT::dataTableOutput("mytable", height = "50vh"),
          data.step = 3,
          data.intro = "Find states and counties! <br> 
                        Search states and counties and click on them to select them on the map."
        )
      ),
      column(
        width = 10,
        fluidRow(
          style = "padding-bottom: 10px;",
          bs4Card(
            width = 6,
            closable = FALSE,
            collapsible = FALSE,
            introBox(
              actionButton("drill_down", "Drill Down"),
              actionButton("drill_up", "Drill Up"),
              data.step = 2,
              data.intro = "Drill the Map! <br> 
                            Use these buttons to drill the map on the selected shapes."
            ),
            introBox(
              leafletOutput("leafdown", height = "30vh"),
              data.step = 1,
              data.intro = "The Map! <br> 
                            Click on shapes to select them and compare their values in the graphs."
            )
          ),
          bs4Card(
            width = 6,
            closable = FALSE,
            collapsible = FALSE,
            echarts4rOutput("bar", height = "30vh")
          )
        ),
        fluidRow(
          height = "90%",
          bs4Card(
            width = 6,
            closable = FALSE,
            collapsible = FALSE,
            echarts4rOutput("line", height = "30vh")
          ),
          bs4Card(
            width = 6,
            closable = FALSE,
            collapsible = FALSE,
            echarts4rOutput("scatter", height = "30vh")
          )
        )
      )
    )
  )
)
