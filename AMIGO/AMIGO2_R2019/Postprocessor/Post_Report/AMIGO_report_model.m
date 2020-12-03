% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_model.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_report_model: reports information about model
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
%   AMIGO_report_model: reports information about model                       %
%                                                                             %
%*****************************************************************************%

    fprintf(fid,'\n\n-------------------------------\n');
    fprintf(fid,'   Model related information\n');
    fprintf(fid,'-------------------------------\n');
  
    fprintf(fid,'\n--> Number of states: %i\n\n', inputs.model.n_st);

    switch inputs.model.input_model_type
        
        case {'fortranmodel'}    
    
         fprintf(fid,'--> The user supplied the following FORTRAN file for the ode set: %s\n', inputs.model.fortranmodel_file);
         fprintf(fid,'--> The user supplied the following FORTRAN file for the sensitivities set: %s\n', inputs.model.fortransens_file);
        
        case {'sbmlmodel'} 
         fprintf(fid,'--> The user supplied the following SBML file for the ode set: %s\n', inputs.model.sbmlmodel_file);
         
        case {'matlabmodel'} 
         fprintf(fid,'--> The user supplied the following MATLAB file for the ode set: %s\n', inputs.model.matlabmodel_file);
        
        case{'charmodelF','charmodelM'} 
  
        fprintf(fid,' \n--> Differential equations:\n\n');
        for i=1:inputs.model.n_st
        fprintf(fid,'\t%s\n', inputs.model.eqns(i,:));
        end
        
        case{'blackboxmodel'} 
        fprintf(fid,'--> The user supplied the following black box model file: %s\n', inputs.model.blackboxmodel_file);
        
   end     % switch inputs.model.input_model_type
   
    fprintf(fid,'\n--> Number of model parameters: %i\n',inputs.model.n_par);

    fprintf(fid,'\n--> Vector of parameters (nominal values):\n');

    fprintf(fid,'\n\tpar0=['); fprintf(fid,'%10.5f  ',inputs.model.par); fprintf(fid,']\n');
   
    
  

