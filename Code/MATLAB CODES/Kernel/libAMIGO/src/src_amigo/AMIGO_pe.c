#include <AMIGO_pe.h>

int NL2SOL_AMIGO_pe(AMIGO_problem* amigo_problem, int gradient){

	integer i, counter;
	integer ui[2];
	integer liv, lty, lv, n, p, one=1, printLevel;
	integer* IV;
	doublereal *TY, *B, *X, *V;
	static doublereal big;
	double test;

	lty=10;
	p = amigo_problem->nx;
	n = amigo_problem->n_data;
	printLevel=1;

	//LIV GIVES THE LENGTH OF IV.  IT MUST BE AT LEAST 82 + 4*P.
	liv=4*p+82;
	IV=(integer*)malloc(liv*sizeof(integer));
	TY=(doublereal*)malloc(2*sizeof(doublereal));

	//LV GIVES THE LENGTH OF V.  THE MINIMUM VALUE
	//FOR LV IS LV0 = 105 + P*(N + 2*P + 21) + 2*N
	lv=105+p*(n+2*p+21)+2*n;	

	V=(doublereal*)malloc(lv*sizeof(doublereal));

	X=(doublereal*)malloc(sizeof(doublereal)*p);
	
	ui[0] = 0;
	ui[1] = 0;
	//Set Options
	//DFAULT(iv,v);								//set defaults (OLD v2.2)
	divset_(&one,IV,&liv,&lv,V);
	IV[13] = IV[14] = 0;						//no covar
	IV[16] = amigo_problem->local_max_evals;	//limit on fevals + gevals
	IV[17] = amigo_problem->local_max_iter;		//max iter
	//IV[18] = 1;								//no iteration printing
	//IV[19] = 1;									//no default printing
	//IV[20] = 1;								//no output unit printing
	//IV[21] = 1;									//no x printing
	//IV[22] = 1;									//no summary printing
	//IV[23] = 1;									//no initial printing
	//v[30] = fatol;   
	//v[31] = frtol;
	//V[31] = 1e-9f;
	//V[32] = 1e-9f;
	
    //MEX Options 

	//The circadian problem fails if you don't specify this
	V[33] = 1e-9f;

	V[41] = 0.0046; // V(DLTFDC) Default = MACHEP^1/3. error tolerance in CVODES 1e-7, 1e-7^-3=0.0046
    V[42] = 3.1623e-4; // V(DLTFDJ) Default = MACHEP^1/2  error tolerance in CVODES 1e-7  1e-7^-2=3.1623e-4

	ui[1] = printLevel;
	for (i = 0; i < p; ++i) {
		X[i]=amigo_problem->x0[i];
	}

	B=(doublereal*)malloc(2*p*sizeof(doublereal));

	counter=0;
	for (i = 0; i < p; ++i) {

		B[counter++]=amigo_problem->LB[i];
		B[counter++]=amigo_problem->UB[i];
	}

	if(gradient){
		dn2gb_(&n, &p, X, B, IV, &liv, &lv, V, ui, TY, amigo_problem);
	}else{
		dn2fb_(&n, &p, X, B, IV, &liv, &lv, V, ui, TY, amigo_problem);
	}
	//Final Rnorm
	amigo_problem->local_fbest = V[9]*2; //nl2sol uses 1/2 sum(resid^2)
	//Save Status & Iterations
	amigo_problem->local_flag=IV[0];
	amigo_problem->local_niter=IV[30];

	for (i = 0; i < p; ++i) {
		amigo_problem->xbest[i]=X[i];
	}

	set_AMIGO_problem_pars(X, amigo_problem);

	eval_AMIGO_problem_LSQ(amigo_problem);

	free(B);
	free(X);
	free(IV);
	free(V);

	return 0;
} 


int calcr_(int *n, int *p, double *x, int *nf, double *r__, 
	int *lty, double *ty, void*data)
{

	int i, j, k, n_exps, n_times, n_obs,flag;
	int counter=0;
	double sum=0;

	AMIGO_problem* amigo_problem=(AMIGO_problem*) data;
	amigo_problem->nevals++;
	amigo_problem->local_nfeval++;
	set_AMIGO_problem_pars(x, amigo_problem);
	n_exps=amigo_problem->n_models;

	for (i = 0; i < n_exps; ++i) {
		
		//0 For no sensitivity
		flag=simulate_AMIGO_model_observables(amigo_problem->amigo_models[i],0);

		n_obs=amigo_problem->amigo_models[i]->n_observables;

		if(!flag){
			for (k = 0; k < amigo_problem->amigo_models[i]->n_pars; ++k) {
			//	mexPrintf("%e\t",amigo_problem->amigo_models[k]->pars[i]);
			}
			//mexPrintf("\n");

			handle_AMIGO_problem_stat_fails(i, amigo_problem);
			for (i = 0; i < n_exps; ++i) {
				for (j = 0; j < n_obs; ++j) {
					n_times=amigo_problem->amigo_models[i]->n_times;
					for (k = 0; k < n_times; ++k) {
						r__[counter++]=DBL_MAX;	
					}
				}
			}
			if(amigo_problem->verbose){
				#ifdef MATLAB
					mexPrintf("Eval-%d Simulation failed\n",amigo_problem->nevals);
				#else
					printf("Eval-%d Simulation failed\n",amigo_problem->nevals);
				#endif
			}

			return(0);
		}

		for (j = 0; j < n_obs; ++j) {
			n_times=amigo_problem->amigo_models[i]->n_times;
			for (k = 0; k < n_times; ++k) {
				if( !isnan(amigo_problem->amigo_models[i]->exp_data[j][k]) &&
								!isnan(amigo_problem->amigo_models[i]->Q[j][k]) && 
											amigo_problem->amigo_models[i]->Q[j][k]!=0){
				r__[counter++]=
					(amigo_problem->amigo_models[i]->obs_results[j][k]-
					amigo_problem->amigo_models[i]->exp_data[j][k])*
					amigo_problem->amigo_models[i]->Q[j][k];
				sum+=pow(r__[counter-1],2);
				}else {
						r__[counter++]=0;
				}
			}
		}
	}
	if(amigo_problem->verbose){
	#ifdef MATLAB
			mexPrintf("Eval %d f=%f\n",amigo_problem->nevals,sum);
	#else
		printf("Eval %d f=%f\n",amigo_problem->nevals,sum);
	#endif
	}
	
	return(0);
}

