function AMIGO_plot_obs_vs_data(inputs,results)
% $Header: svn://.../trunk/AMIGO_R2012_cvodes/Postprocessor/Post_Plot/AMIGO_plot_obs_plus_data.m 1813 2014-07-14 14:53:39Z attila $
% AMIGO_plot_plus_data: plots observables vs time plus experimental data
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
% AMIGO_plot_plus_data: plots observables vs time together with the           %
%                        experimental data                                    %
%                                                                             %
%*****************************************************************************%

AMIGO_plot_colors;

for iexp=1:inputs.exps.n_exp
    plot_title={inputs.plotd.data_plot_title,sprintf('observed vs predicted data (exp:%d )',iexp)};
    %plot_title={results.pathd.short_name,['experiment: ',mat2str(iexp)]};
    n_max_plots=min([inputs.exps.n_obs{iexp} inputs.plotd.number_max_obs]);
    n_rows=ceil(n_max_plots/2);
    n_figs=ceil(inputs.exps.n_obs{iexp}/n_max_plots);
    icolor=1;
    for ifig=1:n_figs
        
        figure();
        rows_subplot=max([n_rows ceil((inputs.exps.n_obs{iexp}-(n_figs-1)*n_max_plots)/2)]);
        
        n_end_loop=min([inputs.exps.n_obs{iexp} ifig*n_max_plots]);
        
        
        if inputs.exps.n_obs{iexp}==1
            plot(results.sim.sim_data{iexp}(:),inputs.exps.exp_data{iexp}(:),'.','color',plot_colors(1,:))
            
            hold on
            dmin = min([results.sim.sim_data{iexp}(:); inputs.exps.exp_data{iexp}(:)]);
            dmax = max([results.sim.sim_data{iexp}(:); inputs.exps.exp_data{iexp}(:)]);
            plot([dmin dmax], [dmin dmax],'--','color',[.8 .8 .8],'Linewidth',2)
            
            axis tight
            xlabel(['pred. ' inputs.exps.obs_names{iexp}(1,:)])
            ylabel(['measured. ' inputs.exps.obs_names{iexp}(1,:)])
             title(plot_title,'interpreter','none');

        else
               
            for iobs=(ifig-1)*n_max_plots+1:n_end_loop
                
                
                plot_loc=(iobs-(ifig-1)*n_max_plots);
                
                subplot(rows_subplot,2,plot_loc)
                
                plot(results.sim.sim_data{iexp}(:,iobs),inputs.exps.exp_data{iexp}(:,iobs),'.','color',plot_colors(icolor,:))
                
                hold on
                dmin = min([results.sim.sim_data{iexp}(:,iobs); inputs.exps.exp_data{iexp}(:,iobs)]);
                dmax = max([results.sim.sim_data{iexp}(:,iobs); inputs.exps.exp_data{iexp}(:,iobs)]);
                plot([dmin dmax], [dmin dmax],'--','color',[.8 .8 .8],'Linewidth',2)
                
                axis tight
                xlabel(['pred. ' inputs.exps.obs_names{iexp}(iobs,:)])
                ylabel(['measured ' inputs.exps.obs_names{iexp}(iobs,:)])
                
                
                icolor=icolor+1;
                if icolor==201
                    icolor=1;
                end
            end
            % Create a supertitle for the subplots if there is no stimuli
            if inputs.model.n_stimulus==0
                % create the title
                set(gcf,'NextPlot','add');
                axes('Position',[0.4  0.92  0.2  1e-6]);
                %plot_title=strcat(results.pathd.short_name,' ; experiment: ',mat2str(iexp));
                h = title(plot_title,'interpreter','none');
                set(gca,'Visible','off');
                set(h,'Visible','on');
            end
        end % for iobs=1:inputs.exps.n_obs{iexp}
        
        
        % Keeps the .fig file
        if ifig>1
            file_index=num2str(ifig);
            file_exp=num2str(iexp);
            pred_vs_obs_path=strcat(inputs.pathd.pred_vs_obs_path,'_exp',file_exp,'_',file_index);
            
        else
            file_exp=num2str(iexp);
            pred_vs_obs_path=strcat(inputs.pathd.pred_vs_obs_path,'_exp',file_exp);
            
        end
        if inputs.plotd.figsave
            saveas(gcf, pred_vs_obs_path, 'fig');
        end
        % Saves a .eps color figure
        if inputs.plotd.epssave==1;
            print( gcf, '-depsc', pred_vs_obs_path); end
        
        
    end %for ifig=1:n_figs
    
    
    if rem(iexp,25)==0
        close all
    end
end %  for iexp=1:inputs.exps.n_exp



%% Plots the overall distribution

sim = [];
meas = [];
for iexp=1:inputs.exps.n_exp
   sim = [sim; results.sim.sim_data{iexp}(:)];
   meas = [meas; inputs.exps.exp_data{iexp}(:)];
end

figure()
plot(log10(abs(meas)),log10(abs(sim)),'o')
xlabel('Measured data (log10)')
ylabel('Predicted data (log10)')

pred_vs_obs_path=strcat(inputs.pathd.pred_vs_obs_path,'_all');
if inputs.plotd.figsave
    saveas(gcf, pred_vs_obs_path, 'fig');
end
% Saves a .eps color figure
if inputs.plotd.epssave==1;
    print( gcf, '-depsc', pred_vs_obs_path);
end



sim_err= (sim-meas);
id = (sim_err == 0);
sim_err(id)=[];
sim(id)=[];
meas(id)=[];

figure()
[n,xout] = hist(log10(abs(sim_err./meas)));
bar(xout,n)
xlabel('rel. error in data prediction (log10)')
ylabel('frequency')

pred_vs_obs_path=strcat(inputs.pathd.pred_vs_obs_path,'_hist_all');
if inputs.plotd.figsave
    saveas(gcf, pred_vs_obs_path, 'fig');
end
% Saves a .eps color figure
if inputs.plotd.epssave==1;
    print( gcf, '-depsc', pred_vs_obs_path);
end
