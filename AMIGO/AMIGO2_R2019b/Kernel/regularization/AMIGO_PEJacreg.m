function [JacObjReg, JacResReg] = AMIGO_PEJacreg(inputs,privstruct)
% computes the Jacobian of the regularization part of the objective function.
% JacObjReg: the Jacobian of the regularized part
% JacResReg: if the regularization can be stated as sum of squared functions, g
%   contains the Jacobian of the functions to be squared.
JacObjReg = [];
JacResReg = [];

switch inputs.nlpsol.regularization.method
    case 'tikhonov'
        % ||W(p-pr)||^2
        % decision vector:
        x = privstruct.theta;
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
               
        JacResReg =  W;
        JacObjReg = 2*((W'*W)*(x(:)-xref(:)));
        
        
        
    case 'tikhonov_minflux'
        % ||df/dt||^2
        % exlude the first step because the initial condition may cause
        % trouble.
        for iexp = 1:inputs.exps.n_exp
            error('this is not correct, TODO.')
            dxdt = privstruct.ivpsol.dxdt{iexp}(2:end,:);
            dsdt = privstruct.senssol.dsdt{iexp}(2:end,:,:);
            ntime = size(dxdt,1);
            nstates = size(dxdt,2);
            npar = size(dsdt,3);
            
            R = reshape(dxdt,ntime*nstates,1);
            J = reshape(dsdt,ntime*nstates,npar);
            
            JacResReg = J;
            JacObjReg = J'*R;
        end
        
    case 'user_functional'
        % not implemented yet.
        [R J]= feval(inputs.nlpsol.regularization.user_reg_functional,privstruct.theta);
        JacResReg = J;
        JacObjReg = J'*R;
    case []
        fprintf('Regularization method is empty. Define method for regularization at inputs.nlpsol.regularization.method \n')
        error('');
    otherwise
        fprintf('There is no such regularization method implemented: %s \n',inputs.nlpsol.regularization.method)
        error('');
end

