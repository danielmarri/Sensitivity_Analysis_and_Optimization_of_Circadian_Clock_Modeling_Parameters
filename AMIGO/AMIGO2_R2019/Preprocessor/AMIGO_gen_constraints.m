% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_constraints.m 2204 2015-09-24 07:11:53Z evabalsa $
  function [results,inputs]=AMIGO_gen_OEDconst(inputs,results,privstruct);  
% AMIGO_gen_OEDconst: generates constraints for the OED problem
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
%  AMIGO_gen_OEDconst: generates constraints for OED                          %
%                    for the different optimizers                             %
%                    It should be noted that different solvers will require   %
%                    different information. Particular cases for the available%
%                    optimizers are included here                             %
%*****************************************************************************%



        results.pathd.problem_folder_path=strcat(results.pathd.results_path,filesep,results.pathd.results_folder);
        if isdir(results.pathd.problem_folder_path)==0  
        mkdir(strcat(inputs.pathd.AMIGO_path,filesep,results.pathd.problem_folder_path));
        end
        genpath(results.pathd.problem_folder_path)  
        results.pathd.constraints=strcat('AMIGO_constraints_',results.pathd.short_name);
        results.pathd.ssconstraints=strcat('AMIGO_constraints_',results.pathd.short_name,'_ss');
        results.pathd.constfile=strcat(inputs.pathd.AMIGO_path,filesep,results.pathd.problem_folder_path,filesep,results.pathd.constraints,'.m');
        results.pathd.ss_constfile=strcat(inputs.pathd.AMIGO_path,filesep,results.pathd.problem_folder_path,filesep,results.pathd.constraints,'_ss.m');

        


%
% Generates MATLAB code with the objective function + constraints supplied by user
% 
% 

    fid2=fopen(results.pathd.constfile,'w');
    fid3=fopen(results.pathd.ss_constfile,'w');

    fprintf(fid2,'%%\n%%Code generated by AMIGO to compute constraints for OED and PE\n%%\n');
   
    
    if privstruct.ntotal_constraints>0
        
    if numel(inputs.model.st_names)>0
    for i=1:inputs.model.n_st
         fprintf(fid2,'\t%s=privstruct.yteor(end,%u);\n',inputs.model.st_names(i,:),i);
    end
    end

    
    fprintf(fid2,'switch iexp\n');
    for iexp=1:inputs.exps.n_exp
    
    fprintf(fid2,'case %u\n',iexp);
   
    switch inputs.exps.u_type{iexp}
    case 'od'
    if numel(inputs.model.stimulus_names)>0
            
            for iu=1:inputs.model.n_stimulus
                fprintf(fid2,'\t%s=inputs.exps.u{%u};',inputs.model.stimulus_names(iu,:),iexp);
               
            end % iu=1:inputs.model.n_stimulus
    end % if numel(inputs.model.stimulus_names)>0
    end %switch inputs.exps.u_type{iexp}
    end %for iexp=1:inputs.exps.n_exp
    
      fprintf(fid2,'end\n');
    
    end % if privstruct.ntotal_constraints>0
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % CONSTRAINTS: END-POINT EQUALITY
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 
 
 
       
    % MOST METHODS HANDLE INEQUALITY CONSTRAINTS THUS WE WILL TRANSFORM 
    % EQUALITY CONSTRAINTS INTO INEQUALITIES WITH A TOLERANCE INTRODUCED
    % BY USER.
    fprintf(fid2,'\n%% Definition of constraints\n');
    ncons=0;
 
   
    if privstruct.n_const_eq_tf>0
        
        fprintf(fid3,'problem.neq=0;\n');     
        fprintf(fid2,'switch iexp\n');
        for iexp=1:inputs.exps.n_exp
            
        fprintf(fid2,'case %u\n',iexp);    
            if inputs.exps.n_const_eq_tf{iexp}>0  
            fprintf(fid2,'\n%% End-point equality constraints (transformed into inequalities) for experiment: %u\n',iexp);      
            for icons=1:inputs.exps.n_const_eq_tf{iexp}   
            fprintf(fid2,'\t hh{%u}(1,%u)=abs(%s);\n',iexp,icons,inputs.exps.const_eq_tf(icons,:));
            end
        
            % FOR DE WE NEED TO IMPLEMENT THE DEATH PENALTY
              switch inputs.nlpsol.nlpsolver
                case 'de'
                fprintf(fid2,'\n%% Death penalty for DE\n');   
                fprintf(fid2,'\nswitch inputs.nlpsol.nlpsolver\n');  
                fprintf(fid2,'\ncase ''de''\n');
                for icons=1:inputs.exps.n_const_eq_tf{iexp}  
                fprintf(fid2,'\t if hh{%u}(1,%u) >%f\n',iexp,icons,inputs.exps.eq_const_max_viol); 
                fprintf(fid2,'\t f=inf;\n');
                fprintf(fid2,'\t end;\n'); 
                end
                fprintf(fid2,'\t end;\n');
              end     
              
              switch inputs.nlpsol.global_solver
                case 'de'
                fprintf(fid2,'\n%% Death penalty for DE\n');   
                fprintf(fid2,'\nswitch inputs.nlpsol.global_solver\n');  
                fprintf(fid2,'\ncase ''de''\n');
                for icons=1:inputs.exps.n_const_eq_tf{iexp}  
                fprintf(fid2,'\t if hh{%u}(1,%u) >%f\n',iexp,icons,inputs.exps.eq_const_max_viol); 
                fprintf(fid2,'\t f=inf;\n');
                fprintf(fid2,'\t end;\n'); 
                end
                fprintf(fid2,'\t end;\n');
              end  
              
              
