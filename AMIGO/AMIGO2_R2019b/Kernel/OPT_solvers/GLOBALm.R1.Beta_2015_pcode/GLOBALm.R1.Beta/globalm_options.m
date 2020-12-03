% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/GLOBALM.R1.beta.PUBLIC/globalm_options.m 770 2013-08-06 09:41:45Z attila $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           GLOBALM INPUT DATA                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [options]=globalm_options(xdim);

 options.nsampl=100;      % Number of sample points to be drawn uniformly in one cycle (default: 100)
 options.nsel=2;          % Number of points selected from the sample (default: 2)
 options.msflag=1;        % Flag for pure multistart (1/0)
 options.local='FMINCON'; %Local solvers: 'FMINUNC','FMINSEARCH','SOLNP','UNIRANDI','FMINCON','SOLNP','UNIRANDI','UNIRANDIF'
 options.localmf=200*xdim;%Max number of function evaluations local search (default: 200*nvars)
 options.pweight=[];      %Penalty weight(s) for constraints
 options.tolx= 1e-6;      %Tolerance for x (default: 1.e-6)(used in matlab solvers and unirandi)
 options.tolfun=1e-6;     %Tolerance for the objective function in matlab solvers (default: 1.e-6). Also for SOLNP
 options.bestfval=-Inf;   %Value to reach
 options.maxnc=20;        %Max number of clusters
 options.maxiter=5000;    %Max number of total iterations
 options.maxlocal=10;     %Max number of local searches
 options.maxfeval=10000;  %Max number of function evaluations
 options.maxtime=50*xdim; %Max cpu time (seconds)
 options.iprint=1;        %Print optimization process

return