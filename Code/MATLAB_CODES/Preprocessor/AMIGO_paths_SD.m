% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_paths_SD.m 2487 2016-02-23 14:01:49Z evabalsa $
% AMIGO_paths_SO: Generates and adds necessary paths for SData
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
%  AMIGO_paths_SD: Generates and adds necessary paths for reports and plots   % 
%                                                                             %
%*****************************************************************************%

                
        inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);
        inputs.pathd.task_folder=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder,filesep,'SData_',inputs.pathd.short_name,'_',inputs.pathd.runident);  
        AMIGO_check_runident
        inputs.pathd.task_folder=strcat(inputs.pathd.problem_folder_path,filesep,'SData_',inputs.pathd.short_name,'_',run_ident); 
        try
        mkdir(fullfile(inputs.pathd.AMIGO_path,inputs.pathd.task_folder));
        catch
        warning('AMIGO_paths_SD: Could not create the results folder');
        end
        inputs.pathd.data_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.data_plot);
        inputs.pathd.residuals_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.residuals_plot);
        AMIGO_paths_alltasks
        addpath([inputs.pathd.AMIGO_path filesep inputs.pathd.problem_folder_path]);%
        
        
