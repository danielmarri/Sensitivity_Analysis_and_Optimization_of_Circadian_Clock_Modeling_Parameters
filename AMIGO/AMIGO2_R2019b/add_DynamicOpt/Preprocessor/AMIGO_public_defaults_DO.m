% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/add_DynamicOpt/Preprocessor/AMIGO_public_defaults_OD.m 770 2013-08-06 09:41:45Z attila $

function [inputs_def,results_def]= AMIGO_public_defaults(inputs_def);
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

inputs_def.pathd.results_path='Results';        % General name of the folder to keep results
inputs_def.pathd.results_folder='Problem';      % Name of the folder to keep results for a given problem
                                                 % ADVISE: the user may introduce any name related to the problem at hand 
                                                 
inputs_def.pathd.report_name='report';          % Name of the report file to be created
inputs_def.pathd.struct_name='strreport';       % Name of the matlab structure to keep inputs and results
inputs_def.pathd.short_name='problem';          % Short name, will be used to generate specific problem folders/files
                                                 % ADVISE: the user may introduce any name related to the problem at hand
inputs_def.pathd.runident='run1';               % Identifier required in order not to overwrite previous results
inputs_def.pathd.run_overwrite='on';            % On/off to allow overwriting runs with the same run identifier
%----------------------------------------------------------------------------------------------------------------
%
% PLOTS RELATED INFORMATION
%
inputs_def.plotd.plotlevel='medium';            % Display of results: 'full'|'medium'|'min' | 'noplot' 
inputs_def.plotd.epssave=0;                     % Figures may be saved in .eps (1) or only in .fig format (0)
inputs_def.plotd.states_plot='states_plot';     % Name of states plot 'states_plot'_exp*_n.fig/.eps
inputs_def.plotd.number_max_states=8;           % Maximum number of states per figure
inputs_def.plotd.u_plot='u_plot';               % Name of states plot 'u_plot'_exp*_n.fig/.eps
inputs_def.plotd.n_t_plot=100;                  % Number of times to be used for observables and states plots
inputs_def.plotd.convergence_curve='conv_curve';% Name of the NLP solver convergence curve
inputs_def.plotd.multistart_hist='hist';        % Name of the histogram of solutions for the 
                                                 % multistart of local NLP solvers                                                
inputs_def.plotd.number_max_hist=8;             % Maximum number of unknowns histograms per figure (multistart)
inputs_def.plotd.pareto_plot='pareto';          % Name of the pareto plot for multiobjective problems
inputs_def.plotd.number_max_pareto=5;           % Max number of plots of pareto optimal solutions 
inputs_def.plotd.data_plot_title='';            % Title of of experimental data plots
%----------------------------------------------------------------------------------------------------------------
%
% NUMERICAL METHODS RELATED DATA
%
 
inputs_def.ivpsol.rtol=1.0D-7;                   % Default IVP solver integration tolerances
inputs_def.ivpsol.atol=1.0D-7; 

inputs_def.nlpsol.nlpsolver='eSS';               % Default GLOBAL NLP solver. Several alternatives may be selected here:
                                                % 'de', 'sres', 'ssm','multistart', 'local'. 
                                                % Note that the corresponding defaults are in files: 
                                                % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
                                                % OPT_solvers\SSm_**\ssm_options.m 
                                                
                                           
inputs_def.nlpsol.multi_starts=200;               % Number of different initial guesses to run local methods in the multistart approach


inputs_def.model.J=[];



return