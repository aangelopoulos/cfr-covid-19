rm(list = ls())
library("dplyr")
library("RcppCNPy")
source("./reich/CFR_estimation.R")
source("./R/jh_process.R")
source("./R/generate_coronamat.R")
source("./reindex_time.R")
# Parameters 
DESIRED_L = 20 # Length of the tail of the death distribution, in days. For all results paper, this was 20.
MTTD = 14 # Mean Time To Death
COUNTRY1 = "China"
COUNTRY2 = "Iran"
set.seed(0) #For reproducibility. Can be changed without affecting anything.
min.cases <- 100
# Changing the distribution of deaths can have a large effect especially in the low data regime.
assumed.nu=pnorm(1:DESIRED_L,mean=MTTD,sd=8.0)
#assumed.nu = c(rep(0,4),rep(1,14),rep(0,2))
assumed.nu = assumed.nu/sum(assumed.nu)
#print(assumed.nu)

data = generate_coronamat(COUNTRY1,COUNTRY2,DESIRED_L+2)

# This code fixes some errors in the JHU dataset (negative entries, all-zero rows).
data = reindex_time(data,DESIRED_L)["data"][[1]]
data = data[ ((data[,"N"] > 0) | is.na(data[,"new.times"])) & (data[,"D"]>=0),  ]
data = data[,-6]
out_list = reindex_time(data,DESIRED_L)
data = out_list["data"][[1]]
T = out_list["T"][[1]]
total_time = dim(data)[1]/2

alpha.start <- runif(T-1)
## caution! this next line may take several minutes (5-10, depanding on
## the speed of your machine) to run.
cfr.out <- EMforCFR(assumed.nu = assumed.nu,
                  alpha.start.values = alpha.start,
                  full.data = data,
                  verb = FALSE,
                  SEM.var = TRUE,
                  max.iter = 2000,
                  tol = 1e-04)
theta <- cfr.out["ests"][[1]]


D.1 = unname(data[1:total_time, "D"])
D.2 = unname(data[(total_time+1):(total_time*2), "D"])
R.1 = unname(data[1:total_time, "R"])
R.2 = unname(data[(total_time+1):(total_time*2), "R"])

print(cfr.out["EMconv"])
print(cfr.out["EM.rel.cfr"])
