create_scatter_plot <- function(curr_sel_data, prim_var, sec_var) {
  df <- curr_sel_data
  
  if (nrow(df) > 0) {
    df$name <- ifelse(is.na(df$NAME_2), as.character(df$ST), as.character(df$NAME_2))
    
    df %>% 
      group_by(name) %>%
      e_charts_(prim_var) %>% 
      e_scatter_(sec_var, symbol_size = 15) %>% 
      e_axis_labels(
        x = prim_var,
        y = sec_var
      ) %>% 
      e_x_axis(nameLocation = "center") %>% 
      e_y_axis(nameLocation = "center")
      
  } else {
    # TODO add message to select a shape
  }
}