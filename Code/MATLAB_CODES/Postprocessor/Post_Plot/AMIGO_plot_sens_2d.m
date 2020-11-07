% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_plot_sens_2d.m 2220 2015-09-29 08:10:57Z attila $

index_theta=[inputs.PEsol.index_global_theta inputs.PEsol.index_local_theta{iexp}];
index_theta_y0=[inputs.PEsol.index_global_theta_y0 inputs.PEsol.index_local_theta_y0{iexp}];
n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.n_local_theta{iexp};
n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.n_local_theta_y0{iexp};



figure
pcolor(sensmat)
if v_r_max>v_r_min
    caxis([v_r_min v_r_max])
end

colorbar
shading flat

if inputs.PEsol.n_theta_y0==0
    if numel(inputs.model.par_names)==0
        set(gca,'XTick',1+0.5:1:inputs.PEsol.n_theta+0.5,'XTickLabel',index_theta);
    else
        xticklabel= inputs.model.par_names(index_theta,:);
        set(gca,'XTick',1+0.5:1:inputs.PEsol.n_theta+0.5,'XTickLabel',cellstr(xticklabel));
        set(xticklabel_rotate([],90),'interpreter','none');
    end;
else
    if numel(inputs.model.par_names)==0  && numel(inputs.st_names)==0
        set(gca,'XTick',1+0.5:1:inputs.PEsol.n_theta+inputs.PEsol.n_theta_y0+0.5,'XTickLabel',[index_theta index_theta_y0]);
    else
        str={inputs.model.par_names(inputs.PEsol.index_global_theta,:),inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:),...
            inputs.model.par_names(inputs.PEsol.index_local_theta{iexp},:),inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp},:)};
        xticklabel = char(str(~cellfun('isempty',str)));
        set(gca,'XTick',1+0.5:1:(n_theta+n_theta_y0)+0.5,'XTickLabel',cellstr(xticklabel));
        set(xticklabel_rotate([],90),'interpreter','none');
    end;
end; %if inputs.PEsol.n_theta_y0==0


if numel(inputs.exps.obs_names{iexp})==0
    set(gca,'YTick',1:1:inputs.exps.n_obs{iexp});
else
    yticklabel= inputs.exps.obs_names{iexp}';
    set(gca,'YTick',1+0.5:1:inputs.exps.n_obs{iexp}+0.5,'YTickLabel',yticklabel');
end
title(plot_title);

if results.plotd.figsave
    saveas(gcf, sens_path_fig, 'fig');
end
if results.plotd.epssave==1;
    print( gcf, '-depsc', sens_path_fig);end
