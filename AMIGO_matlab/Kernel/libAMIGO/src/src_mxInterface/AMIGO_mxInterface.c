#include "AMIGO_mxInterface.h"
#include "omp.h"

EXPORTIT void run_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[],int(*rhs)(realtype,N_Vector, N_Vector, void*),void(obs_func)(void*),void(obs_sens_func)(void*),void(change_y_func)(void*,realtype,N_Vector))
{

	mxArray* privstruct_ptr;
	mxArray*inputs_ptr;
	mxArray *pa;
	int n_exp,i;
	char *buf;
	mwSize buflen;
	int status;

	AMIGO_problem* amigo_problem;
	AMIGO_model** amigo_models;

	
	// Check for proper number of input and output arguments
	if(nrhs != 1) {
		mexErrMsgTxt("One input argument required.");
	}
	if(nlhs > 1) {
		mexErrMsgTxt("Too many output arguments.");
	}

	// Check for proper input type
	if (!mxIsChar(prhs[0]) || (mxGetM(prhs[0]) != 1 ) )  {
		mexErrMsgTxt("Input argument must be a string.");
	}

	buflen = mxGetN(prhs[0])*sizeof(mxChar)+1;
	buf = mxMalloc(buflen);

	// Copy the string data into buf.
	status = mxGetString(prhs[0], buf, buflen);

	if (strcmp(buf, "sim_CVODES")==0 || strcmp(buf, "sens_FSA_CVODES")==0 || strcmp(buf, "pe_NL2SOL")==0 ||
		strcmp(buf, "sens_FD_MKL")==0 || strcmp(buf, "cost_LSQ")==0 || strcmp(buf, "cost_LLK")==0 || 
		strcmp(buf, "pe_SRES")==0 || strcmp(buf, "pe_DE")==0){

	}
	else{
		mxFree(buf);
		return;
	}

	privstruct_ptr=mexGetVariable("caller", "privstruct");
	inputs_ptr=mexGetVariable("caller", "inputs");

	pa=mxGetField(privstruct_ptr,0, "n_exp");
	n_exp=(int)mxGetPr(pa)[0];

	amigo_models=(AMIGO_model**)malloc(sizeof(AMIGO_model*)*n_exp);

	for (i = 0; i < n_exp; i++){
		amigo_models[i]=mxAllocateAMIGOmodel(privstruct_ptr,inputs_ptr,i);
	}

	amigo_problem=allocate_AMIGO_problem(n_exp,amigo_models);
	
		pa=mxGetField(inputs_ptr,0, "ivpsol");
	if(mxGetFieldNumber(pa, "nthreads") != - 1){
		pa=mxGetField(pa,0, "nthreads");
		amigo_problem->nthreads=(int)mxGetPr(pa)[0];
	}else amigo_problem->nthreads=1;

		pa=mxGetField(inputs_ptr,0, "nlpsol");
	if(mxGetFieldNumber(pa, "cvodes_gradient") != - 1){
		pa=mxGetField(pa,0, "cvodes_gradient");
		amigo_problem->cvodes_gradient=(int)mxGetPr(pa)[0];
	}else amigo_problem->cvodes_gradient=1;

	pa=mxGetField(inputs_ptr,0, "nlpsol");
	if(mxGetFieldNumber(pa, "mkl_gradient") != - 1){
		pa=mxGetField(pa,0, "mkl_gradient");
		amigo_problem->mkl_gradient=(int)mxGetPr(pa)[0];
	}else amigo_problem->mkl_gradient=0;

	pa=mxGetField(inputs_ptr,0, "nlpsol");
	if(mxGetFieldNumber(pa, "iterprint") != - 1){
		pa=mxGetField(pa,0, "iterprint");
		amigo_problem->verbose=(int)mxGetPr(pa)[0];
	}else amigo_problem->verbose=0;


	set_AMIGO_problem_rhs(amigo_problem,rhs,change_y_func);
	set_AMIGO_problem_obs_function(amigo_problem,obs_func,obs_sens_func);

	if (strcmp(buf, "sim_CVODES")==0){
		mxSolveAMIGOivp(amigo_problem,1,"");
	}else if(strcmp(buf, "sens_FSA_CVODES")==0){
		//arg1 amigo_prob, 2 use cvodes, 3 use mkl, arg4 save2Workspace arg5 filename
		mxSolveAMIGO_FSA(amigo_problem,1,"");
	}else if(strcmp(buf, "sens_FD_MKL")==0){
#ifdef MKL
		//arg1 amigo_prob, 2 use cvodes, 3 use mkl, arg4 save2Workspace arg5 filename
		mxSolveAMIGO_MKLSENS(amigo_problem,1,"");
#else
		mexErrMsgTxt("Compile using MKL library and try again.");
#endif
	}else if(strcmp(buf, "pe_NL2SOL")==0){

		mxSolveAMIGOnl2sol(amigo_problem,1,"");

	}else if(strcmp(buf, "cost_LSQ")==0){

		mxEvalAMIGOlsq(amigo_problem,1,"");

	}else if(strcmp(buf, "cost_LLK")==0){

		mxEvalAMIGOllk(amigo_problem,1,"");


	}else if(strcmp(buf, "pe_SRES")==0){

		mxSolveAMIGOsres(amigo_problem,1,"");

	}else if(strcmp(buf, "pe_DE")==0){

		mxSolveAMIGOde(amigo_problem,1,"");

	}

	mxFree(buf);
	free_AMIGO_problem(amigo_problem);
}


