#' Plot x vs y using pyplot.plot
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
#' if(interactive())
#'    pyshow()
#' @export
pyplot <- function(x, y, args, show=FALSE){
  if (missing(y))
  {
    plotvar("x", x)
    cmd = "_pvars['x']"
  }
  else{
    plotvar("x", x)
    plotvar("y", y)
    cmd = "_pvars['x'],_pvars['y']"
  }
  
  if (!missing(args))
  {
    cmd = paste(cmd, ",", args)
  }
  
  pyrun(paste("plt.plot(", cmd ,")"))
  pyrun("del(_pvars)")
  
  if (show)
    pyshow()  
  
  #Brings up the window, but can't interact, needs event loop
  #pyrun("plt.show(block=False)") 
}

#' Plot stem plot using pyplot
#' 
#' @inheritParams pyplot
#' @examples
#' x = seq(0, pi, length=20)
#' pystem(x, sin(x))
#' if(interactive())
#'    pyshow()
#' @export
pystem <- function(x,y=NULL, args=NULL, show=FALSE){
  if (missing(y))
  {
    plotvar("x", x)
    cmd = "_pvars['x']"
  }
  else{
    plotvar("x", x)
    plotvar("y", y)
    cmd = "_pvars['x'],_pvars['y']"
  }
  
  if (!missing(args))
  {
    cmd = paste(cmd, ",", args)
  }
  
  
  pyrun(paste("plt.stem(", cmd ,")"))
  pyrun("del(_pvars)")
  
  if (show)
    pyshow()  
}

#' Plot error bars using pyplot
#' 
#' @param xerr A numeric vector of x errors at each data point
#' @param yerr A numeric vector of y errors at each data point
#' @inheritParams pyplot
#' @examples
#' x = seq(0, 2*pi, length=50)
#' xerr = rep(0.05, length(x)) #absolute error
#' yerr = sin(x)*0.1 #relative error
#' pyerrorbar(x, sin(x), xerr, yerr, args=" fmt='o', ecolor='red' ")
#' if (interactive())
#'    pyshow()
#' @export
pyerrorbar <- function(x, y, xerr, yerr, args=NULL, show=FALSE)
{
  #Copy data to _pvars dictionary
  plotvar("x", x) 
  plotvar("y", y)
  plotvar("xerr", xerr)
  plotvar("yerr", yerr)
  
  cmd = "_pvars['x'], _pvars['y'], xerr=_pvars['xerr'], yerr=_pvars['yerr']"
  if (!is.null(args))
    cmd = paste(cmd, ",", args)
  
  pyrun(paste("plt.errorbar(", cmd ,")"))
  pyrun("del(_pvars)")
   
  if (show)
    pyshow()
}


#' Filled contour using pyplot
#' 
#' @param z array of z-axis coordinates
#' @inheritParams pyplot
#' @examples
#' x <- 1:ncol(volcano)*.2
#' y <- 1:nrow(volcano)*.5
#' pycontourf(x, y, volcano)
#' if (interactive())
#'    pyshow()
#' @export
pycontourf <- function(x, y, z, args, show=FALSE)
{
  plotvar("x", x)
  plotvar("y", y)
  pyvar("__zplot", z) #No method to move matrices to _pvars defined yet
 
  cmd = "_pvars['x'], _pvars['y'], __zplot"
  if (!missing(args))
    cmd = paste(cmd, ",", args)
  
  pyrun(paste("plt.contourf(", cmd, ")"))
  pyrun("plt.colorbar()")
  pyrun("del(_pvars)")
  pyrun("del(__zplot)")
  
  if (show)
    pyshow()
}

#' Show figures
#' Run pyplot.show(). This will open all created figure windows and hang R before all windows are closed.
#' @export
pyshow <- function(){pyrun("plt.show()")}


#' Create new figure
#' 
#' calls pyplot.figure().
#' 
#' @param num figure number
#' 
#' @export
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

#' Add x-axis label
#' 
#' @param label Axis label as text
#' 
#' @export
xlabel <- function(label){plot_cmd("xlabel", label)}


#' Add y-axis label
#' 
#' @param label Axis label as text
#' 
#' @export
ylabel <- function(label){plot_cmd("ylabel", label)}

#' Add plot title
#' 
#' @param title plot title as text
#' 
#' @export
pytitle <- function(title){plot_cmd("title", title)}

plot_cmd <- function (cmd, param)
{
  pyrun(paste("plt.", cmd, "('", param, "')", sep=""))  
}
