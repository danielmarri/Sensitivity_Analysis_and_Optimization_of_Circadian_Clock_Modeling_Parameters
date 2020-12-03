% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_post_plot_GR.m 770 2013-08-06 09:41:45Z attila $

function AMIGO_post_plot_GR(inputs,results,privstruct)

% AMIGO_post_plot_GR: plotting results for GRank
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
% AMIGO_post_plot_GR: plotting results for GRank                              %
%                     Plots: - overall rank of parameters as summation of     %
%                              observables and experiments contributios       %
%                            - bars of rank of parameters per experiment      %
%                            - 2D plot of rank of parameters per experiment   %
%                                                                             %
%*****************************************************************************%
 



   switch  inputs.plotd.plotlevel
  
    case 'full' 
    AMIGO_plot_global_rank
    AMIGO_plot_global_obs_msqr_rank
    AMIGO_plot_global_obs_mabs_rank
    AMIGO_plot_global_obs_mean_rank
    
    case 'medium'
    AMIGO_plot_global_rank
    AMIGO_plot_global_obs_msqr_rank
    
    case 'min'    
    AMIGO_plot_global_rank   
    end
  return;