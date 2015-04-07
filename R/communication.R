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

to_pydict <- function(x, name, dictname="_pvars") UseMethod("to_pydict") 

to_pydict.numeric <- function(x, name, dictname="_pvars") 
{
  num_to_dict(name, x, dictname)  
}

to_pydict.character <- function(x, name, dictname="_pvars") 
{
  char_to_dict(name, x, dictname)  
}

#' @export
plotvar <- function(name, x)
{
  if (missing(x)){
    x <- name
    name <- deparse(substitute(name))
  }
  
  to_pydict(x, name)
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