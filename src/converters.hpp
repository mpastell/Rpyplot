#ifndef __CONVERT__
#define __CONVERT__
#include <Rcpp.h>
#include <Python.h>

//Converters from R to Python
using namespace Rcpp;

//Convert NumericVector to Python List
PyObject* to_list(NumericVector x){
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

//Convert CharacterVector to Python List
PyObject* to_list(std::vector< std::string > strings){
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

//Push data to python __main__ namespace
void to_main(std::string name, PyObject *pyobj)
{
    PyObject *main = PyModule_GetDict(PyImport_AddModule("__main__"));
    PyDict_SetItemString(main, name.c_str(), pyobj);
    //Py_CLEAR(pyobj);
}

//Get data from __main__ namespace
PyObject* from_main(std::string name){
  PyObject *main = PyModule_GetDict(PyImport_AddModule("__main__"));
  return PyDict_GetItemString(main, name.c_str());
}

//Add data to dict in main. Create the dict if it doesn't exist
PyObject* add_to_dict(std::string name, std::string dictname, PyObject *pyobj)
{
  PyObject *dict = from_main(dictname);
  if (dict==NULL || !PyDict_Check(dict))// !PyDict_Check(dict)) //Create new if dict doesn't exist
  {
    dict = PyDict_New();
  }
  PyDict_SetItemString(dict, name.c_str(), pyobj);  
  to_main(dictname, dict);
}

#endif