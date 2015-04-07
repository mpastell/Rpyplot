#ifndef __REDIRECT__
#define __REDIRECT__

//Redirection of stdout and stderr based on https://github.com/wush978/Rython

#include <Rcpp.h>
#include <Python.h>

static PyObject* stdoutredirect(PyObject* self, PyObject *args) {
  const char* string;
  if (!PyArg_ParseTuple(args, "s", &string))
    return NULL;
  Rcpp::Rcout << string;
  Py_RETURN_NONE;
}


static PyObject* stderrredirect(PyObject* self, PyObject *args) {
  const char* string;
  if (!PyArg_ParseTuple(args, "s", &string))
    return NULL;
  Rcpp::Rcerr << string;
  Py_RETURN_NONE;
}



PyMethodDef redirect_pystdout[] = {
  {"_Rcout", (PyCFunction)stdoutredirect, METH_VARARGS, 
    "stdout redirection helper"},
  {NULL, NULL, 0, NULL}
};

PyMethodDef redirect_pystderr[] = {
  {"_Rcerr", (PyCFunction)stderrredirect, METH_VARARGS, 
    "stderr redirection helper"},
  {NULL, NULL, 0, NULL}
};
#endif