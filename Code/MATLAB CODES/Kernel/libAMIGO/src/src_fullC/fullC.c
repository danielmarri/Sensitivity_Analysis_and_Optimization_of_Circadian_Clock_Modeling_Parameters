
#include <amigoRHS.h>

#if defined WIN32 || defined __WIN32 || defined _WIN32 || defined _WIN64 || defined WIN64 || defined MSVC || defined win32 || defined _win32 || defined __win32 
    __declspec(dllimport) void run_amigo_main(int argc, const char* argv[],int(*rhs)(realtype,N_Vector, N_Vector, void*),void(*obs_func)(void*),void(*obs_sens_func)(void*),void(change_y_func)(void*, realtype t, N_Vector y));
#else 
	extern void run_amigo_main(int argc, const char* argv[],int(*rhs)(realtype,N_Vector, N_Vector, void*),void(*obs_func)(void*),void(*obs_sens_func)(void*),void(change_y_func)(void*, realtype t, N_Vector y));
#endif

int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data);

void amigoRHS_get_OBS(void* data);

 void amigoRHS_get_sens_OBS(void* data);
 
 void amigo_Y_at_tcon(void* data,realtype t, N_Vector y);

int main(int argc, const char* argv[]){

	run_amigo_main(argc,argv,amigoRHS,amigoRHS_get_OBS,amigoRHS_get_sens_OBS,amigo_Y_at_tcon);
	return 0;
	
}
