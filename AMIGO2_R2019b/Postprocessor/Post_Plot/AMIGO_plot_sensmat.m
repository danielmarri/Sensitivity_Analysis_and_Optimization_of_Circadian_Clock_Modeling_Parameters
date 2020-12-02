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


%  CORRELATION MATRIX FOR THE GLOBAL UNKNOWNS
if ~isfield(results.fit,'SM')
    % sensitivity matrix could not be computed
    return
end
for iexp=1:inputs.exps.n_exp
    figure
    SM2pcolor = zeros(size(results.fit.SM{iexp})+1);
    SM2pcolor(1:end-1, 1:end-1) = results.fit.SM{iexp};
    pcolor(abs(SM2pcolor))
    colorbar
    shading flat
    if  numel(inputs.model.par_names)>0 && numel(inputs.model.st_names)>0
        str={inputs.model.par_names(inputs.PEsol.index_global_theta,:),inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:)};
        ticklabels = char(str(~cellfun('isempty',str)));
        set(gca,'xticklabel',[])
        ticksX = 1+0.5:1:length(inputs.PEsol.index_global_theta)+length(inputs.PEsol.index_global_theta_y0)+0.5;
        xlabels = cellstr(ticklabels);
        text(ticksX, 0.9*ones(size(ticksX)), cellstr(xlabels), 'rotation',-90,'horizontalalignment','left');
        % shift by 0.5 the ylabels
        yticklabels = get(gca,'yticklabel');
         set(gca,'ytick',get(gca,'ytick')+0.5)
          set(gca,'yticklabel',yticklabels)
        
        title(sprintf('Sensitivity matrix for global unknowns, iexp = %d',iexp));
    else
        set(gca,'XTick',1+0.5:1:size(privstruct.theta,2)+0.5,'XTickLabel',[inputs.PEsol.index_global_theta inputs.PEsol.index_global_theta_y0]);
        title(sprintf('Sensitivity matrix for global unknowns, iexp = %d',iexp));
    end
    ylabel('Number of data points');
    % rotate the ticks on the x-axis
    
    % Keeps the .fig file
    if inputs.plotd.figsave
        saveas(gcf, sprintf('%s_exp%d',inputs.pathd.sens_mat_path,iexp), 'fig');
    end
    % Saves a .eps color figure
    if inputs.plotd.epssave==1;
        print( gcf, '-depsc', sprintf('%s_exp%d',inputs.pathd.sens_mat_path,iexp));
    end
end



