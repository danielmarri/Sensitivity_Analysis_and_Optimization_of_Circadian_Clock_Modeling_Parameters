% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_residuals.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_residuals: plots residuals
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
% AMIGO_plot_residuals: plots residuals, i.e. differences between model       %
%                       predictions and experimental data at each sampling    %
%                       point for every observable and experiment             %
%                                                                             %
%*****************************************************************************%

  for iexp=1:inputs.exps.n_exp
 
        file_index=num2str(iexp);    
        residuals_plot_path_=strcat(inputs.pathd.residuals_plot_path,file_index); 
        icolor=1;  
         if inputs.exps.n_obs{iexp}==1
            figure    
            iobs=1;
            plot(inputs.exps.t_s{iexp},results.fit.rel_residuals{iexp}(:,iobs),'color',plot_colors(icolor,:),'LineWidth',1)
            hold on
            plot(inputs.exps.t_s{iexp},0.0.*[1:1:inputs.exps.n_s{iexp}],'k-.','LineWidth',1)
            xlabel('Time'); ylabel('Relative residuals in %');
            if  numel(inputs.exps.obs_names{iexp})>=1
            plot_title=['Residuals for ', inputs.exps.obs_names{iexp}(iobs,:), ' ; exp: ', mat2str(iexp)];
%            legend boxoff   
            else   
            plot_title=strcat('Residuals for obs: ', mat2str(iobs), '; exp: ', mat2str(iexp));    
%            legend boxoff   
            end
            axis tight
            title(plot_title);    
            % Keeps the .fig file
            if inputs.plotd.figsave
            saveas(gcf, residuals_plot_path_, 'fig');
            end
            % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', residuals_plot_path_); end
 
 
         else
      
         n_max_plots=min([inputs.exps.n_obs{iexp} inputs.plotd.number_max_obs]);
         n_rows=ceil(n_max_plots/2);
         n_figs=ceil(inputs.exps.n_obs{iexp}/n_max_plots);
 
            for ifig=1:n_figs
            figure
            %size subplot
            rows_subplot=max([n_rows ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)]);    
            n_end_loop=min([inputs.exps.n_obs{iexp} ifig*n_max_plots]);
               for iobs=(ifig-1)*n_max_plots+1:n_end_loop
                if iobs<inputs.exps.n_obs{iexp}
                plot_loc=(iobs-(ifig-1)*n_max_plots);
                else
                plot_loc=inputs.exps.n_obs{iexp}-((n_figs-1)*n_max_plots);
                end
     
            subplot(rows_subplot,2,plot_loc)
  
            plot(inputs.exps.t_s{iexp},results.fit.rel_residuals{iexp}(:,iobs),'color',plot_colors(icolor,:),'LineWidth',1)
            hold on
            plot(inputs.exps.t_s{iexp},0.0.*[1:1:inputs.exps.n_s{iexp}],'k-.','LineWidth',1)
            xlabel('Time');
            ylabel('Relative residuals in %');
            plot_title=strcat('Residuals Observable: ', mat2str(iobs), '; experiment: ', mat2str(iexp));
   
            if  numel(inputs.exps.obs_names{iexp})>=1
            plot_title=strcat('Residuals: ', inputs.exps.obs_names{iexp}(iobs,:), '; exp: ', mat2str(iexp));
            else   
            plot_title=strcat('Residuals for obs: ', mat2str(iobs), '; exp: ', mat2str(iexp));    
            end   
            axis tight
            title(plot_title);
        icolor=icolor+1;
        if icolor==201
        icolor=1;
        end
        
        
            end % for iobs=1:inputs.exps.n_obs{iexp}
   
            % Keeps the .fig file
            if ifig>1
            file_index=num2str(ifig);    
            file_exp=num2str(iexp);
            residuals_file_path_fig=strcat(inputs.pathd.residuals_plot_path,'_exp',file_exp,'_',file_index); 
            else
            file_exp=num2str(iexp);
            residuals_file_path_fig=strcat(inputs.pathd.residuals_plot_path,'_exp',file_exp);     
            end
            if inputs.plotd.figsave
            saveas(gcf, residuals_file_path_fig, 'fig');
            end
          % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', residuals_file_path_fig);end
         

       end
   
    end
if rem(iexp,25)==0
    close all
end
end