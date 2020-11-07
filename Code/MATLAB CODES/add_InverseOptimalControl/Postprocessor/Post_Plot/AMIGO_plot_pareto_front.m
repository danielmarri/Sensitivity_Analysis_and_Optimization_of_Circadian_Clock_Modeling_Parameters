% AMIGO_plot_pareto_front: plots pareto front in multiobjective opt
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
% AMIGO_plot_pareto_front: plots pareto front in multiobjective opt           %
%                                                                             %
%*****************************************************************************%

            figure
            switch inputs.DOsol.DOcost_type
                case 'min'    
                plot(results.nlpsol.pareto_obj(:,1),results.nlpsol.pareto_obj(:,2),'o')
                case 'max'
                plot(abs(results.nlpsol.pareto_obj(:,1)),abs(results.nlpsol.pareto_obj(:,2)),'o')
            end
            xlabel(inputs.DOsol.DOcost{1});
            ylabel(inputs.DOsol.DOcost{2});  
            plot_title=strcat('Pareto front');
            title(plot_title);
        % Keeps the .fig file
            saveas(gcf, inputs.pathd.pareto_plot, 'fig')
        % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc',  inputs.pathd.pareto_plot); end;