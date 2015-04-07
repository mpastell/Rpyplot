#include <Rcpp.h>
#include <Python.h>
#include <stdio.h>
#ifndef WIN32
#include <dlfcn.h>
#endif


// For background info:
// http://gallery.rcpp.org/articles/matplotlib-from-R/
// http://gallery.rcpp.org/articles/rcpp-python/

using namespace Rcpp;
//Can be used to return a pointer to a Python list, not used for now
//typedef Rcpp::XPtr<PyObject> PyList; 



//Redirection based on https://github.com/wush978/Rython
static PyObject* stdoutredirect(PyObject* self, PyObject *args) {
  const char* string;
  if (!PyArg_ParseTuple(args, "s", &string))
    return NULL;
  Rcpp::Rcout << string;
  Py_RETURN_NONE;
}

PyMethodDef redirect_pystdout[] = {
  {"_Rcout", (PyCFunction)stdoutredirect, METH_VARARGS, 
    "stdout redirection helper"},
  {NULL, NULL, 0, NULL}
};


static PyObject* stderrredirect(PyObject* self, PyObject *args) {
  const char* string;
  if (!PyArg_ParseTuple(args, "s", &string))
    return NULL;
  Rcpp::Rcerr << string;
  Py_RETURN_NONE;
}

PyMethodDef redirect_pystderr[] = {
  {"_Rcerr", (PyCFunction)stderrredirect, METH_VARARGS, 
    "stderr redirection helper"},
  {NULL, NULL, 0, NULL}
};


//' Run python code
//'
//' Runs Python code in namespace __main__ . 
//' 
//' @param command Python code to execute as string
//' @examples
//' pyrun("print range(5)")
//' @export
//[[Rcpp::export]]
void pyrun(std::string command){
    PyRun_SimpleString(command.c_str());
}

//[[Rcpp::export]]
void initialize_python() {
#ifndef WIN32
#if PY_MAJOR_VERSION >= 3
  //Not found in path
  //This is the path for Ubuntu 14.10
   dlopen("/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu/libpython3.4.so", RTLD_LAZY |RTLD_GLOBAL); 
#else
   dlopen("libpython2.7.so", RTLD_LAZY |RTLD_GLOBAL);
#endif
#endif


#if PY_MAJOR_VERSION >= 3
    Py_SetProgramName(L"python3.4");
#else
  Py_SetProgramName((char*)"python");
#endif
    Py_Initialize();
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    PyObject *f = PyCFunction_New(redirect_pystdout, (PyObject*)NULL);
    PyObject *f2 = PyCFunction_New(redirect_pystderr, (PyObject*)NULL);
    PyDict_SetItemString(main, "_Rcout",  f);
    PyDict_SetItemString(main, "_Rcerr",  f2);
    pyrun("class _StdoutCatcher:\n  def write(self, out):\n    _Rcout(out)");
    pyrun("class _StderrCatcher:\n  def write(self, out):\n    _Rcerr(out)");
    pyrun("import sys\nsys.stdout = _StdoutCatcher()");
    pyrun("import sys\nsys.stderr = _StderrCatcher()");
    pyrun("import matplotlib");
    //pyrun("matplotlib.use('Qt4Agg')");
    pyrun("import matplotlib.pyplot as plt");
}

//[[Rcpp::export]]
void finalize_python() {
    Py_Finalize();
}

//Convert NumericVector to Python List
PyObject* numvec_to_list(NumericVector x){
    int n = x.length();
    PyObject *xpy = PyList_New(n);
    PyObject *f;
    
    for (int i=0; i<n; i++)
    {
      f = PyFloat_FromDouble(x[i]);
      //std::cout << i << "\n";
      PyList_SetItem(xpy, i, f);
    }   
    return(xpy);
}

PyObject* charvec_to_list(std::vector< std::string > strings){
    int n = strings.size();
    PyObject *xpy = PyList_New(n);
    PyObject *s;
    
    for (int i=0; i<n; i++)
    {
      s = PyUnicode_FromString(strings[i].c_str());
      PyList_SetItem(xpy, i, s);
    }   
    return(xpy);
}


