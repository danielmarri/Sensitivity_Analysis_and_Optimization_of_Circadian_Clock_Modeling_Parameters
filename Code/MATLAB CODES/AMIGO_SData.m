function [results inputs privstruct]=AMIGO_SData(input_file,run_ident)
% AMIGO_SData: simulates observables plus experimental data under a
%              given experimental scheme
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% AMIGO_SData code development:     Eva Balsa-Canto, Attila Gábor             %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_SData: - Simulates observables under a given experimental scheme      %
%              - Generates pseudo-experimental data when required by user     %
%              - Plots states evolution and experimental data vs time         %
%                                                                             %
%               > usage:  AMIGO_SData('input_file',options)                   %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                         different runs, this avoids overwriting             %
%                                                                             %
%               > usage examples:  AMIGO_SData('NFKB_sdata')                  %
%                                  AMIGO_SData('NFKB_sdata','r1')             %
%                                  AMIGO_SData('NFKB_sdata','r2')             %
%*****************************************************************************%
% Last update: EBalsa, 16Jul2013
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_SData.m 2487 2016-02-23 14:01:49Z evabalsa $
%close all;

%Checks for necessary arguments
if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end


%AMIGO_PE header
AMIGO_report_header

%Starts Check of inputs
fprintf(1,'\n\n------>Checking inputs....\n')

%Reads defaults
[inputs_def]= AMIGO_private_defaults;


[inputs_def]= AMIGO_public_defaults(inputs_def);
%[inputs_def,results_def]= AMIGO_public_defaults(inputs_def);

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
%[inputs,results]=AMIGO_check_model(input_file,inputs_def,results_def);

[inputs]=AMIGO_check_exps(inputs);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_data(inputs);


%DETECTS PATH
AMIGO_path

%Generates paths for reporting and plots
AMIGO_paths_SD
AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)

%Generates matlab file to compute observables
AMIGO_gen_obs(inputs,results);


%********************************************************************************************************
%Generates simulated experimental data when required by user

%INITIALIZES VECTORS OF INITIAL CONDITIONS AND PARAMETERS
% Memory allocation
privstruct=inputs.exps;
privstruct.y_0=cell(inputs.exps.n_exp,1);
privstruct.par=cell(inputs.exps.n_exp,1);

for iexp=1:inputs.exps.n_exp
    privstruct.w_obs{iexp}=ones(1,inputs.exps.n_obs{iexp});
end
if isempty(inputs.PEsol.global_theta_guess)==1
    for iexp=1:inputs.exps.n_exp
        privstruct.theta=inputs.model.par;
        inputs.PEsol.n_global_theta=inputs.model.n_par;
        inputs.PEsol.index_global_theta=[1:1:inputs.model.n_par];
    end;
else
    AMIGO_init_theta
end

privstruct=AMIGO_transform_theta(inputs,results,privstruct);

switch inputs.exps.data_type
    case {'pseudo','pseudo_pos'}
        [results.sim.exp_data,inputs.exps.error_data,results.fit.residuals,results.fit.norm_residuals]=AMIGO_pseudo_data(inputs,results,privstruct);
        inputs.exps.exp_data=results.sim.exp_data;
    case 'real'
        fprintf(1,'\n\n\n------>Plotting experimental data vs observables and computing residuals.');
        fprintf(1,'\n\n------>Performing simulation for the given set of parameters');
        results.sim.exp_data = inputs.exps.exp_data;
        results.sim.error_data = inputs.exps.error_data;
end

switch inputs.model.input_model_type
    
    case 'blackboxmodel'
        
        AMIGO_blackbox_smooth_simulation
        
        
    otherwise
        AMIGO_smooth_simulation
        
end


[inputs,results]=AMIGO_post_report_SD(inputs,results,privstruct);

switch inputs.plotd.plotlevel
    case {'full','medium','min'}
        AMIGO_post_plot_SD(inputs,results,privstruct);
    otherwise
        fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
        fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
end

% Compute the residuals between data and simulation:
privstruct.t_int=inputs.exps.t_s;
privstruct.vtout=privstruct.t_int;
switch inputs.model.input_model_type
    case {'fortranmodel','charmodelF','charmodelM','matlabmodel','charmodelC'}
        [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
            AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
    case  'blackboxmodel'
        [results.fit.residuals,results.fit.rel_residuals,results.fit.ms] =...
            AMIGO_residuals(privstruct.theta,inputs,results,privstruct);
end

privstruct.istate_sens=-2;


%****************************************************************************************************************
%SAVES STRUCTURE WITH USEFUL DATA
AMIGO_del_SD
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;

save(inputs.pathd.struct_results,'inputs','results');
cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
if nargout<1
    clear;
end

fclose all;

return