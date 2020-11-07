function d = AMIGO_effective_npar(FIM,alpha,W)
%  AMIGO_effective_npar(FIM,alpha,W) computes the approximate effective number of parameters.
% INPUTS:
%   - FIM: observed Fisher Information Matrix
%   - alpha: regularization parameter
%   - W: regularization scaling matrix (default: I)

Q = FIM;
npar  = size(Q,1);
if nargin < 3
    W = eye(npar);
end

% 
d = trace(Q*pinv(Q+alpha*(W'*W))*Q*pinv(Q+alpha*(W'*W)));
% increase robustness:
d = max(d,0);
d = min(d,npar);