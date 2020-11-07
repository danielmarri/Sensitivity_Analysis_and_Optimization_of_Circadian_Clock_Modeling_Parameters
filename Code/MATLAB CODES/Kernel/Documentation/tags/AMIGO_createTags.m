function [T, ANT]= AMIGO_createTags(A)
% AMIGO_createTags reads the fields of A and collects the tags in the same structure
% ANT is the sting without the tags.
% See also: AMIGO_tags

if ~isstruct(A)
    T = [];
    disp('A is not a struct. ')
    return;
end

[T ANT]= checkFieldsForTags(A);

    function [t a] = checkFieldsForTags(a)
        
        t = struct;
        
        
        fn = fieldnames(a);
        
        for i = 1:length(fn)
            
            if ~isstruct(a.(fn{i}))
                % the field is not a struct, so take the documentation:
                    [a.(fn{i}) t.(fn{i}) ]= AMIGO_findTags(a.(fn{i}));
            else
                % the field is a struct --> go deeper.

                [t.(fn{i}) a.(fn{i})]= checkFieldsForTags(a.(fn{i}));
               
            end

        end
 
    end

end