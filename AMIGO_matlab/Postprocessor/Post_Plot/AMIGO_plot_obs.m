% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_obs.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_obs: plots observables vs time
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
%  AMIGO_plot_obs: plots observables vs time                                  %
%                  Several figures may be generated depending on the number   %
%                  of observables                                             %
%                                                                             %
%*****************************************************************************%


for iexp=1:inputs.exps.n_exp
    
    n_max_plots=min([inputs.exps.n_obs{iexp} inputs.plotd.number_max_obs]);
    n_rows=ceil(n_max_plots/2);
    n_figs=ceil(inputs.exps.n_obs{iexp}/n_max_plots);
    
    if inputs.exps.n_obs{iexp}==1
        col_subplot=1;
    else
        col_subplot=2;
    end
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
            
            if isempty(privstruct.t_s{iexp})==0
                switch inputs.exps.ts_type{iexp}
                    case {'fixed','od'}
                        hold on
                        plot(privstruct.t_s{iexp},zeros(privstruct.n_s{iexp}),'rv')
                end
            end
            ist=1;
            
        end
        
        n_end_loop=min([inputs.exps.n_obs{iexp} ifig*n_max_plots]);
        
        if inputs.model.n_stimulus==0 && inputs.exps.n_obs{iexp}==1
            plot(privstruct.t_int{iexp},results.sim.obs{iexp}(:,1),'color',plot_colors(1,:),'LineWidth',1)
            axis tight
            xlabel('Time');
            if  numel(inputs.exps.obs_names{iexp})>=1
                hleg1 = legend(inputs.exps.obs_names{iexp}(1,:));
                legend boxoff
            else
                hleg1 =legend('Obs: ',mat2str(1));
                legend boxoff
            end
            set(hleg1,'Interpreter','none')
            %title(plot_title);
            axis tight
            
        elseif inputs.model.n_stimulus>=1 && inputs.exps.n_obs{iexp}==1
            
            subplot(rows_subplot,1,2)
            plot(privstruct.t_int{iexp},results.sim.obs{iexp}(:,1),'color',plot_colors(1,:),'LineWidth',1)
            axis tight
            xlabel('Time');
            if  numel(inputs.exps.obs_names{iexp})>=1
                hleg1 =legend(inputs.exps.obs_names{iexp}(1,:));
                legend boxoff
            else
                hleg1 =legend('Obs: ',mat2str(1));
                legend boxoff
            end
            %title(plot_title);
            axis tight
            set(hleg1,'Interpreter','none')
        else
            icolor=1;
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
                if privstruct.w_obs{iexp}(1,iobs)>0
                    subplot(rows_subplot,2,plot_loc)
                    
                    plot(privstruct.t_int{iexp},results.sim.obs{iexp}(:,iobs),'color',plot_colors(icolor,:),'LineWidth',1)
                    try
                    axis tight
                    end
                    xlabel('Time');
                    if  numel(inputs.exps.obs_names{iexp})>=1
                        hleg1 = legend(inputs.exps.obs_names{iexp}(iobs,:));
                        legend boxoff
                    else
                        hleg1 = legend('Obs: ',mat2str(iobs));
                        legend boxoff
                    end
                    set(hleg1,'Interpreter','none')
                    %title(plot_title);
                    try
                    axis tight
                    end
                    icolor=icolor+1;
                    if icolor==201
                        icolor=1;
                    end
                    
                end
                
            end % for iobs=1:inputs.exps.n_obs{iexp}
        end
        % Keeps the .fig file
        
        file_index=num2str(ifig);
        file_exp=num2str(iexp);
        obs_file_path_fig=strcat(inputs.pathd.obs_plot_path,'_exp',file_exp,'_',file_index);
        if inputs.plotd.figsave
            saveas(gcf, obs_file_path_fig, 'fig');
        end
        % Saves a .eps color figure
        if inputs.plotd.epssave==1;
            print( gcf, '-depsc', obs_file_path_fig);end
        
        
    end
    
    
    if rem(iexp,25)==0
        close all
    end
end
