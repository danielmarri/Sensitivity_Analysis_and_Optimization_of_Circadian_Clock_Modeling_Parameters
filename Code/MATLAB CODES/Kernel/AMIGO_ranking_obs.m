% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_ranking_obs.m 770 2013-08-06 09:41:45Z attila $
function [results]=AMIGO_ranking_obs(inputs,results,privstruct);
% AMIGO_ranking_obs: Computes ranking of unknowns for observables 
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
%  AMIGO_ranking_obs: computes the ranking of unknowns (parameters &          %
%                     initial conditions for observables considering all      %
%                     experiments together                                    %
%                     Several measures of ranking are provided:               %
%                     \delta_msqr; \delta_mabs; \delta_mean; \delta_max;      %
%                     \delta_mean                                             %
%                                                                             %
%                     See formulae and further details in:                    %
%                     Balsa-Canto E., Alonso A.A. and Banga J.R.              %
%                     An optimal identification procedure for model           %
%                     identification in systems biology. Applications in      %
%                     cell signalling. In: Algower & Reuss (Eds.)             %
%                     Foundations of Systems Biology in Engineering (2007)    %
%*****************************************************************************%
 


 % RANKING OF (GLOBAL + LOCAL) PARAMETERS
 
 
 
 for iexp=1:inputs.exps.n_exp
 n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
 n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};
 ndim_theta=n_theta+n_theta_y0;
 n_m_reduced=size(privstruct.row_yms_0{iexp},2);

 %  Memory allocation: Rank computed for observables
 d_obs_msqr_mat2{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 d_obs_msqr_mat{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 d_obs_mabs_mat{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 d_obs_mean_mat{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 r_d_obs_msqr_mat2{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 r_d_obs_msqr_mat{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 r_d_obs_mabs_mat{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 r_d_obs_mean_mat{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta);
 
 
results.rank.d_obs_par_msqr{iexp}=[]; 
results.rank.d_obs_y0_msqr{iexp}=[];
results.rank.d_obs_par_mabs{iexp}=[]; 
results.rank.d_obs_y0_mabs{iexp}=[];
results.rank.d_obs_par_mean{iexp}=[]; 
results.rank.d_obs_y0_mean{iexp}=[];
results.rank.r_d_obs_par_msqr{iexp}=[]; 
results.rank.r_d_obs_y0_msqr{iexp}=[];
results.rank.r_d_obs_par_mabs{iexp}=[]; 
results.rank.r_d_obs_y0_mabs{iexp}=[];
results.rank.r_d_obs_par_mean{iexp}=[]; 
results.rank.r_d_obs_y0_mean{iexp}=[];
  
 
if sum(sum(isnan(privstruct.sens_t{iexp})))==0 & sum(sum(isnan(privstruct.r_sens_t{iexp})))==0 
% d_msqr

   d_obs_msqr_mat2{iexp}=sum(privstruct.sens_t{iexp}(:,:,1:n_theta).^2,1)/(inputs.exps.n_s{iexp}^2);
   r_d_obs_msqr_mat2{iexp}=sum(privstruct.r_sens_t{iexp}(:,:,1:n_theta).^2,1)/(n_m_reduced^2);

   
% d_mabs
  
   d_obs_mabs_mat{iexp}=sum(abs(privstruct.sens_t{iexp}(:,:,1:n_theta)),1)/(inputs.exps.n_s{iexp});
   r_d_obs_mabs_mat{iexp}=sum(abs(privstruct.r_sens_t{iexp}(:,:,1:n_theta)),1)/(n_m_reduced);

% d_mean
   
   d_obs_mean_mat{iexp}=sum(privstruct.sens_t{iexp}(:,:,1:n_theta),1)/(inputs.exps.n_s{iexp});
   r_d_obs_mean_mat{iexp}=sum(privstruct.r_sens_t{iexp}(:,:,1:n_theta),1)/(n_m_reduced);

% Transforms 3D matrix to vectors. Ranks for observables.

   d_obs_msqr_mat{iexp}=sqrt(d_obs_msqr_mat2{iexp});
   r_d_obs_msqr_mat{iexp}=sqrt(r_d_obs_msqr_mat2{iexp});


end 
   
   results.rank.d_obs_par_msqr{iexp}=reshape(d_obs_msqr_mat{iexp},inputs.exps.n_obs{iexp},n_theta);
   results.rank.d_obs_par_mabs{iexp}=reshape(d_obs_mabs_mat{iexp},inputs.exps.n_obs{iexp},n_theta);
   results.rank.d_obs_par_mean{iexp}=reshape(d_obs_mean_mat{iexp},inputs.exps.n_obs{iexp},n_theta);

   results.rank.r_d_obs_par_msqr{iexp}=reshape(r_d_obs_msqr_mat{iexp},inputs.exps.n_obs{iexp},n_theta);
   results.rank.r_d_obs_par_mabs{iexp}=reshape(r_d_obs_mabs_mat{iexp},inputs.exps.n_obs{iexp},n_theta);
   results.rank.r_d_obs_par_mean{iexp}=reshape(r_d_obs_mean_mat{iexp},inputs.exps.n_obs{iexp},n_theta);

  
end     % for iexp=1:inputs.exps.n_exp



% RANKING OF (GLOBAL + LOCAL) INITIAL CONDITIONS
     
 if inputs.PEsol.n_theta_y0>0
     
       for iexp=1:inputs.exps.n_exp   
           
       n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
       n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};
       ndim_theta=n_theta+n_theta_y0;
       n_m_reduced=size(privstruct.row_yms_0{iexp},2);

     %  Memory allocation: Rank computed for observables
  
        d_obs_msqr_mat2_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);
        d_obs_msqr_mat_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);
        d_obs_mabs_mat_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);
        d_obs_mean_mat_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);
        r_d_obs_msqr_mat2_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);
        r_d_obs_msqr_mat_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);
        r_d_obs_mabs_mat_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);
        r_d_obs_mean_mat_y0{iexp}=zeros(1,inputs.exps.n_obs{iexp},n_theta_y0);

  
