% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_ranking_mats.m 1449 2014-05-08 16:20:13Z davidh $
function [r_par_rank_index,r_rank_mat,r_sorted_rank_mat,r_senst,par_rank_index,rank_mat,sorted_rank_mat,senst]=...
    AMIGO_ranking_mats(inputs,results,privstruct)


% RANKING OF PARAMETERS

%  Memory allocation: Overall rank

n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
d_msqr_mat2=zeros(1,1,n_theta);
d_msqr_mat=zeros(1,1,n_theta);
d_mabs_mat=zeros(1,1,n_theta);
d_mean_mat=zeros(1,1,n_theta);
r_d_msqr_mat2=zeros(1,1,n_theta);
r_d_msqr_mat=zeros(1,1,n_theta);
r_d_mabs_mat=zeros(1,1,n_theta);
r_d_mean_mat=zeros(1,1,n_theta);

if inputs.exps.n_obs{1}==1
    if inputs.exps.n_s{1}==1
        d_max_mat=privstruct.sens_t{1};
        d_min_mat=privstruct.sens_t{1};
        r_d_max_mat=privstruct.r_sens_t{1};
        r_d_min_mat=privstruct.r_sens_t{1};
    else
        d_max_mat=max(privstruct.sens_t{1});
        d_min_mat=min(privstruct.sens_t{1});
        r_d_max_mat=max(privstruct.r_sens_t{1});
        r_d_min_mat=min(privstruct.r_sens_t{1});
    end
end

if inputs.exps.n_obs{1}>1
    if inputs.exps.n_s{1}==1
        d_max_mat=max(privstruct.sens_t{1});
        d_min_mat=min(privstruct.sens_t{1});
        r_d_max_mat=max(privstruct.r_sens_t{1});
        r_d_min_mat=min(privstruct.r_sens_t{1});
    else
        d_max_mat=max(max(privstruct.sens_t{1}));
        d_min_mat=min(min(privstruct.sens_t{1}));
        r_d_max_mat=max(max(privstruct.sens_t{1}));
        r_d_min_mat=min(min(privstruct.sens_t{1}));
    end
end



for iexp=1:inputs.exps.n_exp
    
    n_m_reduced=size(privstruct.row_yms_0{iexp},2);
    

    % d_msqr
    d_msqr_mat2=d_msqr_mat2+sum(sum(privstruct.sens_t{iexp}.^2,2),1)/(inputs.exps.n_obs{iexp}^2*inputs.exps.n_s{iexp}^2);
    % d_mabs
    d_mabs_mat=d_mabs_mat+sum(sum(abs(privstruct.sens_t{iexp}),2),1)/(inputs.exps.n_obs{iexp}*inputs.exps.n_s{iexp});
    % d_mean
    d_mean_mat=d_mean_mat+sum(sum(privstruct.sens_t{iexp},2),1)/(inputs.exps.n_obs{iexp}*inputs.exps.n_s{iexp});
    % d_max / d_min
    
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
    
    
end     % for iexp=1:inputs.exps.n_exp

d_msqr_mat=sqrt(d_msqr_mat2);

% Transforms 3D matrix to vectors and normalices by the number of
% experiments

d_msqr=reshape(d_msqr_mat,n_theta,1)./inputs.exps.n_exp;
d_mabs=reshape(d_mabs_mat,n_theta,1)./inputs.exps.n_exp;
d_mean=reshape(d_mean_mat,n_theta,1)./inputs.exps.n_exp;
d_max=reshape(d_max_mat,n_theta,1)./inputs.exps.n_exp;
d_min=reshape(d_min_mat,n_theta,1)./inputs.exps.n_exp;

rank_mat(:,1)=d_msqr;
rank_mat(:,2)=d_mabs;
rank_mat(:,3)=d_mean;
rank_mat(:,4)=d_max;
rank_mat(:,5)=d_min;


% OBTAINS RANKING IN D_MSQR DECREASING ORDER
[dummy,d_msqr_index]=sort(-d_msqr);
par_rank_index=reshape(d_msqr_index,n_theta,1);

sorted_rank_mat(:,1)=d_msqr(par_rank_index);
sorted_rank_mat(:,2)=d_mabs(par_rank_index);
sorted_rank_mat(:,3)=d_mean(par_rank_index);
sorted_rank_mat(:,4)=d_max(par_rank_index);
sorted_rank_mat(:,5)=d_min(par_rank_index);

senst=privstruct.sens_t;



r_d_msqr_mat=sqrt(r_d_msqr_mat2);
r_d_msqr=reshape(r_d_msqr_mat,n_theta,1)./inputs.exps.n_exp;
r_d_mabs=reshape(r_d_mabs_mat,n_theta,1)./inputs.exps.n_exp;
r_d_mean=reshape(r_d_mean_mat,n_theta,1)./inputs.exps.n_exp;
r_d_max=reshape(r_d_max_mat,n_theta,1)./inputs.exps.n_exp;
r_d_min=reshape(r_d_min_mat,n_theta,1)./inputs.exps.n_exp;

r_rank_mat(:,1)=r_d_msqr;
r_rank_mat(:,2)=r_d_mabs;
r_rank_mat(:,3)=r_d_mean;
r_rank_mat(:,4)=r_d_max;
r_rank_mat(:,5)=r_d_min;

% OBTAINS RANKING IN R_D_MSQR DECREASING ORDER

[dummy,r_d_msqr_index]=sort(-r_d_msqr);
r_par_rank_index=reshape(r_d_msqr_index,n_theta,1);

r_sorted_rank_mat(:,1)=r_d_msqr(r_par_rank_index);
r_sorted_rank_mat(:,2)=r_d_mabs(r_par_rank_index);
r_sorted_rank_mat(:,3)=r_d_mean(r_par_rank_index);
r_sorted_rank_mat(:,4)=r_d_max(r_par_rank_index);
r_sorted_rank_mat(:,5)=r_d_min(r_par_rank_index);


r_senst=privstruct.r_sens_t;


return