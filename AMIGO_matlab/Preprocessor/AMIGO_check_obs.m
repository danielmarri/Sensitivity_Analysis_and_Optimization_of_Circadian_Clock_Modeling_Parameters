% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_obs.m 2228 2015-09-29 09:55:22Z attila $

function [inputs] = AMIGO_check_obs(inputs)
% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_obs.m 2228 2015-09-29 09:55:22Z attila $
% AMIGO_check_obs: Checks observables related user supplied information
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_check_obs: Checks observables related user supplied information       %
%                                                                             %
%*****************************************************************************%

for iexp=1:inputs.exps.n_exp
    
    if(isempty(inputs.exps.obs{iexp}))
        inputs.exps.obs{iexp}='none';
    end
    
    if strcmp(inputs.exps.obs{iexp},'states')
        inputs.exps.n_obs{iexp}=inputs.model.n_st;
    end
    
    if(isfield(inputs.exps,'n_obs') && ~isempty(inputs.exps.n_obs) && ~isempty(inputs.exps.n_obs{iexp}) && inputs.exps.n_obs{iexp}>0)
        
    else
        %inputs.exps.n_obs{iexp}=0;
        %inputs.exps.Q{iexp}=[];
        %inputs.exps.exp_data{iexp}=[];
        %inputs.exps.error_data{iexp}=[];  
    end
end


for iexp=1:inputs.exps.n_exp
  
    switch  inputs.exps.obs{iexp}
        
        case 'states'
            
            inputs.exps.n_obs{iexp}=inputs.model.n_st;
            
            for ist=1:inputs.model.n_st
                o_list(ist,:)='obs';
                equals_list(ist,:)='=';
            end
            
            obs_names=strcat(o_list,inputs.model.st_names);
            inputs.exps.obs_names{iexp}=obs_names;
            obs=strcat(obs_names,equals_list,inputs.model.st_names);
            inputs.exps.obs{iexp}=obs;
            
            inputs.exps.index_observables{iexp}=1:inputs.model.n_st;
            privstruct.index_observables=inputs.exps.index_observables;
            inputs.exps.n_obs{iexp}=inputs.model.n_st;
            privstruct.n_obs=inputs.model.n_st;
            if iexp == inputs.exps.n_exp
                % remove the extra empty fields.
                inputs.exps.obs_names = inputs.exps.obs_names(1:iexp);
            end
            
        case 'none'
            
            inputs.exps.n_obs{iexp}=0;
            inputs.exps.index_observables{iexp}=[];
            
        otherwise
            
            if(strcmp(inputs.model.exe_type,'costMex') || strcmp(inputs.model.exe_type,'fullMex'))
                
                try 
                    inputs.exps.obs{iexp};
                    
                    
                catch e1
                    
                    try 
                        
                        inputs.exps.index_observables{iexp};
                        
                    catch e2
                        
                        disp(e1);
                        disp(e1);
                        error('AMIGO_check_obs{iexp}: Observation functions or index_observables must be correctly defined for each experiment');
                        
                    end
                    
                end
                    
                
                
            end
            
            if isempty(inputs.exps.obs{iexp})==1
                fprintf(1,'\n\n------> ERROR message\n\n');
                fprintf(1,'\t\t The observables have not been introduced.\n');
                fprintf(1,'\t\t If you may observe all states add inputs.exps.obs{iexp}=states in your input file,\n');
                fprintf(1,'\t\t if not, them you need to specify inputs.exps.obs{iexp}\n');
                error('error_exps_008a','\t\t Observables have not been correctly defined. Stopping.')
            end
            
            if isempty(inputs.exps.n_obs{iexp})==1
                fprintf(1,'\n\n------> ERROR message\n\n');
                fprintf(1,'\t\t The number of observables has not been introduced.\n');
                fprintf(1,'\t\t If you may observe all states add inputs.exps.obs{iexp}=states in your input file,\n');
                fprintf(1,'\t\t if not, them you need to specify inputs.exps.n_obs{iexp}\n');
                error('error_exps_008b','\t\t Observables have not been correctly defined. Stopping.')
            end
            
    end%switch  inputs.exps.obs{iexp}
end %for iexp=1:inputs.exps.n_exp


for iexp=1:inputs.exps.n_exp
    if ~isfield(inputs.exps,'w_obs') || isempty(inputs.exps.w_obs) ||  length(inputs.exps.w_obs)<iexp ||  isempty(inputs.exps.w_obs{iexp})
        inputs.exps.w_obs{iexp}=ones(1,inputs.exps.n_obs{iexp});
    end
end

return


