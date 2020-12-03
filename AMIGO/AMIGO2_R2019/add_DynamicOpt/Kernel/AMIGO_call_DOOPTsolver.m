
%% Calls the optimization solver selected by user for OD
%
%  [results,privstruct]=AMIGO_call_ODOPTsolver(nlpsolver,vguess,vmin,vmax,
%                       inputs,results,privstruct);
% 
%  Arguments: nlpsolver (selected by user in call to AMIGO_OD)
%             vguess, vmin, vmax: initial guess, min and max values
%             generated from CVP in 
%             inputs,results,privstruct
%
% *Version details*
% 
%   AMIGO_OD version:     March 2013
%   Code development:     Eva Balsa-Canto
%   Address:              Process Engineering Group, IIM-CSIC
%                         C/Eduardo Cabello 6, 36208, Vigo-Spain
%   e-mail:               ebalsa@iim.csic.es 
%   Copyright:            CSIC, Spanish National Research Council
%
% *Brief description*
% 
%  AMIGO_call_ODOPTsolver: Calls the optimization solver selected by user
%  from the following alternatives
%                                                                            
%        LOCAL OPTIMIZATION SOLVERS
%        GLOBAL OPTIMIZATION SOLVERS
%                        
%           >'de': a modification of Differential Evolution which 
%                  incorporates a new stopping criterion
%                          
%           >'sres': Stochastic Ranking Evolutionary Search.
%                                                
%           >'ssm', 'fssm' and 'ess Scatter Search based methods
%
%           >'globalm': Clustering method for constrained global
%                       optimization
%                        
%           >'hyb_sres_*' sequential hybrid combining sres
%                           with available local solvers
%                           
%           >'hyb_de_*' sequential hybrid combining de with
%                       available local solvers 
%
%           >'nsga2': non sorting genetic algorithm II, to solve 
%                     Multi-objective problems
% 
% *References*
%
% * Storn R, Price K: Differential Evolution:a Simple and Efficient Heuristic 
%   for Global Optimization over Continuous Spaces. J Global Optim 1997,
%   11:341-359.
% * Runarsson T, Yao X: Stochastic ranking for constrained evolutionary optimization. 
%   IEEE Trans. Evolutionary Computation, 2000, 564:284-294.
% * Egea JA, Rodriguez-Fernandez M, Banga J, Marti R: Scatter Search for Chemical and 
%   Bio-Process Optimization. J Glob Opt 2007, 37(3):481-503.
% * Egea, J.A., E. Balsa-Canto, M.S.G. Garcia, J.R.Banga (2009). Dynamic Optimization of 
%   nonlinear Processes with an Enhanced Scatter Search. Ind. & Eng. Chem. Res. 48:4388-4401. 
% * Csendes, T., L. Pal, J.O.H. Sendin, J.R. Banga. (2008) The GLOBAL Optimization 
%   Method Revisited. Optimization Letters, 2(4):445-454.
% * K. Deb and Samir Agrawal and Amrit Pratap and T. Meyarivan. A Fast Elitist Non-Dominated 
%   Sorting Genetic Algorithm for Multi-Objective Optimization: {NSGA-II}, Parallel Problem 
%   Solving from Nature -- {PPSN VI}}, 849-858, M Schoenauer, K. Deb, G. Rudolph, X Yao, 
%   E Lutton, J J Merelo and Hans-Paul Schwefel Eds., Springer, 2000

%%


