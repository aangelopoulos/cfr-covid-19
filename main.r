rm(list = ls())
source("./generate_cfr_data.r")
source("./plot_cfr_timeseries.r")
library("parallel")

args = commandArgs(trailingOnly=TRUE)

start = 72
end = 92
maxiters=50
realign=TRUE
numCores = detectCores()
print(numCores)

# You can also construct the list by looping...
#C1 = c("Korea, South", "Korea, South", "Korea, South", "Germany", "Germany", "Italy")
#C2 = c("Austria","Spain","Switzerland","Iran","United Kingdom")

L = list(
         list(COUNTRY1="Korea, South",COUNTRY2="Spain",ylabel="CFR of ESP/KOR"),
         list(COUNTRY1="Korea, South",COUNTRY2="Austria",ylabel="CFR of AUT/KOR"),
         list(COUNTRY1="Italy",COUNTRY2="United Kingdom",ylabel="CFR of GBR/ITA"),
         list(COUNTRY1="Germany",COUNTRY2="Switzerland",ylabel="CFR of CHE/DEU"),
         list(COUNTRY1="Germany",COUNTRY2="Iran",ylabel="CFR of IRN/DEU"),
         list(COUNTRY1="Belgium",COUNTRY2="Iran",ylabel="CFR of IRN/BEL")
        )


fx <- function(L) {
    c1=L["COUNTRY1"][[1]]
    c2=L["COUNTRY2"][[1]]
    df = NA
    if((length(args)==1) & (args[1] == "-newdata")) {
        df = generate_cfr_data(c1,c2,start=start,end=end,maxiters=maxiters,realign=realign)
    } else {
        df = read.csv(file=paste0("./plots/",c1,c2,".csv"),header=TRUE)
    }
    plot_cfr_timeseries(df,start,end,ylabel=L["ylabel"][[1]])
}

results = mclapply(L, fx, mc.cores=numCores)
