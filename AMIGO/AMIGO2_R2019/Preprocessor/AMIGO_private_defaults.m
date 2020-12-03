 % $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_private_defaults.m 2482 2016-02-11 14:36:32Z evabalsa $

function [inputs_def]= AMIGO_private_defaults()
% AMIGO_private_defaults: Assign defaults that may not be modified by user
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% AMIGO_private_defaults                                                      %
% Code development:     Eva Balsa-Canto, Attila Gábor, David Henriques        %
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

inputs_def.input_file = [];                 % if the input is in a file, stores the filename.
inputs_def.save_results = true;                 % save the results of AMIGO_PE in file
inputs_def.model.debugmode = 0;       % 1 means a debug compilation with MEX.
inputs_def.ivpsol.nthreads=1;
%----------------------------------------------------------------------------------------------------------------
%
% MODEL RELATED DATA
%
inputs_def.model.input_model_type = 'charmodelM';  % Model introduction: 'charmodelC'|'charmodelF'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'sbmlmodelM'|'fortranmodel'|
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
inputs_def.model.uns=0;                 % Number of sigmoids for u interpolation in IPE
inputs_def.model.ydot=[];               % ??
inputs_def.model.n_stimulus=0;          % number of stimulus
inputs_def.model.eqns_type='odes';      % ?? what else possible?
inputs_def.model.eqns=[];               % equations?
inputs_def.model.mass_matrix=[];        % mass matrix for DAE systems
inputs_def.model.exe_type=[];           % ???
inputs_def.model.sens_file=[];          % ???

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
inputs_def.model.matlabmodel_file='fcnm'; % Default name for matlab and sbml (do not change)

inputs_def.model.st_max = [];
inputs_def.model.st_min = [];

inputs_def.model.reaction_names=[]; 
inputs_def.model.reactions='';

inputs_def.model.reg_u=0;   % This is to modify the model to include regularization in the control for ido


inputs_def.model.time_symbol='t';   % Time symbol by default
%----------------------------------------------------------------------------------------------------------------
%
% EXPERIMENTAL SCHEME RELATED DATA
%

inputs_def.exps.n_exp=20; %180                  % number of maximum default experiments
inputs_def.exps.NLObs = false;          % Indicates if the observables are nonlinear or depends on optimization parameters: sensitivities of the observables are computed from the state-sensitivities.

for iexp=inputs_def.exps.n_exp:-1:1
    inputs_def.exps.n_obs{iexp}=[];         % number of observables in the experiment
    inputs_def.exps.obs_names{iexp}=[];     % obs names per experiment
    inputs_def.exps.obs{iexp}=[];           % equations for the observables (as a function of states)
    inputs_def.exps.index_observables{iexp}=[]; % indicis of the observables (i : y_i = x_i)
    
    
    inputs_def.exps.ts_type{iexp}='eq';   % sampling times equidistant, what else can be ????
    inputs_def.exps.t_in{iexp}=0;         % initial time
    inputs_def.exps.ts_0{iexp}=0;         % first sampling time
    inputs_def.exps.n_s{iexp}=[];         % number of sampling times by default
    inputs_def.exps.max_ns{iexp}=[];       % maximum number of sampling times in OED
    inputs_def.exps.t_s{iexp}=[];         % sampling times
    inputs_def.exps.error_data{iexp}=[];  % error_data
    inputs_def.exps.exp_data{iexp}=[];    % exp_data
    inputs_def.exps.missing_data{iexp}=false; % indicates of the experiments contain missing data. 
    inputs_def.exps.nanfilter{iexp}=[];    % logical matrix indicating the not nan elements of the exp_data ( to treat missing data problem).
    inputs_def.exps.missing_data{iexp}=false; % by default data is not missing
    inputs_def.exps.u_interp{iexp}='linear'; % by default linear interpolation, what else can be ???
    inputs_def.exps.exp_y0{iexp}=[];        % initial consitions for states
    inputs_def.exps.t_f{iexp}=[];           % final time  
    inputs_def.exps.tf_min{iexp}=[];        % minimum final time (for OED)
    inputs_def.exps.tf_max{iexp}=[];        % maximum final time (for OED)
    inputs_def.exps.ts_min_dist{iexp}=[];   % minimum distance between sampling times for OED
    inputs_def.exps.id_y0{iexp}=[];         % ???
    inputs_def.exps.tcon_guess{iexp}=[];    % control switching times for OED 
    inputs_def.exps.t_con{iexp}=[];         % control switching times 
    inputs_def.exps.n_con{iexp}=[];         % number of control discretization elements
