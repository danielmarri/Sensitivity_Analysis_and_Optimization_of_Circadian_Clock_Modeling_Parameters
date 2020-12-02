% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_post_report_OED.m 2202 2015-09-24 07:10:57Z evabalsa $
function [results,privstruct]= AMIGO_post_report_OED(inputs,results,privstruct);

% AMIGO_post_report_OED: reporting results for OED
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
% AMIGO_post_report_OED: reporting results for experimental design            %
%                       - intermediate iterates in the optimization           %
%                       - best obj value                                      %
%                       - best OED                                            %
%                       - expected Crammer-Rao based confidence intervals     %
%                       - expected Crammer-Rao based correlation matrix at the%
%                         optimum                                             %
%*****************************************************************************%


     AMIGO_release_info
     fid=fopen(inputs.pathd.report,'w');
 
      fid=fopen(inputs.pathd.report,'a+');
%   Done in the AMIGO_init_report.m called in the main function: AMIGO_OED 
%     fprintf(fid,'\n\n*********************************** ');
%     fprintf(fid,'\n*     AMIGO, Copyright @CSIC      * ');
%     fprintf(fid,'\n*   %s    *',AMIGO_version);
%     fprintf(fid,'\n*********************************** ');
%     fprintf(fid,'\n\n*Date: %s',date); 
%     fprintf(fid,'\t   \n\n> Problem folder: %s\n',inputs.pathd.problem_folder_path);
%     fprintf(fid,'\t   \n> Results folder in problem folder: %s \n',inputs.pathd.task_folder);
   
     AMIGO_report_model
     AMIGO_report_obs

     fid=fopen(inputs.pathd.report,'a+');
     
     fprintf(fid,'\n\n----------------------------------------\n');
     fprintf(1,'\n\n----------------------------------------\n');
     fprintf(fid,'\t  >>>> EXPERIMENTAL DESIGN:\n');
     fprintf(1,'\t   >>>> EXPERIMENTAL DESIGN:\n');
     fprintf(fid,'\n----------------------------------------\n');
     fprintf(1,'\n----------------------------------------\n');
        
     fprintf(fid,'\t   \n\n>>>> Best objective function: %s = %e \n',inputs.OEDsol.OEDcost_type,results.nlpsol.fbest);
     fprintf(1,'\t   \n\n>>>> Best objective function: %s = %e \n',inputs.OEDsol.OEDcost_type,results.nlpsol.fbest);
     

     AMIGO_report_exps
     
    
    
    %%%% ACABAR ESTO
    
    if privstruct.istate_sens >0
        
        fprintf(1,'\n\n>>> OED corresponding Cramer Rao expected uncertainty for the unknowns:\n');                
        fprintf(fid,'\n\n>>> OED corresponding Cramer Rao expected uncertainty for the unknowns:\n');      
        
        fprintf(fid,'\n\n>>> Global parameters: \n\n');  
        fprintf(1,'\n\n>>> Global parameters: \n\n');  

            for i=1:inputs.PEsol.n_global_theta
            privstruct.rho(i)=sqrt(results.fit.g_var_cov_mat(i,i));                         
            if numel(inputs.model.par_names)>1
            fprintf(1,'\t%s : %8.4e  +-  %8.4e; \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                privstruct.theta(1,i),1.96*privstruct.rho(i));   
            fprintf(fid,'\t%s : %8.4e  +-  %8.4e; \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                privstruct.theta(1,i),1.96*privstruct.rho(i));  
            else
            fprintf(1,'\ttheta(%u): %8.4e  +-  %8.4e; \n',inputs.PEsol.index_global_theta(1,i),privstruct.theta(1,i),1.96*privstruct.rho(i));     
            fprintf(fid,'\ttheta(%u): %8.4e  +-  %8.4e; \n',inputs.PEsol.index_global_theta(1,i),privstruct.theta(1,i),1.96*privstruct.rho(i));    
            end
            end %i=1:inputs.n_theta      
            if inputs.PEsol.n_global_theta_y0>0
            fprintf(fid,'\n\n>>> Global initial conditions: \n\n');     
            fprintf(1,'\n\n>>> Global initial conditions: \n\n');  
            j=1;
            for i=inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
            privstruct.rho(i)=sqrt(results.fit.g_var_cov_mat(i,i));   
                if numel(inputs.model.st_names)>1
                fprintf(1,'\t%s : %8.4e  +-  %8.4e; \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                privstruct.theta(1,i),1.96*privstruct.rho(i));   
                fprintf(fid,'\t%s : %8.4e  +-  %8.4e; \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                privstruct.theta(1,i),1.96*privstruct.rho(i));  
                else
                fprintf(1,'\ty0(%u): %8.4e  +-  %8.4e; \n',inputs.PEsol.index_global_theta_y0(1,j),privstruct.theta(1,i),1.96*privstruct.rho(i));     
                fprintf(fid,'\ty0(%u): %8.4e  +-  %8.4e; \n',inputs.PEsol.index_global_theta_y0(1,j),privstruct.theta(1,i),1.96*privstruct.rho(i));    
                end
            j=j+1;
            end %i=1:inputs.n_theta
               
            end %if inputs.PEsol.n_global_theta_y0>0
            end %if privstruct.istate_sens >0
 
            fprintf(1,'\n\n>>> Correlation matrix for the global unknowns:\n\n');
            fprintf(fid,'\n\n>>> Correlation matrix for the global unknowns:\n\n');
 

            for i=1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
            for j=1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
            fprintf(1,'\t %e',results.fit.g_corr_mat(i,j));
            fprintf(fid,'\t %e',results.fit.g_corr_mat(i,j));
            end
            fprintf(1,'\n');
            fprintf(fid,'\n');
            end 
            
            if privstruct.ntotal_constraints >0
            fprintf(1,'\t   \n\n>>>> Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
            fprintf(fid,'\t   \n\n>>>> Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
            if size(results.oed.constraints_viol,1)>1
            results.oed.constraints_viol=results.oed.constraints_viol';
            end
            for icons=1:length(results.oed.constraints_viol)
                
            fprintf(1,'\t c(%u)=%4.2e;\n',icons,results.oed.constraints_viol(1,icons));
            fprintf(fid,'\t c(%u)=%4.2e;\n',icons,results.oed.constraints_viol(1,icons));
            end
            end
           
            
            
 
    fclose(fid);
return 