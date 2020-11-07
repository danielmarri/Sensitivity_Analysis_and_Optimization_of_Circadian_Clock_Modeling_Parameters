function [dhdx dhdp] = AMIGO_generateObsSensRHS(statenames,parnames,obseqns)


n_obs = size(obseqns,1);
nst = size(statenames,1);
npar = size(parnames,1);
obseqns = cellstr(obseqns);


eqns_splitted =  regexp(obseqns,'=','split');
for iobs = 1:n_obs
    obsname{iobs,1} = eqns_splitted{iobs}(1);
    obsrhs{iobs,1}  = eqns_splitted{iobs}(2);
end

% create symbolic variables and functions
obsS = sym([obsname{:}]');
for iobs = 1: n_obs
    tmp = strrep(obsrhs{iobs},'.','');
    h(iobs,1) = sym(tmp);
end
st = cellstr(statenames);
stS = sym(st);
par = cellstr(parnames);
parS = sym(par);

% compute the analytic partial derivatives
dhdx = jacobian(h,stS);
dhdp = jacobian(h,parS);

end