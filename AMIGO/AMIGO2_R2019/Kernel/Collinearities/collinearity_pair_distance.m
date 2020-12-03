function C = collinearity_pair_distance(x)


n = size(x,2);
C = zeros(n);

for i = 1:n-1
    for j = i+1:n
        
        C(i,j) = collinearity_index(x(:,[i j]));
    end
end

C = C + C';

