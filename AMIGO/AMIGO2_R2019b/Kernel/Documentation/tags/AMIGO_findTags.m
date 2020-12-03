function [strNT tagstr] = AMIGO_findTags(str,t)
%[tagstr strNT] = AMIGO_findTags(str,tags) finds and returns the tags in a cell str.
% strNT is the string without the tags.
% tagstr is the list of tags
% t is a tag,by default taken from  AMIGO_tags.m

if nargin < 2 || isempty(t)
    t = AMIGO_tags;
end
tagstr = cellstr('');

ntags = length(t);

nFoundTags = 0;

for i = 1:ntags
    p = strfind(str,t{i});
    if ~isempty(p)
        nFoundTags = nFoundTags+1;
        tagstr(nFoundTags) = t(i);
        str(p:p+length(t{i})-1)=[];
    end
end
strNT = str;
