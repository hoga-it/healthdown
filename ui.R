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

ui = bs4DashPage(
  bs4DashSidebar(disable = TRUE),
  body = bs4DashBody(
    # set the background of the map-container to be white
    tags$head(
      tags$style(HTML(".leaflet-container { background: #fff; height: 100%}")),
      # workaround for the NA in leaflet legend see https://github.com/rstudio/leaflet/issues/615
      tags$style(HTML(".leaflet-control div:last-child {clear: both;}")),
      tags$style(HTML(".widget-user-header {background-color: #16c2d5!important;}")),
      tags$style(HTML(".col-sm-12:last-child .card {margin-bottom: 0 !important;}")),
      tags$style(HTML("#leafdown {height: 90% !important; margin-top: 10px; margin-bottom: 10px;}")),
      tags$style(HTML(".card-header {height: 0;
                        visibility: hidden;
                        margin: 0;
                        padding: 0;}")
                 )
    ),
    # we need shinyjs for the leafdown map
    useShinyjs(),
    introjsUI(),
    fluidRow(
      column(
        width = 2,
        # box for racial makeup graph
        bs4UserCard(
          src = "https://upload.wikimedia.org/wikipedia/commons/5/57/Caduceus.svg",
          status = "info",
          title = "Health Ranking Data",
          subtitle = "a subtitle here",
          elevation = 1,
          "Any content here",
          width = 12
        ),
        bs4Card(
          width = 12,
          DT::dataTableOutput("mytable")
        )
      ),
      column(
        width = 10,
        fluidRow(
          bs4Card(
            title = NULL,
            width = 12,
            fluidRow(
              pickerInput(
                inputId = "year",
                label = "Select the Year",
                choices = all_years,
                selected = max(all_years)
              ),
              pickerInput(
                inputId = "prim_var",
                label = "Select the Primary Variable",
                choices = all_vars,
                selected = all_vars[1]
              ),
              pickerInput(
                inputId = "sec_var",
                label = "Select the Secondary Variable",
                choices = all_vars,
                selected = all_vars[1]
              ),
              dropdownButton(
                tags$h3("AA"),
                actionButton("help", "More information on the app"),
                circle = TRUE, status = "primary", icon = icon("info-circle"), width = "300px"
              )
            )
          )
        ),
        fluidRow(
          width = 12,
          # a card for the map
          column(
            width = 7,
            introBox(
              bs4Card(
                closable = FALSE,
                collapsible = FALSE,
                width = 12,
                height = 500,
                # a dropdown to select what KPI should be displayed on the ma
                # the two buttons used for drilling
                introBox(
                  actionButton("drill_down", "Drill Down"),
                  actionButton("drill_up", "Drill Up"),
                  data.step = 2,
                  data.intro = "Drill the Map! <br> 
                                  Use these buttons to drill the map on the selected shapes."
                ),
                # the actual map element
                leafletOutput("leafdown")
              ),
              data.step = 1,
              data.intro = "The Map! <br> 
                              Click on shapes to select them and show their info in the plots."
            ),
            bs4Card(
              width = 12,
              height = 250,
              closable = FALSE,
              collapsible = FALSE,
              echarts4rOutput("line",height = 250)
            )
          ),
          
          
          # a column with the two graphs
          column(
            width = 5,
            bs4Card(
              width = 12,
              closable = FALSE,
              collapsible = FALSE,
              echarts4rOutput("bar")
            ),
            bs4Card(
              width = 12,
              closable = FALSE,
              collapsible = FALSE,
              echarts4rOutput("scatter")
            )
          )
        )
      )
    )
  )
)
