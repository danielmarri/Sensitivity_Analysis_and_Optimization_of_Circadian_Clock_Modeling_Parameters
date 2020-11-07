function [C M]= AMIGO_commentStruct(A,B)
% AMIGO_commentStruct returns struct A, the values replaced by the corresponding fields from B.
% recursively checks the fields of struct A and B.
% if A has a field, that B does not have, the default value: 'missing comment' is assigned.
% M is a structure containing only missing elements.
%
%   EXAMPLES:
%       % we have struct a with values:
%       a = struct('field1',rand(5),'field2', 5,'field3','some text',...
%           'field4',struct('field11','apple'),'field5',struct('field51','some text2','field52',999,'field53',magic(8)))
%
%       % struct b contains the corresponding comments:
%       b = struct('field1','this is field1','field3','this is field3',...
%           'field4',struct('field11','this is field11'),'field5',struct('field50','this is field50','field52','this is field52','field53','this is field53'),'field6','this is field6')
%
%       % note that, we were lazy and field2 does not exists in b. --> the
%       % missing comment is indicated in c using the missing_value
%       % variable.
%
%       C = AMIGO_commentStruct(a,b);
%
%       % display C:
%       AMIGO_displayStruct(C);

missing_value = '#RED #MISSING';

if ~isstruct(A)
    C = [];
    disp('A is not a struct. ')
    return;
end

[C M]= intersect(A,B);

    function [c m] = intersect(a,b)
        % returns a if a and b are not structures. Otherwise, c contains the
        % common fields.
        c = struct;
        m = struct;
        
        fn = fieldnames(a);
        
        for i = 1:length(fn)
            
            if ~isstruct(a.(fn{i}))
                % the field is not a struct, so take the documentation:
                if isfield(b,fn{i})
                    c.(fn{i}) = b.(fn{i});
                else
                    % no existing comment for this field.
                    c.(fn{i}) = missing_value;
                    m.(fn{i}) = '';
                end
            else
                % the field is a struct --> go deeper.
                
                if ~isfield(b,fn{i}) ||  ~isstruct(b.(fn{i}))
                    % if b does not have this field or the field is not a
                    % struct, create and empty entry
                    b.(fn{i}) = struct();
                end
                
                [tmp tmpm]=  intersect(a.(fn{i}),b.(fn{i}));
                if ~isempty(fieldnames(tmp))
                    c.(fn{i}) = tmp;
                    m.(fn{i}) = tmpm;
                end
            end 
        end
    end
end