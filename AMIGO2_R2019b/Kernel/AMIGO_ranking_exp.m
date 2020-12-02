% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_ranking_exp.m 770 2013-08-06 09:41:45Z attila $
function  [r_par_rank_index,r_y0_rank_index,r_rank_mat,r_sorted_par_rank_mat,r_sorted_y0_rank_mat,...
          par_rank_index,y0_rank_index,rank_mat,sorted_par_rank_mat,sorted_y0_rank_mat]= ...
          AMIGO_ranking_exp(inputs,results,privstruct,iexp);

% AMIGO_ranking_exp: Computes ranking of unknowns for a given experiment iexp 
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
%  AMIGO_ranking_exp: computes the ranking of unknowns (parameters &          %
%                     initial conditions for a given experimental scheme      %
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


%  Memory allocation: Overall rank

 n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
 n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};
 ndim_theta=n_theta+n_theta_y0;
 
 d_msqr_mat2=zeros(1,1,ndim_theta);
 d_msqr_mat=zeros(1,1,ndim_theta);
 d_mabs_mat=zeros(1,1,ndim_theta);
 d_mean_mat=zeros(1,1,ndim_theta);
 d_max_mat=-1.0e-30.*ones(1,1,ndim_theta);
 d_min_mat=1.0e30.*ones(1,1,ndim_theta);
 r_d_msqr_mat2=zeros(1,1,ndim_theta);
 r_d_msqr_mat=zeros(1,1,ndim_theta);
 r_d_mabs_mat=zeros(1,1,ndim_theta);
 r_d_mean_mat=zeros(1,1,ndim_theta);
 r_d_max_mat=-1.0e-30.*ones(1,1,ndim_theta);
 r_d_min_mat=1.0e30.*ones(1,1,ndim_theta);
 
 sorted_y0_rank_mat=zeros(n_theta_y0,5);
 r_sorted_y0_rank_mat=zeros(n_theta_y0,5);
 y0_rank_index=zeros(n_theta_y0);
 r_y0_rank_index=zeros(n_theta_y0);
 
% RANKING OF PARAMETERS
  
  n_m_reduced=size(privstruct.row_yms_0{iexp},2);

  
% SUMS UP ALL INFORMATION FOR ALL PARAMETERS AND INITIAL CONDITIONS  

% d_msqr_mat
   d_msqr_mat2=d_msqr_mat2+sum(sum(privstruct.sens_t{iexp}.^2,2),1)/(inputs.exps.n_obs{iexp}^2*inputs.exps.n_s{iexp}^2);
% d_mabs_mat
   d_mabs_mat=d_mabs_mat+sum(sum(abs(privstruct.sens_t{iexp}),2),1)/(inputs.exps.n_obs{iexp}*inputs.exps.n_s{iexp});
% d_mean_mat
   d_mean_mat=d_mean_mat+sum(sum(privstruct.sens_t{iexp},2),1)/(inputs.exps.n_obs{iexp}*inputs.exps.n_s{iexp});
% d_max_mat / d_min_mat
  

   if inputs.exps.n_obs{iexp}==1 
       
       if inputs.exps.n_s{iexp}==1
        d_max_mat=max([d_max_mat privstruct.sens_t{iexp}]);
        d_min_mat=max([d_min_mat privstruct.sens_t{iexp}]);
       else
        d_max_mat=max([d_max_mat max(privstruct.sens_t{iexp})]);  
        d_min_mat=min([d_min_mat min(privstruct.sens_t{iexp})]);    
       end
   end

   if inputs.exps.n_obs{iexp}>1 
       if inputs.exps.n_s{iexp}==1
        d_max_mat=max([d_max_mat max(privstruct.sens_t{iexp})]);  
        d_min_mat=min([d_min_mat min(privstruct.sens_t{iexp})]);
       else
        d_max_mat=max([d_max_mat max(max(privstruct.sens_t{iexp}))]);
        d_min_mat=min([d_min_mat min(min(privstruct.sens_t{iexp}))]);
       end
   end
  
   
 % Relative coeficients
   if(n_m_reduced>0)
    r_d_msqr_mat2=r_d_msqr_mat2+sum(sum(privstruct.r_sens_t{iexp}.^2,2),1)/(inputs.exps.n_obs{iexp}^2*n_m_reduced^2);
    r_d_mabs_mat=r_d_mabs_mat+sum(sum(abs(privstruct.r_sens_t{iexp}),2),1)/(inputs.exps.n_obs{iexp}*n_m_reduced); 
    r_d_mean_mat=r_d_mean_mat+sum(sum(privstruct.r_sens_t{iexp},2),1)/(inputs.exps.n_obs{iexp}*n_m_reduced);
    
   if inputs.exps.n_obs{iexp}==1 
       
       if inputs.exps.n_s{iexp}==1
        r_d_max_mat=max([r_d_max_mat privstruct.r_sens_t{iexp}]);
        r_d_min_mat=max([r_d_min_mat privstruct.r_sens_t{iexp}]);
       else
        r_d_max_mat=max([r_d_max_mat max(privstruct.r_sens_t{iexp})]);  
        r_d_min_mat=min([r_d_min_mat min(privstruct.r_sens_t{iexp})]);    
       end
   end

   if inputs.exps.n_obs{iexp}>1 
       if inputs.exps.n_s{iexp}==1
        r_d_max_mat=max([r_d_max_mat max(privstruct.r_sens_t{iexp})]);  
        r_d_min_mat=min([r_d_min_mat min(privstruct.r_sens_t{iexp})]);
       else
        r_d_max_mat=max([d_max_mat max(max(privstruct.r_sens_t{iexp}))]);
        r_d_min_mat=min([d_min_mat min(min(privstruct.r_sens_t{iexp}))]);
       end
   end
   else
   fprintf(1,'>>> Relative ranking may not be calculated one or more observables are zero over time.')    
   fprintf(1,'>>> All coeficients are made zero.') 
   end

