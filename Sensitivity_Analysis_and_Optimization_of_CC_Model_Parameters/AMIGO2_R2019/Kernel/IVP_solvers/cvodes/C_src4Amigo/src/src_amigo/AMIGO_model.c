#include <AMIGO_model.h>                                                                                                                                       
/*Does Memory Initialization for an AMIGO_model*/                                                                                                              
AMIGO_model* new_AMIGO_model                                                                                                                                   
(                                                                                                                                                              
int n_states,		int n_pars,			int n_times,                                                                                                                      
int n_controls,		int n_controls_t,	int(*rhs)(realtype,N_Vector,N_Vector, void*)                                                                                
)                                                                                                                                                              
{                                                                                                                                                              
int i,j;                                                                                                                                                       
AMIGO_model amigo_model;                                                                                                                                       
AMIGO_model* ptr2Model;                                                                                                                                        
ptr2Model=(AMIGO_model*)malloc(sizeof(amigo_model));                                                                                                           
(*ptr2Model).model_name="default";                                                                                                                             
(*ptr2Model).n_pars=n_pars;                                                                                                                                    
(*ptr2Model).sensi=0;                                                                                                                                          
(*ptr2Model).t0=0;                                                                                                                                             
(*ptr2Model).tf=n_times-1;                                                                                                                                     
(*ptr2Model).pars=(double*)malloc((*ptr2Model).n_pars*sizeof(double));                                                                                         
for (i = 0; i < (*ptr2Model).n_pars; i++) {                                                                                                                    
(*ptr2Model).pars[i]=1;                                                                                                                                        
}                                                                                                                                                              
(*ptr2Model).is_opt_par=(int*)malloc((*ptr2Model).n_pars*sizeof(int));                                                                                         
for (i = 0; i < (*ptr2Model).n_pars; i++) {                                                                                                                    
(*ptr2Model).is_opt_par[i]=1;                                                                                                                                  
}                                                                                                                                                              
(*ptr2Model).n_times=n_times;                                                                                                                                  
(*ptr2Model).t=(double*)malloc((*ptr2Model).n_times*sizeof(double)) ;                                                                                          
for (i = 0; i < (*ptr2Model).n_times; i++) {                                                                                                                   
(*ptr2Model).t[i]=i;                                                                                                                                           
}                                                                                                                                                              
(*ptr2Model).n_states=n_states;                                                                                                                                
(*ptr2Model).y0=(double*)malloc((*ptr2Model).n_states*sizeof(double));                                                                                         
for (i = 0; i < (*ptr2Model).n_states; i++) {                                                                                                                  
(*ptr2Model).y0[i]=0;                                                                                                                                          
}                                                                                                                                                              
(*ptr2Model).n_controls=n_controls;                                                                                                                            
(*ptr2Model).n_controls_t=n_controls_t;                                                                                                                        
(*ptr2Model).controls_t=(double*)malloc((*ptr2Model).n_controls_t*sizeof(double));                                                                             
for (i = 0; i < (*ptr2Model).n_controls_t; i++) {                                                                                                              
(*ptr2Model).controls_t[i]=i;                                                                                                                                  
}                                                                                                                                                              
(*ptr2Model).controls_v=(double**)malloc((*ptr2Model).n_controls*sizeof(double*));                                                                             
for (i = 0; i < (*ptr2Model).n_controls; i++) {                                                                                                                
(*ptr2Model).controls_v[i]=(double*)malloc(((*ptr2Model).n_controls_t-1)*sizeof(double));                                                                      
for (j= 0; j < (*ptr2Model).n_controls_t-1; j++){                                                                                                              
(*ptr2Model).controls_v[i][j]=1;                                                                                                                               
}                                                                                                                                                              
}                                                                                                                                                              
(*ptr2Model).slope=(double**)malloc(((*ptr2Model).n_controls)*sizeof(double*));                                                                                
for (i= 0; i < (*ptr2Model).n_controls; i++){                                                                                                                  
(*ptr2Model).slope[i]=(double*)malloc(((*ptr2Model).n_controls_t-1)*sizeof(double));                                                                           
for (j= 0; j < (*ptr2Model).n_controls_t-1; j++){                                                                                                              
(*ptr2Model).slope[i][j]=0;                                                                                                                                    
}                                                                                                                                                              
}                                                                                                                                                              
(*ptr2Model).reltol=1e-6;                                                                                                                                      
(*ptr2Model).atol=1e-6;                                                                                                                                        
(*ptr2Model).max_step_size=DBL_MAX;                                                                                                                            
(*ptr2Model).max_num_steps=2000000;                                                                                                                            
(*ptr2Model).max_error_test_fails=50;                                                                                                                          
(*ptr2Model).use_jacobian=0;                                                                                                                                   
(*ptr2Model).rhs=rhs;                                                                                                                                          
(*ptr2Model).jac=NULL;                                                                                                                                         
(*ptr2Model).n_sens=(*ptr2Model).n_pars;                                                                                                                       
return(ptr2Model);                                                                                                                                             
}                                                                                                                                                              
/*Initialization for matlab*/                                                                                                                                  
AMIGO_model* new_AMIGO_model_matlab(const mxArray *prhs[]){                                                                                                    
int i,j,counter;                                                                                                                                               
/*AMIGO_model amigo_model;*/                                                                                                                                   
AMIGO_model* ptr2Model = NULL;                                                                                                                                 
mwSize  ndim;                                                                                                                                                  
ptr2Model=(AMIGO_model*)malloc(sizeof(AMIGO_model));                                                                                                           
/*if(1) printf("creating AMIGO_model_matlab\n");*/                                                                                                             
(*ptr2Model).model_name="default";                                                                                                                             
(*ptr2Model).n_pars=(int)mxGetPr(prhs[0])[0];/*0*/                                                                                                             
(*ptr2Model).sensi=(int)mxGetPr(prhs[1])[0];/*1*/                                                                                                              
                                                                                                                                                               
/* pars are processed later after the number of states are known.*/                                                                                            
/*(*ptr2Model).pars=(double*)malloc((*ptr2Model).n_pars*sizeof(double)) ;2*/                                                                                 
/* test is_opt_par inputs:*/                                                                                                                                   
if (mxGetNumberOfElements(prhs[3]) != (*ptr2Model).n_pars){                                                                                                    
mexErrMsgTxt("The number of parameters and the is_opt_pars arguments are not consistent.");                                                                    
}                                                                                                                                                              
(*ptr2Model).is_opt_par=(int*)malloc((*ptr2Model).n_pars*sizeof(int)) ;/*3*/                                                                                   
for (i = 0; i < (*ptr2Model).n_pars; i++) {                                                                                                                    
(*ptr2Model).is_opt_par[i]=(int)mxGetPr(prhs[3])[i];                                                                                                           
}                                                                                                                                                              
(*ptr2Model).t0=(double)mxGetPr(prhs[4])[0];/*4*/                                                                                                              
(*ptr2Model).tf=(double)mxGetPr(prhs[5])[0];/*5*/                                                                                                              
(*ptr2Model).n_times=(int)mxGetPr(prhs[6])[0];/*6*/                                                                                                            
/* test consistency of timevector*/                                                                                                                            
if (mxGetNumberOfElements(prhs[7]) != (*ptr2Model).n_times){                                                                                                   
mexErrMsgTxt("The number of time points and the time-vector are not consistent.");                                                                             
}                                                                                                                                                              
(*ptr2Model).t=(double*)malloc((*ptr2Model).n_times*sizeof(double)) ;                                                                                          
for (i = 0; i < (*ptr2Model).n_times; i++) {                                                                                                                   
(*ptr2Model).t[i]=(double)mxGetPr(prhs[7])[i];/*7*/                                                                                                            
}                                                                                                                                                              
(*ptr2Model).n_states=(int)mxGetPr(prhs[8])[0];/*8*/                                                                                                           
                                                                                                                                                               
/* test consistency of parameters*/                                                                                                                            
if (mxGetNumberOfElements(prhs[2]) != (*ptr2Model).n_pars){                                                                                                    
mexErrMsgTxt("The number of parameters and the parameter vector are not consistent.");                                                                         
}                                                                                                                                                              
/* test consistency of initial conditions*/                                                                                                                    
if (mxGetNumberOfElements(prhs[9]) != (*ptr2Model).n_states){                                                                                                  
mexErrMsgTxt("The number of states and the initial condition vector are not consistent.");                                                                     
}                                                                                                                                                              
/* the amigo->pars contains the amigo parameters and initial conditions.*/                                                                                     
(*ptr2Model).pars=(double*)malloc(((*ptr2Model).n_pars+(*ptr2Model).n_states)*sizeof(double)) ;/*2*/                                                           
for (i = 0; i < (*ptr2Model).n_pars; i++) {                                                                                                                    
(*ptr2Model).pars[i]=(double)mxGetPr(prhs[2])[i];                                                                                                              
}                                                                                                                                                              
for (i = (*ptr2Model).n_pars; i < (*ptr2Model).n_pars+(*ptr2Model).n_states; i++) {                                                                            
(*ptr2Model).pars[i]=(double)mxGetPr(prhs[9])[i]; /* fill with initial conditions. Actually not relevant...*/                                                  
}                                                                                                                                                              
(*ptr2Model).y0=(double*)malloc((*ptr2Model).n_states*sizeof(double)) ;                                                                                        
for (i = 0; i < (*ptr2Model).n_states; i++) {                                                                                                                  
(*ptr2Model).y0[i]=(double)mxGetPr(prhs[9])[i];/*9*/                                                                                                           
}                                                                                                                                                              
(*ptr2Model).n_controls=(int)mxGetPr(prhs[10])[0];/*10*/                                                                                                       
(*ptr2Model).n_controls_t=(int)mxGetPr(prhs[11])[0];/*11*/                                                                                                     
/* test consistency of control inputs*/                                                                                                                        
if (mxGetNumberOfElements(prhs[12]) != (*ptr2Model).n_controls_t){                                                                                             
mexErrMsgTxt("The number of control changes and the control time vector are not consistent.");                                                                 
}                                                                                                                                                              
(*ptr2Model).controls_t=(double*)malloc((*ptr2Model).n_controls_t*sizeof(double));                                                                             
for (i = 0; i < (*ptr2Model).n_controls_t; i++) {                                                                                                              
(*ptr2Model).controls_t[i]=(double)mxGetPr(prhs[12])[i];/*12*/                                                                                                 
}                                                                                                                                                              
/* test consistency of control inputs*/                                                                                                                        
/* This needs more time to check...*/                                                                                                                          
ndim = mxGetNumberOfDimensions(prhs[13]);                                                                                                                      
/*printf("ndim=%d \n",ndim);                                                                                                                                   
if (mxGetNumberOfElements(prhs[13]) != (*ptr2Model).n_controls_t-1){                                                                                         
mexErrMsgTxt("The number of controls and the control input vector are not consistent.");                                                                       
}*/                                                                                                                                                            
counter=0;                                                                                                                                                     
(*ptr2Model).controls_v=(double**)malloc((*ptr2Model).n_controls*sizeof(double*));                                                                             
for (i = 0; i < (*ptr2Model).n_controls; i++) {                                                                                                                
(*ptr2Model).controls_v[i]=(double*)malloc(((*ptr2Model).n_controls_t-1)*sizeof(double));                                                                      
for (j= 0; j < (*ptr2Model).n_controls_t-1; j++){                                                                                                              
(*ptr2Model).controls_v[i][j]=(double)mxGetPr(prhs[13])[counter++];/*13*/                                                                                      
}                                                                                                                                                              
                                                                                                                                                               
/*printf("Control: % d %f %f %f\n",i,(*ptr2Model).controls_v[i][0],(*ptr2Model).controls_v[i][1],(*ptr2Model).controls_v[i][2]);*/                             
}                                                                                                                                                              
counter=0;                                                                                                                                                     
(*ptr2Model).slope=(double**)malloc(((*ptr2Model).n_controls)*sizeof(double*));                                                                                
for (i= 0; i < (*ptr2Model).n_controls; i++){                                                                                                                  
(*ptr2Model).slope[i]=(double*)malloc(((*ptr2Model).n_controls_t-1)*sizeof(double));                                                                           
for (j= 0; j < (*ptr2Model).n_controls_t-1; j++){                                                                                                              
(*ptr2Model).slope[i][j]=(double)mxGetPr(prhs[14])[counter++];                                                                                                 
}                                                                                                                                                              
                                                                                                                                                               
/* printf("Slope: %d %f %f %f\n",i,(*ptr2Model).slope[i][0],(*ptr2Model).slope[i][1],(*ptr2Model).slope[i][2]);*/                                              
}                                                                                                                                                              
(*ptr2Model).reltol=(double)mxGetPr(prhs[15])[0];/*15*/                                                                                                        
(*ptr2Model).atol=(double)mxGetPr(prhs[16])[0];/*16*/                                                                                                          
(*ptr2Model).max_step_size=(double)mxGetPr(prhs[17])[0];/*17*/                                                                                                 
(*ptr2Model).max_num_steps=(int)mxGetPr(prhs[18])[0];/*18*/                                                                                                    
(*ptr2Model).max_error_test_fails=(int)mxGetPr(prhs[19])[0];/*19*/                                                                                             
(*ptr2Model).sensi=(int)mxGetPr(prhs[20])[0];/*20*/                                                                                                            
(*ptr2Model).use_jacobian=(int)mxGetPr(prhs[21])[0];/*21*/                                                                                                     
                                                                                                                                                               
(*ptr2Model).exp_num = (int)mxGetPr(prhs[22])[0];/*22*/                                                                                                        
                                                                                                                                                               
/* test consistency of initial conditions*/                                                                                                                    
if (mxGetNumberOfElements(prhs[23]) != (*ptr2Model).n_states){                                                                                                 
mexErrMsgTxt("The number of states and the is_opt_ic vector are not consistent.");                                                                             
}                                                                                                                                                              
/* sensitivity calculations with respect to specified initial conditions:*/                                                                                    
ptr2Model->is_opt_ic=(int*)malloc((*ptr2Model).n_states*sizeof(int)) ;                                                                                         
for (i = 0; i < ptr2Model->n_states; i++) {                                                                                                                    
ptr2Model->is_opt_ic[i] = (int)mxGetPr(prhs[23])[i];/*23*/                                                                                                     
/*mexPrintf("ic %d. is computed:  %d\n",i,ptr2Model->is_opt_ic[i]);*/                                                                                          
}                                                                                                                                                              
                                                                                                                                                               
(*ptr2Model).n_sens=(*ptr2Model).n_pars;                                                                                                                       
ptr2Model=allocate_AMIGO_model_results(ptr2Model);                                                                                                             
ptr2Model=set_rhs(ptr2Model);                                                                                                                                  
(*ptr2Model).index_t_stim = 0;                                                                                                                                 
(*ptr2Model).tlast = 0;                                                                                                                                        
/* initialize report.*/                                                                                                                                        
(*ptr2Model).cvodesReport.nSteps = 0;                                                                                                                          
(*ptr2Model).cvodesReport.nRhsEval = 0;                                                                                                                        
(*ptr2Model).cvodesReport.nLocalErrorFailure= 0;                                                                                                               
(*ptr2Model).cvodesReport.nNonlinSolvIteration = 0;                                                                                                            
(*ptr2Model).cvodesReport.nNonlinConvFailure = 0;                                                                                                              
(*ptr2Model).cvodesReport.nJacobianEval = 0;                                                                                                                   
(*ptr2Model).cvodesReport.nFDrhscall = 0;                                                                                                                      
(*ptr2Model).cvodesReport.nSensRHSeval = 0;                                                                                                                    
(*ptr2Model).cvodesReport.nRHSevalforSens = 0;                                                                                                                 
(*ptr2Model).cvodesReport.nSensLocalErrorFailure = 0;                                                                                                          
(*ptr2Model).cvodesReport.nSensLinSolvSetups = 0;                                                                                                              
(*ptr2Model).cvodesReport.nSensNonlinIters = 0;                                                                                                                
(*ptr2Model).cvodesReport.nSensNonlinConvFailure = 0;                                                                                                          
return(ptr2Model);                                                                                                                                             
}                                                                                                                                                              
AMIGO_model* allocate_AMIGO_model_results(AMIGO_model * amigo_model){                                                                                          
int i,j,k;                                                                                                                                                     
int counter =0;                                                                                                                                                
int tmp;                                                                                                                                                       
(*amigo_model).sim_results=(double**)malloc(sizeof(double*)*(*amigo_model).n_states);                                                                          
(*amigo_model).ydot_results=(double**)malloc(sizeof(double*)*(*amigo_model).n_states);                                                                         
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
(*amigo_model).sim_results[i]=(double*)malloc(sizeof(double)*(*amigo_model).n_times);                                                                          
}                                                                                                                                                              
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
(*amigo_model).ydot_results[i]=(double*)malloc(sizeof(double)*(*amigo_model).n_times);                                                                         
}                                                                                                                                                              
                                                                                                                                                               
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                                                                 
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                                                                   
(*amigo_model).sim_results[j][i]=0;                                                                                                                            
(*amigo_model).ydot_results[j][i]=0;                                                                                                                           
}                                                                                                                                                              
}                                                                                                                                                              
if((*amigo_model).sensi){                                                                                                                                      
/*First count how many parameters will be used for sensitivity analysis*/                                                                                      
/* we account for the estimated parameters and initial conditions*/                                                                                            
/*Number of parameters for Sens*/                                                                                                                              
counter=0;                                                                                                                                                     
amigo_model->n_opt_pars = 0;                                                                                                                                   
for (i = 0; i < (*amigo_model).n_pars; i++){                                                                                                                   
if((*amigo_model).is_opt_par[i] == 1){                                                                                                                         
counter++;                                                                                                                                                     
amigo_model->n_opt_pars +=1;                                                                                                                                   
}                                                                                                                                                              
else if((*amigo_model).is_opt_par[i] != 0) mexPrintf("ERROR: isoptpar[%d]=%d, should be 0 (not estimated) or 1 (estimated)\n ",i,(*amigo_model).is_opt_par[i]);
}                                                                                                                                                              
/* Add how many initial conditions are estimated.*/                                                                                                            
amigo_model->n_opt_ics = 0;                                                                                                                                    
amigo_model->index_opt_ics=(int*)malloc(sizeof(int)*amigo_model->n_states);                                                                                    
tmp = 0;                                                                                                                                                       
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
if((*amigo_model).is_opt_ic[i] == 1) {                                                                                                                         
counter++;                                                                                                                                                     
amigo_model->n_opt_ics +=1;                                                                                                                                    
amigo_model->index_opt_ics[tmp++]=i;                                                                                                                           
}                                                                                                                                                              
else if((*amigo_model).is_opt_ic[i] != 0) mexPrintf("ERROR: isoptic[%d]=%d, should be 0 (not estimated) or 1 (estimated)\n ",i,(*amigo_model).is_opt_ic[i]);   
}                                                                                                                                                              
                                                                                                                                                               
                                                                                                                                                               
/*The number of sensitivities depends on the is_opt_par and is_opt_ic*/                                                                                        
(*amigo_model).n_sens=counter;                                                                                                                                 
/*An array with parameters indexes, CVODES needs this.*/                                                                                                       
(*amigo_model).plist=(int*)malloc((*amigo_model).n_sens*sizeof(int));                                                                                          
/* Scaling parameters for sensitivity computations:*/                                                                                                          
(*amigo_model).pbar=(double*)malloc((*amigo_model).n_sens*sizeof(double));                                                                                     
/* Set-up pbar for estimated parameters:*/                                                                                                                     
counter=0;                                                                                                                                                     
for (i = 0; i < (*amigo_model).n_pars; i++){                                                                                                                   
if((*amigo_model).is_opt_par[i]){                                                                                                                              
(*amigo_model).plist[counter]=i;                                                                                                                               
if (fabs((*amigo_model).pars[i]) > 0)                                                                                                                          
(*amigo_model).pbar[counter] = fabs((*amigo_model).pars[i]);                                                                                                   
else                                                                                                                                                           
(*amigo_model).pbar[counter] = 1.0;                                                                                                                            
counter++;                                                                                                                                                     
}                                                                                                                                                              
}                                                                                                                                                              
/* Set-up pbar for estimated initial conditions:*/                                                                                                             
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
if((*amigo_model).is_opt_ic[i]){                                                                                                                               
(*amigo_model).plist[counter]=i+amigo_model->n_pars;                                                                                                           
if (fabs((*amigo_model).y0[i]) > 0)                                                                                                                            
(*amigo_model).pbar[counter] = fabs((*amigo_model).y0[i]);                                                                                                     
else                                                                                                                                                           
(*amigo_model).pbar[counter] = 1.0;                                                                                                                            
counter++;                                                                                                                                                     
}                                                                                                                                                              
}                                                                                                                                                              
                                                                                                                                                               
                                                                                                                                                               
                                                                                                                                                               
