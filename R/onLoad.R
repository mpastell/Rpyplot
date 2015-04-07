#' @useDynLib Rpyplot
#' @importFrom Rcpp sourceCpp
NULL

.onLoad <- function(libname, pkgname) {
  #packageStartupMessage("Initializing Python\n")
  initialize_python()  
}

