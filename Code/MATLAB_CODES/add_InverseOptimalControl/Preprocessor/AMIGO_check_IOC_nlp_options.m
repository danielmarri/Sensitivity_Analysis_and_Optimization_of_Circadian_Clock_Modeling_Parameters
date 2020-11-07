% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/Preprocessor/AMIGO_check_nlp_options.m 1019 2013-09-27 15:01:51Z attila $

function inputs = AMIGO_check_IOC_nlp_options(inputs)

inputs_def = AMIGO_default_options_IOC;
AMIGO_merge_struct(inputs_def.nlpsol,inputs.nlpsol,'inputs.nlpsol');



% Check nl2Sol related settings. 
if strcmpi(inputs.nlpsol.eSS.local.solver, 'nl2sol') || strcmpi(inputs.nlpsol.local.solver, 'nl2sol')
    % Check automatic Jacobian computation related settings  
    if strcmp(inputs.IOCsol.ioccostJac_type, 'llk')
       if ~strcmp(inputs.IOCsol.llk_type, 'homo') && ~strcmp(inputs.IOCsol.llk_type, 'homo_var') && ~strcmp(inputs.IOCsol.llk_type, 'hetero')
           % llk_type is neither homo nor homo_var
           %error('Forward sensitivity based computation of the Jacobian for Log-Likelihood objective function for heteroscedastic noise is not implemented. Use PEcostJac_type = ''mkl''; for finite difference computation or set llk_type=''homo_var''; if possible.');
           error('Maximum-Likelihood estimation assuming %s noise type is not a Least-Squares problem, thus NL2SOL cannot be used.',inputs.IOCsol.llk_type);
       end
    end
end


end
