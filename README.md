
# Rpyplot

R interface to matplotlib via Rcpp using Python 2.7.

Contains basic working interface to some basic with few options. Tested with Ubuntu 14.10 (System Python) and Windows 7 (Anaconda Python). 

## Install

Install using devtools

```R
library(devtools)
install_github("mpastell/Rpyplot")
```

You'll need to have Python with headers (python-dev in Ubuntu) and matplotlib installed and in your path.

## Use

To get started see:

```R
library(Rpyplot)
example(pyplot)
```