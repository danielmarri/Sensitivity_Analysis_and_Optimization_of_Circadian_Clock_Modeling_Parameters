%% Robust Inverse Dynamic Optimization
%  AMIGO_Rido solves the problem for several data realisations so as to
%  obtain information about uncertainty
%
%  Current version works for numerical pseudo-data using the
%  inputs.model.par for synthetic problems
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%**************************************************************************
%*
%*
function [results]=AMIGO_Rido(input_file,run_ident,opt_solver,reoptsolver,nreopts,nridos)


%%   Checks for necessary arguments

if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end

%%
% * Reads defaults: AMIGO_private_defaults_DO & AMIGO_public_defaults_DO

[inputs_def]= AMIGO_private_defaults_ido;

[inputs_def]= AMIGO_public_defaults_ido(inputs_def);


%AMIGO_ header
AMIGO_report_header


%%   Reads and checks inputs

%Starts Check of inputs
fprintf(1,'\n\n------>Checking inputs....\n')

%Checks for optional arguments

if nargin==1 
    switch inputname(1)
        case 'inputs'
        %Reads inputs
        % * Calls AMIGO_check_ido & AMIGO_check_NLPsolver
        [inputs,privstruct]=AMIGO_check_ido(input_file,inputs_def);
        [inputs]=AMIGO_check_exps_ido(inputs);
        [inputs]=AMIGO_check_obs(inputs);
        [inputs]=AMIGO_check_data_ido(inputs);
        [inputs]=AMIGO_check_ido_nlp_options(inputs);
        % Checks NLP solver  
        [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);    
        
        otherwise      
       [inputs,privstruct]=AMIGO_check_ido(input_file,inputs_def);
       [inputs]=AMIGO_check_exps_ido(inputs);
       [inputs]=AMIGO_check_obs(inputs);
       [inputs]=AMIGO_check_data_ido(inputs);
       [inputs]=AMIGO_check_ido_nlp_options(inputs); 
       [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);   
            
    end
    
else %if nargin==1     

if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
end

    [inputs,privstruct]=AMIGO_check_ido(input_file,inputs_def);
    
    [inputs]=AMIGO_check_exps_ido(inputs);
    [inputs]=AMIGO_check_obs(inputs);
    [inputs]=AMIGO_check_data_ido(inputs);

    [inputs]=AMIGO_check_ido_nlp_options(inputs);

if nargin>2
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,opt_solver,privstruct);
else
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);
end


if nargin>=4 && reoptsolver~=0
    inputs.nlpsol.reopt='on';
    inputs.nlpsol.reopt_local_solver=reoptsolver(1,[7:end]);
    inputs.nlpsol.n_reOpts=1;
end
if nargin>=5 && reoptsolver~=0
    inputs.nlpsol.reopt='on';
    inputs.nlpsol.reopt_local_solver=reoptsolver(1,[7:end]);
    inputs.nlpsol.n_reOpts=nreopts;
end

if nargin==6
    inputs.idosol.n_ridos=nridos;
end


end % if nargin==1


%%   Creates necessary paths

%%
%
% * Calls AMIGO_path and AMIGO_paths_DO


AMIGO_path

AMIGO_paths_ido

%% Generates observation function
    AMIGO_gen_obs(inputs);
    inputs.model.obsfile=1;
   for iexp=1:inputs.exps.n_exp
    privstruct.w_obs{iexp}=ones(1,inputs.exps.n_obs{iexp});
   end


%%  Generates initial guess and bounds using CVP
%%
%
% * Calls AMIGO_init_DO_guess_bounds



AMIGO_init_ido_guess_bounds


%% Generates cost function

            if inputs.idosol.user_cost==0 
              [inputs,results]=AMIGO_gen_idocost(inputs,'off',0);    
            else
      
            if isempty(inputs.pathd.ido_function) || isempty(inputs.pathd.ido_constraints)
            inputs.pathd.ido_function=['AMIGO_idocost_',inputs.pathd.short_name];
            inputs.pathd.ido_constraints=['AMIGO_idoconst_',inputs.pathd.short_name];  
            end
            end
                  
                 
            addpath(fullfile(inputs.pathd.AMIGO_path,inputs.pathd.problem_folder_path));

%% Initializes robust ido
xdim=length(inputs.idosol.vdo_guess);
results.rido.best_population=zeros(inputs.idosol.n_ridos, xdim);

for itrial=1:inputs.idosol.n_ridos
    
    fprintf(1,'\n>>>>> TRIAL %d\n ',itrial);
      
     % Estimates parameters
       privstruct.print_flag=0;
     
%        inputs.plotd.plotlevel='noplot';     
%        inputs.plotd.figsave=0;
       [exp_data,error_data,residuals,norm_residuals]=AMIGO_pseudo_data(inputs,results,privstruct);
       plot(exp_data{1}(:,1))
       hold on
       inputs.exps.exp_data=exp_data;
       inputs.exps.error_data=error_data;
       [results,privstruct]=AMIGO_call_idoOPTsolver(inputs.nlpsol.nlpsolver,inputs.idosol.vdo_guess,inputs.idosol.vdo_min,inputs.idosol.vdo_max,inputs,results,privstruct);     
 
       results.rido.best_population(itrial,2:xdim+1)=results.nlpsol.vbest; 
       results.rido.best_population(itrial,1)=results.nlpsol.fbest; 
       
             
     %  Calculates the distance to the optimum* 
    
        euclid_dist(itrial)=norm(results.nlpsol.vbest-inputs.idosol.vdo_guess); 
        euclid_dist_max(itrial)=max(abs(results.nlpsol.vbest-inputs.idosol.vdo_guess));  
        euclid_dist_matrix(itrial,:)=results.nlpsol.vbest-inputs.idosol.vdo_guess; 
       
        privstruct.ido=results.nlpsol.vbest;
        [privstruct,inputs,results]=AMIGO_transform_ido(inputs,results,privstruct);
        
        for iexp=1:inputs.exps.n_exp 
        results.rido.t_f{itrial,iexp}=privstruct.t_f{iexp};
        results.rido.u{itrial,iexp}=privstruct.u{iexp};
        results.rido.t_con{itrial,iexp}=privstruct.t_con{iexp};
        results.rido.upar(itrial,:)=privstruct.upar;
        end

end

% DISPLAY RESULTS - FIGURES


AMIGO_plot_colors;

        figure
    for iexp=1:inputs.exps.n_exp   
        figure();
        icolor=iexp;
        for itrial=1:inputs.idosol.n_ridos
        inputs.exps.u_interp{iexp}=inputs.idosol.u_interp;
        inputs.exps.n_steps{iexp}=inputs.idosol.n_steps{iexp};
        inputs.exps.u{iexp}=results.rido.u{itrial,iexp};
        inputs.exps.t_con{iexp}= results.rido.t_con{itrial,iexp};
        inputs.exps.t_f{iexp}=results.rido.t_f{itrial,iexp};
        plot_title={inputs.plotd.data_plot_title,['experiment: ',mat2str(iexp)]};
        n_rows=inputs.model.n_stimulus;
        for ifig=1:n_rows     
            subplot(n_rows,1,ifig)
            AMIGO_plot_stimulus
        end
        hold on
        end
   end

figure

hist(results.rido.best_population(:,1))
title('Cost function distribution');

save(inputs.pathd.struct_results,'inputs','results','privstruct');
cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
if nargout<1
    clear;
end

    
