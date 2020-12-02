#include "mex.h"                                                    
/*                                                                  
* utIsInterruptPending(): "undocumented MATLAB API implemented in   
* libut.so, libut.dll, and included in the import library           
* libut.lib. To use utIsInterruptPending in a mex-file, one must    
* manually declare bool utIsInterruptPending() because this function
* is not included in any header files shipped with MATLAB. Since    
* libut.lib, by default, is not linked by mex, one must explicitly  
* tell mex to use libut.lib." -- Wotao Yin,                         
* http://www.caam.rice.edu/~wy1/links/mex_ctrl_c_trick/           
*                                                                   
*/                                                                  
#ifdef __cplusplus                                                  
extern "C" bool utIsInterruptPending();                             
#else                                                               
extern bool utIsInterruptPending();                                 
#endif                                                              
void ctrlcCheckPoint(char* sourceFile, int lineNumber);             
