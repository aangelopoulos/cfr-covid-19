rm(list = ls())
library("RcppCNPy")
#setwd(".")
source("./reich/CFR_estimation.R")

# Parameters
L = 20 # The length of the tail of the distribution of time to death. Was 20 for all experiments in our paper.
mus = 14:14 # The values you want to test for mean time to death.
x = 1:L 
coronadata = npyLoad("./numpy_data/mat.npy") # Import from the processed data


## The rest of this code essentially follows the vignette from coarseDataTools repository.
# I commented out my debug print statements but they remain in the code.

colnames(coronadata) <- c("time", "grp", "R", "D", "N")
T = dim(coronadata)[1]/2
rownames(coronadata) <- 1:(2*T)

# The minimum number of cases until outbreak is counted as having started.
min.cases <- 500
N.1 = coronadata[1:T, "N"]
N.2 = coronadata[(T+1):(T*2), "N"]
first.t = min(which(N.1 > min.cases & N.2 > min.cases))
last.t = max(which(N.1 > min.cases & N.2 > min.cases))
## You have to ensure the number of data points is high enough to support the tail; it doesn't fix the ends!
first.t = max(first.t,L)
T = last.t-first.t+1
cfr_series = matrix(0L, nrow=L, ncol=T)
#print(sum(coronadata[1:length(N.1),"D"])/sum(N.1))
#print(sum(coronadata[1:length(N.1),"D"])/sum(coronadata[1:length(N.1),"D"]+coronadata[1:length(N.1),"R"]))
for(mu in mus)
{
  coronadata = npyLoad("./numpy_data/mat.npy")
  colnames(coronadata) <- c("time", "grp", "R", "D", "N")
  T = dim(coronadata)[1]/2
  rownames(coronadata) <- 1:(2*T)
  min.cases <- 500
  assumed.nu=pnorm(x,mean=mu,sd=1.0)
  assumed.nu = assumed.nu/sum(assumed.nu)
  #print(assumed.nu)
  N.1 = coronadata[1:T, "N"]
  N.2 = coronadata[(T+1):(T*2), "N"]
  first.t = min(which(N.1 > min.cases & N.2 > min.cases))
  last.t = max(which(N.1 > min.cases & N.2 > min.cases))
  ## You have to ensure the number of data points is high enough to support the tail; it doesn't fix the ends!
  first.t = max(first.t,length(assumed.nu))
  T = last.t-first.t+1
  idx.for.Estep = first.t:last.t
  new.times = 1:length(idx.for.Estep)
  coronadata = cbind(coronadata, new.times = NA)
  coronadata[c(idx.for.Estep, idx.for.Estep + T), "new.times"] <- rep(new.times, + 2)
  
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
  M.1 = unname(N.1[first.t:(first.t+T-1)])
  M.2 = unname(N.2[first.t:(first.t+T-1)])
  get_d <- function(theta,t,j,Nj) {
    x <- theta[1]
    if(j == 2) {
      x <- x + theta[length(theta)]
    }
    if(t >= 2) {
      x <- x + theta[t]
    }
    return(Nj[t] * exp(x))
  }
  
  TIMESTEP = 1:T
  cfr_ave <- (get_d(theta,TIMESTEP,2,M.2) + get_d(theta,TIMESTEP,1,M.1))/(M.2[TIMESTEP]+M.1[TIMESTEP])
  #message(sprintf("Converged: %1.0f | CFR: %f",cfr.out["EMconv"],cfr_ave[length(cfr_ave)]))
  cfr_series[mu,TIMESTEP] = cfr_ave
}
print(cfr_series)
