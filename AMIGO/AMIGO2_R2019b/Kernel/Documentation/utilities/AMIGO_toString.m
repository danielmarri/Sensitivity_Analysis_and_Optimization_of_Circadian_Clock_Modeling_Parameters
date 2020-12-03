function tmp = AMIGO_toString(f,writeEmptyType)
% AMIGO_toString converts variable into string.

if nargin < 2 || isempty(writeEmptyType)
    writeEmptyType = true;
end
tmp = '';
fs = size(f);
cf = class(f);
if isempty(f)
    if writeEmptyType
        tmp = strcat(tmp, sprintf('[] (%s)',cf));
    end
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
%     elseif isstruct(f)
%             tmp = strcat(tmp, inputname(1));
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

end