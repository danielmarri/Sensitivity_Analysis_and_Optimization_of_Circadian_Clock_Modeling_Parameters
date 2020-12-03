%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Pearson's Chi2 test of normality of the residuals %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,p,dof,chi2] = AMIGO_chi2gof(npars,nR,alpha,verbose)
% npars: number of fitted parameters
% nR: normalized residuals
% alpha: significance level
%% CHI2GOF:
% Chi2 test for goodness of fit.
fprintf('************************************************************\n')
fprintf('**** TEST 1: Pearson''s Chi-square goodness-of-fit test   ***\n');
fprintf('************************************************************\n')
fprintf('Adapted from the Statistics Toolbox.\n')
% fprintf('tune-able parameters:\n')
% fprintf('nbins [10]: number of bins for the residuals -- similar to histplot')
% fprintf('emin [5]: minimum number of residuals in each bin.')
% fprintf('with the defaults the maximum number of degree of freedom is 10-2-1')
% test for:
% normalized residuals are really normally distributed
% mean value is 0
% standard deviation is 1.


% chi2gof decrease the number of freedom by two (the number of parameters of normal distribution), but we already
% incorporated this information.
n_pars_chi2gof = max(npars - 2,0);

% these tunable parameters of the test fundamentally determines the degree
% of freedom and thus the result of the test. Consult the documentation of
% chi2gof before tune them.
nbins = max(10,npars+5);%min(floor(numel(R)/2),10); %
emin = 3;

fprintf('We test if the normalized residuals shows normal distribution.\n')
fprintf('Null-hypothesis: the model fits the data such that the weighted residuals (R_i/sigma_i)\n are normally distributed.\n')
%fprintf('Significance level: %g\n',alpha)



% figure()
% [n,xout] = hist(nR(:));
% normfactor = trapz(xout,n);
% bar(xout,n/normfactor,'FaceColor','yellow');
% xlabel('bins')
% ylabel('# of residuals / bins / N_data')
% title('Distribution of the normalized residuals')
% pause()
%
% Y = pdf('norm',xout,mean(nR(:)),std(nR(:)));
% hold on
% plot(xout,Y,'--','LineWidth',2,'Color','magenta')
% title('Distribution of the normalized residuals and a normal distribution')
% pause()

[h,p,stats] = chi2gof(nR(:),'cdf',{@normcdf,0,1},'nbins',nbins,'emin',emin,'nparams',n_pars_chi2gof,'alpha',alpha); %
if verbose
    figure('Name','Pearson Chi2 test of residuals')
    h1= bar( 0.5*(stats.edges(1:end-1)+stats.edges(2:end)),stats.O,'FaceColor','yellow'); hold on;
    h2 = plot( 0.5*(stats.edges(1:end-1)+stats.edges(2:end)),stats.E,'--rs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k',...
        'MarkerFaceColor','g');
    xlabel('bins')
    ylabel('residuals in the bin')
    title('Observed and expected distribution of residuals')
    legend([h1,h2],'observed statistics','expected statistics')
end
if stats.df == 0
    fprintf('\n--> WARNING: \n  Degrees of freedom <= 0.\n')
    fprintf('Maximum number of degree of freedom with the current settings:\n')
    fprintf('DOF = (# of bins) - (# of estimated parameters including standard deviations) \n')
    fprintf('\t# of bins: %d\n', length(stats.O))
    fprintf('\t# of estimated parameters: %d\n', npars)
    fprintf('--> DOF = %d\n',length(stats.O)-npars);
    fprintf('\nWhat you can do:\n')
    fprintf('- Tune the test:\n');
    fprintf('\t-decrease emin (minimum number of data in each bin) [emin = %d]\n',emin)
    fprintf('\t-increase nbins (number of bins) [nbins = %d]\n',nbins)
    fprintf('- Try to use more data to increase the degree of freedom,\n')
    fprintf('- Add the error_data to the input of the statistical test to decrease the number of fitted parameters,\n\n\n')
    %     fprintf('\t-decrease alpha (significance level) [alpha = 0.05]\n')
    
    h = [];
    p = [];
    dof = stats.df;
    chi2 = stats.chi2stat;
    return;
end


fprintf('\nTest result:\n')
if h == 0
    fprintf('\n\t--> the null-hypothesis was NOT rejected. p = %g > alpha = %g\n',p,alpha)
else % h==1
    fprintf('\n\t--> the null-hypothesis was REJECTED. p = %g < alpha = %g\n',p,alpha)
end
fprintf('\nTest details:\n')
fprintf('\tnumber of datapoints: \t%d\n',numel(nR))
fprintf('\tchi2 statistics value: \t%g\n', stats.chi2stat)
fprintf('\tdegrees of freedom: \t%d\n', stats.df)
fprintf('\tp-value: \t\t\t\t%g\n', p)
fprintf('\tsignificance level: \t%g\n\n', alpha)
% outputs:
dof = stats.df;
chi2 = stats.chi2stat;

end