end
for iexp=inputs_def.exps.n_exp:-1:1
    inputs_def.exps.u{iexp}=[];             % control values
    inputs_def.exps.n_steps{iexp}=[];       % number of control discretization elements-steps
    inputs_def.exps.n_linear{iexp}=[];      % number of control discretization elements-linear
    inputs_def.exps.n_pulses{iexp}=[];      % number of control discretization elements-pulses
    inputs_def.exps.pend{iexp}=[];          % slope for linear interpolation
    inputs_def.exps.w_obs{iexp}=[];         % weigthing for observables (for OED)
    inputs_def.exps.Q{iexp}=[];             % weigthing matrix for the objective function
    inputs_def.exps.t_int{iexp}=[];         % ??
    inputs_def.exps.u_delay_flag{iexp}=0;   % Input delay: 0 (no delay) | 1 (delay)
    inputs_def.exps.u_delay_type{iexp}='par'; % Type of delay for inputs
    inputs_def.exps.u_delay{iexp}=char('udelay=0'); % Delay defined for inputs; by default there is no delay
end
inputs_def.exps.data_type='pseudo';    % Pseudo-experimental data will be computed if not provided
inputs_def.exps.noise_type='homo_var'; % Type of noise assumed for experimental data
for iexp=inputs_def.exps.n_exp:-1:1
    inputs_def.exps.std_dev{iexp}=[];      % Noise Standard deviation for pseudo-experimental data  no default
    inputs_def.exps.std_deva{iexp} = [];  % homo_lin case
    inputs_def.exps.std_devb{iexp} = [];
end

inputs_def.exps.exp_y0_fpar=0;     % Experimental contions obtained from parameters 0:No; 1:yes
inputs_def.exps.function_y0_par=[];     % Name of the function defining initial conditions from parameters
%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------
%
% PARAMETER ESTIMATION RELATED DATA
%
inputs_def.PEsol.cost_file='AMIGO_PEcost';     % ???

inputs_def.PEsol.PEcost_type='lsq';            % by default least squares is used What else??? [user_PEcost , ... ]
inputs_def.PEsol.PEcost_file = [];                   % user defined PEcost file
inputs_def.PEsol.PEcost_fun = [];                    % user defined PEcost function handler
inputs_def.PEsol.lsq_type='Q_I';               % type of least squares by default [Q_mat | Q_I | Q_exp | Q_expmax | Q_expmean]
inputs_def.PEsol.llk_type=inputs_def.exps.noise_type;  % Log likelihood function type 

inputs_def.PEsol.PEcostJac_type=[];         % type of the Jacobian: [user_pecostjac, mkl, lsq,llk] see details in AMIGO_PEJac
inputs_def.PEsol.PEcostJac_fun = [];           % user defined Jacobian as function handler
inputs_def.PEsol.PEcostJac_file = [];          % user defined Jacobian as a file

inputs_def.PEsol.id_global_theta='all';        % by default all parameters will be estimated
inputs_def.PEsol.id_global_theta_y0='none';    % by default no global initial conditions are to be estimated
inputs_def.PEsol.n_global_theta_y0=0;          % no global initial condiion is estimated

inputs_def.PEsol.global_theta_min=[ ];          % global parameters lower bound
inputs_def.PEsol.global_theta_max=[ ];          % global parameters upper bound
inputs_def.PEsol.global_theta_guess=[];         % global parameters initial guess

inputs_def.PEsol.global_theta_y0_min=[];        % ?? estimated global initial condition lower bound 
inputs_def.PEsol.global_theta_y0_max=[] ;       % ?? estimated global initial condition upper bound 
inputs_def.PEsol.global_theta_y0_guess=[];      % ?? estimated global initial condition initial guess
inputs_def.PEsol.n_global_theta=[];             % number of global estimated parameters
inputs_def.PEsol.index_global_theta=[];         % ?
inputs_def.PEsol.ntotal_local_theta=[];         % ??
inputs_def.PEsol.n_theta=[];                    % ??
inputs_def.PEsol.ntotal_local_theta_y0=[];      % ??
inputs_def.PEsol.n_theta_y0=[];                 % ??
inputs_def.PEsol.ntotal_theta=[];               % ??
inputs_def.PEsol.index_global_theta_y0=[];      % ??
inputs_def.PEsol.vtheta_guess=[];               % ??
inputs_def.PEsol.vtheta_min=[];                 % ??
inputs_def.PEsol.vtheta_max=[];                 % ??
inputs_def.PEsol.upar_guess=[];

