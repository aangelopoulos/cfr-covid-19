generate_cfr_data <- function(COUNTRY1,COUNTRY2,start=35,end=86,maxiters=400,realign=TRUE,sensitivity=TRUE) {
  library(ggplot2)
  theme_set(theme_minimal())
  source("./relative_cfr.r")
  naive = rep(NA,end)
  obs = rep(NA,end)
  reich = rep(NA,end)
  reich_ub = rep(NA,end) # Upper sensitivity bound
  reich_lb = rep(NA,end) # Lower sensitivity bound
  allones=rep(1.0,end)
  conf_mus = c(12.8, 17.5)
  conf_stds = c(5.2, 9.1)
  for(i in c(start:end)) {
    trycfr = tryCatch(
      {
        out=relative_cfr(COUNTRY1,COUNTRY2,enddate=i,MAXITERS=maxiters,realign=realign)
        reich_ub[i] = out["reich"]
        reich_lb[i] = out["reich"]
        # Multithreading the sensitivity analysis.
        if(sensitivity){
            L = list()
            for(mu in conf_mus){
                for(std in conf_stds){ 
                    L=c(L,list(list(mu=mu,std=std))) #add new element to list. 
                }
            }
            numcores=detectCores()
            fx = function(L) {
                mttd = L["mu"][[1]]
                std = L["std"][[1]]
                temp=relative_cfr(COUNTRY1,COUNTRY2,enddate=i,MAXITERS=maxiters,realign=realign,
                                  MTTD=mttd,STD=std)
                temp["reich"]
            }
            results = mclapply(L,fx,mc.cores=numCores)
            reich_ub[i] = max(unlist(reich_ub[i]),max(unlist(results)))
            reich_lb[i] = min(unlist(reich_lb[i]),min(unlist(results)))
            print(paste0("Sensitivity: (",reich_lb[i],",",reich_ub[i],")"))
        }
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
  df = data.frame(COUNTRY1=COUNTRY1, COUNTRY2=COUNTRY2, time=c(1:end),naive=unlist(naive),obs=unlist(obs),reich=unlist(reich),ones=unlist(allones),reich_ub = unlist(reich_ub), reich_lb=unlist(reich_lb))
  write.csv(df, file = paste0("./plots/",COUNTRY1,COUNTRY2,".csv"),row.names=FALSE)
  df
}
