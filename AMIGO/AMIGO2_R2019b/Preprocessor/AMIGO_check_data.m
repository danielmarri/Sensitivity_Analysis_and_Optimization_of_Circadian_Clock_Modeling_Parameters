% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_data.m 2114 2015-09-18 12:19:54Z attila $
function [inputs]= AMIGO_check_data(inputs)
% AMIGO_check_data: Checks experimental scheme
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto,                                      %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_check_data: Checks experimental scheme supplied by user              %
%                                                                             %
%*****************************************************************************%

% check if the user gave experimental data, but forget to switch to real
% data:


if strcmp(inputs.exps.data_type,'pseudo') || strcmp(inputs.exps.data_type,'pseudo_pos')
    
    for iexp=1:inputs.exps.n_exp
        
        if numel(inputs.exps.exp_data)>= iexp && ~isempty(inputs.exps.exp_data{iexp})
            
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\t You have selected to use pseudo experimental data,\n');
            fprintf(1,'\t\t however you are providing inputs.exps.exp_data{iexp}. \n');
            fprintf(1,'\t\t The inputs.exps.data_type is being changed to real.\n');
            inputs.exps.data_type='real';
            %pause(1);
            
        end
    end
    
end



switch inputs.exps.data_type
    
    case {'pseudo','pseudo_pos'}
        
        % Check the neccessary data for AMIGO_PseudoData. 
        [inputs]= AMIGO_check_sampling(inputs);
       
        % keep the previous convention: if the user choose general heteroscedastic
        % pseudo data (hetero), but does not provide error data, then switch to
        % hetero_scedastic_proportional.
        if strcmp(inputs.exps.noise_type,'hetero') && isempty(inputs.exps.error_data{1})
            
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\t You have selected to use pseudo experimental data with general heteroscedastic noise\n');
            fprintf(1,'\t\t however you are not providing standard deviation for each datapoint  in inputs.exps.error_data{iexp}. \n');
            fprintf(1,'\t\t The inputs.exps.noise_type is being changed to hetero_proportional.\n');
            pause(1);
            
            inputs.exps.noise_type = 'hetero_proportional';
        end
        
        switch inputs.exps.noise_type
            
            case  'hetero_lin'
                
                if isempty(inputs.exps.std_deva{iexp}) || isempty(inputs.exps.std_devb{iexp})
                    fprintf(1,'\n\n------> ERROR message\n\n');
                    fprintf(1,'\t\t You have selected to use heteroscedastic noise with treshold,\n');
                    fprintf(1,'\t\t however you did not specify the noise parameters. \n');
                    fprintf(1,'\t\t Please updata inputs.exps.std_deva{iexp}) and inputs.exps.std_devb{iexp} in your input.\n');
                    error('CheckData:hetero_linParameters','Missing noise parameters, impossible to continue. Stopping.')
                end
                
                if length(inputs.exps.std_deva) < inputs.exps.n_exp || length(inputs.exps.std_devb) < inputs.exps.n_exp
                    fprintf(1,'\n\n------> ERROR message\n\n');
                    fprintf(1,'\t\t You have selected to use heteroscedastic noise with treshold,\n');
                    fprintf(1,'\t\t however you did not specify the noise parameters for all experiments. \n');
                    fprintf(1,'\t\t Please include inputs.exps.std_deva{iexp}) and inputs.exps.std_devb{iexp} for each experiment in your input.\n');
                    error('CheckData:hetero_linParameters','Missing noise parameters, Impossible to continue. Stopping.')
                end
                
            case {'hetero_proportional', 'homo', 'homo_var'}
                if isempty(inputs.exps.std_dev{1})
                    for iexp=1:inputs.exps.n_exp
                        fprintf(1,'\n\n------> WARNING message\n\n');
                        fprintf(1,'\t\t You have not provided a measure of the standard deviation of your data noise.\n');
                        fprintf(1,'\t\t Note that inputs.exps.std_dev{iexp} for experiment %d will be fixed to 10%%.\n',iexp);
                        inputs.exps.std_dev{iexp}=0.1*ones(1,inputs.exps.n_obs{iexp});
                        pause(1)
                    end;
                end
                if size(inputs.exps.std_dev{iexp},2)==1 && inputs.exps.n_obs{iexp}>1
                    std_dev{iexp}=inputs.exps.std_dev{iexp};
                    fprintf(1,'\n\n------> WARNING message\n\n');
                    fprintf(1,'\t\t Standard deviation, inputs.exps.std_dev{iexp}, should be a vector of dimension 1*n_obs{iexp}.\n');
                    fprintf(1,'\t\t The same std_dev will be used for all observables.\n');
                    inputs.exps.std_dev{iexp}=std_dev{iexp}*ones(1,inputs.exps.n_obs{iexp});
                    pause(1)
                    
                end
            case 'hetero'
                % pseudo data is generated by the standard deviation given
                % for each point separately in error_data
                if isempty(inputs.exps.error_data{1})
                    fprintf(1,'\n\n------> ERROR message\n\n');
                    fprintf(1,'\t\t Pseudo data generation for general heteroscedastic noise needs the standard deviation for each data point.\n');
                    fprintf(1,'\t\t Please update inputs.exps.error_data{iexp} for each experiment in your input.\n');
                    error('CheckData:NoiseMissing','Error_data missing for the experiments. Stopping.')
                end
                
                if length(inputs.exps.error_data) < inputs.exps.n_exp
                    fprintf(1,'\n\n------> ERROR message\n\n');
                    fprintf(1,'\t\t Pseudo data generation for general heteroscedastic noise needs the standard deviation for each data point.\n');
                    fprintf(1,'\t\t Please update inputs.exps.error_data{iexp} for each experiment in your input.\n');
                    error('CheckData:NoiseMissing','Error_data missing for the experiments. Stopping.')
                end
            case 'log_normal'
               
                if length(inputs.exps.std_devb) < inputs.exps.n_exp
                    fprintf(1,'\n\n------> ERROR message\n\n');
                    fprintf(1,'\t\t Pseudo data generation for log normal noise needs the standard deviation (ln N(0,sigma_ij)) for each data point.\n');
                    fprintf(1,'\t\t Please update inputs.exps.std_deva{iexp} for each experiment in your input.\n');
                    error('CheckData:NoiseMissing','Error_data missing for the experiments. Stopping.')
                end
                % pseudo data is generated by the standard deviation given
                % for each point separately in exps.std_deva
                for iexp=1:inputs.exps.n_exp
                    if isempty(inputs.exps.std_devb{iexp})
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t Pseudo data generation for log normal noise needs the standard deviation (ln N(0,sigma_ij)) for each data point.\n');
                        fprintf(1,'\t\t Please update inputs.exps.std_devb{iexp} for each experiment in your input.\n');
                        error('CheckData:NoiseMissing','Error_data missing for the experiments. Stopping.')
                    end
                    
