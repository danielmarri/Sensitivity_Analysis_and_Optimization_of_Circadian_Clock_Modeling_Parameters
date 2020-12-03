%% Obejctive functional
% [yteor] = AMIGO_ODcost(od,inputs,results,privstruct)
%
%  Arguments: od (current value of decision variables)
%             inputs,results,privstruct
%             yteor (value of the states for the given 
%                    decision variables)
% *Version details*
% 
%   AMIGO_OD version:     March 2013
%   Code development:     Eva Balsa-Canto
%   Address:              Process Engineering Group, IIM-CSIC
%                         C/Eduardo Cabello 6, 36208, Vigo-Spain
%   e-mail:               ebalsa@iim.csic.es 
%   Copyright:            CSIC, Spanish National Research Council
%
% *Brief description*
%
%  Function that provides the necessary inputs for the OD 
%  cost function and constraints. Note that problem dependent
%  functions will be generated for cost function and constraints.
%   
%%



function [yteor,f,g] = AMIGO_IOCcost(ido,inputs,results,privstruct);


global n_amigo_sim_success;
global n_amigo_sim_failed;
if inputs.pathd.print_details
    disp('--> AMIGO_IOCcost()')
end

    % Initialice cost
        f=0.0;
        g=[];
        privstruct.ioc=ido;
       
     %%% COUNTS DATA
 
      ndata=0;
      nexpdata = zeros(1,inputs.exps.n_exp);
