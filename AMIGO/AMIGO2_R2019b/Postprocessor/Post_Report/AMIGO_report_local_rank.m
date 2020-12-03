% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_local_rank.m 2202 2015-09-24 07:10:57Z evabalsa $
% AMIGO_report_local_rank: reports local ranking of unknowns
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
%   AMIGO_report_local_rank: generates part of report devoted to the          %
%                            local rank of unknowns                           %
%                            Relative and absolute rankings are provided in   %
%                            msqr decreasing order                            %
%                            Intermediate information for the different       %
%                            experiments is also provided                     %
%*****************************************************************************%

global n_amigo_sim_success;
global n_amigo_sim_failed;
global n_amigo_sens_success;
global n_amigo_sens_failed;

if privstruct.istate_sens>0
    
    fid=fopen(inputs.pathd.report,'a');
    
    
    % RANKING FOR DIFFERENT EXPERIMENTS
    
    for iexp=1:inputs.exps.n_exp
        
        fprintf(1,'\n\n------> RANKING for experiment: %u\n\n',iexp);
        fprintf(fid,'\n\n------> RANKING for experiment: %u\n\n',iexp);
        
        fprintf(1,'\n\n------>ABSOLUTE Ranking of model unknowns:\n\n');
        fprintf(fid,'\n\n------>ABSOLUTE Ranking of model unknowns:\n\n');
        fprintf(1,'\t\t\tpar value\t\td_msqr\t\t d_mabs\t\t d_mean\t\t\td_max\t\t  d_min\n');
        fprintf(fid,'\t\t\tpar value\t\td_msqr\t\t d_mabs\t\t d_mean\t\t\td_max\t\t  d_min\n');
        index_theta_y0=[inputs.PEsol.index_global_theta_y0 inputs.PEsol.index_local_theta_y0{iexp}];
        index_theta=[inputs.PEsol.index_global_theta inputs.PEsol.index_local_theta{iexp}];
        n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
        n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};
        inputs.model.par(index_theta)=privstruct.theta(1:n_theta);
        theta_ordered_index=index_theta(results.rank.par_rank_index{iexp}(:,1));
        theta_ordered=inputs.model.par(theta_ordered_index(1,:));
        par_rank_index=results.rank.par_rank_index{iexp};
        rank_mat=results.rank.sorted_par_rank_mat{iexp};
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        if numel(inputs.model.par_names)==0
            for i=1:n_theta
                fprintf(1,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        else
            
            for i=1:n_theta
                fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        end  %numel(inputs.model.par_names)==0
        
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        if inputs.PEsol.n_local_theta_y0{iexp}>0
            y0_ordered_index=results.rank.r_y0_rank_index{iexp};
            y0_ordered=inputs.exps.exp_y0{iexp}(y0_ordered_index);
            y0_rank_index= results.rank.r_y0_rank_index{iexp}(1:n_theta_y0,:);
            y0rank_mat=results.rank.r_sorted_y0_rank_mat{iexp}(1:n_theta_y0,:);
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
            
            
            if numel(inputs.model.st_names)==0
                for i=1:n_theta_y0
                    fprintf(1,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta_y0
                
            else
                for i=1:n_theta_y0
                    fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta
            end  %numel(inputs.model.st_names)==0
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
        end %if n_theta_y0>0
        
        
        fprintf(1,'\n\n------>RELATIVE Ranking of model unknowns:\n\n');
        fprintf(fid,'\n\n------>RELATIVE Ranking of model unknowns:\n\n');
        fprintf(1,'\t\t\tpar value\t\trd_msqr\t\trd_mabs\t\trd_mean\t\t\trd_max\t\trd_min\n');
        fprintf(fid,'\t\t\tpar value\t\trd_msqr\t\trd_mabs\t\trd_mean\t\t\trd_max\t\trd_min\n');
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        r_theta_ordered_index=index_theta(results.rank.r_par_rank_index{iexp}(:,1));
        r_theta_ordered=inputs.model.par(r_theta_ordered_index(1,:));
        par_rank_index=results.rank.r_par_rank_index{iexp};
        rank_mat=results.rank.r_sorted_par_rank_mat{iexp};
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        if numel(inputs.model.par_names)==0
            for i=1:n_theta
                fprintf(1,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),r_theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),r_theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        else
            
            for i=1:n_theta
                fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',r_theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',r_theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        end  %numel(inputs.model.par_names)==0
        
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        
        if inputs.PEsol.n_theta_y0>0
            r_y0_ordered_index=index_theta_y0(results.rank.r_y0_rank_index{iexp}(:,1));
            r_y0_ordered=inputs.exps.exp_y0{iexp}(r_y0_ordered_index(1,:));
            y0_rank_index= results.rank.r_y0_rank_index{iexp};
            y0rank_mat=results.rank.r_sorted_y0_rank_mat{iexp};
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
            
            
            if numel(inputs.model.st_names)==0
                for i=1:n_theta_y0
                    fprintf(1,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta_y0
                
            else
                for i=1:n_theta_y0
                    fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',r_y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',r_y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta
            end  %numel(inputs.model.st_names)==0
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
        end
        
    end %for iexp=1:inputs.exps.n_exp
    
    
    
    if inputs.exps.n_exp>1
        
        fprintf(1,'\n\n------> OVERALL RANKING\n\n');
        fprintf(fid,'\n\n------> OVERALL RANKING\n\n');
        
        fprintf(1,'\n\n------>ABSOLUTE Ranking of GLOBAL model unknowns:\n\n');
        fprintf(fid,'\n\n------>ABSOLUTE Ranking of GLOBAL model unknowns:\n\n');
        fprintf(1,'\t\t\tpar value\t\td_msqr\t\t d_mabs\t\t d_mean\t\t\td_max\t\t  d_min\n');
        fprintf(fid,'\t\t\tpar value\t\td_msqr\t\t d_mabs\t\t d_mean\t\t\td_max\t\t  d_min\n');
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        n_theta=inputs.PEsol.n_global_theta;
        theta_ordered_index=inputs.PEsol.index_global_theta(results.rank.over_par_rank_index(1:n_theta,1));
        theta_ordered=inputs.model.par(theta_ordered_index(1,1:n_theta));
        par_rank_index=results.rank.over_par_rank_index(1:n_theta,:);
        rank_mat=results.rank.sorted_over_par_rank_mat(1:n_theta,:);
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        if numel(inputs.model.par_names)==0
            for i=1:n_theta
                fprintf(1,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        else
            
            for i=1:n_theta
                fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        end  %numel(inputs.model.par_names)==0
        
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        
        if inputs.PEsol.n_global_theta_y0>0
            n_theta_y0=inputs.PEsol.n_global_theta_y0;
            y0_ordered_index=results.rank.over_y0_rank_index;
            y0_ordered=inputs.exps.exp_y0{1}(y0_ordered_index);
            y0_rank_index= results.rank.over_y0_rank_index(1:n_theta_y0,:);
            y0rank_mat=results.rank.sorted_over_y0_rank_mat(1:n_theta_y0,:);
            
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
            
            
            if numel(inputs.model.st_names)==0
                for i=1:n_theta_y0
                    fprintf(1,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta_y0
                
            else
                for i=1:n_theta_y0
                    fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta
            end  %numel(inputs.model.st_names)==0
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
        end %if n_theta_y0>0
        %
        %
        fprintf(1,'\n\n------>RELATIVE Ranking of GLOBAL model unknowns:\n\n');
        fprintf(fid,'\n\n------>RELATIVE Ranking of GLOBAL model unknowns:\n\n');
        fprintf(1,'\t\t\tpar value\t\trd_msqr\t\trd_mabs\t\trd_mean\t\t\trd_max\t\trd_min\n');
        fprintf(fid,'\t\t\tpar value\t\trd_msqr\t\trd_mabs\t\trd_mean\t\t\trd_max\t\trd_min\n');
        %
        r_theta_ordered_index=inputs.PEsol.index_global_theta(results.rank.r_over_par_rank_index(:,1));
        r_theta_ordered=inputs.model.par(r_theta_ordered_index(1,:));
        par_rank_index=results.rank.r_over_par_rank_index;
        rank_mat=results.rank.r_sorted_over_par_rank_mat;
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        
        if numel(inputs.model.par_names)==0
            for i=1:n_theta
                fprintf(1,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),r_theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'theta\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    index_theta(par_rank_index(i,1)),theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        else
            
            for i=1:n_theta
                fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',r_theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
                fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                    inputs.model.par_names(index_theta(par_rank_index(i,1)),:)',r_theta_ordered(i),...
                    rank_mat(i,1),rank_mat(i,2),rank_mat(i,3),rank_mat(i,4),rank_mat(i,5));
            end %for i=1:inputs.n_theta
        end  %numel(inputs.model.par_names)==0
        
        fprintf(1,'____________________________________________________________________________________________\n');
        fprintf(fid,'____________________________________________________________________________________________\n');
        %
        if inputs.PEsol.n_global_theta_y0>0
            y0_ordered_index=results.rank.r_over_y0_rank_index;
            y0_ordered=inputs.exps.exp_y0{1}(y0_ordered_index);
            y0_rank_index= results.rank.r_over_y0_rank_index(1:n_theta_y0,:);
            y0rank_mat=results.rank.r_sorted_over_y0_rank_mat(1:n_theta_y0,:);
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
            
            
            if numel(inputs.model.st_names)==0
                for i=1:n_theta_y0
                    fprintf(1,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),r_y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'y0\t %3i %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        index_theta_y0(y0_rank_index(i,1)),y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta_y0
                
            else
                for i=1:n_theta_y0
                    fprintf(1,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',r_y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                    fprintf(fid,'\t%s %12.4e %12.4e %12.4e %12.4e  %12.4e  %12.4e \n',...
                        inputs.model.st_names(index_theta_y0(y0_rank_index(i,1)),:)',r_y0_ordered(i),...
                        y0rank_mat(i,1),y0rank_mat(i,2),y0rank_mat(i,3),y0rank_mat(i,4),y0rank_mat(i,5));
                end %for i=1:inputs.n_theta
            end  %numel(inputs.model.st_names)==0
            fprintf(1,'____________________________________________________________________________________________\n');
            fprintf(fid,'____________________________________________________________________________________________\n');
        end %if n_theta_y0>0
        %
        %
        %
    end %if inputs.exps.n_exp>1
    
    
    
    
end %if privstruct.istate_sens>0

switch inputs.model.exe_type
    
    case 'fullMex'
        
        warning('AMIGO_post_report_PE: Statistics about the simulation are not currently shown in fullMex execution mode.');
        
    otherwise
        
        fprintf(1,'> %.2f%% of successful simulationn\n',100*n_amigo_sim_success/(n_amigo_sim_success+n_amigo_sim_failed));
        fprintf(fid,'> %.2f%% of successful simulationn\n',100*n_amigo_sim_success/(n_amigo_sim_success+n_amigo_sim_failed));
        
        fprintf(1,'> %.2f%% of successful sensitivity calculations\n',100*n_amigo_sens_success/(n_amigo_sens_success+n_amigo_sens_failed));
        fprintf(fid,'> %.2f%% of successful sensitivity calculations\n',100*n_amigo_sens_success/(n_amigo_sens_success+n_amigo_sens_failed));
        
end

fclose(fid);
