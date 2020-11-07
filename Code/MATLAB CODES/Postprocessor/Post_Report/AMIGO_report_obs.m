% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_obs.m 770 2013-08-06 09:41:45Z attila $

% AMIGO_report_experiments: reports experimental scheme 
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
% AMIGO_report_experiments: reports experimental scheme                       %
%                                                                             %
%*****************************************************************************%



    
    fprintf(fid,'\n\n-->Number of observables:\n');
    for iexp=1:inputs.exps.n_exp
    fprintf(fid,'\tExperiment %i: %i\n',iexp,inputs.exps.n_obs{iexp});
    end

    fprintf(fid,'\n-->Observables:\n');
    for iexp=1:inputs.exps.n_exp
    fprintf(fid,'\t\tExperiment %i:\n',iexp);  
    for i=1:inputs.exps.n_obs{iexp}
    fprintf(fid,'\t\t\t%s\n', inputs.exps.obs{iexp}(i,:));
    end
    end




    
    
    
   

