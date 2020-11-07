function n_opt = AMIGO_lcurve_reginska(X,R,alpha,Nmax,Nmin,plot_flag)
%AMIGO_lcurve_reginska(A,x,noiseStd,alpha) computes the optimal regularization parameter
% based on the L-curve method.
%
%   Inputs:
%   A   regression matrix
%   X   solution matrix, each column is the solution corresponding to a reg. par.
%   noiseStd    standard deviation of the noise
%   alpha   regularization parameter vector
fprintf('--> Regularization by the L-curve method, Reginska variant\n')
if nargin < 6 || isempty(plot_flag)
    plot_flag = false;
end

nreg = length(alpha);


[~, ind] = sort(alpha,'descend');
if any(ind~=1:nreg)
    fprintf('--> ERROR: For the L-curve method, the entries should be sorted accorgding to decreasing regularization parameter\n\n')
    n_opt = 1;
    return;
end

nR = nan(Nmax,1);
Q = nan(Nmax,1);
for n = Nmin:Nmax
    nR(n)= norm(R(:,n));
    Q(n)= norm(X(:,n) );
end
% figure()
% plot(alpha(1:Nmax),nR.*Q,'.-');
% set(gca,'xscale','log')

crit = nR.*Q;
[~, n_opt] = min(crit);

if n_opt == Nmin
    fprintf('--> WARNING: L-curve method\n\t Obtained regularization parameter is on the bound. You may increase the bound for the reg. parameter.\n\n')
elseif n_opt == Nmax
    fprintf('--> WARNING: L-curve method\n\t Obtained regularization parameter is on the bound. You may decrease the bound for the reg. parameter.\n\n')
end

if plot_flag
    figure()
    subplot 211
    plot(nR,Q,'.-')
    title('L-curve, Reginska variant')
    xlabel('sum of squared residuals')
    ylabel('solution norm')
    subplot 212
    plot(alpha(Nmin:Nmax),crit(Nmin:Nmax),'.-'), hold on
    plot(alpha(n_opt),crit(n_opt),'r*')
    xlabel('regularization parameter')
    ylabel('curvature of the L-curve')
    set(gca,'yscale','log')
    set(gca,'xscale','log')
end
