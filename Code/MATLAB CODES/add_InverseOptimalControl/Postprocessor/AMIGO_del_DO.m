%% Clear all unnecessary variables in the workspace 
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
%  Clears privstruct and run time variables and files which are 
%  not necessary or not interesting for users
%%
  
  inputs=rmfield(inputs,char('exps','PEsol'));

   warning off 
   if exist('fobj_fsqp.m')==2 
        delete fobj_fsqp.m; end
   if exist('ipopt_f.m')==2
        delete ipopt_f.m; end
   if exist('ssm_report.mat')==2
        delete ssm_report.mat; end
   if exist('fobj_nomad.m')==2   
         which('fobj_nomad')
        delete fobj_nomad.m; end
   if exist('fobj_nomad_Omega.m')==2   
         which('fobj_nomad_Omega')
        delete fobj_nomad_Omega.m; end    
   if exist('fobj_nomad_Param.m')==2   
        which('fobj_nomad_Param')
        delete fobj_nomad_Param.m; end
   if exist('fobj_nomad_x0.m')==2   
        which('fobj_nomad_x0')
        delete fobj_nomad_x0.m; end
    
   if exist('constr_fsqp.m')==2   
        delete constr_fsqp.m; end
    if exist('ess_report.mat')==2   
        delete ess_report.mat; end

 
    
   clear amigodir AMIGO_version f g h iexp input_file inputs_def iu ntplot_def opt_solver results_def privstruct

   