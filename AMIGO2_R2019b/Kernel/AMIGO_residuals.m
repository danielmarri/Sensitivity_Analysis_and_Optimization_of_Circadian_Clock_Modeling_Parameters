% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_residuals.m 2231 2015-09-29 14:57:12Z evabalsa $
function [residuals,rel_residuals,ms] = AMIGO_residuals(theta,inputs,results,privstruct);
% AMIGO_residuals: Computes residuals after parameter estimation
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
%  AMIGO_residuals: Computes residuals, i.e. differences among experimental   %
%                   data and model predictions once the parameter             %
%                   estimation problem has been solved.                       %
%                   Residuals provide further information about the quality   %
%                   of the fit which will be otherwise hidden in the lsq or   %
%                   llk                                                       %
%                   For real experimental data residuals may be used to       %
%                   estimate the experimental noise standard deviation        %
%*****************************************************************************%


% Initialice cost
f=0.0;
g=[];

privstruct=AMIGO_transform_theta(inputs,results,privstruct);

switch inputs.model.exe_type
    case 'standard'

        % Perform simulation for each set of experimental conditions
        for iexp=1:inputs.exps.n_exp

            %Memory allocation for matrices
            yteor=zeros(inputs.exps.n_s{iexp},inputs.model.n_st);
            ms{iexp}=zeros(inputs.exps.n_s{iexp},inputs.exps.n_obs{iexp});
            %Perform integration
           
            yteor=AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par{iexp},iexp);
           
            obsfunc=inputs.pathd.obs_function;

            ms{iexp}=feval(obsfunc,yteor,inputs,privstruct.par{iexp},iexp);



        end

    case{'costMex','fullMex'}

        inputs.exps.exp_y0=privstruct.y_0;
        inputs.model.par=privstruct.par{1};

        if(regexp(inputs.model.mexfile,'\w+$'))
            fname=inputs.model.mexfile(regexp(inputs.model.mexfile,'\w+$'):end);
        else
            fname=inputs.model.mexfile(regexp(inputs.model.mexfile,'/w+$'):end);
        end

        feval(str2func(fname),'sim_CVODES');
        ms=outputs.observables;

    otherwise
        error('AMIGO_residuals: execution type(exe_type) not supported');

end

for iexp=1:inputs.exps.n_exp
     
    residuals{iexp}=inputs.exps.exp_data{iexp}-ms{iexp};

    % To compute relative residuals we have to take into account that
    % residuals may be 0 and data may be also 0. To avoid Infs and Nans
    % we use a trick.
    [i0,j0]=find(residuals{iexp}==0);

    rel_residuals{iexp}=100.*(inputs.exps.exp_data{iexp}-ms{iexp})./inputs.exps.exp_data{iexp};

    for i=1:length(i0)
        rel_residuals{iexp}(i0(i),j0(i))=0;
    end

end

return