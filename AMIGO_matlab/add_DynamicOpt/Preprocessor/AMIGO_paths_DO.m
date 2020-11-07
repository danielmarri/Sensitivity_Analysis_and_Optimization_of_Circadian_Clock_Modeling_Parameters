% $Header: svn://.../trunk/AMIGO_R2012_cvodes/add_DynamicOpt/Preprocessor/AMIGO_paths_OD.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_paths_OD: Generates and adds necessary paths for OD
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
%  AMIGO_paths_OD: Generates and adds necessary paths for reports and plots   % 
%                                                                             %
%*****************************************************************************%


      
        inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);
        inputs.pathd.task_folder=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder,filesep,'DO_',inputs.pathd.short_name,'_',privstruct.nlpsolver,'_',inputs.pathd.runident);  
        AMIGO_check_runident
        inputs.pathd.task_folder=strcat(inputs.pathd.problem_folder_path,filesep,'DO_',inputs.pathd.short_name,'_',privstruct.nlpsolver,'_',run_ident); 
        mkdir(inputs.pathd.AMIGO_path,inputs.pathd.task_folder); 
        inputs.pathd.multistart_hist=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.multistart_hist);
        inputs.pathd.conv_curve_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.convergence_curve);
        inputs.pathd.states_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.states_plot);
        inputs.pathd.u_plot=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.u_plot);
        inputs.pathd.pareto_plot=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.pareto_plot);
        AMIGO_paths_alltasks

       
       