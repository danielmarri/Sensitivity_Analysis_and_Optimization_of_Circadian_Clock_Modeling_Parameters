function [results, inputs, privstruct]=AMIGO_IPE(input_file,run_ident,opt_solver,opts_solver)
% AMIGO_PE: performs model unknowns estimation
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    %
% AMIGO_IPE code development: Eva Balsa-Canto,                                %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_IPE: performs model unknowns estimation parameters + stimulation      %
%          -Intended to compute model unknowns that minimize the distance     %
%           among model predictions and experimental data. This distance may  %
%           be measured in terms of the typical least squares function (lsq)  %
%           or the log-likelihood function (llk)                              %
%                                                                             %
%          -Several types of Gaussian experimental error may be considered    %
%           within the log-likelihood: homocesdastic and heterocesdastic      %
%           with constant and non constant variances                          %
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
%               > usage:  AMIGO_IPE('input_file',options)                     %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                          different runs, this avoids overwriting            %
%                          'nlp_solver' to rapidly change the optimization mth%
% close all;
%Checks for necessary arguments

if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end


%AMIGO_PE header
AMIGO_report_header

%Starts Check of inputs
fprintf(1,'\n\n------>Checking inputs....\n');

%Reads defaults
[inputs_def]= AMIGO_private_defaults;

[inputs_def]= AMIGO_public_defaults(inputs_def);
% [inputs_def, results_def]= AMIGO_public_defaults(inputs_def);

%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
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

[inputs]= AMIGO_scale_model_parameters(inputs);

%if strcmpi(inputs.ivpsol.ivpsolver,'cvodes')
%   if ~exist([inputs.pathd.AMIGO_path, '\Results\',inputs.pathd.results_folder '\'  inputs.ivpsol.ivpmex,'.mexw32'],'file')
%       error('mexfile for CVODES does not exist. Please run AMIGO_Prep before.')
%   end
%end

privstruct=inputs.exps;
AMIGO_init_times

% inputs_orig = inputs; % keep the input, that is not modified by check_NLPsolver.

if nargin>2
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,opt_solver,privstruct);
    
else
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);
end


if nargin>3
    inputs.nlpsol.options_file=opts_solver;
end

%DETECTS PATH
AMIGO_path

%Creates necessary paths
AMIGO_paths_PE
AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)


AMIGO_gen_obs(inputs,results);


%Memory allocation and some necesary assignements
AMIGO_init_PE_guess_bounds
% Regularization needs the indexis of the theta
inputs = AMIGO_check_regularization(inputs);

%Generates matlab files for constraints
privstruct.n_const_ineq_tf=sum(cell2mat(inputs.exps.n_const_ineq_tf));
privstruct.n_const_eq_tf=sum(cell2mat(inputs.exps.n_const_eq_tf));
privstruct.n_control_const=sum(cell2mat(inputs.exps.n_control_const));
privstruct.ntotal_constraints= privstruct.n_const_ineq_tf+privstruct.n_const_eq_tf+privstruct.n_control_const;
privstruct.ntotal_obsconstraints=0;
privstruct.ntotal_tsconstraints=0;

for iexp=1:inputs.exps.n_exp
    privstruct.w_obs{iexp}=ones(1,inputs.exps.n_obs{iexp});
end

if privstruct.ntotal_constraints >0
    [results,inputs]=AMIGO_gen_PEconstraints(inputs,results,privstruct);
end



% creating indexing for the decision vector:
privstruct.index_theta = AMIGO_index_theta_vector(inputs);
%***************************************************************************************
%Solves the model calibration problem for either real or simulated experimental data

switch inputs.exps.data_type
    
    case {'pseudo','pseudo_pos'}
        % generate pseudo experimental data.
        [inputs.exps.exp_data,inputs.exps.error_data,results.fit.residuals,results.fit.norm_residuals]=...
            AMIGO_pseudo_data(inputs,results,privstruct);
        results.sim.exp_data=inputs.exps.exp_data;
        results.sim.error_data=inputs.exps.error_data;        
        
    case {'real'}
        % transfer the data to the results.
        results.sim.exp_data=inputs.exps.exp_data;
        results.sim.error_data=inputs.exps.error_data;        
end


privstruct.print_flag=1;

AMIGO_check_overfitting


[results,privstruct]=AMIGO_call_OPTsolver(...
    'PE',...
    inputs.nlpsol.nlpsolver,...
    inputs.PEsol.vtheta_guess,...
    inputs.PEsol.vtheta_min,...
    inputs.PEsol.vtheta_max,...
    inputs,...
    results,...
    privstruct...
    );

if privstruct.ntotal_constraints >0
    
    [f,h,g] = AMIGO_PEcost(...
        results.nlpsol.vbest,...
        inputs,...
        results,...
        privstruct);
    
    results.fit.constraints_viol=h;
    
end

% if ~strcmpi(inputs.model.exe_type, 'fullMex')
    % Attila 12/12/2013: put the real residuals/jacobian to the results
    try
    [results.fit.f,results.fit.h,results.fit.R] = AMIGO_PEcost(...
        results.nlpsol.vbest,...
        inputs,...
        results,...
        privstruct);
    catch
        keyboard
    end
    try
        % the jacobian of the residuals is not available for some objective
        % functions
        [results.fit.fjac,results.fit.hjac,results.fit.Rjac] = AMIGO_PEJac(...
            results.nlpsol.vbest,...
            inputs,...
            results,...
            privstruct);
    catch err
        disp(err.message)
    end
