% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_paths_GR.m 2487 2016-02-23 14:01:49Z evabalsa $
% AMIGO_paths_GR: Generates and adds necessary paths for LRank
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
%  AMIGO_paths_GR: Generates and adds necessary paths for reports and plots   % 
%                                                                             %
%*****************************************************************************%


        inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);
        inputs.pathd.task_folder=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder,filesep,'GRank_',inputs.pathd.short_name,'_',inputs.pathd.runident);  
        AMIGO_check_runident
        inputs.pathd.task_folder=strcat(inputs.pathd.problem_folder_path,filesep,'GRank_',inputs.pathd.short_name,'_',run_ident); 
        mkdir(inputs.pathd.AMIGO_path,inputs.pathd.task_folder);
        inputs.pathd.global_ranking_pars=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'GRank');
        inputs.pathd.sens_time_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'senst');
        inputs.pathd.sens_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'sens');
        inputs.pathd.obs_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.obs_plot);
        AMIGO_paths_alltasks
        addpath([inputs.pathd.AMIGO_path filesep inputs.pathd.problem_folder_path]);%
