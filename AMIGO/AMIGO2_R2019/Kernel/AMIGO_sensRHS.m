% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_sensRHS.m 2161 2015-09-22 07:18:19Z attila $
function inputs = AMIGO_sensRHS(inputs)
% ----  Core code ---------------------------------------------------------
% the code computes analytically the right hand side of the Sensitivity equation
%
% The system can be index-1 DAE system in the form F = F(t,r(t,x,k),x,k), where
% r = r(t,x,k) defines algebraic equations of the time, parameters and states,
% e.g. represents the reaction rate expressions.
% However we use that, the reaction r does not depends on itself.


% -----  Initialization of the variables ----------------------------------
fprintf('\n\n\n------> Constructing the Forward Sensitivity Equations....\n');

if ~isfield(inputs.model,'sym')
    [stS,parS,algS,fsys,falg,dfdx,dfdp]=AMIGO_charmodel2syms(inputs);
else
    stS  = inputs.model.sym.stS;
    parS = inputs.model.sym.parS;
    algS = inputs.model.sym.algS;
    fsys = inputs.model.sym.fsys;
    falg = inputs.model.sym.falg;
    dfdx = inputs.model.sym.dfdx;
    dfdp = inputs.model.sym.dfdp;
    inputs.model = rmfield(inputs.model,'sym');
end

n_ode = numel(fsys);
n_pars = numel(parS);



y = sym('s%d',[n_ode 1]);
sensrhsI = dfdx*y;
%disp(sensrhsI)

% for i = 1:n_pars
%     sensrhs{i} =sensrhsI + dfdp(:,i) ;%simplify(sensrhsI + dfdp(:,i));
%     %fprintf('sens rhs w.r.t. p%d\n',i)
%     %disp(sensrhs{i})
% end


%disp('Symbolic Jacobian of the system (df/dx):')
%disp(dfdx)
%disp('Symbolic parametric Jacobian of the system (df/dp):')
%disp(dfdp)
% ---- Convert syms to text format ----------------------------------------
dfdx = dfdx.'; % write out row-wise
tmp_dfdx = dfdx(:); % put in a vector
%tmp_dfdp = dfdp(:);
% tmp_dfdxsi = sensrhsI(:);


% Jacobian
fprintf('Symbolic Jacobian of the dynamic equations to text:')
index = 0;
if isempty(inputs.model.J)
    tmp2 = cell(n_ode*n_ode,1);
    for i = 1:n_ode
        for j=1:n_ode
            index = index+1;
            tmp2{index} = char(tmp_dfdx(index));
        end
        if ~mod(i,floor(n_ode/10))
            fprintf('.');
        end
    end
    
    inputs.model.J = tmp2;%char(tmp2);
end
fprintf('  Done.\n')

fprintf('Symbolic Sensitivities of the dynamic equations to text:\n')
fprintf('First part(df/dx*s): ')
tic
% Forward Sensitivity equations first part:
tmp2 = cell(n_ode,1);
for j = 1:n_ode
        tmp2{j} = char(sensrhsI(j));
        if ~mod(j,floor(n_ode/10))
            fprintf('.');
        end
end
inputs.model.sens.rhsI = tmp2;% char(tmp2);
fprintf('  Done\n');

% Forward Sensitivity equations second part:
fprintf('Second part(df/dp): ')
inputs.model.sens.rhsII = cell(n_pars,1);
index = 0;
tmp2 = cell(n_ode*n_pars,1);
for j = 1:n_pars
    wrtParj = dfdp(:,j);
    for i = 1:n_ode
        index = index+1;
        tmp2{index} = char(wrtParj(i));
    end
    if ~mod(j,floor(n_pars/10))
        fprintf('.');
    end
end
inputs.model.sens.rhsII = tmp2;% char(tmp2);
fprintf('  Done\n');
% 
% tic
% tmp2 = cell(n_ode*n_pars,1);
% index = 0;
% fprintf('Converting the symbolic expr. to characters.\n');
% for j = 1:n_pars
%     wrtParj = sensrhs{j};
%     for i = 1:n_ode
%         index = index+1;
%         tmp2{index} = char(wrtParj(i));
%     end
%     if ~mod(j,floor(n_pars/10))
%         fprintf('.');
%     end
% end
% inputs.model.sens.rhs = char(tmp2);
% toc

% Forward sensitivity equaitions wrt the initial conditions 
% tmp2 = cell(n_ode,1);
% for i = 1:n_ode
%         tmp2{i} = char(sensrhsI(i));
% end
inputs.model.sens.rhsIC = inputs.model.sens.rhsI;% char(tmp2);
toc
