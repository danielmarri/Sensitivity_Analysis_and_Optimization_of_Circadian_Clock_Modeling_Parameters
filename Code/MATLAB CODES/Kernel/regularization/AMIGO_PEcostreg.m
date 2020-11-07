function [objReg, resReg] = AMIGO_PEcostreg(theta,inputs,privstruct)
%AMIGO_PEcostreg(theta,inputs,privstruct) computes the regularization part of the objective function without the
% regularization parameter.
% objReg: the sum of the regularization part
% resReg: if the regularization can be stated as sum of squared functions, resReg
% contains the functions to be squared.
objReg = 0;
resReg = [];

switch inputs.nlpsol.regularization.method
    case 'tikhonov'
        % minimum norm parameters wrt the W matrix.
        % ||W(p-pr)||^2
        % decision vector:
        x = theta;
        % Global parameters
        
        % global parameters
        if inputs.PEsol.n_global_theta>=1
            xref = inputs.nlpsol.regularization.tikhonov.gx0;
            %                 x = privstruct.par{iexp}(inputs.PEsol.index_global_theta);
            W = inputs.nlpsol.regularization.tikhonov.gW;
            
            %                 tikh_term = W*(x(:) - xref(:));
            
            % resReg is not empty if the last experiment contains local
            % parameters. Also objReg is nonzero.
            %                 resReg = [resReg; tikh_term];
            %                 objReg = objReg + (tikh_term'*tikh_term);
        end
        % global initial conditions // taken only once.
        if inputs.PEsol.n_global_theta_y0>=1
            xref = [xref inputs.nlpsol.regularization.tikhonov.gy0];
            %                 x = privstruct.exp_y0{1}(inputs.PEsol.index_global_theta_y0);
            W = blkdiag(W, inputs.nlpsol.regularization.tikhonov.gyW);
            
            %tikh_term = W*(x(:) - xref(:));
            
            % resReg is not empty if the last experiment contains local
            % parameters. Also objReg is nonzero.
            %resReg = [resReg; tikh_term];
            %objReg = objReg + (tikh_term'*tikh_term);
        end
        
        
        % handle local parameters
        for iexp = 1:inputs.exps.n_exp
            if inputs.PEsol.n_local_theta{iexp}>=1
                xref = [xref inputs.nlpsol.regularization.tikhonov.lx0{iexp}];
                W = blkdiag(W,inputs.nlpsol.regularization.tikhonov.lW{iexp});
                %x =  privstruct.par{iexp}(inputs.PEsol.index_local_theta{iexp});
                
                %tikh_term = W*(x(:) - xref(:));
                
                %resReg = [resReg; tikh_term];
                %local_Reg = (tikh_term'*tikh_term);
                %objReg = objReg + local_Reg;
            end
        end
        
        % local initial conditions:
        for iexp = 1:inputs.exps.n_exp
            if inputs.PEsol.n_local_theta_y0{iexp}>=1
                xref = [xref inputs.nlpsol.regularization.tikhonov.ly0{iexp}];
                W = blkdiag(W,inputs.nlpsol.regularization.tikhonov.lyW{iexp});
                %                     x =  privstruct.y_0{iexp}(inputs.PEsol.index_local_theta_y0{iexp});
                
                
            end
        end
        tikh_term = W*(x(:) - xref(:));
        resReg = tikh_term;
        local_Reg = (tikh_term'*tikh_term);
        objReg =  local_Reg;
        
        
    case 'tikhonov_minflux'
        % minimum flux norm solution.
        % ||df/dt||^2
        % exlude the first step because the initial condition may cause
        % trouble.
        R = [];
        for iexp = 1:inputs.exps.n_exp
            dxdt = privstruct.ivpsol.dxdt{iexp}(2:end,:);
            R = [R; dxdt(:)];
        end
        resReg = R;
        objReg = R'*R;
        
    case 'user_functional'
        % not implemented yet.
        R = feval(inputs.nlpsol.regularization.user_reg_functional,theta);
        resReg = R;
        objReg = R'*R;
        %error('user_functional is not implemented yet.')
        
        
    case []
        fprintf('Regularization method is empty. Define method for regularization at inputs.nlpsol.regularization.method \n')
        error('');
    otherwise
        fprintf('There is no such regularization method implemented: %s \n',inputs.nlpsol.regularization.method)
        error('');
end
