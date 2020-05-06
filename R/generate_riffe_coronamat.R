generate_riffe_coronamat <- function(COUNTRY, by="Sex", L=25, min.cases=10, loc = "https://raw.githubusercontent.com/timriffe/covid_age/master/Data/Output_10.csv"){
  library("dplyr")
  library("data.table")
  source("./R/dmy2ymd.R")
  source("./R/collapse_two_columns.R")
  
  keep_columns = c(by,"Date","Cases","Deaths")
  df = read.csv(loc) %>%
    filter(Country==COUNTRY)
  if(by=="Sex") {
    df = filter(df,Sex!="b")
  } else {
    df = filter(df,Sex=="b")
  }
  df = df[keep_columns]
  df["Date"] = apply(df["Date"],1,dmy2ymd)
  df["Cases"] = apply(df["Cases"],1,round) # This data is not ints... weird.
  df["Deaths"] = apply(df["Deaths"],1,round)
  df = df[order(df$Sex,df$Date),]
  df = collapse_two_columns(df,by,"Date")
  df1 = filter(df,Sex=="f")
  df2 = filter(df,Sex=="m")
  df1[,"Cases"] = c(0,diff(df1[,"Cases"]))
  df1[,"Deaths"] = c(0,diff(df1[,"Deaths"]))
  df2[,"Cases"] = c(0,diff(df2[,"Cases"]))
  df2[,"Deaths"] = c(0,diff(df2[,"Deaths"]))
  len = dim(df1)[1]
  df1 = cbind(c(1:len),rep(1,len),df1,rep(0,len))
  df2 = cbind(c(1:len),rep(2,len),df2,rep(0,len))
  colnames(df1) = c("time","grp","Sex","Date","N","D","R")
  colnames(df2) = c("time","grp","Sex","Date","N","D","R")
  df = rbind(df1,df2)
  df = df[c("time","grp","R","D","N")]
  #browser()
  df1 = df[1:len,]
  df2 = df[(len+1):(2*len),]
  # Pad with L zeros. This is to protect against assumed.nu being too big.
  df1[,"time"] = df1[,"time"] + L
  df2[,"time"] = df2[,"time"] + L
  z1 = data.frame(cbind(c(1:L),rep(1,L),rep(0,L),rep(0,L),rep(0,L)))
  colnames(z1) = c("time","grp","R","D","N")
  z2 = cbind(c((1:L)),rep(2,L),rep(0,L),rep(0,L),rep(0,L))
  colnames(z2) = c("time","grp","R","D","N")
  df = rbind(z1,df1,z2,df2)
  
  return(df)
}
