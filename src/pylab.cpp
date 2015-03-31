#include <Rcpp.h>
#include <Python.h>
#include <stdio.h>
#ifndef WIN32
#include <dlfcn.h>
#endif


using namespace Rcpp;
typedef Rcpp::XPtr<PyObject> PyList;

//http://gallery.rcpp.org/articles/rcpp-python/

//[[Rcpp::export]]
void pyrun(std::string command){
    PyRun_SimpleString(command.c_str());
}

//[[Rcpp::export]]
void initialize_python() {
#ifndef WIN32
    dlopen("libpython2.7.so", RTLD_NOW | RTLD_GLOBAL);
#endif
    Py_SetProgramName("python");
    Py_Initialize();
    pyrun("import matplotlib");
    pyrun("matplotlib.use('Qt4Agg')");
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



//Push data to python __main__ namespace
//[[Rcpp::export]]
void numvec_to_python(std::string name, NumericVector x){
    PyObject *xpy = numvec_to_list(x);
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    PyDict_SetItemString(main, name.c_str(), xpy);
}


//Call function from pylab
void plt_call(char* fun){
    PyObject *pylab = PyImport_Import(PyString_FromString((char*)"pylab"));
    PyObject *args = PyTuple_Pack(0);
    PyObject_CallObject(PyObject_GetAttrString(pylab, fun), args);
}



//[[Rcpp::export]]
void pyplotCpp(NumericVector x) {
    int n = x.length();
    //std::cout << n << "\n";
    PyObject *xpy = PyList_New(n);
    
    PyObject *f;

    for (int i=0; i<n; i++)
    {
      f = PyFloat_FromDouble(x[i]);
      //std::cout << i << "\n";
      PyList_SetItem(xpy, i, f);
    }
    
    //std::cout << PyList_GetItem(xpy, 1) << "\n";
    
    PyObject *pylab = PyImport_Import(PyString_FromString((char*)"pylab"));
    PyObject *plot = PyObject_GetAttrString(pylab,(char*)"plot");
    PyObject *args = PyTuple_Pack(1, xpy);
    PyObject *presult = PyObject_CallObject(plot, args);
  
    
    //PyRun_SimpleString("pylab.ion()"); //Doesn't work without event loop...
    //PyRun_SimpleString("pylab.plot(xpy)");
    //PyRun_SimpleString("pylab.draw()");
    //PyRun_SimpleString("import pylab");

      
    //Py_DECREF(pylab);
    //Py_DECREF(plot);
    
    Py_DECREF(xpy);
    //Py_DECREF(presult);
    //Py_DECREF(args);
    
    

    return;
    //Py_Finalize();
    //PyRun_SimpleString("import pylab\n");
    
    //PyRun_SimpleString("from time import time,ctime\n"
    //                   "print 'Today is',ctime(time())\n");
}


//SEXP pyplot2(NumericVector x, NumericVector y) {
//[[Rcpp::export]]
void pyplot2Cpp(NumericVector x, NumericVector y) {
    //dlopen("/usr/lib/x86_64-linux-gnu/libpython2.7.so", RTLD_NOW | RTLD_GLOBAL);

    int n = x.length();
    //std::cout << n << "\n";
    PyObject *xpy = PyList_New(n); //allocate lists for data
    PyObject *ypy = PyList_New(n); 
    
    PyObject *f;
    PyObject *f2;

    //Add data to lists
    for (int i=0; i<n; i++)
    {
      f = PyFloat_FromDouble(x[i]);
      PyList_SetItem(xpy, i, f);
      f2 = PyFloat_FromDouble(y[i]);
      PyList_SetItem(ypy, i, f2);
    }
    
    //std::cout << PyList_GetItem(xpy, 1) << "\n";
    
    PyObject *pylab = PyImport_Import(PyString_FromString((char*)"pylab"));
    PyObject *plot = PyObject_GetAttrString(pylab,(char*)"plot");
    PyObject *args = PyTuple_Pack(2, xpy, ypy);
    PyObject *presult = PyObject_CallObject(plot, args);
  
    
    //PyRun_SimpleString("pylab.ion()"); //Doesn't work without event loop...
    //PyRun_SimpleString("pylab.plot(xpy)");
    //PyRun_SimpleString("pylab.draw()");
    //PyRun_SimpleString("import pylab");
    
    //PyRun_SimpleString("pylab.show()");
    //PyRun_SimpleString("pylab.close()");
    
    
    //Py_DECREF(pylab);
    //Py_DECREF(plot);
  
    //Crashes on WIn7
    //Py_DECREF(presult);
    //Py_DECREF(args);
    
    Py_DECREF(xpy);
    Py_DECREF(ypy);
    Py_DECREF(f);
    
    return;
    //PyList res(presult);
    //return res;
}


//Replace with R version
void pyshow() {
  plt_call("show");
}


void pyfigure() {
  plt_call("figure");
}

//Save figure with C api
void pysave(std::string figname){   
    PyObject *pylab = PyImport_Import(PyString_FromString((char*)"pylab"));
    PyObject *args = PyTuple_Pack(1, PyString_FromString(figname.c_str()));
    PyObject_CallObject(PyObject_GetAttrString(pylab, "savefig"), args);
}



//[[Rcpp::export]]
void pyt(NumericVector x) {
    PyObject *xpy = numvec_to_list(x);
    
    PyObject *m = PyImport_AddModule("__main__");
    PyObject *main = PyModule_GetDict(m);
    PyDict_SetItemString(main, "x", xpy);
    
    PyRun_String("import pylab\npylab.plot(x)\npylab.show()", Py_file_input, main, main);
}