EXPORTIT AMIGO_problem* openMatFile(char* file){

	mxArray* privstruct_ptr, *inputs_ptr, *pa;
	MATFile *pmat;
	int i, n_exp;

	AMIGO_problem* amigo_problem;
	AMIGO_model** amigo_models;


	pmat = matOpen(file, "r");
	if (pmat == NULL) {
		printf("Error creating file %s\n", file);
		return(NULL);
	}

	privstruct_ptr=matGetVariable(pmat, "privstruct");
	inputs_ptr=matGetVariable(pmat, "inputs");

	pa=mxGetField(privstruct_ptr,0, "n_exp");
	n_exp=(int)mxGetPr(pa)[0];
	
	amigo_models=(AMIGO_model**)malloc(sizeof(AMIGO_model*)*n_exp);

	for (i = 0; i < n_exp; i++){
		amigo_models[i]=mxAllocateAMIGOmodel(privstruct_ptr,inputs_ptr,i);
	}
	
	amigo_problem=allocate_AMIGO_problem(n_exp,amigo_models);

	pa=mxGetField(inputs_ptr,0, "ivpsol");
	if(mxGetFieldNumber(pa, "nthreads") != - 1){
		pa=mxGetField(pa,0, "nthreads");
		amigo_problem->nthreads=(int)mxGetPr(pa)[0];
	}else amigo_problem->nthreads=1;

	pa=mxGetField(inputs_ptr,0, "nlpsol");
	if(mxGetFieldNumber(pa, "cvodes_gradient") != - 1){
		pa=mxGetField(pa,0, "cvodes_gradient");
		amigo_problem->cvodes_gradient=(int)mxGetPr(pa)[0];
	}else amigo_problem->cvodes_gradient=1;

	pa=mxGetField(inputs_ptr,0, "nlpsol");
	if(mxGetFieldNumber(pa, "mkl_gradient") != - 1){
		pa=mxGetField(pa,0, "mkl_gradient");
		amigo_problem->mkl_gradient=(int)mxGetPr(pa)[0];
	}else amigo_problem->mkl_gradient=0;

	pa=mxGetField(inputs_ptr,0, "nlpsol");
	if(mxGetFieldNumber(pa, "iterprint") != - 1){
		pa=mxGetField(pa,0, "iterprint");
		amigo_problem->verbose=(int)mxGetPr(pa)[0];
	}else amigo_problem->verbose=0;

	if (matClose(pmat) != 0) {
		printf("Error closing file %s\n",file);
		return(amigo_problem);
	}
	
	return(amigo_problem);

}

