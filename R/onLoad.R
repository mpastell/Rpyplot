#' @useDynLib Rpyplot
#' @importFrom Rcpp sourceCpp
NULL

.onLoad <- function(libname, pkgname) {
  #packageStartupMessage("Initializing Python\n")
  initialize_python()
  
  pyrun("import matplotlib");
  #Rstudio server
  if (!is.na(Sys.getenv()["RSTUDIO_HTTP_REFERER"]))
    pyrun("matplotlib.use('Agg')")
  
  pyrun("import matplotlib.pyplot as plt");
}

