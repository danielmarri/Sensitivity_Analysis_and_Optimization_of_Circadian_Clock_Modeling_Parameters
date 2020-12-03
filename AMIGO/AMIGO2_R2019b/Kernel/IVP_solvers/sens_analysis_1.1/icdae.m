% $Header: svn://.../trunk/AMIGO2R2016/Kernel/IVP_solvers/sens_analysis_1.1/icdae.m 770 2013-08-06 09:41:45Z attila $
function [y,yp,f,DfDy,nFE,nPD,fac,g] = icdae(odefile,tspan,htry,Mt0,y0, ...
    f0,reltol,Janalytic,thresh,vectorized,Js,varargin)
%ICDAE Helper function to compute initial conditions for DAEs.
%   ICDAE attempts to find a set of consistent initial conditions for
%   equations of the form M(t)*y' = f(t,y).  ICDAE is used when the mass
%   matrix is sparse, but not diagonal.  The initial point t0 is extracted
%   from the array tspan specifying the interval of integration and the
%   output points.  y0 is a guess for y(t0), f0 = f(t0,y0), and 'odefile' is
%   the name of a function for evaluating f(t,y).  The output y and yp are
%   such that M(t0)*yp = f(t0,y) is satisfied much more accurately than the
%   relative error tolerance RelTol.  f is f(t0,y).  DfDy is the Jacobian of
%   f evaluated at (t0,y).  If the Jacobian was computed numerically, the
%   quantities fac and g are returned for subsequent use, and otherwise they
%   are returned as empty arrays.  The number of evaluations of odefile is
%   provided by nFE and the number of evaluations of the Jacobian is
%   provided by nPD.
%   
%   See also ICSEDAE, ODE15S, ODE23T, HB1DAE, AMP1DAE.

%   Jacek Kierzenka, Lawrence F. Shampine, and Mark W. Reichelt, 12-18-97
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.3 $

true = 1;
false = ~true;
neq = length(y0);
one2neq = (1:neq)';
if length(tspan) == 1
  t0 = 0;
  t1 = tspan(1);
else
  t0 = tspan(1);
  t1 = tspan(2);
end

% The input arguments of odefile determine the args to use to evaluate f.
if nargin(odefile) == 2
  args = {};                            % odefile accepts only (t,y)
else
  args = [{''} varargin];               % use (t,y,'',p1,p2,...)
end

% A relatively large initial value of h is chosen because a value
% that is "too" small emphasizes Mt0 in the iteration matrix, so
% makes the matrix ill-conditioned.  This can be handled with row
% scaling when the problem is in semi-explicit form, but not in
% general.
if isempty(htry)
  htry = 1e-4*abs(t0);
  if htry == 0
    htry = 1e-4*abs(t1);
  end
end
absh = min(htry, abs(t1 - t0));
  
% When t0 = 0 and t1 is "big", the initial h may be much too big.
% Balancing the sizes of the terms in the iteration matrix is used
% to select a more suitable value then.  We need the Jacobian for
% this, so it is initialized here.
if Janalytic 
  DfDy = feval(odefile,t0,y0,'jacobian',varargin{:});
  nFE = 0;
else
  [DfDy,fac,g,nF] = numjac(odefile,t0,y0,f0,thresh,[],vectorized,Js,[], ...
      args{:});
  nFE = nF;
end
nPD = 1;
needJ = false;

nrmMt0 = norm(Mt0,'fro');
nrmDfDy = norm(DfDy,'fro');
if nrmMt0 < absh*nrmDfDy
  absh = nrmMt0/nrmDfDy;
end
% Impose a minimum step size and attach a sign to absh.
h = sign(t1 - t0)*max(absh, 4*eps*abs(t0));

for newh = 1:3                          % Begin loop on the parameter h.

  needLU = true;                        % Factor iteration matrix for each h.
  y = y0;
  f = f0;

  for pass = 1:2                        % Begin loop to get a "small" yp.

    F = -f;                             % Corresponds to initial guess yp = 0.
    converged = false;
    for iter = 1:15                     % Begin simplified Newton iterations.

      if needJ 
        if Janalytic
          DfDy = feval(odefile,t0,y,'jacobian',varargin{:});
        else
          [DfDy,fac,g,nF] = ...
              numjac(odefile,t0,y,f,thresh,fac,vectorized,Js,g,args{:});
          nFE = nFE + nF;
        end
        nPD = nPD + 1;
        needJ = false;
        needLU = true;      
      end
      
      if needLU
        J = Mt0/h - DfDy;
        RowScale = 1 ./ max(abs(J)')';
        J = sparse(one2neq,one2neq,RowScale) * J;
        [L,U] = lu(J);
        needLU = false;
      end      

      dely = -(U \ (L \ (RowScale .* F)));  
      res = norm(dely);                 % Estimate the error of y.

      % Weak line search with affine invariant test.
      lambda = 1;
      for probe = 1:3
        ynew = y + lambda*dely;    
        ypnew = (ynew - y0)/h;
        LHS = Mt0*ypnew;
        fnew = feval(odefile,t0,ynew,args{:});
        nFE = nFE + 1;
        Fnew = LHS - fnew;
        if norm(Fnew) <= 1e-3*reltol*max(norm(LHS),norm(fnew))
          y = ynew;
          yp = ypnew;
          f = fnew;
          F = Fnew;
          converged = true;
          break;
        end
        % Estimate the error of ynew.
        resnew = norm(U \ (L \ (RowScale .* Fnew)));    
        if resnew < 0.9*res
          break;
        else
          lambda = 0.5*lambda;
        end 
      end
     
      if converged
        break;
      end

      ynorm = max(norm(y),norm(ynew));      
      if ynorm == 0
        ynorm = eps;
      end 
      y = ynew;
      yp = ypnew;
      f = fnew;
      F = Fnew;
      if resnew <= 1e-3*reltol*ynorm
        converged = true;
        break;
      end
      needJ = (resnew > 0.1*res);
      
    end  % End loop on simplified Newton iteration.

    if ~converged
      break;
    end
    
    y0 = y;                             % Second pass to get a "small" yp.
    
  end  % End loop to get "small" yp.

  if ~converged
    h = h/10;
  else
    return;
  end

end  % End loop on parameter h.

error('Need a better guess y0 for consistent initial conditions.')
