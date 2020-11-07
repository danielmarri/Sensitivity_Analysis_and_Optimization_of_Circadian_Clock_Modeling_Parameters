% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/sres/AMIGO_SRES.m 770 2013-08-06 09:41:45Z attila $
function [xb,BestMin,neval,cpu_cost,conv_curve,x] = AMIGO_SRES(fcn,inputs,results,privstruct)
%********************************************************************************
% AMIGO_PE_SRES: modification of SRES(Runarsson & Yao) by E. Balsa-Canto
%          - arguments have been modified     
%          - changes on the generation of initial population 
%             depending on new input VAR. Note that if VAR>=1 
%             population is generated as in original DE version
%          -  extra convergence criteria based on population variability
%          - keeps intermediate results in a file: report
%********************************************************************************  

% SRES0 Evolution Strategy using Stochastic Ranking
% usage:
%        [xb,Stats,Gm] = sres0(fcn,mm,lu,NP,G,mu,pf,varphi,x0) ;
% where
%        fcn       : name of function to be optimized (string)
%        mm        : 'max' or 'min' (for maximization or minimization)
%        lu        : parameteric constraints (lower and upper bounds)
%        NP        : population size (number of offspring) (100 to 200)
%        G         : maximum number of generations
%        mu        : parent number (mu/NP usually 1/7)
%        pf        : pressure on fitness in [0 0.5] try around 0.45
%        varphi    : expected rate of convergence (usually 1)
%        x0        : initial location of x0
%
%        xb        : best feasible individual found
%        Stats     : [min(f(x)) mean(f(x)) number_feasible(x)]
%        Gm        : the generation number when "xb" was found

% EBC
%        report    : file to keep convergence curves
%******************************************************************************** 


mm='min';
lu=[inputs.nlpsol.vmin;inputs.nlpsol.vmax];
NP=inputs.nlpsol.SRES.NP;
G=inputs.nlpsol.SRES.itermax;
mu=inputs.nlpsol.SRES.mu;
pf=inputs.nlpsol.SRES.pf;
varphi=inputs.nlpsol.SRES.varphi;
x0=inputs.nlpsol.vguess;
var=inputs.nlpsol.SRES.var;
vareta=inputs.nlpsol.SRES.vareta;
cvarmax=inputs.nlpsol.SRES.cvarmax;


print_hist=0;
init_time=cputime;
neval=0;
g=1;
cvar=1.0e10;

% randomize seed
 rand('seed',sum(100*clock)) ;

  if strcmp(lower(mm),'max'), mm = -1 ; else, mm = 1 ; end

% Initialize Population
  n = size(lu,2) ;

% Selection index vector
  sI = (1:mu)'*ones(1,ceil(NP/mu)) ; sI = sI(1:NP) ;

% Initial parameter settings
  eta = vareta.*ones(NP,1)*(lu(2,:)-lu(1,:))/sqrt(n) ;
  tau  = varphi/(sqrt(2*sqrt(n))) ;
  tau_ = varphi/(sqrt(2*n)) ;
  ub = ones(NP,1)*lu(2,:) ;
  lb = ones(NP,1)*lu(1,:) ;
  eta_u = eta(1,:) ;
  BestMin = inf ;
  nretry = 10 ;
  xb = [] ;
  
%    eta = eta/n ; % !!!!!!!!!!!!!!!! experimental patch!

  
% % Initial population and step size (PATCH)
%   eta = ones(NP,1)*min(lu(2,:)-x0,x0-lu(1,:)) ;
    x_ = ones(NP,1)*x0 ;
%   x =  x_ + eta.*randn(NP,n) ;
%   I = find((x>ub) | (x<lb)) ; if ~isempty(I), x(I) = x_(I) ; end
  
  % Initialize Population
  
  n = size(lu,2) ;
  nmbX0 = size(x0,1); %

  if var<=1  
 % xrnd = ones(NP-nmbX0,1)*lu(1,:)+abs(log(rand(NP-nmbX0,n))).*(ones(NP-nmbX0,1)*(lu(2,:)-lu(1,:)));
  xrnd = ones(NP-nmbX0,1)*lu(1,:)+rand(NP-nmbX0,n).*(ones(NP-nmbX0,1)*(lu(2,:)-lu(1,:)));
  else
  xrnd=ones(NP-nmbX0,1)*lu(1,:)+var.*rand(NP-nmbX0,n).*abs(randn(NP-nmbX0,n).*(ones(NP-nmbX0,1)*(lu(2,:)-lu(1,:))));
  for i=1:NP
  if find(x(i,:)>lu(2,:))>0
      x(i,:)=rand(size(lu(2,:))).*lu(2,:);
  end
  
  if find(x(i,:)<lu(1,:))>0
      x(i,:)=lu(1,:);
  end
