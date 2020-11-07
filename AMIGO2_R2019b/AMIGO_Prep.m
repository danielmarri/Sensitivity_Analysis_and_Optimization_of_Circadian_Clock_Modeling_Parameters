function [inputs privstruct] = AMIGO_Prep(input_file)
% AMIGO_Prep: Preprocessor main file
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% AMIGO_Prep code development: Eva Balsa-Canto, David Henriques               %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_Prep: Performs several task to prepare an AMIGO session:             %
%              > Generates necessary fortran code, mex files and matlab files %
%
%               The user should run AMIGO_Prep when:                          %
%                 - Once open MATLAB and before running the first AMIGO task  %
%                 - Whenever the model, observables or experiments for a      %
%                   given example are modified                                %
%                 - Whenever changing the example                             %
%               Paths will be added at any AMIGO session so as user does not  %
%               need to modify the MATLAB path                                %
%               Note that folders keeping problem results will be created     %
%               under the Results folder (unless otherwise specified)         %
%               All problem related files (inputs, outputs and intermediate   %
%               files) will be kept in such folder.                           %
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_Prep.m 2305 2015-11-25 08:20:26Z evabalsa $
%Checks for necessary arguments
if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end

%tmp_dir = cd;
%AMIGO_PE header
AMIGO_report_header

fprintf(1,'\n\n------>Pre processing....this may take a few seconds.\n');

%Starts Check of inputs
fprintf(1,'\n\n------>Checking inputs....\n');

%Reads defaults
[inputs_def]= AMIGO_private_defaults;

%[inputs_def, results_def]= AMIGO_public_defaults(inputs_def);
[inputs_def]= AMIGO_public_defaults(inputs_def);


%Reads inputs
[inputs,results]=AMIGO_check_model(input_file,inputs_def);%,results_def

[inputs]=AMIGO_check_nlp_options(inputs);

switch inputs.model.input_model_type
    case {'charmodelF','charmodelM','charmodelC'}
        [inputs]=AMIGO_check_customnames(inputs);
end

%DETECTS PATH
AMIGO_path


% symbolic computations:
if inputs.model.AMIGOjac > 0 || inputs.model.AMIGOsensrhs > 0
    
     disp('-->Jacobian or sensitivity calculation detected. Checking the Symbolic Toolbox.')
%     disp('Symbolic toolbox information:')
    v = ver('Symbolic');
%     disp(v);
    
    if str2double(v.Version(1)) < 4
        inputs.symver = 'old';
    else
        inputs.symver = 'new';
    end
    
end

if inputs.model.AMIGOjac
    if strcmp(inputs.symver,'old')
        fprintf('--> WARNING: The analytic Jacobian computation requires version(Symbolic Toolbox) >= 4.0.\n\t inputs.model.AMIGOjac = 0\n')
        inputs.model.AMIGOjac = 0;
    else   
        inputs = AMIGO_jacobian(inputs);  
    end
end

if inputs.model.AMIGOsensrhs
    if strcmp(inputs.symver,'old')  
        fprintf('--> WARNING: The analytic Forward Sensitivity Equations computation requires version(Symbolic Toolbox) >= 4.0.\n\t inputs.model.AMIGOsensrhs = 0\n')
        % disp('Old version of Symbolic Toolbox is detected.')
        % inputs = AMIGO_sensRHS2008(inputs);
        inputs.model.AMIGOsensrhs = 0;
    else
        % disp('New version of Symbolic Toolbox is detected.');
        inputs = AMIGO_sensRHS(inputs);
    end
end



%Generates output folder
privstruct=inputs.exps;

results.pathd.problem_folder_path=fullfile(...
    inputs.pathd.AMIGO_path,results.pathd.results_path,results.pathd.results_folder);

if ~isdir(results.pathd.problem_folder_path)
    mkdir(results.pathd.problem_folder_path);
    addpath(results.pathd.problem_folder_path);
end

inputs.pathd.problem_folder_path=results.pathd.problem_folder_path;
%Generates model
inputs=AMIGO_gen_model(inputs,results);


if inputs.model.shownetwork
    AMIGO_ShowNetwork(inputs);
end



if size(dir('*.i'))>0
    delete *.i
end

fprintf(1,'\n\n------>Files generated....\n');
%cd(tmp_dir);
end