% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_GRank_LHS.m 770 2013-08-06 09:41:45Z attila $
function [results,privstruct]=AMIGO_GRank_LHS(inputs,results,privstruct)

% AMIGO_global_rank: computes the global rank of parameters
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
%  AMIGO_GRank_LHS: computes the global sensitivities and global rank of    % 
%                     parameters and initial conditions by calculating        %
%                     local sensitivities thousands (default:10000) vectors   %         
%                     parameters sampled within the feasible range.           %
%                     Sampling is performed by the Latin Hypercube Sampling   %
%                     method.                                                %
%                                                                             %
%                     Sensitivities are computed for the different:           % 
%                     - observables                                           %
%                     - experiments                                           %
%                     Global rank sums up all information                     %
%                     Absolute and relative values are provided               %  
%                                                                             %
%                     See formulae and further details in:                    %
%                     Balsa-Canto E., Alonso A.A. and Banga J.R.              %
%                     An optimal identification procedure for model           %
%                     identification in systems biology. Applications in      %
%                     cell signalling. In: Algower & Reuss (Eds.)             %
%                     Foundations of Systems Biology in Engineering (2007)    %
%*****************************************************************************%



%Memory allocation
n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+...
    inputs.PEsol.ntotal_local_theta+inputs.PEsol.ntotal_local_theta_y0;

dsamp=zeros(1,n_theta);
dsamp=(inputs.PEsol.vtheta_max-inputs.PEsol.vtheta_min)./inputs.rank.gr_samples;
sorted_pop_par=zeros(inputs.rank.gr_samples,n_theta);
pop_par=sorted_pop_par;

% Initialize sampling of parameters

for isamp=1:inputs.rank.gr_samples
  sorted_pop_par(isamp,:)=inputs.PEsol.vtheta_min+(isamp-1).*dsamp+rand(1,n_theta).*dsamp;
end
for itheta=1:n_theta
pop_par(:,itheta)=sorted_pop_par(randperm(inputs.rank.gr_samples)',itheta);
end

global_rank_mat=zeros(n_theta,5);
dummy_rank_mat=zeros(n_theta,5);
r_global_rank_mat=zeros(n_theta,5);
r_dummy_rank_mat=zeros(n_theta,5);


for iexp=1:inputs.exps.n_exp
    
n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp};   
g_d_msqr=zeros(n_theta,1);
g_d_mabs=zeros(n_theta,1);
g_d_mean=zeros(n_theta,1);
g_d_max=zeros(n_theta,1);
g_d_min=zeros(n_theta,1);

r_g_d_msqr=zeros(n_theta,1);
r_g_d_mabs=zeros(n_theta,1);
r_g_d_mean=zeros(n_theta,1);
r_g_d_max=zeros(n_theta,1);
r_g_d_min=zeros(n_theta,1);
g_d_obs_msqr_mat{iexp}=zeros(inputs.exps.n_obs{iexp},n_theta);
g_d_obs_mabs_mat{iexp}=zeros(inputs.exps.n_obs{iexp},n_theta);
g_d_obs_mean_mat{iexp}=zeros(inputs.exps.n_obs{iexp},n_theta);
g_r_d_obs_msqr_mat{iexp}=zeros(inputs.exps.n_obs{iexp},n_theta);
g_r_d_obs_mabs_mat{iexp}=zeros(inputs.exps.n_obs{iexp},n_theta);
g_r_d_obs_mean_mat{iexp}=zeros(inputs.exps.n_obs{iexp},n_theta);

end

