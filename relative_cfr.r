rm(list = ls())
library("RcppCNPy")
setwd("/home/aa/Code/Berkeley/corona")
source("./R_reich/CFR_estimation.R")

# Parameters 
DESIRED_L = 20 # Length of the tail of the death distribution, in days. For all results paper, this was 20.
MTTD = 14 # Mean Time To Death
COUNTRY1 = "China"
COUNTRY2 = "Iran"
FILE = paste("./numpy_data/",COUNTRY1,"_",COUNTRY2,".npy",sep="") # The relative CFR will be calculated as (CFR2)/(CFR1)
print(paste("CFR of",COUNTRY2,"relative to",COUNTRY1))

# As before a lot of this code is taken from the vignette in coarseDataTools

coronadata = npyLoad(FILE)
colnames(coronadata) <- c("time", "grp", "R", "D", "N")
# Sometimes if the glm breaks, it can help to remove rows of all 0.
# coronadata=rbind(coronadata[0:49,],coronadata[51:104,],coronadata[106:110,],coronadata[111:122,])
total_time = dim(coronadata)[1]/2
rownames(coronadata) <- 1:(2*total_time)
min.cases <- 100
N.1 = unname(coronadata[1:total_time, "N"])
N.2 = unname(coronadata[(total_time+1):(total_time*2), "N"])
first.t = min(which(N.1 > min.cases & N.2 > min.cases))
last.t = max(which(N.1 > min.cases & N.2 > min.cases))
## You have to ensure the number of data points is high enough to support the tail
first.t = max(first.t,DESIRED_L)
T = last.t-first.t+1

L = min(DESIRED_L,T)
x = 1:L
assumed.nu=pnorm(x,mean=MTTD,sd=1.0)
assumed.nu = assumed.nu/sum(assumed.nu)
#print(assumed.nu)

idx.for.Estep = first.t:last.t
new.times = 1:length(idx.for.Estep)
coronadata = cbind(coronadata, new.times = NA)
coronadata[first.t:last.t, "new.times"] <- 1:T
coronadata[(first.t+total_time):(last.t+total_time),"new.times"] <- 1:T

alpha.start <- rep(0, T-1)
## caution! this next line may take several minutes (5-10, depanding on
## the speed of your machine) to run.
cfr.out <- EMforCFR(assumed.nu = assumed.nu,
                  alpha.start.values = alpha.start,
                  full.data = coronadata,
                  verb = FALSE,
                  SEM.var = TRUE,
                  max.iter = 1000,
                  tol = 1e-04)
theta <- cfr.out["ests"][[1]]


D.1 = unname(coronadata[1:total_time, "D"])
D.2 = unname(coronadata[(total_time+1):(total_time*2), "D"])
R.1 = unname(coronadata[1:total_time, "R"])
R.2 = unname(coronadata[(total_time+1):(total_time*2), "R"])

print(cfr.out["EM.rel.cfr"])
