rm(list = ls())
source("./generate_cfr_data.r")
source("./plot_cfr_timeseries.r")
library("parallel")

args = commandArgs(trailingOnly=TRUE)

start = 70
end = 86
maxiters=50
numCores = detectCores()
print(numCores)

C1 = c("Korea, South", "Korea, South", "Korea, South", "Germany", "Germany", "Italy")
C2 = c("Austria","Spain","Switzerland","Iran","United Kingdom")

L = list(
         l1=list(COUNTRY1="Korea, South", COUNTRY2="Austria"),
         l2=list(COUNTRY1="Korea, South", COUNTRY2="Spain"),
         l3=list(COUNTRY1="Korea, South", COUNTRY2="Switzerland"),
         l4=list(COUNTRY1="Germany",COUNTRY2="Iran"),
         l5=list(COUNTRY1="Germany",COUNTRY2="Switzerland"),
         l6=list(COUNTRY1="Italy",COUNTRY2="United Kingdom")
        )


fx <- function(L) {
    c1=L["COUNTRY1"][[1]]
    c2=L["COUNTRY2"][[1]]
    df = NA
    if((length(args)==1) & (args[1] == "-newdata")) {
        df = generate_cfr_data(c1,c2,start=start,end=end,maxiters=maxiters)
    } else {
        df = read.csv(file=paste0("./plots/",c1,c2,".csv"),header=TRUE)
    }
    plot_cfr_timeseries(df,start,end)
}

results = mclapply(L, fx, mc.cores=numCores)