for iexp=inputs_def.exps.n_exp:-1:1
    inputs_def.PEsol.id_local_theta{iexp}= 'none';   % by default no local parameters are to be estimated
    inputs_def.PEsol.n_local_theta{iexp}=0;          % by default no local parameters are to be estimated
    inputs_def.PEsol.id_local_theta_y0{iexp}='none'; % by default no local initial conditions are to be estimated
    inputs_def.PEsol.n_local_theta_y0{iexp}=0;       % by default no local initial conditions are to be estimated
    inputs_def.PEsol.local_theta_min{iexp}=[ ];      % estimated local parameters lower bound 
    inputs_def.PEsol.local_theta_max{iexp}=[ ] ;     % estimated local parameters upper bound 
    inputs_def.PEsol.local_theta_guess{iexp}=0.5.*(inputs_def.PEsol.local_theta_max{iexp}-inputs_def.PEsol.local_theta_min{iexp});
    inputs_def.PEsol.local_theta_y0_min{iexp}=[ ];  % estimated local initial conditions lower bound 
    inputs_def.PEsol.local_theta_y0_max{iexp}=[ ];  % estimated local initial conditions upper bound 
    inputs_def.PEsol.local_theta_y0_guess{iexp}=0.5.*(inputs_def.PEsol.local_theta_y0_max{iexp}-inputs_def.PEsol.local_theta_y0_min{iexp});
    
    inputs_def.PEsol.n_const_ineq_tf{iexp}=0;       % ???
    inputs_def.PEsol.index_local_theta{iexp}=[ ];   % ???
    inputs_def.PEsol.index_local_theta_y0{iexp}=[ ];% ???
end

inputs_def.PEsol.GRankmethod='lhs';
inputs_def.PEsol.CramerRao=1;
inputs_def.PEsol.log_var = [];    % parameter indices to scale to logarithm in the local search.

inputs_def.PEsol.lin_scaled_var =[]; % select which optim variables are scaled
inputs_def.PEsol.lin_scaled_factor =[]; % scaling factor for the linearly scaled optim variables.
%--------------------------------------------------------------------------
%
% OPTIMIZATION RELATED DATA
%
inputs_def.nlpsol.global_solver=[];           % For hybrids
inputs_def.nlpsol.nlpsolver='eSS';              % NLP solver
% these should be defined for each Opt solver:
%inputs_def.nlpsol.maxeval= Inf;                %Maximum number of function evaluations (Default 1000)
%inputs_def.nlpsol.maxtime= 60;                 %Maximum CPU time in seconds (Default 60)
inputs_def.nlpsol.iterprint=1;                  %Print each iteration on screen: 0-Deactivated 1-Activated (Default 1)


%Local options
inputs_def.nlpsol.local = local_options();  % call the local options file

inputs_def.nlpsol.local_solver ='';         %local solver for global(hybrid) optimization(!), set up in the code.
inputs_def.nlpsol.cvodes_gradient=1;        % ???
inputs_def.nlpsol.mkl_gradient=0;           % ???
inputs_def.nlpsol.mkl_tol=1e-3;             % relative tolerance for MKLJac
    
inputs_def.nlpsol.eSS = ess_options_defaults;       % call eSS default options

inputs_def.nlpsol.DE = de_options_defaults;            % call DE default options

inputs_def.nlpsol.globalm = globalm_options_defaults;  % call ??
    
inputs_def.nlpsol.SRES = sres_options_defaults;        % call SRES default options
inputs_def.nlpsol.nsga2 = nsga2_options_defaults;        % call NSGA2 default options
inputs_def.nlpsol.multistart.maxeval = 5000;
inputs_def.nlpsol.multistart.maxtime = 60;
inputs_def.nlpsol.multistart.iterprint=1;
inputs_def.nlpsol.multi_starts=200;               % Number of different initial guesses to run local methods in the multistart approach
inputs_def.nlpsol.reopt='off';
inputs_def.nlpsol.reopt_local_solver=[]; 
inputs_def.nlpsol.n_reopts=0; 
inputs_def.nlpsol.regularization = regularization_options_defaults; % call regularization options.
%--------------------------------------------------------------------------
%
% OPTIMAL EXPERIMENTAL DESIGN RELATED DATA
%
for iexp=inputs_def.exps.n_exp:-1:1
    inputs_def.exps.exp_type{iexp}='fixed';                 % Type of experiment: 'fixed' | 'od' (to be designed) --> this default will be used for all tasks
    inputs_def.exps.exp_y0_type{iexp}='fixed';              % Type of initial conditions: 'fixed' | 'od' (to be designed)
    inputs_def.exps.tf_type{iexp}='fixed';                  % Type of experiment duration: 'fixed' | 'od' (to be designed)
    inputs_def.exps.u_type{iexp}='fixed';                   % Type of stimulation: 'fixed' | 'od' (to be designed)
    inputs_def.exps.ts_type{iexp}='fixed';                  % Type of sampling times: 'fixed' | 'od' (to be designed)
    inputs_def.exps.obs_type{iexp}='fixed';                 % Type of observation function: 'fixed' | 'od' (to be designed)
    inputs_def.exps.u_min{iexp}=[];                         % ?
    inputs_def.exps.u_max{iexp}=[];                         % ?
    inputs_def.exps.u_guess{iexp}=[];                       % ?
    inputs_def.exps.t_in{iexp}=0; 
    inputs_def.exps.tf_guess{iexp}=[];                      % ?
    inputs_def.exps.y0_min{iexp}=[];                      	% ?
    inputs_def.exps.y0_max{iexp}=[];                        % ?
    inputs_def.exps.y0_guess{iexp}=[];                      % ?
    inputs_def.exps.ts_min_dist{iexp}=[];                   % ?
    inputs_def.exps.n_const_ineq_tf{iexp}=0;                % ?
    inputs_def.exps.const_ineq_tf{iexp}=[];     
    inputs_def.exps.n_const_eq_tf{iexp}=0;                  % ?
    inputs_def.exps.n_control_const{iexp}=0;                % ?
    inputs_def.exps.fixed_exps=0;                           % ?
    inputs_def.exps.max_obs{iexp}=[];                       % ?
    inputs_def.exps.index_obs_guess{iexp}=[];
    inputs_def.exps.index_obs_min{iexp}=[];
    inputs_def.exps.index_obs_max{iexp}=[];
