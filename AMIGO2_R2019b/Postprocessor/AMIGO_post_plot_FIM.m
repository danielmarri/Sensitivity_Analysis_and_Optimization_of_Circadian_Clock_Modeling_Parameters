
function AMIGO_post_plot_FIM(inputs,results,privstruct)

%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************


AMIGO_plot_colors

% Keeps some input information in the structure results

fprintf(1,'\n\n------>Plotting results....\n\n');
theta=privstruct.theta;
privstruct=AMIGO_transform_theta(inputs,results,privstruct);

switch inputs.model.exe_type
    
    case {'costMex','fullMex'}
        
    otherwise
        
        if ~isfield(results,'sim') 
            results.sim=[];
            results.sim.obs={};
        end
        
        if isfield(inputs.pathd,'obs_function') && ~isempty(inputs.pathd.obs_function)
            
            obsfunc=inputs.pathd.obs_function;
            
            for iexp=1:inputs.exps.n_exp
                
                results.sim.obs{iexp}=feval(obsfunc,results.sim.states{iexp},inputs,privstruct.par{iexp},iexp);
                
            end
        end
end


if privstruct.istate_sens>0 && sum(diag(results.fit.g_corr_mat))>0
    
    AMIGO_plot_correlationmat
    
end

end

