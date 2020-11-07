function AMIGO_displayStruct_fullsyntax(s,fid,depth,inputName)
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
if nargin < 3 || isempty(depth)
    depth = inf;
end

if nargin < 4 || isempty(inputName)
input_name = inputname(1);
if isempty(input_name)
    input_name = 's';
end
else
    input_name = inputName;
end
%fprintf(fid,'%s',input_name);
if ~isstruct(s)
    display(s)
    return;
end
parents = input_name;
extractfield(s,1,fid,depth,parents);


%  fn = fieldnames(s);
% for i = 1:length(fn)
%     f = getfield(s,fn{i});
%     fprintf('\t%s.\n',fn{i});
%     disp(f);
end

function extractfield(f,level,fid,depth,parents)
if isstruct(f) && level <= depth
    [f] = AMIGO_orderfields(f);
    %fprintf(fid,'.\n');
    fn = fieldnames(f);
    for i = 1:length(fn)
        %for j=1:level, fprintf(fid,'\t'); end
        fullfieldName = strcat(parents,'.', fn{i});
        %fprintf(fid,'%s',fullfieldName);
        extractfield(getfield(f,fn{i}),level+1,fid,depth,fullfieldName);
    end
else
    fs = size(f);
    cf = class(f);
    fprintf(fid,'%s=\t',parents);
    if isempty(f)
        fprintf(fid,'[]\n');
    elseif isscalar(f)
        if isfloat(f) && rem(f,1)==0
            fprintf(fid,'%d\n',f);
        elseif isfloat(f)
            fprintf(fid,'%g\n',f);
        elseif ischar(f)
            fprintf(fid,'%s\n',f);
        elseif islogical(f)
            if f
                fprintf(fid,'''true''\n');
            else
                fprintf(fid,'''false''\n');
            end
        else
            fprintf(fid,'(%dx%d ',fs);
            fprintf(fid,'%s)\n',cf);
        end
    elseif ischar(f) && (fs(1)==1 || fs(2)==1)
         fprintf(fid,'''%s''\n',f);
    else
        fprintf(fid,'(%dx%d ',fs);
        fprintf(fid,'%s)\n',cf);
    end
end

end