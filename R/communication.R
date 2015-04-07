topyf <- function(x, name) UseMethod("topyf")

topyf.numeric  <- function(x, name)
{
  numvec_to_python(name, x)
}
  
topy <- function(name, x)
{
  if (missing(x)){
    x <- name
    name <- deparse(substitute(name))
  }
  
  topyf(x, name)
}