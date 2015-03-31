#' Plot x vs y
#' 
#' Plot 2D line plots and scatter plots using pyplot.plot. You can interact with the plots using matplotlib tools
#' after calling pyshow() (=pyplot.show)  
#' 
#' @param x A Numeric vector
#' @param y A Numeric vector
#' @param args String of extra arguments that are passed to Python
#' @param show If TRUE the plot will open and block (calls pyplot.show)
#' @examples
#' x = seq(0, 2*pi, length=100)
#' pyplot(x, sin(x))
#' pyplot(x, cos(x), args="'r--', linewidth=3")
#' pyfigure()
#' pyplot(x, sin(x)^2)
#' xlabel("x")
#' ylabel("$sin(x)^2$")
#' pyshow()
pyplot <- function(x,y=NULL, args=NULL, show=FALSE){
  if (is.null(y))
  {
    numvec_to_python("x", x)
    cmd = "x"
  }
  else{
    numvec_to_python("x", x)
    numvec_to_python("y", y)
    cmd = "x,y"
  }
  
  if (!is.null(args))
  {
    cmd = paste(cmd, ",", args)
  }
  
  pyrun(paste("plt.plot(", cmd ,")"))
  
  if (show)
    pyshow()  
  
  #Brings up the window, but can't interact, needs event loop
  #pyrun("plt.show(block=False)") 
}

stem <- function(x,y=NULL, args=NULL, show=FALSE){
  if (is.null(y))
  {
    numvec_to_python("x", x)
    cmd = "x"
  }
  else{
    numvec_to_python("x", x)
    numvec_to_python("y", y)
    cmd = "x,y"
  }
  
  if (!is.null(args))
  {
    cmd = paste(cmd, ",", args)
  }
  
  pyrun(paste("plt.stem(", cmd ,")"))
  
  if (show)
    pyshow()  
}

errorbar <- function(x, y, xerr, yerr, args=NULL, show=FALSE)
{
  numvec_to_python("x", x)
  numvec_to_python("y", y)
  numvec_to_python("xerr", xerr)
  numvec_to_python("yerr", yerr)
  cmd = "x, y, xerr=xerr, yerr=yerr"
  if (!is.null(args))
    cmd = paste(cmd, ",", args)
  
  pyrun(paste("plt.errorbar(", cmd ,")"))
  
  if (show)
    pyshow()
}

# x <- 1:nrow(volcano)*.2
# y <- 1:ncol(volcano)*.5
# pycontourf(x, y, volcano)
pycontourf <- function(x, y, z, args=NULL, show=FALSE)
{
  numvec_to_python("x", x)
  numvec_to_python("y", y)
  numvec_to_python("z_size", c(nr, nc))
  
  #Array moved to Python as list and converted to 
  #NumPy array
  nr = nrow(z)
  nc = ncol(z)
  numvec_to_python("z", z)
  pyrun("import numpy as np")
  pyrun("zn = (np.reshape(z, z_size, order='F')).T")
  
  cmd = "x, y, zn"
  if (!is.null(args))
    cmd = paste(cmd, ",", args)
  
  pyrun(paste("plt.contourf(", cmd, ")"))
  pyrun("plt.colorbar()")
  
  
  if (show)
    pyshow()
}





pyshow <- function(){pyrun("plt.show()")}

pyfigure <- function(num=NULL){
  if (is.null(num))
  {
    cmd = "plt.figure()"
  }
  else{
    cmd = paste("plt.figure(", num, ")")
  }
  pyrun(cmd)
}

xlabel <- function(label){plot_cmd("xlabel", label)}
ylabel <- function(label){plot_cmd("ylabel", label)}
pytitle <- function(label){plot_cmd("title", label)}

plot_cmd <- function (cmd, param)
{
  pyrun(paste("plt.", cmd, "('", param, "')", sep=""))  
}
