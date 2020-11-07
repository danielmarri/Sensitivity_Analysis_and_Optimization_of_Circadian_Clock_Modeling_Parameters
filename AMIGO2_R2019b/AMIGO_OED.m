
function [results]=AMIGO_OED(input_file,run_ident,opt_solver);
% AMIGO_OED: performs optimal experimental design 
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
% AMIGO_OED: performs optimal experimental design based on the FIM            %
%          -Intended to compute:                                              %
%                                                                             %
%                   - Optimal stimuli profile: sustained, pulse or step-wise  %
%                   - Optimal sampling times                                  %
%                   - Optimal duration of the experiments                     %
%                                                                             %
%          -Several experiments can be sumultaneously designed                %
%          -Sequential and parallel design are possible                       %
%          -The following types of designs are available                      %
%                A_optimality:  minimize trace(inv(FIM))                      %
%                D_optimality:  maximize  det(FIM)                            %
%                E_optimality:  maximize  min(eig(FIM))                       %
%                E_modified:    minimize max(eig(FIM))/min(eig(FIM))          %  
%                                                                             %
%          -Several local and global optimization methods may be used:        %
%                                                                             %
%               LOCAL optimization methods:                                   %
%
%
%               GLOBAL optimization methods:                                  %
%
%
%               MULTISTART of local methods:                                  %
%                                                                             %
%               > usage:  AMIGO_OED('input_file',options)                     %   
%                                                                             %  
%               > options: 'run_identifier' to keep different folders for     %
%                          different runs, this avoids overwriting            %
%                         'nlp_solver' to rapidly change the optimization mth %
%                                                                             %
%                                                                             % 
%               > usage examples:  AMIGO_PE('NFKB_PE')                        % 
%                                  AMIGO_RIdent('NFKB_PE','r1')               % 
%                                  AMIGO_RIdent('NFKB_PE','r2')               % 
%                                  AMIGO_RIdent('NFKB_PE','r1','ssm')         % 
%                                  AMIGO_RIdent('NFKB_PE','r1','de')          %
%            ****                                                             %
%            *    Details on how the Optimal experimental design is formulated%
%            *    and solved may be found in:                                 %
%            *    Balsa-Canto, E., A.A. Alonso and J.R. Banga                 %
%            *    Computational Procedures for Optimal Experimental Design in %
%            *    Biological Systems. IET Systems Biology, 2(4):163-172, 2008 %
%            ****                                                             %
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_OED.m 2305 2015-11-25 08:20:26Z evabalsa $
    close all;

%
%   Checks for necessary arguments
%
    

if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end
    
%
%   AMIGO_PE header
%

    AMIGO_report_header    

  
        
%
%  Starts Check of inputs
%
    fprintf(1,'\n\n------>Checking inputs....\n')
   
%    
%   Reads defaults    
%    

    [inputs_def]= AMIGO_private_defaults;
   
    [inputs_def]= AMIGO_public_defaults(inputs_def);

    
%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else

    inputs_def.pathd.runident=inputs_def.pathd.runident;
end


       
%
%   Reads inputs 
%
 
    [inputs,results]=AMIGO_check_model(input_file,inputs_def); %,results_def 
   
    [inputs]=AMIGO_check_obs(inputs);  

    [inputs]=AMIGO_check_OED_data(inputs,results); 

   %%%% INTRODUCIR CHECK DE DATOS DE EXP SCHEME
    
    privstruct=inputs.exps;

      
    if nargin>2
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,opt_solver,privstruct);    
    else
    [inputs,privstruct]=AMIGO_check_NLPsolver(inputs,inputs.nlpsol.nlpsolver,privstruct);   
    end
        

%   DETECTS PATH
%
    AMIGO_path    
       

%
%   Generates matlab file to compute observables
%
    AMIGO_gen_obs(inputs,results);
      
%
%   Creates necessary paths
%

    AMIGO_paths_OED    
	AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)


	
%
%   Memory allocation and some necesary assignements
%

    AMIGO_init_OED_guess_bounds


%
%   Generates matlab files for constraints
%


    privstruct.n_const_ineq_tf=sum(cell2mat(inputs.exps.n_const_ineq_tf));
    privstruct.n_const_eq_tf=sum(cell2mat(inputs.exps.n_const_eq_tf));
    privstruct.n_control_const=sum(cell2mat(inputs.exps.n_control_const));
    privstruct.ntotal_constraints= privstruct.n_const_ineq_tf+privstruct.n_const_eq_tf+privstruct.n_control_const;
    if privstruct.ntotal_constraints >0
    [results]=AMIGO_gen_constraints(inputs,results,privstruct);
    end
    privstruct.ntotal_obsconstraints=inputs.OEDsol.n_obs_od; 
    privstruct.ntotal_tsconstraints=inputs.OEDsol.n_ts_od;



    
