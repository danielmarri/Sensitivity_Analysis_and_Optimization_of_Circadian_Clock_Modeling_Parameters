% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_PE.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_report_PE: reports results for parameter estimation
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
% AMIGO_report_PE: reports results for parameter estimation                   %
%                                                                             %
%*****************************************************************************%


    fprintf(fid,' \n\n \t>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
    fprintf(fid,' \t -----> Model related information\n');
    fprintf(fid,' \t>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
  
    fprintf(fid,'\n \t--> Number of states: %i\n', inputs.model.n_states);

    switch inputs.model_type
        
        case {'fortran','matlab'}    
    
         fprintf(fid,'\t\t--> The user supplied the following fortran file for the ode set: %s', inputs.model.odes_file);
         fprintf(fid,'\t\t--> The user supplied the following fortran file for the sensitivities set: %s', inputs.model.sens_file);
        
        case {'sbml'} 
         fprintf(fid,'\t\t--> The user supplied the following fortran file for the ode set: %s', inputs.model.odes_file);
        
        case{'char'} 
  
        fprintf(fid,' \t\t--> Differential equations:\n\n');
        for i=1:inputs.model.n_states
        fprintf(fid,'\t\t\t%s\n', inputs.ydot(i,:));
        end
   end     % switch inputs.model_type
   
    fprintf(fid,' \t\t--> Initial conditions (nominal):\n');
    fprintf(fid,'\t\t\ty0=[');
    for i=1:inputs.model.n_states
        fprintf(fid,'%10.5f  ',inputs.y0(1,i));  
    end
    fprintf(fid,']\n');

    
    switch inputs.theta_y0_type
        case 'global'
        fprintf(fid,' \t\t--> Initial conditions to be estimated for all experiments');    
        fprintf(fid,' \t\t--> Number of initial conditions to be estimated: %i\n',inputs.n_theta_y0{1}); 
        fprintf(fid,' \t\t--> Index of initial conditions to be estimated within vector y0: \t');
        for i=1:inputs.n_theta_y0{1}
        fprintf(fid,'\t%i, ',inputs.index_theta_y0{1}(1,i));  
        end
        case 'local'    
           
        fprintf(fid,' \t\t--> Initial conditions to be estimated for each experiment');    
        for iexp=1:inputs.n_exp
        fprintf(fid,' \t\t--> Number of initial conditions to be estimated: %i\n',inputs.n_theta_y0{iexp});
        fprintf(fid,' \t\t--> Index of initial conditions to be estimated within vector y0: \t');
        for i=1:inputs.n_theta_y0{iexp}
        fprintf(fid,'\t\t%i, ',inputs.index_theta_y0{iexp}(1,i));  
        end
        end
    end % switch inputs.theta_y0_type
        
    fprintf(fid,'\n \t\t--> Number of model parameters (initial conditions not included here): %i\n',inputs.n_par);

    fprintf(fid,' \t\t--> Vector of parameters (nominal values):\n');

    fprintf(fid,'\t\t\tpar0=[');
    for i=1:inputs.n_par
        fprintf(fid,'%10.5f  ',inputs.par(1,i)); 
    end
    fprintf(fid,']\n');

    fprintf(fid,' \t\t--> Number of parameters to be estimated: %i\n',inputs.n_theta);
    fprintf(fid,' \t\t--> Index of parameters to be estimated within vector par: \t');
    for i=1:inputs.n_theta
        fprintf(fid,'%i,  ',inputs.index_theta(1,i));  
    end