% $Header:  $
% AMIGO_plot_obs_confidence_data: plots observables vs time with confidence plus experimental data
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
% AMIGO_plot_obs_confidence_data: plots observables vs time with confidence plus experimental data                            %
%                                                                             %
%*****************************************************************************%

AMIGO_plot_colors;

for iexp=1:inputs.exps.n_exp
    plot_title = {'Prediction confidence',[inputs.pathd.short_name,sprintf(' (exp. %d)',iexp)]};
    
    n_max_plots=min([inputs.exps.n_obs{iexp} inputs.plotd.number_max_obs]);
    n_rows=ceil(n_max_plots/2);
    n_figs=ceil(inputs.exps.n_obs{iexp}/n_max_plots);
    icolor=1;
    for ifig=1:n_figs
        
        figure
        
        if inputs.model.n_stimulus==0
            %size subplot
            rows_subplot=max([n_rows ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)]);
        else
            %size subplot
            rows_subplot=max([n_rows+1 ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)+1]);
            subplot(rows_subplot,1,1)
            AMIGO_plot_stimulus
            ist=1;
        end
        
        n_end_loop=min([inputs.exps.n_obs{iexp} ifig*n_max_plots]);
        
        
        if inputs.model.n_stimulus==0 && inputs.exps.n_obs{iexp}==1
            
              if ~isempty(results.fit.obs_conf_mat{iexp})
                    % interpolate the simulation for the points where we
                    % computed the confidence interval.
                    signal  = interp1q(results.sim.tsim{iexp}',results.sim.obs{iexp}(:,1),inputs.exps.t_s{iexp}(1:end)');
                    x_coordinates = [inputs.exps.t_s{iexp}(1:end) inputs.exps.t_s{iexp}(end:-1:1)];
              
                    upper = signal+results.fit.obs_conf_mat{iexp}(:,1);
                    lower = signal-results.fit.obs_conf_mat{iexp}(:,1);
                    y_coordinates = [upper;  lower(end:-1:1,:)];
                    grey = [0.8 0.8 0.8];
                    patch(x_coordinates,y_coordinates,grey,'EdgeColor',grey)
                end
                hold on 
            
            
            
            if ~isempty(inputs.exps.error_data{iexp})
                fig2=errorbar(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,1),inputs.exps.error_data{iexp}(:,1),'color',plot_colors(icolor,:),'LineStyle','none','Marker','.');
            else
                fig2=plot(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,1),'color',plot_colors(icolor,:),'LineStyle','none','Marker','.');
            end
            set(fig2,'LineWidth',1)
            hold on
            plot(results.sim.tsim{iexp},results.sim.obs{iexp}(:,1),'color',plot_colors(icolor,:),'LineWidth',1)
            
            axis tight
            xlabel('Time');
            if  numel(inputs.exps.obs_names{iexp})>=1
                hleg1 = legend(inputs.exps.obs_names{iexp}(1,:));
                legend boxoff
                set(hleg1,'Interpreter','none')
            else
                legend('Obs: ',mat2str(1));
                legend boxoff
            end
            %title(plot_title);
            axis tight
            
        elseif inputs.model.n_stimulus>=1 && inputs.exps.n_obs{iexp}==1
            
            subplot(rows_subplot,1,2)
        
             if ~isempty(results.fit.obs_conf_mat{iexp})
                    % interpolate the simulation for the points where we
                    % computed the confidence interval.
                    signal  = interp1q(results.sim.tsim{iexp}',results.sim.obs{iexp}(:,1),inputs.exps.t_s{iexp}(1:end)');
                    x_coordinates = [inputs.exps.t_s{iexp}(1:end) inputs.exps.t_s{iexp}(end:-1:1)];
              
                    upper = signal+results.fit.obs_conf_mat{iexp}(:,1);
                    lower = signal-results.fit.obs_conf_mat{iexp}(:,1);
                    y_coordinates = [upper;  lower(end:-1:1,:)];
                    grey = [0.8 0.8 0.8];
                    patch(x_coordinates,y_coordinates,grey,'EdgeColor',grey)
                end
                hold on          
            
            if inputs.exps.error_data{iexp}
                fig2=errorbar(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,1),inputs.exps.error_data{iexp}(:,1),'color',plot_colors(icolor,:),'LineStyle','none','Marker','.');
            else
                fig2=plot(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,1),'color',plot_colors(icolor,:),'LineStyle','none','Marker','.');
            end
            set(fig2,'LineWidth',1)
            hold on
            plot(results.sim.tsim{iexp},results.sim.obs{iexp}(:,1),'color',plot_colors(icolor,:),'LineWidth',1)
            axis tight
            xlabel('Time');
            

            
            if  numel(inputs.exps.obs_names{iexp})>=1
                hleg1 = legend(inputs.exps.obs_names{iexp}(1,:));
                legend boxoff
                set(hleg1,'Interpreter','none')
            else
                legend('Obs: ',mat2str(1));
                legend boxoff
            end
            %title(plot_title);
            axis tight
            
        else
            
            for iobs=(ifig-1)*n_max_plots+1:n_end_loop
                
                if inputs.model.n_stimulus==0
                    plot_loc=(iobs-(ifig-1)*n_max_plots);
                else
                    if iobs<inputs.exps.n_obs{iexp}
                        plot_loc=2+(iobs-(ifig-1)*n_max_plots);
                    else
                        plot_loc=2+inputs.exps.n_obs{iexp}-((n_figs-1)*n_max_plots);end
                end
                subplot(rows_subplot,2,plot_loc)
                
                if ~isempty(results.fit.obs_conf_mat{iexp})
                    % interpolate the simulation for the points where we
                    % computed the confidence interval.
                    signal  = interp1q(results.sim.tsim{iexp}',results.sim.obs{iexp}(:,iobs),inputs.exps.t_s{iexp}(1:end)');
                    x_coordinates = [inputs.exps.t_s{iexp}(1:end) inputs.exps.t_s{iexp}(end:-1:1)];
              
                    upper = signal+results.fit.obs_conf_mat{iexp}(:,iobs);
                    lower = signal-results.fit.obs_conf_mat{iexp}(:,iobs);
                    y_coordinates = [upper;  lower(end:-1:1,:)];
                    grey = [0.8 0.8 0.8];
                    patch(x_coordinates,y_coordinates,grey,'EdgeColor',grey)
                end
                hold on
                if sum(inputs.exps.error_data{iexp})
                    fig2=errorbar(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,iobs),inputs.exps.error_data{iexp}(:,iobs),'color',plot_colors(icolor,:),'LineStyle','none','Marker','.');
                else
                    fig2=plot(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,iobs),'color',plot_colors(icolor,:),'LineStyle','none','Marker','.');
                end
                set(fig2,'LineWidth',1)
                
                plot(results.sim.tsim{iexp},results.sim.obs{iexp}(:,iobs),'color',plot_colors(icolor,:),'LineWidth',1)
                axis tight
                xlabel('Time');
                if  numel(inputs.exps.obs_names{iexp})>=1
                    hleg1 = legend(fig2,inputs.exps.obs_names{iexp}(iobs,:));
                    legend boxoff
                    set(hleg1,'Interpreter','none');
                else
                    legend('Obs: ',mat2str(iobs));
                    legend boxoff
                end
                %title(plot_title);
                axis tight
                
                icolor=icolor+1;
                if icolor==201
                    icolor=1;
                end
                % Create a supertitle for the subplots if there is no stimuli
                if inputs.model.n_stimulus==0
                    % create the title
                    set(gcf,'NextPlot','add');
                    axes('Position',[0.4  0.92  0.2  1e-6]);
                    %plot_title=strcat(inputs.pathd.short_name,' ; experiment: ',mat2str(iexp));
                    h = title(plot_title,'interpreter','none');
                    set(gca,'Visible','off');
                    set(h,'Visible','on');
                end
            end
            
        end % for iobs=1:inputs.exps.n_obs{iexp}
        
        %         % Keeps the .fig file
        %         if ifig>1
        %             file_index=num2str(ifig);
        %             file_exp=num2str(iexp);
        %             fit_file_path_fig=strcat(fig_plot_path,'_exp',file_exp,'_',file_index);
        %
        %         else
        %             file_exp=num2str(iexp);
        %             fit_file_path_fig=strcat(fig_plot_path,'_exp',file_exp);
        %
        %         end
        %         saveas(gcf, fit_file_path_fig, 'fig');
        %         % Saves a .eps color figure
        %         if inputs.plotd.epssave==1;
        %             print( gcf, '-depsc', fit_file_path_fig); end
        
        
    end %for ifig=1:n_figs
    
    
    if rem(iexp,25)==0
        close all
    end
end %  for iexp=1:inputs.exps.n_exp
