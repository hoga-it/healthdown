source("utils.R")
source("scatter_plot.R")
source("line_graph.R")
source("table.R")
source("bar_chart.R")
# Run before uploading
# devtools::install_github("hoga-it/leafdown")

# Comment this when uploading
states <- readRDS("us1.RDS")
counties <- readRDS("us2.RDS")

us_health_states <- read.csv2("data/clean/us_health_states.csv")
us_health_counties <- read.csv2("data/clean/us_health_counties.csv")
us_health_all <- read.csv2("data/clean/all.csv")

all_years <- unique(us_health_all$year)
# TODO: Ignore CI columns (once we renamed all columns)
all_vars <- sort(names(us_health_all)[6:ncol(us_health_all)])