/* DEBUG Print*/                                                                                                                                               
/*counter = 0;                                                                                                                                                 
for (i = 0; i<(*amigo_model).n_pars; i++){                                                                                                                     
mexPrintf("%dth, opt: %d, %.4g\n",i,(*amigo_model).is_opt_par[i],(*amigo_model).pars[i]);                                                                      
if((*amigo_model).is_opt_par[i]){                                                                                                                              
mexPrintf("\tlist=%d,pbar: %.4g\n",(*amigo_model).plist[counter],(*amigo_model).pbar[counter] );                                                               
counter++;                                                                                                                                                     
}                                                                                                                                                              
}*/                                                                                                                                                            
/*Allocate memory for the results*/                                                                                                                            
(*amigo_model).sens_results=(double***)malloc(sizeof(double**)*(*amigo_model).n_states);                                                                       
(*amigo_model).sensdot_results=(double***)malloc(sizeof(double**)*(*amigo_model).n_states);                                                                    
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
(*amigo_model).sens_results[i]=(double**)malloc(sizeof(double*)*(*amigo_model).n_sens);                                                                        
(*amigo_model).sensdot_results[i]=(double**)malloc(sizeof(double*)*(*amigo_model).n_sens);                                                                     
for (j = 0; j < (*amigo_model).n_sens; j++){                                                                                                                   
(*amigo_model).sens_results[i][j]=(double*)malloc(sizeof(double)*(*amigo_model).n_times);                                                                      
(*amigo_model).sensdot_results[i][j]=(double*)malloc(sizeof(double)*(*amigo_model).n_times);                                                                   
for(k = 0; k < (*amigo_model).n_times; ++k){                                                                                                                   
(*amigo_model).sens_results[i][j][k] = 0;                                                                                                                      
(*amigo_model).sensdot_results[i][j][k] = 0;                                                                                                                   
}                                                                                                                                                              
}                                                                                                                                                              
}                                                                                                                                                              
}                                                                                                                                                              
return(amigo_model);                                                                                                                                           
}                                                                                                                                                              
AMIGO_model* set_parameters(AMIGO_model* amigo_model,double*pars){                                                                                             
return(amigo_model);                                                                                                                                           
}                                                                                                                                                              
AMIGO_model* set_rhs(AMIGO_model* amigo_model){                                                                                                                
(*amigo_model).rhs = amigoRHS;                                                                                                                                 
(*amigo_model).jac = &amigoJAC;                                                                                                                                
(*amigo_model).sensrhs = amigoSensRHS;                                                                                                                         
return(amigo_model);                                                                                                                                           
}                                                                                                                                                              
/*path+filename of dll or so*/                                                                                                                                 
/*TODO!!!!*/                                                                                                                                                   
AMIGO_model* set_rhs_dynamic(AMIGO_model* amigo_model){                                                                                                        
return(amigo_model);                                                                                                                                           
}                                                                                                                                                              
AMIGO_model *set_rhs_test(AMIGO_model* amigo_model){                                                                                                           
(*amigo_model).rhs=amigoRHS;                                                                                                                                   
return(amigo_model);                                                                                                                                           
}                                                                                                                                                              
/*Free Memory*/                                                                                                                                                
void free_AMIGO_model(AMIGO_model* amigo_model){                                                                                                               
int i,j;                                                                                                                                                       
free((*amigo_model).is_opt_par);                                                                                                                               
(*amigo_model).is_opt_par = NULL;                                                                                                                              
free((*amigo_model).is_opt_ic);                                                                                                                                
(*amigo_model).is_opt_ic = NULL;                                                                                                                               
free((*amigo_model).pars);                                                                                                                                     
(*amigo_model).pars = NULL;                                                                                                                                    
free((*amigo_model).y0);                                                                                                                                       
(*amigo_model).y0 = NULL;                                                                                                                                      
free((*amigo_model).t);                                                                                                                                        
(*amigo_model).t = NULL;                                                                                                                                       
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
free((*amigo_model).sim_results[i]);                                                                                                                           
(*amigo_model).sim_results[i] = NULL;                                                                                                                          
}free((*amigo_model).sim_results);                                                                                                                             
(*amigo_model).sim_results = NULL;                                                                                                                             
                                                                                                                                                               
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
free((*amigo_model).ydot_results[i]);                                                                                                                          
(*amigo_model).ydot_results[i] = NULL;                                                                                                                         
}free((*amigo_model).ydot_results);                                                                                                                            
(*amigo_model).ydot_results = NULL;                                                                                                                            
                                                                                                                                                               
