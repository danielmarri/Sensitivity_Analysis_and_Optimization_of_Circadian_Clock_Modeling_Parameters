% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_sens.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_sens: plots parametric sensitivities vs time
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
%  AMIGO_plot_sens: plots observables parametric relative and absolute        %
%                   sensitivities vs time                                     %   
%                                                                             %
%*****************************************************************************%
 
if privstruct.istate_sens <0
     fprintf(1,'\n\n >>>> An error ocurred when computing sensitivities. Sorry, it is not possible to plot sensitivities.'); 
else


  for iexp=1:inputs.exps.n_exp
      
  n_max_plots=min([inputs.exps.n_obs{iexp} inputs.plotd.number_max_obs]);
  n_rows=ceil(n_max_plots/2);
  n_figs=ceil(inputs.exps.n_obs{iexp}/n_max_plots);

  n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};   
  %%%%% ABSOLUTE SENSITIVITIES
  for ifig=1:n_figs
        figure
      
        if inputs.model.n_stimulus==0
             %size subplot
           rows_subplot=max([n_rows ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)]);    
           icolor=1;
        else   
           %size subplot
           rows_subplot=max([n_rows+1 ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)+1]);
           subplot(rows_subplot,1,1)
           AMIGO_plot_stimulus
           
           
           switch inputs.exps.ts_type{iexp}
               case {'fixed','od'}    
               hold on
               plot(privstruct.t_s{iexp},zeros(privstruct.n_s{iexp}),'rv')
           end           
           
           ist=1;      
           icolor=1;                
        end
        
        n_end_loop=min([inputs.exps.n_obs{iexp} ifig*n_max_plots]);

        for iobs=(ifig-1)*n_max_plots+1:n_end_loop
            if inputs.model.n_stimulus==0
            plot_loc=(iobs-(ifig-1)*n_max_plots);
            else
            if iobs<inputs.exps.n_obs{iexp}
            plot_loc=2+(iobs-(ifig-1)*n_max_plots);
            else
            plot_loc=2+inputs.exps.n_obs{iexp}-((n_figs-1)*n_max_plots);
            end
            end
            subplot(rows_subplot,2,plot_loc)   
            
            plot(privstruct.t_s{iexp},reshape(results.rank.sens_t{iexp}(:,iobs,:),privstruct.n_s{iexp},n_theta),'LineWidth',1)
            axis tight
            xlabel('Time');
            if  numel(inputs.exps.obs_names{iexp})>=1   
            %title(strcat('Absolute sensitivities vs time.', inputs.exps.obs_names{iexp}(iobs,:), ' Exp: ',mat2str(iexp)));
            title(['Abs sensitivities vs time: ', inputs.exps.obs_names{iexp}(iobs,:),', exp: ' , mat2str(iexp)]);
            else
             title(strcat('Abs sensitivities vs time, Obs:', mat2str(iobs)));    
            end %if numel(inputs.exps.obs_names{iexp}))>=1   
            axis tight           
 
       end % for iobs=1:inputs.exps.n_obs{iexp}
        
        % Keeps the .fig file
           
            file_index=num2str(ifig);   
            file_exp=num2str(iexp);
            sens_file_path_fig=strcat(inputs.pathd.sens_time_path,'_abs_exp',file_exp,'_',file_index);

            saveas(gcf, sens_file_path_fig, 'fig');
        % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', sens_file_path_fig);end
        
            
        end   %   for ifig=1:n_figs  
    
        
        %%% RELATIVE SENSITIVITIES
        figure
    for ifig=1:n_figs

      
        if inputs.model.n_stimulus==0
             %size subplot
           rows_subplot=max([n_rows ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)]);    
           icolor=1;
        else   
           %size subplot
           rows_subplot=max([n_rows+1 ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)+1]);
           subplot(rows_subplot,1,1)
           AMIGO_plot_stimulus
           
           
           switch inputs.exps.ts_type{iexp}
               case {'fixed','od'}    
               hold on
               plot(privstruct.t_s{iexp},zeros(privstruct.n_s{iexp}),'rv')
           end           
           
           ist=1;      
           icolor=1;                
        end
        
        n_end_loop=min([inputs.exps.n_obs{iexp} ifig*n_max_plots]);

        for iobs=(ifig-1)*n_max_plots+1:n_end_loop
        
            if inputs.model.n_stimulus==0
            plot_loc=(iobs-(ifig-1)*n_max_plots);
            else
            if iobs<inputs.exps.n_obs{iexp}
            plot_loc=2+(iobs-(ifig-1)*n_max_plots);
            else
            plot_loc=2+inputs.exps.n_obs{iexp}-((n_figs-1)*n_max_plots);
            end
            end
            subplot(rows_subplot,2,plot_loc)   
            plot(privstruct.t_s{iexp},reshape(results.rank.r_sens_t{iexp}(:,iobs,:),privstruct.n_s{iexp},n_theta),'LineWidth',1)
            axis tight
            xlabel('Time');
            if  numel(inputs.exps.obs_names{iexp})>=1   
            %title(strcat('Absolute sensitivities vs time.', inputs.exps.obs_names{iexp}(iobs,:), ' Exp: ',mat2str(iexp)));
            title(['Rel sensitivities vs time: ', inputs.exps.obs_names{iexp}(iobs,:),', exp: ' , mat2str(iexp)]);
            
            else
             title(strcat('Rel sensitivities vs time, Obs:', mat2str(iobs)));    
     
            end
            axis tight           
 
       end % for iobs=1:inputs.exps.n_obs{iexp}
        
        % Keeps the .fig file
           
            file_index=num2str(ifig);   
            file_exp=num2str(iexp);
            sens_file_path_fig=strcat(inputs.pathd.sens_time_path,'_rel_exp',file_exp,'_',file_index);

            saveas(gcf, sens_file_path_fig, 'fig');
        % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', sens_file_path_fig);end
        
            
    end   
        
    if rem(iexp,25)==0
    close all
    end

    
    
    end
    
    

end % if privstruct.istate_sens <0