% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_clouds.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_clouds: plots clouds by pairs of parameters in the Robust identifiability
%                    analysis
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
% AMIGO_plot_clouds: plots clouds by pairs of parameters in the Robust        %
%                    identifiability analysis                                 %
%                                                                             %
%*****************************************************************************%

for ipar=1:inputs.PEsol.n_theta-1
       % GLOBAL PARS
        for jpar=ipar+1:inputs.PEsol.n_global_theta
        figure    
        plot(results.rid.best95_norm(:,ipar),results.rid.best95_norm(:,jpar),'.')   
        hold on
        AMIGO_plot_ellipse(results.rid.semi_major(ipar,jpar),results.rid.semi_minor(ipar,jpar),1,1,results.rid.alfa(ipar,jpar),'r');
        hold on
        plot(1,1,'^g')
        plot(results.rid.vtheta_guess(ipar)/results.rid.mu(ipar),results.rid.vtheta_guess(jpar)/results.rid.mu(jpar),'*r')
        hold on
        h=plot([1 1+results.rid.semi_major(ipar,jpar)*cos(results.rid.alfa(ipar,jpar))],[1 1+results.rid.semi_major(ipar,jpar)*sin(results.rid.alfa(ipar,jpar))],'k');
        set(h,'LineWidth',2)
       
       if numel(inputs.model.par_names)>0
       title_plot=[inputs.model.par_names(inputs.PEsol.index_global_theta(ipar),:), ' vs ', inputs.model.par_names(inputs.PEsol.index_global_theta(jpar),:)];
       title(title_plot);
       xlabel(inputs.model.par_names(inputs.PEsol.index_global_theta(ipar),:));
       ylabel(inputs.model.par_names(inputs.PEsol.index_global_theta(jpar),:));    
       file_name=strcat(inputs.pathd.conf_cloud_path,'_',inputs.model.par_names(inputs.PEsol.index_global_theta(ipar),:),'_',inputs.model.par_names(inputs.PEsol.index_global_theta(jpar),:));
       else
       title_plot=['par ' num2str(inputs.PEsol.index_global_theta(jpar)), ' vs par ', num2str(inputs.PEsol.index_global_theta(ipar))];
       title(title_plot);
       xlabel(strcat('par ',num2str(inputs.PEsol.index_global_theta(ipar))));
       ylabel(strcat('par ',num2str(inputs.PEsol.index_global_theta(jpar))));    
       file_name=strcat(inputs.pathd.conf_cloud_path,'_par',num2str(inputs.PEsol.index_global_theta(ipar)),'_par',num2str(inputs.PEsol.index_global_theta(jpar)));
       end
  
       saveas(gcf, file_name, 'fig')
       % Saves a .eps color figure
        if inputs.plotd.epssave==1;
        print( gcf, '-depsc', file_name); end;
    end % jpar=ipar+1:inputs.n_theta
    
      close all  
end % for ipar=1:inputs.n_theta-1
    
    
    % GLOBAL y0
    counterg=inputs.PEsol.n_global_theta;
    
    if inputs.PEsol.n_global_theta_y0>0
     
        for ipar=1:inputs.PEsol.n_theta-1  
        for jpar=ipar+1:inputs.PEsol.n_global_theta_y0
           
        figure    
        plot(results.rid.best95_norm(:,ipar),results.rid.best95_norm(:,jpar+counterg),'.')   
        hold on
        AMIGO_plot_ellipse(results.rid.semi_major(ipar,jpar+counterg),results.rid.semi_minor(ipar,jpar+counterg),1,1,results.rid.alfa(ipar,jpar+counterg),'r');
        hold on
        plot(1,1,'^g')
        plot(results.rid.vtheta_guess(ipar)/results.rid.mu(ipar),results.rid.vtheta_guess(jpar+counterg)/results.rid.mu(jpar+counterg),'*r')
        hold on
        h=plot([1 1+results.rid.semi_major(ipar,jpar+counterg)*cos(results.rid.alfa(ipar,jpar+counterg))],[1 1+results.rid.semi_major(ipar,jpar+counterg)*sin(results.rid.alfa(ipar,jpar+counterg))],'k');
        set(h,'LineWidth',2)
       
       if numel(inputs.model.par_names)>0 && numel(inputs.model.st_names)>0
       title_plot=[inputs.model.par_names(inputs.PEsol.index_global_theta(ipar),:) 'vs ' inputs.model.st_names(inputs.PEsol.index_global_theta_y0(jpar),:)];
       title(title_plot);
       xlabel(inputs.model.par_names(inputs.PEsol.index_global_theta(ipar),:));
       ylabel(inputs.model.st_names(inputs.PEsol.index_global_theta_y0(jpar),:));    
       file_name=strcat(inputs.pathd.conf_cloud_path,'_',inputs.model.par_names(inputs.PEsol.index_global_theta(ipar),:),'_',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(jpar),:));
       else
       title_plot=['par ' num2str(inputs.PEsol.index_global_theta_y0(jpar)) 'vs par ' num2str(inputs.PEsol.index_global_theta(ipar))];
       title(title_plot);
       xlabel(strcat('par ',num2str(inputs.PEsol.index_global_theta(ipar))));
       ylabel(strcat('par ',num2str(inputs.PEsol.index_global_theta(jpar))));    
       file_name=strcat(inputs.pathd.conf_cloud_path,'_par',num2str(inputs.PEsol.index_global_theta(ipar)),'_y0',num2str(inputs.PEsol.index_global_theta_y0(jpar)));
       end
  
       saveas(gcf, file_name, 'fig')
       % Saves a .eps color figure
        if inputs.plotd.epssave==1;
        print( gcf, '-depsc', file_name); end;
        end;
        close all
        end;       
        
    end    
    
    
    
    
    
