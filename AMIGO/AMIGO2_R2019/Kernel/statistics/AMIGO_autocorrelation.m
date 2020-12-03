function [autoCorrCoeff autoCorrCoeff_std lag_pars]= AMIGO_autocorrelation(R,maxLag)
% computes the autocorrelation coefficients of the residuals
% up to the maximum lag parametr: maxLag
%
% the autocorrelation with lag parameter k is 
%  AC_k = 1/sigma^2 * 1/(N-k) * \sum_i^(N-k) r(i)r(i+k)
%
% where sigma^2 is the variance of the residuals: (r'*r)/(N)



[n_time n_obs] = size(R);

if nargin<2 || isempty(maxLag)
    maxLag = min(5,n_time-1);
end

% compute the variance and mean of the residuals
var_iobs = zeros(n_obs,1);
for iobs = 1:n_obs
        var_iobs(iobs) = R(:,iobs).'*R(:,iobs)/(n_time-1);
end
var_tot = R(:)'*R(:)/(n_time*n_obs-1);


lag_pars = [0:maxLag];

Rt = R.';
cor = zeros(n_obs,1);

for lag = lag_pars
    % observable-wise:
    for iobs = 1:n_obs
        cor(iobs) = R(1:end-lag,iobs).'*R(lag+1:end,iobs);
    end
%     cor = 0;
%     for ti = 1: n_time-lag
%         cor = cor + R(ti,:).*R(ti+lag,:);
%     end
    ck = cor/(n_time-lag-1);
    autoCorrCoeff(lag+1,:) = ck./var_iobs;
    autoCorrCoeff_std(lag+1,:) = repmat(1 /sqrt(n_time-lag-1),1,n_obs);
end

