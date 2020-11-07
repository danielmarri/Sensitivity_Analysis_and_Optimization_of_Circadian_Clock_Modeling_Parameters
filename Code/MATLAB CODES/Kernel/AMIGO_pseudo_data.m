function [exp_data,error_data,residuals,norm_residuals]=AMIGO_pseudo_data(inputs,results,privstruct)
% AMIGO_pseudo_data: Computes pseudo-experimental data
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto, Attila Gabor, David Henriques        %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_pseudo_data: computes pseudo-experimental data for numerical tests,  %
%                     taking into account the maximum experimental error in   %
%                     terms of the standard deviation and the type of         %
%                     experimental noise: homocedastic or heterocedastic      %
%                                                                             %
%                     REMARK: the values for the parameters and initial       %
%                     conditions are the ones introduced in inputs.model.par  %
%                     and inputs.exps.exp_y0{iexp}                            %
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_pseudo_data.m 2138 2015-09-21 10:13:12Z evabalsa $

fprintf(1,'\n\n\n------> Calculating simulated experimental data for synthetic problems.');
fprintf(1,'\n\n         Experimental noise being used:');
switch inputs.exps.noise_type
    case 'hetero_proportional'
        fprintf(1,'\n\t\t Heterocedastic noise. \n');
        fprintf(1,'\t\t Standard deviation proportional to the observable: a*y being a maximum:\n');
        for iexp=1:inputs.exps.n_exp
            fprintf(1,'\n\t\t\t*Experiment %u:\n',iexp);
            for iobs=1:inputs.exps.n_obs{iexp}
                fprintf(1,' \n\t\t\tObservable %u, %f (percent)',iobs, 100.*inputs.exps.std_dev{iexp}(iobs));
            end
        end
        
    case 'hetero'
        fprintf(1,'\n\t\t Heterocedastic noise. \n');
        fprintf(1,'\t\t Standard deviation is given for each point:\n');
        for iexp=1:inputs.exps.n_exp
            fprintf(1,'\n\t\t\t*Experiment %u:\n',iexp);
            fprintf(1,' \n\tTime\t\t\t\tObservables (abs STD)\n');
            for itime = 1:inputs.exps.n_s{iexp}
                fprintf(1,'\tt(%d)\t',itime);
                for iobs=1:inputs.exps.n_obs{iexp}
                    fprintf(1,'%2.2g\t',inputs.exps.error_data{iexp}(itime,iobs));
                end
                fprintf(1,'\n');
            end
        end
    case 'hetero_lin'
        fprintf(1,'\n\t\t Heterocedastic noise a+b*y. \n');
        for iexp=1:inputs.exps.n_exp
            fprintf(1,'\n\t\t\t*Experiment %u:\n',iexp);
            for iobs=1:inputs.exps.n_obs{iexp}
                fprintf(1,' \n\t\t\tObservable %u, %f ,%f',iobs, inputs.exps.std_deva{iexp}(iobs),inputs.exps.std_devb{iexp}(iobs));
            end
        end
        
    case 'homo_var'
        fprintf(1,'\n\t\t Homocedastic noise with varying variance.\n');
        fprintf(1,'\t\t Maximum standard deviation:\n');
        for iexp=1:inputs.exps.n_exp
            fprintf(1,'\n\t\t\t*Experiment %u:\n',iexp);
            for iobs=1:inputs.exps.n_obs{iexp}
                fprintf(1,' \n\t\t\tObservable %u, %f (percent)',iobs, 100.*inputs.exps.std_dev{iexp}(iobs));
            end
        end
    case 'homo'
        fprintf(1,'\n\t\t Homocedastic noise with constant variance.\n');
        fprintf(1,'\t\t Maximum standard deviation:\n');
        for iexp=1:inputs.exps.n_exp
            fprintf(1,'\n\t\t\t*Experiment %u:\n',iexp);
            for iobs=1:inputs.exps.n_obs{iexp}
                fprintf(1,' \n\t\t\tObservable %u, %f (percent)',iobs, 100.*inputs.exps.std_dev{iexp}(iobs));
            end
        end
end


% Perform simulation for each set of experimental condition

