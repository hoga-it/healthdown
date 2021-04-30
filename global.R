source("helpers/utils.R")
source("helpers/scatter_plot.R")
source("helpers/line_graph.R")
source("helpers/table.R")
source("helpers/bar_chart.R")
# Run before uploading
# devtools::install_github("hoga-it/leafdown")

# Comment this when uploading
states <- readRDS("shapes/us1.RDS")
counties <- readRDS("shapes/us2.RDS")

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