AMIGO_model* mxAllocateAMIGOmodel(mxArray* privstruct_ptr,mxArray* inputs_ptr, int exp_num){

	mxArray *pa;
	mxArray *cell_ptr;
	const mwSize  *dim;
	AMIGO_model* amigo_model;
	
	int n_states,n_observables,n_pars,n_opt_pars,n_times,n_opt_ics,n_controls,n_controls_t,i,j,counter;
	
	//inputs.model.n_st
	pa=mxGetField(inputs_ptr,0, "model");
	pa=mxGetField(pa,0, "n_st");
	n_states=mxGetPr(pa)[0];

	//N_OBS
	pa=mxGetField(privstruct_ptr,0, "n_obs");
	cell_ptr = mxGetCell(pa, exp_num);
	n_observables=(int)mxGetPr(cell_ptr)[0];

	//n pars
	pa=mxGetField(inputs_ptr,0, "model");
	pa=mxGetField(pa,0, "n_par");
	n_pars=(int)mxGetPr(pa)[0];

	//inputs.PEsol.n_theta
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0, "n_theta");
	n_opt_pars=(int)mxGetPr(pa)[0];

	// privstruct.n_s
	pa=mxGetField(privstruct_ptr,0, "n_s");
	cell_ptr = mxGetCell(pa, exp_num);
	n_times=(int)mxGetPr(cell_ptr)[0];
	//printf("n_times=%d\n",n_times);

	//inputs.PEsol.n_theta_y0
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0, "n_local_theta_y0");
	cell_ptr = mxGetCell(pa, exp_num);
	n_opt_ics=(int)mxGetPr(cell_ptr)[0];
	//printf("n_opt_ics=%d\n",n_opt_ics);

	//inputs.model.n_stimulus
	pa=mxGetField(inputs_ptr,0, "model");
	pa=mxGetField(pa,0, "n_stimulus");
	n_controls=(int)mxGetPr(pa)[0];
	//printf("n_controls=%d\n",n_controls);

	//privstruct.n_s
	pa=mxGetField(privstruct_ptr,0, "t_con");
	cell_ptr = mxGetCell(pa, exp_num);
	dim=mxGetDimensions(cell_ptr);
	n_controls_t=(int)dim[1];
	//printf("n_controls_t=%d\n",n_controls_t);

	amigo_model=allocate_AMIGO_model(n_states,n_observables,n_pars,
		n_opt_pars,n_times,n_opt_ics,n_controls, n_controls_t,exp_num);

	
	//privstruct.index_observablesY_0

	pa=mxGetField(privstruct_ptr,0, "index_observables");

	cell_ptr = mxGetCell(pa, exp_num);
	
	if(mxGetDimensions(cell_ptr)[0]<n_observables  && mxGetDimensions(cell_ptr)[1]<n_observables){

		amigo_model->use_obs_func=1;
		amigo_model->use_sens_obs_func=1;

	}else{

		for (i = 0; i < n_observables; i++){
			amigo_model->index_observables[i]=(int)mxGetPr(cell_ptr)[i]-1;
			//mexPrintf("%d\n",amigo_model->index_observables[i]);
		}
	}
	
	//Simulation Pars
	pa=mxGetField(inputs_ptr,0, "model");
	pa=mxGetField(pa,0, "par");
	for (i = 0; i < n_pars; i++){
		amigo_model->pars[i]=(double)mxGetPr(pa)[i];
		//mexPrintf("%f\n",amigo_model->pars[i]);
	}

	//inputs.PEsol.index_global_theta
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0, "index_global_theta");
	for (i = 0; i < n_opt_pars; i++){
		amigo_model->index_opt_pars[i]=(int)mxGetPr(pa)[i] - 1;
		//mexPrintf("%f\n",amigo_model->index_opt_pars[i]);
	}


	//inputs.PEsol.global_theta_guess
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0, "global_theta_guess");
	for (i = 0; i < n_opt_pars; i++){
		amigo_model->pars_guess[i]=(double)mxGetPr(pa)[i];
		//mexPrintf("%f\n",amigo_model->pars_guess[i]);
	}

	//inputs.PEsol.global_theta_min
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0, "global_theta_min");
	for (i = 0; i < n_opt_pars; i++){
		amigo_model->pars_LB[i]=(double)mxGetPr(pa)[i];
		//mexPrintf("%f\n",amigo_model->pars_LB[i]);
	}

	//inputs.PEsol.global_theta_max
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0, "global_theta_max");
	for (i = 0; i < n_opt_pars; i++){
		amigo_model->pars_UB[i]=(double)mxGetPr(pa)[i];
		//mexPrintf("%f\n",amigo_model->pars_UB[i]);
	}

	//Simulation times
	//inputs.exps.t_int{iexp}
	pa=mxGetField(privstruct_ptr,0, "t_in");
	cell_ptr = mxGetCell(pa, exp_num);
	amigo_model->t0=(double)mxGetPr(cell_ptr)[0];
	//mexPrintf("%f\n",amigo_model->t0);
	
	//privstruct.t_f{iexp}
	pa=mxGetField(privstruct_ptr,0, "t_f");
	cell_ptr = mxGetCell(pa, exp_num);
	amigo_model->tf=(double)mxGetPr(cell_ptr)[0];
	//mexPrintf("%f\n",amigo_model->tf);


	//privstruct.t_int{iexp}
	pa=mxGetField(privstruct_ptr,0, "t_int");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_times; i++){
		amigo_model->t[i]=(double)mxGetPr(cell_ptr)[i];
		//   mexPrintf("%f\n",amigo_model->t[i]);
	}
	
	

	//Initial conditions
	//inputs.exps.exp_y0
	pa=mxGetField(inputs_ptr,0, "exps");
	pa=mxGetField(pa,0, "exp_y0");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_states; i++){
		amigo_model->y0[i]=(double)mxGetPr(cell_ptr)[i];
		//mexPrintf("%f\n",amigo_model->y0[i]);
	}
	//inputs.PEsol.index_local_theta_y0{1}
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0,"index_local_theta_y0");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_opt_ics; i++){
		amigo_model->index_opt_ics[i]=(int)mxGetPr(cell_ptr)[i]-1;
		//mexPrintf("%d\n",amigo_model->index_opt_ics[i]);
	}

	//inputs.PEsol.local_theta_y0_guess{1,2,...}
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0,"local_theta_y0_guess");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_opt_ics; i++){
		amigo_model->y0_guess[i]=(double)mxGetPr(cell_ptr)[i];
		//mexPrintf("%f\n",amigo_model->y0_guess[i]);
	}
	
	//inputs.PEsol.local_theta_y0_min{1,2,...}
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0,"local_theta_y0_min");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_opt_ics; i++){
		amigo_model->y0_LB[i]=(double)mxGetPr(cell_ptr)[i];
		//mexPrintf("%f\n",amigo_model->y0_LB[i]);
	}


	//inputs.PEsol.local_theta_y0_max{1,2,...}
	pa=mxGetField(inputs_ptr,0, "PEsol");
	pa=mxGetField(pa,0,"local_theta_y0_max");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_opt_ics; i++){
		amigo_model->y0_UB[i]=(double)mxGetPr(cell_ptr)[i];
		//mexPrintf("%f\n",amigo_model->y0_UB[i]);
	}

	//Controls
	//privstruct.t_con{iexp}
	pa=mxGetField(privstruct_ptr,0, "t_con");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i <n_controls_t; i++){
		amigo_model->controls_t[i]=(double)mxGetPr(cell_ptr)[i];
		//mexPrintf("%f\n",amigo_model->controls_t[i]);
	}
	

	//privstruct.u{iexp}
	counter=0;
	pa=mxGetField(privstruct_ptr,0, "u");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_controls; i++) {
		for (j= 0; j < n_controls_t-1; j++){
			// mexPrintf("%d %d\n",i,j);
			amigo_model->controls_v[i][j]=(double)mxGetPr(cell_ptr)[counter++];
			//mexPrintf("%f\t",amigo_model->controls_v[i][j]);
		}
		//mexPrintf("\n");
	}
	
	//inputs.exps.pend{iexp}
	counter=0;
	pa=mxGetField(privstruct_ptr,0, "pend");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i= 0; i < amigo_model->n_controls; i++){
		for (j= 0; j < amigo_model->n_controls_t-1; j++){
			amigo_model->slope[i][j]=(double)mxGetPr(cell_ptr)[counter++];
			//    mexPrintf("%f\t",amigo_model->slope[i][j]);
		}
		//mexPrintf("\n");
	}

	
	//Storing matrixes
	counter=0;
	pa=mxGetField(privstruct_ptr,0, "exp_data");
	cell_ptr = mxGetCell(pa, exp_num);
	
	if (n_observables>0){

		if(mxGetNumberOfElements(cell_ptr)>0){

			for (i = 0; i < n_observables; i++){
				for (j = 0; j < n_times; j++){
					amigo_model->exp_data[i][j]=(double)mxGetPr(cell_ptr)[counter++];
				}
			}
		}
	}
	
	counter=0;
	pa=mxGetField(inputs_ptr,0, "exps");
	pa=mxGetField(pa,0, "Q");
	cell_ptr = mxGetCell(pa, exp_num);

	for (i = 0; i < n_observables; i++){
		for (j = 0; j < n_times; j++){
				amigo_model->Q[i][j]=(double)mxGetPr(cell_ptr)[counter++];
		}
		
	}
		
	

	counter=0;
	pa=mxGetField(privstruct_ptr,0, "w_obs");
	cell_ptr = mxGetCell(pa, exp_num);
	for (i = 0; i < n_observables; i++)
		amigo_model->w_obs[i]=(double)mxGetPr(cell_ptr)[counter++];

	//Simulation Related Parameter
	//inputs.ivpsol.rtol
	pa=mxGetField(inputs_ptr,0, "ivpsol");
	if(mxGetFieldNumber(pa, "rtol") != - 1){
		pa=mxGetField(pa,0, "rtol");
		amigo_model->reltol=(double)mxGetPr(pa)[0];
	}else amigo_model->reltol=1e-6;
	//mexPrintf("%e\n",amigo_model->reltol);
	
	//inputs.ivpsol.atol
	pa=mxGetField(inputs_ptr,0, "ivpsol");
	if(mxGetFieldNumber(pa, "atol") != - 1){
		pa=mxGetField(pa,0, "atol");
		amigo_model->atol=(double)mxGetPr(pa)[0];
	}else amigo_model->atol=1e-6;
	//mexPrintf("%e\n",amigo_model->atol);

	//privstruct.ivpsol.max_step_size
	pa=mxGetField(inputs_ptr,0, "ivpsol");
	if(mxGetFieldNumber(pa, "max_step_size") != - 1){
		pa=mxGetField(pa,0, "max_step_size");
		amigo_model->max_step_size=(double)mxGetPr(pa)[0];
	}else amigo_model->max_step_size==DBL_MAX;
	//mexPrintf("%f\n",amigo_model->max_step_size);

	//privstruct.ivpsol.max_num_steps
	pa=mxGetField(inputs_ptr,0, "ivpsol");
	if(mxGetFieldNumber(pa, "ivp_maxnumsteps") != - 1){
		pa=mxGetField(pa,0, "ivp_maxnumsteps");
		amigo_model->max_num_steps=(int)mxGetPr(pa)[0];
	}else amigo_model->max_num_steps=10000;
	//mexPrintf("%d\n",amigo_model->max_num_steps);


	//privstruct.ivpsol.max_error_test_fails
	pa=mxGetField(inputs_ptr,0, "ivpsol");
	if(mxGetFieldNumber(pa, "max_error_test_fails") != - 1){
		pa=mxGetField(pa,0, "max_error_test_fails");
		amigo_model->max_error_test_fails=(int)mxGetPr(pa)[0];
	}else amigo_model->max_error_test_fails=50;
	//mexPrintf("%d\n",amigo_model->max_error_test_fails);

	
	pa=mxGetField(inputs_ptr,0, "nlpsol");
	if(mxGetFieldNumber(pa, "mkl_tol") != - 1){
		pa=mxGetField(pa,0, "mkl_tol");
		amigo_model->mkl_tol=(double)mxGetPr(pa)[0];
	}


	return(amigo_model);
}

