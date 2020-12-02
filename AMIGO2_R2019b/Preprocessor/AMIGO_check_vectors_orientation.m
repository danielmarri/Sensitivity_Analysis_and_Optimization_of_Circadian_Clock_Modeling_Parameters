% $Header$
function [inputs]= AMIGO_check_vectors_orientation(inputs)
% AMIGO_check_vectors_orientation goes through the user defined vectors and
% converts them to row vectors. 
% coded: Attila Gabor 27/08/2013

inputs.model.par = inputs.model.par(:)';
inputs.PEsol.global_theta_max = inputs.PEsol.global_theta_max(:)';
inputs.PEsol.global_theta_min = inputs.PEsol.global_theta_min(:)';
inputs.PEsol.global_theta_guess = inputs.PEsol.global_theta_guess(:)';


for iexp = 1:inputs.exps.n_exp
    inputs.exps.std_dev{iexp} = inputs.exps.std_dev{iexp}(:)';
    inputs.exps.exp_y0{iexp} = inputs.exps.exp_y0{iexp}(:)';
    inputs.exps.t_s{iexp} = inputs.exps.t_s{iexp}(:)';
end
    