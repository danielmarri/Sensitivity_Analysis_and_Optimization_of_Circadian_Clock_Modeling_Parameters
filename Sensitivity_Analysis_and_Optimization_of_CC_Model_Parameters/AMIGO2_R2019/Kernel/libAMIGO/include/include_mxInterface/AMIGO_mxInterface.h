#pragma once

#include "AMIGO_problem.h"
#include "AMIGO_pe.h"
#include "mat.h"
#include <string.h>
#include "mex.h"


EXPORTIT void run_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[],int(*rhs)(realtype,N_Vector, N_Vector, void*),void(obs_func)(void*),void(obs_sens_func)(void*),void(change_y_func)(void*,realtype,N_Vector));

EXPORTIT AMIGO_model* mxAllocateAMIGOmodel(mxArray* privstruct_ptr,mxArray* inputs_ptr, int exp_num);

EXPORTIT void mxSolveAMIGOivp(AMIGO_problem* amigo_problem, int save2workspace, char* save2File);

EXPORTIT void mxSolveAMIGO_FSA(AMIGO_problem* amigo_problem, int save2Workspace, char* save2File);

EXPORTIT void mxSolveAMIGO_MKLSENS(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File);

EXPORTIT AMIGO_problem* openMatFile(char * file);

EXPORTIT double AMIGO_dummy(AMIGO_problem* amigo_problem);

EXPORTIT int mxAMIGOsave2File(mxArray *outputs_ptr,char* save2File);

EXPORTIT void mxSolveAMIGOnl2sol(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File);

EXPORTIT void mxSolveAMIGOsres(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File);

EXPORTIT void mxSolveAMIGOde(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File);

EXPORTIT void mxEvalAMIGOlsq(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File);

EXPORTIT void mxEvalAMIGOllk(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File);