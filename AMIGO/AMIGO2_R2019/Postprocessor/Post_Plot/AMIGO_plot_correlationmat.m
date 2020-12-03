% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_correlationmat.m 2224 2015-09-29 08:49:50Z attila $

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

figure
% pcolor cut the last row and column:
pcolor_g_corr_mat = zeros(size(results.fit.g_corr_mat)+[1 1]);
pcolor_g_corr_mat(1:end-1, 1:end-1) = results.fit.g_corr_mat;

pcolor(real(pcolor_g_corr_mat))
caxis([-1,1])

colorbar
if  numel(inputs.model.par_names)>0 && numel(inputs.model.st_names)>0
    str={inputs.model.par_names(inputs.PEsol.index_global_theta,:),inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:)};
    ticklabels = char(str(~cellfun('isempty',str)));
    set(gca,'YTick',1+0.5:1:length(inputs.PEsol.index_global_theta)+length(inputs.PEsol.index_global_theta_y0)+0.5,'YTickLabel',ticklabels);
    set(gca,'xticklabel',[])
    ticksX = 1+0.5:1:length(inputs.PEsol.index_global_theta)+length(inputs.PEsol.index_global_theta_y0)+0.5;
    xlabels = cellstr(ticklabels);
    set(gca,'XTick',1+0.5:1:length(inputs.PEsol.index_global_theta)+length(inputs.PEsol.index_global_theta_y0)+0.5)
    set(gca,'xticklabel',xlabels)
    xticklabel_rotate([],90,[],'interpreter','none');
%     rotateXLabels(gca,-90)
%     text(ticksX, ones(size(ticksX))-0.5, strtrim(xlabels), 'rotation',-90,'horizontalalignment','left');
%     set(gca,'XTick',1+0.5:1:length(inputs.PEsol.index_global_theta)+length(inputs.PEsol.index_global_theta_y0)+0.5,'XTickLabel',ticklabels);
    title('Crammer Rao based correlation matrix for global unknowns');
else
    set(gca,'YTick',1+0.5:1:size(privstruct.theta,2)+0.5,'YTickLabel',[inputs.PEsol.index_global_theta inputs.PEsol.index_global_theta_y0]);
    set(gca,'XTick',1+0.5:1:size(privstruct.theta,2)+0.5,'XTickLabel',[inputs.PEsol.index_global_theta inputs.PEsol.index_global_theta_y0]);
    title('Crammer Rao based correlation matrix for global unknowns');
end

% Keeps the .fig file
if inputs.plotd.figsave
saveas(gcf, inputs.pathd.corr_mat_path, 'fig');
end
% Saves a .eps color figure
if inputs.plotd.epssave==1;
    print( gcf, '-depsc', inputs.pathd.corr_mat_path);
end


%  CORRELATION MATRIX FOR THE DIFFERENT EXPERIMENTS (INCORPORATE LOCAL UNKNOWNS)


if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0
    
    for iexp=1:inputs.exps.n_exp
         if inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp}>0
        figure
        % pcolor cut the last row and column:
        pcolor_l_corr_mat = zeros(size(results.fit.l_corr_mat{iexp})+[1 1]);
        pcolor_l_corr_mat(1:end-1, 1:end-1) = results.fit.l_corr_mat{iexp};
        
        pcolor(real(pcolor_l_corr_mat));
        caxis([-1,1])
        
        colorbar
        if  numel(inputs.model.par_names)>=1 && numel(inputs.model.st_names)>=1
            str={inputs.model.par_names(inputs.PEsol.index_global_theta,:),inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:),...
                inputs.model.par_names(inputs.PEsol.index_local_theta{iexp},:),inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp},:)};
            ticklabels = char(str(~cellfun('isempty',str)));
            set(gca,'YTick',1+0.5:1:size(privstruct.theta,2)+0.5,'YTickLabel',ticklabels);
            set(gca,'xticklabel',[])
            ticksX = 1+0.5:1:size(ticklabels,1)+0.5;
            xlabels = cellstr(ticklabels);
            set(gca,'XTick',ticksX)
            set(gca,'xticklabel',xlabels)
            xticklabel_rotate([],90,[],'interpreter','none');
            %text(ticksX, zeros(size(ticksX)), cellstr(xlabels), 'rotation',-90,'horizontalalignment','right');
            title_plot=strcat('Crammer Rao based correlation matrix for exp ',num2str(iexp));
            title(title_plot);
        else
            set(gca,'YTick',1+0.5:1:size(privstruct.theta,2)+0.5,'YTickLabel',[inputs.PEsol.index_global_theta inputs.PEsol.index_global_theta_y0...
                inputs.PEsol.index_local_theta{iexp} inputs.PEsol.index_local_theta_y0{iexp}]);
            set(gca,'XTick',1+0.5:1:size(privstruct.theta,2)+0.5,'XTickLabel',[inputs.PEsol.index_global_theta inputs.PEsol.index_global_theta_y0...
                inputs.PEsol.index_local_theta{iexp} inputs.PEsol.index_local_theta_y0{iexp}]);
            title_plot=strcat('Crammer Rao based correlation matrix for exp ',num2str(iexp));
            title(title_plot);
        end
        
        % Keeps the .fig file
        
        path_local_corr=strcat(inputs.pathd.corr_mat_path,'_exp',num2str(iexp));
        if inputs.plotd.figsave
        saveas(gcf, path_local_corr, 'fig');
        end
        % Saves a .eps color figure
        if inputs.plotd.epssave==1;
            print( gcf, '-depsc', path_local_corr);
        end
        
        end % if  inputs.PEsol.n_local_theta{iexp}+inputs.PEsol.n_local_theta_y0{iexp}>0
    end %iexp
    
    
end %   if inputs.PEsol.ntotal_local_theta>0 || inputs.PEsol.ntotal_local_theta_y0>0