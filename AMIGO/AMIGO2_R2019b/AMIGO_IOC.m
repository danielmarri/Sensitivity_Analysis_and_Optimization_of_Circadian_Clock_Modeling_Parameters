%% Multi- & Single- Objective Inverse Dynamic Optimization
%  AMIGO_IOC is an AMIGO addon to solve Multi- and Single- Objective constrained
%  inverse dynamic optimization problems
%  This tool can be used to simultanously estimate model parameters and
%  stimulation conditions to fit model to data.
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
% *Brief description*
%
% AMIGO_IOC: solves inverse dynamic optimization problems using the Control 
%           Vector Parameterization (CVP) approach
%
%          >It may handle:
%          -Single or multi-objective cases
%          -Constraints on decision variables
%          -Constraints on state variables
%
%          >It may call several optimizers
%               LOCAL optimization methods: indirect and direct methods
%               MULTISTART of local methods
%               GLOBAL optimization methods: DE, SRES
%               HYBRID optimization methods: eSS, sequential hybrids
%               MULTI-objective solvers: NSGAII
%
%          > Usage:  AMIGOI_DO('input_file',options)
%
%          > options: 'run_identifier' to keep different folders for
%                          different runs, this avoids overwriting
%                     'nlp_solver' to rapidly change the optimization method
%                     'reoptsolver' solver for reoptimization
%                     'nreopts' number of reoptimizations
%
%          > Usage examples:  AMIGO_IOC('nfkb')

%
% *References*
%
% * E. Balsa-Canto, V. S. Vassiliadis, J. R. Banga (2005) Dynamic
%   Optimization of Single and Multi-Stage Systems Using a Hybrid
%   Stochastic-Deterministic Method. Ind. Eng. Chem. Res., 44(5):
%   1514–1523.
% * Banga J.R.,E. Balsa-Canto,C.G. Moles,A.A.Alonso(2005) Dynamic
%   Optimization of bioprocesses: Efficient and robust
%   numerical strategies. J. Biotechnology, 117(4):407-419
% * Egea, J.A., E. Balsa-Canto, M.S.G. Garcia, J.R.Banga (2009)
%   Dynamic Optimization of nonlinear Processes with an Enhanced
%   Scatter Search. Ind. & Eng. Chem. Res. 48:4388-4401.
% * Vilas C., Balsa-Canto E., S.G. Garcia, J.R. Banga and A.A. Alonso
%   (2012) Dynamic optimization of distributed biological systems using
%   robust and efficient numerical techniques. BMC Systems Biology, 6:79.
%%
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_DO.m 2410 2015-12-07 13:58:57Z evabalsa $
function [results]=AMIGO_IOC(input_file,run_ident,opt_solver,reoptsolver,nreopts)


%%   Checks for necessary arguments

if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end

%%
% * Reads defaults: AMIGO_private_defaults_DO & AMIGO_public_defaults_DO

[inputs_def]= AMIGO_private_defaults_IOC;

[inputs_def]= AMIGO_public_defaults_IOC(inputs_def);


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
        % * Calls AMIGO_check_IOC & AMIGO_check_NLPsolver
        [inputs,privstruct]=AMIGO_check_IOC(input_file,inputs_def);
        [inputs]=AMIGO_check_exps_IOC(inputs);
        [inputs]=AMIGO_check_obs(inputs);
        [inputs]=AMIGO_check_data_IOC(inputs);
        [inputs]=AMIGO_check_IOC_nlp_options(inputs);
        % Checks NLP solver  
        [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);    
        
        otherwise      
       [inputs,privstruct]=AMIGO_check_IOC(input_file,inputs_def);
       [inputs]=AMIGO_check_exps_IOC(inputs);
       [inputs]=AMIGO_check_obs(inputs);
       [inputs]=AMIGO_check_data_IOC(inputs);
       [inputs]=AMIGO_check_IOC_nlp_options(inputs); 
       [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);   
            
    end
    
