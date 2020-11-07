function [results]=AMIGO_ContourP(input_file,run_ident);
% AMIGO_ContourP: plots contours of the Maximum Likelihood function by
% pairs of unknowns
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
% AMIGO_ContourP: - plots contours of the Maximum Likelihood function by      %
%                   pairs of unknowns, this may help to detect lack of        %
%                   practical identifiability, presence of suboptimal         %
%                   solutions, to define suitable bounds for the unknowns,... %
%                                                                             %
%               > usage:  AMIGO_ContourP('input_file',options)                %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                         different runs, this avoids overwriting             %
%                                                                             %
%               > usage examples:  AMIGO_ContourP('NFKB_contour')             %
%                                  AMIGO_ContourP('NFKB_contour','r1')        %
%                                  AMIGO_ContourP('NFKB_contour','r2')        %
%                                                                             %
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_ContourP.m 2305 2015-11-25 08:20:26Z evabalsa $
close all;

%
%   Checks for necessary arguments
%

if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end

%
%   AMIGO_PE header
%

AMIGO_report_header



%
%  Starts Check of inputs
%
fprintf(1,'\n\n------>Checking inputs....\n')

%
%   Reads defaults
%

[inputs_def]= AMIGO_private_defaults;
%[inputs_def, results_def]= AMIGO_public_defaults(inputs_def);
[inputs_def]= AMIGO_public_defaults(inputs_def);
%
%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
end
%   Reads inputs
%
[inputs,results]=AMIGO_check_model(input_file,inputs_def); % ,results_def
[inputs]=AMIGO_check_exps(inputs);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_data(inputs);
[inputs]= AMIGO_check_sampling(inputs);
[inputs]= AMIGO_check_theta(inputs);
[inputs]= AMIGO_check_theta_bounds(inputs);


%
%   DETECTS PATH
%
AMIGO_path



%
%   Generates matlab file to compute observables
%
AMIGO_gen_obs(inputs,results);


%
%   Generates paths for reporting and plots
%
AMIGO_paths_CP
AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)
%
%   Memory allocation and some necesary assignements
%

%INITIALIZES VECTORS OF INITIAL CONDITIONS AND PARAMETERS
privstruct=inputs.exps;

% Memory allocation
privstruct.y_0=cell(inputs.exps.n_exp,1);
privstruct.par=cell(inputs.exps.n_exp,1);
if isempty(inputs.PEsol.id_global_theta)==1
    for iexp=1:inputs.exps.n_exp
        privstruct.theta=inputs.model.par;
        inputs.PEsol.n_global_theta=inputs.model.n_par;
        inputs.PEsol.index_global_theta=[1:1:inputs.model.n_par]; end;
else
    AMIGO_init_theta
end
% Vector definition
privstruct=AMIGO_transform_theta(inputs,results,privstruct);
AMIGO_init_PE_guess_bounds

%
%   Generates matlab files for constraints
%

privstruct.n_const_ineq_tf=sum(cell2mat(inputs.exps.n_const_ineq_tf));
privstruct.n_const_eq_tf=sum(cell2mat(inputs.exps.n_const_eq_tf));
privstruct.n_control_const=sum(cell2mat(inputs.exps.n_control_const));
privstruct.ntotal_constraints= privstruct.n_const_ineq_tf+privstruct.n_const_eq_tf+privstruct.n_control_const;

if privstruct.ntotal_constraints >0
    [results]=AMIGO_gen_constraints(inputs,results,privstruct);
end

%********************************************************************************************************
%
%   Generates maximum-likelihood contour plots by pairs of parameters
%
switch inputs.exps.data_type
    case {'pseudo','pseudo_pos'}
        [inputs.exps.exp_data,inputs.exps.error_data,results.fit.residuals,results.fit.norm_residuals]=AMIGO_pseudo_data(inputs,results,privstruct);
        results.sim.exp_data = inputs.exps.exp_data;
        results.sim.error_data=inputs.exps.error_data;
end


fprintf('\n\n------> Generating maximum likelihood plots for all model unknowns\n');

for i=1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
    index_theta=[i];
    [results.contour.error1d{i},results.contour.par1d{i}]=...
        AMIGO_post_plot_PC_1D(inputs.PEsol.vtheta_guess(1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0),index_theta,inputs,results,privstruct);
    close
end

index_theta=[0 0];

if inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0 >1
    fprintf('\n\n------> Generating maximum likelihood contour plots for pairs of global unknowns \n');
    for i=1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0-1
        for j=i+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
            index_theta=[i j];
            
            [results.contour.errorxy{i,j},results.contour.parx{i},results.contour.pary{j}]=...
                AMIGO_post_plot_PC(inputs.PEsol.vtheta_guess(1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0),index_theta,inputs,results,privstruct);
            if(inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0)>7
                close
            end
            
        end
    end
    
    
    
end
%********************************************************************************************************

[results]=AMIGO_post_report_SM(inputs,results,privstruct);

[inputs,results]=AMIGO_post_report_SD(inputs,results,privstruct);

%
% SAVES STRUCTURE WITH USEFUL DATA
%

%
% SAVES STRUCTURE WITH USEFUL DATA
%

switch results.plotd.plotlevel
    case 'noplot'
        fprintf(1,'\n------>No plots were generated, since results.plotd.plotlevel=''noplot''.\n');
        fprintf(1,'         Change results.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
end

AMIGO_del_CP
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;
save(inputs.pathd.struct_results,'inputs','results');

cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);


if nargout<1
    clear all;
end
return