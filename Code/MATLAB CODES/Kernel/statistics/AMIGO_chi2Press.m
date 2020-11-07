
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Chi2 goodness of fit test - Press et al %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,p,DOF,chi2] = AMIGO_chi2Press(npars,nR,alpha)
% Chi2 goodness of fit test (Press et al 2007)
% test the sum of the residuals
% the sum of the residuals have Chi2 distribution if the residuals have
% standard normal distribution.
%
% npars: number of fitted parameters
% nR: normalized residuals
% alpha: significance level
fprintf('\n********************************************\n')
fprintf('**** TEST 3: Chi-square goodness of fit  ***\n');
fprintf('********************************************\n')
fprintf('We test the sum of squared residuals as presented in Press et. al. 2007. \n');
fprintf('The assumption  is that, the residuals are normally distributed, thus the\n')
fprintf(' sum of the squared residuals normalized  by the standard deviation (Chi2_obs)\n')
fprintf(' must follow the Chi-2 distribution. The resulted p-value tells you the\n')
fprintf('probability that a random variable from a Chi2 distribution  \n')
fprintf('with the given degree-of-freedom exceeds the Chi2_obs value.\n')
fprintf('Where the DOF = (number of data) - (number of estimated parameters)\n')
fprintf('If the probability is less than %g, we reject the hypothesis.\n\n',alpha)
DOF = numel(nR) - npars;
chi2 = sum(nR(:).^2); % sum-of-squares normalized residuals
if (DOF > 0)
    p = 1 - gammainc(chi2/2,DOF/2);   % 1-chi2cdf(chi2,dof) in Statistics toolbox
    h = p < alpha;
    fprintf('Test result:\n')
    if h == 0
        fprintf('\n\t--> the null-hypothesis was NOT rejected. p = %g > alpha = %g\n',p,alpha)
    else % h==1
        fprintf('\n\t--> the null-hypothesis was REJECTED. p = %g < alpha = %g\n',p,alpha)
    end
    fprintf('\nTest details:\n')
    fprintf('\tnumber of datapoints: \t%d\n',numel(nR))
    fprintf('\tchi2 (Res_norm''*Res_norm) value: \t%g\n', chi2)
    fprintf('\tdegrees of freedom: \t%d\n', DOF)
    fprintf('\tp-value: \t\t\t\t%g\n', p)
    fprintf('\tsignificance level: \t%g\n\n', alpha)
else
    fprintf('WARNING. DOF = %d, the test is skipped.\n',DOF);
    h = [];
    p = [];
end
end

