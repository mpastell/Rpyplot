#' @useDynLib Rpyplot
#' @importFrom Rcpp sourceCpp
NULL

.onLoad <- function(libname, pkgname) {
  #packageStartupMessage("Initializing Python\n")
  initialize_python()
  #From https://github.com/wush978/Rython
  pyrun("import sys")
  pyrun("import redirection\nclass StdoutCatcher:\n  def write(self, out):\n    redirection.stdoutredirect(out)")
  pyrun("sys.stdout = StdoutCatcher()")
}

