function AMIGO_displayStruct_fullsyntax_html(s,fid,depth)
% recursively displays the fields of struct s in the Command Window or write
% in the text file given by the filehandler fid. 
%
% Inputs:
%   s       structure, may contain fields that are themself structures.
%   depth   set up the display depth of the structure: inf - full depth (default)
%   fid     file handler for writing to text file.
%
% Field values are displayed if they are either scalar numeric/logic values
% or one dimensional strings, otherwise their size and types are displayed.
%
% EXAMPLES:
%   a = struct('field1',rand(5),'field2', 5,...
%   'field3',struct('field11','apple'));
%
%   % display all depth: 
%   AMIGO_displayStruct_fullsyntax(a);
%
%   % display only the first layer:
%   AMIGO_displayStruct_fullsyntax(a,[],1);

if nargin < 2 || isempty(fid)
    fid = 1;
end
if nargin < 3 
    depth = inf;
end

input_name = inputname(1);
if isempty(input_name)
    input_name = 's';
end
%fprintf(fid,'%s',input_name);
if ~isstruct(s)
    display(s)
    return;
end
parents = input_name;

fprintf(fid,'<table style="width:600px">\n');
fprintf(fid,'<tr>');
fprintf(fid,'  <th>Struct</th>');
fprintf(fid,'  <th>Description</th> ');
fprintf(fid,'</tr>\n');

extractfield(s,1,fid,depth,parents);
fprintf(fid,'</table>');


%  fn = fieldnames(s);
% for i = 1:length(fn)
%     f = getfield(s,fn{i});
%     fprintf('\t%s.\n',fn{i});
%     disp(f);
end

function extractfield(f,level,fid,depth,parents)


if isstruct(f) && level <= depth
    fprintf(fid,'<tr><th colspan = "2">%s</th></tr>\n',parents);
    f = orderfields(f);
    %fprintf(fid,'.\n');
    fn = fieldnames(f);
    for i = 1:length(fn)
        %for j=1:level, fprintf(fid,'\t'); end
        fullfieldName = strcat(parents,'.', fn{i});
%         fprintf(fid,'<th>%s<\th>',fullfieldName);
        extractfield(getfield(f,fn{i}),level+1,fid,depth,fullfieldName);
    end
else
    tmp = '';
    fs = size(f);
    cf = class(f);
    tmp_parents = strcat(tmp, sprintf('<td>%s',parents));
    if isempty(f)
        tmp = strcat(tmp, sprintf('[]'));
    elseif isscalar(f)
        if isfloat(f) && rem(f,1)==0
            tmp = strcat(tmp, sprintf('%d',f));
        elseif isfloat(f)
            tmp = strcat(tmp, sprintf('%g',f));
        elseif ischar(f)
            tmp = strcat(tmp, sprintf('%s',f));
        elseif islogical(f)
            if f
                tmp = strcat(tmp, sprintf('''true'''));
            else
                tmp = strcat(tmp, sprintf('''false'''));
            end
        else
            tmp = strcat(tmp, sprintf('(%dx%d ',fs));
            tmp = strcat(tmp, sprintf('%s)',cf));
        end
    elseif ischar(f) && (fs(1)==1 || fs(2)==1)
        tmp = strcat(tmp, sprintf('%s',f));
    else
        tmp = strcat(tmp, sprintf('(%dx%d ',fs));
        tmp = strcat(tmp, sprintf('%s)',cf));
    end
    fprintf(fid,strcat('<tr>',tmp_parents,'<td>',tmp,'<tr>','\n'));
end

end