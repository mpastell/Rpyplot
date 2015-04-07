topy <- function(x, name) UseMethod("topy")

topy.numeric  <- function(x, name)
{
  numvec_to_python(name, x)
}

topy.character <- function(x, name)
{
  charvec_to_python(name, x)
}

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
pyprint <- function(name)
{
  if (is.character(name)){
    cmd = name
  }
  else{
    cmd = deparse(substitute(name))
  }
  
  pyrun(paste("print(", cmd, ")"))   
}