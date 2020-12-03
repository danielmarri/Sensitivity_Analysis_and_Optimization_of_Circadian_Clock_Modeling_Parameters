
function opts = regularization_options_defaults
% defines the default regularization options
% regularzation structure and default parameters for functional
% regularization techniques. 
%
% method:
%   'tikhonov': 2-norm weighted regularization: ||W(x-x0)||_2^2
%       parameters:
%           W: weighting matrix
%           x0: reference parameter vector
%   'user_functional': user functional in the form [f (r) (a)] = userfunction(p,inputs,results,privstruct)
%       f: if the regularization functional evaluated in the current stage
%       r: (optional) residual vector form of the regularization. If the regularization part can be formulated as
%       least squares residual problem.
% regularization parameter:
%       alpha: (optional) regularization parameter


opts.ison = false;
opts.reg_par_method_type = 'selective';  % 'iterative'   how the reg. par. points are chosen
opts.weighting_matrix_method = ''; % 'ridge' |  'upper_bound' | 'sqrt_upper_bound' | 'pre_estimate' | 'mean_sensitivity' 
opts.reg_par_method = '';
opts.method = [];           % ['tikhonov','tikhonov_minflux','user_functional']
opts.alpha = [];            % regularization parameter.
opts.tikhonov.gW = [];  %weighting matrix for the global parameters
opts.tikhonov.lW = cell(1,100);  %weighting matrix for the local parameters
opts.tikhonov.gx0 = [];   % reference parameter set for the global parameters
opts.tikhonov.lx0 = cell(1,100);   % reference parameter set for the local parameters
opts.tikhonov.gy0 = [];   % reference parameter set for the estimated global initial conditions
opts.tikhonov.gyW = [];  %weighting matrix for the estimated global initial conditions
opts.tikhonov.ly0 = cell(1,100);   % reference parameter set for the estimated local initial conditions
opts.tikhonov.lyW = cell(1,100);  % weighting matrix for the estimated local initial conditions

opts.user_reg_functional = []; % function handler for user functional.
opts.n_alpha = []; % number of regualarization parameter in the alphaSet
opts.alpha_max = []; 
opts.alpha_min = [];
opts.reg_par_method = [];
opts.isinFIM = 0;
opts.alphaSet = [];  % set of regularization parameters. 
opts.plotflag = 1;
