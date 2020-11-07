% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_CramerRao.m 2495 2016-03-01 14:28:54Z evabalsa $
function [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,ini_exp,fin_exp)
% AMIGO_CramerRao: confidence intervals by Cramer-Rao inequality
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
%  AMIGO_CramerRao: computes the Fisher Information Matrix and the            %
%                   the correlation matrix through the Cramer-Rao             %
%                   approximation                                             %
%                   The Fisher Information Matrix is based on the expected    %
%                   value: E{dJ/dtheta_i dJ/dthetaj}, where J corresponds     %
%                   either to the lsq or the llk functions. All subcases will %
%                   be considered :                                           %
%                   lsq: Q_I and Q_expmax                                     %
%                   llk: homo, homo_var and hetero                            %
%                                                                             %
%                   For the case of estimating local parameters or initial    %
%                   conditions a FIM matrix will be computed for every        %
%                   experiment, to enable the analysis of the correlation     %
%                   between pairs of global and local unknowns and to compute %
%                   Cramer-Rao confidence intervals for local unknowns        %
%*****************************************************************************%

global n_amigo_sim_success;
global n_amigo_sim_failed;
global n_amigo_sens_success;
global n_amigo_sens_failed;

cont_istate=0;
privstruct.conf_intervals=0;

%CALCULATES PARAMETRIC SENSITIVITIES
privstruct=AMIGO_transform_theta(inputs,results,privstruct);
h=[];
hobs=[];

for iexp=ini_exp:fin_exp
    results.fit.obs_cov_mat{iexp}=[];
    results.fit.obs_conf_mat{iexp}=[];
end
flag_fixed=0;

nt_gtheta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
nt_ltheta=nt_gtheta;

