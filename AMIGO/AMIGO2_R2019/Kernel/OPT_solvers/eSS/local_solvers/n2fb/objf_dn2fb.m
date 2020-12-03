function [R]= objf_dn2fb (N,P,x,NF,R,LTY,TY)
global n_fun_eval 
global input_par 
[f,g,R]= AMIGO_PEcost(x,input_par{:});
n_fun_eval=n_fun_eval+1; 
return
