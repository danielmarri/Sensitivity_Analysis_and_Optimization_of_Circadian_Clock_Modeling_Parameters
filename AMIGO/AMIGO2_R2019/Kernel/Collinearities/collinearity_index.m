function gamma  = collinearity_index(S) 
% calculates the collinearity factor according to Brun et al (2001)

try
s = svd(S);
catch 
    keyboard
end
gamma  = 1/s(end);

