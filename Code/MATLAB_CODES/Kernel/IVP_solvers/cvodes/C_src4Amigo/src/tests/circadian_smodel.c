#include <circadian_smodel.h>                                                                                                              
int run_circadian_smodel()                                                                                                                 
{                                                                                                                                          
AMIGO_experiment* amigo_experiment_1;                                                                                                      
AMIGO_experiment* amigo_experiment_2;                                                                                                      
AMIGO_problem* amigo_problem;                                                                                                              
double error;                                                                                                                              
int i,j,k, flag;                                                                                                                           
const int n_pars=27;                                                                                                                       
const int n_st=7;                                                                                                                          
const int n_observables=2;                                                                                                                 
const int n_stimuli=1;                                                                                                                     
const int n_controls_t_exp1=2;                                                                                                             
const int n_controls_t_exp2=11;                                                                                                            
const int n_sens=27;                                                                                                                       
const int sensi=0;                                                                                                                         
const int n_times_exp1=15;                                                                                                                 
const int n_times_exp2=25;                                                                                                                 
char model_name[]="circadian_smodel";                                                                                                      
const double reltol=1e-9;                                                                                                                  
const double atol=1e-9;                                                                                                                    
const int max_num_steps=100000;                                                                                                            
const int max_error_test_fails=50;                                                                                                         
const double n1=7.5038;	const double n2=0.6801 ;                                                                                           
const double g1=1.4992;	const double g2=3.0412;                                                                                            
const double m1=10.0982;const double m2=1.9685;                                                                                            
const double m3=3.7511;	const double m4= 2.3422;                                                                                           
const double m5=7.2482;	const double m6=1.8981;                                                                                            
const double m7=1.2;	const double k1=3.8045;                                                                                               
const double k2=5.3087;	const double k3=4.1946;                                                                                            
const double k4=2.5356;	const double k5=1.4420;                                                                                            
const double k6=4.8600;	const double k7=1.2;                                                                                               
const double p1=2.1994;	const double p2=9.4440;                                                                                            
const double p3=0.5;	const double r1=0.2817;                                                                                               
const double r2=0.7676;	const double r3=0.4364;                                                                                            
const double r4=7.3021; const double q1=4.5703;                                                                                            
const double q2=1.0;                                                                                                                       
double pars[27]={                                                                                                                          
n1, n2, g1, g2, m1, m2, m3,                                                                                                                
m4, m5, m6, m7, k1, k2, k3,k4, k5, k6,                                                                                                     
k7,p1, p2, p3, r1, r2, r3, r4, q1, q2                                                                                                      
};                                                                                                                                         
const double y0[7]={0, 0, 0, 0, 0, 0, 0};                                                                                                  
const double t_con_exp1[2]={0,120};                                                                                                        
const double t_con_exp2[11]={0, 12, 24, 26, 48, 60, 72 ,84, 96, 108,120};                                                                  
const double u_exp1[1][1]={                                                                                                                
{1}                                                                                                                                        
};                                                                                                                                         
const double u_exp2[1][10]={                                                                                                               
{1,0,1,0,1,0,1,0,1,0}                                                                                                                      
};                                                                                                                                         
const double is_opt_par[27]={                                                                                                              
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,                                                                                                           
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,                                                                                                           
1, 1, 1, 1, 1                                                                                                                              
};                                                                                                                                         
const double t0=0;                                                                                                                         
const double tf=120;                                                                                                                       
const double t_exp1[15]={                                                                                                                  
0.000e+00,	8.571e+00, 1.714e+01, 2.571e+01, 3.429e+01, 4.286e+01,                                                                          
5.143e+01, 6.000e+01, 6.857e+01, 7.714e+01, 8.571e+01, 9.429e+01,                                                                          
1.029e+02, 1.114e+02, 1.200e+02                                                                                                            
};                                                                                                                                         
double t_exp2[25]={                                                                                                                        
0.000e+00,	5.000e+00,	1.000e+01,  1.500e+01,  2.000e+01,  2.500e+01,                                                                       
3.000e+01,  3.500e+01,  4.000e+01,  4.500e+01,  5.000e+01,  5.500e+01,                                                                     
6.000e+01,  6.500e+01,  7.000e+01,	7.500e+01,  8.000e+01,  8.500e+01,                                                                      
9.000e+01,  9.500e+01,  1.000e+02,  1.050e+02,  1.100e+02,  1.150e+02,                                                                     
1.200e+02                                                                                                                                  
};                                                                                                                                         
double slope_exp1[1]={0};                                                                                                                  
double slope_exp2[10]={0, 0, 0, 0, 0, 0, 0, 0, 0, 0};                                                                                      
double const exp_data1[15][2]={                                                                                                            
{0.037642,	0.059832},                                                                                                                      
{1.398618,	0.983442},                                                                                                                      
{1.606762,  0.433379},                                                                                                                     
{0.265345,  0.628819},                                                                                                                     
{1.417288,  0.858973},                                                                                                                     
{1.381613,  0.496637},                                                                                                                     
{0.504584,  0.717923},                                                                                                                     
{1.240249,  0.862584},                                                                                                                     
{1.180193,  0.634508},                                                                                                                     
{0.775945,  0.679648},                                                                                                                     
{1.514514,  0.735783},                                                                                                                     
{0.904653,  0.593644},                                                                                                                     
{0.753736,  0.759013},                                                                                                                     
{1.389312,  0.678665},                                                                                                                     
{0.833228,  0.574736},                                                                                                                     
};                                                                                                                                         
double const exp_data2[25][2]={                                                                                                            
{0.146016,	0.018152},                                                                                                                      
{0.831813,  1.002499},                                                                                                                     
{1.874870,  0.816779},                                                                                                                     
{1.927580,  0.544111},                                                                                                                     
{1.139536,  0.354476},                                                                                                                     
{0.876938,  0.520424},                                                                                                                     
{0.559600,  0.802322},                                                                                                                     
{1.273548,  0.939453},                                                                                                                     
{1.696482,  0.687495},                                                                                                                     
{1.065496,  0.577896},                                                                                                                     
{0.847460,  0.524076},                                                                                                                     
{0.517520,  0.738095},                                                                                                                     
{1.162232,	0.826737},                                                                                                                      
{1.421504,  0.779833},                                                                                                                     
{1.340639,  0.550493},                                                                                                                     
{0.563822,  0.515605},                                                                                                                     
{0.402755,  0.714877},                                                                                                                     
{1.029856,  0.871118},                                                                                                                     
{1.490741,	0.840174},                                                                                                                      
{1.580873,  0.692047},                                                                                                                     
{0.696610,  0.459481},                                                                                                                     
{0.141546,  0.646803},                                                                                                                     
{0.804194,  0.925806},                                                                                                                     
{1.622378,  0.824711},                                                                                                                     
{1.525194,  0.537398},                                                                                                                     
};                                                                                                                                         
double const error_data1[15][2]={                                                                                                          
{0.037642,  0.059832},                                                                                                                     
{0.072461,  0.013999},                                                                                                                     
{0.002877,  0.020809},                                                                                                                     
{0.050324,  0.002705},                                                                                                                     
{0.042936,  0.017832},                                                                                                                     
{0.044338,  0.022538},                                                                                                                     
{0.016335,  0.017981},                                                                                                                     
{0.164745,  0.035301},                                                                                                                     
{0.010631,  0.102381},                                                                                                                     
{0.127745,  0.065791},                                                                                                                     
{0.081671,  0.049568},                                                                                                                     
{0.126739,  0.050306},                                                                                                                     
{0.006308,  0.018894},                                                                                                                     
{0.054665,  0.066953},                                                                                                                     
{0.082163,  0.015295}                                                                                                                      
};                                                                                                                                         
double const error_data2[25][2]={                                                                                                          
{0.146016,  0.018152},                                                                                                                     
{0.066547,  0.045194},                                                                                                                     
{0.184009,  0.101495},                                                                                                                     
{0.047431,  0.030858},                                                                                                                     
{0.175280,  0.033712},                                                                                                                     
{0.031945,  0.048733},                                                                                                                     
{0.107148,  0.008715},                                                                                                                     
{0.019847,  0.072804},                                                                                                                     
{0.111892,  0.001840},                                                                                                                     
{0.104932,  0.058752},                                                                                                                     
{0.059721,  0.033324},                                                                                                                     
{0.056537,  0.000360},                                                                                                                     
{0.051815,  0.037473},                                                                                                                     
{0.103393,  0.028094},                                                                                                                     
{0.008084,  0.012024},                                                                                                                     
{0.188444,  0.022982},                                                                                                                     
{0.046354,  0.031981},                                                                                                                     
{0.043436,  0.003749},                                                                                                                     
{0.030177,  0.042560},                                                                                                                     
{0.116245,  0.110535},                                                                                                                     
{0.059345,  0.025112},                                                                                                                     
{0.218587,  0.000564},                                                                                                                     
{0.115783,  0.043708},                                                                                                                     
{0.099239,  0.002678},                                                                                                                     
{0.010644,  0.052990}                                                                                                                      
};                                                                                                                                         
/*Do it N_Times to make sure there are no huge memory leaks*/                                                                              
for (k = 0; k < 1; k++) {                                                                                                                  
/*Here we start all memory allocation,*/                                                                                                   
amigo_problem=new_AMIGO_problem(2, n_pars);                                                                                                
amigo_experiment_1=new_AMIGO_experiment_no_model(n_st, n_pars, n_times_exp1, n_observables, n_stimuli, n_controls_t_exp1,circadian_smodel);
amigo_experiment_2=new_AMIGO_experiment_no_model(n_st, n_pars, n_times_exp2, n_observables, n_stimuli, n_controls_t_exp2,circadian_smodel);
amigo_experiment_1=allocate_AMIGO_experiment_results(amigo_experiment_1,0);                                                                
amigo_experiment_2=allocate_AMIGO_experiment_results(amigo_experiment_2,0);                                                                
amigo_problem->amigo_experiments[0]=amigo_experiment_1;                                                                                    
amigo_problem->amigo_experiments[1]=amigo_experiment_2;                                                                                    
/*Memory allocation Ends here. No more mallocs. Dont forget to free!!*/                                                                    
/*Here we start copying into allocated space*/                                                                                             
for (i = 0; i < n_pars; ++i){                                                                                                              
amigo_problem->pars[i]=pars[i];                                                                                                            
amigo_problem->LB[i]=pars[i]*0.1;                                                                                                          
amigo_problem->UB[i]=pars[i]*10;                                                                                                           
amigo_problem->is_opt_par[i]=is_opt_par[i];                                                                                                
}                                                                                                                                          
                                                                                                                                           
/*Experimental Data, remember to include experimental error at some-point*/                                                                
for (i = 0; i < n_observables; ++i){                                                                                                       
for (j = 0; j < n_times_exp1; ++j){                                                                                                        
amigo_problem->amigo_experiments[0]->exp_data[i][j]=exp_data1[j][i];                                                                       
amigo_problem->amigo_experiments[0]->error_data[i][j]=error_data1[j][i];                                                                   
}                                                                                                                                          
for (j = 0; j < n_times_exp2; ++j){                                                                                                        
amigo_problem->amigo_experiments[1]->exp_data[i][j]=exp_data2[j][i];                                                                       
amigo_problem->amigo_experiments[1]->error_data[i][j]=error_data2[j][i];                                                                   
}                                                                                                                                          
}                                                                                                                                          
for (i = 0; i < n_stimuli; ++i){                                                                                                           
for (j = 0; j < n_controls_t_exp1; ++j){                                                                                                   
amigo_problem->amigo_experiments[0]->controls_t[j]=t_con_exp1[i];                                                                          
if(j>n_controls_t_exp1-1){                                                                                                                 
amigo_problem->amigo_experiments[0]->controls_v[i][j]=u_exp1[j][i];                                                                        
}                                                                                                                                          
}                                                                                                                                          
for (j = 0; j < n_controls_t_exp2; ++j){                                                                                                   
amigo_problem->amigo_experiments[1]->controls_t[j]=t_con_exp2[j];                                                                          
if(j>n_controls_t_exp2-1){                                                                                                                 
amigo_problem->amigo_experiments[1]->controls_v[i][j]=u_exp2[i][j];                                                                        
}                                                                                                                                          
}                                                                                                                                          
}                                                                                                                                          
/*Define experiment times*/                                                                                                                
for (i = 0; i < n_times_exp1; ++i){                                                                                                        
amigo_problem->amigo_experiments[0]->t[i]=t_exp1[i];                                                                                       
}                                                                                                                                          
for (i = 0; i < n_times_exp2; ++i){                                                                                                        
amigo_problem->amigo_experiments[1]->t[i]=t_exp2[i];                                                                                       
}                                                                                                                                          
/*Define initial times*/                                                                                                                   
amigo_problem->amigo_experiments[0]->t0=t0;                                                                                                
amigo_problem->amigo_experiments[1]->t0=t0;                                                                                                
                                                                                                                                           
/*Define FInal times*/                                                                                                                     
amigo_problem->amigo_experiments[0]->tf=tf;                                                                                                
amigo_problem->amigo_experiments[1]->tf=tf;                                                                                                
/*Define an observation function*/                                                                                                         
amigo_problem=set_AMIGO_problem_custom_observation_function(amigo_problem,circadian_gen_obs);                                              
/*Update the parameters from the AMIGO_experiment into the several instances of AMIGO_problem*/                                            
amigo_problem=update_AMIGO_problem_pars(amigo_problem);                                                                                    
                                                                                                                                           
/*Evaluate!*/                                                                                                                              
error=evaluate_AMIGO_problem(amigo_problem);                                                                                               
/*print_sim_results(amigo_problem->amigo_experiments[0]->amigo_model);*/                                                                   
print_observables(amigo_problem->amigo_experiments[0]);                                                                                    
/*print_sim_results(amigo_problem->amigo_experiments[0]->amigo_model);*/                                                                   
printf("error%f\n",error);                                                                                                                 
free_AMIGO_problem_and_experiments(amigo_problem);                                                                                         
}                                                                                                                                          
return(1);                                                                                                                                 
}                                                                                                                                          
int circadian_smodel(realtype t, N_Vector y, N_Vector ydot, void *data){                                                                   
AMIGO_model* amigo_model=(AMIGO_model*)data;                                                                                               
double	CL_m=Ith(y,0);                                                                                                                      
double	CL_c=Ith(y,1);                                                                                                                      
double	CL_n=Ith(y,2);                                                                                                                      
double	CT_m=Ith(y,3);                                                                                                                      
double	CT_c=Ith(y,4);                                                                                                                      
double	CT_n=Ith(y,5);                                                                                                                      
double	CP_n=Ith(y,6);                                                                                                                      
double	dCL_m;                                                                                                                              
double	dCL_c;                                                                                                                              
double	dCL_n;                                                                                                                              
double	dCT_m;                                                                                                                              
double	dCT_c;                                                                                                                              
double	dCT_n;                                                                                                                              
double	dCP_n;                                                                                                                              
double	n1=(*amigo_model).nominal_pars[0];                                                                                                  
double	n2=(*amigo_model).nominal_pars[1];                                                                                                  
double	g1=(*amigo_model).nominal_pars[2];                                                                                                  
double	g2=(*amigo_model).nominal_pars[3];                                                                                                  
double	m1=(*amigo_model).nominal_pars[4];                                                                                                  
double	m2=(*amigo_model).nominal_pars[5];                                                                                                  
double	m3=(*amigo_model).nominal_pars[6];                                                                                                  
double	m4=(*amigo_model).nominal_pars[7];                                                                                                  
double	m5=(*amigo_model).nominal_pars[8];                                                                                                  
double	m6=(*amigo_model).nominal_pars[9];                                                                                                  
double	m7=(*amigo_model).nominal_pars[10];                                                                                                 
double	k1=(*amigo_model).nominal_pars[11];                                                                                                 
double	k2=(*amigo_model).nominal_pars[12];                                                                                                 
double	k3=(*amigo_model).nominal_pars[13];                                                                                                 
double	k4=(*amigo_model).nominal_pars[14];                                                                                                 
double	k5=(*amigo_model).nominal_pars[15];                                                                                                 
double	k6=(*amigo_model).nominal_pars[16];                                                                                                 
double	k7=(*amigo_model).nominal_pars[17];                                                                                                 
double	p1=(*amigo_model).nominal_pars[18];                                                                                                 
double	p2=(*amigo_model).nominal_pars[19];                                                                                                 
double	p3=(*amigo_model).nominal_pars[20];                                                                                                 
double	r1=(*amigo_model).nominal_pars[21];                                                                                                 
double	r2=(*amigo_model).nominal_pars[22];                                                                                                 
double	r3=(*amigo_model).nominal_pars[23];                                                                                                 
double	r4=(*amigo_model).nominal_pars[24];                                                                                                 
double	q1=(*amigo_model).nominal_pars[25];                                                                                                 
double	q2=(*amigo_model).nominal_pars[26];                                                                                                 
double	light;                                                                                                                              
light=(*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[(*amigo_model).index_t_stim];
dCL_m=q1*CP_n*light+n1*CT_n/(g1+CT_n)-m1*CL_m/(k1+CL_m);                                                                                   
dCL_c=p1*CL_m-r1*CL_c+r2*CL_n-m2*CL_c/(k2+CL_c);                                                                                           
dCL_n=r1*CL_c-r2*CL_n-m3*CL_n/(k3+CL_n);                                                                                                   
dCT_m=n2*pow(g2,2)/(pow(g2,2)+pow(CL_n,2))-m4*CT_m/(k4+CT_m);                                                                              
dCT_c=p2*CT_m-r3*CT_c+r4*CT_n-m5*CT_c/(k5+CT_c);                                                                                           
dCT_n=r3*CT_c-r4*CT_n-m6*CT_n/(k6+CT_n);                                                                                                   
dCP_n=(1-light)*p3-m7*CP_n/(k7+CP_n)-q2*light*CP_n;                                                                                        
Ith(ydot,0)=dCL_m;                                                                                                                         
Ith(ydot,1)=dCL_c;                                                                                                                         
Ith(ydot,2)=dCL_n;                                                                                                                         
Ith(ydot,3)=dCT_m;                                                                                                                         
Ith(ydot,4)=dCT_c;                                                                                                                         
Ith(ydot,5)=dCT_n;                                                                                                                         
Ith(ydot,6)=dCP_n;                                                                                                                         
return(0);                                                                                                                                 
}                                                                                                                                          
double** circadian_gen_obs(double** sim_data, double** obs_data, int n_observables, int n_times){                                          
int i;                                                                                                                                     
for (i = 0; i < n_times; ++i){                                                                                                             
obs_data[0][i]=sim_data[0][i];                                                                                                             
obs_data[1][i]=sim_data[3][i];                                                                                                             
}                                                                                                                                          
return(obs_data);                                                                                                                          
}                                                                                                                                          
