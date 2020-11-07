% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_post_report_PE.m 2197 2015-09-23 13:58:17Z evabalsa $
function [inputs,results]= AMIGO_post_report_PE(inputs,results,privstruct)

% AMIGO_post_report_PE: reporting results for parameter estimation
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
% AMIGO_post_report_PE: reporting results for parameter estimation            %
%                       - intermediate iterates in the optimization           %
%                       - best fit value (lsq or llq)                         %
%                       - best set of parameters/initial conditions           %
%                       - Crammer-Rao based confidence intervals              %
%                       - Crammer-Rao based correlation matrix at the         %
%                         optimum                                             %
%                       - statistics about the residuals: mean and max        %
%                         value, per observable and experiment                %
%*****************************************************************************%

AMIGO_release_info

global n_amigo_sim_success;
global n_amigo_sim_failed;
global n_amigo_sens_success;
global n_amigo_sens_failed;

fid=fopen(inputs.pathd.report,'a+');

%
AMIGO_report_model
AMIGO_report_exps
AMIGO_report_obs
AMIGO_report_data
AMIGO_report_residuals


fprintf(fid,'\t   \n\n>>>> Best objective function: %f \n',results.nlpsol.fbest);
fprintf(1,'\t   \n\n>>>> Best objective function: %f \n',results.nlpsol.fbest);
fprintf(fid,'\t   \n\n>>>> Computational cost: %f s\n',results.nlpsol.cpu_time);
fprintf(1,'\t   \n\n>>>> Computational cost: %f s\n',results.nlpsol.cpu_time);

if privstruct.ntotal_constraints >0
    
    fprintf(1,'\t   \n\n>>>> Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
    fprintf(fid,'\t   \n\n>>>> Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
    for icons=1:length(results.fit.constraints_viol)
        fprintf(1,'\t c(%u)=%4.2e;\n',icons,results.fit.constraints_viol(1,icons));
        fprintf(fid,'\t c(%u)=%4.2e;\n',icons,results.fit.constraints_viol(1,icons));
    end
    
end

switch inputs.model.exe_type
    
    case 'fullMex'
        
        warning('AMIGO_post_report_PE: Statistics about the simulation are not currently shown in fullMex execution mode.');
        
    otherwise

        fprintf(1,'> %.2f%% of successful simulationn\n',100*n_amigo_sim_success/(n_amigo_sim_success+n_amigo_sim_failed));
        fprintf(fid,'> %.2f%% of successful simulationn\n',100*n_amigo_sim_success/(n_amigo_sim_success+n_amigo_sim_failed));
        
        fprintf(1,'> %.2f%% of successful sensitivity calculations\n',100*n_amigo_sens_success/(n_amigo_sens_success+n_amigo_sens_failed));
        fprintf(fid,'> %.2f%% of successful sensitivity calculations\n',100*n_amigo_sens_success/(n_amigo_sens_success+n_amigo_sens_failed));
        
end



if ~isfield(results.fit,'g_corr_mat') || isempty(results.fit.g_corr_mat)
    results.fit.g_corr_mat=1;
end

if privstruct.istate_sens >0 && sum(diag(results.fit.g_corr_mat))>0 && privstruct.conf_intervals==1
    AMIGO_report_confintervals
else
    AMIGO_report_theta
 
end


%% report estimated parameters in the results structure.
if inputs.PEsol.n_global_theta>0
    results.fit.global_theta_estimated = privstruct.theta(1,1:inputs.PEsol.n_global_theta);
%     results.fit.id_global_theta = inputs.PEsol.id_global_theta;
end
if inputs.PEsol.n_global_theta_y0>0
    results.fit.global_theta_y0_estimated = privstruct.theta(1,inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0);
end
        
n_reported = inputs.PEsol.n_global_theta + inputs.PEsol.n_global_theta_y0 +1;
if inputs.PEsol.ntotal_local_theta > 0
    for iexp = inputs.exps.n_exp
        results.fit.local_theta_estimated{iexp} = privstruct.theta(1,n_reported:n_reported  + inputs.PEsol.n_local_theta{iexp}-1);
        n_reported = n_reported +inputs.PEsol.n_local_theta{iexp};
    end
end
if inputs.PEsol.ntotal_local_theta_y0 > 0
    for iexp = 1: inputs.exps.n_exp
        results.fit.local_theta_y0_estimated{iexp} = privstruct.theta(1,n_reported:n_reported  + inputs.PEsol.n_local_theta_y0{iexp}-1);
        n_reported = n_reported +inputs.PEsol.n_local_theta_y0{iexp};
    end
end



%if isfield(privstruct,'conf_intervals') && (privstruct.conf_intervals==0)
  %  fprintf(1,'\n\n\n>>>>>>CONFIDENCE INTERVALS can only be computed for Log-Likelihood (llk) cost functions\n');
  %  fprintf(1,'\n\n\n>>>>>>SENSITIVITY MATRIX is provided in results.fit.SM\n');
%end
fclose(fid);
end