//' Push data to python __main__ namespace
//' 
//' @param name Python variable name as string
//' @param x Numeric vector to copy to Python
//' 
//' @examples
//' numvec_to_python("l", 1:10)
//' pyrun("print l")
//' 
//' @export
//[[Rcpp::export]]
void numvec_to_python(std::string name, NumericVector x){
    PyObject *xpy = numvec_to_list(x);
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    PyDict_SetItemString(main, name.c_str(), xpy);
}

//' @export
//[[Rcpp::export]]
void charvec_to_python(std::string name, std::vector< std::string > strings){
    PyObject *xpy = charvec_to_list(strings);
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    PyDict_SetItemString(main, name.c_str(), xpy);
}


//' Get numeric vector from python __main__ namespace.
//' 
//' The data retrieved from Python has to be a list of numbers.
//' 
//' @param name Python variable name
//' 
//' @export
//[[Rcpp::export]]
NumericVector numvec_to_R(std::string name){
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    PyObject *list = PyDict_GetItemString(main, name.c_str());
    
    if (list == NULL)
    {
      Rcout << "Error: Unknown Python variable\n";
      return NumericVector(0);
    }
    
    int n = (int)PyList_Size(list);
    NumericVector x(n);
    
    for (int i=0; i<n; i++)
    {
      x(i) = PyFloat_AsDouble(PyList_GetItem(list, i));
      //Rcout << x(i) << std::endl;
    }  
    return x;
}

//' Copy list of strings from Python to R character vector
//' 
//' @examples
//'
//'pyrun("l = ['a', 'b']")
//'pyrun("print(l)")
//'charvec_to_R("l")
//'pyrun("l2 = [u'a', u'b']")
//'charvec_to_R("l2")
//'@export
//[[Rcpp::export]]
std::vector<std::string> charvec_to_R(std::string name){
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    PyObject *list = PyDict_GetItemString(main, name.c_str());
    
    if (list == NULL)
    {
      Rcout << "Error: Unknown Python variable\n";
      std::vector< std::string > x(0);
      return x;
    }
    
    int n = (int)PyList_Size(list);
    std::vector< std::string > x(n);
    PyObject *item;
    
    for (int i=0; i<n; i++)
    {

      item = PyList_GetItem(list, i);
#if PY_MAJOR_VERSION >= 3
        x[i] = PyBytes_AsString(PyUnicode_AsUTF8String(item));
#else
    if (PyString_Check(item)){
          x[i] = PyString_AsString(item);
      } else
      {
        x[i] = PyBytes_AsString(PyUnicode_AsUTF8String(item));
      }
#endif
    }
  //Rcout << x[i] << std::endl;
    return x;
}

//Add NumericVector to dict in Python
//Used to "hide" variables for plotting
//[[Rcpp::export]]
void num_to_dict(std::string name, NumericVector x, std::string dictname){
    PyObject *xpy = numvec_to_list(x);
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
  
    PyObject *dict = PyDict_GetItemString(main, dictname.c_str());
    if (dict==NULL || !PyDict_Check(dict))// !PyDict_Check(dict)) //Create new if dict doesn't exist
    {
      dict = PyDict_New();
    }
    
    PyDict_SetItemString(dict, name.c_str(), xpy);
    PyDict_SetItemString(main, dictname.c_str() , dict);  
}

//Add character vector to dict in Python
//Used to "hide" variables for plotting
//[[Rcpp::export]]
void char_to_dict(std::string name, std::vector<std::string>  x, std::string dictname){
    PyObject *xpy = charvec_to_list(x);
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    
    PyObject *dict = PyDict_GetItemString(main, dictname.c_str());
    
    if (dict==NULL || !PyDict_Check(dict)) //Create new if dict doesn't exist
    {
      dict = PyDict_New();
    }
    
    PyDict_SetItemString(dict, name.c_str(), xpy);
    PyDict_SetItemString(main, dictname.c_str() , dict);
}