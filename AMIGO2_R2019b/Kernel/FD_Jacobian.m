function [J] = FD_Jacobian(p,ndata, fun_residuals, dp, method)
% computes the Jacobian of the least squares cost function based on finite
% differences of the Residuals:
% J = partial R \ partial p
%
% SYNTAX:
%   [J] = FD_Jacobian(p,ndata, fun_residuals, dp, method)
%
% Inputs:
%   p: parameter vector
%   ndata: number of residuals
%   fun_residuals: function handle that returns the residuals : 
%                r_i =  (y_i,modelled - y_i,measured). 
%   dp: (optional) perturbation length if scalar, or perturbation in each coordinates 
%   method: method to compute, i.e. [forward finite difference] ('ffd') or
%                                    central finite diff ('cfd')
% outputs:
%   J: J  approximation of the Jacobian


p = p(:);
npar = length(p);
% H3 = 'only for test';

if nargin < 4  || isempty(dp)
    dp = repmat(sqrt(eps),npar,1);
else
    if length(dp) == 1
        dp = repmat(dp,npar,1);
    else
        assert(length(dp)==length(p),'dp must have the same size as p.')
    end
end

if nargin < 5 || isempty(method)
    method = 'ffd';
else
    assert(strcmpi(method,'ffd') | strcmpi(method,'cfd'),'input argument: method = ''ffd'' | ''cfd''. ')
end

R = fun_residuals(p);
% J = fun_jacobian(p);

assert(all(size(R)==[ndata,1]),'The size of the obtained Residuals is incorrect.')
% assert(all(size(J)==[ndata, npar]),'The size of the obtained Jacobian is incorrect.')


% create basis vectors
E = eye(npar);
J = zeros(ndata,npar);
% for testing:
% H3 = zeros(npar,npar,ndata);
% Forward difference:
if strcmpi(method,'ffd')
    for ip = 1:npar
        e = E(:,ip)*dp(ip); % perturbation vector.
        p2 = p+e;
        R2 = fun_residuals(p2);
        J(:,ip) = (R2-R)/norm(e);
    end
else % strcmpi(method,'cfd')
    % Central finite difference:
    for ip = 1:npar
        e = E(:,ip)*dp(ip); % perturbation vector.
        pf = p+1/2*e;
        Rf = fun_residuals(pf);
        pb = p - 1/2*e;
        Rb = fun_residuals(pb);
        dr2 = (Rf-Rb)/norm(e);
        J(:,ip) = dr2;
        %H3(ip,:,:) = dJ';
    end
end