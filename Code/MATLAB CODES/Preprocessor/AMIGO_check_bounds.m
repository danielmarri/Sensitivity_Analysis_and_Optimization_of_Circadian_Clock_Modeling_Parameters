% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_bounds.m 770 2013-08-06 09:41:45Z attila $
function [inputs]= AMIGO_check_bounds(inputs);
% AMIGO_check_bounds: Checks definitions of bounds for the unknowns 
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
% AMIGO_check_bounds: Checks definitions of bounds for the unknowns           % 
%                                                                             %
%*****************************************************************************%  




%   GLOBAL PARAMETERS


     if isempty(inputs.PEsol.global_theta_max)==1 && isempty(inputs.PEsol.global_theta_guess)==0
       
        fprintf(1,'\n\n------> WARNING message\n\n');    
        fprintf(1,'\t\t The maximum value for the global parameters has not been specified: inputs.PEsol.global_theta_max,\n');
        fprintf(1,'\t\t By default we will consider 1e12. Note that you should update your input file with reasonable values.\n');
        inputs.PEsol.global_theta_max=1e12.*ones(1,size(inputs.PEsol.id_global_theta,1));
     end
    
     if isempty(inputs.PEsol.global_theta_min)==1 && isempty(inputs.PEsol.global_theta_guess)==0
       
        fprintf(1,'\n\n------> WARNING message\n\n');    
        fprintf(1,'\t\t The minimum value for the global parameters has not been specified: inputs.PEsol.global_theta_max,\n');
        fprintf(1,'\t\t By default we will consider 0. Note that you should update your input file with reasonable values.\n');
        inputs.PEsol.global_theta_min=0.*ones(1,size(inputs.PEsol.id_global_theta,1));
     end
    
     
     if isempty(inputs.PEsol.global_theta_guess)==1
        inputs.PEsol.global_theta_guess=0.5.*(inputs.PEsol.global_theta_max-inputs.PEsol.global_theta_min);
     end
     
     
    if size(inputs.PEsol.global_theta_guess,2)~=size(inputs.PEsol.id_global_theta,1)
        fprintf(1,'\n\n------> ERROR message\n\n');    
        fprintf(1,'\t\t The dimension of the initial guess does not coincide with the number of global parameters\n');
        fprintf(1,'\t\t inputs.PEsol.global_theta_guess should be corrected.\n');
        error('error_bounds_001','\t\t Impossible to continue. Stopping.\n');
    end
     
     if size(inputs.PEsol.global_theta_max,2)~=size(inputs.PEsol.id_global_theta,1)
        fprintf(1,'\n\n------> ERROR message\n\n');    
        fprintf(1,'\t\t The dimension of the upper bounds for global parameters does not coincide with the number\n of global parameters\n');
        fprintf(1,'\t\t inputs.PEsol.global_theta_max should be corrected.\n');
        error('error_bounds_002','\t\t Impossible to continue. Stopping.\n');
    end
    if size(inputs.PEsol.global_theta_min,2)~=size(inputs.PEsol.id_global_theta,1)
        fprintf(1,'\n\n------> ERROR message\n\n');    
        fprintf(1,'\t\t The dimension of the lower bounds for global parameters does not coincide with the number\n of global parameters\n');
        fprintf(1,'\t\t inputs.PEsol.global_theta_min should be corrected.\n');
        error('error_bounds_003','\t\t Impossible to continue. Stopping.\n');
    end
    
     if sum(inputs.PEsol.global_theta_max < inputs.PEsol.global_theta_min)>=1
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t Upper bound for global parameters is lower than the lower bound\n');
            fprintf(1,'\t\t inputs.PEsol.global_theta_max / min  should be corrected.\n');
            error('error_bounds_013','\t\t Impossible to continue. Stopping.\n');
     end    
            
     if sum(inputs.PEsol.global_theta_guess > inputs.PEsol.global_theta_max)>=1 || sum(inputs.PEsol.global_theta_guess < inputs.PEsol.global_theta_min)>=1 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t The initial guess for global parameters is outside the bounds\n');
            fprintf(1,'\t\t inputs.PEsol.global_theta_guess should be corrected.\n');
            error('error_bounds_014','\t\t Impossible to continue. Stopping.\n');
     end 
    
     
     
