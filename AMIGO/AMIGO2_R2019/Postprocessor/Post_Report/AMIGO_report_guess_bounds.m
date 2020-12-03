% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_guess_bounds.m 2090 2015-09-15 08:21:56Z evabalsa $
  function []=AMIGO_report_guess_bounds(vguess,vmin,vmax,reportfile);  
% AMIGO_report_guess_bounds: reports guess and bounds for PE and OED
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
% AMIGO_report_OPTsolver: reports options selected by the user for the OPT    %
%                         solver                                              %
%                                                                             %
%*****************************************************************************%


    fid=fopen(reportfile,'a+');    
    fprintf(1,'\n\t\t>Bounds on the unknowns:\n');
    fprintf(fid,'\n\t\t>Bounds on the unknowns:\n');

    for i=1:size(vguess,2)
     fprintf(1,'\n\t\tv_guess(%d)=%f;  v_min(%d)=%f;  v_max(%d)=%f;',i,vguess(i),i,vmin(i),i,vmax(i));
     fprintf(fid,'\n\t\tv_guess(%d)=%f;  v_min(%d)=%f; v_max(%d)=%f;',i,vguess(i),i,vmin(i),i,vmax(i));
    end
    fprintf(1,'\n\n');
    fprintf(fid,'\n\n');    
    fclose(fid);    