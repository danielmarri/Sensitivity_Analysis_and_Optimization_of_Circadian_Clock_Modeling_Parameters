% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/Preprocessor/AMIGO_public_defaults.m 1129 2013-12-02 12:35:30Z attila $

function [inputs_def]= AMIGO_public_defaults_doc(inputs_def)
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
% 
% results_def.pathd.results_path='Results';        % General name of the folder to keep results
% results_def.pathd.results_folder='Problem';      % Name of the folder to keep results for a given problem
%                                                  % ADVISE: the user may introduce any name related to the problem at hand 
% results_def.pathd.report_name='report';          % Name of the report file to be created
% results_def.pathd.struct_name='strreport';       % Name of the matlab structure to keep inputs and results
% results_def.pathd.short_name='problem';          % Short name, will be used to generate specific problem folders/files
%                                                  % ADVISE: the user may introduce any name related to the problem at hand
% results_def.pathd.runident='run1';               % Identifier required in order not to overwrite previous results
% results_def.pathd.run_overwrite='off';           % On/off to allow overwriting runs with the same run identifier
% 
% results_def.pathd.runident_cl=[];
% results_def.pathd.AMIGO_path=[];
% %----------------------------------------------------------------------------------------------------------------
% %
% % PLOTS RELATED INFORMATION
% %
% results_def.plotd.plotlevel='medium';            % Display of results: 'full'|'medium'|'min' | 'noplot' 
% results_def.plotd.epssave=0;                     % Figures may be saved in .eps (1) or only in .fig format (0)
% 
% results_def.plotd.fit_plot='fit_plot';           % Name of best fit plots 'fit_plot'_exp*.fig/.eps
% results_def.plotd.data_plot='data_plot';         % Name of experimental data plots 'data_plot'_exp*.fig/.eps
% results_def.plotd.residuals_plot='residuals';    % Name of best fit corresponding residuals 'residuals'_exp*.fig/.eps
% results_def.plotd.states_plot='states_plot';     % Name of states plot 'states_plot'_exp*_n.fig/.eps
% 
% results_def.plotd.number_max_states=9;           % Maximum number of states per figure
% results_def.plotd.obs_plot='obs_plot';           % Name of observables plot 'obs_plot'_exp*_n.fig/.eps
% results_def.plotd.number_max_obs=9;              % Maximum number of observables per figure
% results_def.plotd.n_t_plot=120;                   % Number of times to be used for observables and states plots
% results_def.plotd.conf_cloud='ccloud';           % Name of the confidence region by pairs of unknowns'ccloud'_thetai_vs_thetaj.fig/.eps
% results_def.plotd.ecc='ecc';                     % Name of the figure of the eccentricity by pairs of unknowns
% results_def.plotd.conf_hist='conf';              % Name of the confidence region for each unknowns 'hist'_thetai.fig/.eps
% results_def.plotd.contour_plot='contourP';       % Name of the llq/lsq contour plots by pairs of unknowns 'contourP'_thetai_vs_thetaj.fig/.eps
% results_def.plotd.contour1D_plot='costplot';     % Name of the llq/lsq cost plots vs unknowns 'costplot'_thetai.fig/.eps
% results_def.plotd.contour_rtol=1e-9;             % Integration tolerances for the contour plots. 
% results_def.plotd.contour_atol=1e-9;             % ADVISE: These tolerances should be a little bit strict
% results_def.plotd.nx_contour=60;                 % Number of points for plotting the contours x and y direction
% results_def.plotd.ny_contour=60;                 % ADVISE: >50
% results_def.plotd.convergence_curve='conv_curve';% Name of the NLP solver convergence curve
% results_def.plotd.multistart_hist='hist';        % Name of the histogram of solutions for the 
%                                                  % multistart of local NLP solvers                                                
% results_def.plotd.number_max_hist=8;             % Maximum number of unknowns histograms per figure (multistart)

inputs_def.pathd.results_path='General name of the folder to keep results';        % General name of the folder to keep results
inputs_def.pathd.results_folder='Name of the folder to keep results for a given problem';      % Name of the folder to keep results for a given problem
                                                 % ADVISE: the user may introduce any name related to the problem at hand 
inputs_def.pathd.report_name='Name of the report file to be created';          % Name of the report file to be created
inputs_def.pathd.struct_name='strrepoName of the matlab structure to keep inputs and resultsrt';       % Name of the matlab structure to keep inputs and results
inputs_def.pathd.short_name='Short name, will be used to generate specific problem folders/files';          % Short name, will be used to generate specific problem folders/files
                                                 % ADVISE: the user may introduce any name related to the problem at hand
inputs_def.pathd.runident='Identifier required in order not to overwrite previous results';               % Identifier required in order not to overwrite previous results
inputs_def.pathd.run_overwrite='allow overwriting runs with the same run identifier';           % On/off to allow overwriting runs with the same run identifier

% inputs_def.pathd.runident_cl=[];
% inputs_def.pathd.AMIGO_path=[];
% 
% inputs_def.pathd.problem_folder_path = [];
% inputs_def.pathd.task_folder = [];
% inputs_def.pathd.residuals_plot_path = [];
%----------------------------------------------------------------------------------------------------------------
%
% PLOTS RELATED INFORMATION
%
inputs_def.plotd.plotlevel='Display of results';            % Display of results: 'full'|'medium'|'min' | 'noplot' 
inputs_def.plotd.epssave='Figures may be saved in .eps';                     % Figures may be saved in .eps (1) or only in .fig format (0)

