function iguess_set = AMIGO_update_parameter_guesses(inputs,iguess_set,theta,alpha)
% iguess_set = AMIGO_update_parameter_guesses(inputs,iguess_set,theta,alpha) initialize or updates the initial guess structure
%
%
% INPUTS:
%   inputs  AMIGO inputs strucure with PEsol field
%   iguess_set(optional)    structure, containing initial guesses for global
%                           and local parameters/initial conditions
%   theta   estimated parameter's row vector/array, like results.fit.thetabest,
%           i.e. the parameters are not separated into groups (local/global par/IC)
%   alpha   regularization parameter used to obtain the theta vectors
%
% SYNTAX:
%   iguess_set = AMIGO_update_parameter_guesses(inputs)
%       creates the iguess_set and initialize with the user
%       inputs.PEsol.***_guess
%
%   iguess_set = AMIGO_update_parameter_guesses(inputs,[],theta)
%       creates the iguess_set and initialize with the user inputs and
%       theta
%
%   iguess_set = AMIGO_update_parameter_guesses(inputs,iguess_set,theta)
%       updates the iguess_set with theta
% 
%   iguess_set = AMIGO_update_parameter_guesses(inputs,iguess_set,theta,alpha)
%       updates the iguess_set with theta and alpha
%

if nargin < 4
    alpha = [];
end
% initialize the structure
if nargin < 2 || isempty(iguess_set)
    iguess_set = struct('n_guess',[],...
        'global_theta',[],...
        'global_y0',[],...
        'local_theta',[],...
        'local_theta_y0',[],...
        'alpha',0);
    
    % we assume that the number of initial guesses for all types of
    % estimated parameters are the same. This is for data storage purposes.
    % global parameters
    
    if inputs.PEsol.n_global_theta > 0
        iguess_set.global_theta = inputs.PEsol.global_theta_guess;
    end
    % global initial conditions
    if inputs.PEsol.n_global_theta_y0 > 0
        iguess_set.global_y0 = inputs.PEsol.global_theta_y0_guess;
        if size(inputs.PEsol.global_theta_y0_guess,1) ~= size(inputs.PEsol.global_theta_guess,1)
            error('Sorry, but make sure to provide the same number of initial guesses for global parameters and global initial conditions.')
        end
    end
    %local parameters and initial conditions
    for iexp = 1:inputs.exps.n_exp
        if inputs.PEsol.n_local_theta{iexp} > 0
            if size(inputs.PEsol.global_theta_y0_guess,1) ~= size(inputs.PEsol.global_theta_guess,1)
                error('Sorry, but make sure to provide the same number of initial guesses for global parameters and local  parameters.')
            end
            iguess_set.local_theta{iexp} = inputs.PEsol.local_theta_guess{iexp};
        end
        if inputs.PEsol.n_local_theta_y0{iexp} > 0
            if size(inputs.PEsol.global_theta_y0_guess,1) ~= size(inputs.PEsol.global_theta_guess,1)
                error('Sorry, but make sure to provide the same number of initial guesses for global parameters and local initial conditions.')
            end
            iguess_set.local_theta_y0{iexp} = inputs.PEsol.local_theta_y0_guess{iexp};
        end
    end

    iguess_set.n_guess = size(inputs.PEsol.global_theta_guess,1);
  
    
    if isempty(alpha)
       iguess_set.alpha = nan( iguess_set.n_guess,1);
    end
end

if nargin > 2 && ~isempty(theta)
    iguess_set.n_guess =  iguess_set.n_guess + size(theta,1);
    % global parameters
    if inputs.PEsol.n_global_theta > 0
        g_theta = theta(:,1:inputs.PEsol.n_global_theta);
        iguess_set.global_theta = [iguess_set.global_theta; g_theta ];
    end
    % global initial conditions
    if inputs.PEsol.n_global_theta_y0 > 0
        y0 = theta(:,inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0);
        iguess_set.global_y0 = [iguess_set.global_y0; y0];
    end
    
    % local parameters
    counter_g=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
    for iexp = 1:inputs.exps.n_exp
        if inputs.PEsol.n_local_theta{iexp} > 0
            l_theta = theta(:,counter_g+1:counter_g+inputs.PEsol.n_local_theta{iexp});
            counter_g = counter_g+inputs.PEsol.n_local_theta{iexp};
            
            iguess_set.local_theta{iexp} = [iguess_set.local_theta{iexp} l_theta];
        end
    end
    % local initial conditions
    counter_gl=counter_g;
    for iexp = 1:inputs.exps.n_exp
        if inputs.PEsol.n_local_theta_y0{iexp} > 0
            ly0 = theta(:,counter_gl+1:counter_gl+inputs.PEsol.n_local_theta_y0{iexp});
            counter_gl=counter_gl+inputs.PEsol.n_local_theta_y0{iexp};
            iguess_set.local_theta_y0{iexp} = [iguess_set.local_theta_y0{iexp}; ly0];
        end
    end
    
    if ~isempty(alpha)
        iguess_set.alpha = [iguess_set.alpha; alpha(:)];
    else
        iguess_set.alpha = [iguess_set.alpha; zeros( size(theta,1),1)];
    end
end
