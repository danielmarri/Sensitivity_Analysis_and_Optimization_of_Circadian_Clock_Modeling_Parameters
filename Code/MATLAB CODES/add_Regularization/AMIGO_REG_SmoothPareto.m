function  [reg_summary results inputs] = AMIGO_REG_SmoothPareto(input_file,prev_results)
% Smooth the Pareto front by multi start local optimization
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
%                                                                             %
% AMIGO_REG_PE: performs model unknowns estimation using regularization       %
%          -Intended to compute model unknowns that minimize the distance     %
%           among model predictions and experimental data. This distance may  %
%           be measured in terms of the typical least squares function (lsq)  %
%           or the log-likelihood function (llk)                              %
%                                                                             %
%          -Several types of Gaussian experimental error may be considered    %
%           within the log-likelihood: homocesdastic and heterocesdastic      %
%           with constant and non constant variances                          %
%
%                                                                             %
%          -Several local and global optimization methods may be used:        %
%                                                                             %
%               LOCAL optimization methods:                                   %
%
%
%               GLOBAL optimization methods:                                  %
%
%
%               MULTISTART of local methods:                                  %
%
%               > usage:  AMIGO_PE('input_file',options)                      %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                          different runs, this avoids overwriting            %
%                          'nlp_solver' to rapidly change the optimization mth%
%                                                                             %
%                                                                             %
%               > usage examples:
%
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO_R2012_cvodes/AMIGO_REG_PE.m 1858 2014-08-25 08:12:57Z attila $

if nargout < 2
    error('call with 2 output arguments, otherwise valuable information is lost.')
end

%Checks for necessary arguments
if nargin<1
    fprintf(1,'\n\n------> ERROR message\n\n');
    fprintf(1,'\t\t AMIGO requires at least one input argument: input file.');
    error('error_gen_001','\t\t Impossible to continue. Stopping.\n');
end

%AMIGO_PE header
AMIGO_report_header

%Starts Check of inputs
fprintf(1,'\n\n------>Checking inputs....\n')

%Reads defaults
[inputs_def]= AMIGO_default_options;

%Checks for optional arguments
if nargin>2 && ~isempty(run_ident)
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
end

% check for earlier computations:
if  nargin > 1 && ~isempty(prev_results)
    % report previous results:
    n_prev = length(prev_results);
    fprintf('\t%d previously computed points were detected:\n',n_prev);
    for i = 1:n_prev
        fprintf('-> element %d:\n',i);
        AMIGO_displayStruct(prev_results(i).regularization,[],[],'PrevRegularizationResults')
    end
end

%Reads inputs
[inputs,results]=AMIGO_check_model(input_file,inputs_def);
[inputs,results]=AMIGO_check_exps(inputs,results);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_data(inputs);
inputs = AMIGO_check_Q(inputs);
[inputs]= AMIGO_check_theta(inputs);
[inputs]= AMIGO_check_theta_bounds(inputs);
[inputs]=AMIGO_check_nlp_options(inputs);



% Create privstruct
privstruct=inputs.exps;
AMIGO_init_times


[inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);

%DETECTS PATH
AMIGO_path

%Creates necessary paths
AMIGO_paths_PE
AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)


AMIGO_gen_obs(inputs,results);

%Memory allocation and some necesary assignements
AMIGO_init_PE_guess_bounds

% inputs = AMIGO_check_regularization(inputs);
%Generates matlab files for constraints
privstruct.n_const_ineq_tf=sum(cell2mat(inputs.exps.n_const_ineq_tf));
privstruct.n_const_eq_tf=sum(cell2mat(inputs.exps.n_const_eq_tf));
privstruct.n_control_const=sum(cell2mat(inputs.exps.n_control_const));
privstruct.ntotal_constraints= privstruct.n_const_ineq_tf+privstruct.n_const_eq_tf+privstruct.n_control_const;
privstruct.ntotal_obsconstraints=0;