%   GLOBAL INTIAL CONDITIONS
     
     switch inputs.PEsol.id_global_theta_y0
         
         case 'none'
         otherwise    
            if isempty(inputs.PEsol.global_theta_y0_max)==1
            fprintf(1,'\n\n------> WARNING message\n\n');    
            fprintf(1,'\t\t The maximum value for the global parameters has not been specified: inputs.PEsol.global_theta_max,\n');
            fprintf(1,'\t\t By default: 1e12. Note that you should update your input file with reasonable values.\n');
            inputs.PEsol.global_theta_y0_max=1e12.*ones(1,size(inputs.PEsol.id_global_theta_y0,1));
            end
    
            if isempty(inputs.PEsol.global_theta_y0_min)==1
            fprintf(1,'\n\n------> WARNING message\n\n');    
            fprintf(1,'\t\t The minimum value for the global parameters has not been specified: inputs.PEsol.global_theta_max,\n');
            fprintf(1,'\t\t By default: 0. Note that you should update your input file with reasonable values.\n');
            inputs.PEsol.global_theta_y0_min=0.*ones(1,size(inputs.PEsol.id_global_theta_y0,1));
            end
    
            if isempty(inputs.PEsol.global_theta_y0_guess)==1
            inputs.PEsol.global_theta_y0_guess=0.5.*(inputs.PEsol.global_theta_y0_max-inputs.PEsol.global_theta_y0_min);
            end
        
            if size(inputs.PEsol.global_theta_y0_guess,2)~=size(inputs.PEsol.id_global_theta_y0,1)
            fprintf(1,'\n\n------> ERROR message\n\n');    
            fprintf(1,'\t\t The dimension of the initial guess does not coincide with the number of global initial conditions\n');
            fprintf(1,'\t\t inputs.PEsol.global_theta_y0_guess should be corrected.\n');
            error('error_bounds_004','\t\t Impossible to continue. Stopping.\n');
            end
     
            if size(inputs.PEsol.global_theta_y0_max,2)~=size(inputs.PEsol.id_global_theta_y0,1)
            fprintf(1,'\n\n------> ERROR message\n\n');    
            fprintf(1,'\t\t The dimension of the upper bounds for global initial conditions does not coincide with the number\n of global initial conditions\n');
            fprintf(1,'\t\t inputs.PEsol.global_theta_y0_max should be corrected.\n');
            error('error_bounds_005','\t\t Impossible to continue. Stopping.\n');
            end
         
            if size(inputs.PEsol.global_theta_y0_min,2)~=size(inputs.PEsol.id_global_theta_y0,1)
            fprintf(1,'\n\n------> ERROR message\n\n');    
            fprintf(1,'\t\t The dimension of the upper bounds for global initial conditions does not coincide with the number\n of global initial conditions\n');
            fprintf(1,'\t\t inputs.PEsol.global_theta_y0_min should be corrected.\n');
            error('error_bounds_006','\t\t Impossible to continue. Stopping.\n');
            end
            
     if sum(inputs.PEsol.global_theta_y0_max < inputs.PEsol.global_theta_y0_min)>=1
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t Upper bound for global parameters is lower than the lower bound\n');
            fprintf(1,'\t\t inputs.PEsol.global_theta_y0_max / min  should be corrected.\n');
            error('error_bounds_015','\t\t Impossible to continue. Stopping.\n');
     end    
            
     if sum(inputs.PEsol.global_theta_y0_guess > inputs.PEsol.global_theta_y0_max)>=1 || sum(inputs.PEsol.global_theta_y0_guess < inputs.PEsol.global_theta_y0_min)>=1 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t The initial guess for global initial conditions outside the bounds\n');
            fprintf(1,'\t\t inputs.PEsol.global_theta_y0_guess should be corrected.\n');
            error('error_bounds_016','\t\t Impossible to continue. Stopping.\n');
     end 
            
    
