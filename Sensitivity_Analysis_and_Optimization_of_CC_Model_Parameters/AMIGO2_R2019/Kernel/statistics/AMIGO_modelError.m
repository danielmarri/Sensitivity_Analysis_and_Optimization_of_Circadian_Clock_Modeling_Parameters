function s2 = AMIGO_modelError (inputs, results)
%AMIGO_modelError computes the variance of the noise for the different cases of the cost function.
% s^2 is the estimate of the measurement noise variance based on the weighted sum of
% squares error and the degree of freedom. 


npar = length(results.fit.thetabest);
ndata = 0;
SoS = zeros(1,inputs.exps.n_exp);
f = 0;

for iexp = 1:inputs.exps.n_exp
    resM = results.fit.residuals{iexp};
    ndata = ndata + numel(resM);
    
    
    switch inputs.PEsol.PEcost_type
        
        
        case 'lsq'
            
            switch inputs.PEsol.lsq_type
                
                case 'Q_mat'
                    Q = inputs.PEsol.lsq_Qmat{iexp};
                case 'Q_I'
                    Q = ones(size(resM));
                    
                case 'Q_exp'
                    % weighting matrix is the measurements.
                    % if the data is almost zero, replace by one.
                    D =  inputs.exps.exp_data{iexp};
                    D(abs(D) < 10*inputs.ivpsol.atol) =10*inputs.ivpsol.atol;
                    
                    Q = 1./D;
                    
                    
                case 'Q_expmax'
                    expDataMax = max(inputs.exps.exp_data{iexp});
                    expDataMax(abs(expDataMax)<10*inputs.ivpsol.atol) = 10*inputs.ivpsol.atol;
                    % every timepoint of each observable have the same
                    % weighting factor:
                    Q = repmat(1./expDataMax, inputs.exps.n_s{iexp},1);
                    
                case 'Q_expmean'
                    % weighting matrix is the mean of the trajectories
                    expDataMean = mean(inputs.exps.exp_data{iexp});
                    expDataMean(abs(expDataMean)<10*inputs.ivpsol.atol) = 10*inputs.ivpsol.atol;
                    
                    Q = repmat(1./expDataMean, inputs.exps.n_s{iexp},1);
            end
            
            r = Q.*resM;
            SoS(iexp) = r(:)'*r(:);
      
        case 'llk'
            
            switch inputs.PEsol.llk_type
                case {'homo','homo_var'}
                    % simple weighted LS case.
                    % Known error variance: (std_dev * max(exp_data))^2
                    
                    error_data =  repmat(max(inputs.exps.exp_data{iexp}).*inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                    
                    error_data(error_data <= inputs.ivpsol.atol) = inputs.ivpsol.atol;    %To avoid /0
                    
                    R = resM./error_data;
                    
                    f = f+ R(:)'*R(:);
                    
                    s2 = f/(ndata);
                    
                    
                case 'hetero'
                    % known variance for each points given by the
                    % error_data.^2
                    % compute s2 from the weighted SOS. 
                    
                    
                    error_data = abs(inputs.exps.error_data{iexp});
                    error_data(abs(error_data) <= inputs.ivpsol.atol) = inputs.ivpsol.atol;    %To avoid /0
                    
                    error_matrix = resM./error_data;
                    %                     error_matrix = error_matrix(inputs.exps.nanfilter{iexp});
                    
                    f = f+ error_matrix(:)'*error_matrix(:);
                    
                    s2 = f/(ndata);
                    
                case 'hetero_proportional'
                    %Standard deviation is assumed to be
                    %proportional to ms, noise = std_dev*y
                    % var(eps_i) = (std_dev*y_i)^2
                    
                    % Walter And Pronzano: page 62.
                    % case: a = std_dev and b = 1;
                    % NOT EXACTLY: in the book the a and b are estimated!!!
                    % Here we mix up: we assume a is estimated  and b is
                    % known and equals 2.
                    b = 2;
                    
                    ms = results.fit.ms{iexp};
                    ms(ms<=inputs.ivpsol.atol)=inputs.ivpsol.atol;   % To avoid log(0) and /0
                    
                    g = g + sum(resM(:).^2./(abs(ms(:))).^b);
                    
                    a = g/ndata;
                    % I think s^2 is a diagonal matrix in this case for each experiment, but how to use
                    % it later???
                    s2{iexp} = a^2*diag(abs(ms(:)).^2);
                case 'hetero_lin'
                    
                    % good luck! :)
                    
                    s2 = -1;
                    
                otherwise
                    
                    fprintf('Either LS or LLK estimation should be used to estimate the model error.')
            end
            
    end
end


if strcmpi(inputs.PEsol.PEcost_type,'lsq')
    % variance of the noise:
    s2 = sum(SoS)/(ndata - npar);
end