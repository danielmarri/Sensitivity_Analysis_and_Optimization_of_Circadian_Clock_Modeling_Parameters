function[bic] = AMIGO_bic(R,D,s,npar,llktype)
% Bayesian information criteria
fprintf('\n*************************************\n')
fprintf('**** Bayesian Information Criteria  ***\n');
fprintf('***************************************\n')
fprintf('In statistics, the Bayesian information criterion (BIC) or Schwarz\n')
fprintf('criterion (also SBC, SBIC) is a criterion for model selection among a finite set of models\n');
fprintf('BIC = Chi^2 + npar*log(ndata)\n\n')


switch llktype
    
    case {'homo','homo_var','hetero'}
        nR = R./s;
        chi2 = nR'*nR;
        bic = npar *log(numel(D))+ chi2; % the constant part is neglected.
        fprintf('\tBIC = %g\n', bic)
    case 'hetero_proportional'
        fprintf('BIC is not implemented for hetero_proportional LK function.\n')
        bic = []; 
    otherwise
        fprintf('ERROR: there is no such llktype:%s',llktype);
        bic = [];
end

end