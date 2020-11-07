% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_conv_curve.m 2062 2015-08-24 13:13:34Z attila $
% AMIGO_plot_conv_curve: plots convergence curve for the selected NLP solver
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
% AMIGO_plot_conv_curve: plots convergence curve for the selected NLP solver  %
%                                                                             %
%*****************************************************************************%

switch inputs.nlpsol.nlpsolver
    case 'mglobal'
        fprintf(1,'Sorry, convergence curve plot is not available for MGLOBAL, at the moment\n\n');
    case {'local'}
        fprintf(1,'Sorry, convergence curve plot is not available for local solvers, at the moment\n\n');
    case {'multistart'}
        AMIGO_plot_multistart_fhist
        AMIGO_plot_multistart_thetahist
    case{'hybrid'}
        fprintf(1,'Sorry, at the moment, convergence curve plot is not available for local solvers\n');
        fprintf(1,'convergence curve plot for the global is depicted.\n');
        figure
        plot(results.nlpsol.conv_curve(:,1),results.nlpsol.conv_curve(:,2))
        xlabel('CPU time (s)');
        ylabel('Objective function');
        plot_title=strcat('Convergence curve for global phase: ',inputs.nlpsol.nlpsolver,' ; ',inputs.pathd.short_name);
        title(plot_title);
        % Keeps the .fig file
        if inputs.plotd.figsave
            saveas(gcf, inputs.pathd.conv_curve_path, 'fig')
        end
        % Saves a .eps color figure
        if inputs.plotd.epssave==1;
            print( gcf, '-depsc', inputs.pathd.conv_curve_path); end;
    otherwise
        
        if ~isempty(results.nlpsol.conv_curve)
            
            figure
            stairs(results.nlpsol.conv_curve(:,1),results.nlpsol.conv_curve(:,2),'.-')
            xlabel('CPU time (s)');
            ylabel('Objective function');
            plot_title={strcat('Convergence curve: ',inputs.nlpsol.nlpsolver) ,inputs.pathd.short_name};
            title(plot_title,'interpreter','none');
            set(gca,'yscale','log','xscale','log')
            
            % Keeps the .fig file
            if inputs.plotd.figsave
                saveas(gcf, [inputs.pathd.conv_curve_path '_CPU'], 'fig')
            end
            % Saves a .eps color figure
            if inputs.plotd.epssave==1;
                print( gcf, '-depsc', [inputs.pathd.conv_curve_path '_CPU']);
            end;
            
            if isfield(results.nlpsol,'neval')
                figure
                stairs(results.nlpsol.neval,results.nlpsol.conv_curve(:,2),'.-')
                xlabel('Number of function evaluations');
                ylabel('Objective function');
                plot_title={strcat('Convergence curve: ',inputs.nlpsol.nlpsolver) ,inputs.pathd.short_name};
                title(plot_title,'interpreter','none');
                set(gca,'yscale','log','xscale','log')
                
                % Keeps the .fig file
                if inputs.plotd.figsave
                    saveas(gcf, [inputs.pathd.conv_curve_path  '_NFUN'], 'fig')
                end
                % Saves a .eps color figure
                if inputs.plotd.epssave==1;
                    print( gcf, '-depsc', [inputs.pathd.conv_curve_path  '_NFUN']);
                end;
            end
        else
            fprintf(1,'Sorry, convergence curve plot is not available for this solver\n\n');
        end
        
end;