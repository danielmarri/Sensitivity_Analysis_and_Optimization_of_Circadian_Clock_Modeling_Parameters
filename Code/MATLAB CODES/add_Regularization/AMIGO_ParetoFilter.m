function [x,y,t] = AMIGO_ParetoFilter(x,y)
% AMIGO_ParetoFilter(x,y) checks if any of the (x,y) points are dominated
% and eliminates those. Also removes points if they are too close to each other
% SYNTAX:
%   [xs,ys] = AMIGO_ParetoFilter(x,y)   returns the remainig points
%   [xs,ys,filtInd] = AMIGO_ParetoFilter(x,y) filtInd contains the indices
%       of the remainig points in the original vectors, i.e. xs(i) = x(filtInd(i))
%
% EXAMPLE:
%   xr = rand(5,1);
%   yr = rand(5,1);
%   [xp,yp,tp] = AMIGO_ParetoFilter(xr,yr);
%   plot(xr,yr,'.',xp,yp,'rx','Markersize',10,'Linewidth',2)
%   xp(1) == xr(tp(1))

% Tuning knobs:
relTol_x = 0.001;  % rel. tolerance between x(i+1) and x(i)
relTol_y = 0.001;  % rel. tolerance between y(i+1) and y(i)

%if nargin < 3 || isempty(t)
    t = 1:length(x);
%end

assert(length(x) == length(y) && length(x) == length(t),'Inputs should have the same length.');



%% Check too close points:
npoints = length(x);
i = 0;
while npoints > 1
    i = i+1;
    if (abs(x(i+1) - x(i))< (x(i+1)+x(i))/2*relTol_x) && (abs(y(i+1) - y(i))< (y(i+1)+y(i))/2*relTol_y)
       x(i) = [];
       y(i) = [];
       t(i) = [];
       npoints = npoints - 1;
       i = i-1;
    end
    
    if i >= npoints-1
        break
    end
end

%% Check dominant points
npoints = length(x);
i = 0;
while npoints > 1
    i = i+1;
    if isDominated(x(i),y(i),x([1:i-1, i+1:end]),y([1:i-1, i+1:end]))
       x(i) = [];
       y(i) = [];
       t(i) = [];
       npoints = npoints - 1;
       i = i-1;
    end
    
    if i >= npoints
        break
    end
end
end

function flag = isDominated(px,py,Sx,Sy)
% checks if a point (px,py) is dominated by any point (x,y) in the set (Sx,Sy)

nTotal = length(Sx);
for i = 1:nTotal
    if px > Sx(i) && py > Sy(i)
        flag = true;
        return
    end
end
flag = false;
end