switch inputs.model.exe_type
    
    case 'standard'
        
        for iexp=ini_exp:fin_exp
     
            if strcmp(inputs.exps.exp_type{iexp},'fixed')
                [results,privstruct]=AMIGO_sens(inputs,results,privstruct,iexp);
            else
                
                privstruct.t_int{iexp}=privstruct.t_s{iexp};
                [results,privstruct]=AMIGO_sens(inputs,results,privstruct,iexp);
                
            end %if size(strcat(inputs.exps.exp_y0_t....
            
            if privstruct.istate_sens<0
                privstruct.conf_intervals=0;
                results.fit.g_FIM=[];
                results.fit.g_corr_mat=[];
                results.fit.g_var_cov_mat=[];
                privstruct.h_constraints=[];
                return
            end
        end %for iexp=ini_exp:fin_exp
        
    case {'costMex','fullMex'}
        
        if inputs.PEsol.n_global_theta_y0>0
            error('Cannot run AMIGO_CrammerRao in costMex or fullMex with global initial conditions.')
        end
        
        inputs.model.par=privstruct.par{1};
        inputs.exps.exp_y0=privstruct.y_0;
        
        privstruct.istate_sens=1;
        feval(inputs.model.mexfunction,'sens_FSA_CVODES');
        
        for iexp=ini_exp:fin_exp
            
            if(outputs.success{iexp})
                
                privstruct.istate_sens=1;
                n_amigo_sim_success=n_amigo_sim_success+1;
                n_amigo_sens_success=n_amigo_sens_success+1;
            else
                privstruct.count_failed_sens=privstruct.count_failed_sens+1;
                n_amigo_sens_failed=n_amigo_sens_failed+1;
                n_amigo_sim_failed=n_amigo_sim_failed+1;
                
            end
            
        end
        
        
        
        for iexp=ini_exp:fin_exp

            try
                for ipar=1:nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                    privstruct.sens_t{iexp}(:,:,ipar)=feval(inputs.pathd.obs_function,outputs.sensitivities{iexp}(:,:,ipar),inputs,privstruct.par{iexp},iexp);
                    
                end
                
            catch e1
                try
                    for ipar=1:inputs.PEsol.n_theta
                        warning('AMIGO_sens: Not observation function found. Tryign index_observables');
                         privstruct.sens_t{iexp}(:,:,ipar)=outputs.sensitivities{iexp}(:,inputs.exps.index_observables{iexp},ipar);
                    end
                    
                catch e2
                    disp(e1.message);
                    disp(e2.message);
                    error('AMIGO_CrammerRao: costMex/fullMex. Something went wrong!')
                end
            end
            
            sens{iexp}=privstruct.sens_t{iexp};
            privstruct.r_sens_t{iexp}=privstruct.sens_t{iexp};
            warning('Relative sensitivities are currently not being computed in costMex mode');
            
        end
        r_sens=sens;
        
        if ~isfield(results,'sim')
            results.sim.states=outputs.simulation;
        end
end % switch inputs.model.exe_type


% EBC EVALUATES CONSTRAINTS for free exps

h=[];
hobs=[];
hts=[];
if privstruct.ntotal_constraints+privstruct.ntotal_obsconstraints+privstruct.ntotal_tsconstraints ==0
    
    h(1)=0; % It there aren't constraints there isn't constraint violation
else
    
    % It there are constraints....
    for iexp=ini_exp:fin_exp
        
        % Detect if experiment is fixed
        if  strcmp(inputs.exps.exp_type{iexp},'fixed')
            flag_fixed=1; end
        
        % For experiments to be designed
        if flag_fixed==0
            
            % Handle general constraints
            if privstruct.ntotal_constraints >0
                for iexp=ini_exp:fin_exp
                    eval(sprintf('%s',results.pathd.constraints))
                end %for iexp=ini_exp:fin_exp
                hmat=cell2mat(hh);
                h=reshape(hmat, numel(hmat),1);
            end
            
            % Handle Maximum number of observables constraint
            if inputs.OEDsol.n_obs_od>0
                for iexp=1:inputs.OEDsol.n_obs_od
                    hobs(iexp)=sum(privstruct.w_obs{inputs.OEDsol.exp_obs_od(1,iexp)})-inputs.exps.max_obs{inputs.OEDsol.exp_obs_od(1,iexp)};
                    % if ~outputs.flag{iexp}
                    %     privstruct.istate_sens=-1;    %%% EBC What is "outputs"??
                    % end
                end %for iexp=1:inputs.OEDsol.n_obs_od
            end % if inputs.OEDsol.n_obs_od>0
            
            
            % Maximum number of sampling times constraint
            
            if inputs.OEDsol.n_ts_od>0
                for iexp=1:inputs.OEDsol.n_ts_od
                    hts(iexp)=sum(privstruct.w_sampling{inputs.OEDsol.exp_ts_od(1,iexp)})-inputs.exps.max_ns{inputs.OEDsol.exp_ts_od(1,iexp)};
                end %for iexp=1:inputs.OEDsol.n_obs_od
            end % if inputs.OEDsol.n_ts_od>0
            
        end% if flag_fixed==0
        
    end %for iexp=ini_exp:fin_exp
    
end %if privstruct.ntotal_constraints+privstruct.ntotal_obsconstraints+privstruct.ntotal_tsconstraints ==0

privstruct.h_constraints=[h hobs hts];

% END of CONSTRAINTS

% FISHER INFORMATION MATRIX
privstruct.conf_intervals = 0;

if privstruct.istate_sens<0
    
    fprintf(1,'\n\n>>>> Sensitivity solver reported an integration error. \n');
    fprintf(1,'     Sorry, it was not possible to calculate sensitivities and thus FIM and confidence intervals.\n');
    pause(3)
    return
    
else
    
    % Initialize global matrix
    
    results.fit.g_FIM=zeros(nt_gtheta);
    
    
    % CALCULATES FIM MATRIX: NOTE THAT FIM WILL DEPEND ON THE SELECTION OF THE
    % LSQ OR LLK FUNCTIONS FOR PARAMETER ESTIMATION
    
    
    
    switch inputs.PEsol.PEcost_type
        
        % USER PROVIDED COST FUNCTION
        case 'user_PEcost'
            
            % FIM AND CORRELATION MAT FOR GLOBAL THETA
            
            if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                for iexp=ini_exp:fin_exp
                    ssquare{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                    dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                    sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                    r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_gtheta]);
                    
                end %iexp=1:inputs.n_exp
                % fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                [results.fit.g_corr_mat results.fit.g_var_cov_mat ]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta);
            end % if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
            
            % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
            if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                for iexp=ini_exp:fin_exp
                    %  fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                    if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                        ssquare{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                        dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                        sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                        r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                        results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                        results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                        [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta);
                    end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                end; %iexp=1:inputs.exps.n_exp
            end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
            
        case 'lsq'
            
            results.fit.g_FIM=[];
            results.fit.g_corr_mat=[];
            results.fit.g_var_cov_mat=[];
            for iexp=ini_exp:fin_exp
                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
            end
            privstruct.conf_intervals=1;
            %fprintf('WARNING:\n\tFor Least-squares problem the FIM is not computed. Choose Maximum Likelihood function inputs.PEsol.PEcost_type = ''llk''\n\n')
            
            % estimate the model variance:
            R = results.fit.R;
            s2 = R(:)'*R(:)/(numel(R)-1);
            % this value scales the inverse of the FIM to obtain the covariance matrix.
            
            
            switch inputs.PEsol.lsq_type
                
                case 'Q_mat'
                    
                    
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            ssquare{iexp}=1./inputs.PEsol.lsq_Qmat{iexp}'.^2;
                            dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                        end %iexp=1:inputs.n_exp
                        %  fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta,s2);
                    end %inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                    
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            %  fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                
                                ssquare{iexp}=1./inputs.PEsol.lsq_Qmat{iexp}'.^2;
                                dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta,s2);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                    
                    
                    
                    
                case 'Q_I'
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            ssquare{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                        end %iexp=1:inputs.n_exp
                        %  fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta,s2);
                    end %if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                    
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            % fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                ssquare{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                               results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta,s2);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                                       
                    
                case {'Q_expmax','Q_exp'}
                    
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            ssquare{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            
                            if isempty(inputs.exps.exp_data{iexp})==0
                                for i_obs=1:inputs.exps.n_obs{iexp}
                                    max_data(:,i_obs)= max(inputs.exps.exp_data{iexp}(:,i_obs)).^2;
                                end %i_obs=1:inputs.exps.n_obs{iexp}
                            else
                                for i_obs=1:inputs.exps.n_obs{iexp}
                                    max_data(:,i_obs)= max(privstruct.ms{iexp}(:,i_obs)).^2;
                                end
                            end
                          
                            ssquare{iexp}=repmat(max_data',1,inputs.exps.n_s{iexp});
                           
                        end %iexp=1:inputs.n_exp
                        %  fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta,s2);
                    end %inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                    
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            %  fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                for i_obs=1:inputs.exps.n_obs{iexp}
                                    max_data(i_obs)= max(inputs.exps.exp_data{iexp}(:,i_obs)).^2;  end;
                                ssquare{iexp}=repmat(max_data',1,inputs.exps.n_s{iexp});
                                dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta,s2);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                    
                case 'Q_expmean'
                    
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            ssquare{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            
                            if isempty(inputs.exps.exp_data{iexp})==0
                                for i_obs=1:inputs.exps.n_obs{iexp}
                                    mean_data(:,i_obs)= mean(abs(inputs.exps.exp_data{iexp}(:,i_obs))).^2;
                                end %i_obs=1:inputs.exps.n_obs{iexp}
                            else
                                for i_obs=1:inputs.exps.n_obs{iexp}
                                    mean_data(:,i_obs)= mean(abs(privstruct.ms{iexp}(:,i_obs))).^2;
                                end
                            end
                            
                            ssquare{iexp}=repmat(mean_data',1,inputs.exps.n_s{iexp});
                            
                        end %iexp=1:inputs.n_exp
                        %  fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta,s2);
                    end %inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                    
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            %  fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                for i_obs=1:inputs.exps.n_obs{iexp}
                                    mean_data(i_obs)= mean(abs(inputs.exps.exp_data{iexp}(:,i_obs))).^2;  end;
                                ssquare{iexp}=repmat(mean_data',1,inputs.exps.n_s{iexp});
                                dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta,s2);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                  case 'Q_mat_obs'
                      % TO DO ----
                      results.fit.g_var_cov_mat=zeros(inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0);  
                      results.fit.g_corr_mat=zeros(inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0);  
                otherwise
                    error('no such LS cost function option.');
            end %switch inputs.PEsol.lsq_type
            
        case 'llk'
            
            privstruct.conf_intervals=1;
            switch inputs.PEsol.llk_type
                
                case 'homo'
                    
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        
                        for iexp=ini_exp:fin_exp
                            
                            if isempty(inputs.exps.error_data{iexp})
                                if inputs.exps.n_s{iexp}>1
                                    error_data{iexp}=repmat(max(abs(privstruct.ms{iexp})).*inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                                else
                                    error_data{iexp}=repmat(abs(privstruct.ms{iexp}).*inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                                end
                            else
                                error_data{iexp}=inputs.exps.error_data{iexp};
                            end
                            
                            ssquare{iexp}=(error_data{iexp}.^2)';
                            
                            dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_gtheta]);
                        end %iexp=1:inputs.n_exp
                        
                        %   fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta);
                    end %inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                    
                    
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            %    fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                std_dev{iexp}=inputs.exps.std_dev{iexp}*ones(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
                                for is=1:inputs.exps.n_s{iexp}
                                    error_data{iexp}(is,:)= max(abs(privstruct.ms{iexp})).*std_dev{iexp}(is,:);
                                end
                                ssquare{iexp}=(error_data{iexp}.^2)';
                                dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                    
                case 'homo_var'
                    
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            
                            if isempty(inputs.exps.error_data{iexp})
                                for iobs=1:inputs.exps.n_obs{iexp}
                                    std_dev{iexp}(:,iobs)= inputs.exps.std_dev{iexp}(iobs)*ones(inputs.exps.n_s{iexp},1);
                                end
                                for is=1:inputs.exps.n_s{iexp}
                                    error_data{iexp}(is,:)= max(abs(privstruct.ms{iexp})).*std_dev{iexp}(is,:);
                                end
                                
                                ssquare{iexp}=(error_data{iexp}.^2)';
                            else
                                ssquare{iexp}=(inputs.exps.error_data{iexp}.^2)';
                            end
                            dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_gtheta]);
                            
                            
                        end %iexp=1:inputs.n_exp
                        
                        
                        %   fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta);
                    end
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            %   fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                ssquare{iexp}=(inputs.exps.error_data{iexp}.^2)';
                                dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end %iexp=1:inputs.exps.n_exp
                    end %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                case 'hetero_proportional'
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            ssquare{iexp}=(privstruct.ms{iexp}.^2)';
                            dssdy{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_gtheta]);
                        end %iexp=1:inputs.n_exp
                        %   fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta);
                    end
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp 
                            %   fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                ssquare{iexp}=repmat(max_data,1,inputs.exps.n_s{iexp});
                                dssdy{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                case 'hetero'
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    
                    
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        
                        % EBC: for the case of OED, we will not have
                        % error_data for OD experiments, thus we need to generate it
                        % we assume homo_var generation
                        
                        
                        for iexp=ini_exp:fin_exp
                            
                            if strcmp(inputs.exps.exp_type{iexp},'od')
                                for iobs=1:inputs.exps.n_obs{iexp}
                                    std_dev{iexp}(:,iobs)= inputs.exps.std_dev{iexp}(iobs)*ones(inputs.exps.n_s{iexp},1);
                                end
                                for is=1:inputs.exps.n_s{iexp}
                                    inputs.exps.error_data{iexp}(is,:)= max(abs(privstruct.ms{iexp})).*std_dev{iexp}(is,:);
                                end
                            end
                            
                            ssquare{iexp}=inputs.exps.error_data{iexp}'.^2;
                            dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_gtheta]);
                        end %iexp=1:inputs.n_exp
                        %   fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        
                        
                        
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta);
                        for iexp=ini_exp:fin_exp
                            [results.fit.obs_cov_mat{iexp} results.fit.obs_conf_mat{iexp}]= AMIGO_obs_conf_mat(results.fit.g_var_cov_mat,sens{iexp},ssquare{iexp}');
                        end
                    end
                    % TODO: observables confidence that incorporates the
                    % local parameters and observables.
                    
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            %   fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
                                ssquare{iexp}=inputs.exps.error_data{iexp}'.^2;
                                dssdy{iexp}=zeros(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                    
                    
                case 'hetero_lin'
                    % FIM AND CORRELATION MAT FOR GLOBAL THETA
                    if inputs.PEsol.n_global_theta>0 || inputs.PEsol.n_global_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            
                           A=repmat(inputs.exps.stddeva{iexp}, [size(privstruct.ms{iexp},1),1]); %% MRG original A=repmat(inputs.PEsol.llk.stddeva{iexp}, [inputs.exps.n_s{iexp},1]);
                           B=repmat(inputs.exps.stddevb{iexp}, [size(privstruct.ms{iexp},1),1]); %%% MRG original B=repmat(inputs.PEsol.llk.stddevb{iexp}, [inputs.exps.n_s{iexp},1]);
                            ssquare{iexp}=(A+B.*privstruct.ms{iexp}).^2';
                            dssdy{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                            sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_gtheta]);
                            r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_gtheta]);
                        end %iexp=1:inputs.n_exp
                        %   fprintf(1,'\n\n------> Computing Correlation Matrix for Global unknowns...');
                        [results.fit.g_FIM]= AMIGO_gFIM(nt_gtheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp);
                        [results.fit.g_corr_mat,results.fit.g_var_cov_mat]= AMIGO_corr_mat(results.fit.g_FIM,nt_gtheta);
                    end
                    % FIM AND CORRELATION MAT FOR EVERY EXPERIMENT
                    if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                        for iexp=ini_exp:fin_exp
                            %   fprintf(1,'\n\n------> Computing Correlation Matrix for experiment %u...',iexp);
                            if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                                ssquare{iexp}=repmat(max_data,1,inputs.exps.n_s{iexp});
                                dssdy{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
                                sens{iexp}=privstruct.sens_t{iexp}(:,:,[1:nt_ltheta]);
                                r_sens{iexp}=privstruct.r_sens_t{iexp}(:,:,[1:nt_ltheta]);
                                results.fit.l_FIM{iexp}=AMIGO_lFIM(nt_ltheta,ssquare{iexp},sens{iexp},dssdy{iexp},inputs,privstruct,iexp);
                                results.fit.l_corr_matrix{iexp}=zeros(nt_ltheta+1);
                                [results.fit.l_corr_mat{iexp},results.fit.l_var_cov_mat{iexp}]= AMIGO_corr_mat(results.fit.l_FIM{iexp},nt_ltheta);
                            end; %if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
                        end; %iexp=1:inputs.exps.n_exp
                    end; %if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
                    
                    
            end % switch inputs.PEsol.llk_type
            
    end %   switch inputs.PEsol.PEcost_type
    
end % if privstruct.istate_sens<0~



% append the sensitivities of the states to the results:
results.fit.time = privstruct.t_s;
results.fit.sens_t=privstruct.sens_t;
results.fit.r_sens_t=privstruct.r_sens_t;

% COMPUTES THE SENSITIVITY MATRIX AND ITS CONDITION NUMBER

for iexp=ini_exp:fin_exp
    if inputs.PEsol.n_local_theta{iexp}>0 || inputs.PEsol.n_local_theta_y0{iexp}>0
      nt_ltheta=nt_gtheta+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};
    else
        nt_ltheta=nt_gtheta;
    end
 

    results.fit.SM{iexp}=reshape(sens{iexp}(1,:,:),inputs.exps.n_obs{iexp},nt_ltheta);
   % results.fit.rSM{iexp}=reshape(r_sens{iexp}(1,:,:),inputs.exps.n_obs{iexp},nt_ltheta); % relative sensitivity m.
    
    for is=2:privstruct.n_s{iexp}
        results.fit.SM{iexp}=[results.fit.SM{iexp}; reshape(sens{iexp}(is,:,:),inputs.exps.n_obs{iexp},nt_ltheta)];
   %     results.fit.rSM{iexp}=[results.fit.rSM{iexp}; reshape(r_sens{iexp}(is,:,:),inputs.exps.n_obs{iexp},nt_ltheta)];
    end
    
end

% if ~any(any(isnan(results.fit.SM)))
%
%     S=svd(results.fit.SM);
%     results.fit.condN_SM=max(S)/min(S);
%
% else
%     results.fit.condN_SM = NaN;
% end