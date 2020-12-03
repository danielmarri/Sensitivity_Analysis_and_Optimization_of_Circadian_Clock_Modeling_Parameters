% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_model.m 2410 2015-12-07 13:58:57Z evabalsa $
function [inputs,results]= AMIGO_check_model(input_file,inputs_def,results)
%function [inputs,results]= AMIGO_check_model(input_file,inputs_def,results_def)
% AMIGO_check_model: Checks model and model solver user supplied information
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
%  AMIGO_check_model: Checks model and model solver user supplied information %
%                                                                             %
%*****************************************************************************%


%Assignments
inputs.model=inputs_def.model;
inputs.exps=inputs_def.exps;
inputs.ivpsol=inputs_def.ivpsol;
inputs.PEsol=inputs_def.PEsol;
inputs.nlpsol=inputs_def.nlpsol;
inputs.rank=inputs_def.rank;
inputs.rid=inputs_def.rid;
inputs.OEDsol=inputs_def.OEDsol;
inputs.DOsol=inputs_def.DOsol;
inputs.IOCsol=inputs_def.IOCsol;
inputs.pathd = inputs_def.pathd;
inputs.plotd = inputs_def.plotd;
inputs.input_file = inputs_def.input_file;
inputs.save_results = inputs_def.save_results;
inputs.randstate=[];


%Reads input file
if(ischar(input_file))
    % is the name of the script.
    
    if exist(input_file,'file')~= 2
            cprintf('*red','\n\n------> ERROR message\n\n');
            cprintf('red','\t\t The input file you selected %s could not be found in the AMIGO path...\n\n');
            return;
      end
    
    %evaluate the script
 
    eval(sprintf(input_file));
      
    % move the content of the results struct to the inputs struct
    if exist('results','var')   % user defined results in the input script
        
        warning('AMIGO_check_model: Please declare "pathd" and "plotd" as part of the inputs struct. Their use as part of the results struct will be discontinued in the next version of AMIGO.');
        
        if isfield(results,'pathd')
            
            inputs.pathd = results.pathd;
            
        end
        
        if isfield(results,'plotd')
            
            inputs.plotd = results.plotd;
            
        end
    end
    
  
    
elseif isstruct(input_file) % input is a structure

    inputs = AMIGO_merge_struct(inputs, input_file,'inputs');
    %inputs = input_file;
    
    if isfield(input_file,'exps') % For DO inputs.exps is not declared in the inputs struct
    fn = fieldnames(input_file.exps);
    
    for j = 1:numel(fn)
        if iscell(input_file.exps.(fn{j}))  %% check only cell arrays
        
            for iexp = 1: input_file.exps.n_exp
                 if length(input_file.exps.(fn{j}))<iexp || isempty(input_file.exps.(fn{j}){iexp})
                    inputs.exps.(fn{j}){iexp} = inputs_def.exps.(fn{j}){iexp};
                end
            end

        end
    end

    end
    
    
else error('Input must be a filename or a structure.');
    
end






% check the inputs has the pathd and plotd, otherwise fill with defaults
if ~isfield(inputs,'pathd')
    
    warning('Please declare "pathd" and as part of the inputs struct. Its declaration as part of the results struct will be discontinued in the next version of AMIGO.');
    inputs.pathd = inputs_def.pathd; %results_def.pathd;
    
end

if ~isfield(inputs,'plotd')
    
    warning('Please declare "plotd" as part of the inputs struct. Its declaration as part of the results struct will be discontinued in the next version of AMIGO.');
    inputs.plotd = inputs_def.plotd;%results_def.plotd;
    
end

% fill the missing fields with the default values:
inputs.pathd = AMIGO_merge_struct(inputs_def.pathd, inputs.pathd,'inputs.pathd');
inputs.plotd = AMIGO_merge_struct(inputs_def.plotd, inputs.plotd,'inputs.plotd');
% inputs.pathd = AMIGO_merge_struct(results_def.pathd, inputs.pathd,'inputs.pathd');
% inputs.plotd = AMIGO_merge_struct(results_def.plotd, inputs.plotd,'inputs.plotd');

% check figure titles
if isempty(inputs.plotd.data_plot_title)
    inputs.plotd.data_plot_title = inputs.pathd.short_name;
end




% create the result struct from the defaults and from the inputs.
% results = results_def;
results.pathd = inputs.pathd;
results.plotd = inputs.plotd;


