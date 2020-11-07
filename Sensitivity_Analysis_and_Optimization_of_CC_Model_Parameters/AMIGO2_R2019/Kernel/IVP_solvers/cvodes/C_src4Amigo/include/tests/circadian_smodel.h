#include <AMIGO_problem.h>

int run_circadian_smodel();

int circadian_smodel(realtype t, N_Vector y, N_Vector ydot, void *data);

double** circadian_gen_obs(double** sim_data, double** obs_data, int n_observables, int n_times);