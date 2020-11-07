function AMIGO_plot_comparedParameters(p1,pn,legendstr)
%AMIGO_plot_comparedParameters(p1,p2,p3) depicts the vectors (supposely
%estimated parameters) by plotting using different methods.
% p1: first candidate vector
% pn: nominal parameter vector

if nargin < 3
    legendstr = 'parameter values';
end


% plot diagonally, depicted each parameter by a dot 
figure()
ph1 = plot(pn,p1,'o','markersize',2,'linewidth',2);
xlabel('Nominal parameters')
ylabel('Estimated parameters')
axis tight
hold on
% plot the diagonal:
xl = xlim;
yl = ylim;
line(xl,yl,'color','black')
legend(ph1,legendstr)

if ~any(pn<=0) &&  max(pn) > 100*min(pn)
    set(gca,'xscale','log','yscale','log')
end
AMIGO_fig2publish(gcf,14);

% %% plot ratios:
% pr = p1./repmat(pn,size(p1,1),1);
% pu = prctile(pr,75,2);
% pl = prctile(pr,25,2);
% 
% figure()
% ph1 = plot(1:length(pn),pr,'o','markersize',2,'linewidth',2);
% hold on
% xlabel('parameter index')
% ylabel('Estimated parameters / nominal parameters')
% axis tight
% hold on
% % plot the diagonal:
% xl = xlim;
% % yl = ylim;
% line(xl,[1 1],'color','black')
% plot(xl',[pu'; pu'],'--');
% plot(xl',[pl'; pl'],'--')
% legend(ph1,legendstr)
% set(gca,'yscale','log')