%********************************************************************************************************
% 
%   Solves the optimal experimental design problem
% 
%


     privstruct.print_flag=1;

    % First identify the number of fixed experiments
    inputs.exps.n_fixed_exp=0;
    for iexp=1:inputs.exps.n_exp
    if strcmp(inputs.exps.exp_type{iexp},'fixed')  
   	inputs.exps.n_fixed_exp=inputs.exps.n_fixed_exp+1;
    end
    end

    % Computes FIM for the fixed experiments, this will be used to save
    % simulations during the optimization
        
        privstruct.oed=inputs.OEDsol.voed_guess;
        [privstruct,inputs]=AMIGO_transform_oed(inputs,results,privstruct);  
        
        inputs.exps.n_s=privstruct.n_s;  
        nt_gtheta=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
        privstruct.g_fixedFIM=zeros(nt_gtheta);
        
        if inputs.exps.n_fixed_exp>=1
        [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,1,inputs.exps.n_fixed_exp);    
        
        privstruct.g_fixedFIM=results.fit.g_FIM;

        else
            
        privstruct.g_fixedFIM=zeros(nt_gtheta,nt_gtheta);    
        end
        
        
          

     % Generates constraint file for the case of designing observables
     
     if inputs.OEDsol.n_obs_od>0
        
        inputs.pathd.ssconstraints_obs=strcat('AMIGO_constraints_obs_',inputs.pathd.short_name,'_ss');
        inputs.pathd.ss_obsconstfile=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path,filesep,inputs.pathd.ssconstraints_obs,'.m'); 
 
        fid3=fopen(inputs.pathd.ss_obsconstfile,'w');
        fprintf(fid3,'problem.neq=0;\n');
        for icons=1:inputs.OEDsol.n_obs_od
            fprintf(fid3,'problem.c_L(1,%u)=-inf;\n',icons+privstruct.ntotal_constraints);
            fprintf(fid3,'problem.c_U(1,%u)=%f;\n',icons+privstruct.ntotal_constraints,1e-20);
        end
        fclose(fid3);
     end
     
     
     % Generates constraint file for the case of designing sampling
     % times

      if inputs.OEDsol.n_ts_od>0
        
        inputs.pathd.ssconstraints_ts=strcat('AMIGO_constraints_ts_',inputs.pathd.short_name,'_ss');
        inputs.pathd.ss_tsconstfile=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path,filesep,inputs.pathd.ssconstraints_ts,'.m');
        fid3=fopen(inputs.pathd.ss_tsconstfile,'w');
        fprintf(fid3,'problem.neq=0;\n');
        for icons=1:inputs.OEDsol.n_ts_od
        fprintf(fid3,'problem.c_L(1,%u)=-inf;\n',icons+privstruct.ntotal_constraints+privstruct.ntotal_obsconstraints);
        fprintf(fid3,'problem.c_U(1,%u)=%f;\n',icons+privstruct.ntotal_constraints+privstruct.ntotal_obsconstraints,1e-20);
        end
        fclose(fid3);
      end  
  
     
     
     % Calls optimization    
     
     [results,privstruct]=AMIGO_call_OPTsolver('OED',inputs.nlpsol.nlpsolver,inputs.OEDsol.voed_guess,inputs.OEDsol.voed_min,inputs.OEDsol.voed_max,inputs,results,privstruct);      
      privstruct.oed=results.nlpsol.vbest;
     [privstruct,inputs]=AMIGO_transform_oed(inputs,results,privstruct);  
     [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,inputs.exps.n_fixed_exp+1,inputs.exps.n_exp);
     results.oed.n_exp=privstruct.n_exp;
     results.oed.n_obs=privstruct.n_obs(1:inputs.exps.n_exp);
     results.oed.obs=privstruct.obs(1:inputs.exps.n_exp);
     results.oed.n_s=privstruct.n_s;
     results.oed.t_f=privstruct.t_f;
     results.oed.t_s=privstruct.t_s;
     results.oed.u=privstruct.u(1:inputs.exps.n_exp);
     results.oed.t_con=privstruct.t_con;
     results.oed.exp_y0=privstruct.y_0;
     results.oed.w_sampling=privstruct.w_sampling;
     results.oed.sens_t=privstruct.sens_t;
     results.oed.r_sens_t=privstruct.r_sens_t;
     results.oed.ms=privstruct.ms;   
     results.oed.g_FIM=results.fit.g_FIM;
     results.oed.g_corr_mat=results.fit.g_corr_mat;
     results.oed.w_obs=privstruct.w_obs;
     AMIGO_smooth_simulation 
     
     if privstruct.ntotal_constraints >0
     [f,h,g] = AMIGO_OEDcost(privstruct.oed,inputs,results,privstruct);
     results.oed.constraints_viol=h;
     end
    
     
     [results,privstruct]= AMIGO_post_report_OED(inputs,results,privstruct);
     
     results.oed.conf_intervals=1.96.*privstruct.rho;
     
        switch results.plotd.plotlevel    
        case {'full','medium','min'}
             AMIGO_post_plot_OED(inputs,results,privstruct);
        otherwise
        fprintf(1,'\n------>No plots are being generated, since results.plotd.plotlevel=''noplot''.\n');
        fprintf(1,'         Change results.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
        end
      

    
%********************************************************************************************************
%
% SAVES STRUCTURE WITH USEFUL DATA
%
  
  AMIGO_del_OED
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