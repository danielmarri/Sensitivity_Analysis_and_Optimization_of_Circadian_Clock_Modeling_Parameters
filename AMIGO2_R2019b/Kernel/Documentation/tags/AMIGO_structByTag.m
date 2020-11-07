function C = AMIGO_structByTag(A,tag)
%AMIGO_structByTag(inputs,tag) returns a similar structure of A with the fields, where the tag appears.
% if tag is a cellstr containing multiple tags, it returns the union of the
% fields that contain at least one of those flags. 


if ~isstruct(A)
    C = [];
    disp('A is not a struct. ')
    return;
end

[C]= checkFieldsForTags(A,tag);
end
function [c] = checkFieldsForTags(a,tag)
% returns a if a and b are not structures. Otherwise, c contains the
% common fields.
c = struct;


fn = fieldnames(a);

for i = 1:length(fn)
    
    if ~isstruct(a.(fn{i}))
        % the field is not a struct, so check for tags
        
        [strNT, T] = AMIGO_findTags(a.(fn{i}),tag);
        if ~isempty(T{1})
            c.(fn{i}) = strNT;
        end
    else
        
        
        [tmp]=  checkFieldsForTags(a.(fn{i}),tag);
        if ~isempty(fieldnames(tmp))
            c.(fn{i}) = tmp;
            
        end
    end
end
end
