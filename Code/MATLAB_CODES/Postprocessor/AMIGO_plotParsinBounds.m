function [hfig,haxes] = AMIGO_plotParsinBounds(p, lower_bound, upper_bound, ptrue,h, par_names)
%AMIGO_plotParsinBounds plots the parameters in their bounded domain
%represented by rectangles.
%   AMIGO_plotParsinBounds(p, lb, ub) plots the (Nx1) parameter vector p
%   in the bounds such that lb(i)<p(i)<ub(i). If P is an NxM matrix, then
%   each column of P is considered as a parameter vector with the same color. 
%
%   AMIGO_plotParsinBounds(p, lb, ub, pref) marks a reference parameter
%   set pref in the bounds.
%   
%   AMIGO_plotParsinBounds(p, lb, ub, pref, h), where h is the axes handler
%   where the plot is generated.

logscaled = 1;
with_par_names = 0;

if nargin >= 6 && ~isempty(par_names)
    assert(size(par_names,1)==size(p,1),'number of parameters and of names are not equal.');
    with_par_names = 1;
    ticklabels = par_names;
    
end

if nargin < 5
    hfig = figure();
else
    haxes = h;
    axes(haxes);
end

if size(p,1) == 1
    p = p(:);
end
npars = size(p,1);
nsets = size(p,2);

if length(lower_bound) ~= npars
    error('length of lower_bounds is not equal to the number of parameters')
elseif length(upper_bound) ~= npars
    error('length of upper_bounds is not equal to the number of parameters')
elseif nargin > 5 && length(ptrue) ~= npars
    error('length of ptrue is not equal to the number of parameters')
end

AMIGO_plot_colors
% func = @(x) colorspace('RGB->Lab',x);
% plot_colors = distinguishable_colors(nsets,{[1 1 1], [0.6 0.6 0.6]},func);


plb = lower_bound;
pup = upper_bound;
for l=1:npars
    x=l+0.3*[-1 -1 1 1];
    y=[plb(l) pup(l) pup(l) plb(l)];
    patch(x,y,[.8 0.8 0.8],'EdgeColor','None')
    if nargin > 3 && ~isempty(ptrue)
        y=ptrue(l)*[ 0.97 1.03 1.03 0.97];
        patch(x,y,[0.6 0.6 0.6],'EdgeColor','None')
    end
end
if logscaled
    set(gca,'YScale','Log')
end
hold all
for i = 1:nsets
  haxes =  plot(p(:,i),'*','color',plot_colors(i,:));%
end
xlim([0 npars+0.5])

xlabel('parameter indices')
ylabel('parameter values')
title('Parameters with their bounds')

if with_par_names
    set(gca,'xticklabel',[])
    ticksX = 1+0.5:1:npars+0.5;
    xlabels = cellstr(ticklabels);
    text(ticksX, zeros(size(ticksX)), cellstr(xlabels), 'rotation',-90,'horizontalalignment','left');
end

if nargout == 0
    clear haxes hfig
end