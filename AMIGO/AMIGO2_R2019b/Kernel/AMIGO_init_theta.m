% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_init_theta.m 852 2013-09-04 10:07:37Z davidh $

% AMIGO_init_theta: initializes theta from nominal values and guesses
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
%  AMIGO_init_vectors: generates the vector of parameters and initial         %
%                      conditions for SMODEL/SDATA/RANK/CONTOURS/             %
%                      IDENTIFIABILITY PURPOSES                               %
%*****************************************************************************%

AMIGO_set_theta_index

%SETS INITIAL VALUES FOR THE PARAMETERS + IC WHEN REQUIRED
if inputs.PEsol.n_global_theta>0
    
    if isempty(inputs.PEsol.global_theta_min) && isempty(inputs.PEsol.global_theta_max)
        if isempty(inputs.PEsol.global_theta_guess)==1
            inputs.PEsol.global_theta_guess=[inputs.model.par(inputs.PEsol.index_global_theta) inputs.PEsol.upar_guess]; 
        end
    else
        if isempty(inputs.PEsol.global_theta_guess)==1
            inputs.PEsol.global_theta_guess=[mean([inputs.PEsol.global_theta_max;inputs.PEsol.global_theta_min]) inputs.PEsol.upar_guess];
        end
    end
end %inputs.PEsol.n_global_theta>0

for iexp=1:inputs.exps.n_exp
    
    if inputs.PEsol.n_local_theta{iexp}>0
        
        if isempty(inputs.PEsol.local_theta_min{iexp})==1 && isempty(inputs.PEsol.local_theta_max{iexp})==1
            if isempty(inputs.PEsol.local_theta_guess{iexp})==1
                inputs.PEsol.local_theta_guess{iexp}=inputs.model.par(inputs.PEsol.index_local_theta{iexp});
            end;
        else
            if isempty(inputs.PEsol.local_theta_guess{iexp})==1
                inputs.PEsol.local_theta_guess{iexp}=mean([inputs.PEsol.local_theta_max{iexp};inputs.PEsol.local_theta_min{iexp}]); end;
        end
    end %if inputs.PEsol.n_local_theta{iexp}>0
end %for iexp=1:inputs.exps.n_exp



if inputs.PEsol.n_global_theta_y0>0
    
    if isempty(inputs.PEsol.global_theta_y0_min)==1 && isempty(inputs.PEsol.global_theta_y0_max)==1
        if isempty(inputs.PEsol.global_theta_y0_guess)==1
            inputs.PEsol.global_theta_y0_guess=inputs.exps.exp_y0{1}(inputs.PEsol.index_global_theta_y0);
        end;
    else
        if isempty(inputs.PEsol.global_theta_y0_guess)==1
            inputs.PEsol.global_theta_y0_guess=mean([inputs.PEsol.global_theta_y0_max;inputs.PEsol.global_theta_y0_min]); end;
    end
end %if inputs.PEsol.n_global_theta_y0>0

for iexp=1:inputs.exps.n_exp
    
    if inputs.PEsol.n_local_theta_y0{iexp}>0
        
        if isempty(inputs.PEsol.local_theta_y0_min{iexp})==1 && isempty(inputs.PEsol.local_theta_y0_max{iexp})==1
            if isempty(inputs.PEsol.local_theta_y0_guess{iexp})==1
                inputs.PEsol.local_theta_y0_guess{iexp}=inputs.exps.exp_y0{iexp}(inputs.PEsol.index_local_theta_y0{iexp});
            end;
        else
            if isempty(inputs.PEsol.local_theta_y0_guess{iexp})==1
                inputs.PEsol.local_theta_y0_guess{iexp}=mean([inputs.PEsol.local_theta_y0_max{iexp};inputs.PEsol.local_theta_y0_min{iexp}]); end;
        end
    end %if inputs.PEsol.n_local_theta_y0{iexp}>0
end %for iexp=1:inputs.exps.n_exp


privstruct.theta=[inputs.PEsol.global_theta_guess  inputs.PEsol.global_theta_y0_guess  cell2mat(inputs.PEsol.local_theta_guess)  cell2mat(inputs.PEsol.local_theta_y0_guess)];


