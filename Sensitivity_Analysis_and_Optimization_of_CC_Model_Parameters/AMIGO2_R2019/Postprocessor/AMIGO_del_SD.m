% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/AMIGO_del_SD.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_del_SD: Clear all unnecessary variables in the workspace 
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
%  AMIGO_del_SD: Clear all unnecessary variables in the workspace             %
%                                                                             %
%*****************************************************************************%
 
  inputs.exps.n_obs=inputs.exps.n_obs(1:inputs.exps.n_exp);  
  inputs.exps.obs=inputs.exps.obs(1:inputs.exps.n_exp);
  inputs.exps.error_data=inputs.exps.error_data(1:inputs.exps.n_exp);
  inputs.exps.exp_data=inputs.exps.exp_data(1:inputs.exps.n_exp);
  inputs.exps.exp_y0_type= inputs.exps.exp_y0_type(1:inputs.exps.n_exp);                  
  inputs.exps.tf_type= inputs.exps.tf_type(1:inputs.exps.n_exp);                      
  inputs.exps.u_type=inputs.exps.u_type(1:inputs.exps.n_exp);                      
  inputs.exps.ts_type=inputs.exps.ts_type(1:inputs.exps.n_exp);   
  
  inputs=rmfield(inputs,char('PEsol','nlpsol','rank','rid'));
  %results=rmfield(results,char('fit'));