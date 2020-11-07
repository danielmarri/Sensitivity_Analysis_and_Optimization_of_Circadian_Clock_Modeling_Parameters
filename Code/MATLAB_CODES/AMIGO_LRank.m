function [inputs results]=AMIGO_LRank(input_file,run_ident)
% AMIGO_LRank: computes local ranking of model unknowns
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
% AMIGO_LRank: - Computes (local) sensitivities for a given value of model    %
%                unknowns, keeps information for all observables and all      %
%                experiments
%              - Computes overall (for all experimental schemes and           %
%                observables) ranking of global unknowns (experiment          %
%                independent parameters and initial conditions                %
%              - Plots sensitivities evolution with time                      %
%              - Plots/Reports overall local ranking of global unknowns       %
%              - Plots bars and 2D figures of sensitivities for all           %
%                observables and all experiments for global and local unknowns%
%                                                                             %
%               > usage:  AMIGO_LRank('input_file',options)                   %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                         different runs, this avoids overwriting             %
%                                                                             %
%               > usage examples:  AMIGO_LRank('NFKB_lrank')                  %
%                                  AMIGO_LRank('NFKB_lrank','r1')             %
%                                  AMIGO_LRank('NFKB_lrank','r2')             %
%                                                                             %
%*****************************************************************************%
% close all;
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_LRank.m 2305 2015-11-25 08:20:26Z evabalsa $
global n_amigo_sim_success;
global n_amigo_sim_failed;
global n_amigo_sens_success;
global n_amigo_sens_failed;

%Checks for necessary arguments

if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end


%AMIGO_PE header
AMIGO_report_header

fprintf(1,'\n\n------>Pre processing....this may take a few seconds.\n')

%Starts Check of inputs
fprintf(1,'\n\n------>Checking inputs....\n')

%Reads defaults
[inputs_def]= AMIGO_private_defaults;
%[inputs_def, results_def]= AMIGO_public_defaults(inputs_def);
[inputs_def]= AMIGO_public_defaults(inputs_def);

%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
end


%Reads inputs
[inputs,results]=AMIGO_check_model(input_file,inputs_def);%results_def
[inputs]=AMIGO_check_exps(inputs);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_sampling(inputs);
inputs = AMIGO_check_nlp_options(inputs);
[inputs]= AMIGO_check_theta(inputs);

%DETECTS PATH
AMIGO_path

%Generates matlab file to compute observables
AMIGO_gen_obs(inputs,results);

%Creates necessary paths
AMIGO_paths_LR
AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)


%**************************************************************************
% 'local_rank': simulates for the given set of parameters and intial conditions, computes ranking of
%                  parameters and parametrict sensitivities
privstruct=inputs.exps;
fprintf(1,'\n\n\n------>Performing local sensitivity analysis and ranking of unknowns\n\n ');
% Memory allocation
privstruct.y_0=cell(inputs.exps.n_exp,1);
privstruct.par=cell(inputs.exps.n_exp,1);

if isempty(inputs.PEsol.id_global_theta)==1
    privstruct.theta=inputs.model.par;
    inputs.PEsol.n_global_theta=inputs.model.n_par;
    inputs.PEsol.index_global_theta=[1:1:inputs.model.n_par];
else
    AMIGO_init_theta
end

privstruct=AMIGO_transform_theta(inputs,results,privstruct);

AMIGO_init_times

