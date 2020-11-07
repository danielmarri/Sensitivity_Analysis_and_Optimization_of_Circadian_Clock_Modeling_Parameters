function n_opt = AMIGO_lcurve_curvature(X,R,alpha,plot_flag)
%AMIGO_lcurve_curvature(X,R,alpha) computes the optimal regularization parameter
% based on the L-curve maximal curvature detection method.
%
%   Inputs:
%   R   residuals matrix, each column corresponding to the regularization parameter.
%   X   solution matrix, each column is the solution corresponding to a reg. par.
%   noiseStd    standard deviation of the noise
%   alpha   regularization parameter vector


fprintf('--> Regularization by the L-curve method, maximal curvature detection\n')

if nargin < 4 || isempty(plot_flag)
    plot_flag = false;
end

nreg = length(alpha);


[~, ind] = sort(alpha,'descend');


if any(ind~=1:nreg)
    fprintf('--> ERROR: For the L-curve method, the entries should be sorted accorgding to decreasing regularization parameter\n\n')
    n_opt = 1;
    return;
end

nR = nan(nreg,1);
Q = nan(nreg,1);
for n = 1:nreg
    Q_LS(n)= norm(R(:,n));
    Q_penalty(n)= norm(X(:,n) );
end


[alpha,ix]= sort(alpha,'ascend');   
ref = 1:nreg;
sref = ref(ix);
Q_LS = Q_LS(ix);
Q_penalty = Q_penalty(ix);
% check/remove piling and dominated points:
[Q_LS,Q_penalty,Ind] = AMIGO_ParetoFilter(Q_LS,Q_penalty);
alpha = alpha(Ind);

[n_lcurve curvature salpha  explCurvature implCurvature]= RM_lcurve_ndiff(alpha,(Q_LS),(Q_penalty));
n_opt = sref(Ind(n_lcurve));
% n_opt = n_lcurve;


if n_opt == 1
    fprintf('--> WARNING: L-curve method\n\t Obtained regularization parameter is on the bound. You may increase the bound for the reg. parameter.\n\n')
elseif n_opt == nreg-1
    fprintf('--> WARNING: L-curve method\n\t Obtained regularization parameter is on the bound. You may decrease the bound for the reg. parameter.\n\n')
end

if plot_flag
    figure()
    subplot 211
    plot(Q_LS,Q_penalty,'.-')
    title('L- curve')
    xlabel('sum of squared residuals')
    ylabel('solution norm')
    subplot 212
    plot(salpha,curvature,'.-'), hold on
    plot(salpha(n_lcurve),curvature(n_lcurve),'r*')
    xlabel('regularization parameter')
    ylabel('curvature of the L-curve')
    
    set(gca,'xscale','log')
    
end