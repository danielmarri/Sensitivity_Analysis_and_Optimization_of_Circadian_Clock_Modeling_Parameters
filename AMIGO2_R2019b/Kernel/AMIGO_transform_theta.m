% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_transform_theta.m 2046 2015-08-24 12:43:55Z attila $
function [privstruct]=AMIGO_transform_theta(inputs,results,privstruct)
% AMIGO_transform_theta: transforms theta vector in: local/global theta/y0
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
% AMIGO_transform_theta: transforms theta vector in: local/global theta/y0    %
%                                                                             %
%*****************************************************************************%



if size(privstruct.theta,1)>1
    privstruct.theta=privstruct.theta';
end %if size(theta,1)>1

for iexp=1:inputs.exps.n_exp
    % GLOBAL PARAMETERS
    privstruct.par{iexp}=[inputs.model.par inputs.PEsol.upar_guess];
    privstruct.par{iexp}(inputs.PEsol.index_global_theta)=privstruct.theta(1,1:inputs.PEsol.n_global_theta);
    switch inputs.exps.exp_y0_type{iexp}
        case 'fixed'
            privstruct.y_0{iexp}=inputs.exps.exp_y0{iexp};
    end
end


if inputs.PEsol.n_global_theta_y0>=1
    for iexp=1:inputs.exps.n_exp
        % GLOBAL INITIAL CONDITIONS WHEN NECESSARY
        privstruct.y_0{iexp}=inputs.exps.exp_y0{iexp};
        try
        privstruct.y_0{iexp}(inputs.PEsol.index_global_theta_y0)=privstruct.theta(1,inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0);
        catch
            keyboard
        end
    end;
end
counter_g=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;

for iexp=1:inputs.exps.n_exp
    % LOCAL PARAMETERS WHEN NECESSARY

    if inputs.PEsol.n_local_theta{iexp}>=1
          privstruct.par{iexp}(inputs.PEsol.index_local_theta{iexp})=privstruct.theta(1,counter_g+1:counter_g+inputs.PEsol.n_local_theta{iexp});
        counter_g=counter_g+inputs.PEsol.n_local_theta{iexp};
        
    end
    
end %for iexp=1:inputs.exps.n_exp
counter_gl=counter_g;



for iexp=1:inputs.exps.n_exp

    % LOCAL INITIAL CONDITIONS WHEN NECESSARY
    if inputs.PEsol.n_local_theta_y0{iexp}>=1
        privstruct.y_0{iexp}(inputs.PEsol.index_local_theta_y0{iexp})=privstruct.theta(1,counter_gl+1:counter_gl+inputs.PEsol.n_local_theta_y0{iexp});
        counter_gl=counter_gl+inputs.PEsol.n_local_theta_y0{iexp};
    end
    
end %iexp=1:inputs.exps.n_exp


return;