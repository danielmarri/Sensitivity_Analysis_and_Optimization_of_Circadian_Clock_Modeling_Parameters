% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_local_obs_msqr_rank.m 2196 2015-09-23 13:57:54Z evabalsa $

% AMIGO_plot_local_obs_msqr_rank: plots local msqr rank per experiment
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
%   AMIGO_plot_local_obs_msqr_rank: plots local msqr rank for the different   %
%                              observables per experiment                     %
%                              There are two types of plots: 3D bars and      %
%                              the corresponding 2D projections               %                                   
%                                                                             %
%*****************************************************************************%
    
    
if privstruct.istate_sens>0

            
    % Computes maximum and minimum values to fix axes
    for iexp=1:inputs.exps.n_exp
    vect_min(iexp)=min(results.rank.d_obs_msqr{iexp}(:));
    vect_max(iexp)=max(results.rank.d_obs_msqr{iexp}(:));
    vect_r_min(iexp)=min(results.rank.r_d_obs_msqr{iexp}(:));
    vect_r_max(iexp)=max(results.rank.r_d_obs_msqr{iexp}(:));
    end
    v_min=min(vect_min);
    v_max=max(vect_max);
    v_r_min=min(vect_r_min);
    v_r_max=max(vect_r_max);
    
    % 3D FIGURE absolute msqr rank 
    
    for iexp=1:inputs.exps.n_exp
         sensmat=results.rank.d_obs_msqr{iexp};   
         plot_title=strcat('MSQR sensitivity analysis. Experiment:  ',num2str(iexp));        
         sens_path_fig=strcat(inputs.pathd.sens_path,'_lmsqr_exp',num2str(iexp));
         
         AMIGO_plot_sens_bars    
                  
  % PROJECTION FIGURE ABSOLUTE msqr rank    
        
         n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
         n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};
  
         sensmat=zeros(inputs.exps.n_obs{iexp}+1,n_theta+n_theta_y0+1);
         sensmat(1:inputs.exps.n_obs{iexp},1:n_theta+n_theta_y0)=results.rank.d_obs_msqr{iexp};         
         plot_title=strcat('MSQR Absolute sensitivity analysis. Experiment:  ',num2str(iexp));
         sens_path_fig=strcat(inputs.pathd.sens_path,'_2D_lmsqr_exp',num2str(iexp));

         if n_theta+n_theta_y0>1
         AMIGO_plot_sens_2d     
         end
         
         
if rem(iexp,25)==0
    close all
end
    end
           
     % 3D FIGURE relative msqr rank
     for iexp=1:inputs.exps.n_exp
             
         sensmat=results.rank.r_d_obs_msqr{iexp};       
         plot_title=strcat('MSQR Relative sensitivity analysis. Experiment:  ',num2str(iexp));
         sens_path_fig=strcat(inputs.pathd.sens_path,'_rel_lmsqr_exp',num2str(iexp));
         
         if n_theta>1 || n_theta_y0>1
         AMIGO_plot_sens_bars 
         end
         n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
         n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};
         
  % PROJECTION FIGURE RELATIVE msqr rank    
        
         sensmat=zeros(inputs.exps.n_obs{iexp}+1,n_theta+n_theta_y0+1);
         sensmat(1:inputs.exps.n_obs{iexp},1:n_theta+n_theta_y0)=results.rank.r_d_obs_msqr{iexp};         
         plot_title=strcat('MSQR Relative sensitivity analysis. Experiment:  ',num2str(iexp));
         sens_path_fig=strcat(inputs.pathd.sens_path,'_2D_rel_lmsqr_exp',num2str(iexp));
         if n_theta>1 || n_theta_y0>1
         AMIGO_plot_sens_2d     
         end
         
         
if rem(iexp,25)==0
    close all
end
     end %iexp=1:inputs.exps.n_exp
    
  
 end