for iexp=1:inputs.exps.n_exp
    privstruct.w_obs{iexp}=ones(1,inputs.exps.n_obs{iexp});
end

if privstruct.ntotal_constraints >0
    [results]=AMIGO_gen_PEconstraints(inputs,results,privstruct);
end

%***************************************************************************************
%Solves the model calibration problem for either real or simulated experimental data

switch inputs.exps.data_type
    
    case {'pseudo','pseudo_pos'}
        [inputs.exps.exp_data,inputs.exps.error_data,results.fit.residuals,results.fit.norm_residuals]=...
            AMIGO_pseudo_data(inputs,results,privstruct);
        results.sim.exp_data=inputs.exps.exp_data;
        results.sim.error_data=inputs.exps.error_data;
end


privstruct.print_flag=1;

AMIGO_check_overfitting

%*****************************
%**** REGULARIZATION
%*****************************

% inputs.save_results = 0;
% inputs.plotd.plotlevel = 'min';
inputs.nlpsol.regularization.ison = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE regularization results by earlier calculations if given
if nargin > 1 && ~isempty(prev_results)
    [reg_results prev_results]= AMIGO_get_reg_summary(prev_results);
    reg_par_inputs.nalpha = 0;
    reg_par_inputs.alphaSet=[];
else
    error('prev_results are needed.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize the regularization structure
%reg_par_inputs = AMIGO_init_reg_structure (inputs);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check and set-up regualrization related data structures
fatal_error = false;

if strcmpi(inputs.nlpsol.regularization.method,'tikhonov')
    % regularization parameters: alpha, W, reference parameters
    weighting_matrix_flag = 1;
    % regularization matrix related checkings:
    if isempty(inputs.nlpsol.regularization.weighting_matrix_method)
        % weighting matrix:
        if isempty(inputs.nlpsol.regularization.tikhonov.gW)
            fprintf(2,'\tThe regularization matrix is undefined.\n');
            fprintf(2,'Define the matrix: inputs.nlpsol.regularization.tikhonov.gW    OR  select method: inputs.nlpsol.regularization.weighting_matrix_method \n');
            fatal_error = true;
        else
            gW = inputs.nlpsol.regularization.tikhonov.gW;
            inputs.nlpsol.regularization.weighting_matrix_method = 'user_input';
            weighting_matrix_method= 'user_input';
        end
    else
        weighting_matrix_method = inputs.nlpsol.regularization.weighting_matrix_method;
        if ~isempty(inputs.nlpsol.regularization.tikhonov.gW)
            fprintf(2,'\tBoth the regularization matrix W and a method are defined. Remove one of them...\n');
            fatal_error = true;
        end
    end
        
    % reference parameters
    if isempty(inputs.nlpsol.regularization.tikhonov.gx0)
        fprintf(2,'\n\t Parameters lower bound is used as regularization reference. Define with inputs.nlpsol.regularization.tikhonov.gx0 = ...\n');
        inputs.nlpsol.regularization.tikhonov.gx0 = inputs.PEsol.global_theta_min;
    end
else
    weighting_matrix_flag = 0;
end

% pre-calculation
prestep_flag = false;

% how to compute the regularization parameter candidates:
reg_par_candidates = false;

% how the regularization parameter is chosen
if isempty(inputs.nlpsol.regularization.reg_par_method_type)
    reg_par_inputs.reg_par_method_type = 'selective';
else
    reg_par_inputs.reg_par_method_type = inputs.nlpsol.regularization.reg_par_method_type;
end

if fatal_error
    error('An error occured during the check of regularization inputs. Please check the details above.\n')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if strcmpi(reg_par_inputs.reg_par_method_type, 'iterative')
    % Iterative methods, not really implemented yet:)
    switch reg_par_inputs.reg_par_method
        case 'lcurve_iterative'
            keyboard;
            
            stop_flag = false;
            %while(~stop_flag)
            
            % Solve the PE problem
            [PE_results] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
            
            % Process the results
            
    end

