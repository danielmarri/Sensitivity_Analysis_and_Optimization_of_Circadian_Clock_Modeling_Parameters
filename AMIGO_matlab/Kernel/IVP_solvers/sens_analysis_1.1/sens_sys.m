% $Header: svn://.../trunk/AMIGO2R2016/Kernel/IVP_solvers/sens_analysis_1.1/sens_sys.m 1739 2014-07-09 13:50:25Z davidh $
function [tout,yout,dydu_out,varargout] = sens_sys(odefile,tspan,y0,dydu,options,Uc,vecpar,initfile,varargin)
% 
%   01/JUNE/2010 EBC MODIFICATION TO INCORPORATE INITIAL CONDITIONS
%                FOR DYDU... useful to be used withi control loops
%
%   11/JUNE/2010 EBC MODIFICATION TO HANDLE VARARGIN FOR AMIGO TOOLBOX 
%
% SENS_SYS is an extension of the ODE15s (v 5.3) solver;as ODE15s, it
% integrates the system and, furthermore, calculate sensitivities of 
% the Has been written "over" the ODE15s code respecting the basic
% solving algorithm, whose only modification has been to set the default
% relative tolerance to 1e-6. The original ODE15s help is kept below, and
% users must check it. Only the extra parameters are explained.
%
% The "minimum" calling sequence of SENS_SYS is
%
% [T,Y,DYDP] = SENS_SYS('F',TSPAN,Y0,OPTIONS,P)
%
% where all parameters but DYDP and P are like in ODE15s. P must be now
% a column parameter vector not optional which must be passed to the ODE file, and
% DYDP contains the derivatives of the solution Y with respect to P, in the
% times returned in the T vector. As in ODE15s, derivatives may be obtained
% in specified points by using TSPAN = [T0 T1 ... TFINAL].
% (See Gas_oil example, in the Description.pdf file). Also, the OPTIONS
% parameter may be [] if no options are set.
% 
% The vecpar parameter tells SENS_SYS whether the ode file has been "vectorized"
% or not. (See again gas_oil example). The default is that it is not vectorized
% vecpar=0; if it is vectorized, you may set vecpar to 1.
%
% If the derivatives of Y0 with respect to P are not zero (the default is that these
% derivatives are zero), they may be specified  through a 'initfile':
%
% [T,Y,DYDP] = SENS_SYS('F',TSPAN,Y0,OPTIONS,P,VECPAR,initfile)
%
% where initfile must be a string containing an function which returns the
% derivatives of the initial vector Y0 with respect to P.
% Finally, further arguments needed , but whose derivatives  are not needed, 
% may be passed
%
% [T,Y,DYDP] = SENS_SYS('F',TSPAN,Y0,OPTIONS,P,VECPAR,initfile, varargin)
%
% if no initfile is needed, set initfile=[].
% All these features are described through the Gas_oil example in the Description.pdf
% file.
%
% The modifications to the original code are clearly indicated; The only modification
% that affects the ODE15s code is that the relative Tolerance has been set to 1e-6
% The statistics of ODE15s have not been corrected, so that they are not reliable yet
% (but for LU decompositions, whose number does not change)
%
% This code has been tested in many system of ODES an DAEs with good results in most
% of them, but can fail with very badly scaled problems. The writers of these modifications
% warn that this software is in development process, must be used with caution and that
% the possible user "uses" it at its own risk.
% Any comment or suggestion shall be welcome: vmgarcia@dsic.upv.es
% Valencia, Spain, 12/3/2002; Víctor M. García Mollá and R. Gómez Padilla


% 
%ODE15S Solve stiff differential equations and DAEs, variable order method.
%   [T,Y] = ODE15S('F',TSPAN,Y0) with TSPAN = [T0 TFINAL] integrates the
%   system of differential equations y' = F(t,y) from time T0 to TFINAL with
%   initial conditions Y0.  'F' is a string containing the name of an ODE
%   file.  Function F(T,Y) must return a column vector.  Each row in
%   solution array Y corresponds to a time returned in column vector T.  To
%   obtain solutions at specific times T0, T1, ..., TFINAL (all increasing
%   or all decreasing), use TSPAN = [T0 T1 ... TFINAL].
%   
%   [T,Y] = ODE15S('F',TSPAN,Y0,OPTIONS) solves as above with default
%   integration parameters replaced by values in OPTIONS, an argument
%   created with the ODESET function.  See ODESET for details.  Commonly
%   used options are scalar relative error tolerance 'RelTol' (1e-3 by
%   default) and vector of absolute error tolerances 'AbsTol' (all
%   components 1e-6 by default).
%   
%   [T,Y] = ODE15S('F',TSPAN,Y0,OPTIONS,P1,P2,...) passes the additional
%   parameters P1,P2,... to the ODE file as F(T,Y,FLAG,P1,P2,...) (see
%   ODEFILE).  Use OPTIONS = [] as a place holder if no options are set.
%   
%   It is possible to specify TSPAN, Y0 and OPTIONS in the ODE file (see
%   ODEFILE).  If TSPAN or Y0 is empty, then ODE15S calls the ODE file
%   [TSPAN,Y0,OPTIONS] = F([],[],'init') to obtain any values not supplied
%   in the ODE15S argument list.  Empty arguments at the end of the call
%   list may be omitted, e.g. ODE15S('F').
%   
%   The Jacobian matrix dF/dy is critical to reliability and efficiency.
%   Use ODESET to set JConstant 'on' if dF/dy is constant.  Set Vectorized
%   'on' if the ODE file is coded so that F(T,[Y1 Y2 ...]) returns
%   [F(T,Y1) F(T,Y2) ...].  Set JPattern 'on' if dF/dy is a sparse matrix
%   and the ODE file is coded so that F([],[],'jpattern') returns a sparsity
%   pattern matrix of 1's and 0's showing the nonzeros of dF/dy.  Set
%   Jacobian 'on' if the ODE file is coded so that F(T,Y,'jacobian') returns
%   dF/dy.
%   
%   As an example, the command
%   
%       ode15s('vdpode',[0 3000],[2 0],[],1000);
%   
%   solves the system y' = vdpode(t,y) with mu = 1000, using the default
%   relative error tolerance 1e-3 and the default absolute tolerance of 1e-6
%   for each component.  When called with no output arguments, as in this
%   example, ODE15S calls the default output function ODEPLOT to plot the
%   solution as it is computed.
%   
%   ODE15S can solve problems M(t,y)*y' = F(t,y) with a mass matrix M that
%   is nonsingular.  Use ODESET to set Mass to 'M', 'M(t)', or 'M(t,y)' if
%   the ODE file is coded so that F(T,Y,'mass') returns a constant,
%   time-dependent, or time- and state-dependent mass matrix, respectively.
%   The default value of Mass is 'none'.  See FEM1ODE, FEM2ODE, or
%   BATONODE.
%   
%   If M is singular, M(t)*y' = F(t,y) is a differential-algebraic equation
%   (DAE).  DAEs have solutions only when y0 is consistent, i.e. there is a
%   vector yp0 such that M(t0)*yp0 = f(t0,y0).  ODE15S can solve DAEs of
%   index 1 provided that M is not state dependent and y0 is sufficiently
%   close to being consistent.  You can use ODESET to set MassSingular to
%   'yes', 'no', or 'maybe'.  The default of 'maybe' causes ODE15S to test
%   whether the problem is a DAE. If it is, ODE15S treats y0 as a guess,
%   attempts to compute consistent initial conditions that are close to y0,
%   and goes on to solve the problem. When solving DAEs, it is very
%   advantageous to formulate the problem so that M is diagonal (a
%   semi-explicit DAE).  See HB1DAE or AMP1DAE.
%   
%   [T,Y,TE,YE,IE] = ODE15S('F',TSPAN,Y0,OPTIONS) with the Events property
%   in OPTIONS set to 'on', solves as above while also locating zero
%   crossings of an event function defined in the ODE file.  The ODE file
%   must be coded so that F(T,Y,'events') returns appropriate information.
%   See ODEFILE for details.  Output TE is a column vector of times at which
%   events occur, rows of YE are the corresponding solutions, and indices in
%   vector IE specify which event occurred.
%   
%   See also ODEFILE and
%       other ODE solvers:   ODE23S, ODE23T, ODE23TB, ODE45, ODE23, ODE113
%       options handling:    ODESET, ODEGET
%       output functions:    ODEPLOT, ODEPHAS2, ODEPHAS3, ODEPRINT
%       odefile examples:    VDPODE, BRUSSODE, B5ODE, CHM6ODE, FEM1ODE
%       Jacobian functions:  NUMJAC, COLGROUP

