#include <simulate_amigo_model.h>                                                                                                                
#include <amigo_terminate.h>                                                                                                                     
#define Ith(v,i) ( NV_DATA_S(v)[i] )                                                                                                             
#define ZERO  RCONST(0.0)                                                                                                                        
int simulate_amigo_model(AMIGO_model* amigo_model,int verbose);                                                                                  
static int check_flag(void *flagvalue, char *funcname, int opt, int verbose);                                                                    
static CVODES_REPORT GenerateCVODESReport(void *cvode_mem, int sensflag);                                                                        
int simulate_amigo_model(AMIGO_model* amigo_model,int verbose)                                                                                   
{                                                                                                                                                
int i,j,k,neq,NS,flag,stop_ti,TS_index;                                                                                                          
booleantype err_con;                                                                                                                             
realtype tout, tstop, ti, tf, t,previous_tstop;                                                                                                  
                                                                                                                                                 
N_Vector y;                                                                                                                                      
N_Vector *yS = NULL;                                                                                                                             
N_Vector ydot;                                                                                                                                   
N_Vector *ySdot = NULL;                                                                                                                          
void *cvode_mem;                                                                                                                                 
                                                                                                                                                 
ctrlcCheckPoint(__FILE__, __LINE__);                                                                                                             
                                                                                                                                                 
cvode_mem = NULL;                                                                                                                                
y = NULL;                                                                                                                                        
neq=amigo_model->n_states;                                                                                                                       
y = N_VNew_Serial(neq);                                                                                                                          
ydot = N_VNew_Serial(neq);                                                                                                                       
                                                                                                                                                 
NS=amigo_model->n_opt_pars+amigo_model->n_opt_ics; /*=amigo_model->n_sens;*/                                                                     
err_con=TRUE;/*FALSE;  FALSE/ TRUE  are the sensitivity variables included in the error control?*/                                             
ti=amigo_model->t0;                                                                                                                              
tf=amigo_model->tf;                                                                                                                              
if (check_flag((void *)y, "N_VNew_Serial", 0,verbose)  ) /*|check_flag((void *)ydot, "N_VNew_Serial", 0,verbose)*/                               
{                                                                                                                                                
if(verbose)printf("\nSolver failed in N_VNew_Serial(neq). . .\n");                                                                               
return(1);                                                                                                                                       
}                                                                                                                                                
/*Fill the first position of the outputs with y0*/                                                                                               
if(amigo_model->t[0]==amigo_model->t0){                                                                                                          
tout=ti;                                                                                                                                         
TS_index=1;                                                                                                                                      
for(i=0; i<amigo_model->n_states; i++){                                                                                                          
Ith(y,i) =(realtype)amigo_model->y0[i];                                                                                                          
amigo_model->sim_results[i][0]=amigo_model->y0[i];                                                                                               
}                                                                                                                                                
/* get the initial derivatives*/                                                                                                                 
flag = (amigo_model->rhs)(amigo_model->t[0], y,ydot,amigo_model);                                                                                
for(i=0; i<amigo_model->n_states; i++){                                                                                                          
amigo_model->ydot_results[i][0]=Ith(ydot,i);                                                                                                     
}                                                                                                                                                
}                                                                                                                                                
else{                                                                                                                                            
tout=ti;                                                                                                                                         
TS_index=0;                                                                                                                                      
for(i=0; i<amigo_model->n_states; i++){                                                                                                          
Ith(y,i) =(realtype)amigo_model->y0[i];                                                                                                          
}                                                                                                                                                
}                                                                                                                                                
/*Initialize CVODE with BDF and NEWTON iterartion for stiff problem*/                                                                            
cvode_mem = CVodeCreate(CV_BDF, CV_NEWTON);                                                                                                      
if(check_flag((void *)cvode_mem, "CVodeCreate", 0,verbose)) {                                                                                    
if(verbose)printf("\nSolver failed in CVodeCreate(CV_BDF, CV_NEWTON) . . .\n");                                                                  
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
return(2);                                                                                                                                       
}                                                                                                                                                
flag = CVodeInit(cvode_mem,amigo_model->rhs, ti, y);                                                                                             
if (check_flag(&flag, "CVodeMalloc", 1,verbose))                                                                                                 
{                                                                                                                                                
if(verbose)printf("\nSolver failed in CVodeInit(cvode_mem,*rhsODE, ti, y). . .\n");                                                              
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
/* Free integrator memory */                                                                                                                     
CVodeFree(&cvode_mem);                                                                                                                           
return(3);                                                                                                                                       
}                                                                                                                                                
if(verbose)printf("Solver Memory Allocated\n");                                                                                                  
/* Set f_data */                                                                                                                                 
flag = CVodeSetUserData(cvode_mem, amigo_model);                                                                                                 
if(check_flag(&flag, "CVodeSetFdata", 1,verbose))                                                                                                
{                                                                                                                                                
if(verbose)printf("\nSolver failed in flag = CVodeSetUserData(cvode_mem, data). . .\n");                                                         
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
/* Free integrator memory */                                                                                                                     
CVodeFree(&cvode_mem);                                                                                                                           
return(4);                                                                                                                                       
}                                                                                                                                                
flag = CVodeSStolerances(cvode_mem,(realtype)amigo_model->reltol,(realtype)amigo_model->atol);                                                   
if(check_flag(&flag, "CVodeSStolerances", 1,verbose)) return(5);                                                                                 
if(!verbose)                                                                                                                                     
{                                                                                                                                                
flag = CVodeSetErrFile(cvode_mem, NULL);                                                                                                         
}                                                                                                                                                
flag = CVodeSetErrFile(cvode_mem, stderr);                                                                                                       
/*flag = CVLapackDense(cvode_mem, neq);*/                                                                                                        
flag = CVDense(cvode_mem, neq);                                                                                                                  
if (check_flag(&flag, "CVDense", 1,verbose)) return(6);                                                                                          
if(verbose)printf("CVDENSE Solver Initiated\n");                                                                                                 
/* Set maxnumsteps */                                                                                                                            
flag = CVodeSetMaxNumSteps(cvode_mem, amigo_model->max_num_steps);                                                                               
if(check_flag(&flag, "CVodeSetMaxNumSteps", 1,verbose))                                                                                          
{                                                                                                                                                
if(verbose)printf("\nSolver failed in CVodeSetMaxNumSteps(cvode_mem, maxNumSteps). . .\n");                                                      
/* return(0);*/                                                                                                                                  
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
/* Free integrator memory */                                                                                                                     
CVodeFree(&cvode_mem);                                                                                                                           
return(7);                                                                                                                                       
}                                                                                                                                                
if(verbose)printf("Max number of steps: %i\n", amigo_model->max_num_steps);                                                                      
CVodeSetMaxStep(cvode_mem,(realtype)amigo_model->max_step_size);                                                                                 
CVodeSetMaxErrTestFails(cvode_mem, amigo_model->max_error_test_fails);                                                                           
/*COnfigure sensibility Analysis*/                                                                                                             
if (amigo_model->sensi) {                                                                                                                        
yS = N_VCloneVectorArray_Serial(NS, y);                                                                                                          
if (check_flag((void *)yS, "N_VCloneVectorArray_Serial", 0,0)) return(8);                                                                        
ySdot = N_VCloneVectorArray_Serial(NS, y);                                                                                                       
if (check_flag((void *)ySdot, "N_VCloneVectorArray_Serial", 0,0)) return(8);                                                                     
/*Initialize sensitivities with 0 for parameters: s_ij(t=0) = dy_i(0)/dp_j =0*/                                                                  
for (i=0;i<amigo_model->n_opt_pars;i++){                                                                                                         
N_VConst(ZERO, yS[i]);                                                                                                                           
if(amigo_model->t[0]==amigo_model->t0){                                                                                                          
for (j=0;j<amigo_model->n_states;j++){                                                                                                           
amigo_model->sens_results[j][i][0]=ZERO;                                                                                                         
amigo_model->sensdot_results[j][i][0]=ZERO;                                                                                                      
}                                                                                                                                                
}                                                                                                                                                
}                                                                                                                                                
/* Initialize sensitivities for initial conditions: s_ij(t=0) = dy_i(0)/dy0_j= \delta_ij*/                                                       
for (i=amigo_model->n_opt_pars;i<amigo_model->n_opt_pars + amigo_model->n_opt_ics;i++){                                                          
N_VConst(ZERO, yS[i]); /* set 0 and change the right element to 1*/                                                                              
for (j=0;j<amigo_model->n_states;j++){                                                                                                           
                                                                                                                                                 
if(j == (*amigo_model).index_opt_ics[i-amigo_model->n_opt_pars]){                                                                                
Ith(yS[i],j)=1;                                                                                                                                  
if(amigo_model->t[0]==amigo_model->t0){                                                                                                          
amigo_model->sens_results[j][i][0]=1;                                                                                                            
}                                                                                                                                                
}else{                                                                                                                                           
/*Ith(yS[i],j)=0; not needed because N_VConst*/                                                                                                
if(amigo_model->t[0]==amigo_model->t0){                                                                                                          
amigo_model->sens_results[j][i][0]=0;                                                                                                            
}                                                                                                                                                
}                                                                                                                                                
}                                                                                                                                                
}                                                                                                                                                
switch (amigo_model->sensi) /* modification by GA*/                                                                                              
{                                                                                                                                                
case 1: /* sensitivity using finite differences to compute the r.h.s.*/                                                                          
flag = CVodeSensInit1(cvode_mem, NS, CV_STAGGERED, NULL, yS);                                                                                    
if(check_flag(&flag, "CVodeSensInit", 1,verbose)){                                                                                               
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
CVodeFree(&cvode_mem);                                                                                                                           
return(9);                                                                                                                                       
}                                                                                                                                                
break;                                                                                                                                           
case 2: /* sensitivity using user defined r.h.s function (amigoSensRHS)*/                                                                        
flag = CVodeSensInit1(cvode_mem, NS, CV_STAGGERED, amigo_model->sensrhs, yS);   /* CV_STAGGERED1, CV_SIMULTANEOUS*/                              
if(check_flag(&flag, "CVodeSensInit", 1,verbose)){                                                                                               
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
CVodeFree(&cvode_mem);                                                                                                                           
return(10);                                                                                                                                      
}                                                                                                                                                
break;                                                                                                                                           
}                                                                                                                                                
flag = CVodeSensEEtolerances(cvode_mem);                                                                                                         
if(check_flag(&flag, "CVodeSensEEtolerances", 1,verbose)) {                                                                                      
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
CVodeFree(&cvode_mem);                                                                                                                           
return(11);                                                                                                                                      
}                                                                                                                                                
flag = CVodeSetSensErrCon(cvode_mem, err_con);                                                                                                   
if (check_flag(&flag, "CVodeSetSensErrCon", 1,verbose))  {                                                                                       
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
CVodeFree(&cvode_mem);                                                                                                                           
return(12);                                                                                                                                      
}                                                                                                                                                
/*flag = CVodeSetSensParams(cvode_mem,(realtype*)amigo_model->pars, NULL,amigo_model->plist);*/                                                  
flag = CVodeSetSensParams(cvode_mem,(realtype*)amigo_model->pars, (realtype*)amigo_model->pbar,amigo_model->plist); /* added scaling parameters*/
if (check_flag(&flag, "CVodeSetSensParams", 1,verbose))  {                                                                                       
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
CVodeFree(&cvode_mem);                                                                                                                           
return(13);                                                                                                                                      
}                                                                                                                                                
}                                                                                                                                                
/*If the Jacobian matrix has been provided, then use it*/                                                                                        
if(amigo_model->use_jacobian){                                                                                                                   
/* Attach linear solver */                                                                                                                       
flag = CVDense(cvode_mem, neq);                                                                                                                  
if(check_flag(&flag, "CVDense", 1,verbose))  {                                                                                                   
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
if(amigo_model->sensi){                                                                                                                          
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
}                                                                                                                                                
CVodeFree(&cvode_mem);                                                                                                                           
return(14);                                                                                                                                      
}                                                                                                                                                
flag = CVDlsSetDenseJacFn(cvode_mem, amigo_model->jac);                                                                                          
if (check_flag(&flag, "CVDlsSetDenseJacFn", 1,verbose)) {                                                                                        
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
if(amigo_model->sensi){                                                                                                                          
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
}                                                                                                                                                
CVodeFree(&cvode_mem);                                                                                                                           
return(15);                                                                                                                                      
}                                                                                                                                                
}                                                                                                                                                
tstop=tout;                                                                                                                                      
stop_ti=0;                                                                                                                                       
                                                                                                                                                 
while(stop_ti<amigo_model->n_controls_t && tstop<=tout){                                                                                         
previous_tstop=tstop;                                                                                                                            
tstop=amigo_model->controls_t[stop_ti++];                                                                                                        
}                                                                                                                                                
for (i = TS_index;  i < amigo_model->n_times; i++){                                                                                              
/*update tout*/                                                                                                                                  
tout=amigo_model->t[i];                                                                                                                          
amigo_model->tlast=previous_tstop;                                                                                                               
amigo_model->index_t_stim=stop_ti-2;                                                                                                             
/*Try to update tstop*/                                                                                                                          
while(tstop<=tout){                                                                                                                              
/*Find if there are still controls to be executed*/                                                                                              
if(stop_ti<amigo_model->n_controls_t && amigo_model->n_controls_t>0){                                                                            
flag = CVode(cvode_mem, tstop, y, &t, CV_TSTOP_RETURN);                                                                                          
                                                                                                                                                 
if (check_flag(&flag, "CVode", 1,1)){                                                                                                            
if(verbose){                                                                                                                                     
mexPrintf("\nSolver failed at flag = CVode(cvode_mem, tstop, y, &t, CV_TSTOP_RETURN);. . .\n");                                                  
}                                                                                                                                                
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
if(amigo_model->sensi){                                                                                                                          
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
}                                                                                                                                                
CVodeFree(&cvode_mem);                                                                                                                           
return(16);                                                                                                                                      
}                                                                                                                                                
/*We have reached TSTOP, reinitialize memory and update tstop*/                                                                                  
CVodeReInit(cvode_mem, tstop, y);                                                                                                                
previous_tstop=tstop;                                                                                                                            
tstop=amigo_model->controls_t[stop_ti++];                                                                                                        
CVodeSetStopTime(cvode_mem, tstop);                                                                                                              
amigo_model->index_t_stim=stop_ti-2;                                                                                                             
amigo_model->tlast=previous_tstop;                                                                                                               
}                                                                                                                                                
/*In case there are no more control times break the while*/                                                                                      
else break;                                                                                                                                      
}                                                                                                                                                
/*Make sure tout is different from tstop. Dont integrate twice... causes an error*/                                                              
if(tout!=previous_tstop){                                                                                                                        
flag = CVode(cvode_mem, tout, y, &t, CV_TSTOP_RETURN);                                                                                           
if (check_flag(&flag, "CVode", 1,1)){                                                                                                            
/*mexPrintf("error code: %d\n", flag);   GA error handling*/                                                                                   
/*PrintFinalStats(cvode_mem);*/                                                                                                                  
amigo_model->cvodesReport = GenerateCVODESReport(cvode_mem,amigo_model->sensi);                                                                  
if(verbose){                                                                                                                                     
mexPrintf(stderr,"\nSolver failed at flag = CVode(cvode_mem, tout, y, &t, CV_TSTOP_RETURN);. . .\n");                                            
mexPrintf("Function CVode failure: flag = %d\n",flag);                                                                                           
}                                                                                                                                                
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
if(amigo_model->sensi){                                                                                                                          
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
}                                                                                                                                                
CVodeFree(&cvode_mem);                                                                                                                           
return(17);                                                                                                                                      
}                                                                                                                                                
}                                                                                                                                                
                                                                                                                                                 
/* get the first timederivatives of the states*/                                                                                                 
flag = CVodeGetDky(cvode_mem, t, 1, ydot);                                                                                                       
if (check_flag(&flag, "CVodeGetDky", 1,1)){                                                                                                      
if(verbose)printf("CVodeGetDky failed\n");                                                                                                       
}                                                                                                                                                
/*flag = (amigo_model->rhs)(tout, y,ydot,amigo_model);*/                                                                                         
for (j = 0; j < amigo_model->n_states; j++){                                                                                                     
amigo_model->sim_results[j][i]=(double)Ith(y,j);                                                                                                 
amigo_model->ydot_results[j][i]=(double)Ith(ydot,j);/* get the derivatives*/                                                                     
}                                                                                                                                                
                                                                                                                                                 
/*Get sensitivies*/                                                                                                                              
if (amigo_model->sensi) {                                                                                                                        
flag = CVodeGetSens(cvode_mem, &tf, yS);                                                                                                         
if (check_flag(&flag, "CVodeGetSens", 1,verbose)) break;                                                                                         
flag = CVodeGetSensDky(cvode_mem, tf, 1, ySdot);                                                                                                 
if (check_flag(&flag, "CVodeGetSensDky", 1,1)){                                                                                                  
if(verbose)printf("CVodeGetSensDky failed\n");                                                                                                   
}                                                                                                                                                
for (j=0;j<amigo_model->n_states;j++){                                                                                                           
for (k=0;k<NS;k++){		/*for (k=0;k<amigo_model->n_sens;k++){*/                                                                                    
amigo_model->sens_results[j][k][i]=Ith(yS[k],j);                                                                                                 
amigo_model->sensdot_results[j][k][i]=Ith(ySdot[k],j);                                                                                           
}                                                                                                                                                
}                                                                                                                                                
}                                                                                                                                                
}                                                                                                                                                
/* put here everything you waant:)*/                                                                                                             
/*PrintFinalStats(cvode_mem);   Print some final statistics   */                                                                             
amigo_model->cvodesReport = GenerateCVODESReport(cvode_mem,amigo_model->sensi);                                                                  
                                                                                                                                                 
                                                                                                                                                 
                                                                                                                                                 
N_VDestroy_Serial(y);                                                                                                                            
N_VDestroy_Serial(ydot);                                                                                                                         
if (amigo_model->sensi) {                                                                                                                        
N_VDestroyVectorArray_Serial(yS, NS);  /*Free yS vector*/                                                                                        
N_VDestroyVectorArray_Serial(ySdot, NS);  /*Free ySdot vector*/                                                                                  
}                                                                                                                                                
y = NULL;                                                                                                                                        
ydot = NULL;                                                                                                                                     
yS = NULL;                                                                                                                                       
ySdot = NULL;                                                                                                                                    
                                                                                                                                                 
                                                                                                                                                 
/* Free integrator memory */                                                                                                                     
CVodeFree(&cvode_mem);                                                                                                                           
return(0);                                                                                                                                       
}                                                                                                                                                
static int check_flag(void *flagvalue, char *funcname, int opt,int verbose)                                                                      
{                                                                                                                                                
int *errflag;                                                                                                                                    
/* Check if SUNDIALS function returned NULL pointer - no memory allocated */                                                                     
if (opt == 0 && flagvalue == NULL) {                                                                                                             
if(verbose)fprintf(stderr, "\nSUNDIALS_ERROR: %s() failed - returned NULL pointer\n\n",funcname);                                                
if(verbose)mexPrintf("\nSUNDIALS_ERROR: %s() failed - returned NULL pointer\n\n",funcname);                                                      
return(1); }                                                                                                                                     
/* Check if flag < 0 */                                                                                                                          
else if (opt == 1)                                                                                                                               
{                                                                                                                                                
errflag = (int *) flagvalue;                                                                                                                     
if (*errflag < 0)                                                                                                                                
{                                                                                                                                                
if(verbose)fprintf(stderr, "\nSUNDIALS_ERROR: %s() failed with flag = %d\n\n",funcname, *errflag);                                               
/*if(verbose)printf("\nSUNDIALS_ERROR: %s() failed with flag = %d\n\n",funcname, *errflag);*/                                                    
return(1);                                                                                                                                       
}                                                                                                                                                
}                                                                                                                                                
/* Check if function returned NULL pointer - no memory allocated */                                                                              
else if (opt == 2 && flagvalue == NULL)                                                                                                          
{                                                                                                                                                
if(verbose)fprintf(stderr, "\nMEMORY_ERROR: %s() failed - returned NULL pointer\n\n",funcname);                                                  
/*if(verbose)printf("\nMEMORY_ERROR: %s() failed - returned NULL pointer\n\n",funcname);*/                                                       
return(1);                                                                                                                                       
}                                                                                                                                                
return(0);                                                                                                                                       
}                                                                                                                                                
static void PrintFinalStats(void *cvode_mem)                                                                                                     
{                                                                                                                                                
int flag;                                                                                                                                        
long int nst, nfe, netf, nni, ncfn, nje, nfeLS;                                                                                                  
flag = CVodeGetNumSteps(cvode_mem, &nst);                                                                                                        
check_flag(&flag, "CVodeGetNumSteps", 1,1);                                                                                                      
flag = CVodeGetNumRhsEvals(cvode_mem, &nfe);                                                                                                     
check_flag(&flag, "CVodeGetNumRhsEvals", 1,1);                                                                                                   
/*flag = CVodeGetNumLinSolvSetups(cvode_mem, &nsetups);*/                                                                                        
/*check_flag(&flag, "CVodeGetNumLinSolvSetups", 1,1);*/                                                                                          
flag = CVodeGetNumErrTestFails(cvode_mem, &netf);                                                                                                
check_flag(&flag, "CVodeGetNumErrTestFails", 1,1);                                                                                               
flag = CVodeGetNumNonlinSolvIters(cvode_mem, &nni);                                                                                              
check_flag(&flag, "CVodeGetNumNonlinSolvIters", 1,1);                                                                                            
flag = CVodeGetNumNonlinSolvConvFails(cvode_mem, &ncfn);                                                                                         
check_flag(&flag, "CVodeGetNumNonlinSolvConvFails", 1,1);                                                                                        
flag = CVDlsGetNumJacEvals(cvode_mem, &nje);                                                                                                     
check_flag(&flag, "CVDlsGetNumJacEvals", 1,1);                                                                                                   
flag = CVDlsGetNumRhsEvals(cvode_mem, &nfeLS);                                                                                                   
check_flag(&flag, "CVDlsGetNumRhsEvals", 1,1);                                                                                                   
/*mexPrintf("\nFinal Statistics on simulation with CVODES:\n");                                                                                  
mexPrintf("nst:     comulative number of steps;\n");                                                                                             
mexPrintf("nfe:     No. of calls to r.h.s. function; \n");                                                                                       
mexPrintf("nsetups: No. of calls to linear solver setup function; \n");                                                                          
mexPrintf("nfeLS:   No. of r.h.s. calls for finite diff. Jacobian evals;\n");                                                                    
mexPrintf("nje:     No. of Jacobian evaluations;\n");                                                                                            
mexPrintf("nni:     No. of nonlinear solver iterations;\n");                                                                                     
mexPrintf("ncfn:    No. of nonlinear convergence failures;\n");                                                                                  
mexPrintf("netf:    No. of local error test failures that have occurred; \n\n");                                                                 
                                                                                                                                                 
mexPrintf("nst = %-6ld nfe  = %-6ld nsetups = %-6ld nfeLS = %-6ld nje = %ld\n",                                                                  
nst, nfe, nsetups, nfeLS, nje);                                                                                                                  
mexPrintf("nni = %-6ld ncfn = %-6ld netf = %ld\n \n",                                                                                            
nni, ncfn, netf);                                                                                                                                
*/                                                                                                                                               
mexPrintf("nsteps: %-6ld nfevals: %-6ld  nfeval2Jac: %-6ld nJaceval: %ld\n",                                                                     
nst, nfe, nfeLS, nje);                                                                                                                           
/*mexPrintf("nni = %-6ld ncfn = %-6ld netf = %ld\n \n",*/                                                                                        
/*	 nni, ncfn, netf);*/                                                                                                                          
                                                                                                                                                 
/* Print statistics to MATLAB window about the CVODES run:*/                                                                                     
/* mexPrintf("%-6ld, %-6ld, %-6ld, %-6ld, %ld, %-6ld, %-6ld, %ld",                                                                               
nst, nfe, nsetups, nfeLS, nje, nni, ncfn, netf);                                                                                                 
*/                                                                                                                                               
return;                                                                                                                                          
}                                                                                                                                                
static CVODES_REPORT GenerateCVODESReport(void *cvode_mem,int sensflag)                                                                          
{                                                                                                                                                
int flag;                                                                                                                                        
long int nst, nfe, netf, nni, ncfn, nje, nfeLS;                                                                                                  
long int nfSevals, nfevalsS, nSetfails, nlinsetupsS,nSniters,nSncfails;                                                                          
CVODES_REPORT report;                                                                                                                            
/* IVP integration related statistics*/                                                                                                          
flag = CVodeGetNumSteps(cvode_mem, &nst);                                                                                                        
check_flag(&flag, "CVodeGetNumSteps", 1,1);                                                                                                      
flag = CVodeGetNumRhsEvals(cvode_mem, &nfe);                                                                                                     
check_flag(&flag, "CVodeGetNumRhsEvals", 1,1);                                                                                                   
/*flag = CVodeGetNumLinSolvSetups(cvode_mem, &nsetups);*/                                                                                        
/*check_flag(&flag, "CVodeGetNumLinSolvSetups", 1,1);*/                                                                                          
flag = CVodeGetNumErrTestFails(cvode_mem, &netf);                                                                                                
check_flag(&flag, "CVodeGetNumErrTestFails", 1,1);                                                                                               
flag = CVodeGetNumNonlinSolvIters(cvode_mem, &nni);                                                                                              
check_flag(&flag, "CVodeGetNumNonlinSolvIters", 1,1);                                                                                            
flag = CVodeGetNumNonlinSolvConvFails(cvode_mem, &ncfn);                                                                                         
check_flag(&flag, "CVodeGetNumNonlinSolvConvFails", 1,1);                                                                                        
flag = CVDlsGetNumJacEvals(cvode_mem, &nje);                                                                                                     
check_flag(&flag, "CVDlsGetNumJacEvals", 1,1);                                                                                                   
flag = CVDlsGetNumRhsEvals(cvode_mem, &nfeLS);                                                                                                   
check_flag(&flag, "CVDlsGetNumRhsEvals", 1,1);                                                                                                   
                                                                                                                                                 
report.nSteps = nst;                                                                                                                             
report.nRhsEval = nfe;                                                                                                                           
report.nLocalErrorFailure= netf;                                                                                                                 
report.nNonlinSolvIteration = nni;                                                                                                               
report.nNonlinConvFailure = ncfn;                                                                                                                
report.nJacobianEval = nje;                                                                                                                      
report.nFDrhscall = nfeLS;                                                                                                                       
                                                                                                                                                 
/* Sensitivity solution related statistics.*/                                                                                                    
if (sensflag){                                                                                                                                   
flag = CVodeGetSensStats(cvode_mem, &nfSevals, &nfevalsS, &nSetfails, &nlinsetupsS);                                                             
check_flag(&flag, "CVodeGetSensStats", 1,1);                                                                                                     
flag = CVodeGetSensNonlinSolvStats(cvode_mem, &nSniters, &nSncfails);                                                                            
check_flag(&flag, "CVodeGetSensNonlinSolvStats", 1,1);                                                                                           
                                                                                                                                                 
report.nSensRHSeval = nfSevals;                                                                                                                  
report.nRHSevalforSens = nfevalsS;                                                                                                               
report.nSensLocalErrorFailure = nSetfails;                                                                                                       
report.nSensLinSolvSetups = nlinsetupsS;                                                                                                         
report.nSensNonlinIters = nSniters;                                                                                                              
report.nSensNonlinConvFailure = nSncfails;                                                                                                       
}else{                                                                                                                                           
report.nSensRHSeval = 0;                                                                                                                         
report.nRHSevalforSens = 0;                                                                                                                      
report.nSensLocalErrorFailure = 0;                                                                                                               
report.nSensLinSolvSetups = 0;                                                                                                                   
report.nSensNonlinIters = 0;                                                                                                                     
report.nSensNonlinConvFailure = 0;                                                                                                               
}                                                                                                                                                
                                                                                                                                                 
return report;                                                                                                                                   
}                                                                                                                                                
