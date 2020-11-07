function AMIGO_writeHTMLdoc(fid,depth,inputName,varargin)
% recursively writes the fields of structures into HTML table
%
% AMIGO_writeHTMLdoc(fid,depth,inputName,s1,s2,...)
% Inputs:
%   s       struct, may contain fields that are themself structures.
%   s1,s2,... must have the same structure
%   depth   set up the display depth of the structure: inf - full depth (default)
%   fid     file handler for writing to  file.
%   inputName   string that represents the name of the documented structure
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
    fprintf(fid,'<tr><th colspan = "%d">%s</th></tr>\n',length(f),parents);
    tagged_struct = f(1);
    [temp, p] = AMIGO_orderfields(tagged_struct);
    f = orderfields(f,p);
    
    fn = fieldnames(f);
    for i = 1:length(fn)
        
        fullfieldName = strcat(parents,'.', fn{i});
        if isstruct(f(1).(fn{i}))
            extractfield([f.(fn{i})],level+1,fid,depth,fullfieldName); % getfield(f,fn{i})
        else
            fprintf(fid,'<tr>\t');
            out = {f.(fn{i})};
            for iout = out
                outstr = AMIGO_toString(iout{:},false);
            fprintf(fid,'<td>%s\t',outstr);
            end
            fprintf(fid,'</tr>\n');
        end
    end

end

end



