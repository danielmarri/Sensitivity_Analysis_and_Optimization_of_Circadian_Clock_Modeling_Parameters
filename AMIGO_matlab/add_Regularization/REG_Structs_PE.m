% $Header: svn://.../trunk/AMIGO_R2012_cvodes/add_Regulator/Kernel/REG_Structs_PE.m 1448 2014-05-06 11:43:41Z attila $
function [inputs,results,privstruct]=REG_Structs_PE(input_file,run_ident,varargin)
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% modified:             Attila Gabor                                          %
% date:                 02/07/2013
%
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_Structs_PE: creates inputs, results and privstructs structs to be used%
%                   in subsequent calls by other functions.                   %
%                   Inputs are checked and missing inputs are filled with default values                                                          %
%               > usage:  AMIGO_Structs('input_file')  takes a filename
%                         AMIGO_Structs(inputs)         takes a structure
%
%               > usage examples:  AMIGO_Structs('NFKB_PE')                   %
%*****************************************************************************%


%
%   Checks for necessary arguments
%

if nargin<1
    fprintf(1,'\n\n------> ERROR message\n\n');
    fprintf(1,'\t\t AMIGO requires at least one input argument: input file.');
    error('error_gen_001','\t\t Impossible to continue. Stopping.\n');
end



%
% Reads defaults
%
[inputs_def]= AMIGO_private_defaults;
[inputs_def]= AMIGO_public_defaults(inputs_def);
% [inputs_def, results_def]= AMIGO_public_defaults(inputs_def);
%Checks for optional arguments
if nargin>1
    %results_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident_cl=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident_cl=inputs_def.pathd.runident;
end

%
%Reads inputs
%
[inputs,results]=AMIGO_check_model(input_file,inputs_def);
%[inputs,results]=AMIGO_check_model(input_file,inputs_def,results_def);

[inputs,results]=AMIGO_check_exps(inputs,results);

[inputs]=AMIGO_check_obs(inputs);

[inputs]=AMIGO_check_data(inputs);
[inputs]= AMIGO_check_theta(inputs);
[inputs]= AMIGO_check_theta_bounds(inputs);
[inputs]=AMIGO_check_nlp_options(inputs);
[inputs]=AMIGO_check_vectors_orientation(inputs);
privstruct=inputs.exps;
% AMIGO_check_NLPsolver modifies the inputs.nlpsol.nlpsolver field and
% cause error if it is called again.
if nargin>2
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,opt_solver,privstruct);
else
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);
end


%DETECTS PATH
AMIGO_path

%Creates necessary paths
AMIGO_paths_PE

%Generates matlab file to compute observables
if(~strcmp(inputs.model.exe_type,'costMex') && ~strcmp(inputs.model.exe_type,'fullMex'))
    AMIGO_gen_obs(inputs,results);
end





%
%Memory allocation and some necesary assignements
%

AMIGO_init_PE_guess_bounds

inputs = AMIGO_check_regularization(inputs);


%
%Generates matlab files for constraints
%

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


privstruct.print_flag=1;

% creating indexing for the decision vector:
privstruct.index_theta = AMIGO_index_theta_vector(inputs);
end


