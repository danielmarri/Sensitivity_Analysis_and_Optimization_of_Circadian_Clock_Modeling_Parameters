function inputs = AMIGO_check_regularization(inputs,missingAlphaError)
%inputs = AMIGO_check_regularization(inputs) checks the regularization related user inputs.

if ~inputs.nlpsol.regularization.ison
    return;
end
if nargin < 2 || isempty(missingAlphaError)
missingAlphaError = 1;
end
% save time with the checking
opts = inputs.nlpsol.regularization;

if isempty(opts.method)
    error('no method defined for the regularization. inputs.nlpsol.regularization.method is empty')
end



switch opts.method
    case 'tikhonov'
        % regularization of estimated global parameters
        if inputs.PEsol.n_global_theta > 0
            
            if isempty(opts.tikhonov.gx0)
                fprintf('WARNING MESSAGE:\n\tRegularization reference parameter vector for global parameters is undefined. inputs.nlpsol.regularization.tikhonov.gx0 is set to the LowerBound.\n\n')
                opts.tikhonov.gx0 = inputs.PEsol.global_theta_min;
            end
            if isempty(opts.tikhonov.gW)
                fprintf('WARNING MESSAGE:\n\tRegularization scaling matrix for global parameters is undefined. inputs.nlpsol.regularization.tikhonov.gW is set to the IDENTITY matrix.\n\n')
                opts.tikhonov.gW = zeros( inputs.PEsol.n_global_theta);
            end
            assert(length(opts.tikhonov.gx0) == inputs.PEsol.n_global_theta, 'tikhonov reg. global reference parameter vector (gx0) should have the same size as the number of global parameters');
            assert(size(opts.tikhonov.gW,2) == inputs.PEsol.n_global_theta, 'tikhonov reg. global weighting matrix (gW) should have the same number of columns as the number of global parameters');
        end
        % Regularization of estimated global  initial conditions:
        if inputs.PEsol.n_global_theta_y0 > 0
            
            if isempty(opts.tikhonov.gy0)
                fprintf('WARNING MESSAGE:\n\tRegularization reference parameter vector for estimated global initial condisitons is undefined. inputs.nlpsol.regularization.tikhonov.gy0 is set to the LowerBound vector.\n\n')
                opts.tikhonov.gy0 =inputs.PEsol.global_theta_y0_min;
            end
            if isempty(opts.tikhonov.gyW)
                fprintf('WARNING MESSAGE:\n\tRegularization scaling matrix for estimated global initial conditions is undefined. inputs.nlpsol.regularization.tikhonov.gyW is set to the Identity matrix.\n\n')
                opts.tikhonov.gyW = eye( inputs.PEsol.n_global_theta_y0);
            end
            assert(length(opts.tikhonov.gy0) == inputs.PEsol.n_global_theta_y0, 'tikhonov reg. reference parameter vector for estimated global initial conditions (gy0) should have the same size as the number of global initial conditions.');
            assert(size(opts.tikhonov.gyW,2) == inputs.PEsol.n_global_theta_y0, 'tikhonov reg. weighting matrix  for estimated global initial conditions (gyW) should have the same number of columns as the number of global initial conditions.');
        end
        
        % Local parameters and initial conditions:
        for iexp = 1:inputs.exps.n_exp
            % regularization of estimated local parameters
            if inputs.PEsol.n_local_theta{iexp} > 0
                
                if isempty(opts.tikhonov.lx0{iexp})
                    fprintf('WARNING MESSAGE:\n\tRegularization reference parameter vector for local parameters is undefined. inputs.nlpsol.regularization.tikhonov.lx0{%d} is set to their LowerBound.\n\n',iexp)
                    opts.tikhonov.lx0{iexp} =inputs.PEsol.local_theta_min{iexp};
                end
                if isempty(opts.tikhonov.lW{iexp})
                    fprintf('WARNING MESSAGE:\n\t Regularization scaling matrix for local parameters is undefined. inputs.nlpsol.regularization.tikhonov.lW{%d} is set to the IDENTITY matrix.\n\n',iexp)
                    opts.tikhonov.lW{iexp} = eye( inputs.PEsol.n_local_theta{iexp});
                end
                assert(length(opts.tikhonov.lx0{iexp}) == inputs.PEsol.n_local_theta{iexp}, 'tikhonov reg. local reference parameter vector (lx0{%d}) should have the same size as the number of local parameters',iexp);
                assert(size(opts.tikhonov.lW{iexp},2) == inputs.PEsol.n_local_theta{iexp}, 'tikhonov reg. local weighting matrix (lW{%d}) should have the same number of columns as the number of local parameters',iexp);
            end
            % Regularization of estimated local  initial conditions:
            if inputs.PEsol.n_local_theta_y0{iexp} > 0
                
                if isempty(opts.tikhonov.ly0{iexp})
                    fprintf('WARNING MESSAGE:\n\t Regularization reference parameter vector for estimated local initial conditions is undefined. inputs.nlpsol.regularization.tikhonov.ly0{%d} is set to their LowerBound.\n\n',iexp)
                    opts.tikhonov.ly0{iexp} = inputs.PEsol.local_theta_y0_min{iexp};
                end
                if isempty(opts.tikhonov.lyW{iexp})
                    fprintf('WARNING MESSAGE:\n\t Regularization scaling matrix for estimated local initial conditions is undefined. inputs.nlpsol.regularization.tikhonov.lyW{%d} is set to the Identity matrix\n\n',iexp)
                    opts.tikhonov.lyW{iexp} = eye( inputs.PEsol.n_local_theta_y0{iexp});
                end
                assert(length(opts.tikhonov.ly0{iexp}) == inputs.PEsol.n_local_theta_y0{iexp}, 'tikhonov reg. reference parameter vector for estimated local initial conditions (ly0{%d}) should have the same size as the number of local initial conditions.',iexp);
                assert(size(opts.tikhonov.lyW{iexp},2) == inputs.PEsol.n_local_theta_y0{iexp}, 'tikhonov reg. weighting matrix  for estimated local initial conditions (lyW{%d}) should have the same number of columns as the number of local initial conditions.',iexp);
            end
            
        end
        
        
    case 'tikhonov_minflux'
        % TODO
        
    case 'user_functional'
        %TODO
    otherwise
        error('currently only regularization.method = ''tikhonov'' is allowed.')
end

if isempty(opts.alpha) && isempty(opts.alphaSet) && isempty(opts.reg_par_method_type)
    error('Either the regularization parameter or the parameter choice method should be given.')
end

if missingAlphaError && isempty(opts.alpha) && isempty(opts.alphaSet)
    error('Regularization parameter is not given')
elseif isempty(opts.alpha) && ~isempty(opts.alphaSet)
    fprintf('WARNING:\n\t\tregularization.alpha is empty. The regularization parameter is taken from the regularization.alphaSet.\n\n ')
    opts.alpha = opts.alphaSet(1);
end

    
inputs.nlpsol.regularization = opts;


