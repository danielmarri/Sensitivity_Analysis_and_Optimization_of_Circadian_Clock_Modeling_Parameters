function  [lcurve index_maxcurvature]= AMIGO_LCurve(reg_summary, plotflag)
% AMIGO_LCurve computes and plots the curvature of the Lcurve.

if nargin < 2  || isempty(plotflag)
    plotflag = true;
end

alphaSet = reg_summary.alpha;
Q_LS = reg_summary.Q_LS;
Q_penalty = reg_summary.Q_penalty;

% make sure the ordering is correct:
[alphaSet,ix]= sort(alphaSet,'ascend');    
Q_LS = Q_LS(ix);
Q_penalty = Q_penalty(ix);

% check/remove piling and dominated points:
[Q_LS,Q_penalty,Ind] = AMIGO_ParetoFilter(Q_LS,Q_penalty);
alphaSet = alphaSet(Ind);
h = figure();
AMIGO_update_LCurve_plot(h,Q_LS,Q_penalty,alphaSet,[],[]);

% compute curvatures of the reduced Pareto front:
[n_lcurve curvature salphaSet  explCurvature implCurvature]= RM_lcurve_ndiff(alphaSet,Q_LS,Q_penalty);


% index of maximum curvature point among the original points
index_maxcurvature = Ind(n_lcurve);

lcurve.alpha = salphaSet;
lcurve.Q_LS = Q_LS;
lcurve.Q_penalty = Q_penalty;
lcurve.index_maxcurvature = n_lcurve;
lcurve.curvature = curvature;
lcurve.explCurvature = explCurvature;
lcurve.implCurvature = implCurvature;

if plotflag
    figure()
   % plot(salphaSet,curvature,'.-',salphaSet,explCurvature,'.-',salphaSet,implCurvature,'.-')
    plot(salphaSet,curvature,'.-')
    set(gca,'xscale','log')
    title({'Curvature of the L-curve'},'interpreter','none')
    xlabel('Regularization parameter (\alpha_i)')
    ylabel('Curvature of $$(Q_{LS}(\hat\theta_{\alpha_i}),\Gamma(\hat\theta_{\alpha_i}))$$','interpreter','latex')
    %legend('Line-curvature','Explicit formula','Implicit formula')
    legend('Line-curvature')
end