%               case {'ssm','ess','fssm','local','multistart'}
                %end %switch inputs.nlpsol.nlpsolver
            end  %if inputs.exps.n_const_eq_tf{iexp}>0   
        
            for icons=1:inputs.exps.n_const_eq_tf{iexp}
            fprintf(fid3,'problem.c_L(1,%u)=-%f;\n',icons+ncons,inputs.exps.eq_const_max_viol);
            fprintf(fid3,'problem.c_U(1,%u)=%f;\n',icons+ncons,inputs.exps.eq_const_max_viol);
            end  
        ncons=ncons+inputs.exps.n_const_eq_tf{iexp};        
        
    end % for iexp=1:inputs.exps.n_exp
    fprintf(fid2,'end\n');

    %fprintf(fid2,'\nh=cell2mat(hh);')    
    
    
    else
 
        fprintf(fid3,'problem.neq=0;\n');
        fprintf(fid2,'\th(1) =0;\n'); 
    end
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % CONSTRAINTS: END-POINT INEQUALITY
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    niqcons=ncons;
    
    if privstruct.n_const_ineq_tf>0
        fprintf(fid2,'switch iexp\n');
        for iexp=1:inputs.exps.n_exp
            
            fprintf(fid2,'case %u\n',iexp);
            
            if inputs.exps.n_const_ineq_tf{iexp}>0
            fprintf(fid2,'\n%% End-point inequality constraints for experiment %u\n',iexp);    
            for icons=1:inputs.exps.n_const_ineq_tf{iexp} 
            fprintf(fid2,'\thh{iexp}(1,%u) = %s;\n',icons,inputs.exps.const_ineq_tf{iexp}(icons,:)); 
            end
                switch inputs.nlpsol.nlpsolver 
                case 'de'    
                     fprintf(fid2,'\n%% Death penalty for DE\n');  
                      fprintf(fid2,'\t\tswitch inputs.nlpsol.nlpsolver\n ');
                      fprintf(fid2,'\t\tcase ''de''\n')
                      for icons=1:inputs.exps.n_const_ineq_tf{iexp} 
                        fprintf(fid2,'\t\tif hh{%u}(1,%u) > %f;\n',iexp,icons,inputs.exps.ineq_const_max_viol); 
                        fprintf(fid2,'\t\t f=inf;\n');
                        fprintf(fid2,'\t\t end;\n');
                      end
                      fprintf(fid2,'\t\t end;\n'); 
                end
                
                if isempty(inputs.nlpsol.global_solver)
                    inputs.nlpsol.global_solver=inputs.nlpsol.nlpsolver;
                end
                  
                switch inputs.nlpsol.global_solver 
                case 'de'    
                     fprintf(fid2,'\n%% Death penalty for DE\n');  
                      fprintf(fid2,'\t\tswitch inputs.nlpsol.global_solver \n ');
                      fprintf(fid2,'\t\tcase ''de''\n')
                      for icons=1:inputs.exps.n_const_ineq_tf{iexp} 
                        fprintf(fid2,'\t\tif hh{%u}(1,%u) > %f;\n',iexp,icons,inputs.exps.ineq_const_max_viol); 
                        fprintf(fid2,'\t\t f=inf;\n');
                        fprintf(fid2,'\t\t end;\n');
                      end
                      fprintf(fid2,'\t\t end;\n'); 
                end
                
                
            
            for icons=1:inputs.exps.n_const_ineq_tf{iexp}
            fprintf(fid3,'problem.c_L(1,%u)=-inf;\n',icons+niqcons);
            fprintf(fid3,'problem.c_U(1,%u)=%f;\n',icons+niqcons,inputs.exps.ineq_const_max_viol);
            end
            
            end
       
         niqcons=niqcons+inputs.exps.n_const_ineq_tf{iexp};
      

    end %   for iexp=1:inputs.exps.n_exp
    fprintf(fid2,'end\n');
    %fprintf(fid2,'\nh=cell2mat(hh);');
 
    
    else
 
    fprintf(fid3,'problem.ineq=0;\n');
    fprintf(fid2,'\th(1) =0;\n'); 
    end
    
    nucons=niqcons;
  
    if privstruct.n_control_const>0
    fprintf(fid2,'\n%% Constraints on the controls\n');
    fprintf(fid3,'problem.ineq=%u;\n',nucons+privstruct.n_control_const);
    fprintf(fid2','AMIGO_uinterp\n');
    fprintf(fid2,'switch iexp\n');
    for iexp=1:inputs.exps.n_exp
        fprintf(fid2,'case %u\n',iexp);
        if inputs.exps.n_control_const{iexp}>0
            for icons=1:inputs.exps.n_control_const{iexp} 
              fprintf(fid2,'\thh{%u}(%u,:) = %s;\n',iexp,icons,inputs.exps.control_const{iexp}(icons,:)); 
            end    
        end %if inputs.exps.n_control_const{iexp}>0
                   
     
            for icons=1:inputs.exps.n_control_const{iexp}
           fprintf(fid3,'problem.c_L(1,%u)=-inf;\n',icons+nucons);
            fprintf(fid3,'problem.c_U(1,%u)=%f;\n',icons+nucons,inputs.exps.control_const_max_viol);
            end
        
        nucons=nucons+inputs.exps.n_control_const{iexp};
        
    end % for iexp=1:inputs.exps.n_exp
  fprintf(fid2,'end\n');
 % fprintf(fid2,'\nhmat=cell2mat(hh);');
 % fprintf(fid2,'\nh=reshape(hmat, numel(hmat),1);');
     
     end %if privstruct.n_control_const>0
    
    
    
    
    
    fclose(fid2);
    fclose(fid3);
   
    
    fprintf(1,'\n\nThe following file has been created:\n')
    which(results.pathd.constraints)

    
return

  
        