function RSS =  AMIGO_RSS( sim_data,exp_data,iexps)
%RSS =  AMIGO_computeRSS( sim_data,exp_data,...) Computes the residuals sum of squares.
% 
% RSS =  AMIGO_computeRSS( sim_data,exp_data,iexp)
%   sim_data: matrix or cell array of matrices containing the simulated
%             data. sim_data{iexp} contains the data for the iexp experiment. 
%   exp_data: matrix or cell array of matrices containing the simulated
%             data. exp_data{iexp} contains the data for the iexp experiment. 
%   iexps: the experiment for which the RSS is computed. If array, then the
%       indices of the experiments. 

if nargin < 3 
  if iscell(sim_data)
      iexps = 1:numel(sim_data);
  else
      iexps = 1;
  end
end

RSS = 0;
for iexp = iexps
    RSS  = RSS  + sum(sum(( exp_data{iexp} - sim_data{iexp}).^2));
end
end
