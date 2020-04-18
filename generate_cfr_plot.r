generate_cfr_plot <- function(COUNTRY1,COUNTRY2,start=35,end=86,ymax=30.0,maxiters=400) {
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
  df = data.frame(time=c(1:end),naive=unlist(naive),obs=unlist(obs),reich=unlist(reich),ones=unlist(allones))
  ggplot(df, aes(x=time)) + geom_line(aes(y=reich),color="darkred") +
    geom_ribbon(aes(ymin = reich-0.3, ymax = reich+0.3), alpha = 0.3, 
                fill = "darkred", color = "transparent") +
    geom_line(aes(y=obs),color="steelblue") + geom_line(aes(y=naive),color="seagreen") +
    geom_line(aes(y=ones),color="coral") +  labs(y=paste0(COUNTRY2,"/",COUNTRY1)) +
    xlim(start,end) + ylim(0,min(ymax,max(max(unlist(reich[!is.na(reich)])),max(unlist(naive[!is.na(naive)])),max(unlist(obs[!is.na(obs)]))))) + 
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),)
  
  ggsave(paste0("./plots/",COUNTRY1,COUNTRY2,".pdf"),device="pdf")
}
