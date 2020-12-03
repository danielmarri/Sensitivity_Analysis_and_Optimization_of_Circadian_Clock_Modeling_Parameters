function AMIGO_writeDoc(fid,depth,inputName,varargin)
% recursively writes the fields of structures into the outputstream (fid==1 CommandWindow)
%
% AMIGO_writeCommandWindowdoc(fid,depth,inputName,s1,s2,...)
% Inputs:
%   s       struct, may contain fields that are themself structures.
%   s1,s2,... must have the same structure
%   depth   set up the display depth of the structure: inf - full depth (default)
%   fid     file handler for writing to  file.
%   inputName: the name of the s1 structure that appears in the table.
%
% Field values are displayed if they are either scalar numeric/logic values
% or one dimensional strings, otherwise their size and types are displayed.
%



if isempty(depth) 
    depth = inf;
end


input_name = inputName;
if isempty(input_name)
    input_name = 's';
end
%fprintf(fid,'%s',input_name);
if ~isstruct(varargin{1})
    display(varargin{1})
    return;
end
parents = input_name;


extractfield(cell2mat(varargin),1,fid,depth,parents);

end

function extractfield(f,level,fid,depth,parents)


if isstruct(f) && level <= depth
    fprintf(fid,'\n%s\n',parents);
    tagged_struct = f(1);
    [~, p] = AMIGO_orderfields(tagged_struct);
    f = orderfields(f,p);
    
    fn = fieldnames(f);
    for i = 1:length(fn)
        
        fullfieldName = strcat(parents,'.', fn{i});
        if isstruct(f(1).(fn{i}))
            extractfield([f.(fn{i})],level+1,fid,depth,fullfieldName); % getfield(f,fn{i})
        else
            fprintf(fid,'\t');
            out = {f.(fn{i})};
            for iout = out
                outstr = AMIGO_toString(iout{:},false);
            fprintf(fid,'%s\t\t',outstr);
            end
            fprintf(fid,'\n');
        end
    end

end

end

