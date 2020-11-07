
function [ts_out p] = AMIGO_orderfields(ts)
% returns the ordered struct and permutation vector that orders the fields of the structure. 
% we dont use tags yet.
% we order alphabetically the fields, then if a field is a struct itself,
% then those go to the back. 

% ASCII alphabetic ordering
[ots , p1] = orderfields(ts);
struct_elements = zeros(size(p1));

fn = fieldnames(ots);
for i = 1: length(fn)
   struct_elements(i) = isstruct(ots.(fn{i}));     
end

% partition the p.
p = [p1(~logical(struct_elements)); p1(logical(struct_elements)) ];

ts_out = orderfields(ts,p);



end
