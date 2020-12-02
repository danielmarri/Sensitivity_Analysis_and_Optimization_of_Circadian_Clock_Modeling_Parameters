
function [global_theta_guess,global_theta_y0_guess,local_theta_guess,local_theta_y0_guess]  = AMIGO_init_parameter_guesses(inputs,iguess_set,ref_alpha,n_NN)
% takes values from the iguess structure and initialize the inputs.PEsol
% if alpha and n_NN are given, then it initializes inputs.PEsol only with the n_NN
% nearest neighbour of alpha.

global_theta_guess = [];
global_theta_y0_guess = [];
local_theta_guess = {};
local_theta_y0_guess = {};



if nargin < 3
    index_vector = 1:iguess_set.n_guess;
else
    % sort by distance:
    [sa,si]=sort(abs(log10(iguess_set.alpha)-log10(ref_alpha)),'ascend');
    n_NN = min(n_NN,iguess_set.n_guess);
    % select the n_NN closest:
    index_vector = si(1:n_NN);
end

if inputs.PEsol.n_global_theta > 0
    global_theta_guess = iguess_set.global_theta(index_vector,:);
end
if inputs.PEsol.n_global_theta_y0 > 0
    global_theta_y0_guess = iguess_set.global_y0(index_vector,:);
end
for iexp = 1:inputs.exps.n_exp
    if inputs.PEsol.n_local_theta{iexp} > 0
        local_theta_guess{iexp}  = iguess_set.local_theta{iexp}(index_vector,:);
    end
    if inputs.PEsol.n_local_theta_y0{iexp} > 0
        local_theta_y0_guess{iexp} = iguess_set.local_theta_y0{iexp}(index_vector,:);
    end
end

end


