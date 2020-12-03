% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_residuals.m 2086 2015-08-31 07:49:03Z evabalsa $
% AMIGO_report_residuals: reports information about residuals at optimum
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
% AMIGO_report_residuals: reports maximum and mean value of residuals at      %
%                         optimum
%                                                                             %
%*****************************************************************************%

fid=fopen(inputs.pathd.report,'a+');
 
 fprintf(1,'\n\n---------------------------------------------------------------------------------------------');
 fprintf(1,'\n>>>>    Mean / Maximum value of the residuals in percentage (100*(data-model)/data):\n\n');
 fprintf(fid,'\n\n-------------------------------------------------------------------------------------------');
 fprintf(fid,'\n>>>>    Mean / Maximum value of the residuals in percentage (100*(data-model)/data):\n\n');
 
 for iexp=1:inputs.exps.n_exp
     fprintf(1,'\t\tExperiment %u : \n',iexp);
     fprintf(fid,'\t\tExperiment %u : \n',iexp);
     for i_obs=1:inputs.exps.n_obs{iexp}
         mean_res(1,i_obs)=mean(abs(results.fit.rel_residuals{iexp}(:,i_obs)));
         max_res(1,i_obs)=max(abs(results.fit.rel_residuals{iexp}(:,i_obs)));
         fprintf(1,'\t\t Observable %u -->  mean error: %f %%\t max error: %f %%\n',i_obs, mean_res(1,i_obs),max_res(1,i_obs));
         fprintf(fid,'\t\t Observable %u --> mean error: %f %%\t max error: %f %%\n',i_obs, mean_res(1,i_obs),max_res(1,i_obs));
     end
     fprintf(1,'\n');
     fprintf(fid,'\n');
 end  
  fprintf(1,'--------------------------------------------------------------------------');
  fprintf(fid,'--------------------------------------------------------------------------');
  
  
 fprintf(1,'\n\n--------------------------------------------------------------------');
 fprintf(1,'\n>>>>    Maximum absolute value of the residuals (data-model):\n\n');
 fprintf(fid,'\n\n--------------------------------------------------------------------');
 fprintf(fid,'\n>>>>  Maximum absolute value of the residuals (data-model):\n\n');
 
 for iexp=1:inputs.exps.n_exp
     fprintf(1,'\t\tExperiment %u : \n',iexp);
     fprintf(fid,'\t\tExperiment %u : \n',iexp);
     for i_obs=1:inputs.exps.n_obs{iexp}
         max_res(1,i_obs)=max(abs(results.fit.residuals{iexp}(:,i_obs)));
         fprintf(1,'\t\t Observable %u -->  max residual: %f max data: %f\n',i_obs, max_res(1,i_obs),max(inputs.exps.exp_data{iexp}(:,i_obs)));
         fprintf(fid,'\t\t Observable %u -->  max residual: %f max data: %f\n',i_obs, max_res(1,i_obs),max(inputs.exps.exp_data{iexp}(:,i_obs)));
     end
     fprintf(1,'\n');
     fprintf(fid,'\n');
 end  
  fprintf(1,'--------------------------------------------------------------------------');
  fprintf(fid,'--------------------------------------------------------------------------');
  
  
