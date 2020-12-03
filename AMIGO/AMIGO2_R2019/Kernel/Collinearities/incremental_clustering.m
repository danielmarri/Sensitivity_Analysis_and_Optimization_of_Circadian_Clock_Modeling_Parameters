function [idx,k_groups,C,sumd,D] = incremental_clustering(X,r,mode,plot_flag)
%[] = bisection_clustering(X,mode
% X: columns contains the coordinates, rows contains the data.
% r: max/mean allowed distance from centroids
% mode: - 'max' max distance constraints
%       - 'mean' mean distance constraints


opts = statset('Display','off');

[n_points,dim] = size(X);
k_max = n_points;
stop = true;
k_groups = 2;


if plot_flag
    f = figure();
    set(f,'position',get(f,'position').*[1 1 2 1])
    a1 = subplot(121);
    xlim([0 k_max])
    hold on
    title('incremental search progress')
    xlabel('number of clusters')
    ylabel('mean/max  in-cluster distance')
    
    a2 = subplot(122);
    title('2D projected clusters')
end

dk = 1;
iter = 0;

colors =  linspecer(k_max,'sequential');
A = eye( k_max );
idx = randperm(k_max);
A = A(idx, :);
colors = A*colors;

n_rep = 10;

while stop
    iter = iter +1;
    
    if plot_flag
        plot(a1,k_groups,0,'bv','Markersize',10,'markerfacecolor','b')
        drawnow;
    end
    
    warning('off','stats:kmeans:EmptyCluster')
    warning('off','stats:kmeans:FailedToConverge')
    if iter > 1
       M = zeros([k_groups dim n_rep]);
       M(1:end-1,:,:) = repmat(C,[1 1 n_rep]);
       for i = 1:n_rep
           M(end,:,i) = X(randi(n_points,1),:); 
       end
    else
        M = 'sample';
    end
    
    [idx,C,sumd,D] = kmeans(X,k_groups,'distance','sqEuclidean','replicates',n_rep,'emptyaction','singleton','start',M,'Options',opts);%'correlation''city'
    if any(sum(D'<1e-12)>1)
%         keyboard
        warning('incrementalKMEANS:optimalityDetection','The distance of at least one variable from more than one centroid is less than 1e-12.')
    end
   
    if plot_flag
        update_plot(a2,X,C,idx,k_groups,colors)
    end
    
    switch mode
        case 'mean'
            clustersize = zeros(1,k_groups);
            for i = 1:k_groups
                clustersize(i) = sum(idx==i);
            end
            avg_dist = sumd./clustersize';
            if plot_flag
                plot(a1,k_groups,max(avg_dist),'k.','Markersize',18)
            end
            fprintf('iteration: %d, n clusters: %d, dk: %d, max-mean centroid distance: %g\n',iter, k_groups,dk,max(avg_dist))
            if all(avg_dist < r);
                break;
            end
        case 'max'
            centroid_dist = zeros(n_points,1);
            for i = 1:n_points
                centroid_dist(i)=D(i,idx(i));
            end
            if plot_flag
                plot(a1,k_groups,max(centroid_dist),'k.','Markersize',18)
            end
            fprintf('iteration: %d, n clusters: %d, dk: %d, max-max centroid distance: %g\n',iter, k_groups,dk,max(centroid_dist))
            if max(centroid_dist) <= r
                break;
            end
    end
    k_groups = k_groups + dk;
end
end


function update_plot(a2,X,C,idx,k_groups,colors)
% update the search progress plot.
for i = 1:k_groups
    h_data = plot(a2,X(idx==i,1),X(idx==i,2),'.','Markersize',15,'color',colors(i,:)); hold on
    h_centroids = plot(a2,C(i,1),C(i,2),'x','Markersize',10,'color',colors(i,:));
    %     circle(C(i,1),C(i,2),r,'color',colors(i,:))
    %     text(C(i,1)+0.05,C(i,2),sprintf('%d',i),'color',colors(i,:));
end
title(sprintf('N clusters: %d',k_groups))
if ~isempty(h_data) && ~isempty(h_centroids)
    legend([h_data(1),h_centroids(1)],{'parameter','centroid'})
    legend('boxoff')
end
hold(a2,'off')
drawnow;
end
