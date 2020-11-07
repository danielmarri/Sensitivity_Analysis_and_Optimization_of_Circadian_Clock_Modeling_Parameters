% AMIGO_plot_multistart_controlhist: plots control multistart results for OD
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
%  AMIGO_plot_multistart_hist: Plots a histogram of solutions achieved by     %
%                              a multistart of a local solver.                %
%                              x-axis: value of the unknowns (pars or y0)     %
%                              y-axis: frequency of the solutions             %     
%                                                                             %
%*****************************************************************************%   



                   
              n_var=length(results.nlpsol.vbest);
              n_max_plots=min([n_var results.plotd.number_max_hist]);
              n_rows=ceil(n_max_plots/2);
              n_figs=ceil(n_var/n_max_plots);
              
              if n_var>1
                  n_cols=2;
              else
                  n_cols=1;
              end    

              for ifig=1:n_figs
    
              figure
            %size subplot
              rows_subplot=max([n_rows ceil((n_var-(n_figs-1)*n_max_plots)/2)]);    
              n_end_loop=min([n_var ifig*n_max_plots]);
                      
              for ivar=(ifig-1)*n_max_plots+1:n_end_loop
                if ivar<n_var
                 plot_loc=(ivar-(ifig-1)*n_max_plots);
                else
                 plot_loc=n_var-((n_figs-1)*n_max_plots);
                end
     
                subplot(rows_subplot,n_cols,plot_loc)
                hist(results.nlpsol.v_vector_multistart(:,ivar),nbars);
                h = findobj(gca,'Type','patch');
                set(h,'FaceColor','g')
            
%                 if ivar<=inputs.PEsol.n_global_var
%                     if  numel(inputs.model.par_names)>=1  
%                     label_x=inputs.model.par_names(inputs.PEsol.index_global_var(ivar),:);
%                     else
%                     label_x=strcat('var_',inputs.PEsol.index_global_var(ivar));
%                     end
%                 
%                 else
%                     if  numel(inputs.model.st_names)>=1  
%                     label_x=inputs.model.st_names(inputs.PEsol.index_global_var_y0(ivar-inputs.PEsol.n_global_var),:);
%                     else
%                     label_x=strcat('y0_',inputs.PEsol.index_global_var_y0(ivar-inputs.PEsol.n_global_var));
%                     end
%                 end     
                     
%                xlabel(label_x);
                ylabel('Frequency');
                plot_title=strcat('Multistart results: var ',num2str(ivar));
                title(plot_title);
                end %for ivar=(ifig-1)*n_max_plots+1:n_end_loop
                file_index=num2str(ifig);    
                plot_path=strcat(results.pathd.multistart_hist,'_g_var_',file_index); 
                % Keeps the .fig file
                saveas(gcf, plot_path, 'fig')
                % Saves a .eps color figure
                if results.plotd.epssave==1;
                print( gcf, '-depsc', plot_path); end 
            
            end %for ifig=1:n_figs
        
                                   
            
        