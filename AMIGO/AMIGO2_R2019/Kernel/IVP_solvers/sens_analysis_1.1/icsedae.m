% $Header: svn://.../trunk/AMIGO2R2016/Kernel/IVP_solvers/sens_analysis_1.1/icsedae.m 770 2013-08-06 09:41:45Z attila $
function [y,yp,f,DfDy,nFE,nPD,fac,g] = ...
  icsedae(odefile,t0,SE,Mt0,y,f,reltol,Janalytic,thresh,vectorized,Js,varargin)
%ICSEDAE Helper function to compute initial conditions for semi-explicit DAEs.
%   ICSEDAE attempts to find a set of consistent initial conditions for
%   equations of the form M(t)*y' = f(t,y) when the mass matrix is diagonal
%   (the DAE is semi-explicit, SE), or when the mass matrix is full (the DAE
%   is semi-explicit after transformation).  t0 is the initial point, Mt0 is
%   M(t0), y0 is a guess for y(t0), f0 = f(t0,y0), and 'odefile' is the name
%   of a function for evaluating f(t,y).  The output y and yp are such that
%   M(t0)*yp = f(t0,y) is satisfied much more accurately than the relative
%   error tolerance RelTol.  f is f(t0,y).  DfDy is the Jacobian of f
%   evaluated at (t0,y).  If the Jacobian was computed numerically, the
%   quantities fac and g are returned for subsequent use, and otherwise they
%   are returned as empty arrays.  The number of evaluations of odefile is
%   provided by nFE and the number of evaluations of the Jacobian is
%   provided by nPD.
%   
%   See also ICDAE, ODE15S, ODE23T, HB1DAE, AMP1DAE.

%   Jacek Kierzenka, Lawrence F. Shampine, and Mark W. Reichelt, 12-18-97
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.6 $

false = 0;
neq = length(y);
yp = zeros(neq,1);                      % derivative = 0 for alg variables

% The input arguments of odefile determine the args to use to evaluate f.
if nargin(odefile) == 2
  args = {};                            % odefile accepts only (t,y)
else
  args = [{''} varargin];               % use (t,y,'',p1,p2,...)
end

if Janalytic
  DfDy = feval(odefile,t0,y,'jacobian',varargin{:});
  fac = [];
  g = [];
  nFE = 0;
else    
  [DfDy,fac,g,nF] = numjac(odefile,t0,y,f,thresh,[],vectorized,Js,[],args{:});
  nFE = nF;
end
nPD = 1;
if SE
  D = diag(Mt0);
  if issparse(Mt0)
    UM = speye(size(Mt0));
    VM = UM;
  else
    UM = eye(size(Mt0));
    VM = UM;
  end
  AlgVar = find(D == 0);
else
  [UM,S,VM] = svd(Mt0);
  D = diag(S);
  tol = neq * max(D) * eps;
  AlgVar = find(D <= tol);
  D(AlgVar) = 0;
end
DifVar = find(D ~= 0);
F = UM' * f;
DFDY = UM' * DfDy * VM;
Y = VM' * y;

if isempty(AlgVar)
  % Arises only if MassSingular is yes, but the problem is not a DAE.
  yp = VM * (F ./ D);
  return;
end

J = DFDY(AlgVar,AlgVar);               
needJ = false;
% If J is singular, the problem is of index greater than 1:
if nnz(J) == 0 | eps*nnz(J)*condest(J) > 1 
  error('This DAE appears to be of index greater than 1.')
end

% Check for consistency of initial guess.
if norm(F(AlgVar)) <= 1000*eps*norm(F)
  yp(DifVar) = F(DifVar) ./ D(DifVar);
  yp = VM * yp;
  return;
end

[L,U] = lu(J);
for iter = 1:15                         % Begin simplified Newton iterations.
  
  if needJ 
    if Janalytic
      DfDy = feval(odefile,t0,y,'jacobian',varargin{:});
    else    
      [DfDy,fac,g,nF] = numjac(odefile,t0,y,f,thresh,fac,vectorized,Js,g,...
          args{:});
      nFE = nFE + nF;
    end
    DFDY = UM' * DfDy * VM;
    nPD = nPD + 1;
    J = DFDY(AlgVar,AlgVar);
    needJ = false;
    [L,U] = lu(J);
  end 
  
  delY = - (U \ (L \ F(AlgVar)));
  res = norm(delY);                     % Estimate the error.
  
  % Weak line search with affine invariant test.
  lambda = 1;
  Ynew = Y;
  for probe = 1:3
    Ynew(AlgVar) = Y(AlgVar) + lambda*delY;
    ynew = VM * Ynew;
    fnew = feval(odefile,t0,ynew,args{:});
    Fnew = UM' * fnew;
    nFE = nFE + 1;
    if norm(Fnew(AlgVar)) <= 1e-3*reltol*norm(Fnew)
      y = ynew;
      f = fnew;
      yp(DifVar) = Fnew(DifVar) ./ D(DifVar);
      yp = VM * yp;
      return;
    end
    % Estimate the error of ynew.
    resnew = norm(U \ (L \ Fnew(AlgVar)));    
    if resnew < 0.9*res
      break;
    else
      lambda = 0.5*lambda;
    end 
  end

  Ynorm = max(norm(Y(AlgVar)),norm(Ynew(AlgVar)));      
  if Ynorm == 0
    Ynorm = eps;
  end 
  Y = Ynew;
  y = VM * Ynew;
  f = fnew;
  F = Fnew;
  if resnew <= 1e-3*reltol*Ynorm        
    yp(DifVar) = F(DifVar) ./ D(DifVar);
    yp = VM * yp;
    return;
  end
  needJ = (resnew > 0.1*res);

end  % End loop on simplified Newton iteration.

error('Need a better guess y0 for consistent initial conditions.')
