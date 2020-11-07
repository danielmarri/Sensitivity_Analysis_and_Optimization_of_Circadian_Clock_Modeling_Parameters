function index_theta = AMIGO_index_theta_vector(inputs)
% set up index vectors to collect the parameters for each experiment from
% the decision vector. (the theta decision vector contains all the parameters, globals and locals)
%
% index_theta{iexp}  -- contains the indices of the decision variables in each experiments.
% Note that these are indexing the decision vector (theta in AMIGO_PEcost and AMIGO_PEJac) and NOT the
% inputs.model.par vector.
%
% 

for iexp=1:inputs.exps.n_exp
    % GLOBAL PARAMETERS
    index_theta{iexp} =1:inputs.PEsol.n_global_theta;
end


if inputs.PEsol.n_global_theta_y0>=1
    for iexp=1:inputs.exps.n_exp
        % GLOBAL INITIAL CONDITIONS WHEN NECESSARY
        index_theta{iexp} = [index_theta{iexp}  inputs.PEsol.n_global_theta+(1:inputs.PEsol.n_global_theta_y0)];
    end;
end
counter_g=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;

for iexp=1:inputs.exps.n_exp
    % LOCAL PARAMETERS WHEN NECESSARY
    
    if inputs.PEsol.n_local_theta{iexp}>=1
        index_theta{iexp} = [index_theta{iexp} counter_g+(1:inputs.PEsol.n_local_theta{iexp})];
        counter_g=counter_g+inputs.PEsol.n_local_theta{iexp};
    end
    
end %for iexp=1:inputs.exps.n_exp
counter_gl=counter_g;
for iexp=1:inputs.exps.n_exp
    % LOCAL INITIAL CONDITIONS WHEN NECESSARY
    if inputs.PEsol.n_local_theta_y0{iexp}>=1
        index_theta{iexp} = [index_theta{iexp} counter_gl+(1 : inputs.PEsol.n_local_theta_y0{iexp})];
        counter_gl=counter_gl+inputs.PEsol.n_local_theta_y0{iexp};
    end
end %iexp=1:inputs.exps.n_exp



return;