%   ODE15S is a quasi-constant step size implementation in terms of backward
%   differences of the Klopfenstein-Shampine family of Numerical
%   Differentiation Formulas of orders 1-5.  The natural "free" interpolants
%   are used.  Local extrapolation is not done.  By default, Jacobians are
%   generated numerically.

%   Details are to be found in The MATLAB ODE Suite, L. F. Shampine and
%   M. W. Reichelt, SIAM Journal on Scientific Computing, 18-1, 1997.

%   Mark W. Reichelt, Lawrence F. Shampine, and Jacek Kierzenka, 12-18-97
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.62 $  $Date: 1998/05/18 15:06:36 $

% VMGM / RGP i

if (nargin<6)|(isempty(Uc) )
   error('without parameters, use ode15s')
end

% EBC modification to handle AMIGO varargin
% 
% if nargin > 8
%   resvararg=[varargin{2:end}];
% else
%   resvararg={};
% end
[filU,columU]=size(Uc);
if  ((nargin<7)|isempty(vecpar))
   vecpar=0;
elseif ((vecpar~=1)&(vecpar~=0))
   error('vecpar must be set to 1 or to 0')
end

% EBC ....
%dydu=zeros(length(y0),filU);

% tolerances
%temp=sqrt(eps)*Uc+Uc;
temp=sqrt(eps)*(Uc+0.1)+Uc;
told=temp-Uc;
% VMGM / RGP f

true = 1;
false = ~true;

nsteps = 0;                             % stats
nfailed = 0;                            % stats
nfevals = 0;                            % stats
npds = 0;                               % stats
ndecomps = 0;                           % stats
nsolves = 0;                            % stats

if nargin == 0
  error('Not enough input arguments.  See ODE15S.');
elseif ~isstr(odefile) & ~isa(odefile, 'inline')
  error('First argument must be a single-quoted string.  See ODE15S.');
end

if nargin == 1
 % VMGM / RGP i
   error('without parameters, use ode15s')
% VMGM / RGP f
  tspan = []; y0 = []; options = [];
elseif nargin == 2
 % VMGM / RGP i
   error('without parameters, use ode15s')
% VMGM / RGP f
  y0 = []; options = [];
elseif nargin == 3
% VMGM / RGP i
   error('without parameters, use ode15s')
% VMGM / RGP f
 options = [];
elseif nargin == 4
   error('without parameters, use ode15s')
elseif nargin == 5
  error('without parameters, use ode15s')    
%   dydu=y0(:)*ones(1,filU);
elseif nargin >= 8 & ~isempty(initfile)
   dydu=feval(initfile,y0,Uc);
   [fdydu,cdydu]=size(dydu);
   if (fdydu~=length(y0))|(cdydu~=filU)
      error('error dimmensiones en initfile')
   end
end
Ucn=Uc*ones(1,filU);
Ucn=Ucn+diag(told);
varargn=[{Ucn} varargin];
vararg=[{Uc} varargin];
% VMGM / RGP f


% Get default tspan and y0 from odefile if none are specified.
if isempty(tspan) | isempty(y0)
  if (nargout(odefile) < 3) & (nargout(odefile) ~= -1)
    msg = sprintf('Use ode15s(''%s'',tspan,y0,...) instead.',odefile);
    error(['No default parameters in ' upper(odefile) '.  ' msg]);
  end
  [def_tspan,def_y0,def_options] = feval(odefile,[],[],'init',vararg{:});
  if isempty(tspan)
    tspan = def_tspan;
  end
  if isempty(y0)
    y0 = def_y0;
  end
  if isempty(options)
    options = def_options;
  else
    options = odeset(def_options,options);
  end
end

