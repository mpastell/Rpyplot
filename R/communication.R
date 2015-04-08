
#' Copy variable from R to Python
#' 
#' @param name variable name in python
#' @param x R data, numeric and character vectors and numeric matrices are currently supported.
#'
#' @examples
#' pyvar("x", 1:10)
#' pyprint(x)
#' pyvar("s", c("Hello", "R!")) 
#' pyprint(s)
#' pyvar(volcano) #Matrix
#' pyprint(volcano)
#' 
#' @export
pyvar <- function(name, x)
{
  if (missing(x)){
    x <- name
    name <- deparse(substitute(name))
  }
  topy(x, name)
}

# Generic method to copy data to Python
# 
# Some of the methods are defined in C++
# 
topy <- function(x, name) UseMethod("topy")

topy.matrix <- function(z, name)
{
  #Array moved to Python as list and converted to 
  #NumPy array
  nr = nrow(z)
  nc = ncol(z)
  topy.numeric(z, name)
  
  #numvec_to_python(paste(name,"z_size", sep=""), c(nr, nc))
  pyrun("import numpy as np")
  pyrun(sprintf("%s = (np.reshape(%s, [%i, %i], order='F'))", name, name, nr, nc))  
}

# Copy variables to a Python dictionary
pydict <- function(x, name, dictname) UseMethod("pydict") #Generics defined in pylab.cpp

# Copy variables to _pvars dictionary for plotting
plotvar <- function(name, x)
{
  if (missing(x)){
    x <- name
    name <- deparse(substitute(name))
  }
  
  pydict(x, name)
}


#' Print python object
#' 
#' @param name name of the python object
#' 
#' @examples
#' pyvar("x", 1:10)
#' pyprint(x)
#' pyprint("dir()") #You can quote Python commands
#' @export
pyprint <- function(x)
{
  cmd <- substitute(x)
  if (is.character(cmd))
  {
    pyrun(paste("print(", cmd, ")")) 
  }
  else
  {
    pyrun(paste("print(", deparse(cmd), ")")) 
  }
}