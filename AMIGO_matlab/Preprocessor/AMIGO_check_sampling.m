% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_sampling.m 2128 2015-09-21 09:53:59Z evabalsa $
function [inputs]= AMIGO_check_sampling(inputs)
% AMIGO_check_sampling: Checks sampling related data
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
%  AMIGO_check_sampling: Checks sampling related data                         %
%                                                                             %
%*****************************************************************************%

for iexp=1:inputs.exps.n_exp
    if strcmpi(inputs.exps.exp_type{iexp},'fixed')

        if (length(inputs.exps.t_s)<iexp || isempty(inputs.exps.t_s{iexp}))
            
            if (isempty(inputs.exps.n_s{iexp})==0)
                
                fprintf(1,'\n\n------> WARNING message\n\n');
                fprintf(1,'\t\t You have not provided the sampling times.\n');
                fprintf(1,' \t\t Equidistant sampling will be assumed for experiment %u\n', iexp)
                delta=(inputs.exps.t_f{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_s{iexp}-1);
                inputs.exps.t_s{iexp}=[inputs.exps.t_in{iexp}:delta:inputs.exps.t_f{iexp}];
                fprintf(1,'\t\t Note however that you may modify your input file by adding\n');
                fprintf(1,'\t\t inputs.exps.t_s{iexp}\n');
                
            else
                
                fprintf(1,'\n\n------> WARNING message\n\n');
                fprintf(1,'\t\t You have not provided neither the number nor the sampling times.\n');
                fprintf(1,' \t\t Continuous sampling will be assumed for experiment %u\n', iexp)
                inputs.exps.n_s{iexp}=inputs.plotd.n_t_plot;
                delta=(inputs.exps.t_f{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_s{iexp}-1);
                inputs.exps.t_s{iexp}=[inputs.exps.t_in{iexp}:delta:inputs.exps.t_f{iexp}];
                fprintf(1,'\t\t Note however that you may modify your input file by adding\n');
                fprintf(1,'\t\t inputs.exps.n_s{iexp} and inputs.exps.t_s{iexp}\n');
                
            end %if (isempty(inputs.exps.n_s{iexp}==0))
            
        end %if (isempty(inputs.exps.t_s{iexp})==1)
    end
end %for iexp=1:inputs.exps.n_exp


for iexp=1:inputs.exps.n_exp
    if strcmpi(inputs.exps.exp_type{iexp},'fixed')
        if (isempty(inputs.exps.t_s{iexp})==1) && (isempty(inputs.exps.n_s{iexp}==1))
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\t You have not provided the necessary information about sampling times.\n');
            fprintf(1,' \t\t Equidistant and continuous sampling will be assumed for experiment %u\n', iexp)
            inputs.exps.n_s{iexp}=inputs.plotd.n_t_plot;
            delta=(inputs.exps.t_f{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_s{iexp}-1);
            inputs.exps.t_s{iexp}=[inputs.exps.t_in{iexp}:delta:inputs.exps.t_f{iexp}];
            fprintf(1,'\t\t Note however that you should modify your input file by adding\n');
            fprintf(1,'\t\t inputs.exps.n_s{iexp} and inputs.exps.t_s{iexp}\n');
        end
        
        
        if  length(inputs.exps.n_s)<iexp || isempty(inputs.exps.n_s{iexp})
            inputs.exps.n_s{iexp}=size(inputs.exps.t_s{iexp},2);
        end
        
        if (isempty(inputs.exps.t_s{iexp}) && inputs.exps.n_s{iexp}~=size(inputs.exps.t_s{iexp},2))
            fprintf(1,'\n\n------> WARNING message\n\n');
            fprintf(1,'\t\t  Size of vector inputs.exps.t_s does not coincide with the number of sampling times for Exp:%u\n',iexp);
            if size(inputs.exps.t_s{iexp})>1
                fprintf(1,' \t\t Number of sampling times is being updated to %u. \n',size(inputs.exps.t_s{iexp},2))
                inputs.exps.n_s{iexp}=size(inputs.exps.t_s{iexp},2);
            end
        end
    end
end

if strcmpi(inputs.exps.exp_type{iexp},'fixed')
inputs.exps.n_s=inputs.exps.n_s(1:inputs.exps.n_exp);
inputs.exps.t_s=inputs.exps.t_s(1:inputs.exps.n_exp);
end


for iexp=1:inputs.exps.n_exp
if ~isfloat(inputs.exps.t_s{iexp})
    inputs.exps.t_s{iexp}=double(inputs.exps.t_s{iexp});
end
end

return;