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

RUN apt-get update && apt-get install -y -qq r-cran-askpass
RUN apt-get update && apt-get install -y -qq r-cran-assertthat
RUN apt-get update && apt-get install -y -qq r-cran-backports
RUN apt-get update && apt-get install -y -qq r-cran-base64enc 
RUN apt-get update && apt-get install -y -qq r-cran-bh 
RUN apt-get update && apt-get install -y -qq r-cran-bitops 
RUN apt-get update && apt-get install -y -qq r-cran-callr 
RUN apt-get update && apt-get install -y -qq r-cran-cli 
RUN apt-get update && apt-get install -y -qq r-cran-coda 
RUN apt-get update && apt-get install -y -qq r-cran-colorspace 
RUN apt-get update && apt-get install -y -qq r-cran-crayon 
RUN apt-get update && apt-get install -y -qq r-cran-desc 
RUN apt-get update && apt-get install -y -qq r-cran-digest 
RUN apt-get update && apt-get install -y -qq r-cran-dplyr 
RUN apt-get update && apt-get install -y -qq r-cran-ellipsis 
RUN apt-get update && apt-get install -y -qq r-cran-evaluate 
RUN apt-get update && apt-get install -y -qq r-cran-fansi 
RUN apt-get update && apt-get install -y -qq r-cran-farver 
RUN apt-get update && apt-get install -y -qq r-cran-forcats 
RUN apt-get update && apt-get install -y -qq r-cran-gdtools 
RUN apt-get update && apt-get install -y -qq r-cran-ggplot2 
RUN apt-get update && apt-get install -y -qq r-cran-glue 
RUN apt-get update && apt-get install -y -qq r-cran-gtable 
RUN apt-get update && apt-get install -y -qq r-cran-highr 
RUN apt-get update && apt-get install -y -qq r-cran-htmltools 
RUN apt-get update && apt-get install -y -qq r-cran-isoband 
RUN apt-get update && apt-get install -y -qq r-cran-jsonlite 
RUN apt-get update && apt-get install -y -qq r-cran-knitr 
RUN apt-get update && apt-get install -y -qq r-cran-labeling 
RUN apt-get update && apt-get install -y -qq r-cran-lattice 
RUN apt-get update && apt-get install -y -qq r-cran-lifecycle 
RUN apt-get update && apt-get install -y -qq r-cran-lubridate 
RUN apt-get update && apt-get install -y -qq r-cran-magrittr 
RUN apt-get update && apt-get install -y -qq r-cran-markdown 
RUN apt-get update && apt-get install -y -qq r-cran-matrixmodels 
RUN apt-get update && apt-get install -y -qq r-cran-mime 
RUN apt-get update && apt-get install -y -qq r-cran-munsell 
RUN apt-get update && apt-get install -y -qq r-cran-packrat 
RUN apt-get update && apt-get install -y -qq r-cran-pillar 
RUN apt-get update && apt-get install -y -qq r-cran-pkgbuild 
RUN apt-get update && apt-get install -y -qq r-cran-pkgconfig 
RUN apt-get update && apt-get install -y -qq r-cran-pkgload 
RUN apt-get update && apt-get install -y -qq r-cran-plogr 
RUN apt-get update && apt-get install -y -qq r-cran-praise 
RUN apt-get update && apt-get install -y -qq r-cran-prettyunits 
RUN apt-get update && apt-get install -y -qq r-cran-processx 
RUN apt-get update && apt-get install -y -qq r-cran-ps 
RUN apt-get update && apt-get install -y -qq r-cran-purrr 
RUN apt-get update && apt-get install -y -qq r-cran-quantreg 
RUN apt-get update && apt-get install -y -qq r-cran-r6 
RUN apt-get update && apt-get install -y -qq r-cran-rcolorbrewer 
RUN apt-get update && apt-get install -y -qq r-cran-rlang 
RUN apt-get update && apt-get install -y -qq r-cran-rmarkdown 
RUN apt-get update && apt-get install -y -qq r-cran-rprojroot 
RUN apt-get update && apt-get install -y -qq r-cran-rstudioapi 
RUN apt-get update && apt-get install -y -qq r-cran-scales 
RUN apt-get update && apt-get install -y -qq r-cran-sparsem 
RUN apt-get update && apt-get install -y -qq r-cran-stringi 
RUN apt-get update && apt-get install -y -qq r-cran-stringr 
RUN apt-get update && apt-get install -y -qq r-cran-svglite 
RUN apt-get update && apt-get install -y -qq r-cran-sys 
RUN apt-get update && apt-get install -y -qq r-cran-systemfonts 
RUN apt-get update && apt-get install -y -qq r-cran-testthat 
RUN apt-get update && apt-get install -y -qq r-cran-tibble 
RUN apt-get update && apt-get install -y -qq r-cran-tidyr 
RUN apt-get update && apt-get install -y -qq r-cran-tidyselect 
RUN apt-get update && apt-get install -y -qq r-cran-tinytex 
RUN apt-get update && apt-get install -y -qq r-cran-utf8 
RUN apt-get update && apt-get install -y -qq r-cran-vctrs 
RUN apt-get update && apt-get install -y -qq r-cran-viridislite 
RUN apt-get update && apt-get install -y -qq r-cran-withr 
RUN apt-get update && apt-get install -y -qq r-cran-xfun 
RUN apt-get update && apt-get install -y -qq r-cran-yaml 

COPY . .
ENTRYPOINT ["Rscript","./cdt_real.r"]
