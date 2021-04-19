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
      tags$style(HTML(".leaflet-container { background: #fff; height: 100%}")),
      # workaround for the NA in leaflet legend see https://github.com/rstudio/leaflet/issues/615
      tags$style(HTML(".leaflet-control div:last-child {clear: both;}")),
      tags$style(HTML(".widget-user-header {background-color: #16c2d5!important;}")),
      #tags$style(HTML(".col-sm-12:last-child .card {margin-bottom: 0 !important;}")),
      #tags$style(HTML("#leafdown {height: 90% !important; margin-top: 10px; margin-bottom: 10px;}")),
      tags$style(HTML(".card-header {height: 0;
                        visibility: hidden;
                        margin: 0;
                        padding: 0;}")),
      tags$style(HTML(".card-footer {padding: 0rem 0rem;}
                      .card {height: 100%"))
    ),
    # we need shinyjs for the leafdown map
    useShinyjs(),
    introjsUI(),
    fluidRow(
      style = "padding-bottom: 10px;",
      bs4UserCard(
        type = 2,
        width = 2,
        src = "https://smalea.com/files/netzwerk/munichom%20logo.png",
        status = "info",
        title = "Health Ranking Data",
        elevation = 1,
        footer = NULL
      ),
      bs4Card(
        title = NULL,
        width = 10,
        height = "100px",
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
          actionButton("show_modal", "Explore"),
          dropdownButton(
            tags$h3("AA"),
            actionButton("help", "More information on the app"),
            circle = TRUE, status = "primary", icon = icon("info-circle"), width = "300px"
          )
        )
      )
    ),
    fluidRow(
          bs4Card(
            width = 2,
            DT::dataTableOutput("mytable", height = "30vh")
        ),
        column(
          width = 10,
          fluidRow(
            style = "padding-bottom: 10px;",
              bs4Card(
                width = 6,
                closable = FALSE,
                collapsible = FALSE,
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
                introBox(
                  leafletOutput("leafdown", height = "30vh"),
                  data.step = 1,
                  data.intro = "Drill the Map! <br> 
                                  Use these buttons to drill the map on the selected shapes."
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
            heigt = "90%",
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
