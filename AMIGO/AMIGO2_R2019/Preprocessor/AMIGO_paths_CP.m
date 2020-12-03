% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_paths_CP.m 2487 2016-02-23 14:01:49Z evabalsa $
% AMIGO_paths_CP: Generates and adds necessary paths for ContourP
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
%  AMIGO_paths_CP: Generates and adds necessary paths for reports and plots   % 
%                                                                             %
%*****************************************************************************%


        inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);
        inputs.pathd.task_folder=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder,filesep,'Contours_',inputs.pathd.short_name,'_',inputs.pathd.runident); 
        AMIGO_check_runident
        inputs.pathd.task_folder=strcat(inputs.pathd.problem_folder_path,filesep,'Contours_',inputs.pathd.short_name,'_',run_ident); 
        mkdir(inputs.pathd.AMIGO_path,inputs.pathd.task_folder);
        inputs.pathd.contour_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.contour_plot);
        inputs.pathd.contour1D_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.contour1D_plot);
        AMIGO_paths_alltasks
        addpath([inputs.pathd.AMIGO_path filesep inputs.pathd.problem_folder_path]);%