% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_NLPsolver.m 2487 2016-02-23 14:01:49Z evabalsa $
function [inputs,privstruct]= AMIGO_check_NLPsolver(inputs,opt_solver,privstruct);
% AMIGO_check_NLPSolver: Checks opt solver when introduced as optional input
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
%  AMIGO_check_NLPSolver: Checks opt solver when introduced as optional input %
%                                                                             %
%*****************************************************************************%
privstruct.nlpsolver=opt_solver;
if length(opt_solver)>2

    if opt_solver(1,[1:3])=='my_';
        opt_solver='my';
    end;
end

switch opt_solver
    case {'de','sres','ess','eSS','globalm','monlot','nsga2'}
        inputs.nlpsol.nlpsolver=opt_solver;
        inputs.nlpsol.global_solver=opt_solver;
    case {'wsm_de','wsm_sres','wsm_ssm','wsm_fssm','wsm_ess','wsm_globalm'}
        inputs.nlpsol.nlpsolver='wsm';
        inputs.nlpsol.global_solver=opt_solver(1,[5:end]);
             inputs.nlpsol.local_solver=[];
        
    case {'wsm_fmincon','wsm_n2fb','wsm_dn2fb','wsm_dhc','wsm_ipopt','wsm_solnp','wsm_nomad','wsm_fsqp','wsm_misqp','wsm_fminsearch'}
        inputs.nlpsol.nlpsolver='wsm';
        inputs.nlpsol.local_solver=opt_solver(1,[5:end]);
        inputs.nlpsol.global_solver='';

    case {'multi_fmincon','multi_n2fb','multi_dn2fb','multi_dhc','multi_ipopt','multi_solnp','multi_nomad','multi_fsqp','multi_misqp','multi_fminsearch','multi_hooke','multi_lsqnonlin','multi_nl2sol','multi_lbfgsb'}
        inputs.nlpsol.nlpsolver='multistart';
        inputs.nlpsol.local_solver=opt_solver(1,[7:end]);

    case {'local_fmincon','local_n2fb','local_dn2fb','local_dhc','local_ipopt','local_solnp','local_nomad','local_fsqp','local_misqp','local_fminsearch','local_hooke','local_nl2sol','local_lsqnonlin','local_lbfgsb'}
        inputs.nlpsol.nlpsolver='local';
        inputs.nlpsol.local_solver=opt_solver(1,[7:end]);
    
    case{'hyb_de_fmincon','hyb_de_n2fb','hyb_de_dn2fb','hyb_de_dhc','hyp_de_ipopt','hyb_de_solnp','hyb_de_nomad','hyb_de_fsqp','hyb_de_misqp','hyb_de_fminsearch','hyb_de_hooke','hyb_de_nl2sol','hyb_de_lsqnonlin','hyb_de_ipopt'}
        inputs.nlpsol.nlpsolver='hybrid';
        inputs.nlpsol.local_solver=opt_solver(1,[8:end]);
        inputs.nlpsol.global_solver='de';
        
    case{'hyb_sres_fmincon','hyb_sres_n2fb','hyb_sres_dn2fb','hyb_sres_dhc','hyp_sres_ipopt','hyb_sres_solnp','hyb_sres_nomad','hyb_sres_fsqp','hyb_sres_misqp','hyb_sres_fminsearch','hyb_sres_hooke','hyb_sres_nl2sol','hyb_sres_lsqnonlin','hyb_sres_ipopt'}
        inputs.nlpsol.nlpsolver='hybrid';
        inputs.nlpsol.local_solver=opt_solver(1,[10:end]);
        inputs.nlpsol.global_solver='sres';

    case 'my'
        inputs.nlpsol.nlpsolver='usersolver';
        inputs.nlpsol.user_solver=privstruct.nlpsolver(1,[4:end]);

    case{'sim'} % FOR SIMULATION IN OD ONLY
        inputs.nlpsol.nlpsolver=opt_solver;


    otherwise
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\t The NLP solver: %s, you selected is not available.\n', privstruct.nlpsolver);
        error('error_OPT_001','\t\t Impossible to continue. Stopping.\n');
end



end
    
