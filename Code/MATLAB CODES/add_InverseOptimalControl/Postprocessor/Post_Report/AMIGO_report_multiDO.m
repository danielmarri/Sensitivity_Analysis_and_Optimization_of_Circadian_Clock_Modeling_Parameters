% AMIGO_report_multido: reports optimal control profile & constraints
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
%  AMIGO_report_multido_wsm: reports optimal control profile & constraints    %
%                            for multi-objective DO problems                  %
%                                                                             %
%*****************************************************************************%

  

     
      fprintf(fid,'\t   \n\n>>>> Best control profiles:\n');
      fprintf(1,'\t   \n\n>>>> Best control profiles:\n');

      
      for ipareto=1:n_solutions
          
      fprintf(1,'\t   \n\n>>>> Solution %u;\n', ipareto); 
      fprintf(fid,'\t   \n\n>>>> Solution %u;\n', ipareto); 
%      

      for iy0=1:inputs.DOsol.n_y0
       fprintf(fid,'\t   \n  Initial condition %s: %f\n', inputs.DOsol.id_y0(iy0,:), results.do.uy0{ipareto}(iy0));
       fprintf(1,'\t   \n Initial condition %s: %f\n', inputs.DOsol.id_y0(iy0,:), results.do.uy0{ipareto}(iy0));
      end

      for ipar=1:inputs.DOsol.n_par
       fprintf(fid,'\t   \n  Constant Control %s: %f\n', inputs.DOsol.id_par(ipar,:), results.do.upar{ipareto}(ipar));
       fprintf(1,'\t   \n  Constant Control %s: %f\n', inputs.DOsol.id_par(ipar,:), results.do.upar{ipareto}(ipar));
      end

      for iu=1:inputs.model.n_stimulus
       fprintf(fid,'\t   \n     Control u: %u\n', iu);
       fprintf(1,'\t   \n     Control u: %u\n', iu);
       for icon=1:size(results.do.u{ipareto},2)
       fprintf(fid,'\t %f ',results.do.u{ipareto}(iu,icon));
       fprintf(1,'\t %f ',results.do.u{ipareto}(iu,icon));
       end     
      end
%      
      fprintf(fid,'\n\t   \n     Switching times:\n');
      fprintf(1,'\n\t   \n     Switching times:\n');
       for icon=1:size(results.do.t_con{ipareto},2)
       fprintf(fid,'\t %f ',results.do.t_con{ipareto}(icon));
       fprintf(1,'\t %f ',results.do.t_con{ipareto}(icon));
       end   
%           
       fprintf(1,'\t   \n\n     Final time: %f\n',results.do.t_f{ipareto});
       fprintf(fid,'\t   \n\n     Final time: %f\n',results.do.t_f{ipareto});
      
       if  length(results.do.constraints_viol{ipareto}) >1
       fprintf(1,'\t   \n     Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
       fprintf(fid,'\t   \n     Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
       for icons=1:length(results.do.constraints_viol{ipareto})
           fprintf(1,'\t c(%u)=%4.2e;\n',icons,results.do.constraints_viol{ipareto}(1,icons));
           fprintf(fid,'\t c(%u)=%4.2e;\n',icons,results.do.constraints_viol{ipareto}(1,icons));
       end
       end %if  results.nlpsol.ntotalconstraints >0
      end % for ipareto=1:n_solutions
        

    
    