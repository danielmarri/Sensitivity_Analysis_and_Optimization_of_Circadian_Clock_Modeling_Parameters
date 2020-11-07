function plot_reg_solutions(x,x_err,b,bn,Q_LS,delta,nopt,name)


figure()
subplot(211)
 plot(delta,x_err/norm(x),'.-'), hold on
 plot(delta(nopt),x_err(nopt)/norm(x),'r*')
 set(gca,'yscale','log','xscale','log')
 xlabel('reg. parameter')
 ylabel('error in the estimate')
 title(name)
  axis tight
 

 subplot(212)
 plot(delta,Q_LS,'.-'), hold on
 plot(delta(nopt),Q_LS(nopt),'r*')
 plot(delta,repmat(sum((b-bn).^2),size(delta)),'k--','linewidth',2)
 set(gca,'yscale','log','xscale','log')
 xlabel('reg. parameter')
 ylabel('Least squares error')
 legend('reg. solutions','chosen','true noise level','Location','northwest')
 axis tight
 
 