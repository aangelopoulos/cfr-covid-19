
library(dplyr)

COUNTRY1 <- "China"
COUNTRY2 <- "Italy"
source("R/jh_process.R")

confirmed <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") %>%
  jh_process("confirmed")

recovered <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv") %>%
  jh_process("recovered") 

deaths <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv") %>%
  jh_process("deaths")

jh_data <- left_join(confirmed, recovered, by = c("Country.Region", "Province.State", "date")) %>% left_join(deaths, by = c("Country.Region", "Province.State", "date")) %>%
  filter(Country.Region %in% c(COUNTRY1, COUNTRY2)) %>%
  group_by(Country.Region, date) %>%
  # Add up all the provinces for the two countries
  summarise(confirmed = sum(confirmed), recovered = sum(recovered), deaths = sum(deaths)) %>% 
  # Order the dataframe by date
  arrange(date) %>%
  group_by(Country.Region) %>%
  # Create a difference matrix
  do(data.frame(time = 1:I(length(.$recovered)-1), recovered = diff(.$recovered), deaths = diff(.$deaths), confirmed = diff(.$confirmed)))

jh_data$Country.Region <- forcats::fct_recode(jh_data$Country.Region, `1` = COUNTRY1, `2` = COUNTRY2) %>% as.character() %>% as.numeric()

jh_mat <- as.matrix(jh_data)
jh_mat <- jh_mat[,c(2,1,3,4,5)]

colnames(jh_mat) <- c("time", "grp", "R", "D", "N")