isample=1;
ierror=1;
n_real_samples=1;
results.rank.par_obs0=[];
while isample<inputs.rank.gr_samples
    
    for ibloque=1:25
        privstruct.theta=pop_par(isample,:);  
        fprintf(1,' %u ',isample);
        privstruct=AMIGO_transform_theta(inputs,results,privstruct);
       
        for iexp=1:inputs.exps.n_exp
        [results,privstruct]=AMIGO_sens(inputs,results,privstruct,iexp);
        end
        if privstruct.istate_sens<0
        results.rank.error(ierror,:)=privstruct.theta;
        ierror=ierror+1;
        else
        [r_par_rank_index,r_rank_mat,r_sorted_rank_mat,r_senst_opt,par_rank_index,rank_mat,...
         sorted_rank_mat,senst_opt]=AMIGO_ranking_mats(inputs,results,privstruct);     

        if isnan(prod(rank_mat))==0
        g_d_msqr=g_d_msqr+rank_mat(:,1);
        g_d_mabs=g_d_mabs+rank_mat(:,2);
        g_d_mean=g_d_mean+rank_mat(:,3);
        g_d_max=g_d_max+rank_mat(:,4);    
        g_d_min=g_d_min+rank_mat(:,5);
        
        r_g_d_msqr=r_g_d_msqr+r_rank_mat(:,1);
        r_g_d_mabs=r_g_d_mabs+r_rank_mat(:,2);
        r_g_d_mean=r_g_d_mean+r_rank_mat(:,3);
        r_g_d_max=r_g_d_max+r_rank_mat(:,4);    
        r_g_d_min=r_g_d_min+r_rank_mat(:,5);
        
        n_real_samples=n_real_samples+1;
        end    
     
        
        [results]=AMIGO_ranking_obs(inputs,results,privstruct);
        
        for iexp=1:inputs.exps.n_exp
        g_d_obs_msqr_mat{iexp}=g_d_obs_msqr_mat{iexp}+results.rank.d_obs_msqr{iexp};
        g_d_obs_mabs_mat{iexp}=g_d_obs_mabs_mat{iexp}+results.rank.d_obs_mabs{iexp};
        g_d_obs_mean_mat{iexp}=g_d_obs_mean_mat{iexp}+results.rank.d_obs_mean{iexp};
        g_r_d_obs_msqr_mat{iexp}=g_r_d_obs_msqr_mat{iexp}+results.rank.r_d_obs_msqr{iexp};
        g_r_d_obs_mabs_mat{iexp}=g_r_d_obs_mabs_mat{iexp}+results.rank.r_d_obs_mabs{iexp};
        g_r_d_obs_mean_mat{iexp}=g_r_d_obs_mean_mat{iexp}+results.rank.r_d_obs_mean{iexp};  
        end
        end        
    isample=isample+1;
    end % ibloque=1:25
     fprintf('\n');
end %isample<inputs.rank.gr_samples


dummy_rank_mat=dummy_rank_mat./n_real_samples;

% OBTAINS RANKING IN D_MSQR DECREASING ORDER
g_d_msqr=g_d_msqr./n_real_samples;
g_d_mabs=g_d_mabs./n_real_samples;
g_d_mean=g_d_mean./n_real_samples;
g_d_max=g_d_max./n_real_samples;
g_d_min=g_d_min./n_real_samples;

r_g_d_msqr=r_g_d_msqr./n_real_samples;
r_g_d_mabs=r_g_d_mabs./n_real_samples;
r_g_d_mean=r_g_d_mean./n_real_samples;
r_g_d_max=r_g_d_max./n_real_samples;
r_g_d_min=r_g_d_min./n_real_samples;


results.rank.n_global_samples=n_real_samples;

% OBTAINS ABSOULUTE RANKING OF PARAMETER UNKNOWNS IN D_MSQR DECREASING ORDER

[dummy,d_msqr_par_index]=sort(-g_d_msqr(1:inputs.PEsol.n_global_theta));
[dummy,r_d_msqr_par_index]=sort(-r_g_d_msqr(1:inputs.PEsol.n_global_theta));

results.rank.global_par_rank_index=reshape(d_msqr_par_index,inputs.PEsol.n_global_theta,1);
results.rank.r_global_par_rank_index=reshape(r_d_msqr_par_index,inputs.PEsol.n_global_theta,1);

results.rank.global_par_rank_mat(:,1)=g_d_msqr(results.rank.global_par_rank_index);
results.rank.global_par_rank_mat(:,2)=g_d_mabs(results.rank.global_par_rank_index);
results.rank.global_par_rank_mat(:,3)=g_d_mean(results.rank.global_par_rank_index);
results.rank.global_par_rank_mat(:,4)=g_d_max(results.rank.global_par_rank_index);
results.rank.global_par_rank_mat(:,5)=g_d_min(results.rank.global_par_rank_index);