% number of data: total and for each experiment
fregexp=zeros(inputs.exps.n_exp,1); %%ADDED BY NIKOS 15/10/2018
for iexp=1:inputs.exps.n_exp
    % count the numerical element of exp_data. (excluding the nan-s)
    exp_data = inputs.exps.exp_data{iexp};
   
    if isempty(inputs.exps.nanfilter{iexp})
        nexpdata(iexp) = inputs.exps.n_s{iexp}*inputs.exps.n_obs{iexp};
        inputs.exps.nanfilter{iexp} = true(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
    else
        nexpdata(iexp) = numel(exp_data(inputs.exps.nanfilter{iexp}));
       
    end
    
    ndata=ndata+nexpdata(iexp);
end
g = zeros(1,ndata);
        
        
        
%% CVP approach
%
% * Calls AMIGO_transform_od to generate u and tf from the vector ido

        [privstruct,inputs,results]=AMIGO_transform_ioc(inputs,results,privstruct);
        
        
%% Inner iteration: IVP solution
%
% * Calls AMIGO_ivpsol
        %if privstruct.iflag==2   
  nprocessedData = 0;        
          
for iexp=1:inputs.exps.n_exp
            % Memory allocation for matrices
            %privstruct.yteor=zeros(inputs.exps.n_s{iexp},inputs.model.n_st);
            %ms=zeros(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
            
            error_matrix=[];
            

            [yteor{iexp},privstruct]=AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par{iexp},iexp);

        
 %%% COMPUTES OBSERVABLES
  
            privstruct.yteor=yteor{iexp};
            
            obsfunc=inputs.pathd.obs_function;
            
            ms=feval(...
                obsfunc,...
                privstruct.yteor,...
                inputs,...
                privstruct.par{iexp},...
                iexp...
                );
            
       
            if(privstruct.ivpsol.ivp_fail)
                f=Inf;
                g(1:ndata) = Inf;
                return;             
            end %if(privstruct.ivpsol.ivp_fail)
           
 
  %%% COMPUTES COST       
  % accumulate the number of data in each experiment.
  %Helps indexing the cost vector / residual vector

  switch inputs.IOCsol.ioccost_type   
                
                %LEAST SQUARES FUNCTION
                
                case 'lsq'
                    
                    % residuals in matrix form without weighting:
                    
                    resM = ms-inputs.exps.exp_data{iexp};
                    
                    switch inputs.IOCsol.lsq_type
                        
                        case 'Q_mat'
                            % weighting matrix:
                            Q = inputs.PEsol.lsq_Qmat{iexp};
    
                            scaledResM = resM.*Q;
                            scaledResM(isnan(scaledResM))=[];
                            % reshape to a columnvector:
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = scaledResM(:);
                            fres=g*g';
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20; end
                            
                        case 'Q_mat_obs' % for the cases where the observables have different matrices
                            % weighting matrix:
                            Q = inputs.IOCsol.lsq_Qmat{iexp};
                            scaledResM = reshape(resM,1,ndata)*Q;
                            scaledResM(isnan(scaledResM))=[];
                            % reshape to a columnvector:
                            g = scaledResM;
                            fres=g*g';
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20; end
                            
                        case 'Q_I'
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = resM(:);
                            fres=g*g';
                           
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20; end
                            
                        case 'Q_exp'
                            % weighting matrix is the measurements.
                            Q = 1./inputs.exps.exp_data{iexp};
                            tmp1 = or(isinf(Q),isinf(Q));
                            % if the inverse is inf or too huge (data near zero), than the
                            Q(tmp1) = 1;
                            scaledResM = resM.*Q;
                            scaledResM(isnan(scaledResM))=[];
                            % reshape to a columnvector:
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = scaledResM(:);
                            fres=g*g';
                            if isreal(fres)==0 || isnan(fres)==1
                               fres=1e20; end
                            
                        case 'Q_expmax'
                            expDataMax = max(inputs.exps.exp_data{iexp});
                            % every timepoint of each observable have the same
                            % weighting factor:
                            Q = repmat(1./expDataMax, inputs.exps.n_s{iexp},1);
                            % handles close infinity weights / clsoe zero experiments:
                            tmp1 = or(isnan(Q),isinf(Q));
                            Q(tmp1) = 1;
                            scaledResM = resM.*Q;
                            scaledResM(isnan(scaledResM))=[];
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = scaledResM(:);
                            fres=g*g';
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20; end
                            
                        case 'Q_expmean'
                            % weighting matrix is the mean of the trajectories
                            expDataMean = mean(inputs.exps.exp_data{iexp});
                            Q = repmat(1./expDataMean, inputs.exps.n_s{iexp},1);
                            % handles close infinity weights:
                            tmp1 = or(isnan(Q),isinf(Q));
                            Q(tmp1) = 1;
                            
                            scaledResM = resM.*Q;
                            scaledResM(isnan(scaledResM))=[];
                            % reshape to a columnvector:
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = scaledResM(:);
                            fres=g*g';
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20; end
                        otherwise
                            error('There is no such kind of lsq_type: %s', inputs.IOCsol.lsq_type);
                                                        
                   end %switch inputs.lsq_type
  
                    case 'llk'
                    % EBC to make it work for homo_var--- REMOVE
                    %inputs.PEsol.llk_type='homo_var';
                    
                    switch inputs.IOCsol.llk_type
                        
                        %       AG commented this case 19/09/13                  case 'homo'
                        %                             % residuals weighted by the error data
                        %
                        %                             if isempty(inputs.exps.error_data{iexp})
                        %
                        %                                 inputs.exps.error_data{iexp}=...
                        %                                     repmat(max(inputs.exps.exp_data{iexp}).*inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                        %                             end
                        %                             scaledResM = resM./inputs.exps.error_data{iexp};
                        %
                        %                             g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = scaledResM(:);
                        %
                        %                             f=0.5*(g*g');
                        %                             if isreal(fres)==0 || isnan(fres)==1
                        %                                 f=1e20;
                        %                             end
                        
                        case {'homo','homo_var'}
                            
                            error_data =  repmat(max(inputs.exps.exp_data{iexp}).*inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                            
                            error_data(error_data <= 1e-12) = inputs.ivpsol.atol;    %To avoid /0
                            
                            
                            for i_obs=1:inputs.exps.n_obs{iexp}
                                error_matrix=...
                                    [error_matrix; (ms(:,i_obs)-inputs.exps.exp_data{iexp}(:,i_obs))./(error_data(:,i_obs))];
                            end
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = error_matrix';
                            %                             g=[g error_matrix'];
                            
                            %f = 0.5*sum(g.^2); if the 0.5 is needed here,
                            %be sure that the Least Squares local algorithm
                            %also takes the half. Otherwise the value
                            %computed by the eSS and the value computed by
                            %the NLS solver are different.
                            fres = sum(g.^2);
                            
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20;
                            end
                            
                            
                        case 'hetero'
                            % changed by AG
                            % heteroscedastic noise with known  standard
                            % deviation (sigma and not sigma^2!)
                            % provided in inputs.exps.error_data{iexp}.
                            % weighted least squares case.
                            
                            
                            error_data = abs(inputs.exps.error_data{iexp});
                            error_data(abs(error_data) <= inputs.ivpsol.atol) = inputs.ivpsol.atol;    %To avoid /0
                            
                            try
                                error_matrix = (ms - inputs.exps.exp_data{iexp})./error_data;
                            catch
                                fprintf('The observation function is probably corrupted.\n');
                                keyboard
                            end
                            
                            error_matrix = error_matrix(inputs.exps.nanfilter{iexp});
                            
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = error_matrix(:)';
                            
                            fres=sum(g.^2);
                            
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20;
                            end
                            
                        case 'hetero_proportional'
                            %Standard deviation is assumed to be
                            %proportional to ms, noise = std_dev*y
                            
                            ms(ms<=1e-12)=inputs.ivpsol.atol;   % To avoid log(0) and /0
                            
                            for i_obs=1:inputs.exps.n_obs{iexp}
                                
                                g1=g1+sum(log(abs(ms(:,i_obs))));
                                
                                % dREAM g1=g1+sum(log(0.01*ones(size(ms(:,i_obs)))+0.04*ms(:,i_obs).^2));
                                
                                error_matrix=...
                                    [error_matrix; (ms(:,i_obs)-inputs.exps.exp_data{iexp}(:,i_obs))...
                                    ./(inputs.exps.std_dev{iexp}(i_obs).*ms(:,i_obs))];
                                
                            end %i_obs=1:inputs.exps.n_obs{iexp}
                            
                            %g is only approximated in this case, better
                            %not to use n2fb or dn2fb or NL2SOL
                            % DO NOT USE NL2SOL, THIS IS NOT A NONLINEAR
                            % LEAST SQUARES PROBLEM!!!
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = error_matrix';
                            %g=[g error_matrix'];
                            
                            fres=(2/ndata)*g1+sum(g.^2);
                            
                            if isreal(fres)==0 || isnan(fres)==1
                                fres=1e20;
                            end
                            
                            
                            
                        case 'hetero_lin'
                            
                            for i_obs=1:inputs.exps.n_obs{iexp}
                                
                                for i_s=1:inputs.exps.n_s{iexp}
                                    if(abs(ms(i_s,i_obs))<=1e-12) % To avoid log(0) and /0
                                        ms(i_s,i_obs)=inputs.ivpsol.atol;
                                    end
                                end
                                
                                g1=g1+sum(log((inputs.PEsol.llk.stddeva{iexp}(i_obs)^2)*ones(size(ms(:,i_obs)))+(inputs.PEsol.llk.stddevb{iexp}(i_obs)^2)*ms(:,i_obs).^2));
                                % dREAM g1=g1+sum(log(0.01*ones(size(ms(:,i_obs)))+0.04*ms(:,i_obs).^2));
                                error_matrix=[error_matrix; (ms(:,i_obs)-inputs.exps.exp_data{iexp}(:,i_obs))./(inputs.PEsol.llk.stddeva{iexp}(i_obs)+inputs.PEsol.llk.stddevb{iexp}(i_obs).*ms(:,i_obs))];
                            end %i_obs=1:inputs.exps.n_obs{iexp}
                            
                            g(nprocessedData+1 : nprocessedData + nexpdata(iexp)) = error_matrix';
                            %g=[g error_matrix'];  % g is only approximated in this case, better not to use n2fb or dn2fb
                            
                            fres=(2/ndata)*g1+sum(g.^2);
                            if ~isreal(fres) || isnan(fres)
                                fred=1e20;
                            end
                            
                            
                        otherwise
                            error('There is no such kind of llk_type: %s', inputs.PEsol.llk_type);
                            
                    end %switch inputs.IOCsol.llk_type
                                        
                otherwise
                    error('There is no such kind of cost-function type: %s', inputs.PEsol.PEcost_type);
            end %   switch inputs.IOCsol.ioccost_type
    nprocessedData =nprocessedData + nexpdata(iexp);         
    nf=fres/length(g);
%     f=nf; %%CHANGED BY NIKOS 15/10/2018 commented out
   
            % REGULARIZATION CONTROL --- SOLVING: INTEGRAL (U-U_REF)^2
            
            if inputs.model.alpha>0 || inputs.model.beta>0
                   reg_u=0;
                 
                   if isempty(inputs.IOCsol.par_ref)
                   inputs.IOCsol.par_ref=inputs.IOCsol.par_guess;
                   end
                          
                   reg_par=sum((privstruct.par{iexp}(inputs.IOCsol.index_par)-inputs.IOCsol.par_ref).^2);
                   
                   if isfield(inputs.IOCsol,'index_y0')
                   if not(isempty(inputs.IOCsol.index_y0)); %%ADDED by NIKOS 27/09/2018 to put reg on unknown initial conditions
                   reg_par=reg_par+sum((privstruct.y_0{iexp}(inputs.IOCsol.index_y0)-inputs.IOCsol.y0_guess).^2); %%ADDED by NIKOS 27/09/2018
                   end %%ADDED by NIKOS 27/09/2018
                   end

                   fregexp(iexp)=fregexp(iexp)+inputs.model.beta*reg_par;%%CHANGED BY NIKOS 15/10/2018 from 'f' to 'fregexp(iexp)'
           
                   if isempty(inputs.IOCsol.u_ref{iexp})
                   inputs.IOCsol.u_ref{iexp}=inputs.IOCsol.u_guess{iexp};
                   end
                 
                   
                    switch inputs.exps.u_interp{iexp}     
                 
                    case 'sustained'
                     
                     for iu=1:inputs.model.n_stimulus
                     reg_u=reg_u+(inputs.exps.u{iexp}(iu)-inputs.IOCsol.u_ref{iexp}(iu))^2*privstruct.tf{iexp};
                     end
                     
                     penalty_noisy_u=0;
                    case {'step','stepf'}
                        
                     for iu=1:inputs.model.n_stimulus
                     reg_u=reg_u+sum((inputs.exps.u{iexp}(iu,:)-inputs.IOCsol.u_ref{iexp}(iu,:)).^2.*diff(privstruct.t_con{iexp}));
                     end  
                                 
                    case {'linear','linearf'}
                     for iu=1:inputs.model.n_stimulus
                      for ilinear=1:inputs.IOCsol.n_linear{iexp}-1
                        d(iu,ilinear)=((inputs.exps.u{iexp}(iu,ilinear+1)-inputs.IOCsol.u_ref{iexp}(iu,ilinear+1))+(inputs.exps.u{iexp}(iu,ilinear)-inputs.IOCsol.u_ref{iexp}(iu,ilinear)))/2;
                      end
                     reg_u=reg_u+sum(d(iu).^2.*diff(privstruct.t_con{iexp}));
                     end
                    end %switch inputs.exps.u_interp{iexp}     
                        
                   
                    fregexp(iexp)=fregexp(iexp)+inputs.model.alpha*reg_u/inputs.model.n_stimulus/privstruct.t_con{iexp}(end);%%CHANGED BY NIKOS 15/10/2018 from 'f' to 'fregexp(iexp)'
            end % if inputs.model.alpha>0
            
            % SMOOTHING
            
          
           
            if inputs.IOCsol.smoothing >0
            switch inputs.exps.u_interp{iexp}  
                case 'sustained'
                penalty_noisy_u=0;
                case {'stepf','step'}
                penalty_noisy_u=0;
                for iu=1:inputs.model.n_stimulus   
                penalty_noisy_u=penalty_noisy_u+sum(abs(diff(inputs.exps.u{iexp}(iu,:))./max(inputs.exps.u{iexp}(iu,:)))>0.05)/length(inputs.exps.u{iexp}(iu,:));
                end
                if inputs.IOCsol.n_steps{iexp}>1 && penalty_noisy_u==0
                penalty_noisy_u=length(inputs.exps.u{iexp}); % penalty over sustained profiles
                end         
                case {'linearf','linear'}
                penalty_noisy_u=0;
                for iu=1:inputs.model.n_stimulus   
                penalty_noisy_u=penalty_noisy_u+sum(abs(diff(inputs.exps.u{iexp}(iu,:))./max(inputs.exps.u{iexp}(iu,:)))>0.05)/length(inputs.exps.u{iexp}(iu,:));
                end
                if inputs.IOCsol.n_linear{iexp}>1 && penalty_noisy_u==0
                penalty_noisy_u=length(inputs.exps.u{iexp}); % penalty over sustained profiles
                end
                
            end    
            
            np=sum(abs(diff(inputs.exps.u{iexp}(iu,:))./max(inputs.exps.u{iexp}(iu,:)))>0.05);

            fregexp(iexp)=fregexp(iexp)+inputs.IOCsol.smoothing*penalty_noisy_u; % penalty on the number of elments contributing to noisy profiles %%CHANGED BY NIKOS 15/10/2018 from 'f' to 'fregexp(iexp)'
                    
            %f=2*np + ndata*log(sum(g.^2));
            end
            
            
            
            if inputs.IOCsol.uttReg>0
                
                
              switch inputs.exps.u_interp{iexp}  
                  
                case 'sustained'
                penalty_uttReg=0;
                case {'stepf','step'}
                penalty_uttReg=0;
                for iu=1:inputs.model.n_stimulus   
                uS=spline(privstruct.t_con{iexp},inputs.exps.u{iexp}(iu,:));
                M = diag(3:-1:1,1);
                % First derivative
                uS1 = uS;
                uS1.coefs = uS1.coefs*M;

                % Second derivative
                uS2 = uS1;
                uS2.coefs = uS2.coefs*M;
                
                              
                penalty_uttReg=penalty_uttReg+inputs.IOCsol.uttReg*trapz(privstruct.t_con{iexp},ppval(uS2,privstruct.t_con{iexp}).^2);
                end
       
                case {'linearf','linear'}
                    penalty_uttReg=0;
                for iu=1:inputs.model.n_stimulus   
                uS=spline(privstruct.t_con{iexp},inputs.exps.u{iexp}(iu,:));
                
                M = diag(3:-1:1,1);
                % First derivative
                uS1 = uS;
                uS1.coefs = uS1.coefs*M;

                % Second derivative
                uS2 = uS1;
                uS2.coefs = uS2.coefs*M;
                
%                 plot(privstruct.t_con{iexp},inputs.exps.u{iexp}(iu,:),'o')
%                 hold on
%                 plot(privstruct.t_con{iexp},ppval(uS,privstruct.t_con{iexp}),'r')
%                 hold on
%                 plot(privstruct.t_con{iexp},ppval(uS2,privstruct.t_con{iexp}),'b')
%                 pause
                 penalty_uttReg=penalty_uttReg+inputs.IOCsol.uttReg*trapz(privstruct.t_con{iexp},ppval(uS2,privstruct.t_con{iexp}).^2); 
                end

              end
                
              
               fregexp(iexp)=fregexp(iexp)+inputs.IOCsol.uttReg*penalty_uttReg; %%CHANGED BY NIKOS 15/10/2018 from 'f' to 'fregexp(iexp)'
            end
            
            
        
            end %iexp=1:inputs.n_exp
            
            f=nf+sum(fregexp);  %%ADDED BY NIKOS 15/10/2018

        
return