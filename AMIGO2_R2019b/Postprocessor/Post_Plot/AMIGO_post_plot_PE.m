% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_post_plot_PE.m 2519 2016-03-02 09:34:05Z evabalsa $

function AMIGO_post_plot_PE(inputs,results,privstruct)

% AMIGO_post_plot_PE: plotting results for PE
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
% AMIGO_post_plot_SD: plotting results for PE                              %
%                     Plots all observables plus experimental data under the  %
%                     given stimulus conditions                               %
%                                                                             %
%*****************************************************************************%

AMIGO_plot_colors

% Keeps some input information in the structure results


fprintf(1,'\n\n------>Plotting results....\n\n');
theta=privstruct.theta;
privstruct=AMIGO_transform_theta(inputs,results,privstruct);

switch inputs.model.exe_type
    
    case {'costMex','fullMex'}
        
    otherwise
        
         if isfield(inputs.pathd,'obs_function') && ~isempty(inputs.pathd.obs_function)
            obsfunc=inputs.pathd.obs_function;
            
            for iexp=1:inputs.exps.n_exp
                results.sim.obs{iexp}=feval(obsfunc,results.sim.states{iexp},inputs,privstruct.par{iexp},iexp);
            end
        end
end

fig_plot_path=inputs.pathd.fit_plot_path;


switch  inputs.plotd.plotlevel
    
    case 'full'
        
        AMIGO_plot_obs_plus_data(inputs,results,0)
        AMIGO_plot_obs_vs_data(inputs,results)
        AMIGO_plot_residuals
        AMIGO_plot_meanmax_residuals
        AMIGO_plot_conv_curve
        if privstruct.istate_sens>0 && sum(diag(results.fit.g_corr_mat))>0&& privstruct.conf_intervals==1
            AMIGO_plot_correlationmat
            AMIGO_plot_obs_confidence_data
        end
        %if privstruct.conf_intervals==0 && privstruct.istate_sens>0
        if  privstruct.istate_sens>0
         AMIGO_plot_sensmat      
         AMIGO_plot_clust_sensmat
        end 

        AMIGO_plot_estim_params(theta,inputs,results)
        
    case 'medium'
        
        AMIGO_plot_obs_plus_data(inputs,results,0)
        AMIGO_plot_meanmax_residuals
        AMIGO_plot_conv_curve
        if privstruct.istate_sens>0 && sum(diag(results.fit.g_corr_mat))>0 && privstruct.conf_intervals==1
            AMIGO_plot_correlationmat
            AMIGO_plot_obs_confidence_data
        end
        if privstruct.conf_intervals==0 && privstruct.istate_sens>0
        AMIGO_plot_sensmat    
        end    
        
        
    case 'min'
        AMIGO_plot_obs_plus_data(inputs,results,0)
%         AMIGO_plot_meanmax_residuals   % Attila: do not commit to SVN!!!
        if privstruct.istate_sens>0 && sum(diag(results.fit.g_corr_mat))>0 && privstruct.conf_intervals==1
            AMIGO_plot_correlationmat
            
        end
        
end