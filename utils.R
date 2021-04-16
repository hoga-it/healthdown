overwrite_join <- function(x, y, by = NULL){
  bycols     <- which(colnames(x) %in% by) 
  commoncols <- which(colnames(x) %in% colnames(y))
  duplicatecols <- commoncols[!commoncols %in% bycols]
  
  if(length(duplicatecols) == 0) {
    duplicatecols <- c()
  }
  
  out <- x %>% select(-duplicatecols) %>% left_join(y, by = by)
  return(out)
}