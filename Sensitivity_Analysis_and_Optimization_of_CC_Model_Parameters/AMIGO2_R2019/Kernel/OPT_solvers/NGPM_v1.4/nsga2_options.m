% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/nsga2_options.m 2214 2015-09-28 10:50:20Z evabalsa $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           SSM OPTIONS                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [options]=nsga2_options(xdim);

options = nsgaopt();                                % create default options structure
options.popsize = 10*xdim;                           % populaion size
options.maxGen  = 10*xdim;                             % max generation
options.plotInterval = 5;                           % interval between two calls of "plotnsga". 
%options.initfun={@initpop, 'populations.txt'}
options.mutation={'gaussian',0.1, 0.5};             % mutation operator (scale=0.1, shrink=0.5)
return