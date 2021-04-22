create_bar_chart <- function(curr_sel_data, prim_var) {
  df <- curr_sel_data
  
  if (nrow(df) > 0) {
    df$name <- ifelse(is.na(df$NAME_2), as.character(df$ST), as.character(df$NAME_2))
    
    df %>% 
      group_by(name) %>%
      e_charts(name, stack = "grp") %>%
      e_bar_(prim_var) %>%
      e_axis_labels(y = prim_var) %>% 
      e_y_axis(nameLocation = "center", nameGap  = 30)  %>% 
      e_flip_coords()
      
  } else {
    # TODO add message to select a shape
  }
}