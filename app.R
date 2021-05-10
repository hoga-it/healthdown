library(shiny)
library(shinyjs)
library(leaflet)
library(leafdown)
library(echarts4r)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(shinydashboard)
library(shinyWidgets)
library(readr)


# resources -----------------------------------------------------------------
source("healthdown/healthdown_ui.R")
source("healthdown/healthdown.R")


source("healthdown/helpers/utils.R")
source("healthdown/helpers/scatter_plot.R")
source("healthdown/helpers/line_graph.R")
source("healthdown/helpers/table.R")
source("healthdown/helpers/bar_chart.R")

states <- readRDS("shapes/us1.RDS")
counties <- readRDS("shapes/us2.RDS")
spdfs_list <- list(states, counties)

us_health_states <- readr::read_delim(
  "data/clean/us_health_states.csv", ";", 
  escape_double = FALSE, trim_ws = TRUE,
  col_types = readr::cols(),
  locale = readr::locale(decimal_mark = ",", grouping_mark = ".")
)

us_health_counties <- readr::read_delim(
  "data/clean/us_health_counties.csv", ";", 
  escape_double = FALSE, trim_ws = TRUE,
  col_types = readr::cols(),
  locale = readr::locale(decimal_mark = ",", grouping_mark = ".")
)

us_health_all <- rbind(us_health_states, us_health_counties)
all_years <- unique(us_health_all$year)
all_vars <- sort(names(us_health_all)[6:ncol(us_health_all)])
all_vars <- all_vars[!grepl("-CI", all_vars)]
all_vars <- all_vars[!grepl("-Z", all_vars)]

# App -----------------------------------------------------------------

shinyApp(
  ui = htmlTemplate(
    filename = "www/index.html",
    what_if_ui = mod_healthdown_ui("healthdown")
  ),
  server = function(input, output) {
    callModule(mod_healthdown, "healthdown")
  }
)