elseif strcmpi(reg_par_inputs.reg_par_method_type, 'selective')
    
    
    %% In the pre-step a short(fast) estimation is done for local analysis
    if prestep_flag
        fprintf('---> Regularization pre-calculation is in progress.')
        % non-exhaustive initial search:
            preStepInputs = inputs;
            n_par = length(inputs.model.par);
            preStepInputs.nlpsol.eSS.maxeval = n_par*50;
            preStepInputs.nlpsol.regularization.ison = 0;
%             preStepInputs.nlpsol.eSS.local.solver = ''; % only finish
            pre_step_PE_results = AMIGO_PE(preStepInputs);
            
            %update the inputs' initial guesses with the improved
            % parameters:
            inputs = AMIGO_updatePEinputsbyPEresults(inputs,pre_step_PE_results);

         % see if the problem is ill-posed based on local analysis:   
            JLS0 = pre_step_PE_results.fit.Rjac;  % jacobian
            H0 = JLS0'*JLS0;            % approx hessian
            disp('Eigen values of the approx. Hessian after the prestep:')
            e = eig(H0);format shorte, disp(sort(e,'descend'));        % eigendecomposition
            
            if any(e<0)
                fprintf(1,'\tPre-step Hessian is not positive semidefinit.\n');
            end
            if any((e<max(e)*1e-6) & e>=0)
                fprintf(1,'\tBased on the pre-step Hessian the problem is ill-conditioned.\n');
            else
                fprintf(1,'\tBased on the pre-step Hessian the problem looks well-posed.\n');
            end

    end
    
    
    %% Select regularization weighting matrix if needed:
    if weighting_matrix_flag
        switch weighting_matrix_method
            case 'user_input'
                disp('regularization weighting matrix for global unknowns:')
                disp(inputs.nlpsol.regularization.tikhonov.gW)
            case 'ridge'
                gW = eye(length(inputs.PEsol.global_theta_guess));
            case 'upper_bound'
                gW = diag(1./inputs.PEsol.global_theta_max);
                
            case 'sqrt_upper_bound'
                gW = diag(sqrt(1./inputs.PEsol.global_theta_max));
                
            case 'pre_estimate'
                gW = diag(1./pre_step_PE_results.fit.thetabest);
                
            case 'mean_sensitivity'
                JLS0 = pre_step_PE_results.fit.Rjac;  % jacobian
                
                for i = 1:size(JLS0,2)
                    gW(i,i) = 1/norm(JLS0(:,i));
                end
                
                %case 'fim'
                %    H0 = JLS0;
                %    gW = H0;
            otherwise
                error('no such weighting matrix method: weighting_matrix_method = ''%s'' ',weighting_matrix_method);
        end
        inputs.nlpsol.regularization.tikhonov.gW = gW/norm(gW);
    end
    %% Compute candidate set for the regularization parameters
    
    if reg_par_candidates
        % Hessian of the regularization
        if  strcmpi(inputs.nlpsol.regularization.method,'tikhonov')
            gW = inputs.nlpsol.regularization.tikhonov.gW;  % independent of the parameters.
            Hr = gW'*gW;
        elseif strcmpi(inputs.nlpsol.regularization.method,'user_functional')
            [Rr,Jr]=inputs.nlpsol.regularization.user_reg_functional(pre_step_PE_results.fit.thetabest);
            Hr = Jr'*Jr;
        end
        
        % Help the decision with plotting the eigenvalues:
        reg_eigenplot(H0,Hr,(max(0,e)))
        drawnow;
        
        reply = input('select the approx. regularization parameter: ', 's');
        close
        alpha1 = str2double(reply);
        
        % set-up the regularized estimations
        inputs.nlpsol.regularization.n_alpha = 7;
        reg_par_inputs.nalpha = 7;
        reg_par_inputs.alphaSet =  logspace(log10(alpha1*100), log10(alpha1/100),7);
    end
    
    
    
    %% call the robust solver for the estimations with reg. candidates:
    [PE_results] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
    
    
    % process the results:
    [reg_results PE_results] = AMIGO_get_reg_summary(PE_results);
    
    
    
