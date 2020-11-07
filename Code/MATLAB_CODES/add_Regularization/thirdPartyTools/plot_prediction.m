
function plot_prediction(A,QG)
% A = results.regularization.alphaSet;
% G = results.regularization.Q_penalty;
% Q = results.regularization.Q_cost;
% QG = [Q',G']



lg_Ai = interp1(log10(A),1:1/100:length(A));
Ai = 10.^lg_Ai;


[n_lcurve curvature sA]= RM_lcurve_ndiff(A,QG(:,1)',QG(:,2)');



%QGi = interp1(A,QG,Ai(2:end-1),'spline');
% [n_lcurve1 curvature1 sA1]= RM_lcurve_ndiff([Ai],[QGi(:,1)'],[QGi(:,2)']);
% plot(QGi(:,1),QGi(:,2),'.');
lg_QGi1 = spline(log10(A),[-[ 1 1]' log10(QG') [0 0]' ],log10(Ai));
QGi1 = 10.^lg_QGi1;
[n_lcurve1 curvature1 sA1]= RM_lcurve_ndiff([Ai],[QGi1(1,:)],[QGi1(2,:)]);



%QGi = interp1(A,QG,Ai,'cubic');
%[n_lcurve2 curvature2 sA2]= RM_lcurve_ndiff([Ai],[ QGi(:,1)'],[ QGi(:,2)']);
% plot(QGi2(:,1),QGi2(:,2),'.');
lg_QGi2 = spline(log10(A),log10(QG'),log10(Ai));
QGi2 = 10.^lg_QGi2;
[n_lcurve2 curvature2 sA2]= RM_lcurve_ndiff([Ai],[QGi2(1,:)],[QGi2(2,:)]);

figure()
subplot(221)
hold all
plot(QG(:,1),QG(:,2),'x','linewidth',2,'Markersize',10)
plot(QGi1(1,:),QGi1(2,:),'.');
plot(QGi2(1,:),QGi2(2,:),'.');
subplot(223)
hold all
plot(log10(QG(:,1)),log10(QG(:,2)),'x','linewidth',2,'Markersize',10)
plot(log10(QGi1(1,:)),log10(QGi1(2,:)),'.');
plot(log10(QGi2(1,:)),log10(QGi2(2,:)),'.');


subplot(222)
plot(sA,curvature,'.--')
hold all

plot(sA1, curvature1,'.--')
plot(sA2, curvature2,'.--')
set(gca,'xscale','log')
