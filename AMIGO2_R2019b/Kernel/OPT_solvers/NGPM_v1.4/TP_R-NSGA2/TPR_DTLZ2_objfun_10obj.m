% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/TP_R-NSGA2/TPR_DTLZ2_objfun_10obj.m 770 2013-08-06 09:41:45Z attila $
function [y, cons] = TPR_DTLZ2_objfun_10obj(x)
% Objective function : Test problem 'DTLZ2'.
%*************************************************************************


y = zeros(1,10);
cons = [];

g = sum((x(10:end)-0.5).^2);

x = x*pi/2;

% y(10)
t = 1 + g;
y(10) = t * sin(x(1));

% y(9) - y(2)
for i = 9:-1:2
    t = t * cos( x(10-i) );
    y(i) = t * sin( x(10-i+1) );
end

% y(1)
y(1) = t * cos( x(9) );


