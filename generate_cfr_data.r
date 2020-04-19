generate_cfr_data <- function(COUNTRY1,COUNTRY2,start=35,end=86,maxiters=400) {
  library(ggplot2)
  theme_set(theme_minimal())
  source("./relative_cfr.r")
  naive = rep(NA,end)
  obs = rep(NA,end)
  reich = rep(NA,end)
  allones=rep(1.0,end)
  for(i in c(start:end)) {
    trycfr = tryCatch(
      {
        out=relative_cfr(COUNTRY1,COUNTRY2,enddate=i,MAXITERS=maxiters)
        naive[i]=out["naive"]
        obs[i] = out["obs"]
        reich[i] = out["reich"]
      },
      error=function(cond) 
      {
        print(cond)
      }
    )
  }
  df = data.frame(COUNTRY1=COUNTRY1, COUNTRY2=COUNTRY2, time=c(1:end),naive=unlist(naive),obs=unlist(obs),reich=unlist(reich),ones=unlist(allones))
  write.csv(df, file = paste0("./plots/",COUNTRY1,COUNTRY2,".csv"),row.names=FALSE)
  df
}