%     
%     switch reg_par_inputs.reg_par_method
%         case 'lcurve_selection'
%             % simply solves the regularization for a set of regularization
%             % parameters.
%             
%             % solve the regularization problem for each user defined point.
%             [PE_results] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
%             
%             % process the results:
%             [reg_results PE_results] = AMIGO_get_reg_summary(PE_results);
% 
%             
%         case 'method_A'
%             % estimate
% 
%             %%%%%% PRE-STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % non-exhaustive initial search:
%             maxeval = inputs.nlpsol.eSS.maxeval;
%             inputs.nlpsol.eSS.maxeval = 1000;
%             inputs.nlpsol.regularization.ison = 0;
%             results0 = AMIGO_PE(inputs);
%             
%             % local analysis
%             % Hessian of the cost function
%             JLS0 = results0.fit.Rjac;  % jacobian
%             H0 = JLS0'*JLS0;            % approx hessian
%             % Hessian of the regularization
%             if  strcmpi(inputs.nlpsol.regularization.method,'tikhonov')
%                 gW = inputs.nlpsol.regularization.tikhonov.gW;  % independent of the parameters.
%                 Hr = gW'*gW;
%             elseif strcmpi(inputs.nlpsol.regularization.method,'user_functional')
%                 [Rr,Jr]=inputs.nlpsol.regularization.user_reg_functional(results0.fit.thetabest);
%                 Hr = Jr'*Jr;
%             end
%             disp('Eigen values of the first optimized solution'' approx. Hessian:')
%             e = eig(H0);format shorte, disp(e);        % eigendecomposition
%             
%             
%             
%             
%             reg_eigenplot(H0,Hr,(max(0,e)))
%             
%             reply = input('select the approx. regularization parameter: ', 's');
%             close
%             alpha1 = str2double(reply);
%             %         % take the square of the reg. param. selected
%             %         alpha1 = alpha1^2;
%             
%             % update the inputs' initial guesses with the improved
%             % parameters:
%             inputs = AMIGO_updatePEinputsbyPEresults(inputs,results0);
%             
%             %%%%%%%% END OF PRE-STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             
%             
%             % set-up the regularized estimation
%             inputs.nlpsol.regularization.ison = 1;
%             inputs.nlpsol.regularization.n_alpha = 7;
%             inputs.nlpsol.eSS.maxeval = maxeval;
%             reg_par_inputs.nalpha = 7;
%             reg_par_inputs.alphaSet =  logspace(log10(alpha1*100), log10(alpha1/100),7);
%             
%             % solve regularized estimations:
%            [PE_results PE_results_s1] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
%             
%             % process the regularization results:
%             [reg_results PE_results] = AMIGO_get_reg_summary(PE_results);
%             
%             % process the convergence curves
%             conv_res = AMIGO_get_reg_convergence(PE_results_s1,PE_results);
%   
%             
%         case 'GCV'
%             %%%%%% PRE-STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % non-exhaustive initial search:
%             maxeval = inputs.nlpsol.eSS.maxeval;
%             inputs.nlpsol.eSS.maxeval = 1000;
%             inputs.nlpsol.regularization.ison = 0;
%             results0 = AMIGO_PE(inputs);
%             
%             % local analysis
%             JLS0 = results0.fit.Rjac;  % jacobian
%             H0 = JLS0'*JLS0;            % approx hessian
%             disp('Eigen values of the first optimized solution'' approx. Hessian:')
%             e = eig(H0);format shorte, disp(e);        % eigendecomposition
%             reg_eigenplot(H0,gW'*gW,(max(0,e)))
%             
%             reply = input('select the approx. regularization parameter: ', 's');
%             close
%             alpha1 = str2double(reply);
%             %         % take the square of the reg. param. selected
%             %         alpha1 = alpha1^2;
%             % update the inputs' initial guesses with the improved
%             % parameters:
%             inputs = AMIGO_updatePEinputsbyPEresults(inputs,results0);
%             
%             %%%%%%%% END OF PRE-STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             
%             % set-up the regularized estimation
%             inputs.nlpsol.regularization.ison = 1;
%             inputs.nlpsol.regularization.n_alpha = 7;
%             inputs.nlpsol.eSS.maxeval = maxeval;
%             reg_par_inputs.nalpha = 7;
%             reg_par_inputs.alphaSet =  logspace(log10(alpha1*100), log10(alpha1/100),7);
%             
%             % solve regularized estimations:
%             [PE_results] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
%             
%             % process the results:
%             [reg_results PE_results] = AMIGO_get_reg_summary(PE_results);
%             
%             
%         case 'method_B'
%             % estimate
%             
%             %%%%%% PRE-STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % non-exhaustive initial search:
%             maxeval = inputs.nlpsol.eSS.maxeval;
%             inputs.nlpsol.eSS.maxeval = 1000;
%             inputs.nlpsol.regularization.ison = 0;
%             results0 = AMIGO_PE(inputs);
%             
%             % local analysis
%             JLS0 = results0.fit.Rjac;  % jacobian
%             H0 = JLS0'*JLS0;            % approx hessian
%             disp('Eigen values of the first optimized solution'' approx. Hessian:')
%             e = eig(H0);format shorte, disp(e);        % eigendecomposition
%             
%             %disp('*******************************************************************************************')
%             for i = 1:size(JLS0,2)
%                 gW(i,i) = 1/norm(JLS0(:,i));
%             end
%             inputs.nlpsol.regularization.tikhonov.gW = gW/norm(gW);
%             reg_eigenplot(H0,gW'*gW,(max(0,e)))
%             
%             reply = input('select the approx. regularization parameter: ', 's');
%             close
%             alpha1 = str2double(reply);
%             %         % take the square of the reg. param. selected
%             %         alpha1 = alpha1^2;
%             % update the inputs' initial guesses with the improved
%             % parameters:
%             inputs = AMIGO_updatePEinputsbyPEresults(inputs,results0);
%             
%             %%%%%%%% END OF PRE-STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             
%             
%             % set-up the regularized estimation
%             inputs.nlpsol.regularization.ison = 1;
%             inputs.nlpsol.regularization.n_alpha = 7;
%             inputs.nlpsol.eSS.maxeval = maxeval;
%             reg_par_inputs.nalpha = 7;
%             reg_par_inputs.alphaSet =  logspace(log10(alpha1*100), log10(alpha1/100),7);
%             
%             % solve regularized estimations:
%             [PE_results] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
%             
%             % process the results:
%             [reg_results PE_results] = AMIGO_get_reg_summary(PE_results);
%         otherwise
%             error('no such regularization parameter choice method %s \n',reg_par_inputs.reg_par_method)
%     end
%     
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --> APPLY Regularization Parameter choice methods
    
    %%% L-curve curvature based on numerical differentiation:
    alphaSet = reg_results.alpha;
    Q_cost = reg_results.Q_LS;
    Q_penalty = reg_results.Q_penalty;
    [n_lcurve curvature salphaSet  explCurvature implCurvature]= RM_lcurve_ndiff(alphaSet,Q_cost,Q_penalty);
    
    reg_results.lcurve.alpha = salphaSet;
    reg_results.lcurve.n_maxcurve = n_lcurve;
    reg_results.lcurve.curvature = curvature;
    reg_results.lcurve.explCurvature = explCurvature;
    reg_results.lcurve.implCurvature = implCurvature;
    reg_results.lcurve.opt_PEresults = PE_results(n_lcurve);
    
    figure()
    plot(salphaSet,curvature,'.-',salphaSet,explCurvature,'.-',salphaSet,implCurvature,'.-')
    set(gca,'xscale','log')
    title({inputs.pathd.short_name,'Curvature of the L-curve'},'interpreter','none')
    xlabel('Regularization parameter (\alpha_i)')
    ylabel('Curvature of $$(Q_{LS}(\hat\theta_{\alpha_i}),\Gamma(\hat\theta_{\alpha_i}))$$','interpreter','latex')
    legend('Line-curvature','Explicit formula','Implicit formula')
    
    
    %%% Apply the GCV
    alphaSet = reg_results.alpha;
    npar = size(reg_results.theta,2);
    for ires = 1:length(PE_results)
        R = PE_results(ires).fit.R(1:end-npar);
        n = length(R);
        Jr = PE_results(ires).fit.Rjac;
        J = PE_results(ires).fit.Rjac(1:end-npar,:);
        A(:,:,ires) = J*inv(Jr'*Jr)*J';
        V(ires) = 1/n*(R(:)'*R(:))  / (1/n*trace(eye(n)-A(:,:,ires)))^2;
    end
    
    [~, n_opt_GCV] = min(V);
    
    reg_results.GCV.A = A;
    reg_results.GCV.V = V;
    reg_results.GCV.n_opt= n_opt_GCV;
    reg_results.GCV.opt_PEresults = PE_results(n_opt_GCV);
    
    figure()
    plot(alphaSet,V,'.--')
    set(gca,'xscale','log')
    title('GCV curve')
    xlabel('Regularization parameter (\alpha_i)')
    ylabel('estimated CV error')
    
    
    
    
end

%
% [results,privstruct]=AMIGO_call_OPTsolver(...
%     'PE',...
%     inputs.nlpsol.nlpsolver,...
%     inputs.PEsol.vtheta_guess,...
%     inputs.PEsol.vtheta_min,...
%     inputs.PEsol.vtheta_max,...
%     inputs,...
%     results,...
%     privstruct...
%     );
%
% if privstruct.ntotal_constraints >0
%
%     [f,h,g] = AMIGO_PEcost(...
%         results.nlpsol.vbest,...
%         inputs,...
%         results,...
%         privstruct);
%
%     results.fit.constraints_viol=h;
%
% end
%
% % Attila 12/12/2013: put the real residuals/jacobian to the results
% [results.fit.f,results.fit.h,results.fit.R] = AMIGO_PEcost(...
%     results.nlpsol.vbest,...
%     inputs,...
%     results,...
%     privstruct);
% try
%     % the jacobian of the residuals is not available for some objective
%     % functions
%     [results.fit.fjac,results.fit.hjac,results.fit.Rjac] = AMIGO_PEJac(...
%         results.nlpsol.vbest,...
%         inputs,...
%         results,...
%         privstruct);
% catch err
% end
% % HANDLE REGULARIZATION
% if inputs.nlpsol.regularization.ison
%     [f,~,~,regobj,~] = AMIGO_PEcost(results.nlpsol.vbest,inputs,results,privstruct);
%     [~,~,JR,~,Jreg] = AMIGO_PEJac(results.nlpsol.vbest,inputs,results,privstruct);
%     results.regularization.reg = regobj;
%     results.regularization.cost = f;
%     results.regularization.JacRegRes = Jreg;
%     results.regularization.JacObjRes = JR;
%     results.regularization.alpha = inputs.nlpsol.regularization.alpha;
% end
%
%
% %Calculates Residuals and Crammer-Rao confidence intervals for the estimates
% privstruct.theta=results.nlpsol.vbest;
% n_global_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
% privstruct.g_fixedFIM=zeros(n_global_theta,n_global_theta);
%
%
% if ~inputs.PEsol.CramerRao
%
%     switch inputs.model.input_model_type
%
%         case {'fortranmodel','charmodelF','charmodelM','matlabmodel','charmodelC'}
%
%
%             [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
%                 AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
%
%             privstruct=AMIGO_transform_theta(inputs,results,privstruct);
%
%             AMIGO_smooth_simulation
%             privstruct.conf_intervals=0;
%         case  'blackboxmodel'
%
%             [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
%                 AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
%             privstruct=AMIGO_transform_theta(inputs,results,privstruct);
%             AMIGO_blackbox_smooth_simulation
%             privstruct.conf_intervals=0;
%     end
%
%     privstruct.istate_sens=-2;
%
%
% else
%     switch inputs.model.input_model_type
%
%         case {'fortranmodel','charmodelF','charmodelM','matlabmodel','charmodelC'}
%
%             [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
%                 AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
%             fprintf(1,'\n\n------> Computing Correlation Matrix for unknowns...');
%
%             [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,1,inputs.exps.n_exp);
%
%             if privstruct.istate_sens < 0
%
%                 fprintf(1,'\n\n------>An error was obtained when computing sensitivities.\n');
%                 fprintf(1,'\n\n       Sorry, it was not possible to compute Cramer-Rao confidence intervals.');
%
%             end
%
%             privstruct=AMIGO_transform_theta(inputs,results,privstruct);
%
%             AMIGO_smooth_simulation
%
%         case  'blackboxmodel'
%
%             [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
%                 AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
%             fprintf(1,'\n\n------> Computing Correlation Matrix for unknowns...');
%             [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,1,inputs.exps.n_exp);
%
%             if privstruct.istate_sens < 0
%
%                 fprintf(1,'\n\n------>An error was obtained when computing sensitivities.\n');
%                 fprintf(1,'\n\n       Sorry, it was not possible to compute Cramer-Rao confidence intervals.');
%
%             end
%
%             privstruct=AMIGO_transform_theta(inputs,results,privstruct);
%             AMIGO_blackbox_smooth_simulation
%
%         case {'sbmlmodel','blackboxcost'}
%
%             fprintf(1,'Crammer-Rao confidence intervals can not be calculated. Use FORTRAN for this to be available.');
%             privstruct.istate_sens=-2;
%             [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
%                 AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
%
%     end
%
% end
%
% [inputs,results]=AMIGO_post_report_PE(inputs,results,privstruct);
%
% switch results.plotd.plotlevel
%
%     case {'full','medium','min'}
%
%         AMIGO_post_plot_PE(inputs,results,privstruct);
%
%     otherwise
%
%         fprintf(1,'\n------>No plots are being generated, since results.plotd.plotlevel=''noplot''.\n');
%         fprintf(1,'         Change results.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
%
% end
%
% results.fit.thetabest=results.nlpsol.vbest;
% results.fit.fbest=results.nlpsol.fbest;
% results.fit.cpu_time=results.nlpsol.cpu_time;
%
% results.PEsol.index_global_theta_y0=inputs.PEsol.index_global_theta_y0;
% results.PEsol.index_global_theta=inputs.PEsol.index_global_theta;
% results.PEsol.index_local_theta_y0=inputs.PEsol.index_local_theta_y0;
% results.PEsol.index_local_theta=inputs.PEsol.index_local_theta;
% results.PEsol.n_global_theta=inputs.PEsol.n_global_theta;
% results.PEsol.n_theta=inputs.PEsol.n_theta;
% results.PEsol.n_local_theta=inputs.PEsol.n_local_theta;
% results.PEsol.n_global_theta_y0=inputs.PEsol.n_global_theta_y0;



reg_summary = reg_results;
results = PE_results;

%***************************************************************************************************
% SAVES STRUCTURE WITH USEFUL DATA
%AMIGO_del_PE

if (inputs.save_results)
    
    save(inputs.pathd.struct_results,'inputs','results','privstruct','reg_results');
    fprintf(1,'\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t%s\n\n', inputs.pathd.task_folder);
    
end

% if nargout<1
%     clear all;
% end

fclose all;

% TODO

return