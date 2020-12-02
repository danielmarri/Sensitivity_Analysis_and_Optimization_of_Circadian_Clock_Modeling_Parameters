function perr_2norm = AMIGO_parameter_inefficiency(reg_summary,theta0,theta2,W)
%AMIGO_INEFFICIENCY computes the _parametric_ inefficiency, the relative
%error between the Nt dimensional theta0 parameter vector and its estimates
%in the reg_summary.theta.
%
% AMIGO_inefficiency(reg_summary,theta0,theta2) where reg_summary is a structure with
% the following field:
%   alpha   vector of Nr regularization parameter value (1:Nr by default)
%   theta   an Nr x Nt matrix, each row containing an estimate of theta0
% theta0 is the reference parameter vector (nominal/true parameters)
% theta2 (optional) the estimation without the regularization.
% W (optional) is a transformation (weighting) matrix 



theta2_flag = 0;
if nargin > 2 && ~isempty(theta2)
   theta2_flag = 1;
end
W_flag = 0;
if nargin > 3 && ~isempty(W)
   W_flag = 1;
end

theta0 = theta0(:);

for ialpha = 1:length(reg_summary.alpha)
    theta = reg_summary.theta(ialpha,:);
    theta = theta(:);
    perr_2norm(ialpha) = norm(theta-theta0)/norm(theta0);
    perr_lognorm(ialpha) = norm(log(theta)-log(theta0));
    perr_rel(ialpha) =  norm((theta-theta0)./theta0);
    if W_flag
        perr_Wnorm(ialpha) = norm(W*(theta-theta0))/norm(W*theta0);
    end
end

if theta2_flag
    perr_2norm2 = norm(theta2-theta0)/norm(theta0);
    perr_lognorm2 = norm(log(theta2)-log(theta0));
    perr_rel2 =  norm((theta2-theta0)./theta0);
end


if theta2_flag
    perr_2norm_min = min([perr_2norm perr_2norm2]);
    perr_lognorm_min = min([perr_lognorm perr_lognorm2]);
    perr_rel_min = min([perr_rel perr_rel2]);
    
    perr_2norm_max = max([perr_2norm perr_2norm2]);
    perr_lognorm_max = max([perr_lognorm perr_lognorm2]);
    perr_rel_max = max([perr_rel perr_rel2]);
    
else
    perr_2norm_min = min(perr_2norm);
    perr_lognorm_min = min(perr_lognorm);
    perr_rel_min = min(perr_rel);
    
    perr_2norm_max = max(perr_2norm);
    perr_lognorm_max = max(perr_lognorm);
    perr_rel_max = max(perr_rel);
end


%% plot the inefficiencies for different measures ( log,
% 2norm,2norm-relative) individually

figure()
plot(reg_summary.alpha,perr_2norm,'.-','Markersize',12)
set(gca,'xscale','log')
axis tight
xlabel('regularization parameter (\alpha)')
title('2-norm parameter estimation error')
ylabel('||\theta_\alpha - \theta_{nom}||/||\theta_{nom}||')

figure()
plot(reg_summary.alpha,perr_lognorm,'.-','Markersize',12)
set(gca,'xscale','log')
axis tight
title('Logarithmic parameter estimation error')
xlabel('regularization parameter (\alpha)')
ylabel('||log(\theta_\alpha / \theta_{nom})||')


figure()
plot(reg_summary.alpha,perr_rel,'.-','Markersize',12)
set(gca,'xscale','log')
axis tight
title('Relative parameter estimation error')
xlabel('regularization parameter (\alpha)')
ylabel('||(\theta_{i,\alpha} - \theta_{i,nom})/\theta_{i,nom}||')

%%

% scale to [0 1] to show together on a figure:
sc_perr_2norm = (perr_2norm-perr_2norm_min)/(perr_2norm_max - perr_2norm_min);
sc_perr_lognorm = (perr_lognorm-perr_lognorm_min)/(perr_lognorm_max - perr_lognorm_min);
sc_perr_rel = (perr_rel-perr_rel_min)/(perr_rel_max - perr_rel_min);

if theta2_flag
    sc_perr_2norm2 = (perr_2norm2  -perr_2norm_min) /(perr_2norm_max - perr_2norm_min);
    sc_perr_lognorm2 = (perr_lognorm2-perr_lognorm_min)/(perr_lognorm_max - perr_lognorm_min);
    sc_perr_rel2 = (perr_rel2-perr_rel_min)/(perr_rel_max - perr_rel_min);
end
legendstr = {'2-norm','logscaled 2norm','relative 2 norm'};

figure();
plot(reg_summary.alpha,sc_perr_2norm,'.-',reg_summary.alpha,sc_perr_lognorm,'.-',reg_summary.alpha,sc_perr_rel,'.-','Markersize',12)
%plot(reg_summary.alpha,perr_2norm,'.-',reg_summary.alpha,perr_lognorm,'.-',reg_summary.alpha,perr_rel,'.-','Markersize',12)
if W_flag
    hold all
      plot(reg_summary.alpha,perr_Wnorm,'.-');
      legendstr = {'2-norm','logscaled 2norm','relative 2 norm','W-2norm'};
end
if theta2_flag
    hold all
    plot(median(reg_summary.alpha),sc_perr_2norm2,'s',median(reg_summary.alpha),sc_perr_lognorm2,'v',median(reg_summary.alpha),sc_perr_rel2,'*','Markersize',12)
    legendstr = {'2-norm','logscaled 2norm','relative 2 norm','ref 2-norm','ref logscaled 2norm','ref relative 2 norm'};
end
set(gca,'xscale','log')
axis tight
legend(legendstr)
xlabel('regularization parameter (\alpha)')
title({'Scaled estimation error for the candidates.' 'using different measures'})

%% plot histograms:
for ialpha = 1:length(reg_summary.alpha)
figure()
dx = log10(reg_summary.theta(ialpha,:)'./theta0);
hist((dx))
title({'PE error ditribution' sprintf('\\alpha = %g',reg_summary.alpha(ialpha))  })
xlabel('log_{10}(\theta_i/\theta_{i,nom})')
ylabel('# of occurances')
end

