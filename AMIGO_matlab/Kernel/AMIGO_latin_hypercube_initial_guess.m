function X = AMIGO_latin_hypercube_initial_guess(ndim,npoints, xmin, xmax,mode)
%X = AMIGO_latin_hypercube_initial_guess(npoints, xmin, xmax,mode)
% generates initial guesses for parameter estimations according to the
% latin hyper cube sampling. Each row of X is a parameter guess.
% Based on the Statistics Toolbox lhsdesing function.
% inputs:
%   ndim:    length of the parameter vector
%   npoints: the number of generated points: 
%   xmin:    the minimum of the points 
%   xmax:    the maximum of the poiints
%   mode:    'lin' generates random points between xmin and xmax, (default)
%            'log' generates loguniform random points between xmin and xmax

% PROCESS THE INPUTS
if nargin < 4
    error('Minimum the length of the parameter vector, the number of points, lower and upper bounds must be defined.')
end

assert(length(xmin)==ndim && length(xmax)==ndim, 'length(xmin) and length(xmax) should be the same as ndim')

if nargin < 5
    mode = 'lin';
elseif nargin == 5
    assert(strcmp(mode,'lin')||strcmp(mode,'log'));
end

switch mode
    case 'log'
        lpLB=log10(xmin);
        lpUB=log10(xmax);
    case 'lin'
        lpLB = xmin;
        lpUB = xmax;
end


interval = lpUB - lpLB;

% generate random points according to the LHS on the [0,1] interval
X = lhsdesign(npoints,ndim);

% shift and size each interval:
X = repmat(lpLB,npoints,1) +X.*repmat(interval,npoints,1);

if strcmp(mode,'log')
    %transform back from the logarithmic scale
    X = 10.^X;
end



%%%%%%%%%%%%%%%%%%%%%%%%
function test_latinhyp_initguess

X = latinhyp_initguess(2,100, [0.01 0.01 ], [100 100 ],'log');
figure
plot(X','.')
set(gca,'yScale','log')
xlim([0 3])

X = latinhyp_initguess(2,100, [0.2 -0.1 ], [1.2 3 ],'lin');
figure
plot(X','.')
xlim([0 3])


