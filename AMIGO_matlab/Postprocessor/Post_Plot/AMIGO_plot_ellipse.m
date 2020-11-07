% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_ellipse.m 770 2013-08-06 09:41:45Z attila $
function  AMIGO_plot_ellipse(major_axis,minor_axis,mux0,muy0,phi,lineformat)
% AMIGO_draw_ellipse: Draws ellipses for the robust identifiability analysis
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
%  AMIGO_plot_ellipse:Draws ellipses for the robust identifiability           %
%                     analysis. Input parameters are computed from the        %
%                     analysis of the "cloud" of solutions in the             %
%                     Monte-Carlo based method                                %
%                     major_axis and minor_axis correspond to the major       %
%                     and minor_axis respectively                             %
%                     mux0 and muy0 correspond to the coordinates of the      %
%                     center 
%                     phi is the angle between x axis and the major axis      %
%                     lineformat is the plotted line style                    %
%                                                                             %
%*****************************************************************************%

alpha = [-0.03:0.01:2*pi];

 x = major_axis*cos(alpha);
 y = minor_axis*sin(alpha);

 X = cos(phi)*x - sin(phi)*y;
 Y = sin(phi)*x + cos(phi)*y;
 X = X + mux0;
 Y = Y + muy0;

 hEllipse=plot(X,Y,lineformat);
 set(hEllipse,'LineWidth',2)
 axis equal;