else %if nargin==1     


    [inputs,privstruct]=AMIGO_check_IOC(input_file,inputs_def);
if nargin>1
    inputs.pathd.runident_cl=run_ident;
    inputs.pathd.runident=run_ident;
end
    [inputs]=AMIGO_check_exps_IOC(inputs);
    [inputs]=AMIGO_check_obs(inputs);
    [inputs]=AMIGO_check_data_IOC(inputs);

    [inputs]=AMIGO_check_IOC_nlp_options(inputs);

if nargin>2
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,opt_solver,privstruct);
else
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);
end


if nargin==4
    inputs.nlpsol.reopt='on';
    inputs.nlpsol.reopt_local_solver=reoptsolver(1,[7:end]);
    inputs.nlpsol.n_reOpts=1;
end
if nargin>4
    inputs.nlpsol.reopt='on';
    inputs.nlpsol.reopt_local_solver=reoptsolver(1,[7:end]);
    inputs.nlpsol.n_reOpts=nreopts;
end

end % if nargin==1



%%   Creates necessary paths

%%
%
% * Calls AMIGO_path and AMIGO_paths_DO


AMIGO_path

AMIGO_paths_IOC

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



AMIGO_init_IOC_guess_bounds



results.nlpsol.pareto_obj=[];
%
%%   Solves Dynamic optimization problems
%
%

%%   Single- objective case

if inputs.IOCsol.N_IOCcost == 1 % CASE SINGLE OBJECTIVE
    
    switch inputs.nlpsol.nlpsolver
        
        case 'sim'
            privstruct.print_flag=1;
            inputs.exps.n_exp=1;                               %Number of experiments
            inputs.exps.exp_y0{1}=inputs.IOCsol.y0;             %Initial conditions for each experiment
            inputs.exps.t_f{1}=inputs.IOCsol.tf_guess;
            inputs.exps.u{1}=inputs.IOCsol.u_guess;
            inputs.exps.u_max{1}=inputs.IOCsol.u_max;
            inputs.exps.u_min{1}=inputs.IOCsol.u_min;
            inputs.exps.t_con{1}= inputs.IOCsol.t_con;
            inputs.exps.u_interp{1}=inputs.IOCsol.u_interp;
            inputs.exps.n_pulses{1}=inputs.IOCsol.n_pulses;
            privstruct.par{1}=inputs.model.par;
            if inputs.IOCsol.n_par>0, privstruct.par{1}(inputs.IOCsol.index_par)=inputs.IOCsol.par_guess;  end
            if inputs.IOCsol.n_y0>0, privstruct.y0{1}(inputs.IOCsol.index_y0)=inputs.IOCsol.y0_guess;  end
            results.ioc.upar=inputs.IOCsol.par_guess;
            results.ioc.uy0=inputs.IOCsol.y0_guess;
            AMIGO_smooth_simulation
            nlpsolver='sim';
             
        otherwise
            privstruct.print_flag=1;
            %%
            % * Generation of the cost function and constraints: AMIGO_gen_DOcost
            
            if inputs.IOCsol.user_cost==0 
              [inputs,results]=AMIGO_gen_IOCcost(inputs,'off',0);    
            else
      
            if isempty(inputs.pathd.ioc_function) || isempty(inputs.pathd.ioc_constraints)
            inputs.pathd.ioc_function=['AMIGO_IOCcost_',inputs.pathd.short_name];
            inputs.pathd.ioc_constraints=['AMIGO_IOCconst_',inputs.pathd.short_name];  
            end
            end
            %%         
            % * Calls optimizer selected by user: AMIGO_call_IOCOPTsolver
      
            addpath(fullfile(inputs.pathd.AMIGO_path,inputs.pathd.problem_folder_path));
            [results,privstruct]=AMIGO_call_IOCOPTsolver(inputs.nlpsol.nlpsolver,inputs.IOCsol.vdo_guess,inputs.IOCsol.vdo_min,inputs.IOCsol.vdo_max,inputs,results,privstruct);
            privstruct.ioc=results.nlpsol.vbest;
            [privstruct,inputs,results]=AMIGO_transform_ioc(inputs,results,privstruct);
            results.ioc.t_f=privstruct.t_f;
            results.ioc.u=privstruct.u;
            results.ioc.t_con=privstruct.t_con;
            
            if inputs.IOCsol.n_y0>0, results.ioc.uy0=privstruct.uy0;end
            if inputs.IOCsol.n_par>0, results.ioc.upar=privstruct.upar;end
                  nlpsolver= inputs.nlpsol.nlpsolver;
                  
                  
                  
            switch inputs.nlpsol.reopt
                case 'on'
                    inputs.nlpsol.local_solver=inputs.nlpsol.reopt_local_solver;
                         AMIGO_IReOpt
                    nlpsolver= 'local';
            end
            
   
            
            AMIGO_smooth_simulation
            eval(sprintf('[f,g,h]=%s(privstruct.ioc,inputs,results,privstruct);', inputs.pathd.ioc_function));
            results.ioc.constraints_viol=g;
    end % switch inputs.nlpsol.nlpsolver
    %% Generates report and plots for single-objective case
    %%
    % * Calls to AMIGO_post_report_IOC & AMIGO_post_plot_IOC
    [results,privstruct]= AMIGO_post_report_IOC(inputs,results,privstruct);

    switch inputs.plotd.plotlevel
        case {'full','medium','min'}
            AMIGO_post_plot_IOC(inputs,results,privstruct,nlpsolver);
        otherwise 
            fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
            fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
    end
    
    
    
    %%   Multi- objective case
