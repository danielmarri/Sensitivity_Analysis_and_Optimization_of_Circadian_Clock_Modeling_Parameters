% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_IVPsolver.m 2305 2015-11-25 08:20:26Z evabalsa $
% AMIGO_check_IVPsolver: Checks ivp solver when introduced as optional input
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
%  AMIGO_check_IVPSolver: Checks ivp solver when introduced as optional input %
%                                                                             %
%*****************************************************************************%


switch inputs.model.input_model_type
    case    {'charmodelC','sbmlmodel'}
        if ~isfield(inputs.ivpsol,'ivpsolver') || isempty(inputs.ivpsol.ivpsolver) || ~strcmp(inputs.ivpsol.ivpsolver,'cvodes')
            inputs.ivpsol.ivpsolver='cvodes';
            warning('AMIGO_check_IVPsolver: Changing ivp solver to the only option compatible with charmodelC and sbmlmodel, cvodes');
        end
        
        if ~isfield(inputs.ivpsol,'senssolver') || isempty(inputs.ivpsol.senssolver) 
            % EBC to allow for FD sensitivities 
            if ~strcmp(inputs.ivpsol.senssolver,'cvodes') && ~strcmp(inputs.ivpsol.senssolver,'fdsens2') && ~strcmp(inputs.ivpsol.senssolver,'fdsens5')
            inputs.ivpsol.senssolver='cvodes';
            warning('AMIGO_check_IVPsolver: Changing sensitivities solver to, cvodes');
            end
        end
end


if ~isfield(inputs.ivpsol,'ivpsolver') || isempty(inputs.ivpsol.ivpsolver)

    switch inputs.model.input_model_type
        
        case {'charmodelC','sbmlmodel'}
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\t You have selected a %s model type. But you have not specified a particular ODE solver.\n',inputs.model.input_model_type);
            fprintf(1,'\t\t To generate mex(by default) cvodes is used.\n');
            inputs.ivpsol.ivpsolver='cvodes';
            
        case {'sbmlmodelM','matlabmodel','charmodelM'}

            inputs.ivpsol.ivpsolver='ode15s';
            fprintf(1,'By default ode15s will be used.\n');
    end
end

switch inputs.model.input_model_type
    case {'charmodelC','sbmlmodel'}
        inputs.ivpsol.ivpmex=strcat(inputs.ivpsol.ivpsolver,'g_',inputs.pathd.short_name);
end
if isempty(inputs.ivpsol.senssolver)==1
    switch inputs.model.input_model_type
        case {'charmodelC','sbmlmodel'}
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\t You have selected a %s model type. But you have not specified a particular SENS solver.\n',inputs.model.input_model_type);
            fprintf(1,'\t\t To generate dlls (by default) odessa is used.\n');
            inputs.ivpsol.senssolver='odessa';
        case {'sbmlmodelM','matlabmodel','charmodelM'}
            inputs.ivpsol.senssolver='sensmat';
            fprintf(1,'By default sensmat will be used.\n');
        case {'blackboxmodel'}
            inputs.ivpsol.senssolver='fdsens';
        case {'blackboxcost'}
            fprintf(1,'Sensitivities may not be computed since there is not access to states and observables.\n');
    end;
end

switch inputs.model.input_model_type
    case {'charmodelC','amigoCgenerator','sbmlmodel'}
        inputs.ivpsol.sensmex=strcat(inputs.ivpsol.senssolver,'g_',inputs.pathd.short_name);
end

switch inputs.ivpsol.ivpsolver
    case {'ode15s','ode113','ode45','blackboxmodel','blackboxcost','cvodes'}
    otherwise
        fprintf(1,'The ivp_solver you selected [%s] is not available.',inputs.ivpsol.ivpsolver);
        fprintf(1,'\n\tPlease select from the list: ode45, ode15s, ode113, cvodes.');
        error('error_ivpsol_001','\t\t Impossible to continue. Stopping.\n');
end



%   -----------------------------------------------------------------------------------------------------------------

