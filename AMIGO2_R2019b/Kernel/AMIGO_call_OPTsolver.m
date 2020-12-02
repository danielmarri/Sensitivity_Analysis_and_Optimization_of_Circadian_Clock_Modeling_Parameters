% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_call_OPTsolver.m 2528 2016-03-04 11:05:22Z evabalsa $
function [results,privstruct]=AMIGO_call_OPTsolver(optproblem,nlpsolver,vguess,vmin,vmax,inputs,results,privstruct)
% AMIGO_call_OPTsolver:  Calls the optimization solver selected by user for PE
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%*****************************************************************************%
%                                                                             %
%  AMIGO_call_OPTsolver: Calls the optimization solver selected by user       %
%                        The following alternatives are available:
%                        %
%                                                                             %
%                        LOCAL OPTIMIZATION SOLVERS                           %
%                                                                             %
%                        GLOBAL OPTIMIZATION SOLVERS                          %
%                        >'de': a modification of Differential Evolution      %
%                          which incorporates a new stopping criterion        %
%                          Original reference:                                %
%                          Storn R, Price K: Differential Evolution:a Simple  %
%                          and Efficient Heuristic for Global Optimization    %
%                          over Continuous Spaces. J Global Optim 1997,       %
%                          11:341-359.                                        %
%                        >'sres': Stochastic Ranking Evolutionary Search.     %
%                          Original reference:                                %
%                          Runarsson T, Yao X: Stochastic ranking for         %
%                          constrained evolutionary optimization. IEEE Trans. %
%                          Evolutionary Computation, 2000, 564:284-294.       %
%                        >'ess': Scatter Search                               %
%                          Original reference:                                %
%                          Egea JA, Rodriguez-Fernandez M, Banga J, Marti R:  %
%                          Scatter Search for Chemical and Bio-Process        %
%                          Optimization. J Glob Opt 2007, 37(3):481-503.      %
%                        >'globalm': Clustering method for constrained        %
%                          global optimization.                               %
%                          Original reference:                                %
%                          Csendes, T., L. Pal, J.O.H. Sendin, J.R. Banga     %
%                          (2008) The GLOBAL Optimization Method Revisited.   %
%                          Optimization Letters, 2(4):445-454.                %
%                        >'hyb_sres_*' sequential hybrid combining sres       %
%                           with available local solvers                      %
%                        >'hyb_de_*' sequential hybrid combining de with      %
%                           available local solvers                           %
%*****************************************************************************%


if privstruct.print_flag==1
    fprintf(1,'\n*************************************************************************\n');
    fprintf(1,'\n\n------>IMPORTANT!!: Most of the optimization solvers have their own\n');
    fprintf(1,'                    tunning parameters (options).\n');
    fprintf(1,'                    Defaults have been assigned in the *NLPsolver*_options\n');
    fprintf(1,'                    files. You may need to modify those settings for your\n');
    fprintf(1,'                    particular problem, specially:\n');
    fprintf(1,'                      - maximum number of function evaluations /iterations,\n');
    fprintf(1,'                      - maximum computational time\n');
    
    pause(2)
    
    fprintf(1,'\n\n******************************************************************');
    fprintf(1,'\n\n  Solving the NLP problem with');
    
end