%[inputs,results]=feval(input_file,inputs,results);
if(ischar(input_file))
    
    inputs.input_file=input_file;
    
end

%Starts checking inputs
%-----------------------------------------------------------------------------------------------------------------

%OUTPUT RELATED DATA

%Results_folder to keep all output files

if(size(results.pathd.results_folder)==size(inputs_def.pathd.results_folder))
    
    switch results.pathd.results_folder
        
        case inputs_def.pathd.results_folder %results_def.pathd.results_folder
            
            fprintf(1,'\t\tProblem folder has not been provided. Default: %s\n',inputs_def.pathd.results_folder);
            pause(2);
    end
end


if(ischar(input_file))
    %Problem short name
    if(size(results.pathd.short_name)==size(inputs_def.pathd.short_name))
        switch results.pathd.short_name
            
            case inputs_def.pathd.short_name
                fprintf(1,'\n\n------> WARNING message\n\n');
                fprintf(1,'\t\tProblem short name has not been provided. Default: %s', inputs_def.pathd.short_name);
                pause(2);
        end
    end
end


% EBC: gives priority to command line run identifier

if ischar(inputs.pathd.runident_cl)
    inputs.pathd.runident=inputs.pathd.runident_cl;
end

%----------------------------------------------------------------------------------------------------------------
%MODEL RELATED DATA

if(~isfield(inputs.model,'input_model_type'))
    inputs.model.input_model_type='charmodelM';
    inputs.ivpsol.ivpsolver='ode15s';
    warning('AMIGO_check_model: You have not specified inputs.model.input_model_type . charmodelM will be assumed');
end




switch inputs.model.input_model_type
    
    %%%% TEST CHAR TYPE MODELS. THIS INCLUDES TEST OF inputs.model.names_type
    case 'charmodelM'
        
        inputs.model.matlabmodel_file=strcat('fcn_',results.pathd.short_name);
        AMIGO_check_names
        
    case 'charmodelF'
        
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\t FROTRAN models are no longer supported, please update your input file.');
        error('\t\t Impossible to continue. Stopping.\n');
        
    case  'charmodelC'
        
        if(isempty(inputs.model.n_st) || isempty(inputs.model.n_par) || isempty(inputs.model.n_stimulus))
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf(1,'\t\tYou must indicate number of state variables, stimuli and pars in the input file.');
            error('error_model_002','\t\t Impossible to continue. Stopping.\n');
        end
        AMIGO_check_names
        
        %%%% TEST BLACK BOX MODEL
        
    case 'blackboxmodel'
        
        if(isempty(inputs.model.n_st)==1) || (isempty(inputs.model.n_par)==1) || (isempty(inputs.model.n_stimulus)==1)
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf(1,'\t\tYou must indicate number of state variables, stimuli and pars in the input file.');
            error('error_model_002','\t\t Impossible to continue. Stopping.\n');
        end
        
        inputs.ivpsol.ivpsolver='blackboxmodel';  % This corresponds to a .m file with
        % user integration
        if isempty(inputs.ivpsol.senssolver)
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\tYou must indicate the type of finite differences scheme to compute sensitivities for blackboxmodel.\n');
            fprintf(1,'\t\tBy default: fdsens5\n');
            inputs.ivpsol.senssolver='fdsens5';
        end
        if(size(inputs.model.blackboxmodel_file,1)<1)
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a black box model.');
            fprintf('\t\tYou must introduce the name of the corresponding file: inputs.model.blackboxmodel_file.');
            error('error_model_005a','\t\t Impossible to continue. Stopping.\n');
        end
        if exist(strcat(inputs.model.blackboxmodel_file,'.m')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a black box model.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.blackboxmodel_file,'.m'));
            error('error_model_005b','\t\t Impossible to continue. Stopping.\n');
        end
        
        AMIGO_check_names
        
        %%%% TEST MATLAB MODEL
        
    case 'matlabmodel'
        
        if(isempty(inputs.model.n_st)==1) || (isempty(inputs.model.n_par)==1) || (isempty(inputs.model.n_stimulus)==1)
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf(1,'\t\tYou must indicate number of state variables, stimuli and pars in the input file.');
            error('error_model_002','\t\t Impossible to continue. Stopping.\n');
        end
        
        if(size(inputs.model.matlabmodel_file,1)<1)
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a model in matlab.');
            fprintf('\t\tYou must introduce the name of the corresponding file: inputs.model.matlabmodel_file.');
            error('error_model_006a','\t\t Impossible to continue. Stopping.\n');
        end
        
        if exist(strcat(inputs.model.matlabmodel_file,'.m')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a model in matlab.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.matlabmodel_file,'.m'));
            error('error_model_006b','\t\t Impossible to continue. Stopping.\n');
        end
        AMIGO_check_names
        
        %%%% TEST sbml MODEL
    case {'sbmlmodel','sbmlmodelM'}
        
        if(isempty(inputs.model.n_st)==1) || (isempty(inputs.model.n_par)==1) || (isempty(inputs.model.n_stimulus)==1)
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf(1,'\t\tYou must indicate number of state variables, stimuli and pars in the input file.');
            error('error_model_002','\t\t Impossible to continue. Stopping.\n');
        end
        
        if(size(inputs.model.sbmlmodel_file,1)<1)
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a sbml model.');
            fprintf('\t\tYou must introduce the name of the corresponding file: inputs.model.sbmlmodel_file.');
            error('error_model_007a','\t\t Impossible to continue. Stopping.\n');
        end
        
     
        strcat(inputs.model.sbmlmodel_file,'.xml')
        
        if exist(strcat(inputs.model.sbmlmodel_file,'.xml')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a sbml model.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.sbmlmodel_file,'.xml'));
            error('error_model_007b','\t\t Impossible to continue. Stopping.\n');
        end
        
        AMIGO_check_names
        %%%% TEST FORTRAN MODEL
        
    case 'fortranmodel'
        
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\t FROTRAN models are no longer supported, please provide a C file or MATLAB.');
        error('\t\t Impossible to continue. Stopping.\n');
        
        %%%% TEST BLACK BOX COST
    case 'blackboxcost'
        
        inputs.ivpsol.ivpsolver='blackboxcost';
        if(size(inputs.model.blackboxcost_file,1)<1)
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a black box cost function.');
            fprintf('\t\tYou must introduce the name of the corresponding file: inputs.model.blackboxcost_file.');
            error('error_model_009a','\t\t Impossible to continue. Stopping.\n');
        end
        
        if exist(strcat(inputs.model.blackboxcost_file,'.m')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected to use a black box cost function.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.blackboxcost_file,'.m'));
            error('error_model_009b','\t\t Impossible to continue. Stopping.\n');
        end
        AMIGO_check_names
        
    otherwise
        
        fprintf(1,'The type of model you selected [%s] is not available.',inputs.model.input_model_type);
        fprintf(1,'\n\tPlease select from the list: charmodelM,charmodelF, fortranmodel, matlabmodel, sbmlmodel, sbmlmodelM, blackboxmodel, blackboxcost.');
        error('error_model_001','\t\t Impossible to continue. Stopping.\n');
        
        
