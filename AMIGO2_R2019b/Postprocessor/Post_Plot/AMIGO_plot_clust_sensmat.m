% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/Postprocessor/Post_Plot/AMIGO_plot_correlationmat.m 929 2013-09-11 14:49:34Z attila $

% AMIGO_plot_correlationmat: plots correlation matrix
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
%   AMIGO_plot_correlationmat: generates and saves (.fig and .eps ) plots of  %
%                              the correlation matrix                         %
%                              For the case local parameters or initial       %
%                              conditions are to be estimated, the correlation%
%                              matrices per experiment will be also plotted   %
%                                                                             %
%*****************************************************************************%


% Cluster the sensitivities of observables....
if ~isfield(results.fit,'SM')  || ~license('test','statistics_toolbox')
    % sensitivity matrix could not be computed
    return
end
for iexp=1:inputs.exps.n_exp
    nSM = abs(results.fit.SM{iexp});
    
    for i = 1:size(nSM,2)
        nSM(:,i) = nSM(:,i)./norm(nSM(:,i)) ;
    end
    % construct the cluster tree for the correlations
    Z = linkage(nSM','average','euclidean');
    
    figure()
    drawall = 0; % draw all the parameters to the dendrogram
    par_names = inputs.PEsol.id_global_theta;
    if ~isempty (inputs.PEsol.id_global_theta_y0) && ~strcmp(inputs.PEsol.id_global_theta_y0,'none')
        par_names = char(par_names, inputs.PEsol.id_global_theta_y0);
    end
    [H] = dendrogram(Z,drawall,'orientation','left','labels',par_names,'colorthreshold',0.5);
    set(H,'LineWidth',2);
    title(sprintf('Correlation of absolute sensitivities (exp: %d)',iexp))
    xlabel('Distance of the (goup of) parameters')
    
%     
%     
    % Keeps the .fig file
    if inputs.plotd.figsave
        saveas(gcf, sprintf('%s_exp%d',inputs.pathd.sens_mat_clust_path,iexp), 'fig');
    end
    % Saves a .eps color figure
    if inputs.plotd.epssave==1;
        print( gcf, '-depsc', sprintf('%s_exp%d',inputs.pathd.sens_mat_clust_path,iexp));
    end
end



