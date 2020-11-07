% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_theta.m 2057 2015-08-24 13:06:14Z attila $
function [inputs]= AMIGO_check_theta(inputs)
% AMIGO_check_theta: Checks definitions of theta for PE and related tasks
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
% AMIGO_check_theta: Checks if the parameters to be estimated have been       %
%                     introduced by the user                                  %
%                                                                             %
%*****************************************************************************%


if (isempty(inputs.PEsol.id_global_theta)==1 && sum(cell2mat(inputs.PEsol.n_local_theta)))
    fprintf(1,'\n\n------> WARNING message\n\n');
    fprintf(1,'\t\t The unknown parameters have not been specified inputs.PEsol.id_global_theta or inputs.PEsol.id_local_theta,\n');
    fprintf(1,'\t\t By default all parameters will be considered.\n');
    inputs.PEsol.theta_id=inputs.model.par_names;
end

if(strcmp(inputs.model.input_model_type,'costMex') || strcmp(inputs.model.input_model_type,'fullMex') || strcmp(inputs.model.input_model_type,'fullMex'))
    for iexp=1:inputs.exps.n_exp
        if (inputs.PEsol.n_global_theta_y0>0)
            error('amigoCgenerator does not support estimation of Global initial conditions');
        end
    end
end

if strcmp(inputs.PEsol.id_global_theta, 'all')
    inputs.PEsol.id_global_theta = inputs.model.par_names;
    inputs.PEsol.n_global_theta = inputs.model.n_par;
    inputs.PEsol.index_global_theta = 1:inputs.model.n_par;
end

if isempty(inputs.PEsol.n_global_theta)
    inputs.PEsol.n_global_theta = size(inputs.PEsol.id_global_theta,1);
end

AMIGO_set_theta_index



return;