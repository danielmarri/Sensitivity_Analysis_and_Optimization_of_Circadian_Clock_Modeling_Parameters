
function[aic, corr_aic] = AMIGO_aic(R,D,s,npar,llktype)
% AIC and corrected AIC information criteria
fprintf('\n*************************************\n')
fprintf('**** AKAIKE Information Criteria  ***\n');
fprintf('***************************************\n')
fprintf('The Akaike information criterion (AIC) is a measure of the\n')
fprintf('relative quality of a statistical model, for a given set of data.\n')
fprintf('As such, AIC provides a means for model selection. \n')
fprintf('AIC = 2*npar + 2*Chi2\n');
fprintf('corrAIC = AIC + 2*npar*(npar+1)/(ndata - npar-1)\n\n')



switch llktype
    
    case {'homo','homo_var','hetero'}
        nR = R./s;
        chi2 = nR'*nR;
        aic = 2*npar + chi2; % the constant part is neglected.
        corr_aic = aic + 2*npar*(npar+1)/(numel(R)-npar-1);
        fprintf('\taic = %g\n', aic)
        fprintf('\tcorr_aic = %g\n', corr_aic)
    case 'hetero_proportional'
        fprintf('AIC is not implemented for hetero_proportional LK function.\n')
        aic = []; corr_aic =[];
    otherwise
        fprintf('ERROR: there is no such llktype:%s',llktype);
        aic = []; corr_aic =[];
end

end
