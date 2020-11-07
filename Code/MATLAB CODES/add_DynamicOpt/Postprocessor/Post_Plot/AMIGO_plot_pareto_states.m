% AMIGO_plot_pareto_states: plots all states in the model vs time
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
% AMIGO_plot_pareto_states: plots all states in the model vs time             %
%                    Several figures may be generated depending on the number %
%                    of states                                                %
%                                                                             %
%*****************************************************************************%

  n_max_plots=min([inputs.model.n_st inputs.plotd.number_max_states]);
  n_rows=ceil(n_max_plots/2);
  n_figs=ceil(inputs.model.n_st/n_max_plots);

  for iexp=1:inputs.exps.n_exp

  icolor=1;    
  for ifig=1:n_figs
  
        figure           
      
        if inputs.model.n_stimulus==0
           %size subplot
           rows_subplot=max([n_rows ceil((inputs.model.n_st-(n_figs-1)*n_max_plots)/2)]);   
        else   
           %size subplot
           rows_subplot=max([n_rows+1 ceil((inputs.model.n_st-(n_figs-1)*n_max_plots)/2)+1]);
           subplot(rows_subplot,1,1)
           AMIGO_plot_stimulus
           ist=1;               
        end

        n_end_loop=min([inputs.model.n_st ifig*n_max_plots]);
     
        for ist=(ifig-1)*n_max_plots+1:n_end_loop
  
             if inputs.model.n_stimulus==0
             plot_loc=(ist-(ifig-1)*n_max_plots);
             else
             if ist<inputs.model.n_st
             plot_loc=2+(ist-(ifig-1)*n_max_plots);
             else
             plot_loc=2+inputs.model.n_st-(n_figs-1)*n_max_plots;
             end
             end
            subplot(rows_subplot,2,plot_loc)
            plot(privstruct.t_int{iexp},results.sim.states{iexp}(:,ist),'color',plot_colors(icolor,:),'LineWidth',1)
            axis tight
            xlabel('Time');
            if  numel(inputs.model.st_names)>=1   
            legend(inputs.model.st_names(ist,:));
            legend boxoff     
            else
            legend('State: ',mat2str(ist)); 
            legend boxoff     
            end 
            
        icolor=icolor+1;
        if icolor==201
        icolor=1;
        end
        
        end % for ist=1:inputs.model.n_st{iexp}
                  
        
        
        % Keeps the .fig file
            file_ibest=num2str(ibest);
            file_index=num2str(ifig);    
            states_file_path_fig=strcat(inputs.pathd.states_plot_path,'_pareto',file_ibest,'_',file_index); 
            saveas(gcf, states_file_path_fig, 'fig');
        
            
            % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', states_file_path_fig); end         
end % for ifig=1:n_figs

end %for iexp=1:inputs.exps.n_exp