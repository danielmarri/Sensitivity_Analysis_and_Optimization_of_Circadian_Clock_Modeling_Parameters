function C = AMIGO_structFieldPathsAsValue(s,inputstructname)
%AMIGO_structFieldPathsAsValue returns the field's access path as string in the field value
%
% sA = AMIGO_structFieldPathsAsValue(s) copies the structure A and fills each
% field with the field position information.
%
% Example:
%   a = struct('field1',rand(5),'field2', 5,'field3','some text',...
%       'field4',struct('field11','apple'),'field5',struct('field51','some text2','field52',999,'field53',magic(8)))
%   as = AMIGO_structFieldPathsAsValue(a)
%
%     field1: 'a.field1'
%     field2: 'a.field2'
%     field3: 'a.field3'
%     field4: [1x1 struct]
%     field5: [1x1 struct]
if ~isstruct(s)
    C = [];
    disp('A is not a struct. ')
    return;
end
if nargin < 2
    input_name = inputname(1);
    if isempty(input_name)
        input_name = 'structName';
    end
else
    input_name = inputstructname;
end


if ~isstruct(s)
    display(s)
    return;
end
parents = input_name;

C = processStruct(s,parents);




%  fn = fieldnames(s);
% for i = 1:length(fn)
%     f = getfield(s,fn{i});
%     fprintf('\t%s.\n',fn{i});
%     disp(f);
end

function c = processStruct(a,parents)
% returns the path to a if a is not structures.
c = struct;
%a.thisStrucName = parents;
fn = fieldnames(a);
for i = 1:length(fn)
    
    if ~isstruct(a.(fn{i}))
        c.(fn{i}) = strcat(parents,'.',fn{i});
    else
        subparents = strcat(parents,'.',fn{i});
        tmp =  processStruct(a.(fn{i}),subparents);
        if ~isempty(fieldnames(tmp))
            c.(fn{i}) = tmp;
        end
    end
    
end


end