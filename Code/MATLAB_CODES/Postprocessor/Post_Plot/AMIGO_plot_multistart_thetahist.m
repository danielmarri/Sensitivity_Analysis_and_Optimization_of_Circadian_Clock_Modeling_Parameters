% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_multistart_thetahist.m 2457 2015-12-15 14:32:25Z evabalsa $
% AMIGO_plot_multistart_thetahist: plots theta multistart results for PE
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



                   
              n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
              n_max_plots=min([n_theta inputs.plotd.number_max_hist]);
              n_rows=ceil(n_max_plots/2);
              n_figs=ceil(n_theta/n_max_plots);
              
              if n_theta>1
                  n_cols=2;
              else
                  n_cols=1;
              end    

              for ifig=1:n_figs
    
              figure
            %size subplot
              rows_subplot=max([n_rows ceil((n_theta-(n_figs-1)*n_max_plots)/2)]);    
              n_end_loop=min([n_theta ifig*n_max_plots]);
                      
              for itheta=(ifig-1)*n_max_plots+1:n_end_loop
                if itheta<n_theta
                 plot_loc=(itheta-(ifig-1)*n_max_plots);
                else
                 plot_loc=n_theta-((n_figs-1)*n_max_plots);
                end
     
                subplot(rows_subplot,n_cols,plot_loc)
                hist(results.nlpsol.v_vector_multistart(:,itheta),nbars);
                h = findobj(gca,'Type','patch');
                set(h,'FaceColor','g')
            
                if itheta<=inputs.PEsol.n_global_theta
                    if  numel(inputs.model.par_names)>=1  
                    label_x=inputs.model.par_names(inputs.PEsol.index_global_theta(itheta),:);
                    else
                    label_x=strcat('theta_',inputs.PEsol.index_global_theta(itheta));
                    end
                
                else
                    if  numel(inputs.model.st_names)>=1  
                    label_x=inputs.model.st_names(inputs.PEsol.index_global_theta_y0(itheta-inputs.PEsol.n_global_theta),:);
                    else
                    label_x=strcat('y0_',inputs.PEsol.index_global_theta_y0(itheta-inputs.PEsol.n_global_theta));
                    end
                end     
                     
                xlabel(label_x);
                ylabel('Frequency');
                plot_title=strcat('Multistart results: ',label_x);
                title(plot_title);
                end %for itheta=(ifig-1)*n_max_plots+1:n_end_loop
                file_index=num2str(ifig);    
                plot_path=strcat(inputs.pathd.multistart_hist,'_g_theta_',file_index); 
                % Keeps the .fig file
                saveas(gcf, plot_path, 'fig')
                % Saves a .eps color figure
                if inputs.plotd.epssave==1;
                print( gcf, '-depsc', plot_path); end 
            
            end %for ifig=1:n_figs
        
                                   
            
             % LOCAL UNKNOWNS
             
            if inputs.PEsol.ntotal_local_theta>0                 
              counter_g=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
                
              for iexp=1:inputs.exps.n_exp
                
              n_theta=inputs.PEsol.n_local_theta{iexp};
              n_max_plots=min([n_theta inputs.plotd.number_max_hist]);
              n_rows=ceil(n_max_plots/2);
              n_figs=ceil(n_theta/n_max_plots);

              if n_theta>1
                  n_cols=2;
              else
                  n_cols=1;
              end    
              
              
              for ifig=1:n_figs
    
              figure
            %size subplot
            
              rows_subplot=max([n_rows ceil((n_theta-(n_figs-1)*n_max_plots)/2)]);    

              n_end_loop=min([n_theta ifig*n_max_plots]);
                      
              for itheta=(ifig-1)*n_max_plots+1:n_end_loop
                if itheta<n_theta
                 plot_loc=(itheta-(ifig-1)*n_max_plots);
                else
                 plot_loc=n_theta-((n_figs-1)*n_max_plots);
                end
     
                subplot(rows_subplot,n_cols,plot_loc)
                hist(results.nlpsol.v_vector_multistart(:,itheta+counter_g),nbars);
                h = findobj(gca,'Type','patch');
                set(h,'FaceColor','g')
            
                    if  numel(inputs.model.par_names)>=1  
                    label_x=inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(itheta),:);
                    else
                    label_x=strcat('theta_',inputs.PEsol.index_local_theta(itheta));
                    end
                    
                xlabel(label_x);
                ylabel('Frequency');
                plot_title=strcat('Multistart results: ',label_x, ', exp ',num2str(iexp));
                title(plot_title);
                end %for itheta=(ifig-1)*n_max_plots+1:n_end_loop
                file_index=num2str(ifig);    
                exp_index=num2str(iexp);
                plot_path=strcat(inputs.pathd.multistart_hist,'_g_theta_exp',exp_index,file_index); 
                % Keeps the .fig file
                saveas(gcf, plot_path, 'fig')
                % Saves a .eps color figure
                if inputs.plotd.epssave==1;
                print( gcf, '-depsc', plot_path); end 
            
            end %for ifig=1:n_figs
            
            counter_g=counter_g+inputs.PEsol.n_local_theta{iexp};
            
            end  
                
            end %inputs.PEsol.ntotal_local_theta>0 
            
            
            
            
            if inputs.PEsol.ntotal_local_theta_y0>0                 
              counter_gl=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.ntotal_local_theta;
   
              for iexp=1:inputs.exps.n_exp
                
              n_theta=inputs.PEsol.n_local_theta_y0{iexp};
              n_max_plots=min([n_theta inputs.plotd.number_max_hist]);
              n_rows=ceil(n_max_plots/2);
              n_figs=ceil(n_theta/n_max_plots);
              
              
              if n_theta>1
                  n_cols=2;
              else
                  n_cols=1;
              end    

              for ifig=1:n_figs
    
              figure
            %size subplot
            
              rows_subplot=max([n_rows ceil((n_theta-(n_figs-1)*n_max_plots)/2)]);    
      
              n_end_loop=min([n_theta ifig*n_max_plots]);
                      
              for itheta=(ifig-1)*n_max_plots+1:n_end_loop
                if itheta<n_theta
                 plot_loc=(itheta-(ifig-1)*n_max_plots);
                else
                 plot_loc=n_theta-((n_figs-1)*n_max_plots);
                end
     
                subplot(rows_subplot,n_cols,plot_loc)
                hist(results.nlpsol.v_vector_multistart(:,itheta+counter_gl),nbars);
                h = findobj(gca,'Type','patch');
                set(h,'FaceColor','g')
            
                    if  numel(inputs.model.st_names)>=1  
                    label_x=inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(itheta),:);
                    else
                    label_x=strcat('y0_',inputs.PEsol.index_local_theta_y0(itheta));
                    end
                            
                xlabel(label_x);
                ylabel('Frequency');
                plot_title=strcat('Multistart results: ',label_x, ', exp ',num2str(iexp));
                title(plot_title);
                end %for itheta=(ifig-1)*n_max_plots+1:n_end_loop
                file_index=num2str(ifig);    
                exp_index=num2str(iexp);
                plot_path=strcat(inputs.pathd.multistart_hist,'_g_y0_exp',exp_index,file_index); 
                % Keeps the .fig file
                saveas(gcf, plot_path, 'fig')
                % Saves a .eps color figure
                if inputs.plotd.epssave==1;
                print( gcf, '-depsc', plot_path); end 
            
            end %for ifig=1:n_figs
            
            counter_gl=counter_gl+inputs.PEsol.n_local_theta_y0{iexp};
            end  
                
            end %inputs.PEsol.ntotal_local_theta>0 