% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_control.m 1404 2014-04-10 14:21:14Z davidh $
function AMIGO_report_control(iexp,inputs,u,t_con,fid);
% AMIGO_report_control: reports information about stimulus
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
%   % AMIGO_report_control: reports information about stimulus                %
%                                                                             %
%*****************************************************************************%




switch  inputs.exps.u_interp{iexp}
    
    case 'sustained'
        fprintf(fid,'\n\n-->Input values/temporal elements for Experiment %i:\n',iexp);
        fprintf(fid,'\t\t%s interpolation is being used.', inputs.exps.u_interp{iexp});
        fprintf(fid,'\n\t\t\tControl values:\n');
        for iu=1:inputs.model.n_stimulus
            fprintf(fid,'\t\t\tInput %i:\t',iu);
            fprintf(fid,'%8.4f\n',u{iexp}(iu));
        end
        
    case 'step'
        
        fprintf(fid,'\n\n-->Input values/temporal elements for Experiment %i:\n',iexp);
        fprintf(fid,'\t\t%s interpolation is being used.', inputs.exps.u_interp{iexp});
        fprintf(fid,'\n\t\t\tControl values:\n');
        for iu=1:inputs.model.n_stimulus
            fprintf(fid,'\t\t\tInput %i:\t',iu);
            for istep=1:inputs.exps.n_steps{iexp}
                fprintf(fid,'%8.4f\t',u{iexp}(iu,istep));
            end
        end
        
        fprintf(fid,'\n\t\t\tControl switching times: ');
        
        
        for icon=1:inputs.exps.n_steps{iexp}+1
            fprintf(fid,'\t%8.4f',inputs.exps.t_con{iexp}(icon));
        end
        fprintf(fid,'\n');
        
    case {'pulse-up'}
        fprintf(fid,'\n\n-->Input values/temporal elements for Experiment %i:\n',iexp);
        fprintf(fid,'\t\t%s interpolation is being used.', inputs.exps.u_interp{iexp});
        
        fprintf(fid,'\n\t\t\tControl values:\n ');
        for iu=1:inputs.model.n_stimulus
            fprintf(fid,'\t\t\tInput %i:\t',iu);
            for istep=1:2*inputs.exps.n_pulses{iexp}
                fprintf(fid,'%8.4f\t',u{iexp}(iu,istep));
            end
        end
        
        fprintf(fid,'\n\t\t\tControl switching times: ');
        fprintf(fid,'\t%8.4f',t_con{iexp});
        fprintf(fid,'\n');
        
        
    case {'pulse-down'}
        fprintf(fid,'\n\n-->Input values/temporal elements for Experiment %i:\n',iexp);
        fprintf(fid,'\t\t%s interpolation is being used.', inputs.exps.u_interp{iexp});
        fprintf(fid,'\n\t\t\tControl values:\n ');
        for iu=1:inputs.model.n_stimulus
            fprintf(fid,'\t\t\tInput %i:\t',iu);
            for istep=1:2*inputs.exps.n_pulses{iexp}
                fprintf(fid,'%8.4f\t',u{iexp}(iu,istep));
            end
        end
        fprintf(fid,'\n\t\t\tControl switching times: ');
        fprintf(fid,'\t%8.4f',t_con{iexp});
        fprintf(fid,'\n');
        
    case {'linear'}
        fprintf(fid,'\n\n-->Input values/temporal elements for Experiment %i:\n',iexp);
        fprintf(fid,'\t\t%s interpolation is being used.', inputs.exps.u_interp{iexp});
        fprintf(fid,'\n\t\t\tControl values: ');
        for iu=1:inputs.model.n_stimulus
            fprintf(fid,'\t\t\tInput %i:\t',iu);
            for istep=1:inputs.exps.n_linear{iexp}-1
                fprintf(fid,'%8.4f\t',u{iexp}(iu,istep));
            end
        end
        fprintf(fid,'\n\t\t\tControl switching times: ');
        fprintf(fid,'\t%8.4f',t_con{iexp});
        fprintf(fid,'\n');
        
        
end %switch  inputs.exps.u_interp{iexp}