% end
% HANDLE REGULARIZATION
if inputs.nlpsol.regularization.ison
    [f,~,~,regobj,~] = AMIGO_PEcost(results.nlpsol.vbest,inputs,results,privstruct);
    [~,~,JR,~,Jreg] = AMIGO_PEJac(results.nlpsol.vbest,inputs,results,privstruct);
    results.regularization.reg = regobj;
    results.regularization.cost = f;
    results.regularization.JacRegRes = Jreg;
    results.regularization.JacObjRes = JR;
    results.regularization.alpha = inputs.nlpsol.regularization.alpha;
end
results.nlpsol.vbest = AMIGO_scale_theta_back(results.nlpsol.vbest, inputs); 
[inputs]= AMIGO_scale_model_parameters(inputs,1);
% if ~isempty(inputs.PEsol.log_var)
%     results.nlpsol.vbest(inputs.PEsol.log_var) = exp((inputs.PEsol.log_var));
% end
% inputs = AMIGO_expscale_theta (inputs);



%Calculates Residuals and Crammer-Rao confidence intervals for the estimates
privstruct.theta=results.nlpsol.vbest;
n_global_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
privstruct.g_fixedFIM=zeros(n_global_theta,n_global_theta);


if ~inputs.PEsol.CramerRao
    
    switch inputs.model.input_model_type
        
        case {'fortranmodel','charmodelF','charmodelM','matlabmodel','charmodelC'}
            

            [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
                AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
            
            privstruct=AMIGO_transform_theta(inputs,results,privstruct);
            
            AMIGO_smooth_simulation
            privstruct.conf_intervals=0;
        case  'blackboxmodel'
            
            [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
                AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
            privstruct=AMIGO_transform_theta(inputs,results,privstruct);
            AMIGO_blackbox_smooth_simulation
            privstruct.conf_intervals=0;
    end
    
    privstruct.istate_sens=-2;
    
    
else
    switch inputs.model.input_model_type
        
        case {'fortranmodel','charmodelF','charmodelM','matlabmodel','charmodelC'}
            
            [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
                AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
            fprintf(1,'\n\n------> Computing Correlation Matrix for unknowns...');
            
            [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,1,inputs.exps.n_exp);
            
            if privstruct.istate_sens < 0
                
                fprintf(1,'\n\n------>An error was obtained when computing sensitivities.\n');
                fprintf(1,'\n\n       Sorry, it was not possible to compute Cramer-Rao confidence intervals.');
                
            end
            
            privstruct=AMIGO_transform_theta(inputs,results,privstruct);
            
            AMIGO_smooth_simulation
            
        case  'blackboxmodel'
            
            [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
                AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
            fprintf(1,'\n\n------> Computing Correlation Matrix for unknowns...');
             [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,1,inputs.exps.n_exp);
%             
             if privstruct.istate_sens < 0
%                 
%                 fprintf(1,'\n\n------>An error was obtained when computing sensitivities.\n');
                 fprintf(1,'\n\n       Sorry, it was not possible to compute Cramer-Rao confidence intervals.');
                 
             end
            
            privstruct=AMIGO_transform_theta(inputs,results,privstruct);
            AMIGO_blackbox_smooth_simulation
            
        case {'sbmlmodel','blackboxcost'}
            
            fprintf(1,'Crammer-Rao confidence intervals can not be calculated. Use FORTRAN for this to be available.');
            privstruct.istate_sens=-2;
            [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
                AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
            
    end
    
end

[inputs,results]=AMIGO_post_report_PE(inputs,results,privstruct);

switch results.plotd.plotlevel
    
    case {'full','medium','min'}
        
        AMIGO_post_plot_PE(inputs,results,privstruct);
        
    otherwise
        
        fprintf(1,'\n------>No plots are being generated, since results.plotd.plotlevel=''noplot''.\n');
        fprintf(1,'         Change results.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
        
end

results.fit.thetabest=results.nlpsol.vbest;
results.fit.fbest=results.nlpsol.fbest;
results.fit.cpu_time=results.nlpsol.cpu_time;

results.PEsol.index_global_theta_y0=inputs.PEsol.index_global_theta_y0;
results.PEsol.index_global_theta=inputs.PEsol.index_global_theta;
results.PEsol.index_local_theta_y0=inputs.PEsol.index_local_theta_y0;
results.PEsol.index_local_theta=inputs.PEsol.index_local_theta;
results.PEsol.n_global_theta=inputs.PEsol.n_global_theta;
results.PEsol.n_theta=inputs.PEsol.n_theta;
results.PEsol.n_local_theta=inputs.PEsol.n_local_theta;
results.PEsol.n_global_theta_y0=inputs.PEsol.n_global_theta_y0;




%***************************************************************************************************
% SAVES STRUCTURE WITH USEFUL DATA
AMIGO_del_PE
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;

if (inputs.save_results)
    
save(inputs.pathd.struct_results,'inputs','results','privstruct');
cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
end

if nargout<1
    clear ;
end

fclose all;

return