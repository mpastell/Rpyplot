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

#' Print python object
#' 
#' @param name name of the python object
#' 
#' @examples
#' pyvar("x", 1:10)
#' pyprint(x)
#' 
#' @export
pyprint <- function(name)
{
  pyrun(paste("print(", deparse(substitute(name)), ")"))   
}