inputs_def.plotd.fit_plot=' Name of best fit plots';           % Name of best fit plots 'fit_plot'_exp*.fig/.eps
inputs_def.plotd.data_plot='Name of experimental data plots';         % Name of experimental data plots 'data_plot'_exp*.fig/.eps
inputs_def.plotd.residuals_plot='Name of best fit corresponding residuals';    % Name of best fit corresponding residuals 'residuals'_exp*.fig/.eps
inputs_def.plotd.states_plot='Name of states plot';     % Name of states plot 'states_plot'_exp*_n.fig/.eps

inputs_def.plotd.number_max_states='Maximum number of states per figure';           % Maximum number of states per figure
inputs_def.plotd.obs_plot='Name of observables plot ';           % Name of observables plot 'obs_plot'_exp*_n.fig/.eps
inputs_def.plotd.number_max_obs='Maximum number of observables per figure';              % Maximum number of observables per figure
inputs_def.plotd.n_t_plot='Number of times to be used for observables and states plots';                   % Number of times to be used for observables and states plots
inputs_def.plotd.conf_cloud=' Name of the confidence region by pairs of unknowns';           % Name of the confidence region by pairs of unknowns'ccloud'_thetai_vs_thetaj.fig/.eps
inputs_def.plotd.ecc='Name of the figure of the eccentricity by pairs of unknowns';                     % Name of the figure of the eccentricity by pairs of unknowns
inputs_def.plotd.conf_hist='Name of the confidence region for each unknowns';              % Name of the confidence region for each unknowns 'hist'_thetai.fig/.eps
inputs_def.plotd.contour_plot='ame of the llq/lsq contour plots by pairs of unknowns';       % Name of the llq/lsq contour plots by pairs of unknowns 'contourP'_thetai_vs_thetaj.fig/.eps
inputs_def.plotd.contour1D_plot='Name of the llq/lsq cost plots vs unknowns';     % Name of the llq/lsq cost plots vs unknowns 'costplot'_thetai.fig/.eps
inputs_def.plotd.contour_rtol='Integration tolerances for the contour plots';             % Integration tolerances for the contour plots. 
inputs_def.plotd.contour_atol='Integration tolerances for the contour plots';             % ADVISE: These tolerances should be a little bit strict
inputs_def.plotd.nx_contour='Number of points for plotting the contours x and y direction';                 % Number of points for plotting the contours x and y direction
inputs_def.plotd.ny_contour='Number of points for plotting the contours x and y direction';                 % ADVISE: >50
inputs_def.plotd.convergence_curve='Name of the NLP solver convergence curve';% Name of the NLP solver convergence curve
inputs_def.plotd.multistart_hist='Name of the histogram of solutions for the multistart of local NLP solvers';        % Name of the histogram of solutions for the 
                                                 % multistart of local NLP solvers                                                
inputs_def.plotd.number_max_hist='Maximum number of unknowns histograms per figure';             % Maximum number of unknowns histograms per figure (multistart)

%----------------------------------------------------------------------------------------------------------------
%
% NUMERICAL METHODS RELATED DATA
%
 
inputs_def.ivpsol.rtol='Default IVP solver integration tolerances';                   % Default IVP solver integration tolerances
inputs_def.ivpsol.atol='Default IVP solver integration tolerances'; 

inputs_def.nlpsol.nlpsolver='NLP solver algorithm';              % Default GLOBAL NLP solver. Several alternatives may be selected here:
                                                % 'de', 'sres', 'ssm','multistart', 'local'. 
                                                % Note that the corresponding defaults are in files: 
                                                % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
                                                % OPT_solvers\SSm_**\ssm_options.m 
                                                
                                           
inputs_def.nlpsol.multi_starts='Number of different initial guesses to run local methods in the multistart approach';               % Number of different initial guesses to run local methods in the multistart approach
     
inputs_def.rid.conf_ntrials='Number of trials for the robust confidence computation';              % Number of trials for the robust confidence computation
inputs_def.rank.gr_samples='Number of samples for global sensitivities and global rank within LHS';              % Number of samples for global sensitivities and global rank within LHS                             

%
%   SYMBOLIC COMPUTATION RELATED DATA
%

inputs_def.model.AMIGOjac = 'compute the system''s Jacobian analytically to pass to CVODE';          % set 1 to compute the system's Jacobian analytically to pass to CVODE
inputs_def.model.J = 'system''s Jacobian (with respect to the states: dfdx)in C format for CVODE';                % system's Jacobian (with respect to the states: dfdx)in C format for CVODE 
inputs_def.model.AMIGOsensrhs = 'compute the exact right hand side of the sensitivity eqns for CVODES';      % set 1 to compute the exact right hand side of the sensitivity eqns for CVODES
inputs_def.model.Jpar = 'system''s Jacobian with respect to the parameters dfdp';                % system's Jacobian with respect to the parameters dfdp

% inputs_def.pathd=results_def.pathd;
% inputs_def.plotd=results_def.plotd;

return