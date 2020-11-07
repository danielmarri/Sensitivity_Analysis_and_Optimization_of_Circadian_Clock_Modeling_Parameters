function [stS,parS,algS,fsys,falg,dfdx,dfdp,dObsdx,dfdinp]=AMIGO_charmodel2syms(inputs,dfdx_flag,dfdp_flag,dobsdx_flag,dfdinp_flag)
% [stS,parS,algS,fsys,falg,]=AMIGO_charmodel2syms(inputs) determines the
% variables of the model and converts them to symbolic expressions.

if nargin<2 || isempty(dfdx_flag)
    dfdx_flag = true;
end
if nargin<3 || isempty(dfdp_flag)
    dfdp_flag = true;
end
if nargin<4 || isempty(dobsdx_flag)
    dobsdx_flag = false;
end
if nargin<5 || isempty(dfdinp_flag)
    dfdinp_flag = false;
end
% create symbolic parameter variables
par = cellstr(inputs.model.par_names);
parS = sym(par);
n_pars = length(parS);

%---- separate the algebraic equations from the ODE equations ------------
eqns = cellstr(inputs.model.eqns);
n_alg = 0;
n_ode = 0;
n_eqns = 0;
foundODE = regexp(eqns,'^d');
posODE = [];
posAlg = [];
for i = 1:size(foundODE,1)
    n_eqns = n_eqns +1;
    if isempty(foundODE{i})
        n_alg = n_alg + 1;
        posAlg = [posAlg n_eqns];
    else
        n_ode = n_ode + 1;
        posODE = [posODE n_eqns];
    end
end
fprintf('%d algebraic and %d differential equations are found.\n',n_alg,n_ode);

if inputs.model.n_st ~= n_ode
    error('Number of states and number of ODEs are not matching...')
end



%---- split the algebraic equations using the = sign ----------------------
% create algebraic variables if there is any:
if n_alg
    
    alg_splitted =  regexp(eqns(posAlg),'=','split');
    
    for i = 1 : n_alg
        alg_names{i,1} = alg_splitted{i}(1);
        alg_eqns{i,1}  = alg_splitted{i}(2);
    end
    
    inputs.model.algeqns = alg_eqns; % save the algebraic parts of the eqns
    inputs.model.algvarnames = alg_names;
    
    algS = sym([alg_names{:}]');
    % create symbolic state and algebraic equations
    for i = 1: n_alg
        falg(i,1) = sym(alg_eqns{i});
    end
else
    algS = sym('');
    falg = sym('');
end

% eliminate if the algebraic expressions contains algebraic variables on
% their right hand side. We dont know how complicated the right hand sides
% are, but we will give a try.
tmp = falg;
success = 0;
for i = 1:3  % max 3 levels of embedding...
    tmp2 = subs(tmp,algS,falg,0);
    if all(tmp2 == tmp)
        % ready.
        success = 1;
        break;
    else
        % not ready yet
        tmp = tmp2;
    end
end
falg = tmp2;

if ~success
    fprintf('---> WARNING message (Symbolic computation):\n');
    fprintf('The algebraic expressions of the model are to complicated to express as a function of states and parameters.\n');
    fprintf('The Jacobian is probably inaccurate.')
end


%---- split the ODEs using the = sign -------------------------------------
ode_splitted =  regexp(eqns(posODE),'=','split');

for i = 1 : n_ode
    ode_names(i,1) = ode_splitted{i}(1);
    ode_eqns{i,1}  = ode_splitted{i}(2);
end



% reorder the equations as the states are defined...
for i=1:n_ode
    eqn_st{i} = ode_names{i}(2:end);  % state names as ordered in the equations
end

rank = zeros (1,n_ode);
for i = 1:n_ode
    for j = 1:n_ode
        if strcmpi(strtrim(inputs.model.st_names(i,:)), strtrim(eqn_st{j}));
            rank(i) = j;
            continue;
        end
    end
end
% reorder by these.
ode_names = ode_names(rank);
ode_eqns = ode_eqns(rank);
odeS = sym([ode_names]);

% create symbolic state variables using the left hand side of the ODEs
for i = 1: n_ode
    fsys(i,1) = sym(ode_eqns{i});
    stS(i,1) = sym(ode_names{i}(2:end));
end

% it should not be, but try to resolve seemingly differential algebraic
% equations: when the right hand side of the ODEs depends on dx.
fsys = subs(fsys,odeS,fsys,0);


% -----  Compute the Jacobians --------------------------------------------
fprintf('Constructing symbolic Jacobians...')
fsys = subs(fsys,algS,falg,0);
if dfdx_flag
    dfdx =  jacobian(fsys,stS) + jacobian(fsys,algS)*jacobian(falg,stS);
else
    dfdx=[];
end
if dfdp_flag
    dfdp =  jacobian(fsys,parS) + jacobian(fsys,algS)*jacobian(falg,parS);
else
    dfdp = [];
end
fprintf('Done\n')



%% Sensitivities of observables wrt states

    for iexp = 1:inputs.exps.n_exp
        dObsdx{iexp} = [];
    end
if dobsdx_flag
    if inputs.exps.n_obs{1}>=1 && isfield(inputs.exps,'obs') && ~isempty(inputs.exps.obs{1})
        % observables are defined.
        
        for iexp = 1:inputs.exps.n_exp
            eqns = cellstr(inputs.exps.obs{iexp});
            n_obs = size(eqns,1);
            n_eqns = 0;
            
            %---- split the algebraic equations using the = sign ----------------------
            % create algebraic variables if there is any:
            
            obs_splitted =  regexp(eqns,'=','split');
            
            for i = 1 : n_obs
                obs_names{i,1} = obs_splitted{i}(1);
                obs_eqns{i,1}  = obs_splitted{i}(2);
            end
            
            obsS = sym([obs_names{:}]');
            % create symbolic state and algebraic equations
            for i = 1: n_obs
                fobs(i,1) = sym(regexprep(obs_eqns{i},'\.',''));
            end
            
            % -----  Compute the Jacobian of Observables wrt States  ------------------
            dObsdx{iexp} =  jacobian(fobs,stS);
            
        end
    end
else

end



%% Sensitivities of States wrt Inputs
if dfdinp_flag
    n_inp = inputs.model.n_stimulus;
    
    if n_inp > 0
        % inputs are defined.
        
        
        for i = 1 : n_inp
            inp_names{i,1} = inputs.model.stimulus_names(i,:);
        end
        
        inpS = sym(inp_names);
        
        
        % -----  Compute the Jacobian of Observables wrt States  ------------------
        dfdinp =   jacobian(fsys,inpS) + jacobian(fsys,algS)*jacobian(falg,inpS);
        
        
    else
        for iexp = 1:inputs.exps.n_exp
            dfdinp = [];
        end
    end
else
    for iexp = 1:inputs.exps.n_exp
        dfdinp = [];
    end
end
