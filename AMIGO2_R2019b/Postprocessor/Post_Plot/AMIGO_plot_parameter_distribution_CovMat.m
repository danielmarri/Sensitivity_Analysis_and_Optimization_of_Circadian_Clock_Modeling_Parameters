function AMIGO_plot_parameter_distribution_CovMat (x,covmat,x_LB,x_UB,xref,parnames,nx,ny)
% plots the Gaussian distributon of the parameters based on the covariance matrix.


npar = length(x);

if nargin<6 || isempty(parnames)
    for i = 1:npar
        parnames{i} = sprintf('p%d',i);
    end
elseif ischar(parnames)
    parnames = cellstr(parnames);
end

ipar = 0;
if nargin < 8 || isempty(nx) || isempty(ny)
    nx = ceil(sqrt(npar));
    ny = nx;
end

while ipar < npar
    figure()
    nolegend = true;
for i = 1:nx*ny
    ipar = ipar +1;
    subplot(nx,ny,i)
    hold on
    % plot optima:
    xopt = x(ipar);
    plot(xopt,0,'bv','Markersize',10)
    plot(xref(ipar),0,'*','Markersize',10,'color',[0 .8 0])
    xlim([x_LB(ipar) x_UB(ipar)])
    ylim([-0.05 1.05])
    if (x_LB(ipar)/x_UB(ipar)<0.1)  && x_LB(ipar) >0
        set(gca,'xscale','log')
    end
    title(parnames{i})
    
    % plot distr:
    s2 = covmat(ipar,ipar);
    if s2 < 0
        warning ('negative variance detected for the %dth parameter.',ipar);
        if ipar == npar
            break;
        else
            continue;
        end
    end
    sigma = sqrt(s2);
    
    distx = linspace(xopt-3*sigma, xopt+3*sigma,101);
    distx(distx>x_UB(ipar)) = x_UB(ipar);
    distx(distx<x_LB(ipar)) = x_LB(ipar);
    y = exp(-1/2*(xopt - distx).^2./s2);
    plot(distx,y,'k-','linewidth',2)

    if nolegend 
       legend('p_{opt}','p_{nom}','N(p_{opt},\sigma_{p_{opt}}^2)') 
       nolegend = false;
    end
    if ipar == npar
        break;
    end
end
end