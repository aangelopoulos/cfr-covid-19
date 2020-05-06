rm(list = ls())
source("../R/generate_riffe_coronamat.R")
source("../R/generate_riffe_data.R")
source("../plot_cfr_timeseries.r")
library("parallel")
library("data.table")
library("dplyr")
library("tidyr")

args = commandArgs(trailingOnly=TRUE)

start = 56
end = 58
maxiters=5000
numCores = detectCores()
print(numCores)

# You can also construct the list by looping...
#C1 = c("Korea, South", "Korea, South", "Korea, South", "Germany", "Germany", "Italy")
#C2 = c("Austria","Spain","Switzerland","Iran","United Kingdom")

L = list(
         list(COUNTRY="Spain",ylabel="CFR of females to males in South Korea.")
        )


fx <- function(L) {
    c=L["COUNTRY"][[1]]
    by=L["by"][[1]]
    df = NA
    df = generate_riffe_data(c)
    #if((length(args)==1) & (args[1] == "-newdata")) {
        #df = generate_cfr_data(c1,c2,start=start,end=end,maxiters=maxiters,realign=realign)
    #} else {
        #df = read.csv(file=paste0("./plots/",c1,c2,".csv"),header=TRUE)
    #}
    #plot_cfr_timeseries(df,start,end,ylabel=L["ylabel"][[1]])
}

results = mclapply(L, fx, mc.cores=numCores)
df = results[[1]]
