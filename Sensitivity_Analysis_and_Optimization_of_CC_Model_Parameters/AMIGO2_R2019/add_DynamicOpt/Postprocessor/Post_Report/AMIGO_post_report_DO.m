function [results,privstruct]= AMIGO_post_report_do(inputs,results,privstruct);

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
 
     fprintf(fid,'\n\n   *********************************** ');
     fprintf(fid,'\n   *    AMIGO2, Copyright @CSIC    * ');
     fprintf(fid,'\n*       %s      *',AMIGO_version);
     fprintf(fid,'\n   *********************************** ');
     fprintf(fid,'\n\n------>Date: %s',date); 
     fprintf(fid,'\t   \n\n> Problem folder: %s\n',inputs.pathd.problem_folder_path);
     fprintf(fid,'\t   \n> Results folder in problem folder: %s \n',inputs.pathd.task_folder);
   
     AMIGO_report_model
    
 
     switch inputs.nlpsol.nlpsolver
         
         case 'sim'
     
         case 'nsga2'
            fprintf(fid,'\n\n----------------------------------------------\n');
            fprintf(1,'\n\n----------------------------------------------\n');
            fprintf(fid,' >>>> MULTIOBJECTIVE DYNAMIC OPTIMIZATION:\n');
            fprintf(1,'   >>>> MULTIOBJECTIVE DYNAMIC OPTIMIZATION:\n');
            fprintf(fid,'\n---------------------------------------------\n');
            fprintf(1,'\n----------------------------------------------\n');
        
            fprintf(fid,'\t   \n\n>>>> PARETO FRONT with % u non dominated solutions \n',results.nlpsol.n_firstParetoFront);
            fprintf(1,'\t   \n\n>>>> PARETO FRONT with % u non dominated solutions \n',results.nlpsol.n_firstParetoFront);
            n_solutions= results.nlpsol.n_firstParetoFront;
            for ipareto=1:n_solutions
            for iobj=1:inputs.idosol.N_DOcost
            fprintf(fid,'\t\t %e\t',results.nlpsol.sorted_pareto_obj(ipareto,iobj));
            fprintf(1,'\t\t %e\t',results.nlpsol.sorted_pareto_obj(ipareto,iobj));
            end
            fprintf(fid,'\n');
            fprintf(1,'\n');
            end % for ipareto=1:n_solutions
            AMIGO_report_multido
         case 'wsm'
            fprintf(fid,'\n\n----------------------------------------------\n');
            fprintf(1,'\n\n----------------------------------------------\n');
            fprintf(fid,'\t  >>>> MULTIOBJECTIVE DYNAMIC OPTIMIZATION:\n');
            fprintf(1,'\t   >>>> MULTIOBJECTIVE DYNAMIC OPTIMIZATION:\n');
            fprintf(fid,'\n---------------------------------------------\n');
            fprintf(1,'\n----------------------------------------------\n');
        
            fprintf(fid,'\t   \n\n>>>> WSM PARETO FRONT with % u solutions \n',inputs.idosol.n_wsm);
            fprintf(1,'\t   \n\n>>>> WSM PARETO FRONT with % u solutions \n',inputs.idosol.n_wsm);
            n_solutions= inputs.idosol.n_wsm;
            for ipareto=1:n_solutions
            for iobj=1:inputs.idosol.N_DOcost
            fprintf(fid,'\t\t %e\t',results.do.multi_fbest{ipareto}(1,iobj));
            fprintf(1,'\t\t %e\t',results.do.multi_fbest{ipareto}(1,iobj));
            end
            fprintf(fid,'\n');
            fprintf(1,'\n');
            end % for ipareto=1:n_solutions
            AMIGO_report_multido
     otherwise 
     
     fid=fopen(inputs.pathd.report,'a+');
     
     AMIGO_report_DO
          
     fclose(fid);
     end
return 