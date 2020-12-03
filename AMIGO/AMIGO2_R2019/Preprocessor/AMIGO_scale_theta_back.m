function theta = AMIGO_scale_theta_back(scaled_theta, inputs)
% AMIGO_scale_theta scales the model parameters and parameter bounds.



scaled_model = false;
scaled_theta = scaled_theta(:);
% Preparing the logarithmic scaling of the global parameters

if ~isempty(inputs.PEsol.log_var)
    scaled_model = true;
    theta(inputs.PEsol.log_var) = exp(scaled_theta(inputs.PEsol.log_var));
end

if ~isempty(inputs.PEsol.lin_scaled_var)
    scaled_model = true;
    theta(inputs.PEsol.lin_scaled_var) = scaled_theta(inputs.PEsol.lin_scaled_var).*inputs.PEsol.lin_scaled_factor(:);
end

if ~scaled_model
theta = scaled_theta;
end
