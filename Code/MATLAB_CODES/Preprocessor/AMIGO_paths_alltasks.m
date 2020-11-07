% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_paths_alltasks.m 2086 2015-08-31 07:49:03Z evabalsa $
% AMIGO_paths_alltasks: Generates and adds necessary paths for all tasks
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
%  AMIGO_paths_alltasks: Generates and adds necessary paths for reports and   %
%                        plots                                                %
%                                                                             %
%*****************************************************************************%


inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);

if(strcmp(inputs.model.input_model_type,'fullC') || strcmp(inputs.model.input_model_type,'costMex') || strcmp(inputs.model.input_model_type,'fullMex'))
    inputs.pathd.obs_function=[];
else
    inputs.pathd.obs_function=strcat('AMIGO_gen_obs_',inputs.pathd.short_name);
    if inputs.exps.NLObs
        inputs.pathd.obs_sens_function = strcat('AMIGO_gen_obs_sens_',inputs.pathd.short_name);
    end
end


inputs.pathd.obs_file=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path,filesep,inputs.pathd.obs_function,'.m');
inputs.pathd.report=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.pathd.report_name,'_',inputs.pathd.short_name,'_',run_ident,'.m');
inputs.pathd.struct_results=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.pathd.struct_name,'_',inputs.pathd.short_name,'_',run_ident,'.mat');

if isfield(inputs,'input_file')
    if (~isempty(inputs.input_file) && ischar(inputs.input_file)) && ischar(input_file)
      
        inputs.pathd.input_file=strcat(inputs.pathd.AMIGO_path,...
            filesep,...
            inputs.pathd.task_folder,...
            filesep,inputs.input_file,...
            '_','input_',...
            run_ident,'.m');
        
        copyfile(which(strcat(input_file,'.m')),inputs.pathd.input_file,'f');
        
    end
end

%  Keeps copy of the input file in the output directory

clear run_ident;