results.rank.r_global_par_rank_mat(:,1)=r_g_d_msqr(results.rank.r_global_par_rank_index);
results.rank.r_global_par_rank_mat(:,2)=r_g_d_mabs(results.rank.r_global_par_rank_index);
results.rank.r_global_par_rank_mat(:,3)=r_g_d_mean(results.rank.r_global_par_rank_index);
results.rank.r_global_par_rank_mat(:,4)=r_g_d_max(results.rank.r_global_par_rank_index);
results.rank.r_global_par_rank_mat(:,5)=r_g_d_min(results.rank.r_global_par_rank_index);

% OBTAINS ABSOLUTE RANKING OF UNKNOWN INITIAL CONDITIONS IN D_MSQR DECREASING ORDER

[dummy,d_msqr_y0_index]=sort(-g_d_msqr(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0));
[dummy,r_d_msqr_y0_index]=sort(-r_g_d_msqr(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0));

results.rank.global_y0_rank_index=reshape(d_msqr_y0_index,inputs.PEsol.n_global_theta_y0,1);
results.rank.r_global_y0_rank_index=reshape(r_d_msqr_y0_index,inputs.PEsol.n_global_theta_y0,1);



g_d_msqr_y0=g_d_msqr(inputs.PEsol.n_global_theta+1:n_theta,1);
g_d_mabs_y0=g_d_mabs(inputs.PEsol.n_global_theta+1:n_theta,1);
g_d_mean_y0=g_d_mean(inputs.PEsol.n_global_theta+1:n_theta,1);
g_d_max_y0=g_d_max(inputs.PEsol.n_global_theta+1:n_theta,1);
g_d_min_y0=g_d_min(inputs.PEsol.n_global_theta+1:n_theta,1);
r_g_d_msqr_y0=r_g_d_msqr(inputs.PEsol.n_global_theta+1:n_theta,1);
r_g_d_mabs_y0=r_g_d_mabs(inputs.PEsol.n_global_theta+1:n_theta,1);
r_g_d_mean_y0=r_g_d_mean(inputs.PEsol.n_global_theta+1:n_theta,1);
r_g_d_max_y0=r_g_d_max(inputs.PEsol.n_global_theta+1:n_theta,1);
r_g_d_min_y0=r_g_d_min(inputs.PEsol.n_global_theta+1:n_theta,1);

results.rank.global_y0_rank_mat(:,1)=g_d_msqr_y0(results.rank.global_y0_rank_index);
results.rank.global_y0_rank_mat(:,2)=g_d_mabs_y0(results.rank.global_y0_rank_index);
results.rank.global_y0_rank_mat(:,3)=g_d_mean_y0(results.rank.global_y0_rank_index);
results.rank.global_y0_rank_mat(:,4)=g_d_max_y0(results.rank.global_y0_rank_index);
results.rank.global_y0_rank_mat(:,5)=g_d_min_y0(results.rank.global_y0_rank_index);


results.rank.r_global_y0_rank_mat(:,1)=r_g_d_msqr_y0(results.rank.r_global_y0_rank_index);
results.rank.r_global_y0_rank_mat(:,2)=r_g_d_mabs_y0(results.rank.r_global_y0_rank_index);
results.rank.r_global_y0_rank_mat(:,3)=r_g_d_mean_y0(results.rank.r_global_y0_rank_index);
results.rank.r_global_y0_rank_mat(:,4)=r_g_d_max_y0(results.rank.r_global_y0_rank_index);
results.rank.r_global_y0_rank_mat(:,5)=r_g_d_min_y0(results.rank.r_global_y0_rank_index);

        for iexp=1:inputs.exps.n_exp
        results.rank.g_d_obs_msqr_mat{iexp}=g_d_obs_msqr_mat{iexp}./n_real_samples;
        results.rank.g_d_obs_mabs_mat{iexp}=g_d_obs_mabs_mat{iexp}./n_real_samples;
        results.rank.g_d_obs_mean_mat{iexp}=g_d_obs_mean_mat{iexp}./n_real_samples;
        results.rank.g_r_d_obs_msqr_mat{iexp}=g_r_d_obs_msqr_mat{iexp}./n_real_samples;
        results.rank.g_r_d_obs_mabs_mat{iexp}=g_r_d_obs_mabs_mat{iexp}./n_real_samples;
        results.rank.g_r_d_obs_mean_mat{iexp}=g_r_d_obs_mean_mat{iexp}./n_real_samples;
        end

return;