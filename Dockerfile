
# Base image
FROM ubuntu:16.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    xsltproc \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion 

# Get R commit r74931
RUN svn co -r74931 https://svn.r-project.org/R/trunk/ R
# Building R from source
RUN apt-get update && apt-get install -y r-base-dev texlive-full libcairo2-dev
RUN cd R; ./configure --with-x=no --without-recommended-packages 
RUN cd R; make
RUN cd R; make install

# For building the report
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.1.1", repos="https://cran.rstudio.com/")'
RUN apt-get install -y imagemagick

# Packages used in the report
RUN Rscript -e 'library(devtools); install_version("gridBase", "0.4-7", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gridExtra", "2.3", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gtable", "0.2.0", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_github("wilkelab/cowplot@17322673e5d1e9d537437034aa806a6b5bd802b5")'

# The main report package(s)
RUN Rscript -e 'library(devtools); install_github("pmur002/gridGraphics@v0.4-0")'


