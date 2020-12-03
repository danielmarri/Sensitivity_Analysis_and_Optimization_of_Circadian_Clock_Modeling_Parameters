#include <stdlib.h>                                                                                                   
#include "mex.h"                                                                                                      
#include <AMIGO_model.h>                                                                                              
#include <stdio.h>                                                                                                    
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ){                                       
double *output_sim_data = NULL;                                                                                       
double *output_sens_data = NULL;                                                                                      
double *output_ydot_data = NULL;                                                                                      
double *output_sensdot_data = NULL;                                                                                   
int verbose = 0;                                                                                                      
int dims[3];                                                                                                          
double* sim_flag=NULL;                                                                                                
int counter=0;                                                                                                        
int i,j,k,flag;                                                                                                       
const char *stats_names[] = {"nSteps", "nRhsEval", "nLocalErrorFailure", "nNonlinSolvIteration", "nNonlinConvFailure",
"nJacobianEval", "nFDrhscall", "nSensRHSeval", "nRHSevalforSens","nSensLocalErrorFailure",                            
"nLinSolvSetups", "nSensNonlinIters","nSensNonlinConvFailure"};                                                       
mwSize stat_dims[2]={1,1};                                                                                            
mxArray  *stats_value;                                                                                                
mxArray *stats_struct;                                                                                                
AMIGO_model* amigo_model = new_AMIGO_model_matlab(prhs);                                                              
if ( amigo_model == NULL){                                                                                            
mexErrMsgTxt("Error during the initialization of amigo_model in the MEX file. Exiting...");                           
return;                                                                                                               
}                                                                                                                     
                                                                                                                      
                                                                                                                      
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);		/* CVODES statistics*/                                               
dims[0]=(*amigo_model).n_times;                                                                                       
dims[1]=(*amigo_model).n_states;                                                                                      
dims[2]=(*amigo_model).n_sens;                                                                                        
/* allocate space for the output trajectories*/                                                                       
plhs[0] = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);                                                      
output_sim_data= mxGetPr(plhs[0]);                                                                                    
dims[0]=1;                                                                                                            
dims[1]=1;                                                                                                            
/* allocate space for the termination flag*/                                                                          
plhs[1]= mxCreateNumericArray(1, dims , mxDOUBLE_CLASS, mxREAL);                                                      
sim_flag = mxGetPr(plhs[1]);                                                                                          
                                                                                                                      
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
(*amigo_model).sim_results[j][i]=mxGetNaN();;                                                                         
}                                                                                                                     
}                                                                                                                     
/*                                                                                                                    
If sensitivity analysis option is chosen return a third variable with the solution                                
3 Dimension States,parameters and sampled times                                                                   
if((*amigo_model).sensi){                                                                                             
dims[0]=(*amigo_model).n_times;                                                                                       
dims[1]=(*amigo_model).n_states;                                                                                      
dims[2]=(*amigo_model).n_sens;                                                                                        
plhs[2]= mxCreateNumericArray(3, dims , mxDOUBLE_CLASS, mxREAL);                                                      
output_sens_data = mxGetPr(plhs[2]);                                                                                  
counter=0;                                                                                                            
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
for (k = 0; k < (*amigo_model).n_sens; ++k){                                                                          
output_sens_data[counter++]=mxGetNaN();                                                                               
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}*/                                                                                                                   
if(verbose)printf("start simulate amigo model\n");                                                                    
flag=simulate_amigo_model(amigo_model,verbose);                                                                       
if(verbose)printf("simulate amigo model ended\n");                                                                    
sim_flag[0]=flag;                                                                                                     
                                                                                                                      
