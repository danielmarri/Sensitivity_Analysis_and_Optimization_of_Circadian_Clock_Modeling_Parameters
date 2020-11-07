function [n_lcurve curvature salpha explCurvature implCurvature]= RM_lcurve_ndiff(alpha,Q_LS,xnorm)
%RM_lcurve_ndiff calculates the numerical curvature of the L-curve


    
    
[salpha,ind]= sort(alpha,'ascend');
[sQ_LS, ind_ls]= sort(Q_LS,'ascend');
[sxnorm, ind_xn]= sort(xnorm,'descend');

for i = 1:numel(ind)
   if ind(i)~= ind_ls(i) || ind(i)~= ind_xn(i) || ind_xn(i)~= ind_ls(i)
       fprintf(2,'Inconsistency in the order of alpha, Q_LS and ||Wx|| is detected. The L-curve is probably corrupted.\n')
   end
end
    
sQ_LS = Q_LS(ind);
sxnorm = xnorm(ind);


% check piling points:
nalpha = length(alpha);
for i = 1:nalpha-1
    if sxnorm(i)
    end
end


% sQ_LS = [sQ_LS(1), sQ_LS(1), sQ_LS, sQ_LS(end)+0.5*(sQ_LS(end)-sQ_LS(end-1)), sQ_LS(end)+0.7*(sQ_LS(end)-sQ_LS(end-1))];
% sxnorm = [sxnorm(1)+0.7*(sxnorm(1)-sxnorm(2)), sxnorm(1)+0.5*(sxnorm(1)-sxnorm(2)), sxnorm, sxnorm(end) sxnorm(end)];

 Vertices = ([sQ_LS' sxnorm']);
% %Vertices = ([log(sQ_LS)' log(sxnorm)']);
 Lines = [[1:size(Vertices,1)-1]',[2:size(Vertices,1)]' ];
% k=LineCurvature2D(Vertices,Lines);
% N=LineNormals2D(Vertices,Lines);
%  k=k;
%  figure, hold on;
%  plot([Vertices(:,1) Vertices(:,1)+k.*N(:,1)]',[Vertices(:,2) Vertices(:,2)+k.*N(:,2)]','g');
%  plot([Vertices(Lines(:,1),1) Vertices(Lines(:,2),1)]',[Vertices(Lines(:,1),2) Vertices(Lines(:,2),2)]','b');
 
curvature = LineCurvature2D(Vertices,Lines);
explCurvature = AMIGO_explicitCurvature(sxnorm,sQ_LS);
implCurvature = AMIGO_implicitCurvature(salpha,sQ_LS,sxnorm);

[~,n_lcurve]= max(curvature);

% subplot(212)
% plot(alpha,abs(curve))
% set(gca,'xscale','log')