% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_init_PE_guess_bounds.m 2061 2015-08-24 13:08:42Z attila $

% AMIGO_init_PE_guess_bounds: initializes some necessary vectors for optimization
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
%  AMIGO_init_PE_guess_bounds: generates guess and bounds for the vector of   %
%                           parameters and initial conditions                 %
%*****************************************************************************%


% DEFINES INITIAL GUESS AND BOUNDS FOR OPTIMIZATION

    
inputs.PEsol.vtheta_guess=[ inputs.PEsol.global_theta_guess  inputs.PEsol.global_theta_y0_guess  cell2mat(inputs.PEsol.local_theta_guess)  cell2mat(inputs.PEsol.local_theta_y0_guess) ];
inputs.PEsol.vtheta_min=[inputs.PEsol.global_theta_min  inputs.PEsol.global_theta_y0_min  cell2mat(inputs.PEsol.local_theta_min) cell2mat(inputs.PEsol.local_theta_y0_min) ];
inputs.PEsol.vtheta_max=[inputs.PEsol.global_theta_max  inputs.PEsol.global_theta_y0_max  cell2mat(inputs.PEsol.local_theta_max) cell2mat(inputs.PEsol.local_theta_y0_max) ];
    


% INTEGRATION TIMES

for iexp=1:inputs.exps.n_exp
    privstruct.vtout{iexp}=sort(union(inputs.exps.t_s{iexp},inputs.exps.t_con{iexp}));
end

privstruct.t_int=inputs.exps.t_s;

