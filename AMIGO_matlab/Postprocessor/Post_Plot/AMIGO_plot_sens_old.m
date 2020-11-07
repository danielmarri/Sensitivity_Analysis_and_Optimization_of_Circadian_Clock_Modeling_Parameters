% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_sens_old.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_plot_sens: plots parametric sensitivities vs time
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
%  AMIGO_plot_sens: plots observables parametric relative and absolute        %
%                   sensitivities vs time                                     %   
%                                                                             %
%*****************************************************************************%

if privstruct.istate_sens <0
     fprintf(1,'\n\n >>>> An error ocurred when computing sensitivities. Sorry, it is not possible to plot sensitivities.'); 
else

    index_theta=[inputs.PEsol.index_global_theta inputs.PEsol.index_local_theta{iexp}];
    for iexp=1:inputs.exps.n_exp
    theta=results.xbest;   
    AMIGO_initial_conditions;
    leyenda_par='';
    leyenda_y0='';
            
            if  prod(size(inputs.model.par_names))>=1 
            for ipar=1:inputs.n_theta    
            leyenda_par(ipar,:)=strvcat(inputs.model.par_names(inputs.index_theta(ipar),:));
            end; 
            else
            for ipar=1:inputs.n_theta    
            leyenda_par(ipar,:)=strvcat(strcat('\theta_',num2str(inputs.index_theta(ipar))));
            end    
            end
            
            if prod(size(inputs.states_names))>=1
            for iy0=1:inputs.n_theta_y0{iexp}
            leyenda_y0(iy0,:)=strvcat(inputs.states_names(inputs.index_theta_y0{iexp}(iy0),:));
            end;   
            else
            for iy0=1:inputs.n_theta_y0{iexp}
            leyenda_y0(iy0,:)=strvcat(strcat('y0_',num2str(inputs.index_theta_y0{iexp}(iy0)))); 
            end    
            end   
    
            leyenda=strvcat(leyenda_par,leyenda_y0);
            
     for iobs=1:inputs.n_obs{iexp}
         
    
%  PLOTS ABSOLUTE SENSITIVITIES
     
     figure
     subplot(1,2,1)
     
  
     senst=reshape(results.senst_opt{iexp}(:,iobs,:),inputs.n_m{iexp},ndim_theta);
     plot(inputs.t_m{iexp},senst','LineWidth',1)
     xlabel('Time')
         
            if  prod(size(inputs.obs_names{iexp}))>=1
            plot_title=strcat('Abs. sens.  ', inputs.obs_names{iexp}(iobs,:), '; exp: ', mat2str(iexp));
            else   
            plot_title=strcat('Absolute sens. Obs: ', mat2str(iobs),'; exp: ', mat2str(iexp)); 
            end
            title(plot_title);   
            legend(leyenda);
     
     %  PLOTS FULL RELATIVE SENSITIVITIES
     
     subplot(1,2,2)   
     rsenst=reshape(results.r_senst_opt{iexp}(:,iobs,:),size(privstruct.row_yms_0{iexp},2),ndim_theta);
     plot(inputs.t_m{iexp}(privstruct.row_yms_0{iexp}),rsenst','LineWidth',1)
      
            if  prod(size(inputs.obs_names{iexp}))>=1
            plot_title=strcat('Full rel. sens.  ', inputs.obs_names{iexp}(iobs,:), '; exp: ', mat2str(iexp));
            else   
            plot_title=strcat('Full rel. sens. Obs: ', mat2str(iobs),'; exp: ', mat2str(iexp)); 
            end
     
            xlabel('Time')
            title(plot_title);
            legend(leyenda);
            sens_time_path=strcat(results.pathd.sens_time_path,'_obs',num2str(iobs),'_exp',num2str(iexp)); 
     % Keeps the .fig file
         saveas(gcf, sens_time_path, 'fig')
     % Saves a .eps color figure
         print( gcf, '-depsc', sens_time_path)
     
     end
 end
end
