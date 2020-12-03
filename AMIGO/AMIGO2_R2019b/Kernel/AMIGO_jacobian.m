% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_jacobian.m 2041 2015-08-24 12:34:10Z attila $
function inputs = AMIGO_jacobian(inputs)
% ----  Core code ---------------------------------------------------------
% the code computes analytically the Jacobian (dF/dx) of the right hand
% side term (F) with respect to the states (x).
%


% -----  Initialization of the variables ----------------------------------
fprintf('\n\n\n------>Constructing the Jacobian....\n');


[stS,parS,algS,fsys,falg,dfdx,dfdp]=AMIGO_charmodel2syms(inputs);

n_ode = numel(fsys);
n_pars = numel(parS);



%disp('Symbolic Jacobian of the system (df/dx):')
%disp(dfdx)
%disp('Symbolic parametric Jacobian of the system (df/dp):')
%disp(dfdp)
% ---- Convert syms to text format ----------------------------------------
dfdx2 = dfdx.'; % write out row-wise
dfdp2 = dfdp.';
tmp_dfdx = dfdx2(:); % put in a vector
tmp_dfdp = dfdp2(:);
index = 0;
inputs.model.J = '';
tmp2 = cell(n_ode*n_ode,1);
for i = 1:n_ode
    for j=1:n_ode
        index = index+1;
        tmp2{index} = char(tmp_dfdx(index));
    end
end

inputs.model.J =tmp2;


tmp2 = cell(n_ode * n_pars,1);
index = 0;
for i = 1:n_ode
    for j=1:n_pars
        index = index+1;
        tmp2{index} = char(tmp_dfdp(index));
    end
end

inputs.model.Jpar = tmp2;

% save the symbolic variables for a possible sensitivity calculation.
inputs.model.sym = struct('stS', stS,...
                          'parS',parS,...
                          'algS',algS,...
                          'fsys',fsys,...
                          'falg',falg,...
                          'dfdx',dfdx,...
                          'dfdp',dfdp);
                      
AMIGO_test_dfdx(inputs);

