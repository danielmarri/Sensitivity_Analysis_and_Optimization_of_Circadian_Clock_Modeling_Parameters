function cs = AMIGO_structs2Table(varargin)
% AMIGO_structs2Tables converts similar structures into 2D cellstring arrays
% displaying the fields of the struct.
%
% Syntax:
%   cs = AMIGO_structs2Table(s1,s2,...)
% Example:
%   inputs_doc = AMIGO_default_options_doc;
%   inputs_def = AMIGO_default_options;
%   AMIGO_structs2Table(inputs_doc.model,inputs_def.model)

% basic checks of inputs
if nargin == 0
    fprintf('minimum one structure is needed\n');
    cs = [];
    return
else
    for i = 1:nargin
        if ~isstruct(varargin{i})
            fprintf('the inputs must be structures with identical fieldnames.\n');
            cs = [];
            return;
        end
    end
end


fn = fieldnames(varargin{1});
nfield = length(fn);
cs = cell(nfield,nargin);
for i = 1:nfield
    
    if isstruct(varargin{1}.(fn{i}))
        %                 continue
%         evalStr = sprintf('AMIGO_structs2Table(varargin{1}.(fn{%d})',i);
%         for k = 2:nargin
%             evalStr = strcat(evalStr,sprintf(',varargin{%d}.(fn{%d})',k,i));
%         end
%         evalStr = strcat(evalStr,');');
%         cs{i,1} = eval(evalStr);
        cs(i,1) = cellstr(strcat(inputname(1),'.' ,fn{i}));
        continue
    end
    
    for j = 1:nargin
        if isfield(varargin{j},fn{i}) 
            tmp = AMIGO_toString(varargin{j}.(fn{i}));
            cs(i,j) = cellstr(tmp);
        else
            cs(i,j) = cellstr('');
        end
    end
end
