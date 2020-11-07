% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_init_times.m 968 2013-09-17 11:33:28Z attila $
% AMIGO_init_times: Initialize time vectors for integration
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
% AMIGO_init_times: Initialize time vectors for integration                   %
%*****************************************************************************%


for iexp=1:inputs.exps.n_exp
    privstruct.vtout{iexp}=sort(union(inputs.exps.t_s{iexp},inputs.exps.t_con{iexp}));
    privstruct.w_sampling{iexp}=ones(1,inputs.exps.n_s{iexp});
end
privstruct.t_int=inputs.exps.t_s;


%  delta=(inputs.exps.t_f{iexp}-inputs.exps.t_in{iexp})/(results.plotd.n_t_plot-1);
%  privstruct.t_int{iexp}=[inputs.exps.t_in{iexp}:delta:inputs.exps.t_f{iexp}];
%  privstruct.vtout{iexp}=sort(union(privstruct.t_int{iexp},privstruct.t_con{iexp}));
