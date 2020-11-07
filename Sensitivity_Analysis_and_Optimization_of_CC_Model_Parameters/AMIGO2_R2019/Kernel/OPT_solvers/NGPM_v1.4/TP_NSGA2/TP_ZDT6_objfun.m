% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/TP_NSGA2/TP_ZDT6_objfun.m 770 2013-08-06 09:41:45Z attila $
function [y, cons] = TP_ZDT6_objfun(x)
% Objective function : Test problem 'ZDT6'.
%*************************************************************************


y = [0, 0];
cons = [];


numVar = length(x);
g = 1 + 9 * (sum(x(2:numVar))/(numVar-1))^0.25;

y(1) = 1 - exp(-4*x(1)) * sin(6*pi*x(1))^6;
y(2) = g * (1 - (y(1)/g)^2);



