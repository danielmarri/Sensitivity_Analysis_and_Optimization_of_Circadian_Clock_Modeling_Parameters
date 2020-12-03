% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_MC_data.m 1891 2014-10-29 11:43:56Z evabalsa $
function [exp_data,error_data]=AMIGO_MC_data(theta,inputs,results,privstruct)

% AMIGO_pseudo_data: Computes experimental data for Monte Carlo analyses
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
%  AMIGO_MC_data: computes pseudo-experimental data for the Monte Carlo       %
%                     based identifiability analysis                          %
%                                                                             %
%*****************************************************************************%
 
    % Perform simulation for each set of experimental conditions
  

   privstruct.theta=theta;
   privstruct=AMIGO_transform_theta(inputs,results,privstruct);

    for iexp=1:inputs.exps.n_exp

        privstruct.t_int{iexp}= inputs.exps.t_s{iexp};
        privstruct.vtout{iexp}=sort(union(privstruct.t_int{iexp},inputs.exps.t_con{iexp})); 
   % Memory allocation for matrices
        yteor=zeros(inputs.exps.n_s{iexp},inputs.model.n_st);  
        ms=zeros(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
        error_matrix=[];
   % Perform integration
  
        yteor=AMIGO_ivpsol(inputs,privstruct,inputs.exps.exp_y0{iexp},privstruct.par{iexp},iexp);
        obsfunc=strcat('AMIGO_gen_obs_',results.pathd.short_name);
     
        ms=feval(obsfunc,yteor,inputs,privstruct.par{iexp},iexp);
        
        % To generate pseudo-data the following will be taken into account
                % std_dev, corresponds to the 68.26% distribution
                % 2*std_dev, corresponds to a 95.54% distribution
        % an intermediate value 1.5 will be selected to guarantee that the 
        % experimental error is within 1.5 std_dev
        %dist_ratio=2;        
        dist_ratio=1;
        
        switch inputs.exps.data_type
            
            case 'real'

                if isempty(inputs.exps.original_error_data{iexp})==1
                      
                   
                switch inputs.exps.noise_type
            
                case 'hetero' % Assuming quadratic dependence on the states
                std_dev{iexp}=inputs.exps.std_dev{iexp};   
                for iobs=1:inputs.exps.n_obs{iexp}
                rand_mat=randn(inputs.exps.n_s{iexp},1); %2.*rand(inputs.exps.n_s{iexp},1)-ones(inputs.exps.n_s{iexp},1);  
                error_data{iexp}(:,iobs)=ms(:,iobs).*(dist_ratio*std_dev{iexp}(iobs));  
                exp_data{iexp}(:,iobs)=ms(:,iobs).*(ones(inputs.exps.n_s{iexp},1))+(error_data{iexp}(:,iobs)*rand_mat);
                end
               
                case 'homo'  
                for iobs=1:inputs.exps.n_obs{iexp}    
                std_dev{iexp}(iobs)=dist_ratio*inputs.exps.std_dev{iexp}(iobs)*randn(1,1);%(2*rand(1,1)-1); 
                val_error_data{iexp}(:,iobs)=max(abs(ms(:,iobs))).*std_dev{iexp}(iobs);
                A=(2*rand(inputs.exps.n_s{iexp},1)-1);
                B=(2*rand(inputs.exps.n_s{iexp},1)-1);
                mov_mat=floor(A)+ceil(B); %%% This is to move data around the model prediction. Data points > and < than ms
                for is=1:inputs.exps.n_s{iexp}
                error_data{iexp}(is,iobs)=val_error_data{iexp}(iobs);
                end    
                exp_data{iexp}(:,iobs)=ms(:,iobs)+mov_mat(:,1).*error_data{iexp}(:,iobs);      
                end;
                                           
                case 'hetero_lin' % 
                std_deva{iexp}=dist_ratio*inputs.exps.stddeva{iexp};  % std_deva{iexp}=dist_ratio*inputs.PEsol.llk.stddeva{iexp};    
                std_devb{iexp}=dist_ratio*inputs.exps.stddevb{iexp};  % std_devb{iexp}=dist_ratio*inputs.PEsol.llk.stddevb{iexp};
                for iobs=1:inputs.exps.n_obs{iexp}
                rand_mata=randn(inputs.exps.n_s{iexp},1);%2.*rand(inputs.exps.n_s{iexp},1)-ones(inputs.exps.n_s{iexp},1);  
                rand_matb=randn(inputs.exps.n_s{iexp},1);%2.*rand(inputs.exps.n_s{iexp},1)-ones(inputs.exps.n_s{iexp},1);  
                error_data{iexp}(:,iobs)=std_deva{iexp}(iobs)*rand_mata+ms(:,iobs).*(std_devb{iexp}(iobs)*rand_matb);  
                exp_data{iexp}(:,iobs)=ms(:,iobs).*(ones(inputs.exps.n_s{iexp},1))+error_data{iexp}(:,iobs);
                end
                
                end  
                                                           
                
                else
                                      
                rand_mat=randn(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp}); %2.*rand(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp})-ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp}); 
               
                error_data{iexp}=dist_ratio*inputs.exps.original_error_data{iexp};
                exp_data{iexp}=ms+error_data{iexp}.*rand_mat; 
                end
             

                
            case {'pseudo','pseudo_pos'}
               switch inputs.exps.noise_type
            
                case 'hetero' % Assuming quadratic dependence on the states
                std_dev_rel{iexp}=inputs.exps.std_dev{iexp};
                std_dev{iexp} = ms.*std_dev_rel{iexp}(iobs);
                for iobs=1:inputs.exps.n_obs{iexp}
                rand_mat = randn(inputs.exps.n_s{iexp},1);
                error_data{iexp}(:,iobs) = ms(:,iobs).*(std_dev_rel{iexp}(iobs)*rand_mat);
                exp_data{iexp}(:,iobs) = ms(:,iobs).*(ones(inputs.exps.n_s{iexp},1))+error_data{iexp}(:,iobs);
                end
            
             % AG: the error data must contain the absolute standard deviation:
                error_data{iexp} = std_dev{iexp};
                
                case 'homo_var' % Computes the standard deviation for every sampling
            % The datapoints of each observables has the same,
            % constant relative standard deviation provided by the user. we
            % scale up by the maximum of each observables
            
                for iobs=1:inputs.exps.n_obs{iexp}
                rand_mat=randn(inputs.exps.n_s{iexp},1);
                std_dev{iexp}(:,iobs)= inputs.exps.std_dev{iexp}(iobs)*rand_mat;
                end
                for is=1:inputs.exps.n_s{iexp}
                error_data{iexp}(is,:)= max(abs(ms),[],1).*std_dev{iexp}(is,:);
                end
            
                exp_data{iexp}=ms+error_data{iexp};
            
            % AG: the error data must contain the absolute standard deviation:
                error_data{iexp} = repmat(inputs.exps.std_dev{iexp}.*max(abs(ms),[],1),inputs.exps.n_s{iexp},1);
            
                case 'homo'  
                for iobs=1:inputs.exps.n_obs{iexp}
                A=(2*rand(inputs.exps.n_s{iexp},1)-1);
                B=(2*rand(inputs.exps.n_s{iexp},1)-1);
                mov_mat=floor(A)+ceil(B); %%% This is to move data around the model prediction. Data points > and < than ms
                std_dev{iexp}(iobs)=inputs.exps.std_dev{iexp}(iobs); %(2*rand(1,1)-1);
                val_error_data{iexp}(iobs)=abs(max(ms(:,iobs))).*std_dev{iexp}(iobs);%max(abs(ms(:,iobs))).*std_dev{iexp}(iobs);
                
                for is=1:inputs.exps.n_s{iexp}
                    error_data{iexp}(is,iobs)=val_error_data{iexp}(iobs);
                end
                exp_data{iexp}(:,iobs)=ms(:,iobs)+mov_mat(:,1).*error_data{iexp}(:,iobs)*randn(1,1);
                end;
                % AG: the error data must contain the absolute standard
                % deviation:
                
                max(abs(ms),[],1)
                pause
                error_data{iexp} = repmat(inputs.exps.std_dev{iexp}.*max(abs(ms),[],1),inputs.exps.n_s{iexp},1);
            
                               
                case 'hetero_lin' % 
            % noise depends 
            std_deva{iexp}=inputs.exps.std_deva{iexp};
            std_devb{iexp}=inputs.exps.std_devb{iexp};
            
            for iobs=1:inputs.exps.n_obs{iexp}
                
                std_dev{iexp}(:,iobs) = sqrt(std_deva{iexp}(iobs).^2.*ones(inputs.exps.n_s{iexp},1)+ std_devb{iexp}(iobs).^2.*ms(:,iobs).^2);
                rand_mata=randn(inputs.exps.n_s{iexp},1);
                rand_matb=randn(inputs.exps.n_s{iexp},1); 
                error_data{iexp}(:,iobs)=std_deva{iexp}(iobs)*rand_mata+ms(:,iobs).*(std_devb{iexp}(iobs)*rand_matb);
                exp_data{iexp}(:,iobs)=ms(:,iobs).*(ones(inputs.exps.n_s{iexp},1))+error_data{iexp}(:,iobs);
                % error data is the standard deviation of the points. 
                % error_data{iexp}(:,iobs) = sqrt(std_deva{iexp}(iobs).^2+(ms(:,iobs).*(std_devb{iexp}(iobs)*rand_matb)).^2); 
            end
            
            % AG: the error data must contain the absolute standard deviation:
            error_data{iexp} = std_dev{iexp};
                
               end             
               
            
        end
       
            
        switch inputs.exps.data_type
        case 'pseudo_pos'
            exp_data{iexp}=abs(exp_data{iexp});
        end
    end % for iexp

  return;