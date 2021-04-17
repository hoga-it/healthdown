overwrite_join <- function(x, y, by = NULL){
  bycols <- which(colnames(x) %in% by) 
  commoncols <- which(colnames(x) %in% colnames(y))
  duplicatecols <- commoncols[!commoncols %in% bycols]
  
  if (length(duplicatecols) == 0) {
    duplicatecols <- c()
  }
  
  out <- x %>% select(-duplicatecols) %>% left_join(y, by = by)
  return(out)
}


percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(x * 100, format = format, digits = digits, ...), "%")
}

create_labels <- function(data, map_level) {
  labels <- sprintf(
    "<strong>%s</strong><br/>
    Premature death:YPLL Rate: %s<br/>
    Poor or fair health: Fair/Poor: %s<br/>
    </sup>",
    data[, paste0("NAME_", map_level)],
    percent(data$"Premature.death.YPLL.Rate"),
    percent(data$"Poor.or.fair.health...Fair.Poor")
  )
  labels %>% lapply(htmltools::HTML)
}
