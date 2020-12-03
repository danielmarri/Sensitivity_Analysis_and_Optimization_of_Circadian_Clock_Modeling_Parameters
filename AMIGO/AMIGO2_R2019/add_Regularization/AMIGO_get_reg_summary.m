function [reg_results sorted_results] = AMIGO_get_reg_summary(results)
% [reg_results sorted_results] = AMIGO_get_reg_summary(AMIGO_PE results)
%
%   collects the optimal parameters from the results and sort them
%   according to alpha. Note that results is also sorted!!
%
%
%
% SYNTAX:
%   AMIGO_get_reg_summary(results)  where results is the output structure
%   from AMIGO_PE() using regularization.
% INPUTS:
%   results     AMIGO_PE output structure with the following fields:
%       .regularization.alpha      
%       .regularization.cost      
%       .regularization.reg      
%       .fit.thetabest
%
% OUTPUTS:
%   reg_results.theta   array of previously obtained optimal parameters
%   reg_results.Q_cost  vector of least squares cost function values
%   reg_results.Q_penalty  vector of the penalty terms without reg. parameter
%   reg_results.alpha   regularization parameter
%   reg_results.Q_tot   total cost: fit and regularization
%
% EXAMPLES:
%
%

% number of results:
n_results = length(results);
reg_results.n_results = n_results;

% sort the results by the regularization parameter
a = zeros(1,n_results);
for i = 1:n_results
    a(i) = results(i).regularization.alpha;
end
[sa si] = sort(a,'ascend');
results = results(si);
sorted_results = results;

%	Collect optimal parameters from the results:
for i = 1:n_results
    thetabest_array(i,:) = results(i).fit.thetabest;
end
reg_results.theta = thetabest_array;


% compute the final :cost, penalty, total and reg. param.
for i = 1 : n_results
    reg_results.Q_LS(i) = results(i).regularization.cost;
    reg_results.Q_penalty(i) = results(i).regularization.reg;
    reg_results.alpha(i) = results(i).regularization.alpha;
    reg_results.Q_tot(i) = results(i).regularization.cost + results(i).regularization.alpha * results(i).regularization.reg;
end


% % obtain convergence curve:
% % no convecurve for multistart local methods...
% for i = 1 : n_results
%     reg_results.conv(i).Q_tot = results(i).nlpsol.f;
%     reg_results.conv(i).time = results(i).nlpsol.time;
%     reg_results.conv(i).neval = results(i).nlpsol.neval;
% end
% 

