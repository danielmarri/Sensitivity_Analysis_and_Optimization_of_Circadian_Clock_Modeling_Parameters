#include <amigo_terminate.h>                                                                                      
/* works only with MSVC.*/                                                                                        
#ifdef _MSC_VER                                                                                                   
/*                                                                                                                
* ctrlcCheckPoint(): function to check whether the user has pressed                                               
*                    Ctrl+C, and if so, terminate execution returning                                             
*                    an error message with a hyperlink to the                                                     
*                    offending function's help, and a hyperlink to                                                
*                    the line in the source code file this function                                               
*                    was called from                                                                              
*                                                                                                                 
* In practice, to use this function put a call like this e.g. inside                                              
* loops that may take for a very long time:                                                                       
*                                                                                                                 
*    /* exit if user pressed Ctrl+C                                                                             
*    ctrlcCheckPoint(__FILE__, __LINE__);                                                                         
*                                                                                                                 
* sourceFile: full path and name of the C++ file that calls this                                                  
*             function. This should usually be the preprocessor                                                   
*             directive __FILE__                                                                                  
*                                                                                                                 
* lineNumber: line number where this function is called from. This                                                
*             should usually be the preprocessor directive __LINE__                                               
*                                                                                                                 
*/                                                                                                                
void ctrlcCheckPoint(char* sourceFile, int lineNumber) {                                                          
const int nlhs = 1; /* number of output arguments we expect*/                                                     
mxArray *plhs[1]; /* to store the output argument*/                                                               
const int nrhs = 1; /* number of input arguments we are going to pass*/                                           
mxArray *prhs[1]; /* to store the input argument we are going to pass*/                                           
char *pathAndName;                                                                                                
                                                                                                                  
prhs[0] = mxCreateString("fullpath"); /* input argument to pass*/                                                 
if (utIsInterruptPending()) {                                                                                     
/* run from here the following code in the Matlab side:*/                                                         
/**/                                                                                                              
/* >> path = mfilename('fullpath')*/                                                                              
/**/                                                                                                              
/* this provides the full path and function name of the function*/                                                
/* that called ctrlcCheckPoint()*/                                                                                
                                                                                                                  
if (mexCallMATLAB(nlhs, plhs, nrhs, prhs, "mfilename")) { /* run mfilename('fullpath')*/                          
mexErrMsgTxt("ctrlcCheckPoint(): mfilename('fullpath') returned error");                                          
}                                                                                                                 
if (plhs == NULL) {                                                                                               
mexErrMsgTxt("ctrlcCheckPoint(): mfilename('fullpath') returned NULL array of outputs");                          
}                                                                                                                 
if (plhs[0] == NULL) {                                                                                            
mexErrMsgTxt("ctrlcCheckPoint(): mfilename('fullpath') returned NULL output instead of valid path");              
}                                                                                                                 
/* get full path to current function, including function's name*/                                                 
/* (without the file extension)*/                                                                                 
pathAndName = mxArrayToString(plhs[0]);                                                                           
if (pathAndName == NULL) {                                                                                        
mexErrMsgTxt("ctrlcCheckPoint(): mfilename('fullpath') output cannot be converted to string");                    
}                                                                                                                 
/* for some reason, using mexErrMsgTxt() to give this output*/                                                    
/* doesn't work. Instead, we have to give the output to the*/                                                     
/* standar error, and then call mexErrMsgTxt() to terminate*/                                                     
/* execution of the program*/                                                                                     
mexPrintf("Operation terminated by user during '%s' in %s, line %d\n",mexFunctionName(), pathAndName, lineNumber);
mexErrMsgTxt("");                                                                                                 
                                                                                                                  
/*std::cerr <<                                                                                                    
<< "<a href=\"matlab:helpUtils.errorDocCallback('"                                                                
<< mexFunctionName()                                                                                              
<< "', '" << pathAndName << ".m', " << lineNumber << ")\">"                                                       
<< mexFunctionName()                                                                                              
<< "</a> (<a href=\"matlab:opentoline('"                                                                          
<< sourceFile                                                                                                     
<< "'," << lineNumber << ",0)\">line " << lineNumber                                                              
<< "</a>)"                                                                                                        
<< std::endl;*/                                                                                                   
                                                                                                                  
}                                                                                                                 
};                                                                                                                
#else                                                                                                             
void ctrlcCheckPoint(char* sourceFile, int lineNumber){};                                                         
#endif                                                                                                            
