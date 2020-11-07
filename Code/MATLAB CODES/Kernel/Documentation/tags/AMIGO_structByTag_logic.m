function C = AMIGO_structByTag_logic(A,taglogic)
%AMIGO_structByTag(inputs,taglogic) returns a similar structure of A with the fields, where the logical expression involving the tags appears.
% taglogic is string containing logical expression of tags, eg.
% taglogic = '(#PE|#IVP)&~#DEV'    returns the fields that are marked either by #IVP or #PE, but not #DEV      


if ~isstruct(A)
    C = [];
    disp('A is not a struct. ')
    return;
end

[C]= checkFieldsForTags(A,taglogic);
end
function [c] = checkFieldsForTags(a,taglogic)
% returns a if a and b are not structures. Otherwise, c contains the
% common fields.
c = struct;


fn = fieldnames(a);

for i = 1:length(fn)
    
    if ~isstruct(a.(fn{i}))
        % the field is not a struct, so check for tags
        
        f = AMIGO_findTags_logic(a.(fn{i}),taglogic);
        if f
            c.(fn{i}) = AMIGO_removeAMIGO_Tags(a.(fn{i}));
        end
    else
        
        
        [tmp]=  checkFieldsForTags(a.(fn{i}),taglogic);
        if ~isempty(fieldnames(tmp))
            c.(fn{i}) = tmp;
            
        end
    end
end
end
