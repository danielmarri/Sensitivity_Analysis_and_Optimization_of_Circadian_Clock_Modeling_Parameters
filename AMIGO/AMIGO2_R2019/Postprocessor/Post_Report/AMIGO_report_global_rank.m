% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_global_rank.m 2202 2015-09-24 07:10:57Z evabalsa $
% AMIGO_report_global_rank: reports global ranking of parameters
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
%   AMIGO_report_global_rank: generates part of report devoted to the         %
%                             global rank of parameters                       %
%*****************************************************************************%

global n_amigo_sim_success;
global n_amigo_sim_failed;
global n_amigo_sens_success;
global n_amigo_sens_failed;


fid=fopen(inputs.pathd.report,'a');


fprintf(1,'\n\n------> GLOBAL RANKING\n\n');
fprintf(fid,'\n\n------> GLOBAL RANKING\n\n');

fprintf(1,'\n\n------>ABSOLUTE Ranking of GLOBAL unknown PARAMETERS:\n\n');
fprintf(fid,'\n\n------>ABSOLUTE Ranking of GLOBAL unknown PARAMETERS:\n\n');
fprintf(1,'\t\t\td_msqr\t\t d_mabs\t\t d_mean\t\t\td_max\t\t  d_min\n');
fprintf(fid,'\t\t\td_msqr\t\t d_mabs\t\t d_mean\t\t\td_max\t\t  d_min\n');