% Test that tspan is internally consistent.
tspan = tspan(:);
ntspan = length(tspan);
if ntspan == 1
  t0 = 0;
  next = 1;
else
  t0 = tspan(1);
  next = 2;
end
tfinal = tspan(ntspan);
if t0 == tfinal
  error('The last entry in tspan must be different from the first entry.');
end
tdir = sign(tfinal - t0);
if any(tdir * (tspan(2:ntspan) - tspan(1:ntspan-1)) <= 0)
  error('The entries in tspan must strictly increase or decrease.');
end

t = t0;
y = y0(:);
neq = length(y);
one2neq = (1:neq)';
% VMGM / RGP i
% The sensibilities are kept in the array dydu, with neq rows and
% filU columns 
% VMGM / RGP f

% Get options, and set defaults.
% Modified Tolerance
%rtol = odeget(options,'RelTol',1e-3);
% VMGM / RGP i
   rtol = odeget(options,'RelTol',1e-6);
% VMGM / RGP f
if (length(rtol) ~= 1) | (rtol <= 0)
  error('RelTol must be a positive scalar.');
end
if rtol < 100 * eps 
  rtol = 100 * eps;
  warning(['RelTol has been increased to ' num2str(rtol) '.']);
end

atol = odeget(options,'AbsTol',1e-6);
if any(atol <= 0)
  error('AbsTol must be positive.');
end

normcontrol = strcmp(odeget(options,'NormControl','off'),'on');
if normcontrol
  if length(atol) ~= 1
    error('Solving with NormControl ''on'' requires a scalar AbsTol.');
  end
  normy = norm(y);
else
  if (length(atol) ~= 1) & (length(atol) ~= neq)
    error(sprintf(['Solving %s requires a scalar AbsTol, ' ...
                   'or a vector AbsTol of length %d'],upper(odefile),neq));
  end
  atol = atol(:);
end
threshold = atol / rtol;

% By default, hmax is 1/10 of the interval.
hmax = min(abs(tfinal-t), abs(odeget(options,'MaxStep',0.1*(tfinal-t))));
if hmax <= 0
  error('Option ''MaxStep'' must be greater than zero.');
end
htry = abs(odeget(options,'InitialStep'));
if htry <= 0
  error('Option ''InitialStep'' must be greater than zero.');
end

haveeventfun = strcmp(odeget(options,'Events','off'),'on');
if haveeventfun
  valt = feval(odefile,t,y,'events',vararg{:});
  teout = [];
  yeout = [];
  ieout = [];
end

if nargout > 0
  outfun = odeget(options,'OutputFcn');
else
  outfun = odeget(options,'OutputFcn','odeplot');
end
if isempty(outfun)
  haveoutfun = false;
else
  haveoutfun = true;
  outputs = odeget(options,'OutputSel',one2neq);
end
refine = odeget(options,'Refine',1);
printstats = strcmp(odeget(options,'Stats','off'),'on');

Janalytic = strcmp(odeget(options,'Jacobian','off'),'on');
Jconstant = strcmp(odeget(options,'JConstant','off'),'on');
vectorized = strcmp(odeget(options,'Vectorized','off'),'on');
Jpattern = strcmp(odeget(options,'JPattern','off'),'on');
if Jpattern
  Js = feval(odefile,[],[],'jpattern',vararg{:});
else
  Js = [];
end

mass = lower(odeget(options,'Mass','none'));

