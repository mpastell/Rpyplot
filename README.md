
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
example(pystep)
example(pycontourf)
```

## Why?

I often use Python and [matplotlib](http://matplotlib.org/) for exploring measurement data (from e.g. accelerometers), even if I use R for the actual analysis. The reason is that I like to be able to flexibly zoom into different parts of the plot using the mouse and this works well for me with matplotlib. So I decided to try to call matplotlib from R using Rcpp and [Python/C API](https://docs.python.org/2/c-api/). It was surprisingly simple to get it working so I put together this package.