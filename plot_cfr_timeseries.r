plot_cfr_timeseries <- function(df,start,end,ymax=Inf,ylabel=NA,normdays=TRUE) {
  library("ggplot2")
  COUNTRY1 = df["COUNTRY1"][[1]]
  COUNTRY2 = df["COUNTRY2"][[1]]
  if(is.na(ylabel)){
      ylabel=paste0("CFR of ",COUNTRY2,"/",COUNTRY1)
  }
  if(normdays){
      df["time"] = df["time"]-start
      end = end-start
      start = 0
  }
  reich = df["reich"]
  reich_ub = df["reich_ub"]
  reich_lb = df["reich_lb"]
  naive = df["naive"]
  obs = df["obs"]
  ggplot(df, aes(x=time)) + geom_line(aes(y=reich),color="darkred") +
    geom_ribbon(aes(ymin = reich_lb, ymax = reich_ub), alpha = 0.3, 
                fill = "darkred", color = "transparent") +
    geom_line(aes(y=obs),color="steelblue") + geom_line(aes(y=naive),color="seagreen") +
    geom_line(aes(y=ones),color="coral") +  labs(y=paste0(COUNTRY2,"/",COUNTRY1)) +
    xlim(start,end) + coord_cartesian(ylim=c(0,min(ymax,max(max(unlist(reich[!is.na(reich)])),max(unlist(naive[!is.na(naive)])),max(unlist(obs[!is.na(obs)])))))) + 
    theme_minimal() + 
    theme(text=element_text(size=8))+
    labs(y=ylabel,x="time (days)")
  ggsave(paste0("./plots/",COUNTRY1,COUNTRY2,".pdf"),device="pdf",width=10,height=5,units="cm")
}
