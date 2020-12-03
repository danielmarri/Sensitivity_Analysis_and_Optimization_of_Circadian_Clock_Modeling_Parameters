% AMIGO_DOsol_defaults: Assign defaults that MAY NOT be modified by user 
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
%  AMIGO_DOsol_defaults: Assign defaults that are required for Prep and DO    % 
%*****************************************************************************%



inputs_def.DOsol.N_DOcost=1;
inputs_def.DOsol.u_interp='stepf';
inputs_def.DOsol.tf_type='fixed';            % Type of experiment duration: 'fixed' | 'od' (to be designed)
inputs_def.DOsol.min_stepduration=[];        % For step or linear interpolation 
inputs_def.DOsol.max_stepduration=[];        % For step or linear interpolation 
inputs_def.DOsol.y0=[];
inputs_def.DOsol.u_min=[];
inputs_def.DOsol.u_max=[];
inputs_def.DOsol.u_guess=[];
inputs_def.DOsol.tf_guess=[];
inputs_def.DOsol.t_con=[];
inputs_def.DOsol.n_steps=[];
inputs_def.DOsol.n_linear=[];
inputs_def.DOsol.n_pulses=[];
inputs_def.DOsol.death_penalty='off';
inputs_def.DOsol.n_const_eq_tf=0;
inputs_def.DOsol.const_eq_tf=[];
inputs_def.DOsol.n_const_ineq_tf=0;
inputs_def.DOsol.const_ineq_tf=[];
inputs_def.DOsol.n_control_const=0;
inputs_def.DOsol.DOcost_type='min';
inputs_def.DOsol.DOcost='';
inputs_def.DOsol.eq_const_max_viol=1.0e-5;
inputs_def.DOsol.ineq_const_max_viol=1.0e-5;
inputs_def.DOsol.n_wsm=10;
inputs_def.DOsol.wsm_mat=[];
inputs_def.DOsol.n_pconst_ineq=0;         % Number of point constraints 
inputs_def.DOsol.tpointc=[];              % Times for point contraints
inputs_def.DOsol.n_control_const=0;
inputs_def.DOsol.control_const=[];         % c(u)<=0
inputs_def.DOsol.control_const_max_viol=1.0e-5;
inputs_def.DOsol.tf_min=0;
inputs_def.DOsol.tf_max=[]; 
inputs_def.DOsol.user_cost=0;                 % The user may need to modify the generated cost function

inputs_def.DOsol.id_par=[];               % parameters or sustained stimuli to be optimised                 

inputs_def.DOsol.par_guess=[];
inputs_def.DOsol.par_max=[];
inputs_def.DOsol.par_min=[];
inputs_def.DOsol.n_par=0;

inputs_def.DOsol.id_y0=[];                                   % initial conditions to be designed
inputs_def.DOsol.y0_max=[];                                         % Maximum allowed values for the initial conditions
inputs_def.DOsol.y0_min= [ ];                                       % Minimum allowed values for the initial conditions
inputs_def.DOsol.y0_guess= [ ]; 
inputs_def.DOsol.n_y0=0;
