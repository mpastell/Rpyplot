
# Rpyplot

R interface to matplotlib via Rcpp using Python 2.7 or 3.

Contains basic working interface to some basic with few options. Tested with Ubuntu 14.10 (System Python 2.7, 3.4) and Windows 7 (Anaconda Python 2.7, 3.4). 

## Why?

I often use Python and [matplotlib](http://matplotlib.org/) for exploring measurement data (from e.g. accelerometers), even if I use R for the actual analysis. The reason is that I like to be able to flexibly zoom into different parts of the plot using the mouse and this works well for me with matplotlib. So I decided to try to call matplotlib from R using Rcpp and [Python/C API](https://docs.python.org/2/c-api/). It was surprisingly simple to get it working so I put together this package.

## Install

Install using devtools.

**Ubuntu**

You'll need to have Python with headers (python-dev in Ubuntu) and matplotlib:


```bash
sudo apt-get install python-dev python-matplotlib

```

Use devtools to install from R.


```R
library(devtools)
install_github("mpastell/Rpyplot")
```

**Windows**

You'll need to have Rtools and Python with matplotlib installed and in your path. You'll also need to have libpythonXX.a in "$PYTHON\libs\".  You can use [libpython](http://www.lfd.uci.edu/~gohlke/pythonlibs/#libpython) from Christoph Gohlke's repository. Make sure you use the same architecture for R and Python.


Install libpython using pip (the version needs to match the install Python version, the url below is for Python3.4)

```
pip install wheel
pip install http://www.lfd.uci.edu/~gohlke/pythonlibs/6icuform/libpython-3.4.3-cp34-none-win_amd64.whl

```

```R
library(devtools)
install_github("mpastell/Rpyplot", args = "--no-multiarch")
```


## Use

To get started see:

```R
library(Rpyplot)
example(pyplot)
example(pystep)
example(pycontourf)
```

## Development 

I developed the package to do quick interactive analysis and its not meant to interface all of pyplot. I will add more features to the package when I need them. If you want add functionality please do so and submit a pull request. You can add new plots and options easily in R (see `R/Plot.R`) without using C++. I have written a post to [Rcpp gallery](http://gallery.rcpp.org/articles/matplotlib-from-R/) that tries to explain the C++ side of the code.