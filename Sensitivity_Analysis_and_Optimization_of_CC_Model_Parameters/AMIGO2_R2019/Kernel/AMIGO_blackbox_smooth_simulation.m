% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_blackbox_smooth_simulation.m 2034 2015-08-24 11:54:26Z attila $
% AMIGO_blackbox_smooth_simulation: Smooth solution of the black box models
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
%  AMIGO_blackbox_smooth_simulation: solves the intial value problem solver   %
%                           continuous sampling times                         %
%*****************************************************************************%


for iexp=1:inputs.exps.n_exp
    if inputs.plotd.n_t_plot>1
        delta=(inputs.exps.t_f{iexp}-inputs.exps.t_in{iexp})/(inputs.plotd.n_t_plot-1);
        privstruct.t_s{iexp}=[inputs.exps.t_in{iexp}:delta:inputs.exps.t_f{iexp}];
        privstruct.t_int{iexp}=[inputs.exps.t_in{iexp}:delta:inputs.exps.t_f{iexp}];
    else
        privstruct.t_s{iexp}=inputs.exps.t_s{iexp};
        privstruct.t_int{iexp}=inputs.exps.t_s{iexp};
    end
    privstruct.vtout{iexp}=sort(union(privstruct.t_int{iexp},privstruct.t_con{iexp}));
    [results.sim.states{iexp} privstruct]=AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par{iexp},iexp);
    
    if inputs.model.obsfile==1
        obsfunc=inputs.pathd.obs_function;
        results.sim.obs{iexp}=feval(obsfunc,results.sim.states{iexp},inputs,privstruct.par{iexp},iexp);
    end
    results.sim.tsim{iexp}=privstruct.t_int{iexp};
end %for iexp=1:inputs.n_exp