if sum(sum(isnan(privstruct.sens_t{iexp})))==0 & sum(sum(isnan(privstruct.r_sens_t{iexp})))==0       
    % d_msqr

        d_obs_msqr_mat2_y0{iexp}=sum(privstruct.sens_t{iexp}(:,:,n_theta+1:n_theta+n_theta_y0).^2,1)/(inputs.exps.n_s{iexp}^2);
        r_d_obs_msqr_mat2_y0{iexp}=sum(privstruct.r_sens_t{iexp}(:,:,n_theta+1:n_theta+n_theta_y0).^2,1)/(n_m_reduced^2);
   
   % d_mabs
  
        d_obs_mabs_mat_y0{iexp}=sum(abs(privstruct.sens_t{iexp}(:,:,n_theta+1:n_theta+n_theta_y0)),1)/(inputs.exps.n_s{iexp});
        r_d_obs_mabs_mat_y0{iexp}=sum(abs(privstruct.r_sens_t{iexp}(:,:,n_theta+1:n_theta+n_theta_y0)),1)/(n_m_reduced);

    % d_mean
   
        d_obs_mean_mat_y0{iexp}=sum(privstruct.sens_t{iexp}(:,:,n_theta+1:n_theta+n_theta_y0),1)/(inputs.exps.n_s{iexp}^2);
        r_d_obs_mean_mat_y0{iexp}=sum(privstruct.r_sens_t{iexp}(:,:,n_theta+1:n_theta+n_theta_y0),1)/(n_m_reduced^2);

    % Transforms 3D matrix to vectors. Ranks for observables.

        d_obs_msqr_mat_y0{iexp}=sqrt(d_obs_msqr_mat2_y0{iexp});
        r_d_obs_msqr_mat_y0{iexp}=sqrt(r_d_obs_msqr_mat2_y0{iexp});

end       
        results.rank.d_obs_y0_msqr{iexp}=reshape(d_obs_msqr_mat_y0{iexp},inputs.exps.n_obs{iexp},n_theta_y0);
        results.rank.d_obs_y0_mabs{iexp}=reshape(d_obs_mabs_mat_y0{iexp},inputs.exps.n_obs{iexp},n_theta_y0);
        results.rank.d_obs_y0_mean{iexp}=reshape(d_obs_mean_mat_y0{iexp},inputs.exps.n_obs{iexp},n_theta_y0);
        results.rank.r_d_obs_y0_msqr{iexp}=reshape(r_d_obs_msqr_mat_y0{iexp},inputs.exps.n_obs{iexp},n_theta_y0);
        results.rank.r_d_obs_y0_mabs{iexp}=reshape(r_d_obs_mabs_mat_y0{iexp},inputs.exps.n_obs{iexp},n_theta_y0);
        results.rank.r_d_obs_y0_mean{iexp}=reshape(r_d_obs_mean_mat_y0{iexp},inputs.exps.n_obs{iexp},n_theta_y0);

        end     % for iexp=1:inputs.exps.n_exp     
   
    end  % if n_theta_y0>0
 
     for iexp=1:inputs.exps.n_exp
     results.rank.d_obs_msqr{iexp}=[results.rank.d_obs_par_msqr{iexp} results.rank.d_obs_y0_msqr{iexp}];
     results.rank.d_obs_mabs{iexp}=[results.rank.d_obs_par_mabs{iexp} results.rank.d_obs_y0_mabs{iexp}];
     results.rank.d_obs_mean{iexp}=[results.rank.d_obs_par_mean{iexp} results.rank.d_obs_y0_mean{iexp}];
     results.rank.r_d_obs_msqr{iexp}=[results.rank.r_d_obs_par_msqr{iexp} results.rank.r_d_obs_y0_msqr{iexp}];
     results.rank.r_d_obs_mabs{iexp}=[results.rank.r_d_obs_par_mabs{iexp} results.rank.r_d_obs_y0_mabs{iexp}];
     results.rank.r_d_obs_mean{iexp}=[results.rank.r_d_obs_par_mean{iexp} results.rank.r_d_obs_y0_mean{iexp}];
 end

return