%
% ABSOLUTE RANKING 
%

% Transforms 3D matrix to vectors 

d_msqr=reshape(sqrt(d_msqr_mat2),ndim_theta,1);
d_mabs=reshape(d_mabs_mat,ndim_theta,1);
d_mean=reshape(d_mean_mat,ndim_theta,1);
d_max=reshape(d_max_mat,ndim_theta,1);
d_min=reshape(d_min_mat,ndim_theta,1);

rank_mat(:,1)=d_msqr;
rank_mat(:,2)=d_mabs;
rank_mat(:,3)=d_mean;
rank_mat(:,4)=d_max;
rank_mat(:,5)=d_min;


% OBTAINS RANKING OF PARAMETERS IN D_MSQR DECREASING ORDER
[dummy,d_msqr_par_index]=sort(-d_msqr(1:n_theta));
par_rank_index=reshape(d_msqr_par_index,n_theta,1);

sorted_par_rank_mat(:,1)=d_msqr(par_rank_index);
sorted_par_rank_mat(:,2)=d_mabs(par_rank_index);
sorted_par_rank_mat(:,3)=d_mean(par_rank_index);
sorted_par_rank_mat(:,4)=d_max(par_rank_index);
sorted_par_rank_mat(:,5)=d_min(par_rank_index);


% OBTAINS RANKING OF INITIAL CONDITIONS IN D_MSQR DECREASING ORDER




if n_theta_y0>0
[dummy,d_msqr_y0_index]=sort(-d_msqr(n_theta+1:ndim_theta));

y0_rank_index=reshape(d_msqr_y0_index,n_theta_y0,1);
sorted_y0_rank_mat(:,1)=d_msqr(n_theta.*ones(n_theta_y0,1)+y0_rank_index);
sorted_y0_rank_mat(:,2)=d_mabs(n_theta.*ones(n_theta_y0,1)+y0_rank_index);
sorted_y0_rank_mat(:,3)=d_mean(n_theta.*ones(n_theta_y0,1)+y0_rank_index);
sorted_y0_rank_mat(:,4)=d_max(n_theta.*ones(n_theta_y0,1)+y0_rank_index);
sorted_y0_rank_mat(:,5)=d_min(n_theta.*ones(n_theta_y0,1)+y0_rank_index);
    
end    

senst=privstruct.sens_t{iexp};

%
% RELATIVE RANKING
%

% Transforms 3D matrix to vectors 

r_d_msqr=reshape(sqrt(r_d_msqr_mat2),ndim_theta,1);
r_d_mabs=reshape(r_d_mabs_mat,ndim_theta,1);
r_d_mean=reshape(r_d_mean_mat,ndim_theta,1);
r_d_max=reshape(r_d_max_mat,ndim_theta,1);
r_d_min=reshape(r_d_min_mat,ndim_theta,1);

r_rank_mat(:,1)=r_d_msqr;
r_rank_mat(:,2)=r_d_mabs;
r_rank_mat(:,3)=r_d_mean;
r_rank_mat(:,4)=r_d_max;
r_rank_mat(:,5)=r_d_min;

% OBTAINS RANKING OF PARAMETERS IN D_MSQR DECREASING ORDER
[dummy,r_d_msqr_par_index]=sort(-r_d_msqr(1:n_theta));
r_par_rank_index=reshape(r_d_msqr_par_index,n_theta,1);

r_sorted_par_rank_mat(:,1)=r_d_msqr(r_par_rank_index);
r_sorted_par_rank_mat(:,2)=r_d_mabs(r_par_rank_index);
r_sorted_par_rank_mat(:,3)=r_d_mean(r_par_rank_index);
r_sorted_par_rank_mat(:,4)=r_d_max(r_par_rank_index);
r_sorted_par_rank_mat(:,5)=r_d_min(r_par_rank_index);

% OBTAINS RANKING OF INITIAL CONDITIONS IN D_MSQR DECREASING ORDER

if n_theta_y0>0
[dummy,r_d_msqr_y0_index]=sort(-r_d_msqr(n_theta+1:ndim_theta));
r_y0_rank_index=reshape(r_d_msqr_y0_index,n_theta_y0,1);

r_sorted_y0_rank_mat(:,1)=r_d_msqr(n_theta.*ones(n_theta_y0,1)+r_y0_rank_index);
r_sorted_y0_rank_mat(:,2)=r_d_mabs(n_theta.*ones(n_theta_y0,1)+r_y0_rank_index);
r_sorted_y0_rank_mat(:,3)=r_d_mean(n_theta.*ones(n_theta_y0,1)+r_y0_rank_index);
r_sorted_y0_rank_mat(:,4)=r_d_max(n_theta.*ones(n_theta_y0,1)+r_y0_rank_index);
r_sorted_y0_rank_mat(:,5)=r_d_min(n_theta.*ones(n_theta_y0,1)+r_y0_rank_index);
end    


return