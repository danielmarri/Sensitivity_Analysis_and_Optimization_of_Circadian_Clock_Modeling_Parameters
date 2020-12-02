function AMIGO_plot_estim_params(est_theta,inputs,results)
% plot some figures about the estimated parameters.


nom_theta = inputs.model.par(inputs.PEsol.index_global_theta);
theta_names = inputs.model.par_names(inputs.PEsol.index_global_theta,:);

if ~isempty(inputs.PEsol.index_global_theta_y0)
    nom_theta = [nom_theta inputs.exps.exp_y0{1}(inputs.PEsol.index_global_theta_y0)];
    theta_names = char(theta_names , inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:));
end



for iexp = 1:inputs.exps.n_exp
    if ~isempty(inputs.PEsol.index_local_theta{iexp})
        nom_theta = [nom_theta inputs.model.par(inputs.PEsol.index_local_theta{iexp})];
        theta_names = char(theta_names , inputs.model.par_names(inputs.PEsol.index_local_theta{iexp},:));
    end
end
%est_theta = results.fit.thetabest;


%% plot estimated vs true parameters
dmin = min([nom_theta, est_theta]);
dmax = max([nom_theta, est_theta]);

figure()
plot(nom_theta,est_theta,'.'), hold on
plot([dmin dmax], [dmin dmax],'--','color',[.8 .8 .8],'Linewidth',2)
xlabel('nominal parameters')
ylabel('estimated parameters')
title({'Estimated vs. nominal parameters' inputs.pathd.short_name},'interpreter','none')

if dmax > 100*dmin  && all(est_theta>0)
    set(gca,'xscale','log','yscale','log')
end

if inputs.plotd.figsave
    saveas(gcf, inputs.pathd.pest_vs_pnom_path, 'fig');
end
% Saves a .eps color figure
if inputs.plotd.epssave==1;
    print( gcf, '-depsc', inputs.pathd.pest_vs_pnom_path); 
end


%% Historgrams for the estimation error in the parameters.
err_theta = nom_theta - est_theta;

figure
[n,xout] = hist(log10(abs(err_theta)));
bar(xout,n)
xlabel('distance of estimated parameters and inputs.model.par (log10)')
ylabel('frequency')
title({'Distribution of the distance in the estim. parameters.', inputs.pathd.short_name},'interpreter','none')
if inputs.plotd.figsave
    saveas(gcf, inputs.pathd.pest_err_hist_path, 'fig');
end
% Saves a .eps color figure
if inputs.plotd.epssave==1;
    print( gcf, '-depsc', inputs.pathd.pest_err_hist_path); 
end


%% Histogram for the relative error in the estimated parameters.
figure
[n,xout] = hist(log10(abs(err_theta)./abs(nom_theta)));
bar(xout,n)
xlabel('rel. distance of estimated parameters and inputs.model.par (log10)')
ylabel('frequency')
title({'Distribution of the rel. distance in the estim. parameters.', inputs.pathd.short_name},'interpreter','none')
if inputs.plotd.figsave
    saveas(gcf, inputs.pathd.pest_err_hist_path, 'fig');
end
% Saves a .eps color figure
if inputs.plotd.epssave==1;
    print( gcf, '-depsc', inputs.pathd.pest_rel_err_hist_path); 
end




%% Logratio between the estimated and the true parameters

figure
plot(1:numel(nom_theta),log10(abs(est_theta./nom_theta)),'.','Markersize',15), hold on
% plot([dmin dmax], [dmin dmax],'--','color',[.8 .8 .8],'Linewidth',2)
set(gca,'xtick',1: numel(nom_theta),'xticklabel',theta_names)
xlim([0.5 numel(nom_theta)+0.5])
xticklabel_rotate([],90,[],'interpreter','none');
% xlabel('nominal parameters')
ylabel('logratio (log(\theta_{est}/\theta_{nom}))')
title({'Error in estimated parameters', inputs.pathd.short_name},'interpreter','none')

if inputs.plotd.figsave
    saveas(gcf, inputs.pathd.pest_pnom_logratio_path, 'fig');
end
% Saves a .eps color figure
if inputs.plotd.epssave==1;
    print( gcf, '-depsc', inputs.pathd.pest_pnom_logratio_path); 
end


