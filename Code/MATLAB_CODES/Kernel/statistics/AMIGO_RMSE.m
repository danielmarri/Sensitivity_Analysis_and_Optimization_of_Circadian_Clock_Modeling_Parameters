function [rmse nrmse  ] = AMIGO_RMSE(R,D)
%[rmse nrmse] = AMIGO_RMSE(R,D) computes the Normalized Root Mean Square error
% rmse and nrmse the normalized root mean square error for each
% observables (wrmse wnrmse) or irrespectively to the observable. Each column of the R corresponding to the columns of the non-normalized residual matrix. 



if ~iscell(R)
    rmse = sqrt(mean((R).^2));
    nrmse = sqrt(mean((R).^2))./(max(D) - min(D));
    
else
    % more experiments at once:
    
    rss = 0;
    nrss = 0;
    ndata = 0;
    nexp = length(R);
    for iexp = 1:nexp
        ndata = ndata + numel(R{iexp});
        rss = rss + sum((R{iexp}(:)).^2);
        nrss = nrss + sum( sum(R{iexp}.^2)./(max(D{iexp},[],1) - min(D{iexp},[],1)).^2);
    end
    
    rmse = sqrt(rss/ndata);
    nrmse = sqrt(nrss/ndata);
end


end