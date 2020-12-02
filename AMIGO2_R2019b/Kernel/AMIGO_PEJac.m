function [JacObj,Jach, JacRes, JacRegObj, JacRegRes] = AMIGO_PEJac( theta,inputs,results,privstruct )
% AMIGO_PEJac calculates the Jacobian of the objective function.
%
% SYNTAX:
%   [JacObj,Jach, JacRes, JacRegObj, JacRegRes] = AMIGO_PEJac( theta,inputs,results,privstruct )
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_PEJac: computes the jacobian of cost function/residual vector to be minimized for    %
%               parameter estimation.                                         %
%                                                                             %
%                 Several possibilities exist:                                %
%                                                                             %
%                   Least squares function: 'lsq' with different weighting    %
%                   matrices: 'lsq_type': 'Q_I' no weighting                  %
%                                      'Q_expmax' weights using the maximum   %
%                                                 experimental data per       %
%                                                 observable                  %
%                   Log-likelihood:'llk' with different versions depending    %
%                   on the type of experimental noise:                        %
%                             'llk_type': 'homo' homocedastic noise with      %
%                                          constant variance                  %
%                                         'homo_var' homocedastic noise with  %
%                                          known non-constant variance        %
%                                         'hetero' heterocedastic noise       %
%                                          with variance proportional to the  %
%                                          observations                       %
%                   User-defined cost: 'user_PEcostJac'                       %
%                           Should be defined in the following manner:        %
%                           [jacObj, jach ,jacRes]=user_costJac(theta);           %
%                           being theta: all model uknowns to be estimated    %
%                                 jacObj: jacobian of objective function        %
%                                 jach: jacobian of constraints if any        %
%                                 jacRes: jacobian matrix of the residual vector.%
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_PEJac.m 2044 2015-08-24 12:40:33Z attila $
JacRegObj = 0;
JacRegRes = [];
if any(isnan(theta) | isinf(theta))
    disp('Parameter vector is wrong: ')
    disp(theta)
end
if inputs.pathd.print_details
    disp('--> AMIGO_PEJac()')
end
% number of data: total and for each experiment
ndata=0;
ntheta = length(theta);
theta = theta(:);
nexpdata = zeros(1,inputs.exps.n_exp);
for iexp=1:inputs.exps.n_exp
    % count the numerical element of exp_data. (excluding the nan-s)
    exp_data = inputs.exps.exp_data{iexp};
    nexpdata(iexp) = numel(exp_data(inputs.exps.nanfilter{iexp}));
    ndata=ndata+nexpdata(iexp);
end

% log scale back...
theta = AMIGO_scale_theta_back(theta,inputs);
% if ~isempty(inputs.PEsol.log_var)
%     theta(inputs.PEsol.log_var) = exp(theta(inputs.PEsol.log_var));
% end

if isempty(inputs.PEsol.PEcostJac_type)
    if exist('mklJac','file')
        inputs.PEsol.PEcostJac_type = 'mkl';
    else
        fprintf(2,'Error in AMIGO_PEJac: we cannot compute the Jacobian. MKL is not detected and inputs.PEsol.PEcostJac_type is empty.\n');
        JacObj = zeros(1,ntheta);
        Jach =  zeros(1,ntheta);
        JacRes =  zeros(ndata,ntheta);
        JacRegObj = zeros(1,ntheta);
        JacRegRes = zeros(ndata,ntheta);
        return;
    end
end
% functions that take care internally about the number of experiments (user defined or mkl)
switch lower(inputs.PEsol.PEcostJac_type)
    case 'user_pecostjac'
        % user gave a filename or function handler to the jacobian.
        
        if ~isempty(inputs.PEsol.PEcostJac_file)
            [JacObj,Jach, JacRes ]=feval(strcat(inputs.PEsol.PEcostJac_file),theta);
        elseif isa(inputs.PEsol.PEcostJac_fun,'function_handle')
            [JacObj,Jach, JacRes]=feval(inputs.PEsol.PEcostJac_fun,theta);
        else
            error('User-defined objective Jacobian is detected. Either a filename in inputs.PEsol.PEcostJac_file or a function handler in inputs.PEsol.PEcostJac_fun is expected.')
        end
        
%         if ~isempty(inputs.PEsol.log_var)
%             JacRes(:,inputs.PEsol.log_var) = JacRes(:,inputs.PEsol.log_var).*repmat(theta(inputs.PEsol.log_var),ndata,1);
%             JacObj(inputs.PEsol.log_var) = JacObj(inputs.PEsol.log_var).*theta(inputs.PEsol.log_var);
%         end
            [JacRes,JacObj] = AMIGO_scale_Jacobian(JacRes,JacObj,theta, inputs);

        return;
        
    case 'mkl'
        % call mkl with default precision.
        
        JacRes = mklJac(@(x)AMIGO_PEcost2mkl(x,inputs,results,privstruct),theta(:));
        
        JacObj = sum(JacRes); % summation over residuals (experiments, observables, time)
        Jach = 0;
