% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_contours.m 2086 2015-08-31 07:49:03Z evabalsa $
% AMIGO_plot_contours: plots contours for
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
%   AMIGO_plot_contours:    plots contours for one pair of unknowns either    %
%                           parameters or initial conditions                  %
%                                                                             %
%*****************************************************************************%


fprintf(1,'        Generating contour plots for pair %s, %s...\n',xvalue,yvalue);
figure
contour(parx(1,:),pary(1,:),errorxy',30)
title([yvalue,' vs  ',xvalue]);
xlabel(xvalue);
ylabel(yvalue);
% hold on
% plot(theta_conf(:,1),theta_conf(:,2),'.r')
hold on
plot(inputs.PEsol.vtheta_guess(1,index_theta(1,1)), inputs.PEsol.vtheta_guess(1,index_theta(1,2)),'*');


contour_file_path_fig=strcat(inputs.pathd.contour_plot_path,'_',yvalue,'_vs_',xvalue);
if results.plotd.figsave
    saveas(gcf, contour_file_path_fig, 'fig');
end
if results.plotd.epssave==1;
    print( gcf, '-depsc', contour_file_path_fig);    end