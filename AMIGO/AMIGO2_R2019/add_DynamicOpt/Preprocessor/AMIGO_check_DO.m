

function [inputs,privstruct]= AMIGO_check_DO(input_file,inputs_def)
% AMIGO_check_do: Checks model and model solver user supplied information for DO 
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
%  AMIGO_check_do: Checks model and model solver user supplied information    %
%                                                                             %
%*****************************************************************************%
    
%
%   Assignments 
%


    inputs.model=inputs_def.model;
    inputs.exps=inputs_def.exps;
    inputs.ivpsol=inputs_def.ivpsol;
    inputs.PEsol=inputs_def.PEsol;
    inputs.nlpsol=inputs_def.nlpsol;
    inputs.DOsol=inputs_def.DOsol;
    inputs.plotd=inputs_def.plotd;
    inputs.pathd=inputs_def.pathd;
    inputs.OEDsol=inputs_def.OEDsol;


%
%   Reads input file
%
%   EBC: 07Nov2014 -- modifications to allow to input structure
%
if(ischar(input_file))
    % is the name of the script.
    
    if exist(input_file,'file')~= 2
        fprintf(1, 'The input file you selected %s could not be found in the AMIGO path...\n',input_file);
        error('\n Stopping.\n')
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
    
    

    

%
%   Starts checking inputs 
%

%   -----------------------------------------------------------------------------------------------------------------
%   OUTPUT RELATED DATA 
% 
    
%
%   Results_folder to keep all output files
%



   if(size(inputs.pathd.results_folder)==size(inputs_def.pathd.results_folder))
     switch inputs.pathd.results_folder
         case inputs_def.pathd.results_folder
      fprintf(1,'\t\tProblem folder has not been provided. Default: %s',inputs_def.pathd.results_folder);    
      pause(2); end; end    

%
%   Problem short name
%
    if(size(inputs.pathd.short_name)==size(inputs_def.pathd.short_name))
     switch inputs.pathd.short_name
         case inputs_def.pathd.short_name
       fprintf(1,'\n\n------> WARNING message\n\n');  
       fprintf(1,'\t\tProblem short name has not been provided. Default: %', inputs_def.short_name);    
       pause(2); end; end    


%   -----------------------------------------------------------------------------------------------------------------
%   MODEL RELATED DATA 
%  
    

%
%  CHECK FOR PARAMETERS (Note that for D0 parameters may not be explicitly
%  declared, this test verifies if there are declared parameters and if
%  not, declares defaults, to proceed with conventional AMIGO functions for
%  simulation)
%

if inputs.model.n_par==0
    inputs.model.n_par=1;
    inputs.model.par_names=char('dummy');
    inputs.model.par=[0];
