% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_post_plot_SO.m 770 2013-08-06 09:41:45Z attila $

function AMIGO_post_plot_SO(inputs,results,privstruct)

% AMIGO_post_plot_SO: plotting results for SObs
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
% AMIGO_post_plot_SObs: plotting results for SObs                             %
%                     Plots all observables plus experimental data under the  %
%                     given stimulus conditions                               %
%                                                                             %
%*****************************************************************************%

    AMIGO_plot_colors
 
%      
% Keeps some input information in the structure results 
%
  results.t_m=privstruct.t_int;
  fprintf(1,'\n\n------>Plotting results....\n\n');

  AMIGO_plot_obs    
  return;