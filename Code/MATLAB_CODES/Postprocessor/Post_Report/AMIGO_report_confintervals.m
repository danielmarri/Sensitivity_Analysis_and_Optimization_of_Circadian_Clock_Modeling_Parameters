% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_confintervals.m 2202 2015-09-24 07:10:57Z evabalsa $
% AMIGO_report_confinterval: reports confidence intervals obtained through Cramer-Rao inequality 
% AMIGO_report_confinterval: reports confidence intervals obtained through Cramer-Rao inequality
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
%  AMIGO_report_confinterval: incorporates in the report results on the       %
%                             confidence intervals for both estimated         %
%                             parameters and initial conditions, as computed  %
%                             by the Cramer-Rao inequality.                   %
%*****************************************************************************%


fid=fopen(inputs.pathd.report,'a+');

fprintf(1,'\n\n>>> Best values found and the corresponding asymptotic confidence intervals\n\n');                
fprintf(fid,'\n\n>>> Best values found and the corresponding asymptotic confidence intervals\n\n');  


fprintf(fid,'\n\n>>> Estimated global parameters: \n\n');  
fprintf(1,'\n\n>>> Estimated global parameters: \n\n');  


cte=1.0;


for i=1:inputs.PEsol.n_global_theta
       
    rho(i)=cte*sqrt(results.fit.g_var_cov_mat(i,i));
    if numel(inputs.model.par_names)>1
        results.fit.rel_conf_interval(1,i)=100*1.96*rho(i)/privstruct.theta(1,i);
        results.fit.conf_interval(1,i)=1.96*rho(i);
        if results.nlpsol.act_bound(1,i)==1
            fprintf(1,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); (bound active) \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            fprintf(fid,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); (bound active) \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
        else
            fprintf(1,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            fprintf(fid,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
        end
    else
        if results.nlpsol.act_bound(1,i)==1
            fprintf(1,'\ttheta(%u): %8.4e  +-  %8.4e (%8.3g%%); (bound active)\n',inputs.PEsol.index_global_theta(1,i),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            fprintf(fid,'\ttheta(%u): %8.4e  +-  %8.4e (%8.3g%%); (bound active)\n',inputs.PEsol.index_global_theta(1,i),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
        else
            fprintf(1,'\ttheta(%u): %8.4e  +-  %8.4e (%8.3g%%); \n',inputs.PEsol.index_global_theta(1,i),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            fprintf(fid,'\ttheta(%u): %8.4e  +-  %8.4e (%8.3g%%); \n',inputs.PEsol.index_global_theta(1,i),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
        end
    end
end %i=1:inputs.n_theta


if inputs.PEsol.n_global_theta_y0>0
    fprintf(fid,'\n\n>>> Estimated global initial conditions: \n\n');
    fprintf(1,'\n\n>>> Estimated global initial conditions: \n\n');
    j=1;
    for i=inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
        rho(i)=cte*sqrt(results.fit.g_var_cov_mat(i,i));
        
        if numel(inputs.model.st_names)>1
            
            if results.nlpsol.act_bound(1,i)==1
                fprintf(1,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); (bound active) \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                    privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
                fprintf(fid,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); (bound active) \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                    privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            else
                fprintf(1,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                    privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
                fprintf(fid,'\t%s : %8.4e  +-  %8.4e (%8.3g%%); \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                    privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            end
        else
            
            if results.nlpsol.act_bound(1,i)==1
                fprintf(1,'\ty0(%u): %8.4e  +-  %8.4e (%8.3g%%); (bound active)\n',inputs.PEsol.index_global_theta_y0(1,j),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
                fprintf(fid,'\ty0(%u): %8.4e  +-  %8.4e (%8.3g%%); (bound active) \n',inputs.PEsol.index_global_theta_y0(1,j),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            else
                fprintf(1,'\ty0(%u): %8.4e  +-  %8.4e (%8.3g%%);\n',inputs.PEsol.index_global_theta_y0(1,j),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
                fprintf(fid,'\ty0(%u): %8.4e  +-  %8.4e (%8.3g%%); \n',inputs.PEsol.index_global_theta_y0(1,j),privstruct.theta(1,i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,i));
            end
        end
        j=j+1;
    end %i=1:inputs.n_theta
    
end %if inputs.PEsol.n_global_theta_y0>0






if inputs.PEsol.ntotal_local_theta>0
    fprintf(fid,'\n\n>>> Estimated local parameters: \n\n');
    fprintf(1,'\n\n>>> Estimated local parameters: \n\n');
    
    counter_g=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
    for iexp=1:inputs.exps.n_exp
             for i=1:inputs.PEsol.n_local_theta{iexp}
            rho(i)=cte*sqrt(results.fit.l_var_cov_mat{iexp}(i,i));
            if numel(inputs.model.par_names)>1
                
                if results.nlpsol.act_bound(1,counter_g+i)==1
                    fprintf(1,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.3g%%); (active bound) \n',iexp,inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,i),:),...
                        privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                    fprintf(fid,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.3g%%); (active bound) \n',iexp,inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,i),:),...
                        privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                else
                    fprintf(1,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.3g%%); \n',iexp,inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,i),:),...
                        privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                    fprintf(fid,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.3g%%); \n',iexp,inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,i),:),...
                        privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                end
            else
                if results.nlpsol.act_bound(1,counter_g+i)==1
                    fprintf(1,'\tExperiment %u, theta(%u): %8.4e  +-  %8.4e (%8.3g%%); (active bound) \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,i),privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                    fprintf(fid,'\tExperiment %u, theta(%u): %8.4e  +-  %8.4e (%8.3g%%); (active bound) \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,i),privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                else
                    fprintf(1,'\tExperiment %u, theta(%u): %8.4e  +-  %8.4e (%8.3g%%); \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,i),privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                    fprintf(fid,'\tExperiment %u, theta(%u): %8.4e  +-  %8.4e (%8.3g%%); \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,i),privstruct.theta(1,counter_g+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_g+i));
                end
            end
            
        end %i=1:inputs.n_theta
        counter_g=counter_g+inputs.PEsol.n_local_theta{iexp};
    end %iexp
    
end %if inputs.PEsol.ntotal_local_theta_y0>0


if inputs.PEsol.ntotal_local_theta_y0>0
    fprintf(fid,'\n\n>>> Estimated local initial conditions: \n\n');
    fprintf(1,'\n\n>>> Estimated local initial conditions: \n\n');
    
    counter_gl=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.ntotal_local_theta;
    for iexp=1:inputs.exps.n_exp
        
        for i=1:inputs.PEsol.n_local_theta_y0{iexp}
            rho(i)=cte*sqrt(results.fit.l_var_cov_mat{iexp}(i,i));
            if numel(inputs.model.st_names)>1
                if results.nlpsol.act_bound(1,counter_gl+i)==1
                    fprintf(1,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.2e%%); (active bound) \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),...
                        privstruct.theta(1,counter_gl+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                    fprintf(fid,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.2e%%); (active bound) \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),...
                        privstruct.theta(1,counter_gl+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                else
                    fprintf(1,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.2e%%); \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),...
                        privstruct.theta(1,counter_gl+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                    fprintf(fid,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.2e%%); \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),...
                        privstruct.theta(1,counter_gl+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                end
            else
                if results.nlpsol.act_bound(1,counter_gl+i)==1
                    fprintf(1,'\tExperiment %u, y0(%u): %8.4e  +-  %8.4e (%8.2e%%); (active bound)\n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),privstruct.theta(1,counter_gl+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                    fprintf(fid,'\tExperiment %u, y0(%u): %8.4e  +-  %8.4e (%8.2e%%); (active bound)\n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),privstruct.theta(1,counter_gl+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                else
                    fprintf(1,'\tExperiment %u, y0(%u): %8.4e  +-  %8.4e (%8.2e%%); \n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),privstruct.theta(1,counter_gl+i),1.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                    fprintf(fid,'\tExperiment %u, y0(%u): %8.4e  +-  %8.4e (%8.2e%%); \n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),privstruct.theta(1,counter_gl+i),6.96*rho(i),100*1.96*rho(i)/privstruct.theta(1,counter_gl+i));
                end
            end
        end %i=1:inputs.n_theta
        counter_gl=counter_gl+inputs.PEsol.n_local_theta_y0{iexp};
    end %iexp
    
end %if inputs.PEsol.ntotal_local_theta_y0>0


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


if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
    
    for iexp=1:inputs.exps.n_exp
        if  inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp}>0
        fprintf(1,'\n\n>>> Correlation matrix for the experiment %u\n\n',iexp);
        fprintf(fid,'\n\n>>> Correlation matrix for the experiment %u\n\n',iexp);
        for i=1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp}
            for j=1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp}
                fprintf(1,'\t %e',results.fit.l_corr_mat{iexp}(i,j));
                fprintf(fid,'\t %e',results.fit.l_corr_mat{iexp}(i,j));
            end
            fprintf(1,'\n');
            fprintf(fid,'\n');
        end
        end
        
    end % for iexp=1:inputs.exps.n_exp
end %inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0


