% AMIGO_report_DO: reports optimal control profile & constraints
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
%  AMIGO_report_DO: reports optimal control profile & constraints             %
%                                                                             %
%*****************************************************************************%

    
    fprintf(fid,'\n\n----------------------------------------\n');
     fprintf(1,'\n\n----------------------------------------\n');
     fprintf(fid,'\t>>>> INVERSE DYNAMIC OPTIMIZATION:');
     fprintf(1,'\t >>>> INVERSE DYNAMIC OPTIMIZATION:');
     fprintf(fid,'\n----------------------------------------\n');
     fprintf(1,'\n----------------------------------------\n');
        
    
   
     fprintf(fid,'\t   \n\n>>>> Control regularization, alpha= %e ', inputs.model.alpha);
     fprintf(1,'\t   \n\n>>>> Control regularization, alpha= %e ', inputs.model.alpha);
     
     fprintf(fid,'\t   \n\n>>>> Parameter estimation regularization, beta= %e \n', inputs.model.beta);
     fprintf(1,'\t   \n\n>>>> Parameter estimation regularization, beta= %e \n', inputs.model.beta);

     
     fprintf(fid,'\t   \n\n>>>> Best objective function: %e \n',results.nlpsol.fbest);
     fprintf(1,'\t   \n\n>>>> Best objective function: %e \n',results.nlpsol.fbest);
  
   
     
     if inputs.IOCsol.n_y0>0
         
     fprintf(fid,'\n>>>> Best initial conditions \n');    
     fprintf(1,'\n>>>> Best initial conditions \n');
     for iy0=1:inputs.IOCsol.n_y0
       fprintf(fid,'\t   \n    %s: %f\n', inputs.IOCsol.id_y0(iy0,:), results.ioc.uy0(iy0));
       fprintf(1,'\t   \n    %s: %f\n', inputs.IOCsol.id_y0(iy0,:), results.ioc.uy0(iy0));
     end
     end
    
      if inputs.IOCsol.n_par>0
        fprintf(fid,'\n>>>> Best parameter values \n');    
       fprintf(1,'\n>>>> Best parameter values \n\n');   
      for ipar=1:inputs.IOCsol.n_par
       fprintf(fid,'\t     %s: %e\n', inputs.IOCsol.id_par(ipar,:), results.ioc.upar(ipar));
       fprintf(1,'\t     %s: %e\n', inputs.IOCsol.id_par(ipar,:), results.ioc.upar(ipar));
      end
      end
     
     fprintf(fid,'\t   \n\n>>>> Best control profile:\n');
     fprintf(1,'\t   \n\n>>>> Best control profile:\n');
     
      for iexp=1:inputs.exps.n_exp
      
      fprintf(fid,'\t   \n\n>>>> Experiment:%u\n',iexp);
      fprintf(1,'\t   \n\n>>>> Experiment:%u\n',iexp);
      for iu=1:inputs.model.n_stimulus
      fprintf(fid,'\t   \n\n>>>> Control u: %u\n', iu);
      fprintf(1,'\t   \n\n>>>> Control u: %u\n', iu);
      if inputs.IOCsol.n_steps{iexp}==1      
      if size(results.ioc.u{iexp},1)>1
          fprintf(fid,'\t %f ',results.ioc.u{iexp}(iu,1));
      fprintf(1,'\t %f ',results.ioc.u{iexp}(iu,1));   
      privstruct.u{iexp}(iu,1)=results.ioc.u{iexp}(iu,1);
      else
      fprintf(fid,'\t %f ',results.ioc.u{iexp}(1,iu));
      fprintf(1,'\t %f ',results.ioc.u{iexp}(1,iu));   
      privstruct.u{iexp}(iu,1)=results.ioc.u{iexp}(1,iu);
      end
      else    
      for icon=1:size(results.ioc.u{iexp},2)
      fprintf(fid,'\t %f ',results.ioc.u{iexp}(iu,icon));
      fprintf(1,'\t %f ',results.ioc.u{iexp}(iu,icon));
      end 
      end
     end
     
     fprintf(fid,'\n\t   \n\n>>>> Switching times:\n');
     fprintf(1,'\n\t   \n\n>>>> Switching times:\n');
      for icon=1:size(results.ioc.t_con{iexp},2)
      fprintf(fid,'\t %f ',results.ioc.t_con{iexp}(icon));
      fprintf(1,'\t %f ',results.ioc.t_con{iexp}(icon));
      end   
          
      fprintf(1,'\t   \n\n>>>> Final time: %f\n',results.ioc.t_f{iexp});
      fprintf(fid,'\t   \n\n>>>> Final time: %f\n',results.ioc.t_f{iexp});
      end
     
      fprintf(1,'\t   \n\n>>>> Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
      fprintf(fid,'\t   \n\n>>>> Constraints violation (c<=0): Equality constraints, Inequality constraints, Control constraints\n');
      for icons=1:length(results.ioc.constraints_viol)
          fprintf(1,'\t c(%u)=%4.2e;\n',icons,results.ioc.constraints_viol(1,icons));
          fprintf(fid,'\t c(%u)=%4.2e;\n',icons,results.ioc.constraints_viol(1,icons));
      end
 

    
    