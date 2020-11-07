% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_post_plot_SD.m 2494 2016-03-01 14:28:42Z evabalsa $

function AMIGO_post_plot_SD(inputs,results,privstruct)

% AMIGO_post_plot_SD: plotting results for SData
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
% AMIGO_post_plot_SD: plotting results for SData                              %
%                     Plots all observables plus experimental data under the  %
%                     given stimulus conditions                               %
%                                                                             %
%*****************************************************************************%
 
%      
% Keeps some input information in the structure results 
%

  fprintf(1,'\n\n------>Plotting results....\n\n');

  AMIGO_plot_obs_plus_data(inputs,results,1)
%  AMIGO_plot_residuals   
  return;