void mxSolveAMIGOivp(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*stats_ptr,*stats_value,*sim_data,*obs_data, *sim_cell,*stats_cell,*flag_cell,*observables_cell,*flag_value;
	const char *field_names[] = {"success", "simulation","observables","sim_stats"};
	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"};
	mwSize dims[2]={1,1};
	mwSize dims_cell[1];
	//MATFile *pmat;
	int i,j,k,counter;
	int* flag;

	outputs_ptr=mxCreateStructArray(1, dims,4,field_names);

	dims_cell[0]=amigo_problem->n_models;

	sim_cell=mxCreateCellArray(1,dims_cell);
	flag_cell=mxCreateCellArray(1,dims_cell);
	observables_cell=mxCreateCellArray(1,dims_cell);
	stats_cell=mxCreateCellArray(1,dims_cell);

	mxSetField(outputs_ptr, 0,"simulation", sim_cell);
	mxSetField(outputs_ptr, 0,"success", flag_cell);
	mxSetField(outputs_ptr, 0,"observables", observables_cell);
	mxSetField(outputs_ptr, 0,"sim_stats", stats_cell);

	flag=(int*)malloc(amigo_problem->n_models*sizeof(int));

	#pragma omp parallel num_threads(amigo_problem->nthreads)
    {
        #pragma omp for schedule(dynamic,1) private(i)
		for (i = 0; i < amigo_problem->n_models; ++i) {
			//0 For no sensitivity
			flag[i]=simulate_AMIGO_model_observables(amigo_problem->amigo_models[i],0);
			
		}	
	}


	for (i = 0; i < amigo_problem->n_models; i++){


		flag_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(flag_value)[0]=(double)flag[i];

		sim_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_states ,
			mxREAL
			);

		obs_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_observables,
			mxREAL
			);

		stats_ptr=mxCreateStructArray(1, dims,7,stats_names);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		mxSetCell(stats_cell,i, stats_ptr);
		mxSetCell(flag_cell,i, flag_value);
		mxSetCell(sim_cell, i, sim_data);
		mxSetCell(observables_cell, i, obs_data);

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_states; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(sim_data)[counter++]=amigo_problem->amigo_models[i]->sim_results[j][k];
			}
		}

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_observables; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(obs_data)[counter++]=amigo_problem->amigo_models[i]->obs_results[j][k];
			}
		}
	}

	free(flag);

	mxAMIGOsave2File(outputs_ptr,save2File);


	if(save2Workspace)
		mexPutVariable("caller", "outputs", outputs_ptr);
	else mxDestroyArray(outputs_ptr);
}

void mxSolveAMIGO_FSA(AMIGO_problem* amigo_problem, int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*sens_data,*stats_ptr,*stats_cell,*stats_value,*sim_data,*sens_cell, *sim_cell,*flag_cell,*flag_value;
	const char *field_names[] = {"success", "simulation","sensitivities","cvodes_stats"};
	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"
		,"nfSe","nfeS","nsetupsS","netfS","nniS","ncfnS"};

	mwSize dims[2]={1,1};
	mwSize dims_sens[3];
	mwSize dims_cell[1];
	int* flag;
	MATFile *pmat;

	int i,j,k,m,counter;

	outputs_ptr=mxCreateStructArray(1, dims,4,field_names);

	dims_cell[0]=amigo_problem->n_models;

	flag_cell=mxCreateCellArray(1,dims_cell);
	sim_cell=mxCreateCellArray(1,dims_cell);
	sens_cell=mxCreateCellArray(1,dims_cell);
	stats_cell=mxCreateCellArray(1,dims_cell);

	mxSetField(outputs_ptr, 0,"success", flag_cell);
	mxSetField(outputs_ptr, 0,"simulation", sim_cell);
	mxSetField(outputs_ptr, 0,"sensitivities", sens_cell);
	mxSetField(outputs_ptr, 0,"cvodes_stats", stats_cell);

	flag=(int*)malloc(amigo_problem->n_models*sizeof(int));


	#pragma omp parallel num_threads(amigo_problem->nthreads)
	{	
		#pragma omp for schedule(dynamic,1) private(i)
		for (i = 0; i < amigo_problem->n_models; i++){

			flag[i]=get_AMIGO_model_sens(amigo_problem->amigo_models[i],1,0);
			
		}
	}

	for (i = 0; i < amigo_problem->n_models; i++){
		flag_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(flag_value)[0]=(double)flag[i];

		dims_sens[0]=amigo_problem->amigo_models[i]->n_times;
		dims_sens[1]=amigo_problem->amigo_models[i]->n_states;
		dims_sens[2]=amigo_problem->amigo_models[i]->n_total_x;

		sens_data=mxCreateNumericArray(3,dims_sens,mxDOUBLE_CLASS, mxREAL);

		sim_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_states ,
			mxREAL
			);

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_states; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(sim_data)[counter++]=amigo_problem->amigo_models[i]->sim_results[j][k];
			}
		}

		counter=0;
		for (m = 0; m < amigo_problem->amigo_models[i]->n_total_x; m++){
			for (j = 0; j < amigo_problem->amigo_models[i]->n_states; j++){
				for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
					mxGetPr(sens_data)[counter++]=amigo_problem->amigo_models[i]->sens_results[j][m][k];
				}
			}
		}

		stats_ptr=mxCreateStructArray(1, dims,13,stats_names);
		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nfSe;
		mxSetField(stats_ptr, 0,"nfSe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nfeS;
		mxSetField(stats_ptr, 0,"nfeS", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->netfS;
		mxSetField(stats_ptr, 0,"netfS", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nniS;
		mxSetField(stats_ptr, 0,"nniS", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->ncfnS;
		mxSetField(stats_ptr, 0,"ncfnS", stats_value);

		mxSetCell(stats_cell,i, stats_ptr);
		mxSetCell(flag_cell,i, flag_value);
		mxSetCell(sim_cell, i, sim_data);
		mxSetCell(sens_cell, i, sens_data);
	}
	free(flag);
	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace)
		mexPutVariable("caller", "outputs", outputs_ptr);
	else mxDestroyArray(outputs_ptr);
}

void mxSolveAMIGO_MKLSENS(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*sens_data,*sim_data,*sens_cell, *sim_cell,*flag_cell,*flag_value;
	const char *field_names[] = {"success", "simulation","sensitivities"};


	mwSize dims[2]={1,1};
	mwSize dims_sens[3];
	mwSize dims_cell[1];
	// MATFile *pmat;
	int i,j,k,m,flag,counter;

	outputs_ptr=mxCreateStructArray(1, dims,3,field_names);

	dims_cell[0]=amigo_problem->n_models;

	flag_cell=mxCreateCellArray(1,dims_cell);
	sim_cell=mxCreateCellArray(1,dims_cell);
	sens_cell=mxCreateCellArray(1,dims_cell);

	mxSetField(outputs_ptr, 0,"success", flag_cell);
	mxSetField(outputs_ptr, 0,"simulation", sim_cell);
	mxSetField(outputs_ptr, 0,"sensitivities", sens_cell);

	for (i = 0; i < amigo_problem->n_models; i++){

#ifdef MKL
		//last flag
		flag=get_AMIGO_model_sens(amigo_problem->amigo_models[i],0,1);
#else
		mexPrintf("Compile using MKL library and try again.");
		printf("Compile using MKL library and try again.");
		mexErrMsgTxt("Compile using MKL library and try again.");
#endif

		flag_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(flag_value)[0]=(double)flag;

		dims_sens[0]=amigo_problem->amigo_models[i]->n_times;
		dims_sens[1]=amigo_problem->amigo_models[i]->n_states;
		dims_sens[2]=amigo_problem->amigo_models[i]->n_total_x;

		sens_data=mxCreateNumericArray(3,dims_sens,mxDOUBLE_CLASS, mxREAL);

		sim_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_states ,
			mxREAL
			);

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_states; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(sim_data)[counter++]=amigo_problem->amigo_models[i]->sim_results[j][k];
			}
		}

		counter=0;
		for (m = 0; m < amigo_problem->amigo_models[i]->n_total_x; m++){
			for (j = 0; j < amigo_problem->amigo_models[i]->n_states; j++){
				for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
					mxGetPr(sens_data)[counter++]=amigo_problem->amigo_models[i]->sens_results[j][m][k];
				}
			}
		}

		mxSetCell(flag_cell,i, flag_value);
		mxSetCell(sim_cell, i, sim_data);
		mxSetCell(sens_cell, i, sens_data);
	}

	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace)
		mexPutVariable("caller", "outputs", outputs_ptr);
	else mxDestroyArray(outputs_ptr);

}

