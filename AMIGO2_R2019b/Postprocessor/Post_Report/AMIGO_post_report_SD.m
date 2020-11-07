% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_post_report_SD.m 1622 2014-06-26 11:09:56Z attila $
function [inputs,results]= AMIGO_post_report_SD(inputs,results,privstruct);

% AMIGO_postprocessor_report_SM: reporting results for model simulation
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
% AMIGO_postprocessor_report_SM: reporting results for model simulation       %
%                                                                             %
%*****************************************************************************%

    AMIGO_release_info
     fid=fopen(inputs.pathd.report,'a+');
%   Done in the AMIGO_init_report.m called in the main function: AMIGO_SData 
%     fprintf(fid,'\n\n*********************************** ');
%     fprintf(fid,'\n*     AMIGO, Copyright @CSIC      * ');
%     fprintf(fid,'\n*   %s    *',AMIGO_version);
%     fprintf(fid,'\n*********************************** ');
%     fprintf(fid,'\n\n*Date: %s',date); 
%     fprintf(fid,'\t   \n\n> Problem folder: %s\n',inputs.pathd.problem_folder_path);
%     fprintf(fid,'\t   \n> Results folder in problem folder: %s \n',inputs.pathd.task_folder);

    AMIGO_report_model
    AMIGO_report_exps
    AMIGO_report_obs
    AMIGO_report_data
    %AMIGO_report_residuals   



return