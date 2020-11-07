% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_local_rank.m 2196 2015-09-23 13:57:54Z evabalsa $
% AMIGO_plot_local_rank: plots local ranking of parameters
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
%   AMIGO_plot_local_rank: plots all measures of local relative and           %
%                          absolute ranking of parameters in decreasing       %
%                          order of the msqr value                            %
%                                                                             %
%*****************************************************************************%


if privstruct.istate_sens>0
    
    
    index_theta=[inputs.PEsol.index_global_theta ];
    if inputs.PEsol.n_global_theta<=1
        fprintf(1,'\n\n------> WARNING message\n\n');
        fprintf(1,'\t\tOverall ranking plots are available for more than one unknown parameter\n');
    end
    
    
    if inputs.PEsol.n_global_theta>=2 && inputs.PEsol.n_global_theta<=30
        
        figure
        subplot(1,2,1)
        plot(results.rank.sorted_over_par_rank_mat,'-o','LineWidth',1)
        legend('d_{msqr}','d_{mabs}','d_{mean}','d_{max}','d_{min}');
        
        if numel(inputs.model.par_names)==0
          xtick_par=strcat('\theta_',num2str(inputs.index_theta(1)));  
          for ipar=2:inputs.PEsol.n_global_theta    
          xtick_par=char(xtick_par,strcat('\theta_',num2str(inputs.index_theta(ipar))));
          end 
          set(gca,'XTick',1:1:inputs.PEsol.n_global_theta ,'XTickLabel',xtick_par);
        else
            xticklabel= inputs.model.par_names(index_theta(results.rank.over_par_rank_index(:,1)),:)';
            set(gca,'XTick',1:1:inputs.PEsol.n_global_theta,'XTickLabel',xticklabel');
        end
        xlabel('Parameters ordered by decreasing d_{msqr}');
        title('Full local ranking: (Global) Parameters ');
        
        subplot(1,2,2)
        plot(results.rank.r_sorted_over_par_rank_mat,'-o','LineWidth',1)
        legend('rd_{msqr}','rd_{mabs}','rd_{mean}','rd_{max}','rd_{min}');
        if numel(inputs.model.par_names)==0
             xtick_par=strcat('\theta_',num2str(inputs.index_theta(1)));  
             for ipar=2:inputs.PEsol.n_global_theta    
             xtick_par=char(xtick_par,strcat('\theta_',num2str(inputs.index_theta(ipar))));
             end 
            set(gca,'XTick',1:1:inputs.PEsol.n_global_theta ,'XTickLabel',xtick_par);
        else
            xticklabel= inputs.model.par_names(index_theta(results.rank.r_over_par_rank_index(:,1)),:)';
            set(gca,'XTick',1:1:inputs.PEsol.n_global_theta,'XTickLabel',xticklabel');
        end
        xlabel('Parameters ordered by decreasing rd_{msqr}');
        title('Relative local ranking: (Global) Parameters ');
        
        % Keeps the .fig file
        saveas(gcf, inputs.pathd.ranking_pars, 'fig')
        % Saves a .eps color figure
        print( gcf, '-depsc', inputs.pathd.ranking_pars)
    end %if inputs.PEsol.n_global_theta>=2 && inputs.PEsol.n_global_theta<=30
    
    
    % INITIAL CONDITIONS
    
    if inputs.PEsol.n_global_theta_y0<=1
        fprintf(1,'\n\n------> WARNING message\n\n');
        fprintf(1,'\t\t Overall ranking plots are available for more than one unknown initial condition\n');
    end
    if inputs.PEsol.n_global_theta_y0>=2
        index_theta_y0=[inputs.PEsol.index_global_theta_y0 ];
        figure
        subplot(1,2,1)
        plot(results.rank.sorted_over_y0_rank_mat,'-o','LineWidth',1)
        legend('d_{msqr}','d_{mabs}','d_{mean}','d_{max}','d_{min}');
        
        if numel(inputs.model.st_names)==0
          xtick_y0=strcat('\thetay_',num2str(index_theta_y0(1)));  
          for iy0=2:inputs.PEsol.n_global_theta_y0   
          xtick_y0=char(xtick_par,strcat('\thetay_',num2str(index_theta_y0(iy0))));
          end        
          set(gca,'XTick',1:1:inputs.PEsol.n_global_theta_y0,'XTickLabel',xtick_y0);
        else
            xticklabel= inputs.model.st_names(index_theta_y0(results.rank.over_y0_rank_index(:,1)),:)';
            set(gca,'XTick',1:1:inputs.PEsol.n_global_theta_y0,'XTickLabel',xticklabel');
        end
        xlabel('Initial conditions ordered by decreasing d_{msqr}');
        title('Full local ranking:(Global) initial conditions ');
        
        subplot(1,2,2)
        plot(results.rank.r_sorted_over_y0_rank_mat,'-o','LineWidth',1)
        legend('rd_{msqr}','rd_{mabs}','rd_{mean}','rd_{max}','rd_{min}');
        if numel(inputs.model.st_names)==0
          xtick_y0=strcat('\thetay_',num2str(index_theta_y0(1)));  
          for iy0=2:inputs.PEsol.n_global_theta_y0   
          xtick_y0=char(xtick_par,strcat('\thetay_',num2str(index_theta_y0(iy0))));
          end  
            set(gca,'XTick',1:1:inputs.PEsol.n_theta_y0,'XTickLabel',xtick_y0);
        else
            xticklabel= inputs.model.st_names(index_theta_y0(results.rank.r_over_y0_rank_index(:,1)),:)';
            set(gca,'XTick',1:1:inputs.PEsol.n_global_theta_y0,'XTickLabel',xticklabel');
        end
        xlabel('Initial conditions ordered by decreasing rd_{msqr}');
        title('Relative local ranking: (Global) initial conditions ');
        
        % Keeps the .fig file
        saveas(gcf, inputs.pathd.ranking_y0, 'fig')
        % Saves a .eps color figure
        if inputs.plotd.epssave==1;
            print( gcf, '-depsc', inputs.pathd.ranking_y0); end
    end %if inputs.PEsol.n_global_theta>=2 && inputs.PEsol.n_global_theta<=25
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FOR LARGE SCALE MODELS, Absolute ranking and relative ranking
    % are plot in different figures
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ABSOLUTE RANKING
    if inputs.PEsol.n_global_theta>30
        
        % Number of plots by default is 5
        npar_per_figure=ceil(inputs.PEsol.n_global_theta/5);
        
        if npar_per_figure<30
            n_lrank_plots=ceil(inputs.PEsol.n_global_theta/30);
        else %npar_per_figure>=30
            n_lrank_plots=ceil(inputs.PEsol.n_global_theta/30);
            npar_per_figure=30;
        end
        
        n_lrank_fig=ceil(n_lrank_plots/4);
        
        figure
        jpar=1;
        index_par=[1:1:npar_per_figure];
        for iplot=1:n_lrank_plots
            subplot(n_lrank_plots,1,iplot)
            
            plot(results.rank.sorted_over_par_rank_mat(index_par,1:5),'-o','LineWidth',1)
            legend('d_{msqr}','d_{mabs}','d_{mean}','d_{max}','d_{min}');
            
            if numel(inputs.model.par_names)==0
                xtick_par=strcat('\theta_',num2str(inputs.index_theta(1)));  
                for ipar=2:inputs.PEsol.n_global_theta    
                xtick_par=char(xtick_par,strcat('\theta_',num2str(inputs.index_theta(ipar))));
                end
                set(gca,'XTick',1:1:size(index_par,2),'XTickLabel',xtick_par);
            else
                xticklabel= inputs.model.par_names(index_theta(results.rank.over_par_rank_index(index_par,1)),:)';
                set(gca,'XTick',1:1:size(index_par,2),'XTickLabel',xticklabel');
            end
            xlabel('Parameters ordered by decreasing d_{msqr}');
            title(strcat('Full ABSOLUTE local ranking: (Global) Parameters - ', num2str(iplot)));
            last_index=max(index_par);
            next_index=min(last_index+npar_per_figure,inputs.PEsol.n_global_theta);
            index_par=[last_index+1:1:next_index];
            
        end %for iplot=1:n_lrank_plots
        
        
        % Keeps the .fig file
        saveas(gcf, strcat(inputs.pathd.ranking_pars,'abs'), 'fig')
        % Saves a .eps color figure
        if inputs.plotd.epssave==1;
            print( gcf, '-depsc', strcat(inputs.pathd.ranking_pars,'abs'))
        end
        
        % RELATIVE RANKING
        
        figure
        jpar=1;
        index_par=[1:1:npar_per_figure];
        for iplot=1:n_lrank_plots
            subplot(n_lrank_plots,1,iplot)
            
            plot(results.rank.r_sorted_over_par_rank_mat(index_par,1:5),'-o','LineWidth',1)
            legend('d_{msqr}','d_{mabs}','d_{mean}','d_{max}','d_{min}');
            
            if numel(inputs.model.par_names)==0
                xtick_par=strcat('\theta_',num2str(inputs.index_theta(1)));  
                for ipar=2:inputs.PEsol.n_global_theta    
                xtick_par=char(xtick_par,strcat('\theta_',num2str(inputs.index_theta(ipar))));
                end
                set(gca,'XTick',1:1:size(index_par,2),'XTickLabel',xtick_par);
            else
                xticklabel= inputs.model.par_names(index_theta(results.rank.r_over_par_rank_index(index_par,1)),:)';
                set(gca,'XTick',1:1:size(index_par,2),'XTickLabel',xticklabel');
            end
            xlabel('Parameters ordered by decreasing d_{msqr}');
            title(strcat('Full RELATIVE local ranking: (Global) Parameters - ', num2str(iplot)));
            last_index=max(index_par);
            next_index=min(last_index+npar_per_figure,inputs.PEsol.n_global_theta);
            index_par=[last_index+1:1:next_index];
            
        end %for iplot=1:n_lrank_plots
        
        
        % Keeps the .fig file
        saveas(gcf, strcat(inputs.pathd.ranking_pars,'rel'), 'fig')
        % Saves a .eps color figure
        if inputs.plotd.epssave==1;
            print( gcf, '-depsc', strcat(inputs.pathd.ranking_pars,'rel'))
        end
        
        
        
    end %inputs.PEsol.n_global_theta>25
    
    
    
    
    
    
    
end