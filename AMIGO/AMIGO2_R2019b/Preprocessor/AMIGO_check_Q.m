% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_Q.m 1627 2014-06-26 13:13:09Z davidh $
function inputs= AMIGO_check_Q(inputs)


if(strcmp(inputs.model.exe_type,'costMex') || strcmp(inputs.model.exe_type,'fullMex') || strcmp(inputs.model.exe_type,'fullC'))
    
    if isempty(inputs.exps.exp_data{1})
        for iexp=1:inputs.exps.n_exp
            inputs.exps.exp_data{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
        end
    end
else
    return;
    
end


if isempty(inputs.exps.error_data{1})
    for iexp=1:inputs.exps.n_exp
        % inputs.exps.error_data{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
    end
end

switch inputs.PEsol.PEcost_type
    
    case 'lsq'
        
        switch inputs.PEsol.lsq_type
            
            case 'Q_mat'
                
                if ~isfield(inputs.PEsol,'Q') || isempty(inputs.PEsol.Q)
                    
                    warning('You selected lsq_type Q_mat but you did not specify a user defined Q matrix.');
                    warning('Identity matrix will be assumed.');
                    
                    inputs.PEsol.Q='Q_I';
                    
                    inputs.exps.Q={};
                    
                    for iexp=1:inputs.exps.n_exp
                        inputs.exps.Q{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
                    end
                    
                end
                
                
            case 'Q_I'
                
                inputs.exps.Q={};
                for iexp=1:inputs.exps.n_exp
                    inputs.exps.Q{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
                end
                
            case 'Q_exp'
                
                inputs.exps.Q={};
                
                for iexp=1:inputs.exps.n_exp
                    
                    inputs.exps.Q{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
                    
                    for jobs=1:inputs.exps.n_obs{iexp}
                        inputs.exps.Q{iexp}(:,jobs)=1./(inputs.exps.exp_data{iexp}(:,jobs));
                    end
                    tmp1 = or(isinf(inputs.exps.Q{iexp}),inputs.exps.Q{iexp} > 1/inputs.ivpsol.atol);
                    % if the inverse is inf or too huge (data near zero),
                    % than replace by 1
                    inputs.exps.Q{iexp}(tmp1) = 1;
                end
                
            case 'Q_expmax'
                
                inputs.exps.Q={};
                
                for iexp=1:inputs.exps.n_exp
                    
                    inputs.exps.Q{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
                    
                    for jobs=1:inputs.exps.n_obs{iexp}
                        inputs.exps.Q{iexp}(:,jobs)=1./max(inputs.exps.exp_data{iexp}(:,jobs));
                    end
                    
                end
                
            case 'Q_expmean'
                
                inputs.exps.Q={};
                
                for iexp=1:inputs.exps.n_exp
                    
                    inputs.exps.Q{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
                    
                    for jobs=1:inputs.exps.n_obs{iexp}
                        inputs.exps.Q{iexp}(:,jobs)=1./mean(inputs.exps.exp_data{iexp}(:,jobs));
                    end
                    
                end
                
                
            case 'homo'
                
                inputs.exps.Q={};
                for iexp=1:inputs.exps.n_exp
                    
                    if isempty(inputs.exps.error_data{iexp})
                        max(inputs.exps.exp_data{iexp})
                        inputs.exps.error_data{iexp}=repmat(max(inputs.exps.exp_data{iexp}).*...
                            inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                    end
                    
                    for jobs=1:inputs.exps.n_obs{iexp}
                        inputs.exps.Q{iexp}(:,jobs)=1./inputs.exps.error_data{iexp}(:,jobs);
                    end
                    
                end
                
            otherwise
                
                error('Cannot recognize type of objective function lsq_type');
                
        end
        
    case 'llk'
        
        switch inputs.PEsol.llk_type
            
            case {'homo','homo_var'}
                
                inputs.exps.Q={};
                for iexp=1:inputs.exps.n_exp
                    
                    if isempty(inputs.exps.error_data{iexp})
                        max(inputs.exps.exp_data{iexp})
                        inputs.exps.error_data{iexp}=repmat(max(inputs.exps.exp_data{iexp}).*...
                            inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                    end
                    
                    error_data = abs(inputs.exps.error_data{iexp});
                    error_data(abs(error_data) <= inputs.ivpsol.atol) = inputs.ivpsol.atol;    %To avoid /0
                    inputs.exps.Q{iexp}=1./error_data;
                    
                end
                
            case 'hetero'
                
                inputs.exps.Q={};
                
                for iexp=1:inputs.exps.n_exp
                    
                    error_data = abs(inputs.exps.error_data{iexp});
                    error_data(abs(error_data) <= inputs.ivpsol.atol) = inputs.ivpsol.atol;    %To avoid /0
                    inputs.exps.Q{iexp}=1./error_data;
                    
                    
                end
                
            case {'hetero_lin','hetero_proportional'}
                
                inputs.exps.Q={};
                
                for iexp=1:inputs.exps.n_exp
                    inputs.exps.Q{iexp}=ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
                end
                
            otherwise
                
                error('Cannot recognize type of objective function inputs.PEsol.llk_type. Please, correct the input.');
                
        end %switch inputs.llk_type
        
        
end %switch inputs.PEsol.PEcost_type

for iexp=1:inputs.exps.n_exp
    
    inputs.exps.Q{iexp}=abs(inputs.exps.Q{iexp});
    inputs.exps.Q{iexp}(isinf(inputs.exps.Q{iexp}))=nan;
    inputs.exps.Q{iexp}(inputs.exps.Q{iexp}==0)=nan;
    
end

end