%                     if size(inputs.exps.std_deva{iexp},1) ~= inputs.exps.n_obs{iexp}
%                         fprintf(1,'\n\n------> ERROR message\n\n');
%                         fprintf(1,'\t\t Pseudo data generation for log normal noise needs the standard deviation (ln N(0,sigma_ij)) for each observable.\n');
%                         fprintf(1,'\t\t Please update inputs.exps.std_deva{iexp} for each experiment in your input.\n');
%                         error('CheckData:NoiseMissing','Error_data missing for the experiments. Stopping.')
%                     end
                end
        end
        
    case 'real'
        % Check the neccessary data for AMIGO_PE.
        
        % check sampling
        [inputs]= AMIGO_check_sampling(inputs);
        
        % Experimental Data given
        if length(inputs.exps.exp_data) < inputs.exps.n_exp
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf(1,'\t\t The size of exp_data is less then n_exp.\n');
            fprintf(1,'\t\t Please include experimental data  for every experiment.\n');
            error('Data_checking:exp_data','\t\t Impossible to continue. Stopping.\n');
        end
        
        for iexp=1:inputs.exps.n_exp
            % EBC this has been modified to stop if data is not provided
            if  isempty(inputs.exps.exp_data{iexp})
                fprintf(1,'\n\n------> ERROR message\n\n');
                fprintf(1,'\t\t You have not provided the real experimental data.\n');
                error('Please udpdate your input file with inputs.exps.exp_data{iexp} or choose pseudo data  inputs.exps.data_type=''pseudo''; . Stopping.');
            end
        end
        
        if strcmp(inputs.PEsol.PEcost_type,'llk')
            % the error_data is needed only for log-likelihood estimation.
            % not for LSQ objective functions.
            
            % See if error_data is given but homoscecdastic (default) is
            % assumed and then change to heteroscedastic. 
            if (strcmp(inputs.PEsol.llk_type,'homo') || strcmp(inputs.PEsol.llk_type,'homo_var')) 
                error_data_is_given_for_each_experiment = true;
                if isempty(inputs.exps.error_data{1})
                    % if the first is empty, then we can proceed
                    error_data_is_given_for_each_experiment = false;
                    
                    % if the first is nonempty, we have to check that every
                    % experiment has the error_data, or not.
                elseif length(inputs.exps.error_data) < inputs.exps.n_exp
                    % if not
                    error_data_is_given_for_each_experiment = false;
                end
                
                if error_data_is_given_for_each_experiment
                    fprintf(1,'\n\n------> WARNING message\n\n');
                    fprintf('\t\tError_data is detected for each experiment, the estimation problem\n')
                    fprintf('\t\tis modified to heteroscedastic LLK with known variance.\n\n')
