function AMIGO_supertitle(plot_title)
% create a super title for a figure with subplots


set(gcf,'NextPlot','add');
axes('Position',[0.4  0.92  0.2  1e-6]);
%plot_title=strcat(inputs.pathd.short_name,' ; experiment: ',mat2str(iexp));
h = title(plot_title,'interpreter','none');
set(gca,'Visible','off');
set(h,'Visible','on');