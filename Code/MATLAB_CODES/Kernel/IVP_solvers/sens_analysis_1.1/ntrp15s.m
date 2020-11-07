% $Header: svn://.../trunk/AMIGO2R2016/Kernel/IVP_solvers/sens_analysis_1.1/ntrp15s.m 770 2013-08-06 09:41:45Z attila $
function yinterp = ntrp15s(tinterp,t,y,tnew,ynew,h,dif,k)
%NTRP15S Interpolation helper function for ODE15S.
%   YINTERP = NTRP15S(TINTERP,T,Y,TNEW,YNEW,H,DIF,K) uses data computed in
%   ODE15S to approximate the solution at time TINTERP.
%   
%   See also ODE15S.

%   Mark W. Reichelt and Lawrence F. Shampine, 6-13-94
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 1997/11/21 23:30:50 $

s = ((tinterp - tnew) / h)';        % may be a row vector

if k == 1
  yinterp = ynew(:,ones(length(tinterp),1)) + dif(:,1) * s;
else                    % cumprod collapses vectors
  K = (1:k)';
  kI = K(:,ones(length(tinterp),1));
  yinterp = ynew(:,ones(length(tinterp),1)) + ...
      dif(:,K) * cumprod((s(ones(k,1),:)+kI-1)./kI);
end
