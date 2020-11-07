function AMIGO_fig2publish(figureHandle,FontSize,LineWidth,MarkerSize)
% AMIGO_fig2publish change the font size on the figure.
if nargin < 1 || isempty(figureHandle)
    gcfh = gcf;
else
    gcfh = figureHandle;
end

if nargin < 2 || isempty(FontSize)
    FS = nan;%12;
else
    FS = FontSize;
end

if nargin < 3 || isempty(LineWidth)
    LW = nan; %1;
else
    LW = LineWidth;
end

if nargin < 4 || isempty(MarkerSize)
    MS = nan;%10;
else
    MS = MarkerSize;
end


hplots = get(gcfh,'children');

nplots = length(hplots);

if ~isnan(FS)
    for ipl = 1:nplots
        try
            set(hplots(ipl),'Fontsize',FS)
            set(get(hplots(ipl),'Title'),'Fontsize',FS);
            set(get(hplots(ipl),'XLabel'),'Fontsize',FS);
            set(get(hplots(ipl),'YLabel'),'Fontsize',FS);
            set(findobj(hplots(ipl),'Type','text'),'FontSize',FS)
        end
    end
    set(findobj(gcfh,'Type','axes','Tag','legend'),'FontSize',FS)
end

if ~isnan(LW)
    set(findobj(gcfh,'Type','line'),'LineWidth',LW)
end
if ~isnan(MS)
    set(findobj(gcfh,'Type','line'),'MarkerSize',MS)
end

