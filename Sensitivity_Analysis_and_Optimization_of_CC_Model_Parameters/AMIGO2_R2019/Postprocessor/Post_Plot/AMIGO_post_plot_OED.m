% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_post_plot_OED.m 770 2013-08-06 09:41:45Z attila $

function AMIGO_post_plot_OED(inputs,results,privstruct)

% AMIGO_post_plot_OED: plotting results for OED
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
% AMIGO_post_plot_SD: plotting results for PE                              %
%                     Plots all observables plus experimental data under the  %
%                     given stimulus conditions                               %
%                                                                             %
%*****************************************************************************%

AMIGO_plot_colors
 
%      
% Keeps some input information in the structure results 
%

  fprintf(1,'\n\n------>Plotting results....\n\n');
  results.t_m=privstruct.t_int;
  AMIGO_plot_obs 
        %
        % Plots convergence curve
        %
        switch inputs.nlpsol.nlpsolver
            case 'mglobal'
            fprintf(1,'Sorry, convergence curve plot is not available for MGLOBAL, at the moment\n\n'); 
            case {'local'}
            fprintf(1,'Sorry, convergence curve plot is not available for local solvers, at the moment\n\n');          
            case {'multistart'}
            AMIGO_plot_multistart_fhist
            AMIGO_plot_multistart_thetahist
            otherwise
            figure
            plot(results.nlpsol.conv_curve(:,1),results.nlpsol.conv_curve(:,2))
            xlabel('CPU time (s)');
            ylabel('Objective function');  
            plot_title=strcat('Convergence curve: ',inputs.nlpsol.nlpsolver,' ; ',inputs.pathd.results_folder);
            title(plot_title);
        % Keeps the .fig file
            saveas(gcf, inputs.pathd.conv_curve_path, 'fig')
        % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', inputs.pathd.conv_curve_path); end;
        end; 
     
     if privstruct.istate_sens>0   
     AMIGO_plot_correlationmat
     end