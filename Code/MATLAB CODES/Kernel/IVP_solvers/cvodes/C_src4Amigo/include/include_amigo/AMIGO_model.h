#pragma once                                                                                                                                    
#include <stdio.h>                                                                                                                              
#include <stdlib.h>                                                                                                                             
#include "mex.h"                                                                                                                                
#include <cvodes/cvodes_dense.h>                                                                                                                
#include <sundials/sundials_types.h> /* definition of type realtype */                                                                          
#include <nvector/nvector_serial.h>/* serial N_Vector types, fcts., and macros */                                                               
#include <sundials/sundials_math.h>                                                                                                             
#include <amigoRHS.h>                                                                                                                           
#include <amigoJAC.h>                                                                                                                           
#include <amigoSensRHS.h>                                                                                                                       
#include <simulate_amigo_model.h>                                                                                                               
#include <math.h>                                                                                                                               
#ifdef _MSC_VER                                                                                                                                 
#define INFINITY (DBL_MAX+DBL_MAX)                                                                                                              
#define NAN (INFINITY-INFINITY)                                                                                                                 
#endif                                                                                                                                          
#define Ith(v,i) ( NV_DATA_S(v)[i] )                                                                                                            
#define IJth(A,i,j) DENSE_ELEM(A,i,j)                                                                                                           
#ifndef max                                                                                                                                     
#define max( a, b ) ( ((a) > (b)) ? (a) : (b) )                                                                                                 
#endif                                                                                                                                          
#ifndef min                                                                                                                                     
#define min( a, b ) ( ((a) < (b)) ? (a) : (b) )                                                                                                 
#endif                                                                                                                                          
                                                                                                                                                
#ifndef fmax                                                                                                                                    
#define fmax( a, b )  (max(a,b))                                                                                                                
#endif                                                                                                                                          
typedef struct{                                                                                                                                 
long int nSteps, nRhsEval, nLocalErrorFailure, nNonlinSolvIteration, nNonlinConvFailure, nJacobianEval, nFDrhscall;                             
long int nSensRHSeval, nRHSevalforSens, nSensLocalErrorFailure, nSensLinSolvSetups, nSensNonlinIters,nSensNonlinConvFailure;                    
}CVODES_REPORT;                                                                                                                                 
typedef struct                                                                                                                                  
{                                                                                                                                               
int n_states;                                                                                                                                   
int n_pars;                                                                                                                                     
int n_opt_pars;                                                                                                                                 
int n_opt_ics;                                                                                                                                  
int sensi;                                                                                                                                      
double* pars;                                                                                                                                   
int* is_opt_par;                                                                                                                                
int* is_opt_ic;                                                                                                                                 
int* index_opt_ics;                                                                                                                             
char* model_name;                                                                                                                               
double t0;                                                                                                                                      
double tf;                                                                                                                                      
double* t;                                                                                                                                      
int n_times;                                                                                                                                    
double* y0;                                                                                                                                     
int n_controls;                                                                                                                                 
int n_controls_t;                                                                                                                               
double* controls_t;                                                                                                                             
double** controls_v;                                                                                                                            
double** slope;                                                                                                                                 
double tlast;                                                                                                                                   
int index_t_stim;                                                                                                                               
int(*rhs)(realtype,N_Vector, N_Vector, void*);                                                                                                  
/*int(*jac)(int, realtype,N_Vector, N_Vector, DlsMat, void*, N_Vector, N_Vector, N_Vector);*/                                                   
CVDlsDenseJacFn jac;                                                                                                                            
int(*sensrhs)(int, realtype, N_Vector, N_Vector, int, N_Vector, N_Vector, void*, N_Vector,N_Vector);  /* modification by GA: sensitivity R.H.S*/
void (*jY)(int);                                                                                                                                
void (*jS)(int);                                                                                                                                
double** sim_results;                                                                                                                           
double** ydot_results;                                                                                                                          
double ***sens_results;                                                                                                                         
double ***sensdot_results;                                                                                                                      
double reltol;                                                                                                                                  
double atol;                                                                                                                                    
double max_step_size;                                                                                                                           
int max_num_steps;                                                                                                                              
int max_error_test_fails;                                                                                                                       
int use_jacobian;                                                                                                                               
int* plist;                                                                                                                                     
double* pbar;                                                                                                                                   
int n_sens;                                                                                                                                     
int exp_num;                                                                                                                                    
CVODES_REPORT cvodesReport;                                                                                                                     
                                                                                                                                                
}AMIGO_model;                                                                                                                                   
/*Does Memory Initialization for an AMIGO_model*/                                                                                               
AMIGO_model* new_AMIGO_model                                                                                                                    
(                                                                                                                                               
int n_states,		int n_pars,			int n_times,                                                                                                       
int n_controls,		int n_controls_t,	int(*rhs)(realtype,N_Vector,N_Vector, void*)                                                                 
);                                                                                                                                              
/*Initialization for matlab, dont forget mex.h*/                                                                                                
AMIGO_model* new_AMIGO_model_matlab(const mxArray *prhs[]);                                                                                     
AMIGO_model* new_AMIGO_model_test();                                                                                                            
/*Change parameters values*/                                                                                                                    
AMIGO_model* set_parameters(AMIGO_model* amigo_model,double*pars);                                                                              
/*All compiled toghether*/                                                                                                                      
AMIGO_model* set_rhs(AMIGO_model* amigo_model);                                                                                                 
/*path+filename.dll or so (at least thats is the initial inetention)*/                                                                          
AMIGO_model *set_rhs_dynamic(AMIGO_model* amigo_model);                                                                                         
AMIGO_model *set_rhs_test(AMIGO_model* amigo_model);                                                                                            
void free_AMIGO_model(AMIGO_model* amigo_model);                                                                                                
void print_amigo_model(AMIGO_model* amigo_model);                                                                                               
AMIGO_model* allocate_AMIGO_model_results(AMIGO_model * amigo_model);                                                                           
void test_amigo_model();                                                                                                                        
int simulate_amigo_model(AMIGO_model* amigo_model,int verbose);                                                                                 
void print_amigo_model(AMIGO_model* amigo_model);                                                                                               
void print_sim_results(AMIGO_model* amigo_model);                                                                                               
