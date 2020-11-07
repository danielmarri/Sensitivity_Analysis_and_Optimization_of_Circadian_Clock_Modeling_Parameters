// dllmain.cpp : Defines the entry point for the DLL application.

#include <stdio.h>

#if defined WIN32 || defined __WIN32 || defined _WIN32 || defined _WIN64 || defined WIN64 || defined MSVC || defined win32 || defined _win32 || defined __win32

#include "stdafx.h"

BOOL APIENTRY DllMain( HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
	)
{
	
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

#endif

#include <AMIGO_mxInterface.h>

EXPORTIT void run_amigo_main( int argc,
    const char* argv[],
    int(*rhs)(realtype,N_Vector, N_Vector, void*),
	void(obs_func)(void*),
	void(obs_sens_func)(void*),
	void(change_y_func)(void*, realtype t, N_Vector y)
)
{
	int i;
	AMIGO_problem* amigo_problem;

	if (argc>1 && strcmp(argv[1], "-help")==0 ){

		printf("AMIGO fullC requires three input arguments\n");
		printf("arg 1: Location of the input data file (.mat file from matlab) \n");
		printf("arg 2: Destination of the results (.mat file from matlab)\n");
		printf("arg 3: Task to be performed Available tasks: sim_CVODES, sens_FSA_CVODES, pe_NL2SOL, sens_FD_MKL, cost_LSQ, cost_LLK, pe_SRES or pe_DE\n");
		return;
	}
	
	printf("Input arguments:\n");
	for(i = 1; i < argc; i++ ){
		printf( "arg %d: %s\n", i, argv[i]);
	}
	
	if(argc!=4){
		printf("AMIGO fullC requires three input arguments\n");
		printf("type -help for more information \n");

		return;
	}
	
	if (strcmp(argv[3], "sim_CVODES")==0 || strcmp(argv[3], "sens_FSA_CVODES")==0 || strcmp(argv[3], "pe_NL2SOL")==0 ||
		strcmp(argv[3], "sens_FD_MKL")==0 || strcmp(argv[3], "cost_LSQ")==0 || strcmp(argv[3], "cost_LLK")==0 || 
		strcmp(argv[3], "pe_SRES")==0 || strcmp(argv[3], "pe_DE")==0 ){

	}else{
		printf("You have not selected a valid AMIGO fullC task. Available tasks: sim_CVODES,sens_FSA_CVODES,pe_NL2SOL,sens_FD_MKL,cost_LSQ,cost_LLK,pe_SRES and pe_DE\n");
		return;
	}
	
	amigo_problem=openMatFile((char*) argv[1]);

	if(amigo_problem){
		
		
		set_AMIGO_problem_rhs(amigo_problem,rhs,change_y_func);
		
		set_AMIGO_problem_obs_function(amigo_problem,obs_func,obs_sens_func);
		
		if (strcmp(argv[3], "sim_CVODES")==0 ) mxSolveAMIGOivp(amigo_problem,0, (char*) argv[2]);

		if (strcmp(argv[3], "sens_FSA_CVODES")==0 ) mxSolveAMIGO_FSA(amigo_problem,0, (char*) argv[2]);

		if (strcmp(argv[3], "pe_NL2SOL")==0 ) mxSolveAMIGOnl2sol(amigo_problem,0, (char*) argv[2]);

		if (strcmp(argv[3], "sens_FD_MKL")==0 ) mxSolveAMIGO_MKLSENS(amigo_problem,0, (char*) argv[2]);

		if (strcmp(argv[3], "cost_LSQ")==0 ) mxEvalAMIGOlsq(amigo_problem,0, (char*) argv[2]);

		if (strcmp(argv[3], "cost_LLK")==0 ) mxEvalAMIGOllk(amigo_problem,0, (char*) argv[2]);

		if (strcmp(argv[3], "pe_SRES")==0 ) mxSolveAMIGOsres(amigo_problem,0, (char*) argv[2]);

		if (strcmp(argv[3], "pe_DE")==0 ) mxSolveAMIGOde(amigo_problem,0, (char*) argv[2]);
		free_AMIGO_problem(amigo_problem);

	}else{

		return;

	}
	
}


