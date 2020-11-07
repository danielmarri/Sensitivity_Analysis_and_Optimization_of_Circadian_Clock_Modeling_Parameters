function C = AMIGO_intersectStructs(A,B)
% AMIGO_StructIntersect returns the common fields of struct A and B
% recursively checks the fields of struct A and B and returns struct C with
% field that is common. NOTE that the field value is taken from A. 
%
%   EXAMPLES:
%     a = struct('field1',rand(5),'field2', 5,...
%     'field3',struct('field11','apple'))
%
%     b = struct('field1',rand(5),'field3',struct('field12','apple'))
%   
%      C = AMIGO_intersectStructs(a,b);
%  
%     % display C:
%     AMIGO_displayStruct(C);

if ~isstruct(A)
    C = [];
    disp('A is not a struct. ')
    return;
end

C = intersect(A,B);




%  fn = fieldnames(s);
% for i = 1:length(fn)
%     f = getfield(s,fn{i});
%     fprintf('\t%s.\n',fn{i});
%     disp(f);
end

function c = intersect(a,b)
% returns a if a and b are not structures. Otherwise, c contains the
% common fields. 
c = struct;
if isstruct(a) && isstruct(b) 
    fn = fieldnames(a);
    for i = 1:length(fn)
        if isfield(b,fn{i})
            if ~isstruct(a.(fn{i}))
                c.(fn{i}) = a.(fn{i});
            else
                tmp =  intersect(getfield(a,fn{i}),getfield(b,fn{i}));
                if ~isempty(fieldnames(tmp))
                    c.(fn{i}) = tmp;
                end
            end
        end
    end
else
    c = a;
    return;
    
end

end