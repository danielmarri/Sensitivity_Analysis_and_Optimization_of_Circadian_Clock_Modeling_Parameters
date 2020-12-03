% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/local_options_defaults.m 770 2013-08-06 09:41:45Z attila $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           Local Optimization OPTIONS                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opts=local_options_defaults()

opts.solver='fmincon';                %Choose local solver: 'fmincon'(Default), 'fminsearch','n2fb', 'dhc', 'lsqnonlin'
opts.maxeval = 500;
opts.maxtime = 60;
opts.iterprint=1;


end

