function [JTJ RR2] = FD_Hessian(p,ndata, fun_residuals, fun_jacobian, dp)
% computes the Hessian of the least squares cost function based on finite
% differences of the Jacobian:
% H = J'J + Sum_i r_i \partial^2r_i\partial p^2
%
% Inputs:
%   p: parameter vector
%   ndata: number of residuals
%   fun_residuals: function handle that returns the residuals : 
%                r_i =  (y_i,modelled - y_i,measured). 
%   fun_jacobian : function handle that returns the jacobian: J(i,j)=dr_i/dp_j
%   dp: (optional) perturbation length if scalar, or perturbation in each coordinates 
% outputs:
%   JTJ: J^TJ approximation of the Hessian
%   RR2: the second order part of the hessian: \sum r_i dr/dp^2, computed based on the
%   finite forward difference of the Jacobian (J(p+dp_i)-J(p))/||dp_i||. 

p = p(:);
npar = length(p);
% H3 = 'only for test';

if nargin < 5
    dp = repmat(sqrt(eps),npar,1);
else
    if length(dp) == 1
        dp = repmat(dp,npar,1);
    else
        assert(length(dp)==length(p),'dp must have the same size as p.')
    end
end

R = fun_residuals(p);
J = fun_jacobian(p);

assert(all(size(R)==[ndata,1]),'The size of the obtained Residuals is incorrect.')
assert(all(size(J)==[ndata, npar]),'The size of the obtained Jacobian is incorrect.')

JTJ = J'*J;

% create basis vectors
E = eye(npar);
RR2 = zeros(npar,npar);
% for testing:
% H3 = zeros(npar,npar,ndata);
% % Forward difference:
% for ip = 1:npar
%     e = E(:,ip)*dp(ip); % perturbation vector.
%     p2 = p+1/2*e;
%     J2 = fun_jacobian(p2);
%     dr2 = (J2-J)/norm(e);
%     RR2(ip,:) = R'*dr2;
%     %H3(ip,:,:) = dJ';
% end
% Central finite difference:
for ip = 1:npar
    e = E(:,ip)*dp(ip); % perturbation vector.
    pf = p+1/2*e;
    Jf = fun_jacobian(pf);
    pb = p - 1/2*e;
    Jb = fun_jacobian(pb);
    dr2 = (Jf-Jb)/norm(e);
    RR2(ip,:) = R'*dr2;
    %H3(ip,:,:) = dJ';
end
