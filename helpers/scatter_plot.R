create_scatter_plot <- function(df, prim_var, sec_var) {
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
      e_x_axis(nameLocation = "center", min = 0.9 * min(df[[prim_var]])) %>% 
      e_y_axis(nameLocation = "center", min = 0.9 * min(df[[sec_var]]))
      
  } else {
    # TODO add message to select a shape
  }
}