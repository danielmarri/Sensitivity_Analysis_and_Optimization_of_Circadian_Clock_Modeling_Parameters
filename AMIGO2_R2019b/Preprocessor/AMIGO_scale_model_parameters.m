function inputs = AMIGO_scale_model_parameters (inputs,backward)
% AMIGO_scale_theta scales the model parameters and parameter bounds.
%
% if backward == 1 we scale the parameters and bounds back in the inputs
% structure.


if nargin < 2
    backward = 0;
end

scaled_model = false;

if ~backward
    % Preparing the logarithmic scaling of the global parameters
    if ~isempty(inputs.PEsol.log_var)
        scaled_model = true;
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
            inputs.PEsol.global_theta_max(inputs.PEsol.log_var) =  log(inputs.PEsol.global_theta_max(inputs.PEsol.log_var));
            inputs.PEsol.global_theta_min(inputs.PEsol.log_var) =  log(inputs.PEsol.global_theta_min(inputs.PEsol.log_var));
            inputs.PEsol.global_theta_guess(inputs.PEsol.log_var) =  log(inputs.PEsol.global_theta_guess(inputs.PEsol.log_var));
        end
    end
    
    
    if ~isempty(inputs.PEsol.lin_scaled_var)
        scaled_model = true;
        fprintf('\n\n-----> WARNING:\n\n\t Linear scaling is activated.\n\t The bounds and initial conditions are transformed. \n\n');
        % TODO:
        % handle the local parameters too.
        % Not a good check.
        if max(inputs.PEsol.lin_scaled_var)>inputs.PEsol.n_global_theta
            fprintf('!!!   max(inputs.PEsol.lin_scaled_var) > inputs.PEsol.n_global_theta\n')
            error('Error: linear scaling is currently available only for global unknowns. \n')
        end
        
        % SCALING:
        if inputs.PEsol.n_global_theta > 0
            inputs.PEsol.global_theta_max(inputs.PEsol.lin_scaled_var) =  inputs.PEsol.global_theta_max(inputs.PEsol.lin_scaled_var)./inputs.PEsol.lin_scaled_factor;
            inputs.PEsol.global_theta_min(inputs.PEsol.lin_scaled_var) =  inputs.PEsol.global_theta_min(inputs.PEsol.lin_scaled_var)./inputs.PEsol.lin_scaled_factor;
            inputs.PEsol.global_theta_guess(inputs.PEsol.lin_scaled_var) =  inputs.PEsol.global_theta_guess(inputs.PEsol.lin_scaled_var)./inputs.PEsol.lin_scaled_factor;
        end
    end
    
    if scaled_model
        
        fprintf('-->   AMIGO applies scaling:\n')
        fprintf('\tParameter: scaling method\n')
        for itheta = 1 :  inputs.PEsol.n_global_theta
           if ~isempty(inputs.model.par_names)
               fprintf('\t%s:\t',inputs.model.par_names(inputs.PEsol.index_global_theta(itheta),:));
           else
               fprintf('\tpar%d:\t',inputs.PEsol.index_global_theta(itheta));
           end
            if any(itheta==inputs.PEsol.log_var)
                fprintf('logarithmic\n')
            elseif any(itheta==inputs.PEsol.lin_scaled_var)
                fprintf('linear')
                fprintf('(fac.:%.3g)\n',inputs.PEsol.lin_scaled_factor(itheta==inputs.PEsol.lin_scaled_var));
            else
                fprintf('non-scaled\n')
            end
        end
        
    end
end

if backward
    % Preparing the logarithmic scaling of the global parameters
    if ~isempty(inputs.PEsol.log_var)
        scaled_model = true;
        
        % SCALING:
        if inputs.PEsol.n_global_theta > 0
            inputs.PEsol.global_theta_max(inputs.PEsol.log_var) =  exp(inputs.PEsol.global_theta_max(inputs.PEsol.log_var));
            inputs.PEsol.global_theta_min(inputs.PEsol.log_var) =  exp(inputs.PEsol.global_theta_min(inputs.PEsol.log_var));
            inputs.PEsol.global_theta_guess(inputs.PEsol.log_var) =  exp(inputs.PEsol.global_theta_guess(inputs.PEsol.log_var));
        end
    end
    
    
    if ~isempty(inputs.PEsol.lin_scaled_var)
        scaled_model = true;
        
        % SCALING:
        if inputs.PEsol.n_global_theta > 0
            inputs.PEsol.global_theta_max(inputs.PEsol.lin_scaled_var) =  inputs.PEsol.global_theta_max(inputs.PEsol.lin_scaled_var).*inputs.PEsol.lin_scaled_factor;
            inputs.PEsol.global_theta_min(inputs.PEsol.lin_scaled_var) =  inputs.PEsol.global_theta_min(inputs.PEsol.lin_scaled_var).*inputs.PEsol.lin_scaled_factor;
            inputs.PEsol.global_theta_guess(inputs.PEsol.lin_scaled_var) =  inputs.PEsol.global_theta_guess(inputs.PEsol.lin_scaled_var).*inputs.PEsol.lin_scaled_factor;
        end
    end
end

