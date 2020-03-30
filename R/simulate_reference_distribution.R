# Simulating an outbreak, like the supplement of Reich.
simulate_reference_distribution <- function(country2table,T=67,abs_cfr=1/100) {
  #abs_cfr = 1/100 # Assume a 1% CFR
  #T = 67
  psi = rep(9/10,T) # Probability fatal case is reported
  phi = rep(2/10,T) # Probability recovered case is reported
  S = 1000000
  I = 1
  R = 0
  
  beta = 0.15 # Secondary attack rate from https://www.medrxiv.org/content/10.1101/2020.03.03.20028423v3.full.pdf+html
  beta = beta/S*10 # Normalized by population, with assumed 8 unique contacts per day
  gamma = 1/14 # Clearing interval
  
  sir_step <- function(S,I,R,beta,gamma) {
    Sn = (-beta*S*I)+S
    In = (beta*S*I)-(gamma*I)+I
    Rn = (gamma*I)+R
    c(Sn,In,Rn)
  }
  
  arrN = rep(0,T)
  arrD = rep(0,T)
  arrR = rep(0,T)
  
  for (t in 1:T) {
    if(country2table[t,"confirmed"] < 3){
      next
    }
    # Take model step
    SIR = sir_step(S,I,R,beta,gamma)
    dS = SIR[1]-S
    dI = SIR[2]-I
    dR = SIR[3]-R
    
    # Observations
    arrD[t] = rbinom(1,rbinom(1, floor(dR),abs_cfr),psi[t])
    arrR[t] = rbinom(1,rbinom(1,floor(dR),1.0-abs_cfr),phi[t])
    arrN[t] = arrD[t] + arrR[t]
    
    S = SIR[1]
    I = SIR[2]
    R = SIR[3]
  }
  # Borrow format from country 2
  result = country2table
  result[,"Country.Region"] = 1
  result[,"deaths"] = arrD
  result[,"recovered"] = arrR
  result[,"confirmed"] = arrN
  result
}