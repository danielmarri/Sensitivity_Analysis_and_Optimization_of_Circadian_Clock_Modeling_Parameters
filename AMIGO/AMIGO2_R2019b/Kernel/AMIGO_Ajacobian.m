% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_Ajacobian.m 770 2013-08-06 09:41:45Z attila $
function inputs = AMIGO_AJacobian(inputs)
% ----  Core code ---------------------------------------------------------
% This is the advanced version of AMIGO_jacobian. It is required to split
% the original ODEs into: reactions, timefunctions and odes, where:
% - reactions r=r(x,p,t) the reactions depends only on the states,
%       parameters and time (so not on other reactions)
% - timefunctions: these functions wil be copied into the C file without
%       modifications. Constants are handled here too. 
% - ODEs: only the odes, no extra algebraic equations. 
%
% the code computes analytically the Jacobian (dF/dx) of the right hand
% side term (F) with respect to the states (x).
%
% The system can be index-1 DAE system in the form F = F(t,r(t,x,k),x,k), where
% r = r(t,x,k) defines algebraic equations among the time, parameters and states,
% e.g. represents the reaction rate expressions.
% However we use that, the reaction r does not depends on itself.


% -----  Initialization of the variables ----------------------------------
fprintf('\n\n\n------>Constructing the Jacobian using AMIGO_Ajacobian....\n');


% create symbolic parameter variables
par = cellstr(inputs.model.par_names);
parS = sym(par);
n_pars = length(parS);

%---- separate the algebraic equations from the ODE equations ------------
eqns = cellstr(inputs.model.eqns);
n_alg = inputs.model.n_reactions;
n_ode = inputs.model.n_st;
n_eqns = n_ode;

fprintf('%d algebraic and %d differential equations.\n',n_alg,n_ode);


%---- split the algebraic equations using the = sign ----------------------
% create algebraic variables if there is any:
if ~isempty(n_alg) && n_alg
    alg_splitted =  regexp(cellstr(inputs.model.reactions),'=','split');
    
    for i = 1 : n_alg
        alg_names{i,1} = alg_splitted{i}(1);
        alg_eqns{i,1}  = alg_splitted{i}(2);
    end
    % symbolic variables from algebraic names:
    algS = sym([alg_names{:}]');
    % create symbolic algebraic equations
    for i = 1: n_alg
        falg(i,1) = sym(alg_eqns{i});
    end
else
    algS = sym;
    falg = sym;
end

%---- split the ODEs using the = sign -------------------------------------
ode_splitted =  regexp(cellstr(inputs.model.odes),'=','split');

for i = 1 : n_ode
    ode_names{i,1} = ode_splitted{i}(1);
    ode_eqns{i,1}  = ode_splitted{i}(2);
end
odeS = sym([ode_names{:}]');
% create symbolic state variables using the names
st = cellstr(inputs.model.st_names);
stS = sym(st);

%ode_eqn = cellstr(ode_eqn);
for i = 1: n_ode
    fsys(i,1) = sym(ode_eqns{i});
end


% -----  Compute the Jacobians --------------------------------------------
dfdx =  jacobian(fsys,stS) + jacobian(fsys,algS)*jacobian(falg,stS);
dfdp =  jacobian(fsys,parS) + jacobian(fsys,algS)*jacobian(falg,parS);

%disp('Symbolic Jacobian of the system (df/dx):')
%disp(dfdx)
%disp('Symbolic parametric Jacobian of the system (df/dp):')
%disp(dfdp)
% ---- Convert syms to text format ----------------------------------------
dfdx = dfdx.'; % write out row-wise
dfdp = dfdp.';
tmp_dfdx = dfdx(:); % put in a vector
tmp_dfdp = dfdp(:);
index = 0;
inputs.model.J = '';
tmp2 = cell(n_ode*n_ode,1);
for i = 1:n_ode
    for j=1:n_ode
        index = index+1;
        tmp2{index} = char(tmp_dfdx(index));
    end
end

inputs.model.J = char(tmp2);


tmp2 = cell(n_ode * n_pars,1);
index = 0;
for i = 1:n_ode
    for j=1:n_pars
        index = index+1;
        tmp2{index} = char(tmp_dfdp(index));
    end
end

inputs.model.Jpar = char(tmp2);


