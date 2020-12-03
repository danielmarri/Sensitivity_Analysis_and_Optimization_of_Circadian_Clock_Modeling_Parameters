function [reg_summary results inputs]=AMIGO_REG_PE(input_file,prev_results,run_ident)
% AMIGO_REG_PE: performs model unknowns estimation with regularization
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% AMIGO_REG_PE Code development:     Attila Gàbor                             %
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
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_REG_PE.m 2305 2015-11-25 08:20:26Z evabalsa $





%Checks for necessary arguments
if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end

if nargout < 2
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t Call with 2 output arguments, otherwise valuable information is lost.\n\n');
    return;
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


inputs = AMIGO_check_regularization(inputs,0);
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
else
    reg_results = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize the regularization structure
%reg_par_inputs = AMIGO_init_reg_structure (inputs);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check and set-up regualrization related data structures
fatal_error = false;

results.regularization.reg_method = inputs.nlpsol.regularization.method;

if strcmpi(inputs.nlpsol.regularization.method,'tikhonov')
    % regularization parameters: alpha, W, reference parameters
    weighting_matrix_flag = 1;
    results.regularization.weighting.weighting_matrix_flag = 1;
    
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
    results.regularization.ref_par.gx0 = inputs.nlpsol.regularization.tikhonov.gx0;
        
else
    weighting_matrix_flag = 0;
    results.regularization.weighting.weighting_matrix_flag = 0;
end


% how to compute the regularization parameter candidates:
reg_par_candidates = false;
if isempty(inputs.nlpsol.regularization.alphaSet)
    reg_par_candidates = true;
else
    % set-up the regularized estimations
    na = length(inputs.nlpsol.regularization.alphaSet);
    inputs.nlpsol.regularization.n_alpha =na;
    reg_par_inputs.nalpha = na;
    reg_par_inputs.alphaSet =  inputs.nlpsol.regularization.alphaSet;
end

% Decide on the neccessity of the pre-calculation
prestep_flag = false;
if reg_par_candidates
    prestep_flag = true;
end
if isempty(inputs.nlpsol.regularization.alpha) && ...
        isempty(inputs.nlpsol.regularization.alphaSet)
    prestep_flag = true;
end
if strcmp(weighting_matrix_method,'pre_estimate')  || ...
    strcmp(weighting_matrix_method,'mean_sensitivity')
    prestep_flag = true;
end




% how the regularization parameter is chosen
if isempty(inputs.nlpsol.regularization.reg_par_method_type)
    reg_par_inputs.reg_par_method_type = 'selective';
else
    reg_par_inputs.reg_par_method_type = inputs.nlpsol.regularization.reg_par_method_type;
end

if fatal_error
 
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t An error occured during the check of regularization inputs. Please check the details above.\n\n');
    return;
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
            [PE_results, ~, utopia] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
            
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
            
        results.regularization.preStep.peresults = pre_step_PE_results;
        results.regularization.preStep.Jacobian = JLS0;
        results.regularization.preStep.Hessian = H0;
        results.regularization.preStep.Hessian_eigs = e;
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
                
            cprintf('*red','\n\n------> ERROR message\n\n');
            cprintf('red','\t\t The weighting matrix method %s is not available.\n\n',weighting_matrix_method);
            return;
        end
%         inputs.nlpsol.regularization.tikhonov.gW = gW/norm(gW);
        
        results.regularization.weighting.method = weighting_matrix_method;
        results.regularization.weighting.gW = inputs.nlpsol.regularization.tikhonov.gW;
    end
    %% Compute candidate set for the regularization parameters
    
    if reg_par_candidates
        % Hessian of the regularization
        if  strcmpi(inputs.nlpsol.regularization.method,'tikhonov')
            gW = inputs.nlpsol.regularization.tikhonov.gW;  % independent of the parameters.
            gyW = inputs.nlpsol.regularization.tikhonov.gyW;  % independent of the parameters.
            W = blkdiag(gW,gyW);
            Hr = W'*W;
        elseif strcmpi(inputs.nlpsol.regularization.method,'user_functional')
            [Rr,Jr]=inputs.nlpsol.regularization.user_reg_functional(pre_step_PE_results.fit.thetabest);
            Hr = Jr'*Jr;
        end
        
        % Help the decision with plotting the eigenvalues:
        fh = reg_eigenplot(H0,Hr,(max(0,e)));
        drawnow;
        
        reply = input('select the approx. regularization parameter: ', 's');
        try, close(fh), end;
        alpha1 = str2double(reply);
        
        % set-up the regularized estimations
       if isempty( inputs.nlpsol.regularization.n_alpha)
           inputs.nlpsol.regularization.n_alpha = 11;
           reg_par_inputs.nalpha = 11;
       else
           reg_par_inputs.nalpha = inputs.nlpsol.regularization.n_alpha;
       end
        reg_par_inputs.alphaSet =  logspace(log10(alpha1*100), log10(alpha1/100),reg_par_inputs.nalpha);
    end
    
    
    
    %% call the robust solver for the estimations with reg. candidates:
    [PE_results,~,utopia] = AMIGO_solve_REGPE_forPoints(inputs,reg_par_inputs,reg_results);
    
    
    % process the results:
    [reg_results PE_results] = AMIGO_get_reg_summary(PE_results);
    
    %%
    % Plot effective number of parameters against the cost function.
    
%     AMIGO_effective_npar( PE_results)
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --> APPLY Regularization Parameter choice methods
    
    %%% L-curve curvature based on numerical differentiation:
    [lcurve index_maxcurvature] = AMIGO_LCurve(reg_results,inputs.nlpsol.regularization.plotflag);
    
    reg_results.lcurve =  lcurve;
    % put here the l-curve - optimal PE results:
    reg_results.lcurve.opt_PEresults = PE_results(index_maxcurvature);

    
    %%% Apply the GCV
    GCV = AMIGO_GCV_wrapper(PE_results,inputs.nlpsol.regularization.plotflag);
    %GCV2 = AMIGO_GCV_wrapper2(PE_results,inputs.nlpsol.regularization.plotflag);
    
%     reg_results.GCV.A = GCV.A;
    reg_results.GCV.V = GCV.V;
    reg_results.GCV.n_opt= GCV.n_opt;
    reg_results.GCV.opt_PEresults = PE_results(GCV.n_opt);
    reg_results.GCV.onbound = GCV.onbound;
    
    %reg_results.GCV2.V = GCV2.V;
    %reg_results.GCV2.n_opt= GCV2.n_opt;
    %reg_results.GCV2.opt_PEresults = PE_results(GCV2.n_opt);
    %reg_results.GCV2.onbound = GCV2.onbound;
end




reg_summary = reg_results;
results.regularization.PEiter = PE_results;

%***************************************************************************************************
% SAVES STRUCTURE WITH USEFUL DATA
%AMIGO_del_PE
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;
if (inputs.save_results)
    
    save(inputs.pathd.struct_results,'inputs','results','privstruct','reg_results');
   cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
end

fclose all;

% TODO

return