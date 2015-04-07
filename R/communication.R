

#' Copy variable from R to Python
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

#' Generics defined in C++
topy <- function(x, name) UseMethod("topy")


#' Copy variables to a Python dictionary
#' 
pydict <- function(x, name, dictname) UseMethod("pydict") #Generics defined in pylab.cpp

#' @export
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