% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/local_options.m 1622 2014-06-26 11:09:56Z attila $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           Local Optimization OPTIONS                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opts=local_options()

% DO not use this field. It is only for the eSS. 
 opts.solver='';                %Choose local solver: 'fmincon'(Default), 'fminsearch','n2fb', 'dhc', 'lsqnonlin'
% set the solver by inputs.nlpsol.local_solver. Here, set only its options.
opts.maxeval = 500;
opts.maxtime = 60;
opts.iterprint=1;


end

