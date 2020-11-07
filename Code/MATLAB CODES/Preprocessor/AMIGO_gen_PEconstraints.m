% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_PEconstraints.m 2481 2016-01-29 13:55:14Z evabalsa $
  function [results,inputs]=AMIGO_gen_PEconstraints(inputs,results,privstruct);  
% AMIGO_gen_PEconstraints: generates constraints for the PE problem
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



        inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);
        if isdir(inputs.pathd.problem_folder_path)==0  
        mkdir(strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path));
        end
        genpath(inputs.pathd.problem_folder_path)  
        inputs.pathd.constraints=strcat('AMIGO_constraints_',inputs.pathd.short_name);
        inputs.pathd.ssconstraints=strcat('AMIGO_constraints_',inputs.pathd.short_name,'_ss');
        inputs.pathd.constfile=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path,filesep,inputs.pathd.constraints,'.m');
        inputs.pathd.ss_constfile=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path,filesep,inputs.pathd.constraints,'_ss.m');

        


%
% Generates MATLAB code with the objective function + constraints supplied by user
% 
% 

    fid3=fopen(inputs.pathd.ss_constfile,'w');

    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % CONSTRAINTS: END-POINT EQUALITY
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
       
    % MOST METHODS HANDLE INEQUALITY CONSTRAINTS THUS WE WILL TRANSFORM 
    % EQUALITY CONSTRAINTS INTO INEQUALITIES WITH A TOLERANCE INTRODUCED
    % BY USER.
     ncons=0;
    
    if sum(cell2mat(inputs.exps.n_const_eq_tf))>0
        
        fprintf(fid3,'problem.neq=0;\n');     
        
        for iexp=1:inputs.exps.n_exp

            for icons=1:inputs.exps.n_const_eq_tf{iexp}
            fprintf(fid3,'problem.c_L(1,%u)=-%f;\n',icons+ncons,inputs.exps.eq_const_max_viol);
            fprintf(fid3,'problem.c_U(1,%u)=%f;\n',icons+ncons,inputs.exps.eq_const_max_viol);
            end  
        ncons=ncons+inputs.exps.n_const_eq_tf{iexp};        
        
    end % for iexp=1:inputs.exps.n_exp
    
    else
 
        fprintf(fid3,'problem.neq=0;\n');
    end
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % CONSTRAINTS: END-POINT INEQUALITY
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    niqcons=ncons;
    
    if sum(cell2mat(inputs.exps.n_const_ineq_tf))>0
        
        for iexp=1:inputs.exps.n_exp
              
            
            for icons=1:inputs.exps.n_const_ineq_tf{iexp}
            fprintf(fid3,'problem.c_L(1,%u)=-inf;\n',icons+niqcons);
            fprintf(fid3,'problem.c_U(1,%u)=%f;\n',icons+niqcons,inputs.exps.ineq_const_max_viol);
            end
            
     
         niqcons=niqcons+inputs.exps.n_const_ineq_tf{iexp};
      

        end %   for iexp=1:inputs.exps.n_exp

    else
 
    fprintf(fid3,'problem.ineq=0;\n');

    end

    fclose(fid3);
   
    
    fprintf(1,'\n\nThe following file has been created:\n')
    which(inputs.pathd.ss_constfile)

    
return

  
        