/*if(flag){*/                                                                                                         
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
output_sim_data[counter++]=(*amigo_model).sim_results[j][i];                                                          
}                                                                                                                     
}                                                                                                                     
/*}*/                                                                                                                 
/*                                                                                                                    
else{                                                                                                                 
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
output_sim_data[counter++]=mxGetNaN();                                                                                
}                                                                                                                     
}                                                                                                                     
}*/                                                                                                                   
/*If sensitivity analysis option is chosen return a third variable with the solution*/                                
/*3 Dimension States,parameters and sampled times*/                                                                   
if(verbose)printf("creating sensitivity output\n");                                                                   
if((*amigo_model).sensi){                                                                                             
dims[0]=(*amigo_model).n_times;                                                                                       
dims[1]=(*amigo_model).n_states;                                                                                      
dims[2]=(*amigo_model).n_sens;                                                                                        
/* allocate memory for the sensitivity results*/                                                                      
plhs[2]= mxCreateNumericArray(3, dims , mxDOUBLE_CLASS, mxREAL);                                                      
output_sens_data = mxGetPr(plhs[2]);                                                                                  
counter=0;                                                                                                            
if(!flag){                                                                                                            
for (k = 0; k < (*amigo_model).n_sens; ++k){                                                                          
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
output_sens_data[counter++]=(*amigo_model).sens_results[j][k][i];                                                     
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
else{                                                                                                                 
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
for (k = 0; k < (*amigo_model).n_sens; ++k){                                                                          
output_sens_data[counter++]=mxGetNaN();                                                                               
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}else{/* initialize the output*/                                                                                      
dims[0] = 1;                                                                                                          
dims[1] = 1;                                                                                                          
plhs[2]= mxCreateNumericArray(2, dims , mxDOUBLE_CLASS, mxREAL);                                                      
/*mxGetPr(plhs[2])[0] = mxGetNaN();*/                                                                                 
}                                                                                                                     
                                                                                                                      
if(verbose)printf("creating ydot output\n");                                                                          
if (nlhs > 3){                                                                                                        
dims[0]=(*amigo_model).n_times;                                                                                       
dims[1]=(*amigo_model).n_states;                                                                                      
plhs[3] = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);                                                      
output_ydot_data= mxGetPr(plhs[3]);                                                                                   
if(!flag){                                                                                                            
for (j = 0, counter = 0; j < (*amigo_model).n_states; ++j){                                                           
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
output_ydot_data[counter++]=(*amigo_model).ydot_results[j][i];                                                        
}                                                                                                                     
}                                                                                                                     
}else{                                                                                                                
for (j = 0, counter = 0; j < (*amigo_model).n_states; ++j){                                                           
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
output_ydot_data[counter++]=mxGetNaN();                                                                               
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
if(verbose)printf("creating sensitivity_dot output\n");                                                               
if (nlhs > 4){                                                                                                        
if((*amigo_model).sensi){                                                                                             
dims[0]=(*amigo_model).n_times;                                                                                       
dims[1]=(*amigo_model).n_states;                                                                                      
dims[2]=(*amigo_model).n_sens;                                                                                        
plhs[4]= mxCreateNumericArray(3, dims , mxDOUBLE_CLASS, mxREAL);                                                      
output_sensdot_data = mxGetPr(plhs[4]);                                                                               
counter=0;                                                                                                            
if(!flag){                                                                                                            
for (k = 0; k < (*amigo_model).n_sens; ++k){                                                                          
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
output_sensdot_data[counter++]=(*amigo_model).sensdot_results[j][k][i];                                               
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
else{                                                                                                                 
for (i = 0; i <(*amigo_model).n_times; ++i){                                                                          
for (j = 0; j < (*amigo_model).n_states; ++j){                                                                        
for (k = 0; k < (*amigo_model).n_sens; ++k){                                                                          
output_sensdot_data[counter++]=mxGetNaN();                                                                            
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
}                                                                                                                     
else/* initialize the output*/                                                                                        
{                                                                                                                     
dims[0] = 1;                                                                                                          
dims[1] = 1;                                                                                                          
plhs[4]= mxCreateNumericArray(2, dims , mxDOUBLE_CLASS, mxREAL);                                                      
/*mxGetPr(plhs[2])[0] = mxGetNaN();*/                                                                                 
}                                                                                                                     
}                                                                                                                     
/* pass the CVODES report back in a mxStructure.*/                                                                    
if(verbose)printf("creating CVODES report structure\n");                                                              
if (nlhs > 5){                                                                                                        
if(!flag){                                                                                                            
plhs[5] = mxCreateStructArray(2, stat_dims,13,stats_names);                                                           
stats_struct = mxGetPr(plhs[5]);                                                                                      
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nSteps;                                                   
mxSetField(stats_struct, 0,"nSteps", stats_value);                                                                    
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nRhsEval;                                                 
mxSetField(stats_struct, 0,"nRhsEval", stats_value);                                                                  
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nLocalErrorFailure;                                       
mxSetField(stats_struct, 0,"nLocalErrorFailure", stats_value);                                                        
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nNonlinSolvIteration;                                     
mxSetField(stats_struct, 0,"nNonlinSolvIteration", stats_value);                                                      
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nNonlinConvFailure;                                       
mxSetField(stats_struct, 0,"nNonlinConvFailure", stats_value);                                                        
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nJacobianEval;                                            
mxSetField(stats_struct, 0,"nJacobianEval", stats_value);                                                             
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nFDrhscall;                                               
mxSetField(stats_struct, 0,"nFDrhscall", stats_value);                                                                
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nSensRHSeval;                                             
mxSetField(stats_struct, 0,"nSensRHSeval", stats_value);                                                              
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nRHSevalforSens;                                          
mxSetField(stats_struct, 0,"nRHSevalforSens", stats_value);                                                           
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nSensLocalErrorFailure;                                   
mxSetField(stats_struct, 0,"nSensLocalErrorFailure", stats_value);                                                    
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nSensLinSolvSetups;                                       
mxSetField(stats_struct, 0,"nSensLinSolvSetups", stats_value);                                                        
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nSensNonlinIters;                                         
mxSetField(stats_struct, 0,"nSensNonlinIters", stats_value);                                                          
stats_value = mxCreateDoubleMatrix(1,1,mxREAL);                                                                       
mxGetPr(stats_value)[0]=(double)(*amigo_model).cvodesReport.nSensNonlinConvFailure;                                   
mxSetField(stats_struct, 0,"nSensNonlinConvFailure", stats_value);                                                    
}else{                                                                                                                
dims[0] = 1;                                                                                                          
dims[1] = 1;                                                                                                          
plhs[5]= mxCreateNumericArray(2, dims , mxDOUBLE_CLASS, mxREAL);                                                      
}                                                                                                                     
                                                                                                                      
}                                                                                                                     
if(verbose)printf("free AMIGO model\n");                                                                              
free_AMIGO_model(amigo_model);                                                                                        
if(verbose)printf("AMIGO model freed.\n");                                                                            
}                                                                                                                     
