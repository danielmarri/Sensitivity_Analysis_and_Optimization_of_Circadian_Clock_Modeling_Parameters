% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_local_rank.m 770 2013-08-06 09:41:45Z attila $
function [results]= AMIGO_local_rank(inputs,results);
% AMIGO_local_rank: Computes local ranking of unknowns
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
%  AMIGO_local_rank:  computes the ranking of unknowns for a given value of   %
%                     the unknowns (inputs.par /inputs.exp_y0)                %
%                     sums up information coming from all observables and     %
%                     all experimental schemes                                %
%                                                                             %
%                     It should be noted that for the overall rank is only    %
%                     computed for global unknowns. The information by        %
%                     experiments must be used to asses influence of local    %
%                     unknowns                                                %
%                                                                             %
%                     Absolute and relative values are provided               %                   
%                                                                             %
%                     See formulae and further details in:                    %
%                     Balsa-Canto E., Alonso A.A. and Banga J.R.              %
%                     An optimal identification procedure for model           %
%                     identification in systems biology. Applications in      %
%                     cell signalling. In: Algower & Reuss (Eds.)             %
%                     Foundations of Systems Biology in Engineering (2007)    %
%*****************************************************************************%


%-----------------------------------------------------------------------------
% OVERALL RANKING OF (GLOBAL) PARAMETERS

d_msqr=zeros(inputs.PEsol.n_global_theta,1);
d_mabs=zeros(inputs.PEsol.n_global_theta,1);
d_mean=zeros(inputs.PEsol.n_global_theta,1);
d_max=results.rank.rank_mat{1}(1:inputs.PEsol.n_global_theta,4);
d_min=results.rank.rank_mat{1}(1:inputs.PEsol.n_global_theta,5);
r_d_msqr=zeros(inputs.PEsol.n_global_theta,1);
r_d_mabs=zeros(inputs.PEsol.n_global_theta,1);
r_d_mean=zeros(inputs.PEsol.n_global_theta,1);
r_d_max=results.rank.r_rank_mat{1}(1:inputs.PEsol.n_global_theta,4);
r_d_min=results.rank.r_rank_mat{1}(1:inputs.PEsol.n_global_theta,5);



% SUMS UP THE INFORMATION FOR THE DIFFERENT EXPERIMENTS

for iexp=1:inputs.exps.n_exp
 
d_msqr=d_msqr+results.rank.rank_mat{iexp}(1:inputs.PEsol.n_global_theta,1);
r_d_msqr=r_d_msqr+results.rank.r_rank_mat{iexp}(1:inputs.PEsol.n_global_theta,1);

d_mabs=d_mabs+results.rank.rank_mat{iexp}(1:inputs.PEsol.n_global_theta,2);
r_d_mabs=r_d_mabs+results.rank.r_rank_mat{iexp}(1:inputs.PEsol.n_global_theta,2);

d_mean=d_mean+results.rank.rank_mat{iexp}(1:inputs.PEsol.n_global_theta,3);
r_d_mean=r_d_mean+results.rank.r_rank_mat{iexp}(1:inputs.PEsol.n_global_theta,3);
end
for iexp=2:inputs.exps.n_exp
d_max=[d_max results.rank.rank_mat{iexp}(1:inputs.PEsol.n_global_theta,4)];
r_d_max=[r_d_max results.rank.r_rank_mat{iexp}(1:inputs.PEsol.n_global_theta,4)];

