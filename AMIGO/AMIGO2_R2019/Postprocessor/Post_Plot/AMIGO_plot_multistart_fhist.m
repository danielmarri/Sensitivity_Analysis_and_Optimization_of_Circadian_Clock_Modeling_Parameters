% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_multistart_fhist.m 2086 2015-08-31 07:49:03Z evabalsa $
% AMIGO_plot_multistart_hist: plots fobj multistart results for PE or OED
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
%  AMIGO_plot_multistart_hist: Plots a histogram of solutions achieved by     %
%                              a multistart of a local solver.                %
%                              x-axis: objective function achieved            %
%                              y-axis: frequency of the solutions             %     
%                                                                             %
%*****************************************************************************%

            figure
            
            nbars=ceil(inputs.nlpsol.multi_starts/5);
            hist(results.nlpsol.func_vector_multistart,nbars);
            xlabel('Objective Function Value');
            ylabel('Frequency');
            plot_title=strcat('Histogram of results for the multistart: ',inputs.pathd.results_folder);
            title(plot_title,'interpreter','none');
            % Keeps the .fig file
            saveas(gcf, inputs.pathd.multistart_hist,'fig')
            % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', results.histogram_path); end  
         
         