end %   switch inputs.model.input_model_type

if ~isfield(inputs.model,'J')
    inputs.model.J={};
end

% test dynamic state-constraints related inputs
if isfield(inputs.model,'st_max') && ~isempty(inputs.model.st_max)
    if numel(inputs.model.st_max) == 1
        inputs.model.st_max = repmat(inputs.model.st_max,1,inputs.model.n_st);
    else
        assert(numel(inputs.model.st_max) == inputs.model.n_st);
    end
end
if isfield(inputs.model,'st_min') && ~isempty(inputs.model.st_min)
    if numel(inputs.model.st_min) == 1
        inputs.model.st_min = repmat(inputs.model.st_min,1,inputs.model.n_st);
    else
        assert(numel(inputs.model.st_min) == inputs.model.n_st);
    end
end


if(~isfield(inputs.model,'exe_type') || isempty(inputs.model.exe_type))
    fprintf('------> WARNING message\n\n\t\t AMIGO_check_model: You did not specify inputs.model.exe_type, standard will be assumed\n\n');
    inputs.model.exe_type='standard';
end

AMIGO_path;

results.pathd.problem_folder_path=strcat(...
    inputs.pathd.AMIGO_path,...
    filesep,results.pathd.results_path,...
    filesep,...
    results.pathd.results_folder...
    );


if(strcmp(inputs.model.exe_type,'costMex') || strcmp(inputs.model.exe_type,'fullMex')  || strcmp(inputs.model.exe_type,'fullC'))
    [inputs results] = AMIGO_check_costFullMex(inputs,results);
end


%-----------------------------------------------------------------------------------------------------------------
%ODE SOLVER RELATED DATA

AMIGO_check_IVPsolver

%-----------------------------------------------------------------------------------------------------------------

return;