d_min=[d_min results.rank.rank_mat{iexp}(1:inputs.PEsol.n_global_theta,5)];
r_d_min=[r_d_min results.rank.r_rank_mat{iexp}(1:inputs.PEsol.n_global_theta,5)];
end


 over_d_msqr=d_msqr./inputs.exps.n_exp;
 over_d_mean=d_mean./inputs.exps.n_exp;
 over_d_mabs=d_mabs./inputs.exps.n_exp;
 over_d_max=max(d_max')';
 over_d_min=min(d_min')';
 
 
 
 r_over_d_msqr=r_d_msqr./inputs.exps.n_exp;
 r_over_d_mean=r_d_mean./inputs.exps.n_exp;
 r_over_d_mabs=r_d_mabs./inputs.exps.n_exp;
 r_over_d_max=max(r_d_max')';
 r_over_d_min=min(r_d_min')';
 

 
% OBTAINS ABSOULUTE RANKING OF PARAMETER UNKNOWNS IN D_MSQR DECREASING ORDER
 [dummy,over_d_msqr_par_index]=sort(-over_d_msqr(1:inputs.PEsol.n_global_theta));
 results.rank.over_par_rank_index=reshape(over_d_msqr_par_index,inputs.PEsol.n_global_theta,1);
 
 
results.rank.sorted_over_par_rank_mat(:,1)=over_d_msqr(results.rank.over_par_rank_index);
results.rank.sorted_over_par_rank_mat(:,2)=over_d_mabs(results.rank.over_par_rank_index);
results.rank.sorted_over_par_rank_mat(:,3)=over_d_mean(results.rank.over_par_rank_index);
results.rank.sorted_over_par_rank_mat(:,4)=over_d_max(results.rank.over_par_rank_index);
results.rank.sorted_over_par_rank_mat(:,5)=over_d_min(results.rank.over_par_rank_index);
 

% OBTAINS RELATIVE RANKING OF PARAMETER UNKNOWNS IN D_MSQR DECREASING ORDER
 [dummy,r_over_d_msqr_par_index]=sort(-r_over_d_msqr(1:inputs.PEsol.n_global_theta));
results.rank.r_over_par_rank_index=reshape(r_over_d_msqr_par_index,inputs.PEsol.n_global_theta,1);
 
 
results.rank.r_sorted_over_par_rank_mat(:,1)=r_over_d_msqr(results.rank.r_over_par_rank_index);
results.rank.r_sorted_over_par_rank_mat(:,2)=r_over_d_mabs(results.rank.r_over_par_rank_index);
results.rank.r_sorted_over_par_rank_mat(:,3)=r_over_d_mean(results.rank.r_over_par_rank_index);
results.rank.r_sorted_over_par_rank_mat(:,4)=r_over_d_max(results.rank.r_over_par_rank_index);
results.rank.r_sorted_over_par_rank_mat(:,5)=r_over_d_min(results.rank.r_over_par_rank_index);
 
%-----------------------------------------------------------------------------
% OVERALL RANKING OF (GLOBAL) INITIAL CONDITIONS


  if inputs.PEsol.n_global_theta_y0>0
           
        clear d_msqr d_mabs d_mean d_max d_min;
        clear r_d_msqr r_d_mabs r_d_mean r_d_max r_d_min;
  
        d_msqr=zeros(inputs.PEsol.n_global_theta_y0,1);
        d_mabs=zeros(inputs.PEsol.n_global_theta_y0,1);
        d_mean=zeros(inputs.PEsol.n_global_theta_y0,1);
        d_max=results.rank.rank_mat{1}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,4);
        d_min=results.rank.rank_mat{1}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,5);
        r_d_msqr=zeros(inputs.PEsol.n_global_theta_y0,1);
        r_d_mabs=zeros(inputs.PEsol.n_global_theta_y0,1);
        r_d_mean=zeros(inputs.PEsol.n_global_theta_y0,1);
        r_d_max=results.rank.r_rank_mat{1}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,4);
        r_d_min=results.rank.r_rank_mat{1}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,5);     
           
           
        for iexp=1:inputs.exps.n_exp
        d_msqr=d_msqr+results.rank.rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,1);
        r_d_msqr=r_d_msqr+results.rank.r_rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,1);

        d_mabs=d_mabs+results.rank.rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,2);
        r_d_mabs=r_d_mabs+results.rank.r_rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,2);

        d_mean=d_mean+results.rank.rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,3);
        r_d_mean=r_d_mean+results.rank.r_rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,3);
        end
        for iexp=2:inputs.exps.n_exp
        d_max=[d_max results.rank.rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,4)];
        r_d_max=[r_d_max results.rank.r_rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,4)];

        d_min=[d_min results.rank.rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,5)];
        r_d_min=[r_d_min results.rank.r_rank_mat{iexp}(inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0,5)];
        end

        over_d_msqr=d_msqr./inputs.exps.n_exp;
        over_d_mean=d_mean./inputs.exps.n_exp;
        over_d_mabs=d_mabs./inputs.exps.n_exp;
        over_d_max=max(d_max')';
        over_d_min=min(d_min')';
 
        r_over_d_msqr=r_d_msqr./inputs.exps.n_exp;
        r_over_d_mean=r_d_mean./inputs.exps.n_exp;
        r_over_d_mabs=r_d_mabs./inputs.exps.n_exp;
        r_over_d_max=max(r_d_max')';
        r_over_d_min=min(r_d_min')';
 

 
% OBTAINS ABSOULUTE RANKING OF UNKNOWNS IN D_MSQR DECREASING ORDER


        [dummy,over_d_msqr_y0_index]=sort(-over_d_msqr);
        results.rank.over_y0_rank_index=reshape(over_d_msqr_y0_index,inputs.PEsol.n_global_theta_y0,1);
  
        results.rank.sorted_over_y0_rank_mat(:,1)=over_d_msqr(results.rank.over_y0_rank_index);
        results.rank.sorted_over_y0_rank_mat(:,2)=over_d_mabs(results.rank.over_y0_rank_index);
        results.rank.sorted_over_y0_rank_mat(:,3)=over_d_mean(results.rank.over_y0_rank_index);
        results.rank.sorted_over_y0_rank_mat(:,4)=over_d_max(results.rank.over_y0_rank_index);
        results.rank.sorted_over_y0_rank_mat(:,5)=over_d_min(results.rank.over_y0_rank_index);
 

% OBTAINS RELATIVE RANKING OF UNKNOWNS IN D_MSQR DECREASING ORDER
        [dummy,r_over_d_msqr_y0_index]=sort(-r_over_d_msqr);
        results.rank.r_over_y0_rank_index=reshape(r_over_d_msqr_y0_index,inputs.PEsol.n_global_theta_y0,1);
 
 
        results.rank.r_sorted_over_y0_rank_mat(:,1)=r_over_d_msqr(results.rank.r_over_y0_rank_index);
        results.rank.r_sorted_over_y0_rank_mat(:,2)=r_over_d_mabs(results.rank.r_over_y0_rank_index);
        results.rank.r_sorted_over_y0_rank_mat(:,3)=r_over_d_mean(results.rank.r_over_y0_rank_index);
        results.rank.r_sorted_over_y0_rank_mat(:,4)=r_over_d_max(results.rank.r_over_y0_rank_index);
        results.rank.r_sorted_over_y0_rank_mat(:,5)=r_over_d_min(results.rank.r_over_y0_rank_index);
 
    end % if inputs.PEsol.n_global_theta_y0>0

    
          
return