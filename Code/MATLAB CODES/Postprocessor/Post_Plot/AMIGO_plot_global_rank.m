% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_global_rank.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_global_rank: plots global ranking of parameters
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
%   AMIGO_plot_global_rank: plots all measures of global relative and         %
%                           absolute ranking of parameters in decreasing      %
%                           order of the msqr value                           %                             
%                                                                             %
%*****************************************************************************%
      
         figure
         subplot(1,2,1)
         plot(results.rank.global_par_rank_mat,'-o','LineWidth',1)
         legend('global d_{msqr}','global d_{mabs}','global d_{mean}','global d_{max}','global d_{min}');
         if numel(inputs.model.par_names)==0 
          xtick_par=strcat('\theta_',num2str(inputs.index_theta(1)));  
          for ipar=2:inputs.PEsol.n_global_theta    
          xtick_par=char(xtick_par,strcat('\theta_',num2str(inputs.index_theta(ipar))));
          end    
         set(gca,'XTick',1:1:inputs.PEsol.n_global_theta,'XTickLabel',xtick_par);
         else
         xticklabel= inputs.model.par_names(inputs.PEsol.index_global_theta(results.rank.global_par_rank_index(:,1)),:)';   
         set(gca,'XTick',1:1:inputs.PEsol.n_global_theta,'XTickLabel',xticklabel');
         end    
         xlabel('Parameters ordered by decreasing global d_{msqr}');
         title('Global full ranking of parameters.');
%  
         subplot(1,2,2) 
         plot(results.rank.r_global_par_rank_mat,'-o','LineWidth',1)
         legend('global rd_{msqr}','global rd_{mabs}','global rd_{mean}','global rd_{max}','global rd_{min}');
         if numel(inputs.model.par_names)==0  
          xtick_par=strcat('\theta_',num2str(inputs.index_theta(1)));  
          for ipar=2:inputs.PEsol.n_global_theta    
          xtick_par=char(xtick_par,strcat('\theta_',num2str(inputs.index_theta(ipar))));
          end    
         set(gca,'XTick',1:1:inputs.PEsol.n_global_theta,'XTickLabel',xtick_par);
         else
         xticklabel= inputs.model.par_names(inputs.PEsol.index_global_theta(results.rank.r_global_par_rank_index(:,1)),:)';   
         set(gca,'XTick',1:1:inputs.PEsol.n_global_theta,'XTickLabel',xticklabel');
         end  
         xlabel('Parameters ordered by decreasing global rd_{msqr}');
         title('Global relative ranking of parameters.');
%        

%        
%        Keeps the .fig file
         saveas(gcf, inputs.pathd.global_ranking_pars, 'fig')
%        Saves a .eps color figure
        if inputs.plotd.epssave==1;
         print( gcf, '-depsc', inputs.pathd.global_ranking_pars); end;