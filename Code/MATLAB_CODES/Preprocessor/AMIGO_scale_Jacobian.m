function [JacRes,JacObj] = AMIGO_scale_Jacobian(JacRes,JacObj,theta, inputs)
% AMIGO_scale_Jacobian scales the Jacobian of the residuals.
%
% If the parameter vector is scaled the sensitivity must be also scaled.




scaled_model = false;

% Preparing the logarithmic scaling of the global parameters

if ~isempty(inputs.PEsol.log_var)
    JacRes(:,inputs.PEsol.log_var) = JacRes(:,inputs.PEsol.log_var).*repmat(theta(inputs.PEsol.log_var)',size(JacRes,1),1);
    JacObj(inputs.PEsol.log_var) = JacObj(inputs.PEsol.log_var).*theta(inputs.PEsol.log_var)';
end

if ~isempty(inputs.PEsol.lin_scaled_var)
    sc_fac = inputs.PEsol.lin_scaled_factor;
    sc_fac = sc_fac(:);
    JacRes(:,inputs.PEsol.lin_scaled_var) = JacRes(:,inputs.PEsol.lin_scaled_var)./repmat(sc_fac',size(JacRes,1),1);
    JacObj(inputs.PEsol.lin_scaled_var) = JacObj(inputs.PEsol.lin_scaled_var)./sc_fac';
end


