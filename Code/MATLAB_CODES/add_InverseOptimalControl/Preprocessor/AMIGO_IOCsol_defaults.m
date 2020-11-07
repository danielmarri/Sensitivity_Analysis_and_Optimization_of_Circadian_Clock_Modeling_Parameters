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



inputs_def.IOCsol.N_IOCcost=1;
inputs_def.IOCsol.u_interp='stepf';
inputs_def.IOCsol.tf_type='fixed';            % Type of experiment duration: 'fixed' | 'od' (to be designed)

inputs_def.IOCsol.y0=[];


inputs_def.exps.n_exp=20;   
for iexp=inputs_def.exps.n_exp:-1:1
inputs_def.IOCsol.u_min{iexp}=[];
inputs_def.IOCsol.u_max{iexp}=[];
inputs_def.IOCsol.u_guess{iexp}=[];
inputs_def.IOCsol.tf_guess{iexp}=[];
inputs_def.IOCsol.t_con{iexp}=[];
inputs_def.IOCsol.n_steps{iexp}=[];
inputs_def.IOCsol.n_linear{iexp}=[];
inputs_def.IOCsol.n_pulses{iexp}=[];
inputs_def.IOCsol.min_stepduration{iexp}=[];        % For step or linear interpolation 
inputs_def.IOCsol.max_stepduration{iexp}=[];        % For step or linear interpolation 
end
inputs_def.IOCsol.death_penalty='off';
inputs_def.IOCsol.n_const_eq_tf=0;
inputs_def.IOCsol.const_eq_tf=[];
inputs_def.IOCsol.n_const_ineq_tf=0;
inputs_def.IOCsol.const_ineq_tf=[];
inputs_def.IOCsol.n_control_const=0;
inputs_def.IOCsol.ioccost_type='min';
inputs_def.IOCsol.ioccost='AMIGO_IOCcost';
inputs_def.IOCsol.ioccostJac_type=[];         % type of the Jacobian: [user_pecostjac, mkl, lsq,llk] see details in AMIGO_PEJac
inputs_def.IOCsol.ioccostJac_fun = [];           % user defined Jacobian as function handler
inputs_def.IOCsol.ioccostJac_file = [];          % user defined Jacobian as a file
inputs_def.IOCsol.ioccost_type='lsq';
inputs_def.IOCsol.lsq_type='QI';
inputs_def.IOCsol.llk_type='homo_var';
inputs_def.IOCsol.eq_const_max_viol=1.0e-5;
inputs_def.IOCsol.ineq_const_max_viol=1.0e-5;
inputs_def.IOCsol.n_wsm=10;
inputs_def.IOCsol.wsm_mat=[];
inputs_def.IOCsol.n_pconst_ineq=0;         % Number of point constraints 
inputs_def.IOCsol.tpointc=[];              % Times for point contraints
inputs_def.IOCsol.n_control_const=0;
inputs_def.IOCsol.control_const=[];         % c(u)<=0
inputs_def.IOCsol.control_const_max_viol=1.0e-5;
inputs_def.IOCsol.tf_min=0;
inputs_def.IOCsol.tf_max=[]; 
inputs_def.IOCsol.user_cost=0;                 % The user may need to modify the generated cost function
inputs_def.IOCsol.uttReg=0;                    % Regularization the time second order derivative - u
inputs_def.IOCsol.id_par=[];                   % parameters or sustained stimuli to be optimised                 

inputs_def.IOCsol.par_guess=[];
inputs_def.IOCsol.par_max=[];
inputs_def.IOCsol.par_min=[];
inputs_def.IOCsol.n_par=0;

inputs_def.IOCsol.id_y0=[];                   % initial conditions to be designed
inputs_def.IOCsol.y0_max=[];                  % Maximum allowed values for the initial conditions
inputs_def.IOCsol.y0_min= [ ];                % Minimum allowed values for the initial conditions
inputs_def.IOCsol.y0_guess= [ ]; 
inputs_def.IOCsol.n_y0=0;




inputs_def.model.reg_u=1;   % This is to modify the model to include regularization in the control for ido
inputs_def.model.rep_par=1; % This it to modify the cost function to include regularization term (Tikhonov)
inputs_def.model.beta=0;    % Regularization for parameters --- by default there is no regularisation; beta can take any real value
inputs_def.model.alpha=0;    % Regularization for parameters --- by default there is no regularisation; beta can take any real value

inputs_def.IOCsol.u_ref=[];                   % References for regularization
inputs_def.IOCsol.par_ref=[];


inputs_def.IOCsol.smoothing=0;  % 0 or >0; smoothing on the control
inputs_def.IOCsol.uttRegg=0;    % 0 or >0: penalty on the control second order derivative with respect to time
