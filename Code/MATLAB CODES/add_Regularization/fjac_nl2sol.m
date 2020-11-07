function [Jres]= fjac_nl2sol(x)
% Jacobian of objective function for NL2SOL in AMIGO
% Automatically generated in ssm_aux_local.m
global n_jac_eval 
global input_par 
[Jobj, Jg, Jres]= AMIGO_PEJac(x,input_par{:});
n_jac_eval=n_jac_eval+1; 

return