switch inputs.model.exe_type
    
    case 'standard'
        
        for iexp=1:inputs.exps.n_exp
            [results,privstruct]=AMIGO_sens(inputs,results,privstruct,iexp);
        end
        
    otherwise
        
        feval(inputs.model.mexfunction,'sim_CVODES');
        for iexp=1:inputs.exps.n_exp
            if(outputs.success{iexp})
                
                privstruct.istate_sens=1;
                n_amigo_sim_success=n_amigo_sim_success+1;
                
            else
                
                n_amigo_sim_failed=n_amigo_sim_failed+1;
                privstruct.istate_sens=-1;
                
            end
        end
        
        privstruct.ms=outputs.observables;
        inputs.ivpsol.max_num_steps=inputs.ivpsol.sens_maxnumsteps;
        feval(inputs.model.mexfunction,'sens_FSA_CVODES');
        privstruct.sens_t=outputs.sensitivities;
        
        warning('AMIGO_LRank: Relative sensitivities are not being computed in costMex, TODO.');
        
        for iexp=1:inputs.exps.n_exp
            
            privstruct.sens_t{iexp}=outputs.sensitivities{iexp}(:,privstruct.index_observables{iexp},:);
            %privstruct.sens_t{iexp}=outputs.sensitivities{iexp}(:,privstruct.index_observables{iexp},:)...
            privstruct.r_sens_t{iexp}=outputs.sensitivities{iexp}(:,privstruct.index_observables{iexp},:);
            
            if(outputs.success{iexp})
                
                privstruct.istate_sens=1;
                n_amigo_sens_success=n_amigo_sens_success+1;
                
            else
                
                n_amigo_sens_failed=n_amigo_sens_failed+1;
                privstruct.istate_sens=-1;
                
            end
            
            privstruct.row_yms_0{iexp}=[];
            n_t_sampling=size(privstruct.t_s{iexp},2);
            
            for i=1:n_t_sampling
                
                if isempty(find(privstruct.ms{iexp}(i,:)==0)),
                    privstruct.row_yms_0{iexp}=[privstruct.row_yms_0{iexp}, i];
                else
                    %  fprintf(1,'>>> Exp %u: Obs(s)is/are zero at the %ust sampling time. Data not used for relative sensitivities.\n', iexp,i);
                    % results.rank.par_obs0=[results.rank.par_obs0; privstruct.par{iexp}];
                end
                
            end
            
        end
        
end

if privstruct.istate_sens < 0
    fprintf(1,'\n\n------>%s reported an integration error. Sorry, it was not possible to:\n',inputs.ivpsol.senssolver);
    fprintf(1,'\n\t\t\t * Calculate parametric sensitivities\n');
    fprintf(1,'\n\t\t\t * Ranking of parameters\n');
    pause(3)
else
    
    results.rank.sens_t=privstruct.sens_t;
    results.rank.r_sens_t=privstruct.r_sens_t;
    
    for iexp=1:inputs.exps.n_exp
        [results.rank.r_par_rank_index{iexp},results.rank.r_y0_rank_index{iexp},results.rank.r_rank_mat{iexp},...
            results.rank.r_sorted_par_rank_mat{iexp},results.rank.r_sorted_y0_rank_mat{iexp},...
            results.rank.par_rank_index{iexp},results.rank.y0_rank_index{iexp},results.rank.rank_mat{iexp},...
            results.rank.sorted_par_rank_mat{iexp},results.rank.sorted_y0_rank_mat{iexp}]=AMIGO_ranking_exp(inputs, results, privstruct,iexp);
    end
    
    if inputs.exps.n_exp>1
        [results]=AMIGO_local_rank(inputs,results);
    else
        results.rank.sorted_over_par_rank_mat=results.rank.sorted_par_rank_mat{1};
        results.rank.over_par_rank_index=results.rank.par_rank_index{1};
        results.rank.r_sorted_over_par_rank_mat=results.rank.r_sorted_par_rank_mat{1};
        results.rank.r_over_par_rank_index=results.rank.r_par_rank_index{1};
        results.rank.sorted_over_y0_rank_mat=results.rank.sorted_y0_rank_mat{1};
        results.rank.over_y0_rank_index=results.rank.y0_rank_index{1};
        results.rank.r_sorted_over_y0_rank_mat=results.rank.r_sorted_y0_rank_mat{1};
        results.rank.r_over_y0_rank_index=results.rank.r_y0_rank_index{1};
        
    end
    
    
    [results]=AMIGO_ranking_obs(inputs,results,privstruct);
    AMIGO_post_report_LR
end

switch inputs.plotd.plotlevel
    case {'full','medium','min'}
        AMIGO_post_plot_LR(inputs,results,privstruct);
    otherwise
        fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
        fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
end




%**************************************************************************
% SAVES STRUCTURE WITH USEFUL DATA

AMIGO_del_LR
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;
save(inputs.pathd.struct_results,'inputs','results');
cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
if nargout<1
    clear;
end
return