function [results,privstruct]=AMIGO_call_DOOPTsolver(nlpsolver,vguess,vmin,vmax,inputs,results,privstruct);
% AMIGO_call_ODOPTsolver:  Calls the optimization solver selected by user for OD 








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
           

        
        switch nlpsolver
                 
        case 'de'
            if privstruct.print_flag==1
            fprintf(1,'\t\t Global Optimizer: DIFFERENTIAL EVOLUTION (DE)\n'); 
            AMIGO_report_OPTsolver
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  
            end
                inputs.nlpsol.vguess=vguess;
                inputs.nlpsol.vmin=vmin;
                inputs.nlpsol.vmax=vmax;   
                cost_function=inputs.pathd.DO_function;
                [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve,results.nlpsol.de_pop] = ...
                AMIGO_DE(cost_function,inputs,results,privstruct);      
                    
            for i=1:size(results.nlpsol.vbest,2)
            results.nlpsol.act_bound(i)=0;
            if 100*((results.nlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 || 100*((vmax(1,i)-results.nlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
            results.nlpsol.act_bound(1,i)=1;
            end
                
            end 

    
        case 'sres'
            
            inputs.nlpsol.vguess=vguess;
            inputs.nlpsol.vmin=vmin;
            inputs.nlpsol.vmax=vmax;   
            
            if privstruct.print_flag==1
            fprintf(1,'\t\tGlobal Optimizer: STOCHASTIC RANKING EVOLUTIONARY SEARCH (SRES)\n');
            AMIGO_report_OPTsolver
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  
            end
                [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve,results.nlpsol.sres_pop]= ...
                AMIGO_SRES('sres_DOcost',inputs,results,privstruct);   
            for i=1:size(results.nlpsol.vbest,2)
            results.nlpsol.act_bound(i)=0;
            if 100*((results.nlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 || 100*((vmax(1,i)-results.nlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
            results.nlpsol.act_bound(1,i)=1;
            end
                
            end 
        
 
         case 'ssm'
            if privstruct.print_flag==1
            fprintf(1,'\t\t Global Optimizer: SCATTER SEARCH (SSm)\n');
            AMIGO_report_OPTsolver          
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end
            problem.x_0=vguess; problem.x_L=vmin; problem.x_U=vmax; 
            problem.f=inputs.pathd.DO_function;    
            eval(sprintf('%s',inputs.pathd.DO_constraints))
            [res_ssm]=ssm_kernel(problem,inputs.nlpsol.nlp_opts,inputs,results,privstruct); 
            results.nlpsol.fbest=res_ssm.fbest;
            results.nlpsol.vbest=res_ssm.xbest;
            results.nlpsol.cpu_time=res_ssm.cpu_time;
            results.nlpsol.conv_curve=[res_ssm.time;  res_ssm.f]';
            results.nlpsol.bestit=res_ssm.x;
            for i=1:size(results.nlpsol.vbest,2)
            results.nlpsol.act_bound(i)=0;
            if 100*((results.nlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 || 100*((vmax(1,i)-results.nlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
            results.nlpsol.act_bound(1,i)=1;
            end
                
            end 
        case 'fssm'           
            if privstruct.print_flag==1
            fprintf(1,'\t\t Global Optimizer: Fast SCATTER SEARCH (fSSm)\n');
            AMIGO_report_OPTsolver
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end
            problem.x_0=vguess;  problem.x_L=vmin; problem.x_U=vmax; 
            problem.f=inputs.pathd.DO_function;       
            eval(sprintf('%s',inputs.pathd.DO_constraints))
            [res_ssm]=fssm_kernel(problem,inputs.nlpsol.nlp_opts,inputs,results,privstruct); 
            results.nlpsol.fbest=res_ssm.fbest;
            results.nlpsol.vbest=res_ssm.xbest;
            results.nlpsol.cpu_time=res_ssm.cpu_time;
            results.nlpsol.conv_curve=[res_ssm.time;  res_ssm.f]';
            results.nlpsol.bestit=res_ssm.x;
            for i=1:size(results.nlpsol.vbest,2)
            results.nlpsol.act_bound(i)=0;
            if 100*((results.nlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 || 100*((vmax(1,i)-results.nlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
            results.nlpsol.act_bound(1,i)=1;
            end
                
            end 
      case {'ess','eSS'}           
            if privstruct.print_flag==1
            fprintf(1,'\t\t Global Optimizer: Enhanced SCATTER SEARCH (eSS)\n');
            AMIGO_report_OPTsolver
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end
      
            problem.x_0=vguess;  problem.x_L=vmin; problem.x_U=vmax; 
            problem.f=inputs.pathd.DO_function; 

            eval(sprintf('%s',inputs.pathd.DO_constraints))
           %eSS options are defined in inputs.nlpsol.eSS
            [res_ssm]=ess_kernel(problem,inputs.nlpsol.eSS,inputs,results,privstruct); 
            results.nlpsol.fbest=res_ssm.fbest;
            results.nlpsol.vbest=res_ssm.xbest;
            results.nlpsol.cpu_time=res_ssm.cpu_time;
            results.nlpsol.conv_curve=[res_ssm.time;  res_ssm.f]';    
            for i=1:size(results.nlpsol.vbest,2)
            results.nlpsol.act_bound(i)=0;
            if 100*((results.nlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 || 100*((vmax(1,i)-results.nlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
            results.nlpsol.act_bound(1,i)=1;
            end
                
            end 
                        
            
         case 'globalm'
            if privstruct.print_flag==1
            fprintf(1,'\t\tGlobal Optimizer: GLOBALm a clustering optimization method\n');
            AMIGO_report_OPTsolver
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  
            end

                        
                inputs.nlpsol.vguess=vguess;
                inputs.nlpsol.vmin=vmin;
                inputs.nlpsol.vmax=vmax; 
                cost_function=inputs.pathd.DO_function;   
                eval(sprintf('%s',inputs.pathd.DO_constraints))
                [vbest,results.nlpsol.fbest,clusters,info] =...
                globalm('globalm_DOcost',inputs.nlpsol.vguess',inputs.nlpsol.vmax',inputs.nlpsol.vmin',0,0,inputs.nlpsol.nlp_opts,inputs,results,privstruct);
                results.nlpsol.vbest=vbest(:,1)';
                results.nlpsol.fbest=fbest(1,1);
                results.nlpsol.clusters=clusters;
                results.nlpsol.cpu_time=info.time;
                results.nlpsol.conv_curve=[info.opthist(:,2) info.opthist(:,4)]; 
                           for i=1:size(results.nlpsol.vbest,2)
            results.nlpsol.act_bound(i)=0;
            if 100*((results.nlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 || 100*((vmax(1,i)-results.nlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
            results.nlpsol.act_bound(1,i)=1;
            end
                
            end  
                
         case 'monlot'
            if privstruct.print_flag==1
            fprintf(1,'\t\tMulti-objective global Optimizer: MONLOT, finds utopia solution and pareto front\n');end
            if(isempty(inputs.nlpsol.options_file)==1)   
            [inputs.nlpsol.nlp_opts]=monlot_options(size(vguess,2));
            else
            [inputs.nlpsol.nlp_opts]=feval(inputs.nlpsol.options_file);
            end
            if privstruct.print_flag==1    
            AMIGO_report_OPTsolver
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end
              
                        
            inputs.nlpsol.nlp_opts.U.x0=vguess;
            inputs.nlpsol.nlp_opts.lowerb=vmin;
            inputs.nlpsol.nlp_opts.upperb=vmax; 
            inputs.nlpsol.nlp_opts.nvars=size(vguess,2);
            inputs.nlpsol.nlp_opts.ninteg=0;
            inputs.nlpsol.nlp_opts.nbin=0;
            inputs.nlpsol.nlp_opts.nobjs=inputs.DOsol.N_DOcost;
            inputs.nlpsol.nlp_opts.fun=inputs.pathd.DO_function; 
            inputs.nlpsol.nlp_opts.probname='prob';
            inputs.nlpsol.nlp_opts.neq=0;
            inputs.nlpsol.nlp_opts.nineq=results.nlpsol.ntotalconstraints;
            
            [xPareto,fPareto,optInfo] = monlotm(inputs.nlpsol.nlp_opts,inputs,results,privstruct);

            
            case 'nsga2'   
            if privstruct.print_flag==1
            fprintf(1,'\t\tMulti-objective global Optimizer: NSGA2\n');end
%             if(isempty(inputs.nlpsol.options_file)==1)   
%             [inputs.nlpsol.nlp_opts]=nsga2_options(size(vguess,2));
%             else
%             [inputs.nlpsol.nlp_opts]=feval(inputs.nlpsol.options_file);
%             end
                        
            if privstruct.print_flag==1    
            AMIGO_report_OPTsolver
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end

            inputs.nlpsol.nsga2.lb=vmin;
            inputs.nlpsol.nsga2.ub=vmax; 
            inputs.nlpsol.nsga2.x0=vguess;
            inputs.nlpsol.nsga2.numVar=size(vguess,2);
            inputs.nlpsol.nsga2.numObj=inputs.DOsol.N_DOcost;
            inputs.nlpsol.nsga2.numCons=results.nlpsol.ntotalconstraints;
            inputs.nlpsol.nsga2.objfun=inputs.pathd.DO_function;     
            inputs.nlpsol.nsga2.nameObj=inputs.DOsol.DOcost;
            
    
            [res_nsga2] = nsga2(inputs.nlpsol.nsga2,inputs,results,privstruct);
            results.nlpsol.cpu_time=res_nsga2.states(inputs.nlpsol.nsga2.maxGen).totalTime;
            results.nlpsol.n_firstParetoFront=0;
            for ipop=1:inputs.nlpsol.nsga2.popsize
                if res_nsga2.pops(inputs.nlpsol.nsga2.maxGen,ipop).rank==1
                results.nlpsol.pareto_obj(ipop,:)=res_nsga2.pops(inputs.nlpsol.nsga2.maxGen,ipop).obj;
                results.nlpsol.pareto_vbest(ipop,:)=res_nsga2.pops(inputs.nlpsol.nsga2.maxGen,ipop).var;
                results.nlpsol.n_firstParetoFront=results.nlpsol.n_firstParetoFront+1;           
                end
            end
            


         case {'multistart'}
            if privstruct.print_flag==1
             fprintf(1,'\t\tMultistart of the local solver: %s\n',  inputs.nlpsol.local_solver);end
            problem.x_0=vguess; problem.x_L=vmin; problem.x_U=vmax; 
            opts=inputs.nlpsol.nlp_opts;
            opts.ndiverse=inputs.nlpsol.multi_starts;
            opts.local.solver=inputs.nlpsol.local_solver;
            opts.local.iterprint=1;
            if privstruct.print_flag==1
            AMIGO_report_OPTsolver 
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report); end 

                problem.f=inputs.pathd.DO_function;  
                eval(sprintf('%s',inputs.pathd.DO_constraints))
   
            Results_multistart=ssm_multistart(problem,opts,inputs,results,privstruct);
            results.nlpsol.fbest=Results_multistart.fbest; results.nlpsol.vbest=Results_multistart.xbest;
            results.nlpsol.cpu_time=Results_multistart.time;
            results.nlpsol.func_vector_multistart=Results_multistart.func;  
            results.nlpsol.v_vector_multistart=Results_multistart.xxx;
     

             
         case {'local'}
        
            if privstruct.print_flag==1
            fprintf(1,'\t\t Local Optimizer: %s\n', inputs.nlpsol.local_solver);   end
      
            problem.x_0=vguess; problem.x_L=vmin; problem.x_U=vmax; 
            opts=inputs.nlpsol.eSS;
            opts.ndiverse=0;
            opts.local.solver=inputs.nlpsol.local_solver;
            opts.local.iterprint=1;
            if privstruct.print_flag==1
            AMIGO_report_OPTsolver 
            AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end

                problem.f=inputs.pathd.DO_function; 
                eval(sprintf('%s',inputs.pathd.DO_constraints))
           
            Results_multistart=ssm_multistart(problem,opts,inputs,results,privstruct);
    
            results.nlpsol.fbest=Results_multistart.fbest; results.nlpsol.vbest=Results_multistart.xbest;
            results.nlpsol.cpu_time=Results_multistart.time;
             

            
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
    
                        cost_function=inputs.pathd.DO_function;
                        [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve] = ...
                        AMIGO_DE(cost_function,inputs,results,privstruct);      

                                              
                    case 'sres'                     
                         if privstruct.print_flag==1
                        AMIGO_report_OPTsolver
                        AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);  end

                        [results.nlpsol.vbest,results.nlpsol.fbest,results.nlpsol.nfeval,results.nlpsol.cpu_time,results.nlpsol.conv_curve]= ...
                        AMIGO_SRES('sres_DOcost',inputs,results,privstruct);      
                               
                 end    % switch inputs.nlpsol.global_solver

           % CALL LOCAL SOLVER FROM OPTIMUM FOUND
           
            privstruct.global_solver='';
           if privstruct.print_flag==1
            fprintf(1,'\t\t Calling local Optimizer: %s\n', inputs.nlpsol.local_solver);  end  
      
            problem.x_0=results.nlpsol.vbest; problem.x_L=vmin; problem.x_U=vmax; 
            opts=inputs.nlpsol.nlp_opts;
            opts.ndiverse=1;
            opts.local.solver=inputs.nlpsol.local_solver;
            opts.local.iterprint=1;
            %AMIGO_report_OPTsolver 
            if privstruct.print_flag==1
            AMIGO_report_guess_bounds(results.nlpsol.vbest,vmin,vmax,inputs.pathd.report);  end

                problem.f=inputs.pathd.DO_function; 
                eval(sprintf('%s',inputs.pathd.DO_constraints))
                
   
            Results_multistart=ssm_multistart(problem,opts,inputs,results,privstruct);
            results.nlpsol.fbest=Results_multistart.fbest; results.nlpsol.vbest=Results_multistart.xbest;
            results.nlpsol.cpu_time_local=Results_multistart.time;
            results.nlpsol.cpu_time=results.nlpsol.cpu_time+results.nlpsol.cpu_time_local;
            
            
            
            case 'usersolver'
            if privstruct.print_flag==1
            fprintf(1,'\t\t User solver: %s\n',inputs.nlpsol.user_solver); end
  
            eval(sprintf('%s',privstruct.nlpsolver));    
                        

                
        end 
        end % switch opt_solver

       


        