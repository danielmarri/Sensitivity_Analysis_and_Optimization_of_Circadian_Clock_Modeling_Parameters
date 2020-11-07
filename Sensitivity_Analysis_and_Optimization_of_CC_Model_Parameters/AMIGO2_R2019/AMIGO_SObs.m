function [results]=AMIGO_SObs(input_file,run_ident);
% AMIGO_SObs: simulates observables under a given experimental scheme
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
% AMIGO_SObs: Simulates observables under a given experimental scheme         %
%               and plots states evolution vs time                            %
%                                                                             %
%               > input_file is the name of the function provided by the user %
%               with the problem related data                                 %
%               function [inputs,results]=input_file(inputs,results);         %
%               This file should be under the folder Inputs or Examples       %
%                                                                             %
%               > usage:  AMIGO_SObs('input_file',options)                    %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                         different runs, this avoids overwriting             %
%                                                                             %
%               > usage examples:  AMIGO_SObs('NFKB_sobs')                    %
%                                  AMIGO_SObs('NFKB_sobs','r1')               %
%                                  AMIGO_SObs('NFKB_sobs','r2')               %
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_SObs.m 2305 2015-11-25 08:20:26Z evabalsa $
close all;


%
%   Checks for necessary arguments
%

if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end


%   AMIGO_PE header
AMIGO_report_header


%
%  Starts Check of inputs
%
fprintf(1,'\n\n------>Checking inputs....\n')

%
%   Reads defaults
%

[inputs_def]= AMIGO_private_defaults;

[inputs_def]= AMIGO_public_defaults(inputs_def);
% [inputs_def, results_def]= AMIGO_public_defaults(inputs_def);
%Checks for optional arguments

%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
end

% Reads inputs
[inputs,results]=AMIGO_check_model(input_file,inputs_def);
[inputs]=AMIGO_check_exps(inputs);

[inputs]=AMIGO_check_obs(inputs);
inputs=AMIGO_check_Q(inputs);

%DETECTS PATH
AMIGO_path

%Generates matlab file to compute observables
AMIGO_gen_obs(inputs,results);

%Generates paths for reporting and plots
AMIGO_paths_SO

AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)



%**************************************************************************
% Simulates the observables for the given set of parameters
%INITIALIZES VECTORS OF INITIAL CONDITIONS AND PARAMETERS
% Memory allocation
privstruct=inputs.exps;
privstruct.y_0=cell(inputs.exps.n_exp,1);
privstruct.par=cell(inputs.exps.n_exp,1);
for iexp=1:inputs.exps.n_exp
    privstruct.w_obs{iexp}=ones(1,inputs.exps.n_obs{iexp});
end

if isempty(inputs.PEsol.id_global_theta)==1
    for iexp=1:inputs.exps.n_exp
        privstruct.theta=inputs.model.par;
        inputs.PEsol.n_global_theta=inputs.model.n_par;
        inputs.PEsol.index_global_theta=[1:1:inputs.model.n_par]; end;
else
    AMIGO_init_theta
end

privstruct=AMIGO_transform_theta(inputs,results,privstruct);

fprintf(1,'\n\n\n------>Performing simulation for the given set of parameters and initial conditions');


AMIGO_smooth_simulation
[results]=AMIGO_post_report_SO(inputs,results,privstruct);
switch inputs.plotd.plotlevel
    case {'full','medium','min'}
        AMIGO_post_plot_SO(inputs,results,privstruct);
    otherwise
        fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
        fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
end


%**************************************************************************
% SAVES STRUCTURE WITH USEFUL DATA
AMIGO_del_SO
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