n_theta=inputs.PEsol.n_global_theta;
theta_ordered_index=inputs.PEsol.index_global_theta(results.rank.global_par_rank_index(1:n_theta,1)');
theta_ordered=inputs.model.par(theta_ordered_index(1,1:n_theta));
par_rank_index=results.rank.global_par_rank_index(1:n_theta,:);
rank_mat=results.rank.global_par_rank_mat(1:n_theta,:);
index_theta=inputs.PEsol.index_global_theta;

fprintf(1,'____________________________________________________________________________________________\n');
fprintf(fid,'____________________________________________________________________________________________\n');

if numel(inputs.model.par_names)==0
    for i=1:n_theta
        fprintf(1,'theta\t %3i %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            index_theta(par_rank_index(i,1)),...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
        fprintf(fid,'theta\t %3i %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            index_theta(par_rank_index(i,1)),...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
    end %for i=1:inputs.n_theta
else
    
    for i=1:n_theta
        fprintf(1,'\t%s %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
        fprintf(fid,'\t%s %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
    end %for i=1:inputs.n_theta
end  %numel(inputs.model.par_names)==0

fprintf(1,'____________________________________________________________________________________________\n');
fprintf(fid,'____________________________________________________________________________________________\n');

clear rank_mat;

if inputs.PEsol.n_global_theta_y0>0
    n_theta_y0=inputs.PEsol.n_global_theta_y0;
    y0_ordered_index=results.rank.global_y0_rank_index;
    y0_ordered=inputs.exps.exp_y0{1}(y0_ordered_index);
    y0_rank_index= results.rank.global_y0_rank_index(1:n_theta_y0,:);
    rank_mat=results.rank.global_y0_rank_mat(1:n_theta_y0,:);
    index_theta_y0=[inputs.PEsol.index_global_theta_y0];
    fprintf(1,'____________________________________________________________________________________________\n');
    fprintf(fid,'____________________________________________________________________________________________\n');
    
    
    if numel(inputs.model.st_names)==0
        for i=1:n_theta_y0
            fprintf(1,'y0\t %3i  %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                index_theta_y0(y0_rank_index(i,1)),...
                rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            fprintf(fid,'y0\t %3i %12.4e  %12.4e %12.4e  %12.4e  %12.4e \n',...
                index_theta_y0(y0_rank_index(i,1)),...
                rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
        end %for i=1:inputs.n_theta_y0
        
    else
        for i=1:n_theta_y0
            fprintf(1,'\t%s %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',...
                rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e %12.4e \n',...
                inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',...
                rank_mat(i,1),rank_mat(i,2), rank_mat(i,3),rank_mat(i,4), rank_mat(i,5));
        end %for i=1:inputs.n_theta
    end  %numel(inputs.model.st_names)==0
    fprintf(1,'____________________________________________________________________________________________\n');
    fprintf(fid,'____________________________________________________________________________________________\n');
    
    clear rank_mat;
end %if n_theta_y0>0


%
%
fprintf(1,'\n\n------>RELATIVE Ranking of GLOBAL unknown PARAMETERS:\n\n');
fprintf(fid,'\n\n------>RELATIVE Ranking of GLOBAL unknown PARAMETERS: \n\n');
fprintf(1,'\t\t\trd_msqr\t\trd_mabs\t\trd_mean\t\t\trd_max\t\trd_min\n');
fprintf(fid,'\t\t\trd_msqr\t\trd_mabs\t\trd_mean\t\t\trd_max\t\trd_min\n');
%
r_theta_ordered_index=inputs.PEsol.index_global_theta(results.rank.r_global_par_rank_index(:,1));
r_theta_ordered=inputs.model.par(r_theta_ordered_index(1,:));
par_rank_index=results.rank.r_global_par_rank_index;
rank_mat=results.rank.r_global_par_rank_mat;
fprintf(1,'____________________________________________________________________________________________\n');
fprintf(fid,'____________________________________________________________________________________________\n');

if numel(inputs.model.par_names)==0
    for i=1:n_theta
        fprintf(1,'theta\t %3i %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            index_theta(par_rank_index(i,1)),...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
        fprintf(fid,'theta\t %3i %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            index_theta(par_rank_index(i,1)),...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
    end %for i=1:inputs.n_theta
else
    
    for i=1:n_theta
        fprintf(1,'\t%s %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
        fprintf(fid,'\t%s %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
            inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',...
            rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
    end %for i=1:inputs.n_theta
end  %numel(inputs.model.par_names)==0

fprintf(1,'____________________________________________________________________________________________\n');
fprintf(fid,'____________________________________________________________________________________________\n');
clear rank_mat;
%
if inputs.PEsol.n_global_theta_y0>0
    y0_ordered_index=results.rank.r_global_y0_rank_index;
    y0_ordered=inputs.exps.exp_y0{1}(y0_ordered_index);
    y0_rank_index= results.rank.r_global_y0_rank_index(1:n_theta_y0,:);
    rank_mat=results.rank.r_global_y0_rank_mat(1:n_theta_y0,:);
    fprintf(1,'____________________________________________________________________________________________\n');
    fprintf(fid,'____________________________________________________________________________________________\n');
    
    
    if numel(inputs.model.st_names)==0
        for i=1:n_theta_y0
            fprintf(1,'y0\t %3i  %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                index_theta_y0(y0_rank_index(i,1)),...
                rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            fprintf(fid,'y0\t %3i %12.4e  %12.4e %12.4e  %12.4e  %12.4e \n',...
                index_theta_y0(y0_rank_index(i,1)),...
                rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
        end %for i=1:inputs.n_theta_y0
        
    else
        for i=1:n_theta_y0
            fprintf(1,'\t%s %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',...
                rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e %12.4e \n',...
                inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',...
                rank_mat(i,1),rank_mat(i,2), rank_mat(i,3),rank_mat(i,4), rank_mat(i,5));
        end %for i=1:inputs.n_theta
    end  %numel(inputs.model.st_names)==0
    fprintf(1,'____________________________________________________________________________________________\n');
    fprintf(fid,'____________________________________________________________________________________________\n');
    clear rank_mat;
end %if n_theta_y0>0

switch inputs.model.exe_type
    
    case 'fullMex'
        
        warning('AMIGO_report_global_rank: Statistics about the simulation are not currently shown in fullMex execution mode.');
        
    otherwise
        
        fprintf(1,'> %.2f%% of successful simulationn\n',100*n_amigo_sim_success/(n_amigo_sim_success+n_amigo_sim_failed));
        fprintf(fid,'> %.2f%% of successful simulationn\n',100*n_amigo_sim_success/(n_amigo_sim_success+n_amigo_sim_failed));
        
        fprintf(1,'> %.2f%% of successful sensitivity calculations\n',100*n_amigo_sens_success/(n_amigo_sens_success+n_amigo_sens_failed));
        fprintf(fid,'> %.2f%% of successful sensitivity calculations\n',100*n_amigo_sens_success/(n_amigo_sens_success+n_amigo_sens_failed));
        
end

fclose(fid);

