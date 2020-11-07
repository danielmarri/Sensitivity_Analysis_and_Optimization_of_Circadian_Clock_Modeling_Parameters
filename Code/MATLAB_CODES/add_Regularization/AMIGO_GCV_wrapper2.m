function GCV = AMIGO_GCV_wrapper2(PE_results,plotflag)
%AMIGO_GCV choose the optimal regularization parameter according to the general cross validation criteria
%
% SYNTAX:
%   GCV = AMIGO_GCV(PE_results) where
%           PE_results are AMIGO_PE output structure using regularization, which
%           contains:
%           - fit.thetabest: optimized decision vector
%           - regularization.alpha: reg. parameter
%           - fit.R:  residual vector (regularization terms included)
%           - fit.Rjac:  residual Jacobian matrix (regularization terms included)

if nargin < 2  || isempty(plotflag)
    plotflag = true;
end

npar = length(PE_results(1).fit.thetabest);
for ires = 1:length(PE_results)
    alphaSet(ires) = PE_results(ires).regularization.alpha;
    
    alpha = PE_results(ires).regularization.alpha;
    R = PE_results(ires).fit.R(1:end-npar)';
    n = length(R);
    Jr = PE_results(ires).fit.Rjac;
    W = PE_results(ires).fit.Rjac(end-npar+1:end,:)./sqrt(alpha);
    J = PE_results(ires).fit.Rjac(1:end-npar,:);
    [V(ires) A{ires}]= AMIGO_gcv(R,J,alpha,W);
    
end

[~, n_opt_GCV] = min(V);

%     GCV.A = A;
GCV.V = V;
GCV.n_opt= n_opt_GCV;
if n_opt_GCV == 1 ||n_opt_GCV == length(V)
    GCV.onbound = 1;
    fprintf('WARNING Message:\n\t\t According to GCV the optimal regularization parameter is on the boundary of the search interval.\n')
    fprintf('\t\tYou should increase the bounds for the regularization parameter.\n')
else
    GCV.onbound = 0;
end

GCV.opt_PEresults = PE_results(n_opt_GCV);
if plotflag
    figure()
    plot(alphaSet,V,'.--')
    set(gca,'xscale','log')
    title('GCV curve')
    xlabel('Regularization parameter (\alpha_i)')
    ylabel('estimated CV error')
end