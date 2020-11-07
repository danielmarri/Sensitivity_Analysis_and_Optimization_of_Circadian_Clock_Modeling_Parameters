#include "mex.h"
#include <amigoRHS.h>



#if defined win32 || defined _win32 || defined __win32 || defined WIN32 || defined _WIN32 || defined _WIN64 || defined WIN64
	EXPORTIT void run_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[],int(*rhs)(realtype,N_Vector, N_Vector, void*),void(obs_func)(void*),void(obs_sens_func)(void*),void(change_y_func)(AMIGO_model,realtype,N_Vector));
#else 
	extern void run_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[],int(*rhs)(realtype,N_Vector, N_Vector, void*),void(*obs)(void*),void(*obs_sens)(void*),void(change_y_func)(void*,realtype,N_Vector));
#endif

int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data);

void amigoRHS_get_OBS(void* data);

void amigoRHS_get_sens_OBS(void* data);

void amigo_Y_at_tcon(void* amigo_model, realtype t, N_Vector y);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	run_mexFunction(nlhs, plhs, nrhs,prhs, amigoRHS,amigoRHS_get_OBS,amigoRHS_get_sens_OBS,amigo_Y_at_tcon);
	
}