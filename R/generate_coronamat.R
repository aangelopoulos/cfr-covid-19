generate_coronamat <- function(COUNTRY1, COUNTRY2, L, enddate, min.cases=100, realign=TRUE, loc_list = list("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv", "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")){
  source("./R/simulate_reference_distribution.R")
  
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
  jh_data <- jh_data %>% arrange(Country.Region)

  jh_mat <- as.matrix(jh_data)

  if(COUNTRY1==COUNTRY2){
    ttotal = dim(jh_mat)[1]
    jh_mat1 = jh_mat
    jh_mat1[,"Country.Region"] = 1
    jh_mat = rbind(jh_mat1,jh_mat)
  }
  # Simulation if countries are the same
  #if(COUNTRY1==COUNTRY2) {
  #  len = dim(jh_mat)[1]
  #  ref = simulate_reference_distribution(jh_mat,T=len)
  #  jh_mat = rbind(ref,jh_mat)
  #}
  
  jh_mat <- jh_mat[,c(2,1,3,4,5)]
  
  colnames(jh_mat) <- c("time", "grp", "R", "D", "N")
  time_orig = dim(jh_mat)[1]/2
  
  if(is.na(enddate)){
    enddate=time_orig
  }
  
  c1 = jh_mat[1:time_orig,][1:enddate,]
  c2 = jh_mat[(time_orig+1):(time_orig*2),][1:enddate,]
  
  # Curve alignment (method is not robust to epidemics starting at vastly different times):
  if(realign) {
      ts1 = min(which(c1[,"N"]>min.cases))
      ts2 = min(which(c2[,"N"]>min.cases))
      if(ts1>ts2) {
        c1[,"N"] = c(c1[-(1:(ts1-ts2)),"N"],rep(0,ts1-ts2))
        c1[,"D"] = c(c1[-(1:(ts1-ts2)),"D"],rep(0,ts1-ts2))
        c1[,"R"] = c(c1[-(1:(ts1-ts2)),"R"],rep(0,ts1-ts2))
      } else if(ts2>ts1) {
        c2[,"N"] = c(c2[-(1:(ts2-ts1)),"N"],rep(0,ts2-ts1))
        c2[,"D"] = c(c2[-(1:(ts2-ts1)),"D"],rep(0,ts2-ts1))
        c2[,"R"] = c(c2[-(1:(ts2-ts1)),"R"],rep(0,ts2-ts1))
      }
  }
  # Pad with L zeros. This is to protect against assumed.nu being too big.
  c1[,"time"] = c1[,"time"] + L
  c2[,"time"] = c2[,"time"] + L
  z1 = cbind(c(1:L),rep(1,L),rep(0,L),rep(0,L),rep(0,L))
  z2 = cbind(c((1:L)),rep(2,L),rep(0,L),rep(0,L),rep(0,L))
  jh_mat = rbind(z1,c1,z2,c2)
  return(jh_mat)
}
