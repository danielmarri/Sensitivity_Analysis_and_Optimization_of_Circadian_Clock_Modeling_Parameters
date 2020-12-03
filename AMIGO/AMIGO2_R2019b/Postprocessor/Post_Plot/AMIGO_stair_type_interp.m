
function yi = AMIGO_stair_type_interp(x,y,xi)
%yi = AMIGO_stair_type_interp(x,y,xi) do 1D interpolation using stairs and
%interp1. Extrapolate with constant holding of the range of xi is out of x.


% test:
% x = linspace(3.5,7.5,8);
% y = linspace(100,75,8);
% xi = 1:10;
% yi = AMIGO_stair_type_interp(x,y,xi);
% figure()
% stairs(x,y,'k.-')
% hold on
% plot(xi,yi,'ro-')
% legend('original points','iterpolated')

% remove the elemenets if the elapsed time is zero. (why is there such
% element??)
dx = [x(2:end)-x(1:end-1); 1];
x(dx == 0) = [];
y(dx == 0) = [];
% do a stairtype interpolation
[xs,ys] = stairs(x,y);
xs(2:2:end) = xs(2:2:end)-1e-6*xs(2:2:end);

yi = interp1(xs,ys,xi,'nearest');

% handle extrapolation
for i = 1:length(yi)
    if isnan(yi(i))
        if xi(i) <= min(x)
            yi(i) = y(1);
        elseif xi(i)>= max(x)
            yi(i) = y(end) ;
        else 
            error('WTF?!')
        end
    end
end
    



end