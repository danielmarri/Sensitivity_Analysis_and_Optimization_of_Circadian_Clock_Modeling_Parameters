function inputs = AMIGO_logscale_theta (inputs)
% scale the model parameters and parameter bounds.


% Preparing the logarithmic scaling of the global parameters

if isempty(inputs.PEsol.log_var)
    return
else
    fprintf('\n\n-----> WARNING:\n\n\t Logarithmic scaling is activated.\n\t The bounds and initial conditions are transformed to the\n\t logarithmic scale.\n\n');
    % TODO:
    % handle the local parameters too.
    % Not a good check.
    if max(inputs.PEsol.log_var)>inputs.PEsol.n_global_theta
        fprintf('!!!   max(inputs.PEsol.log_var) > inputs.PEsol.n_global_theta\n')
        error('Error: logarithmic scaling is currently available only for global unknowns\n')
    end
    % SIMPLE TESTS
    if any(inputs.PEsol.global_theta_max <= 0)
        error('Error: upper bound is negative or zero. Logarithmic scaling is not possible.\n')
    end
    if any(inputs.PEsol.global_theta_min <= 0)
        error('Error: lower bound is negative or zero. Logarithmic scaling is not possible.\n')
    end
    
    % SCALING:
    if inputs.PEsol.n_global_theta > 0
        inputs.PEsol.global_theta_max =  log(inputs.PEsol.global_theta_max);
        inputs.PEsol.global_theta_min =  log(inputs.PEsol.global_theta_min);
        inputs.PEsol.global_theta_guess =  log(inputs.PEsol.global_theta_guess);
    end
end