end
    
    
    %   LOCAL PARAMETERS
    for iexp=1:inputs.exps.n_exp
       
         switch inputs.PEsol.id_local_theta{iexp}
         
         case 'none'
         otherwise  
     
         if isempty(inputs.PEsol.local_theta_max{iexp})==1
         fprintf(1,'\n\n------> WARNING message\n\n');    
         fprintf(1,'\t\t The maximum value for the local parameters has not been specified: inputs.PEsol.local_theta_max{iexp},\n');
         fprintf(1,'\t\t By default: 1e12. Note that you should update your input file with reasonable values.\n');
         inputs.PEsol.lobal_theta_max{iexp}=1e12.*ones(1,size(inputs.PEsol.id_local_theta{iexp},1));
         end
    
         if isempty(inputs.PEsol.local_theta_min{iexp})==1
         fprintf(1,'\n\n------> WARNING message\n\n');    
         fprintf(1,'\t\t The minimum value for the global parameters has not been specified: inputs.PEsol.local_theta_min{iexp}),\n');
         fprintf(1,'\t\t By default: 0. Note that you should update your input file with reasonable values.\n');
         inputs.PEsol.local_theta_min{iexp}=0.*ones(1,size(inputs.PEsol.id_local_theta{iexp},1));
         end
         
         if isempty(inputs.PEsol.local_theta_guess{iexp})==1
         inputs.PEsol.local_theta_guess{iexp}=0.5.*(inputs.PEsol.local_theta_max{iexp}-inputs.PEsol.local_theta_min{iexp});
         end    
        
         
        if size(inputs.PEsol.local_theta_guess{iexp},2)~=size(inputs.PEsol.id_local_theta{iexp},1)
        fprintf(1,'\n\n------> ERROR message\n\n');    
        fprintf(1,'\t\t The dimension of the initial guess does not coincide with the number of local parameters\n');
        fprintf(1,'\t\t inputs.PEsol.local_theta_guess should be corrected for experiment %u\n', iexp);
        error('error_bounds_007','\t\t Impossible to continue. Stopping.\n');
         end
     
        if size(inputs.PEsol.local_theta_max{iexp},2)~=size(inputs.PEsol.id_local_theta{iexp},1)
        fprintf(1,'\n\n------> ERROR message\n\n');    
        fprintf(1,'\t\t The dimension of the upper bounds for local parameters does not coincide with the number\n of local parameters\n');
        fprintf(1,'\t\t inputs.PEsol.local_theta_max should be corrected for experiment %u\n', iexp);
        error('error_bounds_008','\t\t Impossible to continue. Stopping.\n');
        end
        
        if size(inputs.PEsol.local_theta_min{iexp},2)~=size(inputs.PEsol.id_local_theta{iexp},1)
        fprintf(1,'\n\n------> ERROR message\n\n');    
        fprintf(1,'\t\t The dimension of the lower bounds for local parameters does not coincide with the number\n of local parameters\n');
        fprintf(1,'\t\t inputs.PEsol.local_theta_min should be corrected for experiment %u\n', iexp);
        error('error_bounds_009','\t\t Impossible to continue. Stopping.\n');
        end
         
        if sum(inputs.PEsol.local_theta_max{iexp} < inputs.PEsol.local_theta_min{iexp})>=1
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t Upper bound for local parameters is lower than the lower bound\n');
            fprintf(1,'\t\t inputs.PEsol.local_theta_max / min  should be corrected.\n');
            error('error_bounds_017','\t\t Impossible to continue. Stopping.\n');
     end    
            
     if sum(inputs.PEsol.local_theta_guess{iexp} > inputs.PEsol.local_theta_max{iexp})>=1 || sum(inputs.PEsol.local_theta_guess{iexp} < inputs.PEsol.local_theta_min{iexp})>=1 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t The initial guess for global parameters is outside the bounds\n');
            fprintf(1,'\t\t inputs.PEsol.local_theta_guess should be corrected.\n');
            error('error_bounds_018','\t\t Impossible to continue. Stopping.\n');
     end 
        
        
         
    end %switch inputs.PEsol.id_local_theta{iexp}
    end %for iexp=1:inputs.exps.n_exp   
    
     
     
        %   LOCAL INITIAL CONDITIONS
    for iexp=1:inputs.exps.n_exp
       
         switch inputs.PEsol.id_local_theta_y0{iexp}
         
         case 'none'
         otherwise  
        
         if isempty(inputs.PEsol.local_theta_y0_max{iexp})==1
         fprintf(1,'\n\n------> WARNING message\n\n');    
         fprintf(1,'\t\t The maximum value for the local initial conditions has not been specified: inputs.PEsol.local_theta_y0_max{iexp},\n');
         fprintf(1,'\t\t By default: 1e12. Note that you should update your input file with reasonable values.\n');
         inputs.PEsol.lobal_theta_y0_max{iexp}=1e12.*ones(1,size(inputs.PEsol.id_local_theta_y0{iexp},1));
         end
    
         if isempty(inputs.PEsol.local_theta_y0_min{iexp})==1
         fprintf(1,'\n\n------> WARNING message\n\n');    
         fprintf(1,'\t\t The minimum value for the local initial conditions has not been specified: inputs.PEsol.local_theta_y0_min{iexp}),\n');
         fprintf(1,'\t\t By default: 0. Note that you should update your input file with reasonable values.\n');
         inputs.PEsol.local_theta_min=0.*ones(1,size(inputs.PEsol.id_local_theta_y0{iexp},1));
         end
    
     
         if isempty(inputs.PEsol.local_theta_y0_guess{iexp})==1
         inputs.PEsol.local_theta_y0_guess{iexp}=0.5.*(inputs.PEsol.local_theta_y0_max{iexp}-inputs.PEsol.local_theta_y0_min{iexp});
         end    
         
         
            if size(inputs.PEsol.local_theta_y0_guess{iexp},2)~=size(inputs.PEsol.id_local_theta_y0{iexp},1)
            fprintf(1,'\n\n------> ERROR message\n\n');    
            fprintf(1,'\t\t The dimension of the initial guess does not coincide with the number of local initial conditions\n');
            fprintf(1,'\t\t inputs.PEsol.local_theta_y0_guess should be corrected for experiment %u\n',iexp);
            error('error_bounds_010','\t\t Impossible to continue. Stopping.\n');
            end
     
            if size(inputs.PEsol.local_theta_y0_max{iexp},2)~=size(inputs.PEsol.id_local_theta_y0{iexp},1)
            fprintf(1,'\n\n------> ERROR message\n\n');    
            fprintf(1,'\t\t The dimension of the upper bounds for local initial conditions does not coincide with the number\n of local initial conditions\n');
            fprintf(1,'\t\t inputs.PEsol.local_theta_y0_max should be corrected for experiment %u\n',iexp);
            error('error_bounds_011','\t\t Impossible to continue. Stopping.\n');
            end
         
            if size(inputs.PEsol.local_theta_y0_min{iexp},2)~=size(inputs.PEsol.id_local_theta_y0{iexp},1)
            fprintf(1,'\n\n------> ERROR message\n\n');    
            fprintf(1,'\t\t The dimension of the lower bounds for global initial conditions does not coincide with the number\n of global initial conditions\n');
            fprintf(1,'\t\t inputs.PEsol.local_theta_y0_min should be corrected for experiment %u\n',iexp);
            error('error_bounds_012','\t\t Impossible to continue. Stopping.\n');
            end
         
            
      if sum(inputs.PEsol.local_theta_y0_max{iexp} < inputs.PEsol.local_theta_y0_min{iexp})>=1
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t Upper bound for local parameters is lower than the lower bound\n');
            fprintf(1,'\t\t inputs.PEsol.local_theta_y0_max / min  should be corrected.\n');
            error('error_bounds_019','\t\t Impossible to continue. Stopping.\n');
     end    
            
     if sum(inputs.PEsol.local_theta_y0_guess{iexp} > inputs.PEsol.local_theta_y0_max{iexp})>=1 || sum(inputs.PEsol.local_theta_y0_guess{iexp} < inputs.PEsol.local_theta_y0_min{iexp})>=1 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf(1,'\t\t The initial guess for global parameters is outside the bounds\n');
            fprintf(1,'\t\t inputs.PEsol.local_theta_y0_guess should be corrected.\n');
            error('error_bounds_020','\t\t Impossible to continue. Stopping.\n');
     end 
         
         
        
        end   %switch inputs.PEsol.id_local_theta_y0{iexp} 
    end %for iexp=1:inputs.exps.n_exp
    
    
    
   
     return;