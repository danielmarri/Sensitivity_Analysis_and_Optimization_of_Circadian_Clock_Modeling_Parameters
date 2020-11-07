function [k y_p y_pp] = AMIGO_explicitCurvature(x,y)
% Computes the curvatue based on finite differences
% K = |y''|/(1+y'^2)^3/2
% example

% x = 0:.1:1;
% y = sqrt(1-x.^2);
% yp = -x./sqrt(1-x.^2);
% ypp =- x.^2./(1 - x.^2).^(3/2) - 1./(1 - x.^2).^(1/2);
y_p = [];
y_pp = [];
% second derivative of y w.r.t x is
for i = 2:(length(y)-1)
    dx = (x(i+1)-x(i-1))/2;
    y_pp(i) = (y(i+1) + y(i-1) - 2*y(i))/dx^2;
    y_p(i) = (y(i+1) - y(i-1))/(2*dx);
end

k = (y_pp)./(1+y_p.^2).^(3/2);
k(1) = nan;
k(end+1) = nan;