switch inputs.model.exe_type
    
    case {'standard','costMex'}
        
        switch nlpsolver
            
            case 'de'
                
                if privstruct.print_flag==1
                    fprintf(1,'\t\t Global Optimizer: DIFFERENTIAL EVOLUTION (DE)\n');
                end
                
                if privstruct.print_flag==1
                    AMIGO_report_OPTsolver
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                end
                
                inputs.nlpsol.vguess=vguess;
                inputs.nlpsol.vmin=vmin;
                inputs.nlpsol.vmax=vmax;
                
                switch optproblem
                    case 'PE'
                        [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve,results.nlpsol.de_pop] = ...
                            AMIGO_DE('AMIGO_PEcost',inputs,results,privstruct);
                    case 'OED'
                        [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve,results.nlpsol.de_pop] = ...
                            AMIGO_DE('AMIGO_OEDcost',inputs,results,privstruct);
                end
                
            case 'sres'
                
                if privstruct.print_flag==1
                    fprintf(1,'\t\tGlobal Optimizer: STOCHASTIC RANKING EVOLUTIONARY SEARCH (SRES)\n');
                end
                
                inputs.nlpsol.vguess=vguess;
                inputs.nlpsol.vmin=vmin;
                inputs.nlpsol.vmax=vmax;
                
                if privstruct.print_flag==1
                    AMIGO_report_OPTsolver
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                end
                
                switch optproblem
                    
                    case 'PE'
                        [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve,results.nlpsol.sres_pop]= ...
                            AMIGO_SRES('sres_PEcost',inputs,results,privstruct);
                    case 'OED'
                        [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve,results.nlpsol.sres_pop]= ...
                            AMIGO_SRES('sres_OEDcost',inputs,results,privstruct);
                        
                end
                
                
            case 'globalm'
                
                if privstruct.print_flag==1
                    fprintf(1,'\t\tGlobal Optimizer: GLOBALm a clustering optimization method\n');
                end
                
                if(isempty(inputs.nlpsol.globalm.maxtime))
                    inputs.nlpsol.globalm.maxtime=50*length(vmin);
                end
                
                if(isempty(inputs.nlpsol.globalm.localmf))
                    inputs.nlpsol.globalm.localmf=200*length(vmin);
                end
                
                inputs.nlpsol.vguess=vguess;
                inputs.nlpsol.vmin=vmin;
                inputs.nlpsol.vmax=vmax;
                
                if privstruct.print_flag==1
                    
                    AMIGO_report_OPTsolver
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                    
                end
                
                switch optproblem
                    
                    case 'PE'
                        
                        [vbest,fbest,clusters,info] =...
                            globalm('globalm_PEcost',inputs.nlpsol.vguess',inputs.nlpsol.vmax',inputs.nlpsol.vmin',0,0,inputs.nlpsol.globalm,inputs,results,privstruct);
                        results.nlpsol.vbest=vbest(:,1)';
                        results.nlpsol.fbest=fbest(1,1);
                        results.nlpsol.clusters=clusters;
                        results.nlpsol.cpu_time=info.time;
                        results.nlpsol.conv_curve=[info.opthist(:,2) info.opthist(:,4)];
                        
                    case 'OED'
                        
                        [vbest,results.nlpsol.fbest,clusters,info] =...
                            globalm('globalm_OEDcost',inputs.nlpsol.vguess',inputs.nlpsol.vmax',inputs.nlpsol.vmin',0,0,inputs.nlpsol.nlp_opts.globalm,inputs,results,privstruct);
                        results.nlpsol.vbest=vbest(:,1)';
                        results.nlpsol.fbest=fbest(1,1);
                        results.nlpsol.clusters=clusters;
                        results.nlpsol.cpu_time=info.time;
                        results.nlpsol.conv_curve=[info.opthist(:,2) info.opthist(:,4)];
                        
                        
                end
                
            case {'ess','eSS'}
                
                %SSM has its own 'structures'.
                problem.x_0=vguess;
                problem.x_L=vmin;
                problem.x_U=vmax;
                
                if privstruct.print_flag==1
                    
                    AMIGO_report_OPTsolver
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                    
                end
                
                switch optproblem
                    
                    case 'PE'
                        
                        % objective function
                        problem.f='AMIGO_PEcost';
                        % jacobian of the objective function:
                        if ~isempty(inputs.PEsol.PEcostJac_type)
                            problem.fjac = 'AMIGO_PEJac';
                        end
                        
                    case 'OED'
                        
                        problem.f='AMIGO_OEDcost';
                        
                end
                
                
                
                if privstruct.ntotal_constraints >0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                    
                end
                
                if privstruct.ntotal_obsconstraints>0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                    
                end
                
                
                if  privstruct.ntotal_tsconstraints>0
                    while exist(inputs.pathd.ssconstraints_ts)==0
                        pause(1) 
                    end
                    eval(sprintf('%s',inputs.pathd.ssconstraints_ts))
                    
                end
                
                %eSS options are defined in inputs.nlpsol.eSS
                
                
                [res_ssm]=ess_kernel(problem,inputs.nlpsol.eSS,inputs,results,privstruct);
                results.nlpsol.fbest=res_ssm.fbest;
                results.nlpsol.vbest=res_ssm.xbest;
                results.nlpsol.cpu_time=res_ssm.cpu_time;
                results.nlpsol.conv_curve=[res_ssm.time;  res_ssm.f]';
                results.nlpsol.neval=res_ssm.neval;
                results.nlpsol.time=res_ssm.time;
                results.nlpsol.f=res_ssm.f;
                results.nlpsol.exit_flag = res_ssm.end_crit;
                
                results.nlpsol.bestit=res_ssm.x;
                
            case {'multistart'}
                
                problem.x_0=vguess; problem.x_L=vmin; problem.x_U=vmax;
                
                if privstruct.print_flag==1
                    AMIGO_report_OPTsolver
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                end
                
                switch optproblem
                    case 'PE'
                         % objective function
                        problem.f='AMIGO_PEcost';
                        % jacobian of the objective function:
                        if ~isempty(inputs.PEsol.PEcostJac_type)
                            problem.fjac = 'AMIGO_PEJac';
                        end
                    case 'OED'
                        problem.f='AMIGO_OEDcost';
                end
                
                if privstruct.ntotal_constraints >0
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                end
                
                if privstruct.ntotal_obsconstraints>0
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                end
                
                inputs.nlpsol.eSS.maxeval=inputs.nlpsol.multistart.maxeval;                                %Maximum number of function evaluations (Default 1000)
                inputs.nlpsol.eSS.maxtime=inputs.nlpsol.multistart.maxtime;                                %Maximum CPU time in seconds (Default 60)
                inputs.nlpsol.eSS.iterprint=inputs.nlpsol.multistart.iterprint;                            %Print each iteration on screen: 0-Deactivated 1-Activated (Default 1)
                inputs.nlpsol.eSS.local.solver=inputs.nlpsol.local_solver;                                 %Choose local solver: 'fmincon'(Default), 'fminsearch','n2fb', 'dhc', 'lsqnonlin','nl2sol'
                inputs.nlpsol.eSS.ndiverse=inputs.nlpsol.multi_starts;
                
                Results_multistart=ssm_multistart(problem,inputs.nlpsol.eSS,inputs,results,privstruct);
                results.nlpsol.fbest=Results_multistart.fbest;
                results.nlpsol.vbest=Results_multistart.xbest;
                results.nlpsol.cpu_time=Results_multistart.time;
                results.nlpsol.cpu_time_vector=Results_multistart.itime;
                results.nlpsol.func_vector_multistart=Results_multistart.func;
                results.nlpsol.v_vector_multistart=Results_multistart.xxx;
                results.nlpsol.f0 = Results_multistart.f0;
                results.nlpsol.conv_curve =  Results_multistart.convcurve;
                results.nlpsol.bestit = Results_multistart.bestit;
                results.nlpsol.exit_flag = Results_multistart.end_crit;
                
            case {'local'}
                
                if privstruct.print_flag==1
                    fprintf(1,'\t\t Local Optimizer: %s\n', inputs.nlpsol.local_solver);
                end
                
                problem.x_0=vguess; problem.x_L=vmin; problem.x_U=vmax;

                if privstruct.print_flag==1
                    AMIGO_report_OPTsolver
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                end
                
                switch optproblem
                    case 'PE'
                         % objective function
                        problem.f='AMIGO_PEcost';
                        % jacobian of the objective function:
                        if ~isempty(inputs.PEsol.PEcostJac_type)
                            problem.fjac = 'AMIGO_PEJac';
                        end
                    case 'OED'
                        problem.f='AMIGO_OEDcost';
                end
                
                if privstruct.ntotal_constraints >0
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                end
                
                if privstruct.ntotal_obsconstraints>0
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                end
                
                 if  privstruct.ntotal_tsconstraints>0
                    eval(sprintf('%s',inputs.pathd.ssconstraints_ts))  
                end
                
                inputs.nlpsol.eSS.maxeval=inputs.nlpsol.local.maxeval;                                %Maximum number of function evaluations (Default 1000)
                inputs.nlpsol.eSS.maxtime=inputs.nlpsol.local.maxtime;                                %Maximum CPU time in seconds (Default 60)
                inputs.nlpsol.eSS.iterprint=inputs.nlpsol.local.iterprint;                            %Print each iteration on screen: 0-Deactivated 1-Activated (Default 1)
                inputs.nlpsol.eSS.local.solver=inputs.nlpsol.local_solver;                      %Choose local solver: 'fmincon'(Default), 'fminsearch','n2fb', 'dhc', 'lsqnonlin'
                inputs.nlpsol.eSS.ndiverse=0;
                
                temp_cpu=cputime;
                Results_multistart=ssm_multistart(problem,inputs.nlpsol.eSS,inputs,results,privstruct);
                results.nlpsol.f = [Results_multistart.f0 Results_multistart.fbest];
                results.nlpsol.fbest=Results_multistart.fbest;
                results.nlpsol.vbest=Results_multistart.xbest;
                results.nlpsol.cpu_time=Results_multistart.time;
                results.nlpsol.neval=Results_multistart.nfuneval;
                
                fprintf(1,'\n Cost function: %f',results.nlpsol.fbest);
                fprintf(1,'\n Optimal solution:\n'); 
                results.nlpsol.vbest'
                
            case {'hybrid'}
                if privstruct.print_flag==1
                    fprintf(1,'\t\t SEQUENTIAL HYBRID: %s and %s. \n', inputs.nlpsol.global_solver, inputs.nlpsol.local_solver);end
                
                inputs.nlpsol.vguess=vguess;
                inputs.nlpsol.vmin=vmin;
                inputs.nlpsol.vmax=vmax;
                privstruct.global_solver=inputs.nlpsol.global_solver;
                
                switch inputs.nlpsol.global_solver
                    
                    case 'de'
                        
                        if privstruct.print_flag==1
                            AMIGO_report_OPTsolver
                            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report); end
                        switch optproblem
                            case 'PE'
                                [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve] = ...
                                    AMIGO_DE('AMIGO_PEcost',inputs,results,privstruct);
                            case 'OED'
                                [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve] = ...
                                    AMIGO_DE('AMIGO_OEDcost',inputs,results,privstruct);
                                
                                
                        end
                        
                    case 'sres'
                        
                        if privstruct.print_flag==1
                            AMIGO_report_OPTsolver
                            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end
                        switch optproblem
                            case 'PE'
                                [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve]= ...
                                    AMIGO_SRES('sres_PEcost',inputs,results,privstruct);
                            case 'OED'
                                [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve]= ...
                                    AMIGO_SRES('sres_OEDcost',inputs,results,privstruct);
                                
                        end
                end    % switch inputs.nlpsol.global_solver
                privstruct.global_solver='';
                % CALL LOCAL SOLVER FROM OPTIMUM FOUND
                
                if privstruct.print_flag==1
                    fprintf(1,'\t\t Calling local Optimizer: %s\n', inputs.nlpsol.local_solver);
                end
                
                problem.x_0=results.nlpsol.vbest; problem.x_L=vmin; problem.x_U=vmax;
                %opts=inputs.nlpsol.local_opts;
               
                opts.ndiverse=0;
                opts.local.solver=inputs.nlpsol.local_solver;
                opts.local.iterprint=1;
                %AMIGO_report_OPTsolver
                if privstruct.print_flag==1
                    AMIGO_report_guess_bounds(results.nlpsol.vbest,vmin,vmax,inputs.pathd.report);  end
                
                switch optproblem
                    case 'PE'
                        problem.f='AMIGO_PEcost';
                    case 'OED'
                        problem.f='AMIGO_OEDcost';
                        
                end
                if privstruct.ntotal_constraints >0
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                end
                Results_multistart=ssm_multistart(problem,opts,inputs,results,privstruct);
                results.nlpsol.fbest=Results_multistart.fbest; results.nlpsol.vbest=Results_multistart.xbest;
                results.nlpsol.cpu_time_local=Results_multistart.time;
                results.nlpsol.cpu_time=results.nlpsol.cpu_time+results.nlpsol.cpu_time_local;
                
                
            case 'usersolver'
                
                if privstruct.print_flag==1
                    fprintf(1,'\t\t User solver: %s\n',inputs.nlpsol.user_solver);
                end
                
                eval(sprintf('%s',privstruct.nlpsolver));
                
                
        end %switch opt_solver
        
    case 'fullMex'
        
        switch nlpsolver
            
            case 'local'
                
                switch inputs.nlpsol.local_solver
                    
                    case {'n2fb','dn2fb','local_dn2fb','local_n2fb'}
                        
                        %make sure this variable is not here
                        clear outputs;
                        init_time=cputime;
                        
                        feval(inputs.model.mexfunction,'pe_NL2SOL');
                        
                        results.sim.obs=outputs.observables;
                        results.nlpsol.cpu_time=cputime-init_time;
                        results.nlpsol.vbest=outputs.xbest;
                        results.nlpsol.fbest=outputs.fbest;
                        results.nlpsol.conv_curve=[];
                        results.nlpsol.neval=outputs.nfevals;
                        if privstruct.ntotal_constraints >0
                            eval(sprintf('%s',inputs.pathd.ssconstraints))
                        end
                        
                    otherwise
                        error('Failure in AMIGO_call_OPTsolver: solver not implemented in fullMex execution mode');
                        
                end
                
            case 'sres'
                
                switch optproblem
                    
                    case 'PE'
                        
                        if privstruct.ntotal_constraints >0
                            error('Failure in AMIGO_call_OPTsolver: Problems with constraints are not supported in fullMex execution mode.')
                        end
                        
                        init_time=cputime;
                        
                        clear outputs;
                        feval(inputs.model.mexfunction,'pe_SRES');
                        
                        results.sim.obs=outputs.observables;
                        results.nlpsol.cpu_time=cputime-init_time;
                        results.nlpsol.vbest=outputs.xbest;
                        results.nlpsol.fbest=outputs.fbest;
                        results.nlpsol.conv_curve=[];
                        
                        
                    case 'OED'
                        error('Failure in AMIGO_call_OPTsolver: OED problem are not supported in fullMex execution mode.')
                        
                        
                end
                
                
            case 'de'
                
                switch optproblem
                    
                    case 'PE'
                        
                        if privstruct.ntotal_constraints >0
                            error('Failure in AMIGO_call_OPTsolver: Problems with constraints are not supported in fullMex execution mode.')
                        end
                        
                        init_time=cputime;
                        
                        clear outputs;
                        
                        feval(inputs.model.mexfunction,'pe_DE');
                        
                        results.sim.obs=outputs.observables;
                        results.nlpsol.cpu_time=cputime-init_time;
                        results.nlpsol.vbest=outputs.xbest;
                        results.nlpsol.fbest=outputs.fbest;
                        results.nlpsol.conv_curve=[];
                        results.nlpsol.neval=outputs.nfevals;
                        
                    case 'OED'
                        
                        error('Failure in AMIGO_call_OPTsolver: OED problem are not supported in fullMex execution mode.')
                        
                end
                
            otherwise
                error('Failure in AMIGO_call_OPTsolver: solver not implemented in fullMex execution mode');
                
        end
        
    otherwise
        
        error('Failure in AMIGO_call_OPTsolver: execution mode not recognized.');
        
end%switch exetype


for i=1:size(results.nlpsol.vbest,2)
    
    results.nlpsol.act_bound(i)=0;
    
    if 100*((results.nlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 ||...
            100*((vmax(1,i)-results.nlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
        
        results.nlpsol.act_bound(1,i)=1;
        
    end
    
end