int calcj_(int *n, int* p, double *x, int *nf, double *dr__, int *lty, double *ty, void*data){

	int i, j, k, m, n_exps, n_times, n_obs;
	int counter=0;
	int n_ics=0,count_ic=0,flag;

	AMIGO_problem* amigo_problem=(AMIGO_problem*) data;

	n_exps=amigo_problem->n_models;
	//If sensitivity is activated use it 
	set_AMIGO_problem_pars(x, amigo_problem);

	for (i = 0; i < n_exps; ++i) {
		
#ifdef MKL
		flag=get_AMIGO_model_sens(amigo_problem->amigo_models[i],amigo_problem->cvodes_gradient,amigo_problem->mkl_gradient);  
#else
		flag=get_AMIGO_model_sens(amigo_problem->amigo_models[i],1,0); 
#endif

		if(!flag){
			handle_AMIGO_problem_stat_fails(i, amigo_problem);
			counter=0;
			for (m = 0; m < *p; ++m){
				
				for (i = 0; i < n_exps; ++i){
					n_obs=amigo_problem->amigo_models[i]->n_observables;

					for (j = 0; j < n_obs; ++j) {
						n_times=amigo_problem->amigo_models[i]->n_times;

						for (k = 0; k < n_times; ++k) {
							dr__[counter++]=0;
						}
					}

				}
			}
			
			if(amigo_problem->verbose){
				#ifdef MATLAB
					(int)mexPrintf("Gradient failed\n");
				#else
					printf("Gradient failed\n");		
				#endif
				
			}	
			
			return(0);
		}
	}

	for (m = 0; m < *p; ++m){

		n_ics=amigo_problem->n_pars;

		for (i = 0; i < n_exps; ++i){

			n_obs=amigo_problem->amigo_models[i]->n_observables;

			if(m<amigo_problem->n_pars){

				for (j = 0; j < n_obs; ++j) {

					n_times=amigo_problem->amigo_models[i]->n_times;

					for (k = 0; k < n_times; ++k) {

						if( !isnan(amigo_problem->amigo_models[i]->exp_data[j][k]) &&
								!isnan(amigo_problem->amigo_models[i]->Q[j][k]) && 
											amigo_problem->amigo_models[i]->Q[j][k]!=0){

							dr__[counter++]=
								amigo_problem->amigo_models[i]->sens_obs[j][m][k]*
								(amigo_problem->amigo_models[i]->Q[j][k]);  
						}else{
							dr__[counter++]=0;
						
						}
					}

				}

			}else if(m>=amigo_problem->n_pars && m>=n_ics && m<n_ics+amigo_problem->amigo_models[i]->n_opt_ics){

				for (j = 0; j < n_obs; ++j) {

					n_times=amigo_problem->amigo_models[i]->n_times;

					for (k = 0; k < n_times; ++k){
						if( !isnan(amigo_problem->amigo_models[i]->exp_data[j][k]) &&
								!isnan(amigo_problem->amigo_models[i]->Q[j][k]) && 
											amigo_problem->amigo_models[i]->Q[j][k]!=0){
								
								dr__[counter++]=
									(amigo_problem->amigo_models[i]->sens_obs[j][m-n_ics+amigo_problem->n_pars][k])*
									(amigo_problem->amigo_models[i]->Q[j][k]);   
						}else{
								dr__[counter++]=0;
						}

					}
				}
				count_ic++;

			}else{	
				for (j = 0; j < n_obs; ++j) {

					n_times=amigo_problem->amigo_models[i]->n_times;

					for (k = 0; k < n_times; ++k){
						dr__[counter++]=0;
					}
				}
			}
			n_ics+=amigo_problem->amigo_models[i]->n_opt_ics;
		}
	}
	
	return 0;
} 
/*
double getStatus(int stat)
{
switch((int)stat)
{     
case 3:         //stopped by xtol
case 4:         //stopped by ftol
case 5:         //stopped by ftol and xtol
case 6:         //stopped by abs ftol
return 1;
break;
case 9:         //feval max
case 10:        //itmax
return 0;
break;
case 8:         //tol too small
return -1;
case 13:        //bad initial f(x)
case 14:        //bad parameters
case 15:        //bad g(x)
case 16:        //n or p out of range
case 17:        //restart attempted (?)
case 18:        //iv out of range
case 19:        //v out of range
case 50:        //iv[0] out of range
case 87:        //v problem
return -2;
case 11:
return -5;  //user exit
default:
return -3;        
}
}*/
