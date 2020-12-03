% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_logUniformIntialGuess.m 1131 2013-12-02 12:48:47Z attila $
function guess = AMIGO_logUniformIntialGuess(lower_bound, upper_bound, plotflag, n_guess)
% create log-uniform distributed initial guesses for parameter estimation
%
% n_guess: number of guess
% every guess is a row in the guess array.


if nargin < 2
    error('lower and upper bounds are needed');
else
    if length(lower_bound) ~= length(upper_bound), error('lower and upper bounds should be equal length'), end
end
if any(lower_bound == 0)
    error('lower bound cannot be zero.')
elseif any(upper_bound == 0)
    error('upper bound cannot be zero.')
end
npars = length(lower_bound);
plt = 0;
nguess = 1;

if nargin > 2
    plt = plotflag;
end
if nargin == 4
    nguess = n_guess;
end

lpLB=log10(lower_bound);
lpUB=log10(upper_bound);
logInterval = lpUB - lpLB;


x0 = zeros(nguess,npars);
for i = 1:nguess
    logp = lpLB + rand(size(lpLB)).*logInterval;
    linp = 10.^logp;
    x0(i,:) = linp;
end

if plt
    figure()
    
    plb = lower_bound;
    pup = upper_bound;
    for l=1:npars
        x=l+0.3*[-1 -1 1 1];
        y=[plb(l) pup(l) pup(l) plb(l)];
        patch(x,y,[.8 0.8 0.8],'EdgeColor','None')
%        y=xtrue(l)*[ 0.98 1.02 1.02 0.98];
%        patch(x,y,[0.6 0.6 0.6],'EdgeColor','None')
    end
    set(gca,'YScale','Log')
    hold on
    for i = 1:nguess
        plot(x0(i,:),'*r');
    end
    xlim([0 npars+0.5])
    
    xlabel('parameter indices')
    ylabel('parameter values')
    title('Initial guesses with the bounds')
end

guess = x0;
