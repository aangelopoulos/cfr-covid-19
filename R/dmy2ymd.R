dmy2ymd <- function(dmy) {
  # Takes a string of format dd.mm.yyyy and returns yyyy.mm.dd  
  list = strsplit(dmy,'\\.')[[1]]
  return(paste0(list[3],".",list[2],".",list[1]))
}