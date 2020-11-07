function [f,h,g,regobj,regres,t0] = AMIGO_getPEcost(theta,inputs,results,privstruct)
% returns AMIGO_Pecost
%[f,h,g,regobj,regres] = AMIGO_getPEcost(theta,inputs)

if nargin < 4
[inputs,results,privstruct]=AMIGO_Structs_PE(inputs);
end
% if ~isempty(inputs.PEsol.log_var)
%     theta(inputs.PEsol.log_var) = log(theta(inputs.PEsol.log_var));
% end


if size(theta,1) == 1
    tic;
    [f,h,g,regobj,regres] = AMIGO_PEcost(theta,inputs,results,privstruct);
    t0 = toc;
else
    % multiple parameter vector is given.
    for itheta = size(theta,1):-1:1
        % reverse evaluation for memory efficiency
        tic;
        [f(itheta),h(itheta),g(:,itheta),regobj(itheta),regres(:,itheta)] = AMIGO_PEcost(theta(itheta,:),inputs,results,privstruct);
        t0(itheta) = toc;
    end
end