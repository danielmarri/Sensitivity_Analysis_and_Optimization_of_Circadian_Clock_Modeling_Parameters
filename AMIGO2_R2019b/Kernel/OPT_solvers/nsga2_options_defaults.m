% $Header: svn://.../trunk/AMIGO_R2012_cvodes/Kernel/OPT_solvers/NGPM_v1.4/nsga2_options.m 2165 2015-09-22 08:33:32Z evabalsa $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           SSM OPTIONS                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [options]=nsga2_options();

options = nsgaopt();                                % create default options structure
options.popsize = 100;                           % populaion size
options.maxGen  = 100;                             % max generation
options.plotInterval = 5;                           % interval between two calls of "plotnsga". 
%options.initfun={@initpop, 'populations.txt'}
options.mutation={'gaussian',0.1, 0.5};             % mutation operator (scale=0.1, shrink=0.5)
return