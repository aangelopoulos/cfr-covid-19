plot_cfr_timeseries <- function(df,start,end,ymax=30.0) {
  library("ggplot2")
  COUNTRY1 = df["COUNTRY1"][[1]]
  COUNTRY2 = df["COUNTRY2"][[1]]
  reich = df["reich"]
  naive = df["naive"]
  obs = df["obs"]
  ggplot(df, aes(x=time)) + geom_line(aes(y=reich),color="darkred") +
    geom_ribbon(aes(ymin = reich-0.3, ymax = reich+0.3), alpha = 0.3, 
                fill = "darkred", color = "transparent") +
    geom_line(aes(y=obs),color="steelblue") + geom_line(aes(y=naive),color="seagreen") +
    geom_line(aes(y=ones),color="coral") +  labs(y=paste0(COUNTRY2,"/",COUNTRY1)) +
    xlim(start,end) + coord_cartesian(ylim=c(0,min(ymax,max(max(unlist(reich[!is.na(reich)])),max(unlist(naive[!is.na(naive)])),max(unlist(obs[!is.na(obs)])))))) + 
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank())
  
  ggsave(paste0("./plots/",COUNTRY1,COUNTRY2,".pdf"),device="pdf",width=10,height=5,units="cm")
}
