rm(list = ls())
source("./generate_cfr_data.r")
source("./plot_cfr_timeseries.r")
library("parallel")

### PARAMETERS
# Start and end dates are defined in days since January 22 (the first data point).
# Feb 1 = 10 | Mar 1 = 38 | Apr 1 = 69 | May 1 = 99 
start = 82 
end = 102
# maxiters=n will make the EM procedure run for n iterations
maxiters=5000
# Setting realign=TRUE will realign the outbreaks in time so they overlap.
realign=TRUE 
#Setting sensitivity=TRUE will report sensitivity to the distribution of deaths in time among fatal cases.
# Setting sensitivity = TRUE will make the code much slower, so it shouldn't be used unless this info is needed. 
sensitivity=FALSE  

L = list(
         list(COUNTRY1="Germany", COUNTRY2="Switzerland", ylabel="CFR of CHE/DEU"),
         list(COUNTRY1="Korea, South",COUNTRY2="Spain",ylabel="CFR of ESP/KOR"),
         list(COUNTRY1="Korea, South",COUNTRY2="Austria",ylabel="CFR of AUT/KOR"),
         list(COUNTRY1="Italy",COUNTRY2="United Kingdom",ylabel="CFR of GBR/ITA"),
         list(COUNTRY1="Germany",COUNTRY2="Switzerland",ylabel="CFR of CHE/DEU"),
         list(COUNTRY1="Germany",COUNTRY2="Iran",ylabel="CFR of IRN/DEU"),
         list(COUNTRY1="Belgium",COUNTRY2="Iran",ylabel="CFR of IRN/BEL")
        )

### BODY
args = commandArgs(trailingOnly=TRUE)

numCores = detectCores()
print(numCores)

fx <- function(L) {
    c1=L["COUNTRY1"][[1]]
    c2=L["COUNTRY2"][[1]]
    df = NA
    if((length(args)==1) & (args[1] == "-newdata")) {
        df = generate_cfr_data(c1,c2,start=start,end=end,maxiters=maxiters,realign=realign, sensitivity=sensitivity)
    } else {
        df = read.csv(file=paste0("./plots/",c1,c2,".csv"),header=TRUE)
    }
    plot_cfr_timeseries(df,start,end,ylabel=L["ylabel"][[1]])
}

results = mclapply(L, fx, mc.cores=numCores)
