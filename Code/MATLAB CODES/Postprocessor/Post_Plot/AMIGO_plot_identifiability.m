% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_identifiability.m 2203 2015-09-24 07:11:27Z evabalsa $
% AMIGO_plot_identifiability: plots related to the MC based identifiability
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
%  AMIGO_plot_identifiability: Plots Monte-Carlo based confidence             %
%                              ellipses by pairs of parameters: "cloud" of    %
%                              solutions together with the corresponding      %
%                              ellipse                                        %
%                              Histograms corresponding to the confidence     %
%                              regions or expected uncertainties of the       %
%                              parameters                                     %
%                                                                             %
%                              Plots are saved in .fig and .eps formats       %
%*****************************************************************************%
          
    for ipar=1:inputs.n_theta-1
        for jpar=ipar+1:inputs.n_theta
    figure    
    plot(results.best95_norm(:,ipar),results.best95_norm(:,jpar),'.')   
    hold on
 %   hEllipse = AMIGO_plot_ellipse(semi_major(ipar,jpar),semi_minor(ipar,jpar),results.mu(ipar),results.mu(jpar),results.alfa_max(ipar,jpar),'r');
    hEllipse = AMIGO_plot_ellipse(semi_major(ipar,jpar),semi_minor(ipar,jpar),1,1,results.alfa_max(ipar,jpar),'r');
    set(hEllipse,'LineWidth',2)
    hold on
  %  plot(results.mu(ipar),results.mu(jpar),'*r')
    plot(1,1,'^g')
    plot(XBEST(ipar)/results.mu(ipar),XBEST(jpar)/results.mu(jpar),'*r')
    hold on
 %   h=plot([results.mu(ipar) results.mu(ipar)+semi_major(ipar,jpar)*cos(results.alfa_max(ipar,jpar))],[results.mu(jpar) results.mu(jpar)+semi_major(ipar,jpar)*sin(results.alfa_max(ipar,jpar))],'k');
    h=plot([1 1+semi_major(ipar,jpar)*cos(results.alfa_max(ipar,jpar))],[1 1+semi_major(ipar,jpar)*sin(results.alfa_max(ipar,jpar))],'k');
    set(h,'LineWidth',2)
    

 
    
  % Keeps the .fig file

      if numel(inputs.model.par_names)>1
      title_plot=('Monte-Carlo based ellipse');
      title(title_plot);
      xlabel(strcat(inputs.model.par_names(inputs.index_theta(ipar),:),'/\mu'));
      ylabel(strcat(inputs.model.par_names(inputs.index_theta(jpar),:),'/\mu'));
      file_name=strcat(results.conf_plot_path,'_',inputs.model.par_names(inputs.index_theta(ipar),:),'_',inputs.model.par_names(inputs.index_theta(jpar),:));
      else
      title_plot=('Monte-Carlo based ellipse');
      title(title_plot);
      xlabel(strcat('par ',num2str(inputs.index_theta(ipar)),'/\mu'));
      ylabel(strcat('par ',num2str(inputs.index_theta(jpar)),'/\mu'));  
      file_name=strcat(results.conf_plot_path,'_p',num2str(inputs.index_theta(ipar)),'_p',num2str(inputs.index_theta(jpar)));
      end
  
    saveas(gcf, file_name, 'fig')
  % Saves a .eps color figure
    print( gcf, '-depsc', file_name)
    end % jpar=ipar+1:inputs.n_theta
    close
    end % for ipar=1:inputs.n_theta-1
     
   close all;
     % PLOTS HISTOGRAMS 
    for i=1:inputs.n_theta
    figure
    N=hist(results.best95(:,i),20);
    hist(results.best95(:,i),20)
    hold on
    plot([XBEST(i) XBEST(i)],[0 max(N)+1],'r-')
    hold on
    %plot([results.mu(i) results.mu(i)],[0 max(N)+1],'k-')
    plot([results.mu(i) results.mu(i)],[0 max(N)+1],'k-')
    hold on
    plot([results.mu(i)-results.confidence_interval(i) results.mu(i)-results.confidence_interval(i)],[2 7],'g-')
    hold on
    plot([results.mu(i)+results.confidence_interval(i) results.mu(i)+results.confidence_interval(i)],[2 7],'g-')
    hold on
    plot([results.mu(i)-results.confidence_interval(i) results.mu(i)+results.confidence_interval(i)],[4.5 4.5],'g-')
%     hold on
%     plot([results.mu(i)-results.stdev(i) results.mu(i)-results.stdev(i)],[5.5 6.5],'c-')
%     hold on
%     plot([results.mu(i)+results.stdev(i) results.mu(i)+results.stdev(i)],[5.5 6.5],'c-')
%     hold on
%     plot([results.mu(i)-results.stdev(i) results.mu(i)+results.stdev(i)],[6 6],'c-')
    
            if numel(inputs.model.par_names)>1
            file_name=strcat(results.conf_plot_path,'_hist_',inputs.model.par_names(inputs.index_theta(i),:));
            title('Monte-Carlo based confidence interval');
            xlabel(strcat('par ',num2str(inputs.index_theta(ipar))));
            else
            title('Monte-Carlo based confidence interval');
            xlabel(inputs.model.par_names(inputs.index_theta(ipar),:));
            file_name=strcat(results.conf_plot_path,'_hist_p',num2str(inputs.index_theta(i)));
            end
    saveas(gcf, file_name, 'fig')
    % Saves a .eps color figure
    print( gcf, '-depsc', file_name) 
    close
end
    

    % PLOTS CORRELATION MATRIX
       figure
       pcolor(results.mc_corrmat)
       caxis([-1,1])
       colorbar
       set(gca,'YTick',1+0.5:1:inputs.n_theta+0.5,'YTickLabel',inputs.index_theta);
       set(gca,'XTick',1+0.5:1:inputs.n_theta+0.5,'XTickLabel',inputs.index_theta);
       title('MC based identifiability analysis');
       % Keeps the .fig file
       corr_curve_path=strcat(results.conf_plot_path,'_MC_corrmat');   
       saveas(gcf, corr_curve_path, 'fig')
        % Saves a .eps color figure
        print( gcf, '-depsc', corr_curve_path)
        % close all;