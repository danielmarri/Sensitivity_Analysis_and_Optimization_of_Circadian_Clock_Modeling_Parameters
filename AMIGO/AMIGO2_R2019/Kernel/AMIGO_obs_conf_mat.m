function [obs_cov_mat obs_conf_mat]  = AMIGO_obs_conf_mat(g_var_cov_mat,sens,ssquare)
% Compute the covariance matrix and the confidence interval (alpha=0.05) of the observations
% functions in the same timepoints, in which the experiments are given..
% See Bates & Watts (1988) Nonlinear Regression Analysis and its Applications p58 for details. 
% inputs:
%   g_var_cov_mat: covariance matrix of the estimated parameters
%   sens: sensitivity of the residuals 
%   ssquare: the standard deviation of the parameters -- not used,
%   g_var_covar already contain them.

[ntp,nobs,npar] = size(sens);

% covariance of the observables:
C = zeros(nobs,nobs,ntp);
S = zeros(ntp,nobs);
% standard deviation of the observables:
if (ntp*nobs-npar>0)

f = sqrt(npar * Finverse(0.95,npar,ntp*nobs-npar)); % .95 percentile
% try
for t=1:ntp
%    C(:,:,t) = squeeze(sens(t,:,:))*g_var_cov_mat*squeeze(sens(t,:,:))';
    %ARE these equivalent? squeeze is not OK for 1 observable. - OK.
    %17.07.2014
    S_tp = reshape(sens(t,:,:),nobs,npar)';
  C(:,:,t) = S_tp.'*g_var_cov_mat*S_tp;
  S(t,:) = f*sqrt(diag(C(:,:,t)));  
end
% catch er
%     disp('error in AMIGO_obs_conf_mat ')
%     keyboard;
% end
end
obs_conf_mat = S;
obs_cov_mat = C;




function x  = Finverse(y,nomDOF,denomDOF)
% computes the inverse of the CDF of the F distr. 
z = denomDOF/2;
w = nomDOF/2;

b = betaincinv(y,z,w,'upper');
x = denomDOF/(b*nomDOF) - denomDOF/nomDOF;
