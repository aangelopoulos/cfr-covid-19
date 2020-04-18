FROM rocker/r-apt:bionic
#The next block determines what dependencies to load
RUN R -e 'options(Ncpus = 1)'
RUN R -e 'options(Ncpus = 12)'
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y -qq r-cran-coarsedatatools
RUN apt-get update && apt-get install -y -qq r-cran-coda
RUN apt-get update && apt-get install -y -qq r-cran-lattice
RUN apt-get update && apt-get install -y -qq r-cran-mcmc
RUN apt-get update && apt-get install -y -qq r-cran-mcmcpack
RUN apt-get update && apt-get install -y -qq r-cran-quantreg
RUN apt-get update && apt-get install -y -qq r-cran-rcpp
RUN apt-get update && apt-get install -y -qq r-cran-sparsem
RUN R -e 'install.packages(c("RcppCNPy"))'

RUN apt-get update && apt-get install -y -qq r-cran-askpass,assertthat,backports,base64enc,bh,bitops,callr,cli,coda,colorspace,crayon,desc,digest,dplyr,ellipsis,evaluate,fansi,farver,forcats,gdtools,ggplot2,glue,gtable,highr,htmltools,isoband,jsonlite,knitr,labeling,lattice,lifecycle,lubridate,magrittr,markdown,matrixmodels,mime,munsell,packrat,pillar,pkgbuild,pkgconfig,pkgload,plogr,praise,prettyunits,processx,ps,purrr,quantreg,r6,rcolorbrewer,rlang,rmarkdown,rprojroot,rstudioapi,scales,sparsem,stringi,stringr,svglite,sys,systemfonts,testthat,tibble,tidyr,tidyselect,tinytex,utf8,vctrs,viridislite,withr,xfun,yaml,base,boot,class,cluster,codetools,compiler,datsets,foreign,graphics,grdevices,grid,kernsmooth,lattice,mass,matrix,methods,mgcv,nlme,nnet,parallel,rpart,spatial,splines,stats,stats4,survival,tcltk,tools,utils

COPY . .
ENTRYPOINT ["Rscript","./cdt_real.r"]
