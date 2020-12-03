% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_sensRHS2008.m 770 2013-08-06 09:41:45Z attila $
function inputs = AMIGO_sensRHS2008(inputs)
% Analytic derivation of the sensitivity equations fo CVODES.
%



% -----  Initialization of the variables ----------------------------------
fprintf('\n\n\n------>Constructing the Righ Hand Side....\n');


% create symbolic parameter variables
par = cellstr(inputs.model.par_names);
parS = [];
for i = 1:length(par)
    parS = [parS; sym(par{i})];
end
n_pars = length(parS);


% create symbolic state variables
st = cellstr(inputs.model.st_names);
stS = [];
for i = 1:length(st)
    stS = [stS; sym(st{i})];
end
n_st = length(stS);


% create symbolic stimulus variables
stim=cellstr(inputs.model.stimulus_names);
stimS = [];
for i = 1:length(stim)
    stimS = [stimS; sym(stim{i})];
end


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
% fprintf('%d algebraic and %d differential equations are found.\n',n_alg,n_ode);
% 
% if inputs.model.n_st ~= n_ode
%     error('Number of states and number of ODEs are not matching...')
% end
%---- split the algebraic equations using the = sign ----------------------
% create algebraic variables if there is any:
if n_alg
    alg_splitted =  regexp(eqns(posAlg),'=','split');
    
    for i = 1 : n_alg
        alg_names{i,1} = alg_splitted{i}(1);
        alg_eqns{i,1}  = alg_splitted{i}(2);
    end
    algS = sym([alg_names{:}]');
    % create symbolic state and algebraic equations
    for i = 1: n_alg
        falg(i,1) = sym(alg_eqns{i});
    end
else
    algS = sym;
    falg = sym;
end

%---- split the ODEs using the = sign -------------------------------------
ode_splitted =  regexp(eqns(posODE),'=','split');


for i = 1 : n_ode
    ode_names{i,1} = ode_splitted{i}(1);
    ode_eqns{i,1}  = ode_splitted{i}(2);
end


ode_n=[];
ode_e=[];
odeS=[];
fsys=[];
for i = 1 : n_ode
    ode_n = [ode_n cellstr(ode_names{i,:})].';
    ode_e  = [ode_e cellstr(ode_eqns{i,:})].';
    odeS=[odeS sym(ode_n{i})].';
    fsys=[fsys sym(ode_e{i})].';
end




ds=[];
inputs.model.sens1_name=[];
for i=1:length(st)
    for j=1:length(par)
        si(j)=sym(strcat('s',num2str(i),num2str(j)));
        inputs.model.sens1_name=[inputs.model.sens1_name; si(j)];
        dsi(j)=sym(strcat('ds',num2str(i),num2str(j)));
        ds=[ds dsi(j)];
    end
end
inputs.model.sens1_name
A = reshape(inputs.model.sens1_name,length(st),length(par));

sens1_sym=reshape(jacobian(fsys,stS)*A+jacobian(fsys,parS),length(par)*length(st),1 )



oed_cell=[];
name_cell=[];
for r=1:length(st)
name_cell=[name_cell; cell(stS(r))];    
oed_cell=[oed_cell; cell(fsys(r))];
end


sens1_cell=[oed_cell];
sens1_name=[name_cell];
for k=1:length(sens1_sym)
sens1_cell=[sens1_cell; cell(sens1_sym(k))];
sens1_name=[sens1_name; cell(inputs.model.sens1_name(k))];
end

inputs.model.sens1_eqns=char(sens1_cell);
inputs.model.sens1_name=char(sens1_name);


inputs.model.sens.rhs = inputs.model.sens1_eqns;

%% 
%  This kind of sensitivity is actually extends the original statespace with the
%  sensitivity states - from CVODES point of view it is not a sensitivity
%  computation:
inputs.model.AMIGOsensrhs = 0;

% change the states and their number:
inputs.model.st_names = inputs.model.sens1_name;
inputs.model.n_st = inputs.model.n_st + inputs.model.n_st*inputs.model.n_par;
% change the model equations:
inputs.model.eqns = strcat('d',inputs.model.sens1_name, '=',inputs.model.sens1_eqns);



