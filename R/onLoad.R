#' @useDynLib Rpyplot
#' @importFrom Rcpp sourceCpp
NULL

.onLoad <- function(libname, pkgname) {
  cat("Initializing Python\n")
  initialize_python()
}