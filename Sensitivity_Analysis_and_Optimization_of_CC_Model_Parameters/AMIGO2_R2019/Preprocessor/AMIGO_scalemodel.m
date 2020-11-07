function inputs_chd = AMIGO_scalemodel(inputs,sc_st,sc_par)
% AMIGO_scalemodel(inputs,sc_st,sc_par) scales the model states and
% parameters with the given values in the model equations.
% This requires charmodelC input type!
%
% INPUTS:
%   inputs  AMIGO inputs continaing the model
%           neccessary fields are:
%
%   sc_st   scaling constants for the states
%   sc_par  scaling constants for the parameter values
%       indicate by NaN factor if a variable should not be scaled.
%
%   OUTPUT
%   inputs_chd  a structure similar to inputs, but contains only the
%               fields that were changed.

% scale model equations
st_eqns = AMIGO_scale_variables_in_equations(inputs.model.eqns,inputs.model.st_names,sc_st);
st_eqns = AMIGO_scale_variables_in_equations(st_eqns,inputs.model.par_names,sc_par);
inputs_chd.model.eqns =st_eqns;

% scale observation equations
for iexp = 1:inputs.exps.n_exp
    obs_eqns = AMIGO_scale_variables_in_equations(inputs.exps.obs{iexp},inputs.model.st_names,sc_st);
    obs_eqns = AMIGO_scale_variables_in_equations(obs_eqns,inputs.model.par_names,sc_par);
    inputs_chd.exps.obs{iexp} = obs_eqns;
end

% scale nominal parameters
npar = length(inputs.model.par);
for ipar = 1:npar
    if isnan(sc_par(ipar))
        inputs_chd.model.par(ipar) = inputs.model.par(ipar);
    else
        inputs_chd.model.par(ipar) =  inputs.model.par(ipar)/sc_par(ipar);
    end
end


% scale initial conditions
nst = size(inputs.model.st_names,1);
for iexp = 1:inputs.exps.n_exp
    for ist = 1:nst
        if isnan(sc_st(ist))
            inputs_chd.exps.exp_y0{iexp}(ist) = inputs.exps.exp_y0{iexp}(ist);
        else
            inputs_chd.exps.exp_y0{iexp}(ist) = inputs.exps.exp_y0{iexp}(ist)/sc_st(ist);
        end
    end
end

end


