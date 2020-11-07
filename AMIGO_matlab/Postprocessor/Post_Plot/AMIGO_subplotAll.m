function AMIGO_subplotAll(x,Y,nx,ny,R,LB,UB)
%AMIGO_subplotAll plots each row of Y against x in a subplot.
% AMIGO_subplotAll(x,Y,nx,ny) nx and ny are the dimensions of the subplot
% AMIGO_subplotAll(x,Y,nx,ny,R) plots the reference value R(i) to subplot i
% AMIGO_subplotAll(x,Y,nx,ny,R,LB,UB) set the xlim and ylim accordingly

yAxisScale = 'lin';
% xAxisScale = 'lin';
% yAxisScale = 'log';
xAxisScale = 'log';
if nargin < 3
    nx = 4;
    ny = 4;
end

plotref = true; 
if nargin < 5,
    plotref = false;
end;
bounds = true;
if nargin < 6
    bounds = false;
end
nplot = size(Y,1);

nfig = ceil(nplot/(nx*ny));

plotted = 1;
for ifig = 1:nfig
    figure()
    ninfig = 0;
    for i = 1:nx*ny
            ninfig = ninfig +1;
            subplot(nx,ny,ninfig)
            plot(x,Y(plotted,:),'k.-')
            if plotref
                hold on
                plot(x,repmat(R(plotted),size(x)),'m--')
                hold off
            end
            set(gca,'yscale',yAxisScale,'xscale',xAxisScale)
            if bounds
                ylim([LB(plotted),UB(plotted)])
            end
            plotted = plotted +1;
            if plotted > nplot
                break;
            end
    end
    
    if plotted > nplot
        break;
    end
end
