% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_meanmax_residuals.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_plot_meanmax_residuals: plots mean and max residuals
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
% AMIGO_plot_meanmax_residuals: plots mean and max residuals for all          %
% experiments and observables.                                                % 
%                                                                             %
%*****************************************************************************%

  mean_res=zeros(inputs.exps.n_exp, max(cell2mat(inputs.exps.n_obs)));
  max_res=zeros(inputs.exps.n_exp, max(cell2mat(inputs.exps.n_obs)));
  
  mean_res=mean(abs(results.fit.rel_residuals{1}),1);
  max_res=max(abs(results.fit.rel_residuals{1}),[],1);

    for iexp=1:inputs.exps.n_exp
    mean_res=mean(abs(results.fit.rel_residuals{iexp}),1);
    max_res=max(abs(results.fit.rel_residuals{iexp}),[],1);
    figure
    subplot(1,2,1)
    bar(diag(mean_res),'stacked')
    title(strcat('Experiment ',num2str(iexp)))
    xlabel('Observables')
    ticklabels= str2mat(inputs.exps.obs_names{iexp});     
    set(gca,'XTick',1:1:inputs.exps.n_obs{iexp},'XTickLabel',ticklabels);  
    ylabel('Mean relative residual (%)');
    %legend(inputs.exps.obs_names{iexp});
    %legend boxoff     
    
    subplot(1,2,2)
    bar(diag(max_res),'stacked')
    title(strcat('Experiment ',num2str(iexp)))
    xlabel('Observables')
    ticklabels= str2mat(inputs.exps.obs_names{iexp});     
    set(gca,'XTick',1:1:inputs.exps.n_obs{iexp},'XTickLabel',ticklabels); 
    ylabel('Maximum relative residual (%)');
    %legend(inputs.exps.obs_names{iexp});
    %legend boxoff 
    
%     
%       % Keeps the .fig file
%         residuals_plot_path_=strcat(results.pathd.residuals_plot_path,'_meanmax_exp',num2str(iexp)); 
%         saveas(gcf, residuals_plot_path_, 'fig');
%       % Saves a .eps color figure
%         if results.plotd.epssave==1;
%         print( gcf, '-depsc', residuals_plot_path_); end
        
if rem(iexp,25)==0
    close all
end
    end

  
  

  