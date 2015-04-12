#' Plot lines or markersusing pyplot.plot
#'
#' Plot 2D line plots and scatter plots using matplotlib.pyplot.plot. You can interact with the plots using matplotlib tools
#' after calling pyshow() (=pyplot.show)   
#' 
#' @param x numeric vector containing the x coordinates of points
#' @param y numeric vector containing the y coordinates of points
#' @param color color of the points (default: \code{"b"}), can be one of
#'   \itemize{
#'     \item{single character for basic built-in matplotlib colors, see
#'       \url{http://matplotlib.org/api/colors_api.html#module-matplotlib.colors
#'       }
#'     }
#'     \item{a numeric value between 0 and 1 as character, indicating gray
#'       shade, e.g. \code{"0.75"}}
#'     \item{hex string, e.g. \code{"#00ff00"} for green}
#'     \item{numeric vector of length three, for RGB (red, green and blue, each
#'       between 0 and 1)}
#'     \item{numeric vector of length four, for RGBA (red, green, blue and
#'       opacity, each between 0 and 1)}
#'     \item{character string with HTML color name, e.g. \code{"slateblue"},
#'       see \url{http://www.w3schools.com/html/html_colornames.asp}}
#'   }
#' @param marker single character indicating shape of the points (default:
#'   \code{"o"}), see
#'   \url{http://matplotlib.org/api/markers_api.html#module-matplotlib.markers}
#' @param alpha numeric indicating transparency (0-1, default: 1)
#' @param linewidth numeric of either length 1 or \code{length(x)} indicating
#'   the border width of the points (default: 1)
#' @param linestyle style of the plotted line. See: \url{http://matplotlib.org/api/lines_api.html#matplotlib.lines.Line2D.set_linestyle}   
#' @param args character string of further arguments passed to the **kwargs
#'   argument of matplotlib.pyplot.scatter
#' @param show bool indicating whether to open a window with the plot
#' @examples
#' x = seq(0, 2*pi, length=100)
#' pyplot(x, sin(x))
#' pyplot(x, cos(x), linewidth=3, color="red", linestyle="--")
#' pyfigure()
#' pyplot(x, sin(x)^2)
#' xlabel("x")
#' ylabel("$sin(x)^2$")
#' if(interactive())
#'    pyshow()
#' @seealso \link{pyscatter} 
#'   \url{http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.plot}
#' @export
pyplot <- function(x, y, color = "b", marker = "", alpha = 1,
                      linewidth = 1, linestyle="-", args = NULL, show = FALSE)
{
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
    

  # color can be either character (single character or #hex string) or tuple
  if (is.character(color))
  {
    color <- paste0("'", color, "'")
  } else
  {
    color <- paste0("(", paste(color, collapse = ","), ")")
  }
  
  # marker is character
  marker <- paste0("'", marker, "'")
  
  # linewidths can be either scalar, array_like or None
  if (length(linewidth) > 1)
  {
    plotvar("lwds", linewidth)
    linewidths <- "_pvars['lwds']"
  } 
  
  # alpha can be either scalar or None
  if (is.null(alpha)) alpha <- "None"
  
  # Further arguments
  args <- ifelse(!is.null(args), paste0(",", args), "")
  
  pyrun(paste0("plt.plot(", cmd, ", c = ", color,
               ", marker = ", marker, ", alpha = ", alpha, ", linewidth = ", linewidth,
               ",linestyle ='", linestyle, "',", args, ")"))
  pyrun("del(_pvars)")
  
  if (show) pyshow()
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

#' Plot a scatter plot using pyplot.scatter
#' 
#' Draw a scatter plot using matplotlib.pyplot.scatter
#' 
#' @param x numeric vector containing the x coordinates of points
#' @param y numeric vector containing the y coordinates of points
#' @param s numeric of either length 1 or \code{length(x)} indicating the size
#'   of each point
#' @param c color of the points (default: \code{"b"}), can be one of
#'   \itemize{
#'     \item{single character for basic built-in matplotlib colors, see
#'       \url{http://matplotlib.org/api/colors_api.html#module-matplotlib.colors
#'       }
#'     }
#'     \item{a numeric value between 0 and 1 as character, indicating gray
#'       shade, e.g. \code{"0.75"}}
#'     \item{hex string, e.g. \code{"#00ff00"} for green}
#'     \item{character string with HTML color name, e.g. \code{"slateblue"},
#'       see \url{http://www.w3schools.com/html/html_colornames.asp}}
#'     \item{a character vector of \code{length(x)} containing a color
#'       specification as described above for each point separately}
#'     \item{a numeric vector of \code{length(x)}, where each numeric is used
#'       to map the according point to a colormap using the \code{cmap},
#'       \code{norm}, \code{vmin} and \code{vmax} arguments}
#'     \item{a numeric matrix with \code{length(x)} rows and three columns. Each
#'       row represents one point in \code{x}/\code{y}, the rows set values for
#'       RGB (red, green and blue, each between 0 and 1)}
#'     \item{a numeric matrix with \code{length(x)} rows and four columns. Each
#'       row represents one point in \code{x}/\code{y}, the rows set values for
#'       RGBA (red, green, blue and alpha, each between 0 and 1)}
#'   }
#' @param marker single character indicating shape of the points (default:
#'   \code{"o"}), see
#'   \url{http://matplotlib.org/api/markers_api.html#module-matplotlib.markers}
#' @param cmap character string containing either the name of a matplotlib
#'   colormap (see 
#'   \url{http://matplotlib.org/examples/color/colormaps_reference.html}) or a
#'   string containing a Python call that returns an object of class Colormap,
#'   e.g. \code{"matplotlib.cm.get_cm('Reds')"} (default: \code{NULL}).
#' @param norm character string containing a Python call that returns an object
#'   of class Normalize, e.g. \code{"matplotlib.colors.Normalize(0, 20)"}
#'   (default: \code{NULL})
#' @param vmin numeric. If \code{c} is a numeric vector, \code{vmin} defines
#'   what value is mapped to the lower end of the colormap (default:
#'   \code{NULL}; is set to \code{max(c)} if \code{c} is numeric)
#' @param vmax numeric. If \code{c} is a numeric vector, \code{vmin} defines
#'   what value is mapped to the upper end of the colormap (default:
#'   \code{NULL}; is set to \code{max(c)} if \code{c} is numeric)
#' @param alpha numeric indicating transparency (0-1, default: 1)
#' @param linewidths numeric of either length 1 or \code{length(x)} indicating
#'   the border width of the points (default: 1)
#' @param args character string of further arguments passed to the **kwargs
#'   argument of matplotlib.pyplot.scatter
#' @param show bool indicating whether to open a window with the plot
#' @examples
#' pyscatter(runif(20), runif(20), s = runif(20, 50, 200),
#'           c = runif(20, 0, 100), cmap = "Blues", vmin = 0, vmax = 80)
#' 
#' if (interactive()) pyshow()
#' @seealso \link{pyplot} 
#'   \url{http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.scatter}
#' @export
pyscatter <- function(x, y, s = 20, c = "b", marker = "o", cmap = NULL,
                      norm = NULL, vmin = NULL, vmax = NULL, alpha = 1,
                      linewidths = NULL, args = NULL, show = FALSE)
{
  plotvar("x", x)
  plotvar("y", y)
  
  # s can be either scalar or array_like
  if (length(s) > 1)
  {
    plotvar("s", s)
    s <- "_pvars['s']"
  }
  
  # c can be either character (single character or #hex string), sequence of
  # character (single character or #hex strings) or 
  if (is.character(c) && length(c) == 1)
  {
    c <- paste0("'", c, "'")
  } else if (is.matrix(c))
  {
    pyvar("__cplot", c) # No method to move matrices to _pvars defined yet
    c <- "__cplot"
  } else
  {
    plotvar("c", c)
    c <- "_pvars['c']"
  }
  
  # marker is character
  marker <- paste0("'", marker, "'")
  
  # cmap is object of class matplotlib.colors.Colormap or None
  # Interface provides an option to pass a string containing the name of a
  # matplotlib colormap
  if (is.null(cmap))
  {
    cmap <- "None"
  } else if (!grepl("\\(.*\\)", cmap))
  {
    cmap <- paste0("matplotlib.cm.get_cmap('", cmap, "')")
  }
  
  # norm is either an object of class matplotlib.colors.Normalize or None
  if (is.null(norm)) norm <- "None"
  
  # vmin and vmax are either scalar or None
  if (is.null(vmin)) vmin <- "None"
  if (is.null(vmax)) vmax <- "None"
  
  # linewidths can be either scalar, array_like or None
  if (length(linewidths) > 1)
  {
    plotvar("lwds", linewidths)
    linewidths <- "_pvars['lwds']"
  } else if (is.null(linewidths))
  {
    linewidths <- "None"
  }
  
  # alpha can be either scalar or None
  if (is.null(alpha)) alpha <- "None"
  
  # Further arguments
  args <- ifelse(!is.null(args), paste0(",", args), "")
  
  pyrun(paste0("plt.scatter(_pvars['x'], _pvars['y'], s = ", s, ", c = ", c,
               ", marker = ", marker, ", cmap = ", cmap, ", norm = ", norm,
               ", vmin = ", vmin, ", vmax = ", vmax, ", alpha = ", alpha,
               ", linewidths = ", linewidths, args, ")"))
  
  pyrun("del(_pvars)")
  pyrun("if '__cplot' in locals(): del(__cplot)")
  
  if (show) pyshow()
}

#' Plot vertical lines using pyplot.vlines
#' 
#' @param x numeric or a numeric vector with x-values for vertical lines
#' @param ymin numeric or a numeric vector of \code{length(x)} indicating lower
#'   y-values of the lines
#' @param ymax numeric or a numeric vector of \code{length(x)} indicating upper
#'   y-values of the lines
#' @param colors color of the line(s) (default: \code{"k"}), can be one of
#'   \itemize{
#'     \item{single character for basic built-in matplotlib colors, see
#'       \url{http://matplotlib.org/api/colors_api.html#module-matplotlib.colors
#'       }
#'     }
#'     \item{a numeric value between 0 and 1 as character, indicating gray
#'       shade, e.g. \code{"0.75"}}
#'     \item{hex string, e.g. \code{"#00ff00"} for green}
#'     \item{character string with HTML color name, e.g. \code{"slateblue"},
#'       see \url{http://www.w3schools.com/html/html_colornames.asp}}
#'     \item{a character vector of \code{length(x)} containing a color
#'       specification as described above for each point separately}
#'     \item{a numeric vector of \code{length(x)}, where each numeric is used
#'       to map the according point to a colormap using the \code{cmap},
#'       \code{norm}, \code{vmin} and \code{vmax} arguments}
#'     \item{a numeric matrix with \code{length(x)} rows and three columns. Each
#'       row represents one point in \code{x}/\code{y}, the rows set values for
#'       RGB (red, green and blue, each between 0 and 1)}
#'     \item{a numeric matrix with \code{length(x)} rows and four columns. Each
#'       row represents one point in \code{x}/\code{y}, the rows set values for
#'       RGBA (red, green, blue and alpha, each between 0 and 1)}
#'   }
#' @param linestyle character string or character vector of \code{length(x)}
#'   indicating the linestyle(s), using \code{"solid"} (default),
#'   \code{"dashed"}, \code{"dashdot"} or \code{"dotted"}
#' @param label character string
#' @param args character string of further arguments passed to the **kwargs
#'   argument of matplotlib.pyplot.vlines
#' @param show bool indicating whether to open a window with the plot
#' @examples
#' pyvlines(c(1, 3, 5), 0, 10, colors = c("r", "g", "b"),
#'          linestyles = c("solid", "dashed", "dotted"))
#' if (interactive()) pyshow()
#' @seealso \link{pyhlines}
#'   \url{http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.vlines}
#' @export
pyvlines <- function(x, ymin, ymax, colors = "k", linestyles = "solid",
                     label = "", args = NULL, show = FALSE)
{
  plotvar("x", x)
  
  if (length(ymin) > 1)
  {
    plotvar("ymin", ymin)
    ymin <- "_pvars['ymin']"
  }
  
  if (length(ymax) > 1)
  {
    plotvar("ymax", ymax)
    ymax <- "_pvars['ymax']"
  }
  
  # colors can be either character (single character or #hex string), sequence
  # of character (single character or #hex strings) or array with 3 or 4 cols
  if (is.character(colors) && length(colors) == 1)
  {
    colors <- paste0("'", colors, "'")
  } else if (is.matrix(colors))
  {
    pyvar("__colorsplot", colors) # No method to move matrices to _pvars defined yet
    colors <- "__colorsplot"
  } else
  {
    plotvar("colors", colors)
    colors <- "_pvars['colors']"
  }
  
  # linestyles is either string or string sequence
  if (length(linestyles) == 1)
  {
    linestyles <- paste0("'", linestyles, "'")
  } else
  {
    plotvar("linestyles", linestyles)
    linestyles <- "_pvars['linestyles']"
  }
  
  label <- paste0("'", label, "'")
  
  args <- ifelse(!is.null(args), paste0(",", args), "")
  
  pyrun(paste0("plt.vlines(_pvars['x'], ymin = ", ymin, ", ymax = ", ymax,
               ", colors = ", colors, ", linestyles = ", linestyles,
               ", label = ", label, args, ")"))
  
  pyrun("del(_pvars)")
  pyrun("if '__colorsplot' in locals(): del(__colorsplot)")
  
  if (show) pyshow()
}

#' Plot horizontal lines using pyplot.hlines
#' 
#' @param y numeric or a numeric vector with y-values for horizontal lines
#' @param xmin numeric or a numeric vector of \code{length(y)} indicating lower
#'   x-values of the lines
#' @param xmax numeric or a numeric vector of \code{length(y)} indicating upper
#'   x-values of the lines
#' @param colors color of the line(s) (default: \code{"k"}), can be one of
#'   \itemize{
#'     \item{single character for basic built-in matplotlib colors, see
#'       \url{http://matplotlib.org/api/colors_api.html#module-matplotlib.colors
#'       }
#'     }
#'     \item{a numeric value between 0 and 1 as character, indicating gray
#'       shade, e.g. \code{"0.75"}}
#'     \item{hex string, e.g. \code{"#00ff00"} for green}
#'     \item{character string with HTML color name, e.g. \code{"slateblue"},
#'       see \url{http://www.w3schools.com/html/html_colornames.asp}}
#'     \item{a character vector of \code{length(x)} containing a color
#'       specification as described above for each point separately}
#'     \item{a numeric vector of \code{length(x)}, where each numeric is used
#'       to map the according point to a colormap using the \code{cmap},
#'       \code{norm}, \code{vmin} and \code{vmax} arguments}
#'     \item{a numeric matrix with \code{length(x)} rows and three columns. Each
#'       row represents one point in \code{x}/\code{y}, the rows set values for
#'       RGB (red, green and blue, each between 0 and 1)}
#'     \item{a numeric matrix with \code{length(x)} rows and four columns. Each
#'       row represents one point in \code{x}/\code{y}, the rows set values for
#'       RGBA (red, green, blue and alpha, each between 0 and 1)}
#'   }
#' @param linestyle character string or character vector of \code{length(x)}
#'   indicating the linestyle(s), using \code{"solid"} (default),
#'   \code{"dashed"}, \code{"dashdot"} or \code{"dotted"}
#' @param label character string
#' @param args character string of further arguments passed to the **kwargs
#'   argument of matplotlib.pyplot.hlines
#' @param show bool indicating whether to open a window with the plot
#' @examples
#' pyhlines(1:10, 0, 10)
#' if (interactive()) pyshow()
#' @seealso \link{pyvlines} 
#'   \url{http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.hlines}
#' @export
pyhlines <- function(y, xmin, xmax, colors = "k", linestyles = "solid",
                     label = "", args = NULL, show = FALSE)
{
  plotvar("y", y)
  
  if (length(xmin) > 1)
  {
    plotvar("xmin", xmin)
    xmin <- "_pvars['xmin']"
  }
  
  if (length(xmax) > 1)
  {
    plotvar("xmax", xmax)
    xmax <- "_pvars['xmax']"
  }
  
  # colors can be either character (single character or #hex string), sequence
  # of character (single character or #hex strings) or array with 3 or 4 cols
  if (is.character(colors) && length(colors) == 1)
  {
    colors <- paste0("'", colors, "'")
  } else if (is.matrix(colors))
  {
    pyvar("__colorsplot", colors) # No method to move matrices to _pvars defined yet
    colors <- "__colorsplot"
  } else
  {
    plotvar("colors", colors)
    colors <- "_pvars['colors']"
  }
  
  # linestyles is either string or string sequence
  if (length(linestyles) == 1)
  {
    linestyles <- paste0("'", linestyles, "'")
  } else
  {
    plotvar("linestyles", linestyles)
    linestyles <- "_pvars['linestyles']"
  }
  
  label <- paste0("'", label, "'")
  
  args <- ifelse(!is.null(args), paste0(",", args), "")
  
  pyrun(paste0("plt.hlines(_pvars['y'], xmin = ", xmin, ", xmax = ", xmax,
               ", colors = ", colors, ", linestyles = ", linestyles,
               ", label = ", label, args, ")"))
  
  pyrun("del(_pvars)")
  pyrun("if '__colorsplot' in locals(): del(__colorsplot)")
  
  if (show) pyshow()
}

#' Show figures
#' Run pyplot.show(). This will open all created figure windows and hang R before all windows are closed.
#' @export
pyshow <- function(){
   
    #Show saved png plots in Rstudio server
    if (isRstudio_server())
    {
      pname <- paste0(tempfile(), ".png")
      pyrun(sprintf("plt.savefig('%s', dpi=200)", pname))
      pyrun("plt.close()")
      library(grid)
      library(png)
      plt <- readPNG(pname)
      plot.new()
      grid.raster(plt)
    }else{
      pyrun("plt.show()")
    }
}


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
