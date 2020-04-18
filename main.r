rm(list = ls())
source("./generate_cfr_plot.r")

start = 35
end = 86
maxiters=1000

generate_cfr_plot("Korea, South","France",start=start,end=end,maxiters=maxiters)
generate_cfr_plot("Korea, South","Austria",start=start,end=end,maxiters=maxiters)
generate_cfr_plot("Korea, South","Spain",start=start,end=end,maxiters=maxiters)
generate_cfr_plot("Germany","Switzerland",start=start,end=end,maxiters=maxiters)
generate_cfr_plot("Germany","Iran",start=start,end=end,maxiters=maxiters)
generate_cfr_plot("Italy","United Kingdom",start=start,end=end,maxiters=maxiters)