% $
function [inputs,results]= AMIGO_check_OED_data(inputs,results)
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
%                    Asings experimental error model for OED                  %
%                                                                             %
%*****************************************************************************%


       % For fixed experiments fix everything.... This is need when
       % calling OED with the inputs structure 
% 
          for iexp=1:inputs.exps.n_exp
             
              if strcmp(inputs.exps.exp_type{iexp},'fixed')
               inputs.exps.exp_y0_type{iexp}='fixed';              % Type of initial conditions: 'fixed' | 'od' (to be designed)
               inputs.exps.tf_type{iexp}='fixed';                  % Type of experiment duration: 'fixed' | 'od' (to be designed)
               inputs.exps.u_type{iexp}='fixed';                   % Type of stimulation: 'fixed' | 'od' (to be designed)
               inputs.exps.ts_type{iexp}='fixed';                  % Type of sampling times: 'fixed' | 'od' (to be designed)
               inputs.exps.obs_type{iexp}='fixed';                 % Type of observation function: 'fixed' | 'od' (to be designed)
              end    
           
          end %for iexp=1:inputs.exps.n_exp
% 
%       % If calling OED with inputs strucute we need to make sure that we
%       % we have not empty elements in structures 
%       
         for iexp=1:inputs.exps.n_exp
             if isempty(inputs.exps.t_in{iexp})
                 inputs.exps.t_in{iexp}=0;
             end
             if isempty(inputs.exps.ts_0{iexp})
                 inputs.exps.ts_0{iexp}=0;
             end
         end
        
               
        
        % Check experiment duration
       
        for iexp=1:inputs.exps.n_exp
        
            switch inputs.exps.tf_type{iexp}
        
            case 'od'    
            if isempty(inputs.exps.tf_min{iexp}) || isempty(inputs.exps.tf_max{iexp}) 
                
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf(1,'\t\tFor optimaly designing experiment duration you need to provide allowed maximum a minimum duration \n');
            fprintf(1,'\t\t please define: inputs.exps.tf_min{iexp} and inputs.exps.tf_max{iexp} for experiment %u\n',iexp);
            error(' Please udpdate your input file. Stopping.');   
                
            end
            if isempty(inputs.exps.tf_guess{iexp})
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\t Initial guess for experiment duration has not been defined inputs.exps.tf_guess{iexp}.\n');
            inputs.exps.tf_guess{iexp}=mean(inputs.exps.tf_min{iexp}, inputs.exps.tf_min{iexp});
            fprintf(1,'\t\t Mean value between maximum and minimum will be used for experiment %u: %f.\n',iexp,inputs.exps.tf_guess{iexp});
            
            end
            end % switch inputs.exps.tf_type{iexp}
        end % for iexp=1:inputs.exps.n_exp
        
        
        % Check sampling
        [inputs]= AMIGO_check_sampling(inputs);
                
        % In OED it is assumed that error on data is known: the
        % std_dev or error_data for fixed experiments and std_dev for
        % designed experiments
        
        % PE cost function is assumed to be llk
        
        inputs.PEsol.PEcost_type='llk';
        inputs.PEsol.llk_type=inputs.exps.noise_type;
        
        
        % Type of experimental error
        for iexp=1:inputs.exps.n_exp
            

           switch inputs.exps.exp_type{iexp}
            
           %%%% FIXED EXPERIMENTS 
            case 'fixed'   
        
                switch inputs.exps.noise_type
                
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
                        fprintf(1,'\t\t Please include experimental noise level  for every fixed experiment.\n');
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
                    if isempty(inputs.exps.error_data{iexp})
                            fprintf(1,'\n\n------> ERROR message\n\n');
                            fprintf(1,'\t\t You have not provided a measure of the standard deviation of your data noise.\n');
                            fprintf(1,'\t\t Please update inputs.exps.error_data{iexp} for each fixed experiment in your input.\n');
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
                
                otherwise
                    error('--> There is no such experimental noise type: inputs.exps.noise_type = %s\n',inputs.exps.noise_type );
                end
                
                
          %%%% OPTIMALY DESIGNED EXPERIMENTS         
            case 'od'           
        
                
                    switch inputs.exps.noise_type
                
                    case {'homo', 'homo_var','hetero'}
                    % the standard deviation is constant
                    if isempty(inputs.exps.std_dev)
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\tFor Maximum Loglikelihood Estimation with homoscedastic noise  \n');
                        fprintf(1,'\t\t please declare the noise level (relative standard deviation) for every measurement: inputs.exps.std_dev{iexp}\n');
                        error(' Please udpdate your input file with inputs.exps.std_dev{%u}. Stopping.',iexp);
                    end
                    if length(inputs.exps.std_dev) < inputs.exps.n_exp
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t The size of std_dev is less then n_exp.\n');
                        fprintf(1,'\t\t Please include experimental noise level  for every od experiment.\n');
                        error('Data_checking:std_dev','Impossible to continue. Stopping.');
                    end
                    if size(inputs.exps.std_dev{iexp},2)==1 && inputs.exps.n_obs{iexp}>1
                        std_dev{iexp}=inputs.exps.std_dev{iexp};
                        fprintf(1,'\n\n------> WARNING message\n\n');
                        fprintf(1,'\t\t Standard deviation, inputs.exps.std_dev{iexp}, should be a vector of dimension 1*n_obs{iexp}.\n');
                        fprintf(1,'\t\t The same std_dev will be used for all observables in experiment %u.\n',iexp);
                        inputs.exps.std_dev{iexp}=std_dev{iexp}*ones(1,inputs.exps.n_obs{iexp});
                        pause(1)
                    end
                    
                    
                    case {'hetero_proportional'}
                    if isempty(inputs.exps.std_dev{1})
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\tFor Maximum Loglikelihood Estimation with heteroscedastic, proportional noise  \n');
                        fprintf(1,'\t\t please declare the noise level (relative standard deviation) for every measurement: inputs.exps.std_dev{iexp}\n');
                        error(' Please udpdate your input file with inputs.exps.std_dev{%u}. Stopping.',iexp);
                    end
                    
                    if length(inputs.exps.std_dev) < inputs.exps.n_exp
                        fprintf(1,'\n\n------> WARNING message\n\n');
                        fprintf(1,'\t\t You have not provided a measure of the standard deviation of your data noise.\n');
                        fprintf(1,'\t\t Please update inputs.exps.std_dev{%u} in your input.\n',iexp);
                        error('CheckData:std_dev','Impossible to continue. Stopping.')
                    end
                    
                    if size(inputs.exps.std_dev{iexp},2)==1 && inputs.exps.n_obs{iexp}>1
                        std_dev{iexp}=inputs.exps.std_dev{iexp};
                        fprintf(1,'\n\n------> WARNING message\n\n');
                        fprintf(1,'\t\t Standard deviation, inputs.exps.std_dev{iexp}, should be a vector of dimension 1*n_obs{%u}.\n',iexp);
                        fprintf(1,'\t\t The same std_dev will be used for all observables.\n');
                        inputs.exps.std_dev{iexp}=std_dev{iexp}*ones(1,inputs.exps.n_obs{iexp});
                        pause(1)
                    end
                    
                   
                    case  'hetero_lin'
                    if isempty(inputs.exps.std_deva{iexp}) || isempty(inputs.exps.std_devb{iexp})
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t You have selected to use heteroscedastic noise with treshold,\n');
                        fprintf(1,'\t\t however you did not specify the noise parameters. \n');
                        fprintf(1,'\t\t Please updata inputs.exps.std_deva{%u}) and inputs.exps.std_devb{%u} in your input.\n',iexp,iexp);
                        error('CheckData:hetero_linParameters','Missing noise parameters, impossible to continue. Stopping.')
                    end
                    if length(inputs.exps.std_deva) < inputs.exps.n_exp || length(inputs.exps.std_devb) < inputs.exps.n_exp
                        fprintf(1,'\n\n------> ERROR message\n\n');
                        fprintf(1,'\t\t You have selected to use heteroscedastic noise with treshold,\n');
                        fprintf(1,'\t\t however you did not specify the noise parameters for all experiments. \n');
                        fprintf(1,'\t\t Please include inputs.exps.std_deva{%u}) and inputs.exps.std_devb{%u} for each experiment in your input.\n',iexp);
                        error('CheckData:hetero_linParameters','Missing noise parameters, Impossible to continue. Stopping.')
                    end
                
                otherwise
                    error('--> There is no such experimental noise type: inputs.exps.noise_type = %s\n',inputs.exps.noise_type );
                end
             
                   inputs.exps.error_data{iexp}=[];  
                
                
        end %switch inputs.exps.exp_type{iexp}
        
        
        
        end % for iexp=1:inputs.exps.n_exp

inputs.exps.exp_data = inputs.exps.exp_data(1:inputs.exps.n_exp);
inputs.exps.error_data = inputs.exps.error_data(1:inputs.exps.n_exp);

return


