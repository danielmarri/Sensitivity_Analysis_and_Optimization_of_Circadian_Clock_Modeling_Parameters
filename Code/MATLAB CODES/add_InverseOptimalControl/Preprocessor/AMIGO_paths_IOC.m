% $Header: svn://.../trunk/AMIGO_R2012_cvodes/add_DynamicOpt/Preprocessor/AMIGO_paths_OD.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_paths_IOC: Generates and adds necessary paths for OD
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
%  AMIGO_paths_IOC: Generates and adds necessary paths for reports and plots   % 
%                                                                             %
%*****************************************************************************%


      
        inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);
        inputs.pathd.task_folder=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder,filesep,'ido_',inputs.pathd.short_name,'_',privstruct.nlpsolver,'_',inputs.pathd.runident);  
        AMIGO_check_runident
        inputs.pathd.task_folder=strcat(inputs.pathd.problem_folder_path,filesep,'ido_',inputs.pathd.short_name,'_',privstruct.nlpsolver,'_',run_ident); 
        mkdir(inputs.pathd.AMIGO_path,inputs.pathd.task_folder); 
        inputs.pathd.multistart_hist=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.multistart_hist);
        inputs.pathd.conv_curve_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.convergence_curve);
        inputs.pathd.states_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.states_plot);
        inputs.pathd.u_plot=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.u_plot);
        inputs.pathd.pareto_plot=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.pareto_plot);
        
        inputs.pathd.residuals_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.residuals_plot);
        inputs.pathd.multistart_hist=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.multistart_hist);
        inputs.pathd.fit_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.fit_plot);
        inputs.pathd.conv_curve_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.convergence_curve);
        inputs.pathd.corr_mat_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'corr_mat');
        inputs.pathd.sens_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'sens');
        inputs.pathd.sens_par_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'sens_theta');
        inputs.pathd.obs_plot_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,inputs.plotd.obs_plot);
        inputs.pathd.sens_mat_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'sens_mat');
        inputs.pathd.sens_mat_clust_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'sens_mat_clust');
        inputs.pathd.pred_vs_obs_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'pred_vs_obs');

        inputs.pathd.pest_vs_pnom_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'pest_vs_pnom');
        inputs.pathd.pest_err_hist_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'pest_err_hist');
        inputs.pathd.pest_pnom_logratio_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'pest_pnom_logratio');
        inputs.pathd.pest_rel_err_hist_path=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.task_folder,filesep,'pest_rel_err_hist');
        
        
        
        
        AMIGO_paths_alltasks

       
       