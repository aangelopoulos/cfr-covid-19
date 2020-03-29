reindex_time <- function(data,L) {
  total_time = dim(data)[1]/2
  rownames(data) <- 1:(2*total_time)
  N.1 = unname(data[1:total_time, "N"])
  N.2 = unname(data[(total_time+1):(total_time*2), "N"])
  first.t = min(which(N.1 > min.cases & N.2 > min.cases))
  last.t = max(which(N.1 > min.cases & N.2 > min.cases))
  ## You have to ensure the number of data points is high enough to support the tail
  #first.t = max(first.t,L) # Not putting this results in errors.
  T = last.t-first.t+1
  
  idx.for.Estep = first.t:last.t
  new.times = 1:length(idx.for.Estep)
  data = cbind(data, new.times = NA)
  data[first.t:last.t, "new.times"] <- 1:T
  data[(first.t+total_time):(last.t+total_time),"new.times"] <- 1:T
  
  multi_return = list("data" = data, "T" = T)
}