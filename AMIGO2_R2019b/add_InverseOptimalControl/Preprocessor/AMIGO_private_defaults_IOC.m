% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/add_DynamicOpt/Preprocessor/AMIGO_private_defaults_OD.m 770 2013-08-06 09:41:45Z attila $

function [inputs_def]= AMIGO_private_defaults_DO()
% AMIGO_private_defaults: Assign defaults that may not be modified by user 
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
%  AMIGO_check_tasks: Assign defaults that may not be modified by user        % 
%*****************************************************************************%


%----------------------------------------------------------------------------------------------------------------
%
% MODEL RELATED DATA
%
inputs_def.model.input_model_type = 'charmodelM';  % Model introduction: 'charmodelC'|'charmodelF'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|
inputs_def.model.matlabmodel_file='';
inputs_def.model.names_type='custom';   % by default user selected names; 'standard' names: x1,x2,...p1,p2...,y1,y2...
inputs_def.model.blackboxmodel_file='';
inputs_def.model.st_names=[];           % state names
inputs_def.model.dst_names=[];           % state names
inputs_def.model.n_st=[];               % number of states
inputs_def.model.par_names=[];          % names of parameters
inputs_def.model.n_par=[];              % number of parameters
inputs_def.model.par=[];                % numerical values of the parameters
inputs_def.model.stimulus_names=[];     % stimulus names
inputs_def.model.ydot=[];               % ??
inputs_def.model.n_stimulus=0;          % number of stimulus
inputs_def.model.eqns_type='odes';      % ?? what else possible?
inputs_def.model.eqns=[];               % equations?
inputs_def.model.mass_matrix=[];        % mass matrix for DAE systems
inputs_def.model.exe_type='standard';         
inputs_def.model.sens_file=[];          % ???
inputs_def.model.obsfile='';
inputs_def.model.odes_file='';          % ???
inputs_def.model.mexfile='';            % ???
inputs_def.model.mexfunction='';        % ???
inputs_def.model.use_user_obs=[];       % ???
inputs_def.model.use_user_sens_obs=[];  % ???
inputs_def.model.AMIGOjac = 0;          % set 1 to compute the system's Jacobian analytically and pass to CVODE
inputs_def.model.J = char();                % system's Jacobian (with respect to the states: dfdx)in C format for CVODE 
inputs_def.model.AMIGOsensrhs = 0;      % set 1 to compute the exact right hand side of the sensitivity eqns for CVODES
inputs_def.model.positiveStates = 0;    % 1: includes a positivity check in the AMIGO_rhs in CVODES
inputs_def.model.Jpar = char();                % system's Jacobian with respect to the parameters dfdp
inputs_def.model.overwrite_model = 1;          % set 1 to compute the system's Jacobian analytically and pass to CVODE
inputs_def.model.cvodes_include = {};          % set 1 to compute the system's Jacobian analytically and pass to CVODE
inputs_def.model.matlabmodel_file = [];

inputs_def.model.st_max = [];
inputs_def.model.st_min = [];
inputs_def.pathd.print_details = 0;     % DEBUG flag: print text, when enter/leave AMIGO_PEcost and AMIGO_PEcostjac


%----------------------------------------------------------------------------------------------------------------
%
% EXPERIMENTAL SCHEME RELATED DATA
%

inputs_def.exps.n_exp=20;               % number of maximum default experiments
for iexp=inputs_def.exps.n_exp:-1:1
inputs_def.exps.n_obs{iexp}=[];         % number of observables in the experiment
inputs_def.exps.obs_names{iexp}=[];     % obs names per experiment
inputs_def.exps.obs{iexp}=[];           % equations for the observables (as a function of states)
inputs_def.exps.index_observables{iexp}=[]; % indicis of the observables (i : y_i = x_i)
inputs_def.exps.ts_type{iexp}='eq';     % sampling times equidistant
inputs_def.exps.tf_type{iexp}='fixed';  % final time
inputs_def.exps.t_in{iexp}=0;           % initial time
inputs_def.exps.ts_0{iexp}=0;           % first sampling time
inputs_def.exps.n_s{iexp}=2;            % number of sampling times by default
inputs_def.exps.max_ns{iexp}=2;         % number of sampling times by default
inputs_def.exps.t_s{iexp}=[];           % sampling times
inputs_def.exps.ts_min_dist{iexp}=[];
inputs_def.exps.obs_names{iexp}=[];     % obs names per experiment
inputs_def.exps.obs{iexp}=[];           % obs  per experiment
inputs_def.exps.id_y0{iexp}=[];         % selected obs  per experiment
inputs_def.exps.exp_data{iexp}=[];   % exp_data
inputs_def.exps.error_data{iexp}=[];
inputs_def.exps.u_interp{iexp}='stepf'; % by default linear interpolation
inputs_def.exps.exp_y0{iexp}=[];
inputs_def.exps.y0_min{iexp}=[];      
inputs_def.exps.y0_max{iexp}=[];
inputs_def.exps.y0_guess{iexp}=[];
inputs_def.exps.t_f{iexp}=[];
inputs_def.exps.u{iexp}=[];    
inputs_def.exps.n_steps{iexp}=[];
inputs_def.exps.n_linear{iexp}=[];
inputs_def.exps.n_pulses{iexp}=[];
inputs_def.exps.noise_type{iexp}=[];
inputs_def.exps.std_dev{iexp}=[];
inputs_def.exps.NLObs=0;
inputs_def.exps.exp_type{iexp}='fixed';                 % Type of experiment: 'fixed' | 'od' (to be designed) --> this default will be used for all tasks
inputs_def.exps.exp_y0_type{iexp}='fixed';              % Type of initial conditions: 'fixed' | 'od' (to be designed)
inputs_def.exps.tf_type{iexp}='fixed';                  % Type of experiment duration: 'fixed' | 'od' (to be designed)
inputs_def.exps.u_type{iexp}='fixed';                   % Type of stimulation: 'fixed' | 'od' (to be designed)
inputs_def.exps.ts_type{iexp}='fixed';                  % Type of sampling times: 'fixed' | 'od' (to be designed)
inputs_def.exps.obs_type{iexp}='fixed';                 % Type of observation function: 'fixed' | 'od' (to be designed)
end
inputs_def.exps.data_type='real';
%----------------------------------------------------------------------------------------------------------------
%
% SIMULATION RELATED DATA
%

