% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_rconf.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_rconf: plots robust confidence for unknowns
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
%   AMIGO_plot_rconf: plots robust confidence for unknowns                    %
%                                                                             %
%*****************************************************************************%    



for i=1:inputs.PEsol.n_global_theta
    figure
    N=hist(results.rid.best95(:,i),20);
    hist(results.rid.best95(:,i),20)
    hold on
    plot([results.rid.vtheta_guess(i) results.rid.vtheta_guess(i)],[0 max(N)+1],'r-')
    hold on
    %plot([results.mu(i) results.mu(i)],[0 max(N)+1],'k-')
    plot([results.rid.mu(i) results.rid.mu(i)],[0 max(N)+1],'k-')
    hold on
    plot([results.rid.mu(i)-results.rid.confidence_interval(i) results.rid.mu(i)-results.rid.confidence_interval(i)],[2 7],'g-')
    hold on
    plot([results.rid.mu(i)+results.rid.confidence_interval(i) results.rid.mu(i)+results.rid.confidence_interval(i)],[2 7],'g-')
    hold on
    plot([results.rid.mu(i)-results.rid.confidence_interval(i) results.rid.mu(i)+results.rid.confidence_interval(i)],[4.5 4.5],'g-')
 
    
    
            if numel(inputs.model.par_names)>1
            file_name=strcat(inputs.pathd.conf_hist_path,'_',inputs.model.par_names(inputs.PEsol.index_global_theta(i),:));
            title('Monte-Carlo based confidence interval');
            xlabel(inputs.model.par_names(inputs.PEsol.index_global_theta(i),:));
            else
            title('Monte-Carlo based confidence interval');
            xlabel(strcat('par ',num2str(inputs.index_theta(ipar))));
            file_name=strcat(inputs.pathd.conf_hist_path,'_par', num2str(inputs.PEsol.index_global_theta(i)));
            end
    
            saveas(gcf, file_name, 'fig')
            % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', file_name); end    
end
            
counterg=inputs.PEsol.n_global_theta;            
if inputs.PEsol.n_global_theta_y0>0
    
    for i=1:inputs.PEsol.n_global_theta_y0
    figure
    N=hist(results.rid.best95(:,i+counterg),20);
    hist(results.rid.best95(:,i+counterg),20)
    hold on
    plot([results.rid.vtheta_guess(i+counterg) results.rid.vtheta_guess(i+counterg)],[0 max(N)+1],'r-')
    hold on
    plot([results.rid.mu(i+counterg) results.rid.mu(i+counterg)],[0 max(N)+1],'k-')
    hold on
    plot([results.rid.mu(i+counterg)-results.rid.confidence_interval(i+counterg) results.rid.mu(i+counterg)-results.rid.confidence_interval(i+counterg)],[2 7],'g-')
    hold on
    plot([results.rid.mu(i+counterg)+results.rid.confidence_interval(i+counterg) results.rid.mu(i+counterg)+results.rid.confidence_interval(i+counterg)],[2 7],'g-')
    hold on
    plot([results.rid.mu(i+counterg)-results.rid.confidence_interval(i+counterg) results.rid.mu(i+counterg)+results.rid.confidence_interval(i+counterg)],[4.5 4.5],'g-')
 
    
            if numel(inputs.model.st_names)>1
            file_name=strcat(inputs.pathd.conf_hist_path,'_',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(i),:));
            title('Monte-Carlo based confidence interval');
            xlabel(inputs.model.st_names(inputs.PEsol.index_global_theta_y0(i),:));
            else
            title('Monte-Carlo based confidence interval');
            xlabel(strcat('y0',num2str(inputs.PEsol.index_global_theta_y0(i))));
            file_name=strcat(inputs.pathd.conf_hist_path,'_y0', num2str(inputs.PEsol.index_global_theta_y0(i)));
            end
     
        
            if numel(inputs.model.st_names)>1
            file_name=strcat(inputs.pathd.conf_hist_path,'_',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(i),:));
            else
            file_name=strcat(inputs.pathd.conf_hist_path,'_y0', num2str(inputs.PEsol.index_global_theta_y0(i)));
            end
            saveas(gcf, file_name, 'fig')
            % Saves a .eps color figure
            if inputs.plotd.epssave==1;
            print( gcf, '-depsc', file_name); end  
    end    
    
    
end    
            
            