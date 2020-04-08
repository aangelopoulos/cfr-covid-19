assert <- function(message,condition) {
  if(!condition) {
    message(paste(message))
    if(ASSERT_STOP){
      stop()
    }
  }
}