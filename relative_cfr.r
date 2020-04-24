# If you want the program to try and continue past my asserts, set ASSERT_STOP to FALSE as a global variable in main.r
# Note with DESIRED_L: 
#DESIRED_L = Length of the tail of the death distribution, in days. If DESIRED_L is greater than the length of the outbreak (starting at the first index with min.cases), then you will get an error.
#MTTD = Mean Time To Death
#STD = Standard deviation of distribution
relative_cfr <- function(COUNTRY1,COUNTRY2, enddate=NA, min.cases=40, realign=TRUE, DESIRED_L=25, MTTD=15, STD=6.9, MAXITERS=10000) {
  library("dplyr")
  library("RcppCNPy")
  source("./reich/CFR_estimation.R")
  source("./R/jh_process.R")
  source("./R/generate_coronamat.R")
  source("./R/reindex_time.R")
  source("./R/myassert.R")
  
  set.seed(0) #For reproducibility. Can be changed without affecting anything.
  # Changing the distribution of deaths can have a large effect especially in the low data regime.
  assumed.nu=dgamma(1:DESIRED_L, shape=MTTD^2/STD^2, scale=STD^2/MTTD)
  assumed.nu[assumed.nu<=0.01]=0
  assumed.nu = assumed.nu/sum(assumed.nu)
  
  assert("ERROR: The assumed distribution of deaths in time contains all zeros. Make sure the MTTD is within the range 1:DESIRED_L.",!any(is.nan(assumed.nu)))
  
  data = generate_coronamat(COUNTRY1,COUNTRY2,DESIRED_L+2, min.cases=min.cases, enddate=enddate, realign=realign)

  #data [,"N"] = data[,"R"] + data[,"D"]  # Use this if you only want to consider recovered and deaths (not recommended)
  total_time = dim(data)[1]/2
  D.1 = unname(data[1:total_time, "D"])
  D.2 = unname(data[(total_time+1):(total_time*2), "D"])
  R.1 = unname(data[1:total_time, "R"])
  R.2 = unname(data[(total_time+1):(total_time*2), "R"])
  N.1 = unname(data[1:total_time, "N"])
  N.2 = unname(data[(total_time+1):(total_time*2), "N"])
  
  # This code fixes some errors in the JHU dataset (negative entries, all-zero rows).
  data = reindex_time(data,DESIRED_L,min.cases)["data"][[1]]
  #data = data[ ((data[,"N"] > 0) | is.na(data[,"new.times"])) & (data[,"D"]>=0),  ]
  data = data[ ((data[,"N"] > 0) | is.na(data[,"new.times"])),  ]
  data[data < 0] = 1
  data = data[,-6]
  out_list = reindex_time(data,DESIRED_L,min.cases)
  data = out_list["data"][[1]]
  T = out_list["T"][[1]]
  first.t = out_list["first.t"][[1]]
  last.t = out_list["last.t"][[1]]
  
  total_time = dim(data)[1]/2
 
  #data[1:total_time,"R"] = 10000000 # The time series of recoveries is never used in R_reich, and inserting this line of code has no effect.
  alpha.start <- 5*runif(T-1) # I have never found that this initialization matters.
  ## caution! this next line may take several minutes (5-10, depanding on
  ## the speed of your machine) to run.
  cfr.out=NA
  tryCatch(
    {
      cfr.out <- EMforCFR(assumed.nu = assumed.nu,
                          alpha.start.values = alpha.start,
                          full.data = data,
                          verb = FALSE,
                          SEM.var = TRUE,
                          max.iter = MAXITERS,
                          tol = 1e-04)
      theta <- cfr.out["ests"][[1]]
    },
    error = function(cond)
    {
      print(cond)
      cfr.out = NA
    }
  )
  
  nc1 = sum(D.1)/sum(N.1)
  nc2 = sum(D.2)/sum(N.2)
  oc1 = sum(D.1)/(sum(D.1)+sum(R.1))
  oc2 = sum(D.2)/(sum(D.2)+sum(R.2))
  naive = round(nc2/nc1,2)
  observed = round(oc2/oc1,2)
  reich = round(cfr.out["EM.rel.cfr"][[1]],2)
  print(paste("CFR of",COUNTRY2,"compared to",COUNTRY1,"| Naive:", naive,"Observed:", observed,"Reich:",reich))
    
  multireturn = list("naive"=naive,"obs"=observed,"reich"=reich,"enddate"=enddate)
}