inputs_def.ivpsol.ivpsolver=[];                 %'cvodes';           % IVP solver   what else?
inputs_def.ivpsol.senssolver=[];                %'cvodes';           % sensitivity solver what else?
inputs_def.ivpsol.rtol=1.0D-7;                  % Default IVP solver integration tolerances
inputs_def.ivpsol.atol=1.0D-7;                  % absolut tolerance
inputs_def.ivpsol.ivpmex=[];                    % ???
inputs_def.ivpsol.sensmex=[];                   % ???
inputs_def.ivpsol.max_step_size=Inf;            % for cvodes
inputs_def.ivpsol.ivp_maxnumsteps = 1000000;      % max. number of steps in CVODES ivpsol
inputs_def.ivpsol.sens_maxnumsteps = 1000000;     % max. number of steps in CVODES sens
inputs_def.ivpsol.reinitsolver = false;     % max. number of steps in CVODES sens
%----------------------------------------------------------------------------------------------------------------
%
% OPTIMIZATION RELATED DATA
%
inputs_def.nlpsol.options_file=[];

%--------------------------------------------------------------------------
%
% OPTIMIZATION RELATED DATA
%
inputs_def.nlpsol.global_solver='eSS';          % ???
inputs_def.nlpsol.nlpsolver='eSS';              % ???
% these should be defined for each Opt solver:
%inputs_def.nlpsol.maxeval= Inf;                          %Maximum number of function evaluations (Default 1000)
%inputs_def.nlpsol.maxtime= 60;                           %Maximum CPU time in seconds (Default 60)

inputs_def.nlpsol.iterprint=1;                           %Print each iteration on screen: 0-Deactivated 1-Activated (Default 1)
inputs_def.nlpsol.reopt='off';

%Local options
inputs_def.nlpsol.local = local_options();  % call the local options file


inputs_def.nlpsol.cvodes_gradient=1;        % ???
inputs_def.nlpsol.mkl_gradient=0;           % ???
inputs_def.nlpsol.mkl_tol=1e-3;             % ???
    
inputs_def.nlpsol.eSS = ess_options_defaults;          % call eSS default options

inputs_def.nlpsol.DE = de_options_defaults;            % call DE default options

inputs_def.nlpsol.globalm = globalm_options_defaults;  % call ??
    
inputs_def.nlpsol.SRES = sres_options_defaults;        % call SRES default options
inputs_def.nlpsol.nsga2 = nsga2_options_defaults;        % call NSGA2 default options

inputs_def.nlpsol.multistart.maxeval = 5000;
inputs_def.nlpsol.multistart.maxtime = 60;
inputs_def.nlpsol.multistart.iterprint=1;
inputs_def.nlpsol.multi_starts=200;               % Number of different initial guesses to run local methods in the multistart approach

inputs_def.nlpsol.regularization = regularization_options_defaults; % call regularization options.
inputs_def.nlpsol.reopt_local_solver=[]; 
inputs_def.nlpsol.n_reOpts=0; 
inputs_def.nlpsol.reopt_solver='local';

%----------------------------------------------------------------------------------------------------------------
%
% PARAMETER ESTIMATION RELATED DATA
%


inputs_def.PEsol.id_global_theta='all';        % by default all parameters will be estimated
inputs_def.PEsol.id_global_theta_y0='none';    % by default no global initial conditions are to be estimated
inputs_def.PEsol.n_global_theta_y0=0;
inputs_def.PEsol.global_theta_guess=[];

