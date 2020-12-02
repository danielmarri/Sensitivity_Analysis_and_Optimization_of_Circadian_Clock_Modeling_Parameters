function  AMIGO_update_LCurve_plot(hfig,Q_cost,Q_penalty,alpha,titlestr,formatpts)
% AMIGO_update_LCurve_plot(Q_cost,Q_penalty,alpha,titlestr) creates or
% updates the LCurve by adding the new points and text

if nargin < 5 || isempty(titlestr)
    titlestr = 'L-curve';
end
if nargin < 6 || isempty(formatpts)
    formatpts = 'kx';
end
if isempty(hfig)
    hfig = floor(rand(1)*1000);
end
if ~ ishandle(hfig)
    figure(hfig);
    ah = axes;
else
    set(0,'CurrentFigure',hfig)
    ah = gca();
end
title(titlestr)
hold on
npoints = length(Q_cost);

for i = 1:npoints
    plot(ah,Q_cost(i),Q_penalty(i),formatpts,'LineWidth',2,'Markersize',10)
    text(Q_cost(i),Q_penalty(i),AMIGO_num2latexstr(alpha(i),2),'VerticalAlignment','bottom', ...
    'HorizontalAlignment','left',...
    'FontSize',12)
    xlabel('Model fit (Q_{LS})')
    ylabel('Solution norm: $$||W(\hat\theta_{\alpha_i})||^2$$','interpreter','latex')
    %             legendstr{ialpha} = sprintf('%g',alphaSet(ialpha));
    %             legend(legendstr)
end
% shg