% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/TP_NSGA2/TP_ZDT4_objfun.m 770 2013-08-06 09:41:45Z attila $
function [y, cons] = TP_ZDT4_objfun(x)
% Objective function : Test problem 'ZDT4'.
%*************************************************************************


y = [0, 0];
cons = [];

g = 1 + 10*(10-1);
for i = 2:10
    g = g + x(i)^2 - 10* cos(4*pi*x(i));
end

y(1) = x(1);
y(2) = g * (1-sqrt(x(1)/g));




