collapse_two_columns <- function(df,col1,col2) {
  new_df = df[FALSE,]
  uq1 = unique(df[,col1])
  uq2 = unique(df[,col2])
  for(i in uq1) {
    for(j in uq2) {
      sc = sum(df[(df[,col1]==i)&(df[,col2]==j),"Cases"])
      sd = sum(df[(df[,col1]==i)&(df[,col2]==j),"Deaths"])
      newrow = df[1,]
      newrow[col1]=i
      newrow[col2]=j
      newrow["Cases"] = sc
      newrow["Deaths"] = sd
      new_df = rbind(new_df,newrow)
    }
  }
  return(new_df)
}