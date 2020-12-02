
function R2 = AMIGO_R2test(residuals,data)
%R2 = AMIGO_R2test(residuals,data)
% Computes the R-square value of a model
% R: matrix or cell vector of residuals: difference between prediction and
% data
% D: matrix or cell vector of calibration data
%
% TIP: put the different experiments into cells R{iexp}, D{iexp}
% PURPOSE: test the model against the simple sample mean.
fprintf('********************************************\n')
fprintf('**** TEST 2:  R-squared goodness of fit  ***\n');
fprintf('********************************************\n')
fprintf('Compares the user''s model to the simple mean of the data\n');
fprintf('\tR2 ~  1 =>  the model is much better than using the simple mean of the data;\n')
fprintf('\tR2 << 1 =>  the simple mean explains the observations better than the model.\n\n')

R = residuals;
D = data;

if isempty(D)
    warning('The computation of R^2 requires the data.')
    R2 = 0;
    return;
end
if ~iscell(R)
    % data comming experimentwise
    n_time = size(D,1);
    % the sum of squares of residuals, also called the residual sum of squares
    ss_res = sum(R(:).^2);     %  non-normalized
    
    %  the total sum of squares (proportional to the sample variance):
    ss_tot = sum(sum((D-repmat(mean(D),n_time,1)).^2)); % sum of total error in the data
    
    % the regression sum of squares, also called the explained sum of squares:
    ss_reg = sum(sum(R-repmat(mean(D),n_time,1).^2));
    
    R2 = 1-ss_res/ss_tot;
    
else
    % more experiments at once:
    ss_tot  = 0;
    ss_res  = 0;
    nexp = length(R);
    for iexp = 1:nexp
        ss_res = ss_res+ sum(sum((R{iexp}.^2)));
        n_time = size(D{iexp},1);
        ss_tot = ss_tot + sum(sum((D{iexp} - repmat(mean(D{iexp}),n_time,1)).^2));
    end
    
    R2 = 1-ss_res/ss_tot;    
end

fprintf('Test result:\n')
fprintf('\t-->  R-squared value (1-squared_model_residuals/squared_mean_residuals):\t%g\n',R2);

end