% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_global_obs_mean_rank.m 770 2013-08-06 09:41:45Z attila $

% AMIGO_plot_global_obs_mean_rank: plots global msqt rank per experiment
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
%   AMIGO_plot_global_obs_rank: plots global mean rank for the different      %
%                               observables per experiment                    %
%                               There are two types of plots: 3D bars and     %
%                               the corresponding 2D projections              %                                   
%                                                                             %
%*****************************************************************************%
    
%if privstruct.istate_sens>0

    
    % Computes maximum and minimum values to fix axes
    for iexp=1:inputs.exps.n_exp
    vect_min(iexp)=min(results.rank.g_d_obs_msqr_mat{iexp}(:));
    vect_max(iexp)=max(results.rank.g_d_obs_msqr_mat{iexp}(:));
    vect_r_min(iexp)=min(results.rank.g_r_d_obs_msqr_mat{iexp}(:));
    vect_r_max(iexp)=max(results.rank.g_r_d_obs_msqr_mat{iexp}(:));
    end
    v_min=min(vect_min);
    v_max=max(vect_max);
    v_r_min=min(vect_r_min);
    v_r_max=max(vect_r_max);
    
    % 3D FIGURE global absolute MEAN rank 
    
    for iexp=1:inputs.exps.n_exp
         sensmat=results.rank.g_d_obs_mean_mat{iexp};   
         plot_title=strcat('GLOBAL MEAN sensitivity analysis. Experiment:  ',mat2str(iexp));        
         file_exp=num2str(iexp);
         sens_path_fig=strcat(inputs.pathd.sens_path,'_gmean_exp',file_exp);
         AMIGO_plot_sens_bars     
         
if rem(iexp,25)==0
    close all
end
    end
           
     % 3D FIGURE global relative MEAN rank
     for iexp=1:inputs.exps.n_exp
             
         sensmat=results.rank.g_r_d_obs_mean_mat{iexp};       
         plot_title=strcat('GLOBAL MEAN Relative sensitivity analysis. Experiment:  ',mat2str(iexp));
         file_exp=num2str(iexp);
         sens_path_fig=strcat(inputs.pathd.sens_path,'_rel_gmean_exp',file_exp);
         AMIGO_plot_sens_bars 
         
         
     % PROJECTION FIGURE global RELATIVE MEAN rank    
           
         n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
         n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};  
         sensmat=zeros(inputs.exps.n_obs{iexp}+1,n_theta+n_theta_y0+1);
         sensmat(1:inputs.exps.n_obs{iexp},1:n_theta+n_theta_y0)=results.rank.g_r_d_obs_mean_mat{iexp};         
         plot_title=strcat('GLOBAL MEAN Relative sensitivity analysis. Experiment:  ',mat2str(iexp));
         file_exp=num2str(iexp);
         sens_path_fig=strcat(inputs.pathd.sens_path,'_2D_rel_gmean_exp',file_exp);
         AMIGO_plot_sens_2d      
         
if rem(iexp,25)==0
    close all
end
                 
     end
            
     
     
 %end %privstruct.istate_sens>0       