void mxSolveAMIGOnl2sol(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){


	mxArray *outputs_ptr,*xbest,*fbest,*nevals,*flag, *fails_cell, *stats_ptr, *stats_value,*observables_cell,*obs_data,*par;
	const char *field_names[] = {"par","xbest", "fbest", "nfevals","fail_stats","observables","flag"};
	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"
		,"nfSe","nfeS","nsetupsS","netfS","nniS","ncfnS"};

	mwSize dims[2]={1,1};
	int i,j,k,counter,total_par_size, n_model_pars, n_ics;
	mwSize dims_cell[1];
	mwSize dims_obs_cell[1];

	dims_obs_cell[0]=amigo_problem->n_models;

	if(amigo_problem->cvodes_gradient || amigo_problem->mkl_gradient)
		NL2SOL_AMIGO_pe(amigo_problem,1);
	else
		NL2SOL_AMIGO_pe(amigo_problem,0);

	outputs_ptr=mxCreateStructArray(1,dims,7,field_names);

	n_model_pars=amigo_problem->amigo_models[0]->n_pars;
	n_ics=amigo_problem->n_ics;
	total_par_size=n_model_pars+n_ics;

	xbest=mxCreateDoubleMatrix(1,amigo_problem->nx,mxREAL);
	par=mxCreateDoubleMatrix(1,total_par_size,mxREAL);
	fbest=mxCreateDoubleMatrix(1,1,mxREAL);
	nevals=mxCreateDoubleMatrix(1,1,mxREAL);
	observables_cell=mxCreateCellArray(1,dims_obs_cell);

	counter=0;

	for (i = 0;  i < amigo_problem->nx; i++){
		mxGetPr(xbest)[i]=amigo_problem->xbest[i];
	}

	for (i = 0;  i < amigo_problem->amigo_models[0]->n_pars; i++){
		mxGetPr(par)[i]=amigo_problem->amigo_models[0]->pars[i];
	}

	for (i = 0;  i < amigo_problem->n_pars; i++){
		mxGetPr(par)
			[amigo_problem->amigo_models[0]->index_opt_pars[i]]=amigo_problem->xbest[i];
		counter++;
	}

	for (i = n_model_pars;  i < total_par_size; i++){
		mxGetPr(par)[i]=amigo_problem->xbest[counter++];
	}

	mxGetPr(fbest)[0]=amigo_problem->local_fbest;
	mxGetPr(nevals)[0]=amigo_problem->local_nfeval;

	dims_cell[0]=amigo_problem->n_stored_fails;
	fails_cell=mxCreateCellArray(1,dims_cell);


	for (i = 0; i < amigo_problem->n_stored_fails; i++){


		stats_ptr=mxCreateStructArray(1, dims,13,stats_names);
		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		if(amigo_problem->amigo_stats_containers[i]->sens){

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfSe;
			mxSetField(stats_ptr, 0,"nfSe", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfeS;
			mxSetField(stats_ptr, 0,"nfeS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netfS;
			mxSetField(stats_ptr, 0,"netfS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nniS;
			mxSetField(stats_ptr, 0,"nniS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfnS;
			mxSetField(stats_ptr, 0,"ncfnS", stats_value);
		}

		mxSetCell(fails_cell,i, stats_ptr);

	}

	for (i = 0; i < amigo_problem->n_models; i++){

		obs_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_observables,
			mxREAL
			);

		mxSetCell(observables_cell, i, obs_data);

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_observables; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(obs_data)[counter++]=amigo_problem->amigo_models[i]->obs_results[j][k];
			}
		}

	}

	flag=mxCreateDoubleMatrix(1,1,mxREAL);

	mxGetPr(flag)[0]=(double)amigo_problem->local_flag;

	mxSetField(outputs_ptr, 0,"par", par);
	mxSetField(outputs_ptr, 0,"xbest", xbest);
	mxSetField(outputs_ptr, 0,"fbest", fbest);
	mxSetField(outputs_ptr, 0,"nfevals", nevals);
	mxSetField(outputs_ptr, 0,"fail_stats", fails_cell);
	mxSetField(outputs_ptr, 0,"observables", observables_cell);
	mxSetField(outputs_ptr, 0,"flag", flag);

	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace){
		mexPutVariable("caller", "outputs", outputs_ptr);
	}
	else mxDestroyArray(outputs_ptr);

}


