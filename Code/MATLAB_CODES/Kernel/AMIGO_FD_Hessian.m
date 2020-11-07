function [Hessian JJ RR2 J R] = AMIGO_FD_Hessian(p,inputs,privstruct,results)
% computes the Hessian of the Least Squares objective function.
% the computation involves npar number of gradient evaluation, thus it may timeconsuming.
% inputs: 
%   p: parameter vector
%   inputs: AMIGO_PE input structure
% outputs:
%   Hessian : npar*npar matrix of the Hessian
%   JJ: the J^TJ approximation of the Hessian
%   RR2: the second order part: \sum r_i dr/dp^2, computed based on the
%   finite central difference of the Jacobian (J(p+0.5dp_i)-J(p-0.5dp_i))/||dp_i||. 


% [inputs,results,privstruct]=REG_Structs_PE(inputs);

R = residuals(p);
ndata = numel(R);

[JJ RR2] = FD_Hessian(p,ndata,@residuals,@jacobian,1e-3*p);
RR2 = 1/2*(RR2 + RR2');

Hessian = 2*JJ-2*RR2;

% symmetrize.
Hessian = 1/2*(Hessian + Hessian');

J = jacobian(p);
R = residuals(p);

    function R = residuals(x)
        % collects the appropriate output of AMIGO_PEcost
        [~,~,R,~,~] = AMIGO_PEcost(x,inputs,results,privstruct);
        R = R(:);
    end
    function J = jacobian(x)
        % collects the appropriate output of AMIGO_PEJac
        [~,~, J, ~, ~] = AMIGO_PEJac(x,inputs,results,privstruct);
    end

end