%                    pause(2);
                    inputs.PEsol.llk_type = 'hetero';
                end
            end
            
            switch inputs.PEsol.llk_type
                
                case {'homo', 'homo_var'}
                    % the standard deviation is constant
                    if isempty(inputs.exps.std_dev)
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\tFor Maximum Loglikelihood Estimation with homoscedastic noise  \n');
                        fprintf(1,'\t\t please declare the noise level (relative standard deviation) for every measurement: inputs.exps.std_dev{iexp}\n');
                        error(' Please udpdate your input file with inputs.exps.std_dev{iexp}. Stopping.');
                    end
                    if length(inputs.exps.std_dev) < inputs.exps.n_exp
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t The size of std_dev is less then n_exp.\n');
                        fprintf(1,'\t\t Please include experimental noise level  for every experiment.\n');
                        error('Data_checking:std_dev','Impossible to continue. Stopping.');
                    end
                    if size(inputs.exps.std_dev{iexp},2)==1 && inputs.exps.n_obs{iexp}>1
                        std_dev{iexp}=inputs.exps.std_dev{iexp};
                        fprintf(1,'\n\n------> WARNING message\n\n');
                        fprintf(1,'\t\t Standard deviation, inputs.exps.std_dev{iexp}, should be a vector of dimension 1*n_obs{iexp}.\n');
                        fprintf(1,'\t\t The same std_dev will be used for all observables.\n');
                        inputs.exps.std_dev{iexp}=std_dev{iexp}*ones(1,inputs.exps.n_obs{iexp});
                        pause(1)
                    end
                    
                    
                case {'hetero_proportional'}
                    if isempty(inputs.exps.std_dev{1})
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\tFor Maximum Loglikelihood Estimation with heteroscedastic, proportional noise  \n');
                        fprintf(1,'\t\t please declare the noise level (relative standard deviation) for every measurement: inputs.exps.std_dev{iexp}\n');
                        error(' Please udpdate your input file with inputs.exps.std_dev{iexp}. Stopping.');
                    end
                    
                    if length(inputs.exps.std_dev) < inputs.exps.n_exp
                        fprintf(1,'\n\n------> WARNING message\n\n');
                        fprintf(1,'\t\t You have not provided a measure of the standard deviation of your data noise.\n');
                        fprintf(1,'\t\t Please update inputs.exps.std_dev{iexp} in your input.\n');
                        error('CheckData:std_dev','Impossible to continue. Stopping.')
                    end
                    
                    if size(inputs.exps.std_dev{iexp},2)==1 && inputs.exps.n_obs{iexp}>1
                        std_dev{iexp}=inputs.exps.std_dev{iexp};
                        fprintf(1,'\n\n------> WARNING message\n\n');
                        fprintf(1,'\t\t Standard deviation, inputs.exps.std_dev{iexp}, should be a vector of dimension 1*n_obs{iexp}.\n');
                        fprintf(1,'\t\t The same std_dev will be used for all observables.\n');
                        inputs.exps.std_dev{iexp}=std_dev{iexp}*ones(1,inputs.exps.n_obs{iexp});
                        pause(1)
                    end
                    
                case 'hetero'
                    if isempty(inputs.exps.error_data{1})
                            fprintf(1,'\n\n------> ERROR message\n\n');
                            fprintf(1,'\t\t You have not provided a measure of the standard deviation of your data noise.\n');
                            fprintf(1,'\t\t Please update inputs.exps.error_data{iexp} for each experiment in your input.\n');
                            error('CheckData:NoiseMissing','Error_data missing for the experiments. Stopping.')
                    end
                    
                    if length(inputs.exps.error_data) < inputs.exps.n_exp
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t You have not provided a measure of the standard deviation of your data noise.\n');
                        fprintf(1,'\t\t Please update inputs.exps.error_data{iexp} for each experiment in your input.\n');
                        error('CheckData:NoiseMissing','Error_data missing for the experiments. Stopping.')
                    end
                case  'hetero_lin'
                    if isempty(inputs.exps.std_deva{iexp}) || isempty(inputs.exps.std_devb{iexp})
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t You have selected to use heteroscedastic noise with treshold,\n');
                        fprintf(1,'\t\t however you did not specify the noise parameters. \n');
                        fprintf(1,'\t\t Please updata inputs.exps.std_deva{iexp}) and inputs.exps.std_devb{iexp} in your input.\n');
                        error('CheckData:hetero_linParameters','Missing noise parameters, impossible to continue. Stopping.')
                    end
                    if length(inputs.exps.std_deva) < inputs.exps.n_exp || length(inputs.exps.std_devb) < inputs.exps.n_exp
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t You have selected to use heteroscedastic noise with treshold,\n');
                        fprintf(1,'\t\t however you did not specify the noise parameters for all experiments. \n');
                        fprintf(1,'\t\t Please include inputs.exps.std_deva{iexp}) and inputs.exps.std_devb{iexp} for each experiment in your input.\n');
                        error('CheckData:hetero_linParameters','Missing noise parameters, Impossible to continue. Stopping.')
                    end
                
