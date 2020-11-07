% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_post_plot_RI.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_post_plot_RI: plots related to the MC based identifiability
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
%  AMIGO_post_plot_RI:         Plots Monte-Carlo based confidence             %
%                              ellipses by pairs of parameters: "cloud" of    %
%                              solutions together with the corresponding      %
%                              ellipse                                        %
%                              Histograms corresponding to the confidence     %
%                              regions or expected uncertainties of the       %
%                              parameters                                     %
%                                                                             %
%                              Plots are saved in .fig and .eps formats       %
%*****************************************************************************%
    

    AMIGO_plot_clouds
    AMIGO_plot_rconf
    AMIGO_plot_ecc    
    
