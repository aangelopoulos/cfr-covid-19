
generate_coronamat <- function(COUNTRY1, COUNTRY2, L, loc_list = list("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv", "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")){

  confirmed <- read.csv(loc_list[[1]]) %>%
    jh_process("confirmed")
  
  recovered <- read.csv(loc_list[[2]]) %>%
    jh_process("recovered") 
  
  deaths <- read.csv(loc_list[[3]]) %>%
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
  
  #jh_mat = jh_mat[-(35:66),]
  #jh_mat = jh_mat[-(35:66),]
  #jh_mat[31:68,"time"] = 1:38
  
  # Pad with L zeros. This is to protect against assumed.nu being too big.
  time_orig = dim(jh_mat)[1]/2
  c1 = jh_mat[1:time_orig,]
  c2 = jh_mat[(time_orig+1):(time_orig*2),]
  c1[,"time"] = c1[,"time"] + L
  c2[,"time"] = c2[,"time"] + L
  z1 = cbind(c(1:L),rep(1,L),rep(0,L),rep(0,L),rep(0,L))
  z2 = cbind(c((1:L)),rep(2,L),rep(0,L),rep(0,L),rep(0,L))
  jh_mat = rbind(z1,c1,z2,c2)
  return(jh_mat)
}