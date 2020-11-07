% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_runident.m 923 2013-09-11 08:24:30Z evabalsa $
% AMIGO_check_runident: Checks that results folder has not been already
% used
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
% AMIGO_check_runident: Checks that results folder has not been already       %
%                       used, i.e. checks that the run identifier has not     %
%                       been used and asks for a run identifier when required % 
%                                                                             %
%*****************************************************************************%



switch inputs.pathd.run_overwrite
    case 'off'
        if isdir(inputs.pathd.task_folder)==1
            fprintf(1,'\n\n------>WARNING!!: The output folder \n \t\t%s\n',inputs.pathd.task_folder);
            fprintf(1,'\t\thas been already created in a previous run.\n');
            fprintf(1,'\t\tyou should include a run identifier different to %s.\n',inputs.pathd.runident);
            run_ident=input('        Please, introduce a run identifier as a string (i.e.,''run identifier'')... \n\n ');
        else
            run_ident=inputs.pathd.runident;
        end
    otherwise
        run_ident=inputs.pathd.runident;
end