% Grandfathering code -- should be removed in a subsequent release.
Mconstant = odeget(options,'Mass');
if strcmp(mass,'on') | strcmp(mass,'off') | ...
      strcmp(Mconstant,'on') | strcmp(Mconstant,'off')
  if strcmp(mass,'on') | strcmp(mass,'off')
    warning(['Mass property values are ''none'', ''M'', ''M(t)'', ' ...
          'and ''M(t,y)'' (see ODESET).  Support for the''on'' and ' ...
          '''off'' values has been grandfathered and will disappear ' ...
          'in a future release.']);
  end
  if strcmp(Mconstant,'on') | strcmp(Mconstant,'off')
    warning(['The MassConstant property has been grandfathered and will ' ...
          'disappear in a future release (see ODESET).']);
  end
  if strcmp(Mconstant,'on')
    mass = 'm';
    warning('Assuming Mass value ''M'', a constant mass matrix.');
  elseif strcmp(mass,'on')
    mass = 'm(t)';
    warning('Assuming Mass value ''M(t)'', a time-dependent mass matrix.');
  else
    mass = 'none';
    warning('Assuming Mass value ''none'', no mass matrix.');
  end
end

switch(mass)
  case 'none', Mtype = 0;
  case 'm', Mtype = 1;
  case 'm(t)', Mtype = 2;
  case 'm(t,y)', Mtype = 3;
  otherwise, error('Unrecognized Mass property value.  See ODESET.');
end

Msingular = odeget(options,'MassSingular');
if Mtype == 3
  if strcmp(Msingular,'maybe')
    warning(['Solver assumes MassSingular is ''no'' for state-dependent ' ...
          'mass matrices.']);
    Msingular = 'no';
  elseif strcmp(Msingular,'yes')
    error(['MassSingular cannot be ''yes'' for state-dependent mass '...
          'matrices M(t,y).']);
  else
    Msingular = 'no';
  end
elseif isempty(Msingular)
  Msingular = 'maybe';
end

DAE = false;
RowScale = [];
SE = false;
if Mtype > 0
  Mt = feval(odefile,t,y,'mass',vararg{:});
  
  if nnz(Mt) == 0
    error('The mass matrix must have some non-zero entries.')
  end
  
  if ~strcmp(Msingular,'no')
    
    % If Mt is singular, DAE = true.  It is very advantageous to
    % to recognize a problem that is semi-explicit, SE = true.
    [r,c] = find(Mt);
    SE = isequal(r,c);                  % Test for a diagonal mass matrix.

    DAE = true;
    if strcmp(Msingular,'maybe')
      if SE
        DAE = any(diag(Mt) == 0);
      else
        DAE = (eps*nnz(Mt)*condest(Mt) > 1);
      end
    end
  end
  
else
  Mt = sparse(one2neq,one2neq,1,neq,neq); % Mtype = 0, mass matrix is sparse I.
end
Mcurrent = true;
Mtnew = Mt;

maxk = odeget(options,'MaxOrder',5);
bdf = strcmp(odeget(options,'BDF','off'),'on');

% Set the output flag.
if ntspan > 2
  outflag = 1;                          % output only at tspan points
elseif refine <= 1
  outflag = 2;                          % computed points, no refinement
else
  outflag = 3;                          % computed points, with refinement
  S = (1:refine-1)' / refine;
end

% Initialize method parameters.
G = [1; 3/2; 11/6; 25/12; 137/60];
if bdf
  alpha = [0; 0; 0; 0; 0];
else
  alpha = [-37/200; -1/9; -0.0823; -0.0415; 0];
end
invGa = 1 ./ (G .* (1 - alpha));
erconst = alpha .* G + (1 ./ (2:6)');
difU = [ -1, -2, -3, -4,  -5;           % difU is its own inverse!
          0,  1,  3,  6,  10;
          0,  0, -1, -4, -10;
          0,  0,  0,  1,   5;
          0,  0,  0,  0,  -1 ];
maxK = 1:maxk;
[kJ,kI] = meshgrid(maxK,maxK);
difU = difU(maxK,maxK);
maxit = 4;

% The input arguments of odefile determine the args to use to evaluate f.
if (exist(odefile) == 3) | (nargin(odefile) == 2) % don't nargin MEX files
  args = {};                            % odefile accepts only (t,y)
else
% VMGM / RGP i
args = [{''} {Uc} varargin];               % use (t,y,'',p1,p2,...)
% VMGM / RGP f

end

f0 = feval(odefile,t,y,args{:});
nfevals = nfevals + 1;                  % stats
[m,n] = size(f0);
if n > 1
  error([upper(odefile) ' must return a column vector.'])
elseif m ~= neq
  msg = sprintf('an initial condition vector of length %d.',m);
  error(['Solving ' upper(odefile) ' requires ' msg]);
end

warnstat = warning;

% Compute the initial slope yp.  For DAEs the y input is usually just a
% guess.  Compute consistent initial conditions when necessary.
jthresh = atol + zeros(neq,1);
if DAE
  if SE | ~issparse(Mt)
    [y,yp,f0,dfdy,nFE,nPD,fac,g] = icsedae(odefile,t,SE,Mt,y,f0,rtol,...
       Janalytic,jthresh,vectorized,Js,vararg{:});
        %Víctor M. Garcíai
     tray=y(:)*ones(1,filU);
     if ~isempty(initfile)
       dydu=feval(initfile,y,Uc);
    end
    if vecpar 
      ftray0= feval(odefile,t,y,'',varargn{:});
    else
     for iiU=1:filU
       varaux=[{Ucn(iiU)},varargin];
       ftray0(:,iiU)=feval(odefile,t,y,'',varaux{:});
     end
    end

     for iiU=1:filU
       tray(:,iiU)=tray(:,iiU)+told(iiU)*dydu(:,iiU);
       [tray(:,iiU),trayp(:,iiU),ftray0(:,iiU),dfdy,nFE,nPD,fac,g] = icsedae(odefile,t,SE,Mt,tray(:,iiU),ftray0(:,iiU), ...
          rtol,Janalytic,jthresh,vectorized,Js,vararg{:});
       dydu(:,iiU)=(tray(:,iiU)-y)/told(iiU);
     end  
     % cambiado varargin por vararg
     %Víctor M. García f
   else
     [y,yp,f0,dfdy,nFE,nPD,fac,g] = icdae(odefile,tspan,htry,Mt,y,f0,rtol,...
        Janalytic,jthresh,vectorized,Js,vararg{:});
         %Víctor M. Garcíai
     tray=y(:)*ones(1,filU);
     if ~isempty(initfile)
       dydu=feval(initfile,y,Uc);
    end
    if vecpar 
      ftray0= feval(odefile,t,y,'',varargn{:});
    else
     for iiU=1:filU
       varaux=[{Ucn(iiU)},varargin];
       ftray0(:,iiU)=feval(odefile,t,y,'',varaux{:});
     end
    end

     for iiU=1:filU
       tray(:,iiU)=tray(:,iiU)+told(iiU)*dydu(:,iiU);
       [tray(:,iiU),trayp(:,iiU),ftray0(:,iiU),dfdy,nFE,nPD,fac,g] = icdae(odefile,tspan,htry,Mt,tray(:,iiU),ftray0(:,iiU), ...
          rtol,Janalytic,jthresh,vectorized,Js,vararg{:});
       dydu(:,iiU)=(tray(:,iiU)-y)/told(iiU);
     end  
     % cambiado varargin por vararg
     %Víctor M. García f
  end
  nfevals = nfevals + nFE;
  npds = npds + nPD;
else
  if Mtype > 0
    [L,U] = lu(Mt);
    yp = U \ (L \ f0);
    ndecomps = ndecomps + 1;              % stats
    nsolves = nsolves + 1;                % stats
  else
    yp = f0;
  end
  
  if Janalytic
    dfdy = feval(odefile,t,y,'jacobian',vararg{:});
  else
    [dfdy,fac,g,nF] = ...
        numjac(odefile,t,y,f0,jthresh,[],vectorized,Js,[],args{:});
    nfevals = nfevals + nF;               % stats
  end
  npds = npds + 1;                        % stats
end
Jcurrent = true;

% hmin is a small number such that t + hmin is clearly different from t in
% the working precision, but with this definition, it is 0 if t = 0.
hmin = 16*eps*abs(t);

if isempty(htry)
  % Compute an initial step size h using yp = y'(t).
  if normcontrol
    wt = max(normy,threshold);
    rh = 1.25 * (norm(yp) / wt) / sqrt(rtol);  % 1.25 = 1 / 0.8
  else
    wt = max(abs(y),threshold);
    rh = 1.25 * norm(yp ./ wt,inf) / sqrt(rtol);
  end
  absh = min(hmax, abs(tspan(next) - t));
  if absh * rh > 1
    absh = 1 / rh;
  end
  absh = max(absh, hmin);
  
  if ~DAE
    % The error of BDF1 is 0.5*h^2*y''(t), so we can determine the optimal h.
    h = tdir * absh;
    tdel = (t + tdir*min(sqrt(eps)*max(abs(t),abs(t+h)),absh)) - t;
    f1 = feval(odefile,t+tdel,y,args{:});
    nfevals = nfevals + 1;                % stats
    dfdt = (f1 - f0) ./ tdel;
    if normcontrol
      if Mtype > 0
        rh = 1.25 * sqrt(0.5 * (norm(U \ (L \ (dfdt + dfdy*yp))) / wt) / rtol);
      else
        rh = 1.25 * sqrt(0.5 * (norm(dfdt + dfdy*yp) / wt) / rtol);
      end
    else
      if Mtype > 0
        rh = 1.25*sqrt(0.5*norm((U \ (L \ (dfdt+dfdy*yp))) ./ wt,inf) / rtol);
      else
        rh = 1.25 * sqrt(0.5 * norm((dfdt + dfdy*yp) ./ wt,inf) / rtol);
      end
    end
    absh = min(hmax, abs(tspan(next) - t));
    if absh * rh > 1
      absh = 1 / rh;
    end
    absh = max(absh, hmin);
  end
else
  absh = min(hmax, max(hmin, htry));
end
h = tdir * absh;

% Initialize.
k = 1;                                  % start at order 1 with BDF1
K = 1;                                  % K = 1:k
klast = k;
abshlast = absh;

dif = zeros(neq,maxk+2);
dif(:,1) = h * yp;

%VMGM / RGP i
% differences array for the sensibilities
difdu=zeros(neq,maxk+2,filU);
if vecpar
   f0=feval(odefile,t,y,'',vararg{:})*ones(1,filU);
    difdu(:,1,:)=h*(feval(odefile,t,y,'',varargn{:})-f0)*diag(1./told);
   nfevals=nfevals+1;
else
   ff0=feval(odefile,t,y,'',vararg{:});
   for iiU=1:filU
      auxargn=[{Ucn(:,iiU)} varargin];
     difdu(:,1,iiU)=h*(feval(odefile,t,y,'',auxargn{:})-ff0)/told(iiU);
   end
   nfevals=nfevals+filU+1;
end
% VMGM / RGP f

hinvGak = h * invGa(k);
nconhk = 0;                             % steps taken with current h and k
Miter = Mt - hinvGak * dfdy;
% Use explicit scaling of the equations when solving DAEs.
if DAE
  RowScale = 1 ./ max(abs(Miter),[],2);
  Miter = sparse(one2neq,one2neq,RowScale) * Miter;
end
[L,U] = lu(Miter);
ndecomps = ndecomps + 1;                % stats
havrate = false;

% Initialize the output function.
if haveoutfun
  feval(outfun,[t tfinal],y(outputs),'init');
end

% Allocate memory if we're generating output.
if nargout > 0
  if ntspan > 2                         % output only at tspan points
    tout = zeros(ntspan,1);
    yout = zeros(ntspan,neq);
 %   VMGM / RGP i
   dydu_out=zeros(ntspan,neq,filU);   
 % VMGM / RGP f
  else                                  % alloc in chunks
    chunk = max(ceil(128 / neq),refine);
    tout = zeros(chunk,1);
    yout = zeros(chunk,neq);
 %   VMGM / RGP i
 dydu_out=zeros(chunk,neq,filU);   
 % VMGM / RGP f
  end
  nout = 1;
  tout(nout) = t;
  yout(nout,:) = y.';
 %   VMGM / RGP i

  dydu_out(nout,:,:)=dydu;
 % VMGM / RGP f
end

% THE MAIN LOOP

done = false;
while ~done
  
  hmin = 16*eps*abs(t);
  absh = min(hmax, max(hmin, absh));
  h = tdir * absh;
  
  % Stretch the step if within 10% of tfinal-t.
  if 1.1*absh >= abs(tfinal - t)
    h = tfinal - t;
    absh = abs(h);
    done = true;
  end
  
  if (absh ~= abshlast) | (k ~= klast)
    difRU = cumprod((kI - 1 - kJ*(absh/abshlast)) ./ kI) * difU;
    dif(:,K) = dif(:,K) * difRU(K,K);
    % VMGM / RGP i
    for iiU=1:filU
       difdu(:,K,iiU)=squeeze(difdu(:,K,iiU))*difRU(K,K);
    end
  % VMGM / RGP f

    hinvGak = h * invGa(k);
    nconhk = 0;
    if ~Mcurrent                        % possible only if state-dependent
      Mt = feval(odefile,t,y,'mass',varargin{:});
      Mcurrent = true;
    end
    Miter = Mt - hinvGak * dfdy;
    if DAE
      RowScale = 1 ./ max(abs(Miter),[],2);
      Miter = sparse(one2neq,one2neq,RowScale) * Miter;
    end
    [L,U] = lu(Miter);
    ndecomps = ndecomps + 1;            % stats
    havrate = false;
  end
  
  % LOOP FOR ADVANCING ONE STEP.
  nofailed = true;                      % no failed attempts
  while true                            % Evaluate the formula.
    
    gotynew = false;                    % is ynew evaluated yet?
    while ~gotynew

      % Compute the constant terms in the equation for ynew.
      psi = dif(:,K) * (G(K) * invGa(k));
 % VMGM / RGP i
      for iiU=1:filU
         psisen(:,iiU)=squeeze(difdu(:,K,iiU)) * (G(K) * invGa(k));
      end
      if neq>1
         predsen= dydu+squeeze(sum(difdu(:,K,:),2));
      else
         predsen= dydu+squeeze(sum(difdu(:,K,:),2))';
      end
      dydunew=predsen;
% VMGM / RGP f
      % Predict a solution at t+h.
      tnew = t + h;
      pred = y + sum(dif(:,K),2);
      ynew = pred;
      
      % The difference, difkp1, between pred and the final accepted 
      % ynew is equal to the backward difference of ynew of order
      % k+1. Initialize to zero for the iteration to compute ynew.
      difkp1 = zeros(neq,1); 
% VMGM / RGP i
   difkpsen=zeros(neq,filU);      
   deld=zeros(neq,filU);
% VMGM / RGP f
      if normcontrol
        normynew = norm(ynew);
        invwt = 1 / max(max(normy,normynew),threshold);
        minnrm = 100*eps*(normynew * invwt);
      else
        invwt = 1 ./ max(max(abs(y),abs(ynew)),threshold);
        minnrm = 100*eps*norm(ynew .* invwt,inf);
      end

      % Mtnew is required in the RHS function evaluation.
      if Mtype == 2
        Mtnew = feval(odefile,tnew,ynew,'mass',varargin{:});
      end
      
      % Iterate with simplified Newton method.
        tooslow = false;
      for iter = 1:maxit
        if Mtype == 3
          Mtnew = feval(odefile,tnew,ynew,'mass',varargin{:});
       end
     
        rhs = hinvGak*feval(odefile,tnew,ynew,args{:}) -  Mtnew*(psi+difkp1);
        if DAE                          % Account for row scaling.
          rhs = RowScale .* rhs;
        end
        warning('off');
        del = U \ (L \ rhs);
        warning(warnstat);
        if normcontrol
          newnrm = norm(del) * invwt;
        else
          newnrm = norm(del .* invwt,inf);
        end
        difkp1 = difkp1 + del;
        ynew = pred + difkp1;
        if newnrm <= minnrm
          gotynew = true;
          break;
        elseif iter == 1
          if havrate
            errit = newnrm * rate / (1 - rate);
            if errit <= 0.05*rtol       % More stringent when using old rate.
              gotynew = true;
              break;
            end
          else
            rate = 0;
          end
        elseif newnrm > 0.9*oldnrm
          tooslow = true;
          break;
        else
          rate = max(0.9*rate, newnrm / oldnrm);
          havrate = true;                 
          errit = newnrm * rate / (1 - rate);
          if errit <= 0.5*rtol             
            gotynew = true;
            break;
          elseif iter == maxit            
            tooslow = true;
            break;
          elseif 0.5*rtol < errit*rate^(maxit-iter)
            tooslow = true;
            break;
          end
        end
        
        oldnrm = newnrm;
     end                               
   % end of Newton loop
   % VMGM / RGP i
   if gotynew
       fder= feval(odefile,tnew,ynew,'',vararg{:});
       for itt=1:3
          if vecpar
            ff0=fder*ones(1,filU);
  %          Ucn=Uc*ones(1,filU);
  %          Ucn=Ucn+diag(told);
            aux=-hinvGak* ...
               (feval(odefile,tnew,ynew*ones(1,filU)+dydunew*diag(told),'',varargn{:})- ff0 );
            deld=(-Mtnew*((psisen+difkpsen)*diag(told))-aux)*diag(1./told);
            nfevals=nfevals+iiU;
            if DAE    % Account for row scaling.
 				    for iiU=1:filU     
					   deld(:,iiU) = RowScale .* deld(:,iiU);
               end
            end
         else
            for iiU=1:filU
               auxargn=[{Ucn(:,iiU)} varargin];
               aux=-hinvGak*(feval(odefile,tnew,ynew+told(iiU)*dydunew(:,iiU),'',auxargn{:})- fder );
               deld(:,iiU)=(-Mtnew*(told(iiU)*(psisen(:,iiU)+difkpsen(:,iiU)))-aux)/told(iiU);
                if DAE                          % Account for row scaling.
                  deld(:,iiU) = RowScale .* deld(:,iiU);
                end
            end
            nfevals=nfevals+iiU;
       end
      difkpsen=difkpsen+(U \ (L \ deld));
      nsolves=nsolves+iiU;
        dydunew=predsen+difkpsen;
     end
  end  
  % VMGM / RGP f
     nfevals = nfevals + iter;         % stats %VMGM / RGP actualizar
      nsolves = nsolves + iter;         % stats  % VMGM / RGP actualizar
      
      if tooslow
        nfailed = nfailed + 1;          % stats
        % Speed up the iteration by forming J(t,y) or reducing h.
        if ~Jcurrent
          if Janalytic
            dfdy = feval(odefile,t,y,'jacobian',vararg{:});
          else
            f0 = feval(odefile,t,y,args{:});
            [dfdy,fac,g,nF] = ...
                numjac(odefile,t,y,f0,jthresh,fac,vectorized,Js,g,args{:});
            nfevals = nfevals + nF + 1; % stats
          end
          npds = npds + 1;            % stats
          Jcurrent = true;
        elseif absh <= hmin
          msg = sprintf(['Failure at t=%e.  Unable to meet integration ' ...
                         'tolerances without reducing the step size below ' ...
                         'the smallest value allowed (%e) at time t.\n'], ...
                        t,hmin);
          warning(msg);
          if haveoutfun
            feval(outfun,[],[],'done');
          end
          if printstats                 % print cost statistics
            fprintf('%g successful steps\n', nsteps);
            fprintf('%g failed attempts\n', nfailed);
            fprintf('%g function evaluations\n', nfevals);
            fprintf('%g partial derivatives\n', npds);
            fprintf('%g LU decompositions\n', ndecomps);
            fprintf('%g solutions of linear systems\n', nsolves);
          end
          if nargout > 0
            tout = tout(1:nout);
            yout = yout(1:nout,:);
            if haveeventfun
              varargout{1} = teout;
              varargout{2} = yeout;
              varargout{3} = ieout;
              varargout{4} = [nsteps;nfailed;nfevals; npds; ndecomps; nsolves];
            else
              varargout{1} = [nsteps;nfailed;nfevals; npds; ndecomps; nsolves];
            end
          end
          return;
        else
          abshlast = absh;
          absh = max(0.3 * absh, hmin);
          h = tdir * absh;
          done = false;

          difRU = cumprod((kI - 1 - kJ*(absh/abshlast)) ./ kI) * difU;
          dif(:,K) = dif(:,K) * difRU(K,K);
% VMGM / RGP i
      for iiU=1:filU
       difdu(:,K,iiU)=squeeze(difdu(:,K,iiU))*difRU(K,K);
      end
% VMGM / RGP f
          
          hinvGak = h * invGa(k);
          nconhk = 0;
        end
        if ~Mcurrent                    % possible only if state-dependent
          Mt = feval(odefile,t,y,'mass',varargin{:});
          Mcurrent = true;
        end
        Miter = Mt - hinvGak * dfdy;
        if DAE
          RowScale = 1 ./ max(abs(Miter),[],2);
          Miter = sparse(one2neq,one2neq,RowScale) * Miter;
        end
        [L,U] = lu(Miter);
        ndecomps = ndecomps + 1;        % stats
        havrate = false;
      end   
    end     % end of while loop for getting ynew
    
    % difkp1 is now the backward difference of ynew of order k+1.
    if normcontrol
      err = (norm(difkp1) * invwt) * erconst(k);
    else
      err = norm(difkp1 .* invwt,inf) * erconst(k);
    end
    
    if err > rtol                       % Failed step
      nfailed = nfailed + 1;            % stats
      if absh <= hmin
        msg = sprintf(['Failure at t=%e.  Unable to meet integration ' ...
                       'tolerances without reducing the step size below ' ...
                       'the smallest value allowed (%e) at time t.\n'],t,hmin);
        warning(msg);
        if haveoutfun
          feval(outfun,[],[],'done');
        end
        if printstats                   % print cost statistics
          fprintf('%g successful steps\n', nsteps);
          fprintf('%g failed attempts\n', nfailed);
          fprintf('%g function evaluations\n', nfevals);
          fprintf('%g partial derivatives\n', npds);
          fprintf('%g LU decompositions\n', ndecomps);
          fprintf('%g solutions of linear systems\n', nsolves);
        end
        if nargout > 0
          tout = tout(1:nout);
          yout = yout(1:nout,:);
          if haveeventfun
            varargout{1} = teout;
            varargout{2} = yeout;
            varargout{3} = ieout;
            varargout{4} = [nsteps; nfailed; nfevals; npds; ndecomps; nsolves];
          else
            varargout{1} = [nsteps; nfailed; nfevals; npds; ndecomps; nsolves];
          end
        end
        return;
      end
      
      abshlast = absh;
      if nofailed
        nofailed = false;
        hopt = absh * max(0.1, 0.833*(rtol/err)^(1/(k+1))); % 1/1.2
        if k > 1
          if normcontrol
            errkm1 = (norm(dif(:,k) + difkp1) * invwt) * erconst(k-1);
          else
            errkm1 = norm((dif(:,k) + difkp1) .* invwt,inf) * erconst(k-1);
          end
          hkm1 = absh * max(0.1, 0.769*(rtol/errkm1)^(1/k)); % 1/1.3
          if hkm1 > hopt
            hopt = min(absh,hkm1);      % don't allow step size increase
            k = k - 1;
            K = 1:k;
          end
        end
        absh = max(hmin, hopt);
      else
        absh = max(hmin, 0.5 * absh);
      end
      h = tdir * absh;
      if absh < abshlast
        done = false;
      end
      
      difRU = cumprod((kI - 1 - kJ*(absh/abshlast)) ./ kI) * difU;
      dif(:,K) = dif(:,K) * difRU(K,K);
 % VMGM / RGP i
    for iiU=1:filU
       difdu(:,K,iiU)=squeeze(difdu(:,K,iiU))*difRU(K,K);
    end
 % VMGM / RGP f
      
      hinvGak = h * invGa(k);
      nconhk = 0;
      if ~Mcurrent                      % possible only if state-dependent
        Mt = feval(odefile,t,y,'mass',varargin{:});
        Mcurrent = true;
      end
      Miter = Mt - hinvGak * dfdy;
      if DAE
        RowScale = 1 ./ max(abs(Miter),[],2);
        Miter = sparse(one2neq,one2neq,RowScale) * Miter;
      end
      [L,U] = lu(Miter);
      ndecomps = ndecomps + 1;          % stats
      havrate = false;
      
    else                                % Successful step
      break;
      
    end
  end % while true
  nsteps = nsteps + 1;                  % stats
  
  dif(:,k+2) = difkp1 - dif(:,k+1);
  dif(:,k+1) = difkp1;
  
  % VMGM / RGP i
  if neq>1
     difdu(:,k+2,:)=difkpsen-squeeze(difdu(:,k+1,:));
  else
     difdu(:,k+2,:)=difkpsen-squeeze(difdu(:,k+1,:))';     
  end
  difdu(:,k+1,:)=difkpsen;
% VMGM / RGP f

  for j = k:-1:1
     dif(:,j) = dif(:,j) + dif(:,j+1);
     % VMGM / RGP i
      difdu(:,j,:)=difdu(:,j,:)+difdu(:,j+1,:);
     % VMGM / RGP f
  end
  
  tstep = tnew;
  ystep = ynew;
  dydustep=dydunew;
  if haveeventfun
    [te,ye,ie,valt,stop] = ...
        odezero('ntrp15s',odefile,valt,t,y,tnew,ynew,t0,varargin,h,dif,k);
    nte = length(te);
    if nte > 0
      if nargout > 2
        teout = [teout; te];
        yeout = [yeout; ye.'];
        ieout = [ieout; ie];
      end
      if stop                           % stop on a terminal event
        tnew = te(nte);
        ynew = ye(:,nte);
        done = true;
      end
    end
  end
  
  if nargout > 0
    oldnout = nout;
    if outflag == 2                     % computed points, no refinement
      nout = nout + 1;
      if nout > length(tout)
        tout = [tout; zeros(chunk,1)];
        yout = [yout; zeros(chunk,neq)];
% VMGM / RGP i
        dydu_out=[dydu_out; zeros(chunk,neq,filU)];
% VMGM / RGP f
      end
      tout(nout) = tnew;
      yout(nout,:) = ynew.';
% VMGM / RGP i
      dydu_out(nout,:,:)=dydunew;
% VMGM / RGP f
    elseif outflag == 3                 % computed points, with refinement
      nout = nout + refine;
      if nout > length(tout)
        tout = [tout; zeros(chunk,1)];  % requires chunk >= refine
        yout = [yout; zeros(chunk,neq)];
      end
      i = oldnout+1:nout-1;
      tout(i) = t + (tnew-t)*S;
      yout(i,:) = ntrp15s(tout(i),[],[],tstep,ystep,h,dif,k).';
      tout(nout) = tnew;
      yout(nout,:) = ynew.';
    elseif outflag == 1                 % output only at tspan points
      while next <= ntspan
        if tdir * (tnew - tspan(next)) < 0
          if haveeventfun & done
            nout = nout + 1;
            tout(nout) = tnew;
            yout(nout,:) = ynew.';
% VMGM / RGP i
            dydu_out(nout,:,:)=dydunew;
% VMGM / RGP f
          end
          break;
        elseif tnew == tspan(next)
          nout = nout + 1;
          tout(nout) = tnew;
          yout(nout,:) = ynew.';
% VMGM / RGP i
          dydu_out(nout,:,:)=dydunew;
% VMGM / RGP f
          next = next + 1;
          break;
        end
        nout = nout + 1;                % tout and yout are already allocated
        tout(nout) = tspan(next);
        yout(nout,:) = ntrp15s(tspan(next),[],[],tstep,ystep,h,dif,k).';
% VMGM / RGP i
        for iiU=1:filU
           dydu_out(nout,:,iiU)=ntrp15s(tspan(next), [],[], tstep, dydustep(:,iiU),h,difdu(:,:,iiU),k);
        end   
% VMGM / RGP f
        next = next + 1;
      end
    end
    
    if haveoutfun
      i = oldnout+1:nout;
      if ~isempty(i) & (feval(outfun,tout(i),yout(i,outputs).') == 1)
        tout = tout(1:nout);
        yout = yout(1:nout,:);
        if haveeventfun
          varargout{1} = teout;
          varargout{2} = yeout;
          varargout{3} = ieout;
          varargout{4} = [nsteps; nfailed; nfevals; npds; ndecomps; nsolves];
        else
          varargout{1} = [nsteps; nfailed; nfevals; npds; ndecomps; nsolves];
        end
        return;
      end
    end
    
  elseif haveoutfun
    if outflag == 2
      if feval(outfun,tnew,ynew(outputs)) == 1
        return;
      end
    elseif outflag == 3                 % computed points, with refinement
      tinterp = t + (tnew-t)*S;
      yinterp = ntrp15s(tinterp,[],[],tstep,ystep,h,dif,k);
      if feval(outfun,[tinterp; tnew],[yinterp(outputs,:), ynew(outputs)]) == 1
        return;
      end
    elseif outflag == 1                 % output only at tspan points
      ninterp = 0;
      while next <= ntspan 
        if tdir * (tnew - tspan(next)) < 0
          if haveeventfun & done
            ninterp = ninterp + 1;
            tinterp(ninterp,1) = tnew;
            yinterp(:,ninterp) = ynew;
          end
          break;
        elseif tnew == tspan(next)
          ninterp = ninterp + 1;
          tinterp(ninterp,1) = tnew;
          yinterp(:,ninterp) = ynew;
          next = next + 1;
          break;
        end
        ninterp = ninterp + 1;
        tinterp(ninterp,1) = tspan(next);
        yinterp(:,ninterp) = ntrp15s(tspan(next),[],[],tstep,ystep,h,dif,k);
        next = next + 1;
      end
      if ninterp > 0
        if feval(outfun,tinterp(1:ninterp),yinterp(outputs,1:ninterp)) == 1
          return;
        end
      end
    end
  end
  
  klast = k;
  abshlast = absh;
  nconhk = min(nconhk+1,maxk+2);
  if nconhk >= k + 2
    temp = 1.2*(err/rtol)^(1/(k+1));
    if temp > 0.1
      hopt = absh / temp;
    else
      hopt = 10*absh;
    end
    kopt = k;
    if k > 1
      if normcontrol
        errkm1 = (norm(dif(:,k)) * invwt) * erconst(k-1);
      else
        errkm1 = norm(dif(:,k) .* invwt,inf) * erconst(k-1);
      end
      temp = 1.3*(errkm1/rtol)^(1/k);
      if temp > 0.1
        hkm1 = absh / temp;
      else
        hkm1 = 10*absh;
      end
      if hkm1 > hopt 
        hopt = hkm1;
        kopt = k - 1;
      end
    end
    if k < maxk
      if normcontrol
        errkp1 = (norm(dif(:,k+2)) * invwt) * erconst(k+1);
      else
        errkp1 = norm(dif(:,k+2) .* invwt,inf) * erconst(k+1);
      end
      temp = 1.4*(errkp1/rtol)^(1/(k+2));
      if temp > 0.1
        hkp1 = absh / temp;
      else
        hkp1 = 10*absh;
      end
      if hkp1 > hopt 
        hopt = hkp1;
        kopt = k + 1;
      end
    end
    if hopt > absh
      absh = hopt;
      if k ~= kopt
        k = kopt;

        K = 1:k;
      end
    end
  end
  
  % Advance the integration one step.
  t = tnew;
  y = ynew;
% VMGM / RGP i
  dydu=dydunew;
% VMGM / RGP f
  if normcontrol
    normy = normynew;
  end
  Jcurrent = Jconstant;
  switch Mtype
  case {0,1}
    Mcurrent = true;                    % Constant mass matrix I or M.
  case 2
    % M(t) has already been evaluated at tnew in Mtnew.
    Mt = Mtnew;
    Mcurrent = true;
  case 3
    % M(t,y) has not yet been evaluated at the accepted ynew.
    Mcurrent = false;
  end
  
end % while ~done

if haveoutfun
  feval(outfun,[],[],'done');
end

if printstats                           % print cost statistics
  fprintf('%g successful steps\n', nsteps);
  fprintf('%g failed attempts\n', nfailed);
  fprintf('%g function evaluations\n', nfevals);
  fprintf('%g partial derivatives\n', npds);
  fprintf('%g LU decompositions\n', ndecomps);
  fprintf('%g solutions of linear systems\n', nsolves);
end

if nargout > 0
  tout = tout(1:nout);
  yout = yout(1:nout,:);
% VMGM / RGP i
  dydu_out=dydu_out(1:nout,:,:);
% VMGM / RGP f
  if haveeventfun
    varargout{1} = teout;
    varargout{2} = yeout;
    varargout{3} = ieout;
    varargout{4} = [nsteps; nfailed; nfevals; npds; ndecomps; nsolves];
  else
    varargout{1} = [nsteps; nfailed; nfevals; npds; ndecomps; nsolves];
  end
end