if((*amigo_model).sensi){                                                                                                                                      
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
for (j = 0; j < (*amigo_model).n_sens; j++){                                                                                                                   
free((*amigo_model).sens_results[i][j]);                                                                                                                       
free((*amigo_model).sensdot_results[i][j]);                                                                                                                    
}                                                                                                                                                              
free((*amigo_model).sens_results[i]);                                                                                                                          
free((*amigo_model).sensdot_results[i]);                                                                                                                       
}                                                                                                                                                              
free((*amigo_model).sens_results);                                                                                                                             
free((*amigo_model).sensdot_results);                                                                                                                          
free((*amigo_model).plist);                                                                                                                                    
free((*amigo_model).pbar);                                                                                                                                     
free((*amigo_model).index_opt_ics);                                                                                                                            
(*amigo_model).index_opt_ics = NULL;                                                                                                                           
}                                                                                                                                                              
free((*amigo_model).controls_t);                                                                                                                               
for (i = 0; i < (*amigo_model).n_controls; i++){                                                                                                               
free((*amigo_model).controls_v[i]);                                                                                                                            
free((*amigo_model).slope[i]);                                                                                                                                 
}                                                                                                                                                              
free((*amigo_model).controls_v);                                                                                                                               
free((*amigo_model).slope);                                                                                                                                    
free(amigo_model);                                                                                                                                             
}                                                                                                                                                              
/*For tests only*/                                                                                                                                             
void print_amigo_model(AMIGO_model* amigo_model)                                                                                                               
{                                                                                                                                                              
int i,j;                                                                                                                                                       
printf("Model name %s\n",(*amigo_model).model_name);                                                                                                           
printf("%s\n","initial conditions");                                                                                                                           
for (i = 0; i < (*amigo_model).n_pars; i++){                                                                                                                   
printf("Parameter %d value=%f\n",i,(*amigo_model).pars[i]);                                                                                                    
printf("Parameter %d optPar=%d\n",i,(*amigo_model).is_opt_par[i]);                                                                                             
}                                                                                                                                                              
printf("Number of sensitivities: %d\nIndexes:",(*amigo_model).n_sens);                                                                                         
if((*amigo_model).sensi){                                                                                                                                      
for (i = 0; i < (*amigo_model).n_sens; i++){                                                                                                                   
printf("%d, ",(*amigo_model).plist[i]);                                                                                                                        
}                                                                                                                                                              
}                                                                                                                                                              
printf("\n");                                                                                                                                                  
for (i = 0; i < (*amigo_model).n_states; i++){                                                                                                                 
printf("State %d initial conditions=%f\n",i,(*amigo_model).y0[i]);                                                                                             
}                                                                                                                                                              
printf("Initial simulation time %f\n", (*amigo_model).t0);                                                                                                     
printf("Final simulation time %f\n", (*amigo_model).tf);                                                                                                       
printf("Number of controls: %d\n", (*amigo_model).n_controls);                                                                                                 
printf("Number of control times: %d\n", (*amigo_model).n_controls_t);                                                                                          
for (i = 0; i < (*amigo_model).n_controls; i++){                                                                                                               
for (j= 0; j < (*amigo_model).n_controls_t-1; j++){                                                                                                            
printf("Control %d at t=%f (index=%d) v=%f\n",i,(*amigo_model).controls_t[j],j,(*amigo_model).controls_v[i][j]);                                               
}                                                                                                                                                              
}                                                                                                                                                              
                                                                                                                                                               
for (j= 0; j < (*amigo_model).n_controls_t-1; j++){                                                                                                            
printf("Slope%d: at t=%f slope=%f\n",j,(*amigo_model).controls_t[j],(*amigo_model).slope[j]);                                                                  
}                                                                                                                                                              
                                                                                                                                                               
}                                                                                                                                                              
/*Printf the sim_results field, make sure you have run the simulation*/                                                                                        
/*At least once, otherwise the values will be unitialized*/                                                                                                    
void print_sim_results(AMIGO_model* amigo_model){                                                                                                              
int i,j;                                                                                                                                                       
printf("\n\t\ter");                                                                                                                                            
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                                                                 
printf("y%d\t\t",j);                                                                                                                                           
}                                                                                                                                                              
printf("\n");                                                                                                                                                  
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                                                                   
printf("t=%f\t",(*amigo_model).t[i]);                                                                                                                          
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                                                                 
printf("%f\t",(*amigo_model).sim_results[j][i]);                                                                                                               
}                                                                                                                                                              
printf("\n");                                                                                                                                                  
}                                                                                                                                                              
}                                                                                                                                                              
