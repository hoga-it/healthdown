create_mytable <- function(all_data, sel_data, map_level) {
  # TODO: Make this nicer once we have all columns in our data
  curr_gid <- if_else(map_level == 1, "GID_1", "GID_2")
  sel_ids <- which(all_data[[curr_gid]] %in% sel_data[[curr_gid]])
  
  if (map_level == 1) {
    rel_columns <- c("ST", "Premature.death.YPLL.Rate")
  } else {
    rel_columns <- c("ST", "NAME_2", "Premature.death.YPLL.Rate")
  }
  all_data <- all_data[, rel_columns]
  names(all_data)[1 + map_level] <- "YPLL"
  if (map_level == 1) {
    DT::datatable(
      all_data, rownames = FALSE, selection = list(selected = sel_ids), 
      options = list(
        dom = 'ft', deferRender = TRUE, scrollY = 600, scroller = TRUE, paging = FALSE, 
        bSort = FALSE
      )
    )
  } else {
    all_data <- all_data[, c(2, 3, 1)]
    DT::datatable(
      all_data, rownames = FALSE, selection = list(selected = sel_ids), extensions = 'RowGroup',
      options = list(
        dom = 'ft', deferRender = TRUE, scrollY = 600, scroller = TRUE, paging = FALSE, 
        bSort = FALSE, rowGroup = list(dataSrc = 2), 
        columnDefs = list(list(visible = FALSE, targets = 2))
      )
    )
  }
}