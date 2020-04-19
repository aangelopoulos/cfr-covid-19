rm(list = ls())
source("./generate_cfr_plot.r")
library("parallel")

start = 84
end = 86
maxiters=1000
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
    print(c1)
    generate_cfr_plot(c1,c2,start=start,end=end,maxiters=maxiters)
}

results = mclapply(L, fx, mc.cores=numCores)

#generate_cfr_plot("Korea, South","France",start=start,end=end,maxiters=maxiters)
#generate_cfr_plot("Korea, South","Austria",start=start,end=end,maxiters=maxiters)
#generate_cfr_plot("Korea, South","Spain",start=start,end=end,maxiters=maxiters)
#generate_cfr_plot("Germany","Switzerland",start=start,end=end,maxiters=maxiters)
#generate_cfr_plot("Germany","Iran",start=start,end=end,maxiters=maxiters)
#generate_cfr_plot("Italy","United Kingdom",start=start,end=end,maxiters=maxiters)