end

  switch inputs.model.input_model_type
        
    %%%% TEST CHAR TYPE MODELS. THIS INCLUDES TEST OF inputs.model.names_type
        case 'charmodelM'
                 inputs.model.matlabmodel_file=strcat('fcn_',inputs.pathd.short_name);
                         
        case {'charmodelC','charmodelF','charmodelM'}

                if(isempty(inputs.model.n_st)==1) || (isempty(inputs.model.n_stimulus)==1)
                fprintf(1,'\n\n------> ERROR message\n\n'); 
                fprintf(1,'\t\tYou must indicate number of state variables and stimuli the input file.');
                error('error_model_002','\t\t Impossible to continue. Stopping.\n');
                end    

                if(size(inputs.model.eqns,1)<1)
                fprintf(1,'\n\n------> ERROR message\n\n'); 
                fprintf('\t\tYou must introduce the ODEs in the input file.');
                error('error_model_003','\t\t Impossible to continue. Stopping.\n');
                end; 
    
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
            inputs.ivpsol.senssolver='fdsens';
        
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
        case 'sbmlmodel'
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
        
            if exist(strcat(inputs.model.sbmlmodel_file,'.xml')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tYou have selected to use a sbml model.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.sbmlmodel_file,'.xml'));
            error('error_model_007b','\t\t Impossible to continue. Stopping.\n');
            end      
            
            AMIGO_check_names
   %%%% TEST FORTRAN MODEL      
            
        case 'fortranmodel'    
            if(isempty(inputs.model.n_st)==1) || (isempty(inputs.model.n_par)==1) || (isempty(inputs.model.n_stimulus)==1)
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\tYou must indicate number of state variables, stimuli and pars in the input file.');
            error('error_model_002','\t\t Impossible to continue. Stopping.\n');
            end    
            
            if(size(inputs.model.fortranmodel_file,1)<1)    
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tYou have selected to use a fortran model.');
            fprintf('\t\tYou must introduce the name of the corresponding file: inputs.model.fortranmodel_file.');
            error('error_model_008a','\t\t Impossible to continue. Stopping.\n');
            end
        
            if exist(strcat(inputs.model.fortranmodel_file,'.f')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tYou have selected to use a fortran model.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.fortranmodel_file,'.f'));
            error('error_model_008b','\t\t Impossible to continue. Stopping.\n');
            end
            
            if(size(inputs.model.fortransens_file,1)<1)    
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tYou have selected to use a fortran model.');
            fprintf('\t\tYou must introduce the name of the corresponding file: inputs.model.fortranmodel_file.');
            error('error_model_008a','\t\t Impossible to continue. Stopping.\n');
            end
        
            if exist(strcat(inputs.model.fortransens_file,'.f')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tYou have selected to use a fortran model.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.fortransens_file,'.f'));
            error('error_model_008b','\t\t Impossible to continue. Stopping.\n');
            end
            AMIGO_check_names
        
   %%%% TEST BLACK BOX COST  
        case 'blackboxcost'    
            inputs.ivpsol.ivpsolver='blackboxcost';
            if(size(inputs.model.blackboxcost_file,1)<1)    
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tYou have selected to use a black box cost function.');
            fprintf('\t\tYou must introduce the name of the corresponding file: inputs.model.blackboxcost_file.');
            error('error_model_009a','\t\t Impossible to continue. Stopping.\n');
            end
        
            if exist(strcat(inputs.model.blackboxcost_file,'.xml')) ~= 2
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tYou have selected to use a black box cost function.');
            fprintf('\t\tThe file %s has not been found. It should be in the AMIGO path.', strcat(inputs.model.blackboxcost_file,'.m'));
            error('error_model_009b','\t\t Impossible to continue. Stopping.\n');
            end
            AMIGO_check_names
                
    otherwise    
        
            fprintf(1,'The type of model you selected [%s] is not available.',inputs.model.input_model_type);
            fprintf(1,'\n\tPlease select from the list: charmodelC, charmodelM,charmodelF, fortranmodel, matlabmodel, sbmlmodel, blackboxmodel, blackboxcost.');    
            error('error_model_001','\t\t Impossible to continue. Stopping.\n');   
        
        
end %   switch inputs.model.input_model_type



%   -----------------------------------------------------------------------------------------------------------------
%    ODE SOLVER RELATED DATA                                     
%
    AMIGO_check_IVPsolver
%   -----------------------------------------------------------------------------------------------------------------

%   -----------------------------------------------------------------------------------------------------------------
%  EXPERIMENTAL SCHEME RELATED DATA
%
    inputs.exps.n_exp=1;                                  %Number of experiments 
    inputs.exps.exp_y0{1}=inputs.DOsol.y0;             %Initial conditions for each experiment
    inputs.exps.t_f{1}=inputs.DOsol.tf_guess; 
    inputs.exps.u{1}=inputs.DOsol.u_guess;
    inputs.exps.u_max{1}=inputs.DOsol.u_max;
    inputs.exps.u_min{1}=inputs.DOsol.u_min;
    inputs.exps.t_con{1}= inputs.DOsol.t_con;     
    inputs.exps.u_interp{1}=inputs.DOsol.u_interp;
    inputs.exps.n_pulses{1}=inputs.DOsol.n_pulses;
    inputs.exps.n_steps{1}=inputs.DOsol.n_steps;
    inputs.exps.n_linear{1}=inputs.DOsol.n_linear;
    inputs.exps.n_s{1}=inputs.plotd.n_t_plot;
    inputs.exps.index_observables{1}=[1:1:inputs.model.n_st];
    
    

    
    
 %   ----------------------------------------------------------------------------------------------------------------
       
    privstruct=inputs.exps;
    privstruct.y_0{1}=inputs.exps.exp_y0{1};
    
    if inputs.model.n_par>0
    privstruct.par{1}=inputs.model.par;
    else
    privstruct.par{1}=[0];
    end

return


