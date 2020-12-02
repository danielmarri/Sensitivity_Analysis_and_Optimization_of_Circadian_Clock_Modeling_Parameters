% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/TP_R-NSGA2/TPR_DTLZ2_objfun_3obj.m 770 2013-08-06 09:41:45Z attila $
function [y, cons] = TPR_DTLZ2_objfun_3obj(x)
% Objective function : Test problem 'DTLZ2'.
%*************************************************************************


y = [0, 0, 0];
cons = [];

g = sum((x(3:end)-0.5).^2);

y(1) = (1+g) * cos(x(1)*pi/2) * cos(x(2)*pi/2);
y(2) = (1+g) * cos(x(1)*pi/2) * sin(x(2)*pi/2);
y(3) = (1+g) * sin(x(1)*pi/2);



