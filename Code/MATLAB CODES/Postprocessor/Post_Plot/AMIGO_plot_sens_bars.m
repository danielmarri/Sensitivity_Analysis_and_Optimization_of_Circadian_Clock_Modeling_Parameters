% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_sens_bars.m 2203 2015-09-24 07:11:27Z evabalsa $
 
         
         index_theta=[inputs.PEsol.index_global_theta inputs.PEsol.index_local_theta{iexp}];
         index_theta_y0=[inputs.PEsol.index_global_theta_y0 inputs.PEsol.index_local_theta_y0{iexp}];
        
         n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
         n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};

% If there is more than one observable, then bar-plots are allowed

if size(sensmat,1)>1
            
         figure
         bar3(sensmat)
         grid on
         
        
         if inputs.PEsol.n_theta_y0==0
            if numel(inputs.model.par_names)==0         
            set(gca,'XTick',1:1:inputs.PEsol.n_theta,'XTickLabel',index_theta);
            else
            xticklabel= inputs.model.par_names(index_theta,:)';   
            set(gca,'XTick',1:1:inputs.PEsol.n_theta,'XTickLabel',xticklabel');
            end; 
         
         else    
         
            if numel(inputs.model.par_names)==0  && numel(inputs.st_names)==0     
            set(gca,'XTick',1:1:inputs.PEsol.n_theta+inputs.PEsol.n_theta_y0,'XTickLabel',[index_theta index_theta_y0]);
            else
            xticklabel= char(inputs.model.par_names(inputs.PEsol.index_global_theta,:),inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:),...
                inputs.model.par_names(inputs.PEsol.index_local_theta{iexp},:),inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp},:));
            set(gca,'XTick',1:1:(n_theta+n_theta_y0),'XTickLabel',xticklabel);
            end;
        end;  % inputs.PEsol.n_theta_y0==0 
         
         
         if numel(inputs.exps.obs_names{iexp})==0         
         set(gca,'YTick',1:1:inputs.exps.n_obs{iexp});
         else
         yticklabel= inputs.exps.obs_names{iexp}';   
         set(gca,'YTick',1:1:inputs.exps.n_obs{iexp},'YTickLabel',yticklabel');
         end  % numel(inputs.exps.obs_names{iexp})==0  
         title(plot_title);       
         saveas(gcf, sens_path_fig, 'fig');
         if results.plotd.epssave==1;
         print( gcf, '-depsc', sens_path_fig);
         end % if results.plotd.epssave==1;
 end %if size(sensmat,1)>1