% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_header.m 2281 2015-10-14 09:47:16Z evabalsa $
% AMIGO_report_header: reports AMIGO header
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
% AMIGO_report_header: reports AMIGO header, current version and date         %
%                                                                             %
%*****************************************************************************%

global report_sens
global report_ivp
report_sens = 0;
report_ivp = 0;

AMIGO_release_info

fprintf(1,'\n\n*********************************** ');
fprintf(1,'\n     AMIGO2, Copyright @CSIC      ');
fprintf(1,'\n     %s      ',AMIGO_version);
fprintf(1,'\n*********************************** ');
fprintf(1,'\n\n*Date: %s',date);
if(ischar(input_file))
    fprintf(1,'\n\n*Running AMIGO for: %s\n',input_file);
end