void mxSolveAMIGOsres(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*xbest,*fbest,*nevals,*flag, *fails_cell, *stats_ptr, *stats_value,*observables_cell,*obs_data,*par;
	const char *field_names[] = {"par","xbest", "fbest", "nfevals","fail_stats","observables","flag"};
	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"
		,"nfSe","nfeS","nsetupsS","netfS","nniS","ncfnS"};

	mwSize dims[2]={1,1};
	int i,j,k,counter,total_par_size, n_model_pars, n_ics;
	mwSize dims_cell[1];
	mwSize dims_obs_cell[1];

	dims_obs_cell[0]=amigo_problem->n_models;

	//sres_AMIGO_pe(amigo_problem);

	outputs_ptr=mxCreateStructArray(1,dims,7,field_names);

	n_model_pars=amigo_problem->amigo_models[0]->n_pars;
	n_ics=amigo_problem->n_ics;
	total_par_size=n_model_pars+n_ics;

	xbest=mxCreateDoubleMatrix(1,amigo_problem->nx,mxREAL);
	par=mxCreateDoubleMatrix(1,total_par_size,mxREAL);
	fbest=mxCreateDoubleMatrix(1,1,mxREAL);
	nevals=mxCreateDoubleMatrix(1,1,mxREAL);
	observables_cell=mxCreateCellArray(1,dims_obs_cell);

	counter=0;

	for (i = 0;  i < amigo_problem->nx; i++){
		mxGetPr(xbest)[i]=amigo_problem->xbest[i];
	}

	for (i = 0;  i < amigo_problem->amigo_models[0]->n_pars; i++){
		mxGetPr(par)[i]=amigo_problem->amigo_models[0]->pars[i];
	}

	for (i = 0;  i < amigo_problem->n_pars; i++){
		mxGetPr(par)
			[amigo_problem->amigo_models[0]->index_opt_pars[i]]=amigo_problem->xbest[i];
		counter++;
	}

	for (i = n_model_pars;  i < total_par_size; i++){
		mxGetPr(par)[i]=amigo_problem->xbest[counter++];
	}

	mxGetPr(fbest)[0]=amigo_problem->local_fbest;
	mxGetPr(nevals)[0]=amigo_problem->nevals;

	dims_cell[0]=amigo_problem->n_stored_fails;
	fails_cell=mxCreateCellArray(1,dims_cell);


	for (i = 0; i < amigo_problem->n_stored_fails; i++){


		stats_ptr=mxCreateStructArray(1, dims,13,stats_names);
		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		if(amigo_problem->amigo_stats_containers[i]->sens){

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfSe;
			mxSetField(stats_ptr, 0,"nfSe", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfeS;
			mxSetField(stats_ptr, 0,"nfeS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netfS;
			mxSetField(stats_ptr, 0,"netfS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nniS;
			mxSetField(stats_ptr, 0,"nniS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfnS;
			mxSetField(stats_ptr, 0,"ncfnS", stats_value);
		}

		mxSetCell(fails_cell,i, stats_ptr);

	}

	for (i = 0; i < amigo_problem->n_models; i++){

		obs_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_observables,
			mxREAL
			);

		mxSetCell(observables_cell, i, obs_data);

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_observables; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(obs_data)[counter++]=amigo_problem->amigo_models[i]->obs_results[j][k];
			}
		}

	}

	flag=mxCreateDoubleMatrix(1,1,mxREAL);

	mxGetPr(flag)[0]=(double)amigo_problem->local_flag;

	mxSetField(outputs_ptr, 0,"par", par);
	mxSetField(outputs_ptr, 0,"xbest", xbest);
	mxSetField(outputs_ptr, 0,"fbest", fbest);
	mxSetField(outputs_ptr, 0,"nfevals", nevals);
	mxSetField(outputs_ptr, 0,"fail_stats", fails_cell);
	mxSetField(outputs_ptr, 0,"observables", observables_cell);
	mxSetField(outputs_ptr, 0,"flag", flag);

	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace){
		mexPutVariable("caller", "outputs", outputs_ptr);
	}
	else mxDestroyArray(outputs_ptr);

}

void mxSolveAMIGOde(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*xbest,*fbest,*nevals,*flag, *fails_cell, *stats_ptr, *stats_value,*observables_cell,*obs_data,*par;
	const char *field_names[] = {"par","xbest", "fbest", "nfevals","fail_stats","observables","flag"};
	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"
		,"nfSe","nfeS","nsetupsS","netfS","nniS","ncfnS"};

	mwSize dims[2]={1,1};
	int i,j,k,counter,total_par_size, n_model_pars, n_ics;
	mwSize dims_cell[1];
	mwSize dims_obs_cell[1];

	dims_obs_cell[0]=amigo_problem->n_models;

	DE_AMIGO_pe(amigo_problem);

	outputs_ptr=mxCreateStructArray(1,dims,7,field_names);

	n_model_pars=amigo_problem->amigo_models[0]->n_pars;
	n_ics=amigo_problem->n_ics;
	total_par_size=n_model_pars+n_ics;

	xbest=mxCreateDoubleMatrix(1,amigo_problem->nx,mxREAL);
	par=mxCreateDoubleMatrix(1,total_par_size,mxREAL);
	fbest=mxCreateDoubleMatrix(1,1,mxREAL);
	nevals=mxCreateDoubleMatrix(1,1,mxREAL);
	observables_cell=mxCreateCellArray(1,dims_obs_cell);

	counter=0;

	for (i = 0;  i < amigo_problem->nx; i++){
		mxGetPr(xbest)[i]=amigo_problem->xbest[i];
	}

	for (i = 0;  i < amigo_problem->amigo_models[0]->n_pars; i++){
		mxGetPr(par)[i]=amigo_problem->amigo_models[0]->pars[i];
	}

	for (i = 0;  i < amigo_problem->n_pars; i++){
		mxGetPr(par)
			[amigo_problem->amigo_models[0]->index_opt_pars[i]]=amigo_problem->xbest[i];
		counter++;
	}

	for (i = n_model_pars;  i < total_par_size; i++){
		mxGetPr(par)[i]=amigo_problem->xbest[counter++];
	}

	mxGetPr(fbest)[0]=amigo_problem->local_fbest;
	mxGetPr(nevals)[0]=amigo_problem->nevals;

	dims_cell[0]=amigo_problem->n_stored_fails;
	fails_cell=mxCreateCellArray(1,dims_cell);


	for (i = 0; i < amigo_problem->n_stored_fails; i++){


		stats_ptr=mxCreateStructArray(1, dims,13,stats_names);
		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		if(amigo_problem->amigo_stats_containers[i]->sens){

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfSe;
			mxSetField(stats_ptr, 0,"nfSe", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfeS;
			mxSetField(stats_ptr, 0,"nfeS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netfS;
			mxSetField(stats_ptr, 0,"netfS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nniS;
			mxSetField(stats_ptr, 0,"nniS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfnS;
			mxSetField(stats_ptr, 0,"ncfnS", stats_value);
		}

		mxSetCell(fails_cell,i, stats_ptr);

	}

	for (i = 0; i < amigo_problem->n_models; i++){

		obs_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_observables,
			mxREAL
			);

		mxSetCell(observables_cell, i, obs_data);

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_observables; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(obs_data)[counter++]=amigo_problem->amigo_models[i]->obs_results[j][k];
			}
		}
	}

	flag=mxCreateDoubleMatrix(1,1,mxREAL);

	mxGetPr(flag)[0]=(double)amigo_problem->local_flag;

	mxSetField(outputs_ptr, 0,"par", par);
	mxSetField(outputs_ptr, 0,"xbest", xbest);
	mxSetField(outputs_ptr, 0,"fbest", fbest);
	mxSetField(outputs_ptr, 0,"nfevals", nevals);
	mxSetField(outputs_ptr, 0,"fail_stats", fails_cell);
	mxSetField(outputs_ptr, 0,"observables", observables_cell);
	mxSetField(outputs_ptr, 0,"flag", flag);

	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace){
		mexPutVariable("caller", "outputs", outputs_ptr);
	}
	else mxDestroyArray(outputs_ptr);

}

