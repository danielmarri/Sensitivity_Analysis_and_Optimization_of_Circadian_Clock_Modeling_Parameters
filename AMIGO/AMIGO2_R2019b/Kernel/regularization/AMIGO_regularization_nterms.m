function [nterm] = AMIGO_regularization_nterms(inputs,privstruct)
% computes the number of additional terms to the residual vector
nterm = 0;

for iexp = 1:inputs.exps.n_exp
    switch inputs.nlpsol.regularization.method
        case 'tikhonov'
            % minimum norm parameters wrt the W matrix.
            % ||W(p-pr)||^2
            
            % handle local parameters
            if inputs.PEsol.n_local_theta{iexp}>=1
                xref = inputs.nlpsol.regularization.tikhonov.lx0{iexp}(:);
                W = inputs.nlpsol.regularization.tikhonov.lW{iexp};
                
                nterm = nterm + length(W*xref);
            end
            
            % handle the global parameters in the last case
            if iexp == inputs.exps.n_exp
                xref = inputs.nlpsol.regularization.tikhonov.gx0(:);
                W = inputs.nlpsol.regularization.tikhonov.gW;
                
                nterm = nterm + length(W*xref);
            end
            
        case 'tikhonov_minflux'
            % minimum flux norm solution.
            % ||df/dt||^2
            % exlude the first step because the initial condition may cause
            % trouble.
            n_st = inputs.model.n_st;
            n_time = length(privstruct.t_int{iexp})-1; % initial is not included.
            nterm = nterm + n_st*n_time;
            
            
        case 'user_functional'
            % not implemented yet.
            error('user_functional is not implemented yet.')
            
            
        case []
            fprintf('Regularization method is empty. Define method for regularization at inputs.nlpsol.regularization.method \n')
            error('');
        otherwise
            fprintf('There is no such regularization method implemented: %s \n',inputs.nlpsol.regularization.method)
            error('');
    end
end