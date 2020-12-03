
function [H1,pValue1, H2, pValue2] = AMIGO_swtest(nR, alpha)
% Shapiro-Wilk parametric hypothesis test of composite normality as
% implemented in SBToolbox2  http://www.sbtoolbox2.org/ by Henning Schmidt.
fprintf('\n*******************************************************\n')
fprintf('**** TEST 4:Shapiro-Wilk parametric hypothesis test  ***\n');
fprintf('********************************************************\n')
fprintf('The normalized residuals are test against composite normality. \n')
fprintf('Adapted from SBToolbox2 http://www.sbtoolbox2.org/\n')
fprintf('If the probability is less than %g, we reject the model.\n\n',alpha)


tail = 1; % 1-sided test, does not test overfitting.
% tail = 0; 2-sided test

% 1 test over all the observables:
[H1, pValue1] = swtestSB(nR(:), alpha, tail);

fprintf('Test result (1-sided, underfitting):\n')
if H1 == 0
    fprintf('\n\t--> the null-hypothesis was NOT rejected. p = %g > alpha = %g\n',pValue1,alpha)
else % H==1
    fprintf('\n\t--> the null-hypothesis was REJECTED. p = %g < alpha = %g\n',pValue1,alpha)
end
fprintf('\nTest details:\n')
fprintf('\tnumber of datapoints: \t%d\n',numel(nR))
fprintf('\tp-value: \t\t\t\t%g\n', pValue1)
fprintf('\tsignificance level: \t%g\n\n', alpha)


tail = 0;
[H2, pValue2] = swtestSB(nR(:), alpha, tail);
fprintf('Test result (2-sided, under- and overfitting):\n')
if H2 == 0
    fprintf('\n\t--> the null-hypothesis was NOT rejected. p = %g > alpha = %g\n',pValue2,alpha)
else % H==1
    fprintf('\n\t--> the null-hypothesis was REJECTED. p = %g < alpha = %g\n',pValue2,alpha)
end
fprintf('\nTest details:\n')
fprintf('\tnumber of datapoints: \t%d\n',numel(nR))
fprintf('\tp-value: \t\t\t\t%g\n', pValue2)
fprintf('\tsignificance level: \t%g\n\n', alpha)
end
