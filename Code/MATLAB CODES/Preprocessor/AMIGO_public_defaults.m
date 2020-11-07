% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_public_defaults.m 2457 2015-12-15 14:32:25Z evabalsa $

function [inputs_def]= AMIGO_public_defaults(inputs_def)
%function [inputs_def,results_def]= AMIGO_public_defaults(inputs_def);
% AMIGO_private_defaults: Assign defaults that MAY be modified by user 
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
%  AMIGO_check_tasks: Assign defaults that MAY be modified by user            % 
%*****************************************************************************%

%----------------------------------------------------------------------------------------------------------------
%
% PATHS RELATED DATA
%
inputs_def.pathd.results_path='Results';          % General name of the folder to keep results
inputs_def.pathd.results_folder='Problem';        % Name of the folder to keep results for a given problem
                                                  % ADVISE: the user may introduce any name related to the problem at hand 
inputs_def.pathd.report_name='report';            % Name of the report file to be created
inputs_def.pathd.struct_name='strreport';         % Name of the matlab structure to keep inputs and results
inputs_def.pathd.short_name='problem';            % Short name, will be used to generate specific problem folders/files
                                                  % ADVISE: the user may introduce any name related to the problem at hand
inputs_def.pathd.runident='run1';                 % Identifier required in order not to overwrite previous results
inputs_def.pathd.run_overwrite='on';              % On/off to allow overwriting runs with the same run identifier

inputs_def.pathd.runident_cl=[];
inputs_def.pathd.AMIGO_path=[];

inputs_def.pathd.problem_folder_path = [];
inputs_def.pathd.task_folder = [];
inputs_def.pathd.residuals_plot_path = [];
%----------------------------------------------------------------------------------------------------------------
%
% PLOTS RELATED INFORMATION
%
inputs_def.plotd.plotlevel='medium';            % Display of results: 'full'|'medium'|'min' | 'noplot' 
inputs_def.plotd.epssave=0;                     % Figures may be saved in .eps (1) or only in .fig format (0)

inputs_def.plotd.fit_plot='fit_plot';           % Name of best fit plots 'fit_plot'_exp*.fig/.eps
inputs_def.plotd.data_plot='data_plot';         % Name of experimental data plots 'data_plot'_exp*.fig/.eps
inputs_def.plotd.data_plot_title='';            % Title of of experimental data plots
inputs_def.plotd.residuals_plot='residuals';    % Name of best fit corresponding residuals 'residuals'_exp*.fig/.eps
inputs_def.plotd.states_plot='states_plot';     % Name of states plot 'states_plot'_exp*_n.fig/.eps

inputs_def.plotd.number_max_states=9;           % Maximum number of states per figure
inputs_def.plotd.obs_plot='obs_plot';           % Name of observables plot 'obs_plot'_exp*_n.fig/.eps
inputs_def.plotd.number_max_obs=9;              % Maximum number of observables per figure
inputs_def.plotd.n_t_plot=100;                   % Number of times to be used for observables and states plots
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
inputs_def.plotd.u_plot='u_plot';
inputs_def.plotd.pareto_plot='pareto';

%----------------------------------------------------------------------------------------------------------------
%
% NUMERICAL METHODS RELATED DATA
%
 
inputs_def.ivpsol.rtol=1.0D-5;                   % Default IVP solver integration tolerances
inputs_def.ivpsol.atol=1.0D-7; 

inputs_def.nlpsol.nlpsolver='eSS';              % Default GLOBAL NLP solver. Several alternatives may be selected here:
                                                % 'de', 'sres', 'ssm','multistart', 'local'. 
                                                % Note that the corresponding defaults are in files: 
                                                % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
                                                % OPT_solvers\SSm_**\ssm_options.m 
                                                
                                           
inputs_def.nlpsol.multi_starts=500;               % Number of different initial guesses to run local methods in the multistart approach
     
inputs_def.rid.conf_ntrials=500;              % Number of trials for the robust confidence computation
inputs_def.rank.gr_samples=10000;              % Number of samples for global sensitivities and global rank within LHS                             

%
%   SYMBOLIC COMPUTATION RELATED DATA
%

inputs_def.model.AMIGOjac = 0;          % set 1 to compute the system's Jacobian analytically to pass to CVODE
inputs_def.model.J = char();                % system's Jacobian (with respect to the states: dfdx)in C format for CVODE 
inputs_def.model.AMIGOsensrhs = 0;      % set 1 to compute the exact right hand side of the sensitivity eqns for CVODES
inputs_def.model.Jpar = char();                % system's Jacobian with respect to the parameters dfdp
inputs_def.model.shownetwork = 0;       % show the model in Cytoscape.
% inputs_def.pathd=results_def.pathd;
% inputs_def.plotd=results_def.plotd;

return