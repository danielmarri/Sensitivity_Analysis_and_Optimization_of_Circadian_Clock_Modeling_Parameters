function [JacObj,Jach, JacRes, JacRegObj, JacRegRes] = AMIGO_getPEJac(theta,inputs)
% returns AMIGO_PEJac output.

[inputs,results,privstruct]=AMIGO_Structs_PE(inputs);

if ~isempty(inputs.PEsol.log_var)
    theta(inputs.PEsol.log_var) = log(theta(inputs.PEsol.log_var));
end

[JacObj,Jach, JacRes, JacRegObj, JacRegRes] = AMIGO_PEJac(theta,inputs,results,privstruct);