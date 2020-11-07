function [results]=AMIGO_RIdent(input_file,run_ident,opt_solver,opts_solver);
% AMIGO_RIdent: performs the robust Monte-Carlo based identifiability analysis
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
% AMIGO_RIdent: Performs a robust analysis of practical identifiability by    %
%               computing robust confidence regions or expected uncertainty   %
%               for the parameters using a Monte-Carlo based approach.        %
%                                                                             %
%               This analysis requires the solution of the parameter          %
%               estimation problem hundreds of times (by default:1000) thus   %
%               the overall computational cost may increase rapidly.          %
%                                                                             %
%                 - Plots/reports confidence or uncertainty regions by pairs  %
%                   of unknowns (cloud of solutions + ellipses)               %
%                 - Plots/reports confidence or uncertainty for individual    %
%                   unknonwns (histograms)                                    %
%                                                                             %
%               > usage:  AMIGO_RIdent('input_file',options)                  %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                         different runs, this avoids overwriting             %
%                                                                             %
%               > usage examples:  AMIGO_RIdent('NFKB_contour')               %
%                                  AMIGO_RIdent('NFKB_contour','r1')          %
%                                  AMIGO_RIdent('NFKB_contour','r2')          %
%                                                                             %
%               > usage recommendations: type help AMIGO_identifiability      %
%                                                                             %
%            ****                                                             %
%            *    Details on how the identifiability analysis is  performed   %
%            *    may be found in:                                            %
%            *    Balsa-Canto, E., A.A. Alonso and J.R. Banga                 %
%            *    Computational Procedures for Optimal Experimental Design in %
%            *    Biological Systems. IET Systems Biology, 2(4):163-172, 2008 %
%            ****                                                             %
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_RIdent.m 2305 2015-11-25 08:20:26Z evabalsa $

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

[inputs_def]= AMIGO_public_defaults(inputs_def);
% [inputs_def, results_def]= AMIGO_public_defaults(inputs_def);
%
%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
end

%
%   Reads inputs
%

[inputs,results]=AMIGO_check_model(input_file,inputs_def); %results_def
[inputs,results]=AMIGO_check_exps(inputs,results);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_data(inputs);

[inputs]= AMIGO_check_sampling(inputs);
[inputs]= AMIGO_check_theta(inputs);
[inputs]= AMIGO_check_theta_bounds(inputs);


if nargin>2
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,opt_solver);
else
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver);
end

if nargin>3
    inputs.nlpsol.options_file=opts_solver;
end

%
%   DETECTS PATH
%
AMIGO_path


%
%   Generates matlab file to compute observables
%
AMIGO_gen_obs(inputs,results);

%
%   Creates necessary paths
%

AMIGO_paths_RI
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
privstruct.ntotal_obsconstraints=0;
privstruct.ntotal_tsconstraints=0;
if privstruct.ntotal_constraints >0
    [results]=AMIGO_gen_constraints(inputs,results,privstruct);
end


%********************************************************************************************************
%
% Computes robust confidence by a Monte Carlo based approach

fprintf(1,'\n\n------>IMPORTANT!!: SSm has been selected as the default solver to compute robust\n');
fprintf(1,'                        confidence regions. SSm default options have been assigned \n');
fprintf(1,'                        in the ssm_options and ssm_options_conf files.\n');
fprintf(1,'                        You may need to modify those settings for your particular problem,\n');
fprintf(1,'                        particulary:\n');
fprintf(1,'                               - maximum number of function evaluations /iterations,\n');
fprintf(1,'                               - maximum computational time\n');
pause(2)



[results,privstruct]=AMIGO_identifiability(inputs,results,privstruct);


switch inputs.plotd.plotlevel
    case {'full','medium','min'}
        AMIGO_post_plot_RI
    otherwise
        fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
        fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
end




%********************************************************************************************************


results= AMIGO_post_report_RI(inputs,results,privstruct);

%
% SAVES STRUCTURE WITH USEFUL DATA
%
AMIGO_del_RI
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;
save(inputs.pathd.struct_results,'inputs','results');
cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);

if nargout<1
    clear;
end
return