void mxSolveAMIGOdhc(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*xbest,*fbest,*nevals,*flag, *fails_cell, *stats_ptr, *stats_value,*observables_cell,*obs_data,*par;
	const char *field_names[] = {"par","xbest", "fbest", "nfevals","fail_stats","observables","flag"};
	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"
		,"nfSe","nfeS","nsetupsS","netfS","nniS","ncfnS"};

	mwSize dims[2]={1,1};
	int i,j,k,counter,total_par_size, n_model_pars, n_ics;
	mwSize dims_cell[1];
	mwSize dims_obs_cell[1];

	dims_obs_cell[0]=amigo_problem->n_models;
	/*
	DE_AMIGO_pe(amigo_problem);

	outputs_ptr=mxCreateStructArray(1,dims,7,field_names);

	n_model_pars=amigo_problem->amigo_models[0]->n_pars;
	n_ics=amigo_problem->n_ics;
	total_par_size=n_model_pars+n_ics;

	xbest=mxCreateDoubleMatrix(1,amigo_problem->nx,mxREAL);
	par=mxCreateDoubleMatrix(1,total_par_size,mxREAL);
	fbest=mxCreateDoubleMatrix(1,1,mxREAL);
	nevals=mxCreateDoubleMatrix(1,1,mxREAL);
	observables_cell=mxCreateCellArray(1,dims_obs_cell);

	counter=0;

	for (i = 0;  i < amigo_problem->nx; i++){
		mxGetPr(xbest)[i]=amigo_problem->xbest[i];
	}

	for (i = 0;  i < amigo_problem->amigo_models[0]->n_pars; i++){
		mxGetPr(par)[i]=amigo_problem->amigo_models[0]->pars[i];
	}

	for (i = 0;  i < amigo_problem->n_pars; i++){
		mxGetPr(par)
			[amigo_problem->amigo_models[0]->index_opt_pars[i]]=amigo_problem->xbest[i];
		counter++;
	}

	for (i = n_model_pars;  i < total_par_size; i++){
		mxGetPr(par)[i]=amigo_problem->xbest[counter++];
	}

	mxGetPr(fbest)[0]=amigo_problem->local_fbest;
	mxGetPr(nevals)[0]=amigo_problem->nevals;

	dims_cell[0]=amigo_problem->n_stored_fails;
	fails_cell=mxCreateCellArray(1,dims_cell);


	for (i = 0; i < amigo_problem->n_stored_fails; i++){


		stats_ptr=mxCreateStructArray(1, dims,13,stats_names);
		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		if(amigo_problem->amigo_stats_containers[i]->sens){

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfSe;
			mxSetField(stats_ptr, 0,"nfSe", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nfeS;
			mxSetField(stats_ptr, 0,"nfeS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->netfS;
			mxSetField(stats_ptr, 0,"netfS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->nniS;
			mxSetField(stats_ptr, 0,"nniS", stats_value);

			stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
			mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_stats_containers[i]->ncfnS;
			mxSetField(stats_ptr, 0,"ncfnS", stats_value);
		}

		mxSetCell(fails_cell,i, stats_ptr);

	}

	for (i = 0; i < amigo_problem->n_models; i++){

		obs_data=mxCreateDoubleMatrix(
			amigo_problem->amigo_models[i]->n_times ,
			amigo_problem->amigo_models[i]->n_observables,
			mxREAL
			);

		mxSetCell(observables_cell, i, obs_data);

		counter=0;
		for (j = 0; j < amigo_problem->amigo_models[i]->n_observables; j++){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; k++){
				mxGetPr(obs_data)[counter++]=amigo_problem->amigo_models[i]->obs_results[j][k];
			}
		}
	}

	flag=mxCreateDoubleMatrix(1,1,mxREAL);

	mxGetPr(flag)[0]=(double)amigo_problem->local_flag;

	mxSetField(outputs_ptr, 0,"par", par);
	mxSetField(outputs_ptr, 0,"xbest", xbest);
	mxSetField(outputs_ptr, 0,"fbest", fbest);
	mxSetField(outputs_ptr, 0,"nfevals", nevals);
	mxSetField(outputs_ptr, 0,"fail_stats", fails_cell);
	mxSetField(outputs_ptr, 0,"observables", observables_cell);
	mxSetField(outputs_ptr, 0,"flag", flag);

	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace){
		mexPutVariable("caller", "outputs", outputs_ptr);
	}
	else mxDestroyArray(outputs_ptr);*/

}


