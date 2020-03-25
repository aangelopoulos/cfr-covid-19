library(coarseDataTools)
library("RcppCNPy")
set.seed(1337)
data(simulated.outbreak.deaths)
min.cases <- 10
N.1 <- simulated.outbreak.deaths[1:60, "N"]
N.2 <- simulated.outbreak.deaths[61:120, "N"]
first.t <- min(which(N.1 > min.cases & N.2 > min.cases))
last.t <- max(which(N.1 > min.cases & N.2 > min.cases))
T = last.t-first.t+1
idx.for.Estep <- first.t:last.t
new.times <- 1:length(idx.for.Estep)
simulated.outbreak.deaths <- cbind(simulated.outbreak.deaths, new.times = NA)
simulated.outbreak.deaths[c(idx.for.Estep, idx.for.Estep + 60), "new.times"] <- rep(new.times, + 2)
assumed.nu = c(0, 0.3, 0.4, 0.3)
alpha.start <- rep(0, 22)
## caution! this next line may take several minutes (5-10, depanding on
## the speed of your machine) to run.
cfr.out <- EMforCFR(assumed.nu = assumed.nu,
                    alpha.start.values = alpha.start,
                    full.data = simulated.outbreak.deaths,
                    verb = FALSE,
                    SEM.var = TRUE,
                    max.iter = 500,
                    tol = 1e-05)
print(cfr.out$naive.rel.cfr)
print(cfr.out$glm.rel.cfr)
print(cfr.out$EM.rel.cfr)
print(cfr.out$EM.rel.cfr.var.SEM)
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

y <- get_d(theta,10,1,M.1)

cfr1 <- (get_d(theta,10,1,M.1))/(M.1[10])
cfr2 <- (get_d(theta,10,2,M.2))/(M.2[10])
print(cfr2/cfr1)
cfr <- (get_d(theta,10,2,M.2) + get_d(theta,10,1,M.1))/(M.2[10]+M.1[10])