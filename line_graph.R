create_line_graph <- function(data, curr_sel_data, prim_var, sec_var) {
  # filter the data to get only the currently selected data
  df <- data %>% filter(ST %in% curr_sel_data$ST)
  
  df$year <- as.Date(ISOdate(df$year, 1, 1))
  
  df %>% 
    group_by(ST) %>% 
    e_charts(year) %>% 
    e_line_(prim_var) %>%
    e_line_(sec_var, lineStyle = list(type = "dashed"), x_index = 1, y_index = 1) %>%
    e_tooltip(trigger = "axis") 
}

