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
      style = "padding-bottom: 10px;",
      bs4UserCard(
        type = 2,
        width = 2,
        src = "caduceus.png",
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
            selected = all_vars[2]
          ),
          actionButton("show_modal", "Explore")
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
