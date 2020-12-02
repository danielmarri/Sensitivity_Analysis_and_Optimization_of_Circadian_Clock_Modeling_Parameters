function k = AMIGO_implicitCurvatureGeometric(a,x,y)
% Computes the curvature of a 2D line based on finite differences, assuming
% that the vector of a makes a geometric series.
% a: free variable
% x: first coordinate
% y: second coordinate
% K = (x'y''-y''*x')/(x'^2 + y'^2)^(3/2)
% where ' is a derivative wrt a. 
%
% example:
% a =  0:0.1:pi/2;
% x = sin(a);
% y = cos(a);
% xp = cos(a);
% xpp =-sin(a);
% yp = -sin(a); 
% ypp = -cos(a);
% y_p = nan;
% y_pp = nan;
% x_p = nan;
% x_pp = nan;
% second derivative of y w.r.t x is
if length(y) < 3
    k = nan(size(y));
    return
end

% q = a(1)/a(2);
    
for i = 2:(length(y)-1)
    q = a(i)/a(i+1);
    da =- a(i)*log(q);
    da2 = a(i)^2*log(q)*log(q);
    y_p(i) = (y(i+1) - y(i-1))/(2*da);
    y_pp(i) = (y(i+1) + y(i-1) - 2*y(i))/da2;
    x_p(i) = (x(i+1) - x(i-1))/(2*da);
    x_pp(i) = (x(i+1) + x(i-1) - 2*x(i))/da2;
end

k = [(x_p.*y_pp - y_p.*x_pp) ./ (x_p.^2 + y_p.^2).^(3/2) nan ] ;