else % inputs.IOCsol.N_IOCcost > 1
    
    switch inputs.nlpsol.nlpsolver
        
        case 'sim'
            privstruct.print_flag=1;
            inputs.exps.n_exp=1;                                %Number of experiments
            inputs.exps.exp_y0{1}=inputs.IOCsol.y0;              %Initial conditions for each experiment
            inputs.exps.t_f{1}=inputs.IOCsol.tf_guess;
            inputs.exps.u{1}=inputs.IOCsol.u_guess;
            inputs.exps.u_max{1}=inputs.IOCsol.u_max;
            inputs.exps.u_min{1}=inputs.IOCsol.u_min;
            inputs.exps.t_con{1}= inputs.IOCsol.t_con;
            inputs.exps.u_interp{1}=inputs.IOCsol.u_interp;
            inputs.exps.n_pulses{1}=inputs.IOCsol.n_pulses;
            if inputs.IOCsol.n_par>0, privstruct.par{1}(inputs.IOCsol.index_par)=inputs.IOCsol.par_guess;  end
            if inputs.IOCsol.n_y0>0, privstruct.y0{1}(inputs.IOCsol.index_y0)=inputs.IOCsol.y0_guess;  end
            AMIGO_smooth_simulation
            
            %          case 'monlot'
            %             privstruct.print_flag=1;
            %
            %            CALLS generation of the cost function and constraints
            %             [inputs,results]=AMIGO_gen_multidocost(inputs,'off',0);
            %            CALLS optimizer
            %             [results,privstruct]=AMIGO_call_IOCOPTsolver(inputs.nlpsol.nlpsolver,inputs.IOCsol.vdo_guess,inputs.IOCsol.vdo_min,inputs.IOCsol.vdo_max,inputs,results,privstruct);
            %             privstruct.ioc=results.nlpsol.vbest;
            %             [privstruct,inputs]=AMIGO_transform_od(inputs,results,privstruct);
            %             results.ioc.t_f=privstruct.t_f{1};
            %             results.ioc.u=privstruct.u{1};
            %             results.ioc.t_con=privstruct.t_con{1};
            %             AMIGO_smooth_simulation
            %             eval(sprintf('[f,g,h]=%s(privstruct.ioc,inputs,results,privstruct);', inputs.pathd.ioc_function));
            %             results.ioc.constraints_viol=g;
            
        case 'nsga2'
            privstruct.print_flag=1;
            
            %%
            % * Generation of the cost function and constraints: AMIGO_gen_multidocost
            [inputs,results]=AMIGO_gen_multidocost(inputs,results,'off',0);
            %%
            % * Calls optimizer (currently: nsga2 or weighted sum method):
            %   AMIGO_call_IOCOPTsolver
            
            [results,privstruct]=AMIGO_call_IOCOPTsolver(inputs.nlpsol.nlpsolver,inputs.IOCsol.vdo_guess,inputs.IOCsol.vdo_min,inputs.IOCsol.vdo_max,inputs,results,privstruct);
            
            %% Generates report and plots for multi-objective case
            %%
            % * Calls to AMIGO_plot_pareto_front & AMIGO_plot_pareto_states & AMIGO_post_report_IOC
            AMIGO_plot_colors
            AMIGO_plot_pareto_front
            
            privstruct.ibest_plot_pareto=floor(results.nlpsol.n_firstParetoFront/(inputs.plotd.number_max_pareto-1));
            %Sorted pareto front using first objecitve in ascending order
            [sortedJ1,indexsortedJ1]=sort(results.nlpsol.pareto_obj(:,1));
            results.nlpsol.sorted_pareto_obj=[sortedJ1 results.nlpsol.pareto_obj(indexsortedJ1,2)];
            results.nlpsol.sorted_pareto_vbest=results.nlpsol.pareto_vbest(indexsortedJ1,:);
            
            for ibest=1:results.nlpsol.n_firstParetoFront
                privstruct.ioc=results.nlpsol.sorted_pareto_vbest(ibest,:);
                [privstruct,inputs,results]=AMIGO_transform_IOC(inputs,results,privstruct);
                results.ioc.t_f{ibest}=privstruct.t_f{1};
                results.ioc.u{ibest}=privstruct.u{1};
                results.ioc.t_con{ibest}=privstruct.t_con{1};              
                if inputs.IOCsol.n_par>0, privstruct.par{1}(inputs.IOCsol.index_par)=inputs.IOCsol.par_guess; results.ioc.upar{ibest}=privstruct.upar;  end
                if inputs.IOCsol.n_y0>0, privstruct.y0{1}(inputs.IOCsol.index_y0)=inputs.IOCsol.y0_guess; results.ioc.uy0{ibest}=privstruct.uy0; end
                AMIGO_smooth_simulation
                eval(sprintf('[f,g]=%s(privstruct.ioc,inputs,results,privstruct);', inputs.pathd.ioc_function));
                results.ioc.constraints_viol{ibest}=g;
                
                switch inputs.plotd.plotlevel
                    case {'full','medium','min'}
                        if ibest==1 || mod(ibest,privstruct.ibest_plot_pareto)==1 ||ibest==results.nlpsol.n_firstParetoFront
                            AMIGO_plot_pareto_states
                        end
                        
                        
                    otherwise
                        fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
                        fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
                end
                
                
                
            end %for ibest=1:results.nlpsol.n_firstParetoFront
            
            [results,privstruct]= AMIGO_post_report_IOC(inputs,results,privstruct);
            
        case 'wsm'
            privstruct.print_flag=1;
            %CALLS generation of the cost function and constraints

                for iweights=1:inputs.IOCsol.n_wsm
                inputs.IOCsol.wsm=inputs.IOCsol.wsm_mat(iweights,:);
                [inputs,results]=AMIGO_gen_multidocost(inputs,results,'off',0);
                
                if isempty(inputs.nlpsol.local_solver)
                    [results,privstruct]=AMIGO_call_IOCOPTsolver(inputs.nlpsol.global_solver,inputs.IOCsol.vdo_guess,inputs.IOCsol.vdo_min,inputs.IOCsol.vdo_max,inputs,results,privstruct);
                else
                    [results,privstruct]=AMIGO_call_IOCOPTsolver('local',inputs.IOCsol.vdo_guess,inputs.IOCsol.vdo_min,inputs.IOCsol.vdo_max,inputs,results,privstruct);
                end
                privstruct.ioc=results.nlpsol.vbest;
                [privstruct,inputs,results]=AMIGO_transform_IOC(inputs,results,privstruct);
                results.ioc.t_f{iweights}=privstruct.t_f{1};
                results.ioc.u{iweights}=privstruct.u{1};
                results.ioc.t_con{iweights}=privstruct.t_con{1};
                if inputs.IOCsol.n_par>0, privstruct.par{1}(inputs.IOCsol.index_par)=inputs.IOCsol.par_guess; results.ioc.upar{ibest}=privstruct.upar;  end
                if inputs.IOCsol.n_y0>0, privstruct.y0{1}(inputs.IOCsol.index_y0)=inputs.IOCsol.y0_guess; results.ioc.uy0{ibest}=privstruct.uy0; end
                AMIGO_smooth_simulation
                states{iweights}=results.sim.states;
                
                eval(sprintf('[f,g,h]=%s(privstruct.ioc,inputs,results,privstruct);', inputs.pathd.ioc_function));
                results.ioc.constraints_viol{iweights}=g;
                results.ioc.multi_fbest{iweights}=h;
                results.nlpsol.pareto_obj(iweights,:)=results.ioc.multi_fbest{iweights};
                fprintf(1,'\n--> Pareto solution:\t');
                for icost=1:inputs.IOCsol.N_DOcost
                fprintf(1,'%s: %f\t',inputs.IOCsol.DOcost{icost},results.ioc.multi_fbest{iweights}(1,icost));
                end %icost=1:inputs.IOCsol.N_DOcost

                end %for iweights=1:inputs.IOCsol.n_wsm
               
               
               
                switch inputs.plotd.plotlevel
                    case {'full','medium','min'}
                        % Plots the Pareto front if 2 cost functions    
                        AMIGO_plot_colors
                        if inputs.IOCsol.N_DOcost==2
                         AMIGO_plot_pareto_front
                        end
                        privstruct.ibest_plot_pareto=floor(inputs.IOCsol.n_wsm/(inputs.plotd.number_max_pareto-1));
                        for ibest=1:inputs.IOCsol.n_wsm                        
                        results.sim.states{1}=cell2mat(states{ibest});             
                        inputs.exps.u{1}=results.ioc.u{ibest};
                        if inputs.IOCsol.n_par>0, results.ioc.upar{iweights}=privstruct.upar;end
                        if inputs.IOCsol.n_y0>0, results.ioc.uy0{iweights}=privstruct.uy0;end
                        
                        
                        if ibest==1 || mod(ibest,privstruct.ibest_plot_pareto)==1 ||ibest==inputs.IOCsol.n_wsm
                             AMIGO_plot_pareto_states
                        end
                        end
                        
                    otherwise
                        fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
                        fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
                end
                
                
                

            
               [results,privstruct]= AMIGO_post_report_IOC(inputs,results,privstruct);
            
            
        otherwise
            
           
        cprintf('*red','\n\n------> ERROR message\n\n');
        cprintf('red','\t\t You have selected to solve a multi-objective optimization problem.\n');
        cprintf('red','\t\tThe solver %s is not suitable for this type of problems, please use nsga2 or wsm.\n');
        return;         
            
    end %switch inputs.nlpsol.nlpsolver
    
    
end %if inputs.IOCsol.N_IOCcost == 1



%% Deletes unnecessary info and saves structures in a .mat file
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;
save(inputs.pathd.struct_results,'inputs','results','privstruct');

%%
%
% * Calls to AMIGO_del_DO

AMIGO_del_DO
save(inputs.pathd.struct_results,'inputs','results');
cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
if nargout<1
    clear;
end
return