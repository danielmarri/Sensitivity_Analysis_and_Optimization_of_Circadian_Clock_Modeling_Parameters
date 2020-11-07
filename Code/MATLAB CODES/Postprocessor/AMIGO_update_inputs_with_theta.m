function inputs = AMIGO_update_inputs_with_theta(theta,inputs)
% distribute the decision vector to the inputs
% structure after checking the inputs.

% temporarly:
inputs = AMIGO_check_PEinputs(inputs);
% initialize the decision variable
AMIGO_set_theta_index;
% AMIGO_init_theta;

% decision vector:
privstruct.theta = theta;

% get privstruct.par:
privstruct = AMIGO_transform_theta(inputs,[],privstruct);

% access privstruct.par for which we have the index vectors.

if inputs.PEsol.n_global_theta>0 
    inputs.PEsol.global_theta_guess = privstruct.par{1}(inputs.PEsol.index_global_theta);
end
if inputs.PEsol.n_global_theta_y0 > 0
     inputs.PEsol.global_theta_y0_guess = privstruct.y_0{1}(inputs.PEsol.index_global_theta_y0);
end

for iexp=1:inputs.exps.n_exp
    if inputs.PEsol.n_local_theta{iexp}>0
        
        inputs.PEsol.local_theta_guess{iexp} = privstruct.par{iexp}(1,inputs.PEsol.index_local_theta{iexp});
        
    end
    if inputs.PEsol.n_local_theta_y0{iexp}>0
        
        inputs.PEsol.local_theta_y0_guess{iexp} =  privstruct.y_0{iexp}(inputs.PEsol.index_local_theta_y0{iexp});
        
    end
end