for iexp=1:inputs.exps.n_exp
    
    % build the timevector:
    privstruct.t_int{iexp}= inputs.exps.t_s{iexp};
    privstruct.vtout{iexp}=sort(union(privstruct.t_int{iexp},inputs.exps.t_con{iexp}));
    
    % Memory allocation for matrices
    yteor=zeros(inputs.exps.n_s{iexp},inputs.model.n_st);
    ms=zeros(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
    error_matrix=[];
    
    % Perform integration
    
    yteor=AMIGO_ivpsol(inputs,privstruct,inputs.exps.exp_y0{iexp},inputs.model.par,iexp);
 
    % generate observables
    obsfunc=strcat('AMIGO_gen_obs_',inputs.pathd.short_name);
    ms=feval(obsfunc,yteor,inputs,inputs.model.par,iexp);
   
    % To generate pseudo-data the following will be taken into account
    % std_dev, corresponds to the 68.26% distribution
    % 2*std_dev, corresponds to a 95.54% distribution
    % an intermediate value 1.1 will be selected to guarantee that the
    % experimental error is within 1.25 std_dev
    %dist_ratio=1.25;
    
    switch inputs.exps.noise_type
        
        case 'hetero_lin'
            % noise with threshold 
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
            
        case 'hetero_proportional' 
            % the standard deviation is proportional to the signal. The
            % ratio is given by the user. 
            std_dev_rel{iexp}=inputs.exps.std_dev{iexp};
            for iobs=1:inputs.exps.n_obs{iexp}
                std_dev{iexp}(:,iobs) = ms(:,iobs).*std_dev_rel{iexp}(iobs);
                rand_mat = randn(inputs.exps.n_s{iexp},1);
                error_data{iexp}(:,iobs) = ms(:,iobs).*(std_dev_rel{iexp}(iobs)*rand_mat);
                exp_data{iexp}(:,iobs) = ms(:,iobs).*(ones(inputs.exps.n_s{iexp},1))+error_data{iexp}(:,iobs);
            end
            
            % AG: the error data must contain the absolute standard deviation:
            error_data{iexp} = std_dev{iexp};
            
        case 'hetero'
            % the standard deviation is given by the user for every point separately. 
            
            std_dev{iexp} = inputs.exps.error_data{iexp};
            rand_mat = randn(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
            
            error_d = rand_mat.*std_dev{iexp};
            exp_data{iexp} = ms + error_d;
            
            % AG: the error data must contain the absolute standard deviation:
            error_data{iexp} = std_dev{iexp};
            
        case 'homo_var' 
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
                std_dev{iexp}(iobs)=inputs.exps.std_dev{iexp}(iobs)*randn(1,1); %(2*rand(1,1)-1);
                %val_error_data{iexp}(iobs)=abs(max(ms(:,iobs))).*std_dev{iexp}(iobs);%max(abs(ms(:,iobs))).*std_dev{iexp}(iobs);
                error_data{iexp} = repmat(inputs.exps.std_dev{iexp}.*max(abs(ms),[],1),inputs.exps.n_s{iexp},1);
                exp_data{iexp}(:,iobs)=ms(:,iobs)+mov_mat(:,1).*error_data{iexp}(:,iobs);
            end;
        case 'log_normal_background'
            % multiplicative, lognormally distributed noise with standard
            % deviation given in inputs.exps.std_deva and background noise
            % given in stddevb
            %   y = x*e^(mu) + eta, 
            % where
            %   mu ~ N(0,stddevb)
            %   eta ~ N(0,stddeva)
            
            mu{iexp}  = repmat(inputs.exps.std_devb{iexp},inputs.exps.n_s{iexp},1);
            eta{iexp} = repmat(inputs.exps.std_deva{iexp},inputs.exps.n_s{iexp},1);
            
            rand_mat1 = randn(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
            rand_mat2 = randn(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
            
            error_d1 = rand_mat1.*mu{iexp};
            error_d2 = rand_mat2.*eta{iexp};
            
            exp_data{iexp} = ms.*exp(error_d1) + error_d2;
            
            % error data contains the standard deviation of the error. Note
            % that the mean of the lognormal distribution is not 1, even
            % though the mean of the corresponding normal distribution is
            % 0
            error_data{iexp} = sqrt(ms.^2.*exp(mu{iexp}.^2).*(exp(mu{iexp}.^2)-1) + eta{iexp}.^2);
            std_dev{iexp} = error_data{iexp};
        case 'log_normal'
            % multiplicative, lognormally distributed noise with standard
            % deviation given in inputs.exps.std_deva
            
            std_dev{iexp} = repmat(inputs.exps.std_devb{iexp},inputs.exps.n_s{iexp},1);
            rand_mat = randn(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
            
            error_d = rand_mat.*std_dev{iexp};
            
            exp_data{iexp}=ms.*exp(error_d);
            
            % error data contains the standard deviation of the error. Note
            % that the mean of the lognormal distribution is not 1, even
            % though the mean of the corresponding normal distribution is
            % 0
            error_data{iexp} = ms.*sqrt(exp(std_dev{iexp}.^2).*(exp(std_dev{iexp}.^2)-1));
        otherwise
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf(1,'\t\t No such experimental noise type: %s\n',inputs.exps.noise_type);
            fprintf(1,'\t\t Please update inputs.exps.noise_type in your input.\n');
            error('PseudoData:noisetype','Impossible to continue. Stop.')
    end
    
    switch inputs.exps.data_type
        case 'pseudo_pos'
            exp_data{iexp}=abs(exp_data{iexp});
    end
    
% we should take care of this, where we divide by the data. But for now we
% should allow near 0. 
%     for i_obs=1:inputs.exps.n_obs{iexp}
%         for i_s=1:inputs.exps.n_s{iexp}
%             if(abs(exp_data{iexp}(i_s,i_obs))<=1e-12) % To avoid  /0
%                exp_data{iexp}(i_s,i_obs)=inputs.ivpsol.atol;
%             end;
%         end;
%     end
    
    
    
    residuals{iexp}=ms-exp_data{iexp};
    for iobs=1:inputs.exps.n_obs{iexp}
        norm_residuals{iexp}(:,iobs)=residuals{iexp}(:,iobs)./std_dev{iexp}(iobs);
    end
end

error_data{iexp}=abs(error_data{iexp});
return;