% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_ecc.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_ecc: plots eccentricity values for the robust ident. analysis
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
%   AMIGO_plot_ecc: plots eccentricity values for the robust ident. analysis  %
%                                                                             %
%*****************************************************************************%  
         
  
       

         figure  
         n_ecc=size(results.rid.ecc,1);
         ecc_matrix=zeros(n_ecc+1,n_ecc+1);
         ecc_matrix(1:n_ecc,1:n_ecc)=results.rid.ecc;
         
         pcolor(ecc_matrix)
         colorbar
         shading flat
         
         if numel(inputs.model.par_names)>0
         ticklabels=inputs.model.par_names(inputs.PEsol.index_global_theta,:);
         else
         ticklabels=inputs.PEsol.index_global_theta;
         end
         
         if inputs.PEsol.n_global_theta_y0>0
             
         if  numel(inputs.model.par_names)>=1 && numel(inputs.model.st_names)>=1
         ticklabels= str2mat(ticklabels,inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:));     
         else
         ticklabels=[ticklabels inputs.PEsol.index_global_theta_y0];    
         end   
         end
         
         if inputs.PEsol.ntotal_local_theta>0 
             if  numel(inputs.model.par_names)>=1  
                for iexp=1:inputs.exps.n_exp
                ticklabels=str2mat(ticklabels, inputs.model.par_names(inputs.PEsol.index_local_theta{iexp},:)); 
                        end
            else
                for iexp=1:inputs.exps.n_exp    
                ticklabels=[ticklabels inputs.PEsol.index_local_theta{iexp}]; end   
            end    
         end    
             
         
         
         if inputs.PEsol.ntotal_local_theta_y0>0
            if  numel(inputs.model.st_names)>=1    
            for iexp=1:inputs.exps.n_exp    
            ticklabels=str2mat(ticklabels, inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp},:)); end
            else
            for iexp=1:inputs.exps.n_exp    
            ticklabels=[ticklabels inputs.PEsol.index_local_theta_y0{iexp}]; end    
            end    
         end    

         
         set(gca,'YTick',1+0.5:1:size(privstruct.theta,2)+0.5,'YTickLabel',ticklabels);
         set(gca,'XTick',1+0.5:1:size(privstruct.theta,2)+0.5,'XTickLabel',ticklabels);
         
         
         plot_title='Eccentricity by pairs of unknowns';
         title(plot_title);  
         
        
         saveas(gcf,inputs.pathd.ecc_path, 'fig');
         if inputs.plotd.epssave==1;
         print( gcf, '-depsc', inputs.pathd.ecc_path);end
         