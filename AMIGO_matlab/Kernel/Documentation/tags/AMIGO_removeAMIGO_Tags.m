function [strNT] = AMIGO_removeAMIGO_Tags(str)
%[strNT] = AMIGO_removeAMIGO_Tags(str) finds and removes the tags from the structure's fields .

[strNT] = AMIGO_findTags(str);