end
  
end  
  
 x = [x0; xrnd];


  if print_hist==1
      figure
  hist(x)
  pause
  end
  I = find((x>ub) | (x<lb)) ; if ~isempty(I), x(I) = x_(I) ; end 
  
 
  
 % EBC, report file 
  
fid=fopen(inputs.pathd.report,'a+');

fprintf(1,'\n\n----------------------------------------------------------------------');
fprintf(1,'\nIter\t Neval\t\t\t Best\t\t\t\t Var \t\t\t CPU_time\n');
fprintf(fid,'\nIter\t Neval\t\t\t Best\t\t\t\t Var \t\t\t CPU_time\n');
fprintf(1,'----------------------------------------------------------------------\n');
cont=1;  

% Start Generation loop ...
while g<=G & cvar>=cvarmax 

  % fitness evaluation
% EBC, alpha is a dummy argument in SRES
    [f,phi,alpha] = feval(fcn,x,inputs,results,privstruct) ; 

    
    neval=neval+size(x,1);
    
    f = mm*f ;
    Feasible = find((sum((phi>5e-5),2)<=0)) ;

    
    if ~isempty(Feasible),
      [Min(g),MinInd] = min(f(Feasible)) ;
      MinInd = Feasible(MinInd) ;
      Mean(g) = mean(f(Feasible)) ;
    else,
      Min(g) = NaN ; Mean(g) = NaN ;
    end
    NrFeas(g) = length(Feasible) ;

  % Keep best individual found
    if (Min(g)<BestMin) & ~isempty(Feasible)
      xb = x(MinInd,:) ;
      BestMin = Min(g); 
      Gm = g ;
    end

  % Compute penalty function "quadratic loss function" (or any other)
    phi(find(phi<=0)) = 0 ;
    phi = sum(phi.^2,2) ;

  % Selection using stochastic ranking (see srsort.c)

    I = srsort(f,phi,pf) ;
    x = x(I(sI),:) ; eta = eta(I(sI),:) ;
   
  % Update eta (traditional technique with global intermediate recombination)
    eta = arithx(eta) ;
    eta = eta.*exp(tau_*randn(NP,1)*ones(1,n)+tau*randn(NP,n)) ;
   
  % Upper bound on eta (used?)
   
  for i=1:n,   
      I = find(eta(:,i)>eta_u(i)) ; 
      eta(I,i) = eta_u(i)*ones(size(I)) ;
    end

  % Mutation
    x_ = x ; % make a copy of the individuals for repeat ...
    

    x = x + eta.*randn(NP,n) ;

  % If variables are out of bounds retry "nretry" times 
    I = find((x>ub) | (x<lb)) ;
    retry = 1 ;
      while ~isempty(I)
      x(I) = x_(I) + eta(I).*randn(length(I),1) ;
      I = find((x>ub) | (x<lb)) ;
      if (retry>nretry), break ; end
      retry = retry + 1 ;
    end
    % ignore failures
    if ~isempty(I),
      x(I) = x_(I) ;
    end
    

    % EBC,  Modification to keep information on the mean objective value and
% deviation for each population
cmean=0.;
cvar=0.;
cmean=sum(x)/NP;

for i=1:NP
    cvar=cvar+(x(i,:)-cmean)*(x(i,:)-cmean)';
end
cvar=cvar/(max(cmean)*(NP-1));  
    
  
% EBC: generates reporting file

     cpu_cost=cputime - init_time;
     conv_curve(g,1:2)=[ cpu_cost BestMin];  
     if rem(g,5)==0
      
      fprintf(1,' %d\t\t %d\t\t %e\t\t %e \t\t %f \n',g,neval,BestMin,cvar,cpu_cost);          
      fprintf(fid,' %d\t\t %d\t\t %e\t\t %e \t\t %f  \n',g,neval,BestMin,cvar,cpu_cost);   

  end
  if print_hist==1
  figure
  hist(x)
  close
  pause
  end
% ==================================================================================== 
  g=g+1;
  end       % ....... WHILE LOOP
  
  
%       fprintf(1,'\n');
%       fprintf(fid,'\n');
%       for i=1:n  
%       fprintf(1,'bestmen(%d)=  %f\n',i,xb(i));   
%       fprintf(fid,'bestmen(%d)=  %f\n',i,xb(i));
%       end
  
  
% Check Output
  if isempty(xb),
    [dummy,MinInd] = min(phi) ;
    xb = x(MinInd,:) ;
    Gm = g ;
    disp('warning: solution is infeasible') ;
  end
  if nargout > 1,
    Statistics = [mm*[Min' Mean'] NrFeas'] ;


   end
fclose(fid);