% AG commented       case 'homo_var'
%                     for iexp=1:inputs.exps.n_exp
%                         if isempty(inputs.exps.error_data{iexp})
%                             fprintf(1,'\n\n------> WARNING message\n\n');
%                             fprintf(1,'\t\t You have not provided information about the error of the real data.\n')
%                             fprintf(1,'\t\t You can introduce a matrix with the error for every measurement: inputs.exps.error_data{iexp}\n');
%                             error(' Please udpdate your input file with inputs.exps.error_data{iexp}. Stopping.');
%                         end
%                     end
%                     
%                 case {'homo','hetero'}
%                     for iexp=1:inputs.exps.n_exp
%                         if isempty(inputs.exps.std_dev{iexp})
%                             fprintf(1,'\n\n------> WARNING message\n\n');
%                             fprintf(1,'\t\t You have not provided a measure of the standar deviation of your data noise.\n')
%                             fprintf(1,'\t\t Note that inputs.exps.std_dev{iexp} will be fixed to the 100\%.\n');
%                             inputs.exps.std_dev{iexp}=1;
%                         end
%                     end
                otherwise
                    error('--> There is no such experimental noise type: inputs.exps.noise_type = %s\n',inputs.exps.noise_type );
            end
        end
    otherwise
        error('No such data type: inputs.exps.data_type = %s\n',inputs.exps.data_type);
end

inputs.exps.exp_data = inputs.exps.exp_data(1:inputs.exps.n_exp);
inputs.exps.error_data = inputs.exps.error_data(1:inputs.exps.n_exp);


if ~isfield(inputs.PEsol,'PEcost_type') || isempty(inputs.PEsol.PEcost_type)
    inputs.PEsol.PEcost_type='lsq';
    fprintf(1,'\n\n------> WARNING message\n\n');
    fprintf('You have not specified the objective function. Assuming Least Squares Objective function.');
    pause(1);
end

% the Missing Data handling was moved from AMIGO_check_exps because the
% AMIGO_OED  does not call check_exps.
%********** HANDLE MISSING DATA ****************
% Find the nan measurement points and create a logical filter matrix, that
% indexes the not nan elements of the exp data.
% this is used later in AMIGO_PE.
for iexp=1:inputs.exps.n_exp
    if numel(inputs.exps.exp_data)<iexp || isempty(inputs.exps.exp_data{iexp})
        % no data --> pseudo data is generated, all data exists
        inputs.exps.missing_data{iexp}=false;
        inputs.exps.nanfilter{iexp} = true(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
    else
        inputs.exps.nanfilter{iexp} = ~isnan(inputs.exps.exp_data{iexp});
        inputs.exps.error_data{iexp}(isnan(inputs.exps.error_data{iexp})) = 0;
        
        if any(any(isnan(inputs.exps.exp_data{iexp})))
            inputs.exps.missing_data{iexp} = true;
        end
    end
end

return