end

 inputs_def.exps.count_success_ivp=0;                       
 inputs_def.exps.count_success_sens=0;
 inputs_def.exps.count_failed_ivp=0;                       
 inputs_def.exps.count_failed_sens=0;
 inputs_def.exps.ineq_const_max_viol=1.0e-5;                % Maximum constraint violation
inputs_def.OEDsol.cost_file='AMIGO_OEDcost';                % ? 
inputs_def.OEDsol.OEDcost_type='Eopt';                      % ?
inputs_def.OEDsol.n_obs_od=0;                               % ?

%----------------------------------------------------------------------------------------------------------------
%
% PATHS RELATED DATA
%
inputs_def.pathd.print_details = 0;     % DEBUG flag: print text, when enter/leave AMIGO_PEcost and AMIGO_PEcostjac
inputs_def.pathd.results_folder='Problem';                                                      % Name of the folder to keep results for a given problem
inputs_def.pathd.results_path='Results';        % General name of the folder to keep results
                                     
% ADVISE: the user may introduce any name related to the problem at hand 
inputs_def.pathd.report_name='report';          % Name of the report file to be created
inputs_def.pathd.struct_name='strreport';       % Name of the matlab structure to keep inputs and results
inputs_def.pathd.short_name='problem';          % Short name, will be used to generate specific problem folders/files
                                                 % ADVISE: the user may introduce any name related to the problem at hand
inputs_def.pathd.runident='run1';               % Identifier required in order not to overwrite previous results
inputs_def.pathd.run_overwrite='on';           % On/off to allow overwriting runs with the same run identifier

inputs_def.pathd.runident_cl=[];
inputs_def.pathd.AMIGO_path=[];

inputs_def.pathd.problem_folder_path = [];
inputs_def.pathd.task_folder = [];
inputs_def.pathd.states_plot_path = [];
inputs_def.pathd.residuals_plot_path=[];
inputs_def.pathd.multistart_hist=[];
inputs_def.pathd.fit_plot_path=[];
inputs_def.pathd.data_plot_path=[];
inputs_def.pathd.conv_curve_path=[];
inputs_def.pathd.corr_mat_path=[];
inputs_def.pathd.sens_path=[];
inputs_def.pathd.sens_par_path=[];
inputs_def.pathd.obs_plot_path=[];
inputs_def.pathd.obs_function= [];
inputs_def.pathd.obs_sens_function = [];
inputs_def.pathd.obs_sens_file = [];
inputs_def.pathd.obs_file=[];
inputs_def.pathd.report=[];
inputs_def.pathd.struct_results=[];
inputs_def.pathd.input_file=[];
inputs_def.pathd.FIM=[];
inputs_def.pathd.ranking_pars=[];
inputs_def.pathd.ranking_y0=[];
inputs_def.pathd.sens_mat_path = [];
inputs_def.pathd.sens_mat_clust_path = [];  % path to sensitivity matrix clustering figures.
inputs_def.pathd.sens_time_path = [];
inputs_def.pathd.pred_vs_obs_path = [];
inputs_def.pathd.force_gen_obs = 1;   % set to zero if the observation function should not be generated.

%----------------------------------------------------------------------------------------------------------------
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

%----------------------------------------------------------------------------------------------------------------
%
%DYNAMIC OPTIMIZATION DATA (required for preprocessing) 
%

AMIGO_DOsol_defaults
AMIGO_IOCsol_defaults


%--------------------------------------------------------------------------
%Others
inputs_def.model.obsfile = 1;     % ?

global n_amigo_sim_success;
global n_amigo_sim_failed;
global n_amigo_sens_success;
global n_amigo_sens_failed;

n_amigo_sim_success=0;
n_amigo_sim_failed=0;
n_amigo_sens_success=0;
n_amigo_sens_failed=0;



return
