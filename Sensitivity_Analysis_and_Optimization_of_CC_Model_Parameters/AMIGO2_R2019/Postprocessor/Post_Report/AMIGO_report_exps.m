% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_exps.m 2327 2015-11-30 00:42:50Z davidh $
% AMIGO_report_exps: reports information experimental scheme
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
%   AMIGO_report_exps: reports information about experimental scheme          %
%                                                                             %
%*****************************************************************************%



    fprintf(fid,'\n\n-------------------------------------------\n');
    fprintf(fid,'  Experimental scheme related information\n');
    fprintf(fid,'-------------------------------------------\n');
   
    fprintf(fid,'\n\n-->Number of experiments: %i\n\n',inputs.exps.n_exp);
  
%
% REPORTS INITIAL CONDITIONS
%
    
    fprintf(fid,'\n-->Initial conditions for each experiment:\n');
    
    for iexp=1:inputs.exps.n_exp
        

       switch inputs.exps.exp_y0_type{iexp}
       case 'fixed' 
         fprintf(fid,'\t\tExperiment %i: \n',iexp);
         fprintf(fid,'\t\t\texp_y0=[');   
         fprintf(fid,'%8.3e  ',inputs.exps.exp_y0{iexp});  
         fprintf(fid,']\n');
       case 'od' 
         fprintf(fid,'\t\tExperiment %i: \n',iexp);
         fprintf(fid,'\t\t\texp_y0=[');   
         fprintf(fid,'%8.3e  ',privstruct.y_0{iexp});  
         fprintf(fid,']\n');
         fprintf(1,'\t\tExperiment %i: \n',iexp);
         fprintf(1,'\t\t\texp_y0=[');   
         fprintf(1,'%8.3e  ',privstruct.y_0{iexp});  
         fprintf(1,']\n');
       end 

    end
 
%
% REPORTS OBSERVABLES
%
     
        
    for iexp=1:inputs.exps.n_exp
        
        
       switch inputs.exps.obs_type{iexp}

       case 'od' 
           fprintf(fid,'\n-->Observables for each experiment: \n');   
          fprintf(fid,'\t\tExperiment %i: obs=[\t',iexp);
          for iobs=1:inputs.exps.n_obs{iexp}
          if results.oed.w_obs{iexp}(1,iobs)>0   
          fprintf(fid,'%s  ',inputs.exps.obs_names{iexp}(iobs,:));  
          end
          end
          fprintf(fid,']\n');

          fprintf(1,'\n-->Observables for each experiment: \n');   
          fprintf(1,'\t\tExperiment %i: obs=[\t',iexp);
          for iobs=1:inputs.exps.n_obs{iexp}
          if results.oed.w_obs{iexp}(1,iobs)>0    
          fprintf(1,'%s  ',inputs.exps.obs_names{iexp}(iobs,:));  
          end
          end
          fprintf(1,']\n');
       end 

    end
    
      


%
% REPORTS EXPERIMENT DURATIONS 
% 

        for iexp=1:inputs.exps.n_exp
        switch inputs.exps.tf_type{iexp}
            case 'fixed'    
            fprintf(fid,'\n-->Final process time for each experiment: \n');    
            fprintf(fid,'\t\tExperiment %i: \t %f\n',iexp,inputs.exps.t_f{iexp});  
                       
            case 'od'                            
            fprintf(fid,'\n-->Final process time for each experiment: \n');      
            fprintf(1,'\n-->Final process time for each experiment: \n');
            fprintf(fid,'\t\tExperiment %i: \t %f\n',iexp,privstruct.t_f{iexp});
            fprintf(1,'\t\tExperiment %i: \t %f\n',iexp,privstruct.t_f{iexp});
        end
       end
    
%
% REPORTS SAMPLING TIMES
% 

    for iexp=1:inputs.exps.n_exp
            
            switch inputs.exps.ts_type{iexp}
            case 'fixed'    
            fprintf(fid,'\n\n-->Sampling times for each experiment: \n');    
            fprintf(fid,'\t\tExperiment %i: \t ',iexp,'n_s: %i \t',inputs.exps.n_s{iexp});
            fprintf(fid,'%8.3e  ',inputs.exps.t_s{iexp});  
            case 'od'            
            fprintf(fid,'\n-->Sampling times for each experiment: \n');     
            fprintf(1,'\n-->Sampling times for each experiment: \n');
            fprintf(fid,'\t\tExperiment %i, \t n_s: %i \t',iexp,privstruct.n_s{iexp});
            fprintf(1,'\t\tExperiment %i, \t n_s: %i \t',iexp,privstruct.n_s{iexp});
            fprintf(fid,'%8.3e  ',privstruct.t_s{iexp}); 
            fprintf(1,'%8.3e  ',privstruct.t_s{iexp}); 
            end
    end

   
    

    
    
  
%
% REPORTS STIMULATION CONDITIONS
%    
    

    if inputs.model.n_stimulus==0
         fprintf(fid,'\n\n--> There is no manipulable (control, stimulus, input) variable, inputs.model.n_stimulus=0\n');
    else
        fprintf(fid,'\n\n-->Number of manipulable (control, stimulus, input) variables: %i\n',inputs.model.n_stimulus);
     
       for iexp=1:inputs.exps.n_exp    
           
         switch inputs.exps.u_type{iexp}   
           
            case 'fixed'   
            AMIGO_uinterp
            AMIGO_report_control(iexp,inputs,inputs.exps.u,inputs.exps.t_con,fid)
        
            case 'od'
            AMIGO_report_control(iexp,inputs,privstruct.u,privstruct.t_con,fid)
            AMIGO_report_control(iexp,inputs,privstruct.u,privstruct.t_con,1)
        
        end    

     end  %for iexp=1:inputs.exps.n_exp   
        
    end % if inputs_def.model.n_u==0
    
    