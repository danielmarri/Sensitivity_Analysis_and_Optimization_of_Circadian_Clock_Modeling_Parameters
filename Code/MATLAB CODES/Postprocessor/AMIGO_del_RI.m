% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/AMIGO_del_RI.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_del_RI: Clear all unnecessary variables in the workspace 
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
%  AMIGO_del_RI: Clear all unnecessary variables in the workspace             %
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
  
  inputs.PEsol.id_local_theta=inputs.PEsol.id_local_theta(1:inputs.exps.n_exp);
  inputs.PEsol.n_local_theta= inputs.PEsol.n_local_theta(1:inputs.exps.n_exp);
  inputs.PEsol.id_local_theta_y0=inputs.PEsol.id_local_theta_y0(1:inputs.exps.n_exp);
  inputs.PEsol.n_local_theta_y0=inputs.PEsol.n_local_theta_y0(1:inputs.exps.n_exp);
  inputs.PEsol.local_theta_min= inputs.PEsol.local_theta_min(1:inputs.exps.n_exp);
  inputs.PEsol.local_theta_max= inputs.PEsol.local_theta_max(1:inputs.exps.n_exp);
  inputs.PEsol.local_theta_guess=inputs.PEsol.local_theta_guess(1:inputs.exps.n_exp);
  inputs.PEsol.local_theta_y0_min=inputs.PEsol.local_theta_y0_min(1:inputs.exps.n_exp);
  inputs.PEsol.local_theta_y0_max=inputs.PEsol.local_theta_y0_max(1:inputs.exps.n_exp);
  inputs.PEsol.local_theta_y0_guess=inputs.PEsol.local_theta_y0_guess(1:inputs.exps.n_exp);
 
  
  
  inputs=rmfield(inputs,char('rank'));

    
   if exist('fobj_fsqp.m')==2 
        delete fobj_fsqp.m; end
   if exist('fobj_fsqp.m')==2 
        delete objf_n2fb.m; end
   if exist('objf_dn2fb.m')==2
       which('objf_dn2fb')
        delete objf_dn2fb.m; end
   if exist('objf_n2fb.m')==2
        delete objf_n2fb.m; end
   if exist('ipopt_f.m')==2
        delete ipopt_f.m; end
  
    
  results=rmfield(results,char('nlpsol'));

   