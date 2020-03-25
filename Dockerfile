FROM rocker/r-apt:bionic
#The next block determines what dependencies to load
RUN R -e 'options(Ncpus = 1)'
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
COPY . .
ENTRYPOINT ["Rscript","./cdt_real.r"]