%         if ~isempty(inputs.PEsol.log_var)
%             JacRes(:,inputs.PEsol.log_var) = JacRes(:,inputs.PEsol.log_var).*repmat(theta(inputs.PEsol.log_var),ndata,1);
%             JacObj(inputs.PEsol.log_var) = JacObj(inputs.PEsol.log_var).*theta(inputs.PEsol.log_var);
%         end
           [JacRes,JacObj] = AMIGO_scale_Jacobian(JacRes,JacObj,theta, inputs);
        return;
end

JacRes = zeros(ndata,ntheta);
JacObj = zeros(1,ntheta);
Jach=0;
privstruct.theta = theta;
privstruct = AMIGO_transform_theta(inputs,results,privstruct);
g1=0.0;
% accumulate the data in each experiment. Helps indexing the Jacobian and the cost vectors
nprocessedData = 0;

for iexp=1:inputs.exps.n_exp
    
    % Perform integration of the ODEs and the sensitivity equations
    [results,privstruct]=AMIGO_sens(inputs,results,privstruct,iexp);
    
    % privstruct.yteor contains the states
    obsfunc=inputs.pathd.obs_function;
    ms=feval(obsfunc,privstruct.yteor,inputs,privstruct.par{iexp},iexp);
    % privstruct.sens_t contains the sensitivities of the
    % ovbservables
    sens = privstruct.sens_t{iexp};
    
    % sens is a 3D vector, reshape to 2D: each column contains the
    % sensitivity of the sampling points (residuals) with respect to one
    % parameter:
    ntheta_iexp = inputs.PEsol.n_global_theta +inputs.PEsol.n_global_theta_y0 +inputs.PEsol.n_local_theta{iexp} +inputs.PEsol.n_local_theta_y0{iexp};
    resSens = reshape(sens,inputs.exps.n_s{iexp}*inputs.exps.n_obs{iexp},ntheta_iexp);
    
    % residuals without weighting:
    resM = ms-inputs.exps.exp_data{iexp};
    
    
    switch lower(inputs.PEsol.PEcostJac_type)
        
        case 'lsq'
            
            switch inputs.PEsol.lsq_type
                
                case 'Q_mat'
                    % weighting matrix:
                    Q = inputs.PEsol.lsq_Qmat{iexp};
                    
                    scaledResM = resM.*Q;
                    % reshape to a columnvector:
                    scaledRes = scaledResM(:);
                    
                    % fobj = ((y_ij-ym_ij)Q_ij)^2
                    % note that we have: resM(:).*Q(:)
                    
                    % scaled Sensitivity of the residuals:
                    % the sensitivities wrt each parameter have the same
                    % scaling factor
                    scaledResSens = resSens.*repmat(Q(:),1,ntheta_iexp);
                    JacRes(nprocessedData+1 : nprocessedData + nexpdata(iexp),privstruct.index_theta{iexp}) = scaledResSens;
                    JacObj(privstruct.index_theta{iexp}) = JacObj(privstruct.index_theta{iexp}) + 2*scaledRes'*scaledResSens;
                    
                case 'Q_I'
                    
                    % Jacobian of the residuals is just the sensitivities
                    % of the observables
                    JacRes(nprocessedData+1 : nprocessedData + nexpdata(iexp),privstruct.index_theta{iexp}) =  resSens;
                    % convert residual matrix into a column vector:
                    res = resM(:);
                    % jacobian of the cost function fobj = r'*r --> jac = 2 r'*dr_dp
                    JacObj(privstruct.index_theta{iexp}) = JacObj(privstruct.index_theta{iexp}) + 2*res'*resSens;
                case 'Q_exp'
                    % weighting matrix is the maximum of the trajectories
                    expData = inputs.exps.exp_data{iexp};
                    Q = 1./expData;
                    % handles close infinity weights:
                    tmp1 = or(isnan(Q),isinf(Q));
                    Q(tmp1) = 1;
                    
                    scaledResM = resM.*Q;
                    % reshape to a columnvector:
                    scaledRes = scaledResM(:);
                    
                    % fobj = ((y_ij-ym_ij)Q_ij)^2
                    % note that we have: resM(:).*Q(:)
                    
                    % scaled Sensitivity of the residuals:
                    % the sensitivities wrt each parameter have the same
                    % scaling factor
                    scaledResSens = resSens.*repmat(Q(:),1,ntheta_iexp);
                    JacRes(nprocessedData+1 : nprocessedData + nexpdata(iexp),privstruct.index_theta{iexp}) = scaledResSens;
                    JacObj(privstruct.index_theta{iexp}) = JacObj(privstruct.index_theta{iexp}) + 2*scaledRes'*scaledResSens;
                    
                case 'Q_expmax'
                    % weighting matrix is the maximum of the trajectories
                    expDataMax = max(inputs.exps.exp_data{iexp});
                    Q = repmat(1./expDataMax, inputs.exps.n_s{iexp},1);
                    % handles close infinity weights:
                    tmp1 = or(isnan(Q),isinf(Q));
                    Q(tmp1) = 1;
                    
                    scaledResM = resM.*Q;
                    % reshape to a columnvector:
                    scaledRes = scaledResM(:);
                    
                    % fobj = ((y_ij-ym_ij)Q_ij)^2
                    % note that we have: resM(:).*Q(:)
                    
                    % scaled Sensitivity of the residuals:
                    % the sensitivities wrt each parameter have the same
                    % scaling factor
                    scaledResSens = resSens.*repmat(Q(:),1,ntheta_iexp);
                    JacRes(nprocessedData+1 : nprocessedData + nexpdata(iexp),privstruct.index_theta{iexp}) = scaledResSens;
                    JacObj(privstruct.index_theta{iexp}) = JacObj(privstruct.index_theta{iexp}) + 2*scaledRes'*scaledResSens;
                    
                case 'Q_expmean'
                    % weighting matrix is the mean of the trajectories
                    expDataMean = mean(inputs.exps.exp_data{iexp});
                    Q = repmat(1./expDataMean, inputs.exps.n_s{iexp},1);
                    % handles close infinity weights:
                    tmp1 = or(isnan(Q),isinf(Q));
                    Q(tmp1) = 1;
                    
                    scaledResM = resM.*Q;
                    % reshape to a columnvector:
                    scaledRes = scaledResM(:);
                    
                    % fobj = ((y_ij-ym_ij)Q_ij)^2
                    % note that we have: resM(:).*Q(:)
                    
                    % scaled Sensitivity of the residuals:
                    % the sensitivities wrt each parameter have the same
                    % scaling factor
                    scaledResSens = resSens.*repmat(Q(:),1,ntheta_iexp);
                    JacRes(nprocessedData+1 : nprocessedData + nexpdata(iexp),privstruct.index_theta{iexp}) = scaledResSens;
                    JacObj(privstruct.index_theta{iexp}) = JacObj(privstruct.index_theta{iexp}) + 2*scaledRes'*scaledResSens;
                    
                otherwise
                    error('no automatic Jacobian for inputs.PEsol.lsq_type = %s is defined.', inputs.PEsol.lsq_type);
            end
            
        case 'llk'
            % residual Matrix: resM
            resM = ms-inputs.exps.exp_data{iexp};
            
            switch inputs.PEsol.llk_type
                
                case {'homo', 'homo_var'}
                    % residuals weighted by the error data OR
                    % exp_data*std_dev
                    % residual Matrix: resM
                    if isempty(inputs.exps.error_data{iexp})
                        
                        inputs.exps.error_data{iexp}=...
                            repmat(max(inputs.exps.exp_data{iexp}).*inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                    end
                    
                    
                    error_data = inputs.exps.error_data{iexp};
                    Q = 1./error_data;
                    % handles close infinity weights:
                    tmp1 = or(isnan(Q),Q > 1/inputs.ivpsol.atol);
                    Q(tmp1) = 1;
                    
                    scaledResM = resM.*Q;
                    % reshape to a columnvector:
                    scaledRes = scaledResM(:);
                    
                    % fobj = ((y_ij-ym_ij)Q_ij)^2
                    % note that we have: resM(:).*Q(:)
                    
                    % scaled Sensitivity of the residuals:
                    % the sensitivities wrt each parameter have the same
                    % scaling factor
                    scaledResSens = resSens.*repmat(Q(:),1,ntheta_iexp);
                    JacRes(nprocessedData+1 : nprocessedData + nexpdata(iexp),privstruct.index_theta{iexp}) = scaledResSens;
                    JacObj(privstruct.index_theta{iexp}) = JacObj(privstruct.index_theta{iexp}) + 2*scaledRes'*scaledResSens;
                    
                    
                    
                case 'hetero'
                    % residual Matrix: resM
                    
                    error_data = abs(inputs.exps.error_data{iexp});
                    error_data(error_data < inputs.ivpsol.atol) = inputs.ivpsol.atol;
                    
                    Q = 1./error_data;
                    %                     % handles close infinity weights:
                    %                     tmp1 = or(isnan(Q),Q > 1/inputs.ivpsol.atol);
                    %                     Q(tmp1) = 1;
                    
                    scaledResM = resM.*Q;
                    % reshape to a columnvector:
                    scaledRes = scaledResM(inputs.exps.nanfilter{iexp});
                    scaledRes = scaledRes(:);
                    
                    % fobj = ((y_ij-ym_ij)Q_ij)^2
                    % note that we have: resM(:).*Q(:)
                    
                    % nanfilter for the sensitivities:
                    inputs.exps.nanfilter_sens = inputs.exps.nanfilter{iexp};
                    inputs.exps.nanfilter_sens = inputs.exps.nanfilter_sens(:);
                    
                    % scaled Sensitivity of the residuals:
                    % the sensitivities wrt each parameter have the same
                    % scaling factor
                    scaledResSens = resSens(inputs.exps.nanfilter_sens,:).*repmat(Q(inputs.exps.nanfilter{iexp}),1,ntheta_iexp);
                    JacRes(nprocessedData+1 : nprocessedData + nexpdata(iexp),privstruct.index_theta{iexp}) = scaledResSens;
                    JacObj(privstruct.index_theta{iexp}) = JacObj(privstruct.index_theta{iexp}) + 2*scaledRes'*scaledResSens;
                    
                    
                    
                case 'hetero_lin'
                    
                    error('Forward sensitivity based computation of the Jacobian for hetero_lin llk is not implemented. \nUse PEcostJac_type = ''mkl''; for finite difference computation or set llk_type=''homo_var''; ');
                    
                case 'hetero_proportional'
                    
                    error('Forward sensitivity based computation of the Jacobian for hetero_proportional llk is not implemented. \nUse PEcostJac_type = ''mkl''; for finite difference computation or set llk_type=''hetero''; ');
                    
                otherwise
                    error('There is no such kind of llk_type, or there is not automatic way to define the Jacobian for: inputs.PEsol.llk_type = %s', inputs.PEsol.llk_type);
                    
            end %switch inputs.llk_type
            
        otherwise
            error('No automatic Jacobian for inputs.PEsol.PEcostJac_type = %s is defined. Sorry.', inputs.PEsol.PEcostJac_type);
    end %   switch inputs.PEsol.PEcost_type
    
    
    
    
    nprocessedData = nprocessedData + nexpdata(iexp);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HANDLING REGULARIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if inputs.nlpsol.regularization.ison
    alpha = inputs.nlpsol.regularization.alpha;
    sqrt_alpha = realsqrt(alpha);
    
    [JRR, JR ] = AMIGO_PEJacreg(inputs,privstruct);
    % for the cost function multiplied by alpha:
    JacObj = JacObj + alpha*JRR';
    JacRes = [JacRes; sqrt_alpha*JR];
    
    JacRegObj = JacRegObj + JRR;
    JacRegRes  = [JacRegRes; JR];
end
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% HANDLING REGULARIZATION  - old version, to be deleted.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % concatenate the Jacobian of the Regularization functional to the Jacobian
% % of the residuals and the Jacobian of the cost function.
% if inputs.nlpsol.regularization.ison
%     switch inputs.nlpsol.regularization.method
%         case 'tikhonov'
%
%             xref = inputs.nlpsol.regularization.tikhonov.gx0;
%             x = privstruct.theta(1,1:inputs.PEsol.n_global_theta);
%             W = inputs.nlpsol.regularization.tikhonov.gW;
%             alpha = inputs.nlpsol.regularization.alpha;
%
%
%             sqrt_alpha = realsqrt(alpha);
%
%             JacRes = [JacRes; sqrt_alpha*W];
%             JacObj = JacObj + alpha*2*((W'*W)*(x(:)-xref(:)))';
%
%
%
%         case 'user_functional'
%             % not implemented yet.
%             error('user_functional is not implemented yet.')
%
%
%         case ''
%             fprintf('Regularization method is empty. Define method for regularization at inputs.nlpsol.regularization.method \n')
%             error('');
%         otherwise
%             fprintf('There is no such regularization method implemented: %s \n',inputs.nlpsol.regularization.method)
%             error('');
%     end
% end


% if ~isempty(inputs.PEsol.log_var)
%     JacRes(:,inputs.PEsol.log_var) = JacRes(:,inputs.PEsol.log_var).*repmat(theta(inputs.PEsol.log_var)',size(JacRes,1),1);
%     JacObj(inputs.PEsol.log_var) = JacObj(inputs.PEsol.log_var).*theta(inputs.PEsol.log_var)';
% end
[JacRes,JacObj] = AMIGO_scale_Jacobian(JacRes,JacObj,theta, inputs);


if any(isnan(JacObj) | isinf(JacObj))
%     keyboard;
%     JacRes(1) = NaN;
    for i = 1:size(JacRes,1)
        for j = 1:size(JacRes,2)
            if isnan(JacRes(i,j))
                JacRes(i,j) =0;
            end
        end
    end
end
if inputs.pathd.print_details
    disp('<-- AMIGO_PEJac()')
end

end

