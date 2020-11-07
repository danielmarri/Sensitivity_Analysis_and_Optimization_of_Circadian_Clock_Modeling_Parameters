% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_OPTsolver.m 1813 2014-07-14 14:53:39Z attila $
% AMIGO_report_OPTsolver: reports options selected by the user for the OPT
% solver
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
% global reports

fid=fopen(inputs.pathd.report,'a+');
fprintf(fid,'\n\n-------------------------------\n');
fprintf(fid,'Optimisation related active settings\n');
fprintf(fid,'-------------------------------\n');
   
switch nlpsolver

    case 'de'

        fprintf(fid,'\n\n------> Global Optimizer: DIFFERENTIAL EVOLUTION (DE)\n');
        fprintf(fid,'\n\t\t>Summary of selected DE options: \n');
        fprintf(1,'\n\t\t>Summary of selected DE options: \n');

        fprintf(fid,'\n\t\t  Strategy: %d,  F: %d,  CR: %f,  NP: %d , var: %f \n\n',...
            inputs.nlpsol.DE.strategy,inputs.nlpsol.DE.F,inputs.nlpsol.DE.CR,inputs.nlpsol.DE.NP,inputs.nlpsol.DE.var);
        fprintf(1,'\n\t\t  Strategy: %d,  F: %d,  CR: %f,  NP: %d, var: %f  \n\n',...
            inputs.nlpsol.DE.strategy,inputs.nlpsol.DE.F,inputs.nlpsol.DE.CR,inputs.nlpsol.DE.NP,inputs.nlpsol.DE.var);
%         reports.optimi = 'de';
%         reports.optimisation.global = 'global';
%         reports.optimisation.algorithm_settings = inputs.nlpsol.DE;
    case 'sres'

        fprintf(fid,'\n\n------> Global Optimizer: STOCHASTIC RANKING EVOLUTIONARY SEARCH (SRES)\n');
        fprintf(fid,'\n\t\t>Summary of selected SRES options: \n');
        fprintf(1,'\n\t\t>Summary of selected SRES options: \n');

        fprintf(1,'\n\t\t  NP = %d; itermax= %d;  mu= %f;  pf= %f;  var= %f \n\n',...
            inputs.nlpsol.SRES.NP, inputs.nlpsol.SRES.itermax, inputs.nlpsol.SRES.mu, inputs.nlpsol.SRES.pf, inputs.nlpsol.SRES.var);
        fprintf(fid,'\n\t\t  NP = %d; itermax= %d;  mu= %f;  pf= %f;  var= %d \n\n',...
            inputs.nlpsol.SRES.NP, inputs.nlpsol.SRES.itermax, inputs.nlpsol.SRES.mu, inputs.nlpsol.SRES.pf, inputs.nlpsol.SRES.var);
%         reports.optimisation.algorithm = 'sres';
%         reports.optimisation.type = 'global';
%         reports.optimisation.algorithm_settings = inputs.nlpsol.SRES;
    case {'eSS','ess'}

        fprintf(fid,'\n\n------> Global Optimizer: Enhanced SCATTER SEARCH for parameter estimation\n');
        fprintf(fid,'\n\t\t>Summary of selected eSS options: \n');
        fprintf(1,'\n\t\t>Summary of selected eSS options: \n');

%         fprintf(1,'\n\t\t  maxtime = %d; maxeval= %d;  local solver= %s; \n\n',...
%             inputs.nlpsol.eSS.maxtime, inputs.nlpsol.eSS.maxeval, inputs.nlpsol.eSS.local.solver);
% 
%         fprintf(fid,'\n\t\t  maxtime = %d; maxeval= %d;  local solver= %s; \n\n',...
%             inputs.nlpsol.eSS.maxtime, inputs.nlpsol.eSS.maxeval, inputs.nlpsol.eSS.local.solver);
        ess_options = inputs.nlpsol.eSS;
        AMIGO_displayStruct(ess_options,1,1)
        AMIGO_displayStruct(ess_options,fid,1)
        
