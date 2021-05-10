server <- function(input, output) {
  callModule(mod_healthdown, "healthdown")
}