void mxEvalAMIGOlsq(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*stats_ptr,*stats_value,*f_value,*stats_cell,*res_val,*flag_cell,*flag_value;

	const char *field_names[] = {"success", "f","w_res","sim_stats"};

	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"};

	mwSize dims[2]={1,1};
	mwSize dims_cell[1];


	int i,j,k,flag,counter;

	outputs_ptr=mxCreateStructArray(1, dims,4,field_names);

	dims_cell[0]=amigo_problem->n_models;

	f_value=mxCreateDoubleMatrix(1,1,mxREAL);
	flag_cell=mxCreateCellArray(1,dims_cell);
	stats_cell=mxCreateCellArray(1,dims_cell);

	res_val=mxCreateDoubleMatrix(amigo_problem->n_data,1,mxREAL); 

	mxSetField(outputs_ptr, 0,"f", f_value);
	mxSetField(outputs_ptr, 0,"success", flag_cell);
	mxSetField(outputs_ptr, 0,"w_res", res_val);
	mxSetField(outputs_ptr, 0,"sim_stats", stats_cell);

	mxGetPr(f_value)[0]=(double)eval_AMIGO_problem_LSQ(amigo_problem);

	counter=0;
	for (i = 0; i < amigo_problem->n_models; ++i) {

		for (j = 0; j < amigo_problem->amigo_models[i]->n_observables; ++j) {

			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; ++k) {

				if(!isnan(amigo_problem->amigo_models[i]->exp_data[j][k]) &&
					!isnan(amigo_problem->amigo_models[i]->Q[j][k])	 &&
					amigo_problem->amigo_models[i]->amigo_model_stats->error_flag>=0){

						mxGetPr(res_val)[counter++]=
							(amigo_problem->amigo_models[i]->obs_results[j][k]-
							amigo_problem->amigo_models[i]->exp_data[j][k])
							*amigo_problem->amigo_models[i]->Q[j][k];


				}else if(amigo_problem->amigo_models[i]->amigo_model_stats->error_flag<0){
					mxGetPr(res_val)[counter++]=DBL_MAX;
				}else{
					mxGetPr(res_val)[counter++]=0;
				}
			}
		}
	}

	for (i = 0; i < amigo_problem->n_models; i++){

		flag_value=mxCreateDoubleMatrix(1,1,mxREAL);   

		if(amigo_problem->amigo_models[i]->amigo_model_stats->error_flag==0)
			mxGetPr(flag_value)[0]=(double)1;
		else
			mxGetPr(flag_value)[0]=(double)0;

		stats_ptr=mxCreateStructArray(1, dims,7,stats_names);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		mxSetCell(stats_cell,i, stats_ptr);
		mxSetCell(flag_cell,i, flag_value);
	}

	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace){
		mexPutVariable("caller", "outputs", outputs_ptr);
	}
	else mxDestroyArray(outputs_ptr);
}

void mxEvalAMIGOllk(AMIGO_problem* amigo_problem,int save2Workspace, char* save2File){

	mxArray *outputs_ptr,*stats_ptr,*stats_value,*f_value,*stats_cell,*flag_cell,*flag_value,*res_val;

	const char *field_names[] = {"success", "f","w_res","sim_stats"};

	const char *stats_names[] = {"flag","nst","nfe","nsetups","netf","nni","ncfn"};

	mwSize dims[2]={1,1};
	mwSize dims_cell[1];

	int i,j,k,flag,counter;

	outputs_ptr=mxCreateStructArray(1, dims,4,field_names);

	dims_cell[0]=amigo_problem->n_models;

	res_val=mxCreateDoubleMatrix(amigo_problem->n_data,1,mxREAL); 

	f_value=mxCreateDoubleMatrix(1,1,mxREAL);
	flag_cell=mxCreateCellArray(1,dims_cell);
	stats_cell=mxCreateCellArray(1,dims_cell);

	mxSetField(outputs_ptr, 0,"f", f_value);
	mxSetField(outputs_ptr, 0,"success", flag_cell);
	mxSetField(outputs_ptr, 0,"sim_stats", stats_cell);
	mxSetField(outputs_ptr, 0,"w_res", res_val);

	mxGetPr(f_value)[0]=(double)eval_AMIGO_problem_LLK(amigo_problem);

	counter=0;
	for (i = 0; i < amigo_problem->n_models; ++i) {

		for (j = 0; j < amigo_problem->amigo_models[i]->n_observables; ++j) {

			for (k = 0; k < amigo_problem->amigo_models[i]->n_times; ++k) {

				if(!isnan(amigo_problem->amigo_models[i]->exp_data[j][k]) &&
					!isnan(amigo_problem->amigo_models[i]->Q[j][k])	 &&
					amigo_problem->amigo_models[i]->amigo_model_stats->error_flag>=0){

						mxGetPr(res_val)[counter++]=
							(amigo_problem->amigo_models[i]->obs_results[j][k]-
							amigo_problem->amigo_models[i]->exp_data[j][k])
							/amigo_problem->amigo_models[i]->Q[j][k];


				}else if(amigo_problem->amigo_models[i]->amigo_model_stats->error_flag<0){
					mxGetPr(res_val)[counter++]=DBL_MAX;
				}else{
					mxGetPr(res_val)[counter++]=0;
				}
			}
		}
	}


	for (i = 0; i < amigo_problem->n_models; i++){

		flag_value=mxCreateDoubleMatrix(1,1,mxREAL);   
		
		if(amigo_problem->amigo_models[i]->amigo_model_stats->error_flag==0)
			mxGetPr(flag_value)[0]=(double)1;
		else
			mxGetPr(flag_value)[0]=(double)0;

		stats_ptr=mxCreateStructArray(1, dims,7,stats_names);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->error_flag;
		mxSetField(stats_ptr, 0,"flag", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nst;
		mxSetField(stats_ptr, 0,"nst", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nfe;
		mxSetField(stats_ptr, 0,"nfe", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nsetups;
		mxSetField(stats_ptr, 0,"nsetups", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->netf;
		mxSetField(stats_ptr, 0,"netf", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->nni;
		mxSetField(stats_ptr, 0,"nni", stats_value);

		stats_value=mxCreateDoubleMatrix(1,1,mxREAL);
		mxGetPr(stats_value)[0]=(double)amigo_problem->amigo_models[i]->amigo_model_stats->ncfn;
		mxSetField(stats_ptr, 0,"ncfn", stats_value);

		mxSetCell(stats_cell,i, stats_ptr);
		mxSetCell(flag_cell,i, flag_value);

	}

	mxAMIGOsave2File(outputs_ptr,save2File);

	if(save2Workspace){
		mexPutVariable("caller", "outputs", outputs_ptr);
	}
	else mxDestroyArray(outputs_ptr);
}

int mxAMIGOsave2File(mxArray *outputs_ptr,char* save2File){

	MATFile *pmat;

	if(strcmp(save2File,"")){
		pmat = matOpen(save2File, "w");
		if (pmat == NULL) {
			printf("Error creating file %s\n", save2File);
			printf("(Do you have write permission in this directory?)\n");
			return(EXIT_FAILURE);
		}

		matPutVariable(pmat, "outputs", outputs_ptr);

		if (matClose(pmat) != 0) {
			printf("Error closing file %s\n",save2File);
			return(EXIT_FAILURE);
		}
	}
	return(EXIT_SUCCESS);
}