%         reports.optimisation.algorithm = 'ess';
%         reports.optimisation.type = 'hybrid';
%         reports.optimisation.algorithm_settings = inputs.nlpsol.eSS;
        
        
%         fprintf(fid,'\n\t\t\t%s options: \n',inputs.nlpsol.eSS.local.solver);
%         fprintf(1  ,'\n\t\t\t%s options: \n',inputs.nlpsol.eSS.local.solver);
        if strcmp(inputs.nlpsol.eSS.local.solver,'nl2sol')
            nl2sol_settings = inputs.nlpsol.eSS.local.nl2sol;
            AMIGO_displayStruct(nl2sol_settings)
            AMIGO_displayStruct(nl2sol_settings,fid)
            
        elseif strcmp(inputs.nlpsol.eSS.local.solver,'lbfgsb')
            lbfgs_settings = inputs.nlpsol.eSS.local.lbfgsb;
            AMIGO_displayStruct(lbfgs_settings)
            AMIGO_displayStruct(lbfgs_settings,fid)
        else
            fprintf(1,'\n\t\t  default options are used. \n\n');
            fprintf(fid,'\n\t\t  default options are used. \n\n');
        end

        
    case 'globalm'

        fprintf(fid,'\n\n------> Global Optimizer: GLOBALm (clustering method)\n');
        fprintf(fid,'\n\t\t>Summary of selected GLOBALm options: \n');
        fprintf(1,'\n\t\t>Summary of selected GLOBALm options: \n');

        fprintf(1,'\n\t\t  nsamples = %d; max_number_clusters= %d, local solver= %s;  maxtime= %s;\n\n',...
            inputs.nlpsol.globalm.nsampl,inputs.nlpsol.globalm.maxnc, inputs.nlpsol.globalm.local, inputs.nlpsol.globalm.maxtime);

        fprintf(fid,'\n\t\t  nsamples = %d; max_number_clusters= %d, local solver= %s;  maxtime= %s;\n\n',...
            inputs.nlpsol.globalm.nsampl,inputs.nlpsol.globalm.maxnc, inputs.nlpsol.globalm.local, inputs.nlpsol.globalm.maxtime);

%         reports.optimisation.algorithm = 'globalm';
%         reports.optimisation.type = 1;
%         reports.optimisation.algorithm_settings = inputs.nlpsol.globalm;
    case 'hybrid'

        fprintf(fid,'\t\t SEQUENTIAL HYBRID: %s and %s. \n', inputs.nlpsol.global_solver, inputs.nlpsol.local_solver);

        switch inputs.nlpsol.global_solver

            case 'de'

                fprintf(fid,'\n\t\t>Summary of selected DE options: \n');
                fprintf(1,'\n\t\t>Summary of selected DE options: \n');
                fprintf(fid,'\n\t\t  Strategy: %d,  F: %d,  CR: %f,  NP: %d , var: %f \n\n',...
                    inputs.nlpsol.DE.strategy,inputs.nlpsol.DE.F,inputs.nlpsol.DE.CR,inputs.nlpsol.DE.NP,inputs.nlpsol.DE.var);
                fprintf(1,'\n\t\t  Strategy: %d,  F: %d,  CR: %f,  NP: %d, var: %f  \n\n',...
                    inputs.nlpsol.DE.strategy,inputs.nlpsol.DE.F,inputs.nlpsol.DE.CR,inputs.nlpsol.DE.NP,inputs.nlpsol.DE.var);

                fprintf(1,'ADVISE!!!: You may need to modify the DE options to select switching point for the hybrid.\n');
                fprintf(fid,'ADVISE!!!: You may need to modify the DE options to select switching point for the hybrid.\n');
%                 reports.optimisation.algorithm = 'globalm';
%                 reports.optimisation.type = 1;
%                 reports.optimisation.algorithm_settings = inputs.nlpsol.globalm;
            case 'sres'

                fprintf(fid,'\n\t\t>Summary of selected SRES options: \n');
                fprintf(1,'\n\t\t>Summary of selected SRES options: \n');

                fprintf(1,'\n\t\t  NP = %d; itermax= %d;  mu= %f;  pf= %f;  var= %f \n\n',...
                    inputs.nlpsol.SRES.NP, inputs.nlpsol.SRES.itermax, inputs.nlpsol.SRES.mu, inputs.nlpsol.SRES.pf, inputs.nlpsol.SRES.var);
                fprintf(fid,'\n\t\t  NP = %d; itermax= %d;  mu= %f;  pf= %f;  var= %d \n\n',...
                    inputs.nlpsol.SRES.NP, inputs.nlpsol.SRES.itermax, inputs.nlpsol.SRES.mu, inputs.nlpsol.SRES.pf, inputs.nlpsol.SRES.var);
                fprintf(1,'ADVISE!!!: You may need to modify the SRES options to select switching point for the hybrid.\n');
                fprintf(fid,'ADVISE!!!: You may need to modify the SRES options to select switching point for the hybrid.\n');
                

        end
        
        case 'local'
                fprintf(fid,'\tSummary of selected local solver (%s) options:\n',inputs.nlpsol.local_solver);
                fprintf(1  ,'\tSummary of selected local solver (%s) options:\n',inputs.nlpsol.local_solver);
                fprintf(fid,'\tmaxeval: %d,\n\tmaxtime: %d\n',inputs.nlpsol.local.maxeval,inputs.nlpsol.local.maxtime);
                fprintf(1  ,'\tmaxeval: %d,\n\tmaxtime: %d\n',inputs.nlpsol.local.maxeval,inputs.nlpsol.local.maxtime);

end

fclose(fid);