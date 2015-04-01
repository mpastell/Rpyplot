
# Rpyplot

R interface to matplotlib via Rcpp using Python 2.7 or 3.

Contains basic working interface to some basic with few options. Tested with Ubuntu 14.10 (System Python 2.7, 3.4) and Windows 7 (Anaconda Python 2.7, 3.4). 

## Install

Install using devtools

```R
library(devtools)
install_github("mpastell/Rpyplot")
```

You'll need to have Python with headers (python-dev in Ubuntu) and matplotlib installed and in your path. In Windows you'll need to have Rtools.

## Use

To get started see:

```R
library(Rpyplot)
example(pyplot)
```