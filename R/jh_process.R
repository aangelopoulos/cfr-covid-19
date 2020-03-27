#' @export
jh_process <- function(x, term){
  output <- x %>%
    group_by(Country.Region, Province.State) %>%
    summarise_at(names(.)[purrr::partial(startsWith, prefix = "X")(names(.))], sum) %>%
    tidyr::gather(date, !!term, -Country.Region, -Province.State) %>%
    mutate(date = stringr::str_sub(date, start = 2) %>%
             lubridate::as_date(format = "%m.%d.%y", tz = "Europe/London"))
  return(output)
}
