% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/TP_NSGA2/TP_ZDT6.m 770 2013-08-06 09:41:45Z attila $
%*************************************************************************
% Test Problem : 'ZDT6'
% Description:
%   (1)unconstrained   (2)nonconvex  (3)nonuniformly spaced
%
% Reference : 
% [1] Deb K, Sundar J,  U B R N, et al. Reference point based multi-objective 
%   optimization using evolutionary algorithms[J]. International Journal of 
%   Computational Intelligence Research. 2006, 2(3): 273-286.
% [2] Deb K, Pratap A, Agarwal S, et al. A fast and elitist multiobjective
%    genetic algorithm NSGA-II[J]. Evolutionary Computation. 2002, 6(2): 182-197.
%*************************************************************************


options = nsgaopt();                    % create default options structure
options.popsize = 50;                   % populaion size
options.maxGen  = 500;                  % max generation

options.numObj = 2;                     % number of objectives
options.numVar = 10;                    % number of design variables
options.numCons = 0;                    % number of constraints
options.lb = zeros(1,10);               % lower bound of x
options.ub = ones(1,10);                % upper bound of x
options.objfun = @TP_ZDT6_objfun;       % objective function handle

options.plotInterval = 10;              % large interval for efficiency
options.outputInterval = 10;


result = nsga2(options);






