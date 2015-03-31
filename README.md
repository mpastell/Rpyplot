
# Rpyplot

R interface to matplotlib via Rcpp using Python 2.7.

Contains basic working interface to some basic with few options. Tested with Ubuntu 14.10 (System Python) and Windows 7 (Anaconda Python). 

## Install

Install using devtools

```R
library(devtools)
install_github("mpastell/Rpyplot")
```

If that doesn't work you can adjust `src/Makevars` or `src/Makevars.win` to match your Python installation.

## Use

To get started see:

```R
library(Rpyplot)
example(pyplot)
```