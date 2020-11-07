'GLOBAL' for MATLAB. Release 1.0 (Beta)
JOHS - Process Engineering Group (IIM-CSIC)

=====================================

USAGE
---------------------------------------------------------------------------
 'GLOBAL' for MATLAB (Release 1.0)
Platform: Matlab 7.04 (R14) Service Pack 2

BETA VERSION (August 13, 2008)
JOSE-OSCAR H. SENDIN 
Process Engineering Group (IIM-CSIC)
 
Reference: 
 Sendin,J.O.H., Csendes,T., Banga,J.R.(2007). Extensions of a 
 Multistart Clustering Algorithm for Constrained Global Optimization Problems. 
 Industrial & Engineering Chemistry  Research. Accepted for publication 

This version incorporates a few number of modifications with respect
to the code used in the above paper.
Please send any questions/comments/suggestions/bugs to 
osendin@iim.csic.es and/or julio@iim.csic.es
--------------------------------------------------------------------------

Inputs
   fun         Name of the function ('fun' or @fun). 
                       [f,g] = fun(x)
                       f: objective function
                       g: [equalities; inequalities]
   xo          User-provided initial point(s), in columns
   lowb        Lower bounds on the variables (column vector)
   uppb        Upper bounds on the variables (column vector)
   nec         Number of equality constraints (probably zero)
   nic         Number of inequality constraints
   options :   structure array with the fields
                   options.nsampl   Number of sample points to be drawn 
                                    uniformly in one cycle (default: 100)
                   options.nsel     Number of points selected from the 
                                    sample (default: 2)
                   options.msflag   Flag for pure multistart (1/0)
                   options.local    Name of the local solver (string)
                   options.localmf  Max number of function evaluations in
                                    local search (default: 200*nvars)
                   options.pweight  Penalty weight(s) for constraints
                   options.tolx     Tolerance for x (default: 1.e-6)
                                    (used in matlab solvers and unirandi)
                   options.tolfun   Tolerance for the objective function
                                    in matlab solvers (default: 1.e-6).
                                    Also for SOLNP
                   options.tolcon   Tolerance for constraints 
                   options.lowbic   Lower bound for inequality constraints
                   options.chkbound Flag (1/0) used in UNIRANDI for
                                    checking bounds
                   options.max_ndir Max. number of consecutive failed
                                    directions in UNIRANDI
                   options.rtol_dom Tolerance for comparisons in
                                    Filter-UNIRANDI
                   options.prob_pf  Probability of using an infeasible
                                    point of the filter to generate next
                                    trial point
                   options.bestfval Value to reach
                   options.maxnc    Max number of clusters
                   options.mniter   Max number of consecutives iterations
                                    with no new local minima (default: 2)
                   options.maxiter  Max number of total iterations
                   options.maxlocal Max number of local searches
                   options.maxfeval Max number of function evaluations
                   options.maxtime  Max cpu time (seconds)
                   options.iprint   Print optimization process
                                  
 p1,p2... :  optional parameters to be passed to the objective function

Outputs
  x :        matrix whose columns are the local minimizers found
  f :        corresponding function values, i.e. f(i) = f(x(:,i))
  clusters : structure array containing all the points clustered
  info :     structure array containing optimization history

 Two main functions are called:
  - globalunc: for unconstrained optimization 
  - globalcon: for optimization problems with constraints

Local solvers: 
  - For unconstrained problems: 'FMINUNC','FMINSEARCH','SOLNP','UNIRANDI' 
  - For constrained problems: 'FMINCON','SOLNP','UNIRANDI','UNIRANDIF'

--------------------------------------------------------------------------
DEFINITION OF OBJECTIVE FUNCTION 

    [f, g] = fun(x,p1,p2,...)
    
where 'f' is the value of the objective function; 'g' is the (column) vector 
of constraints (first, equalities; then, inequalities defined as <= 0); 
'x' is the vector of decision variables and 'p1,p2,...' are optional 
(constant) parameters.

For Filter-UNIRANDI, equality constraints should be transformed into 
inequalities:
      h(x) = 0 ---> abs(h(x)) - delta <= 0
where delta is a small positive number (e.g. 1.e-4)
 
---------------------------------------------------------------------------
DEFAULT OPTIMIZATION SETTINGS
---------------------------------------------------------------------------

* NSAMPL is the number of points generated within bounds
at each iteration. With high values, better points will be generated,
but the critical distance for clustering is decreased.
The value of NSAMPL recommended in Huyer (2004) is 100*nvars although in 
that study a value of 10nvars is used in order to reduce the number of 
function evaluations. 
NSEL/NSAMPL is the percentage of points which are selected from the
actual sample. 
In Mongeau et al. (1998), values for NSAMPL and NSEL of 100 and 2, 
respectively, are taken as the default ones. 

* PW is the weight for the penalty function. It can be either a scalar or a
column vector of length equal to the number of constraints. 
When a gradient-based local solver is selected, 
these weights are updated at each iteration using the lagrange multipliers
provided by the solver (default value = 1)

For UNIRANDI, the weights must be adjusted previously in order to obtain
a feasible solution. This is not required for Filter-UNIRANDI ('UNIRANDIF')

* TOLCON is the tolerance for constraints in the Matlab solvers (default = 1.e-6)
It is also used to evaluate the penalty function.
   If abs(h(x)) < tolcon --> h(x) = 0
   If phi < tolcon --> phi = 0. 

* TOLX is the tolerance for X in Matlab solvers. In UNIRANDI, this is 
the minimum step length (recommended value 1.e-6)

* TOLFUN is the tolerance for the objective in Matlab solvers (default 1.e-6).
It is also used in SOLNP (in this case, the recommended value by its author
is 1.e-4).

---------------------------------------------------------------------------
LOCAL SOLVERS
---------------------------------------------------------------------------

SOLNP is more robust than FMINCON, i.e. it is able to solve problems in 
which FMINCON fails. However, in general FMINCON is more efficient and the
final solution is more accurate.

UNIRANDI and Filter-UNIRANDI are derivative-free solvers. 
They are recommended if both FMINCON and SOLNP fail.

Modifications in the original UNIRANDI
- Termination criterion is based only on the step length
- Random directions are generated using a normal distribution
- If options.chkbound = 1, variables out of bounds are set to the value 
  of the corresponding bound

---------------------------------------------------------------------------
TERMINATION CRITERIA
---------------------------------------------------------------------------

The algorithm terminates:

* If no new local minima have been found after 'nmiter' consecutive iterations
* If a local minimum is found with an objective function value 
     less or equal than 'VTR'
* If any of the following values is reached:
    - Maximum number of iterations (default = NSAMPL/NSEL)
    - Maximum number of clusters (i.e. local minima)
    - Maximum number of local searches
    - Maximum number of function evaluations
    - Maximum CPU time
    