for iexp=inputs_def.exps.n_exp:-1:1
inputs_def.PEsol.id_local_theta{iexp}= 'none';   % by default no local parameters are to be estimated
inputs_def.PEsol.n_local_theta{iexp}=0;          % by default no local parameters are to be estimated
inputs_def.PEsol.id_local_theta_y0{iexp}='none'; % by default no local initial conditions are to be estimated
inputs_def.PEsol.n_local_theta_y0{iexp}=0;       % by default no local initial conditions are to be estimated
%OED related data

    inputs_def.exps.u_delay_flag{iexp}=0;   % Input delay: 0 (no delay) | 1 (delay)
    inputs_def.exps.u_delay_type{iexp}='par'; % Type of delay for inputs
    inputs_def.exps.u_delay{iexp}=char('udelay=0'); % Delay defined for inputs; by default there is no delay
end
inputs_def.OEDsol=[];                         % OEDsol is not necessary for DO but we need to declare it
inputs_def.DOsol.id_par=[];
inputs_def.DOsol.n_par=0;



%----------------------------------------------------------------------------------------------------------------
%
%DYNAMIC OPTIMIZATION DATA
%

inputs_def.DOsol.n_par=0;

AMIGO_IOCsol_defaults

inputs_def.nlpsol.global_solver='';


inputs_def.pathd.run_overwrite='on';           % On/off to allow overwriting runs with the same run identifier

inputs_def.pathd.ioc_function=[];
inputs_def.pathd.ioc_constraints=[];
inputs_def.pathd.force_gen_obs=1;
inputs_def.pathd.pred_vs_obs_path = [];
inputs_def.pathd.fit_plot_path=[];
inputs_def.plotd.figsave = 1;                   % Figures are saved in .fig by default

%
% PLOTS RELATED INFORMATION
%
inputs_def.plotd.plotlevel='medium';            % Display of results: 'full'|'medium'|'min' | 'noplot' 
inputs_def.plotd.epssave=0;                     % Figures may be saved in .eps (1) or only in .fig format (0)
inputs_def.plotd.figsave = 1;                   % Figures are saved in .fig by default

inputs_def.plotd.fit_plot='fit_plot';           % Name of best fit plots 'fit_plot'_exp*.fig/.eps
inputs_def.plotd.data_plot='data_plot';         % Name of experimental data plots 'data_plot'_exp*.fig/.eps
inputs_def.plotd.residuals_plot='residuals';    % Name of best fit corresponding residuals 'residuals'_exp*.fig/.eps
inputs_def.plotd.states_plot='states_plot';     % Name of states plot 'states_plot'_exp*_n.fig/.eps

inputs_def.plotd.number_max_states=9;           % Maximum number of states per figure
inputs_def.plotd.obs_plot='obs_plot';           % Name of observables plot 'obs_plot'_exp*_n.fig/.eps
inputs_def.plotd.number_max_obs=9;              % Maximum number of observables per figure
inputs_def.plotd.n_t_plot=120;                   % Number of times to be used for observables and states plots
inputs_def.plotd.conf_cloud='ccloud';           % Name of the confidence region by pairs of unknowns'ccloud'_thetai_vs_thetaj.fig/.eps
inputs_def.plotd.ecc='ecc';                     % Name of the figure of the eccentricity by pairs of unknowns
inputs_def.plotd.conf_hist='conf';              % Name of the confidence region for each unknowns 'hist'_thetai.fig/.eps
inputs_def.plotd.contour_plot='contourP';       % Name of the llq/lsq contour plots by pairs of unknowns 'contourP'_thetai_vs_thetaj.fig/.eps
inputs_def.plotd.contour1D_plot='costplot';     % Name of the llq/lsq cost plots vs unknowns 'costplot'_thetai.fig/.eps
inputs_def.plotd.contour_rtol=1e-9;             % Integration tolerances for the contour plots. 
inputs_def.plotd.contour_atol=1e-9;             % ADVISE: These tolerances should be a little bit strict
inputs_def.plotd.nx_contour=60;                 % Number of points for plotting the contours x and y direction
inputs_def.plotd.ny_contour=60;                 % ADVISE: >50
inputs_def.plotd.convergence_curve='conv_curve';% Name of the NLP solver convergence curve
inputs_def.plotd.multistart_hist='hist';        % Name of the histogram of solutions for the 
                                                 % multistart of local NLP solvers                                                
inputs_def.plotd.number_max_hist=8;             % Maximum number of unknowns histograms per figure (multistart)

inputs_def.plotd.number_max_pareto=5;
inputs_def.randstate=[];
inputs_def.pathd.pest_pnom_logratio_path = [];
inputs_def.pathd.pest_err_hist_path = [];
inputs_def.pathd.pest_rel_err_hist_path = [];
inputs_def.pathd.pest_vs_pnom_path = [];
return