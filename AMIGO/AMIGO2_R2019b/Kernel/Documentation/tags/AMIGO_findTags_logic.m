function [flag] = AMIGO_findTags_logic(str,tagExpr)
%[flag] = AMIGO_findTags_logic(str,tags) checks the logical expression on the input string
% str     is the string labelled by tags
% tagExpr is a logical expression involving tags (#TAG1|#TAG2&(~#TAG3|#TAG4))
%
% test:
% teststr = 'some text #PE #IVP #LVL2';
% key = '#PE&(~#REG|~#DEV)';  % parameter estimation related but not regularization or for developers
%  AMIGO_findTags_logic(teststr,key)



% process the tagExpression to find TAG tokens.
[tagstring,splitstring] = regexp(tagExpr,'#[a-zA-Z0-9]*','match','split');
ntags = length(tagstring);
tag = zeros(ntags,1);
for i =  1: ntags
    mstr = tagstring{i};
    tmp = strfind(str,mstr);
    if isempty(tmp)
        tag(i) = 0;
    else
        tag(i) = 1;
    end
end

% replace the tags with logical values in the tagExpr
logicExpr = '';
for i =  1: ntags
    logicExpr = strcat(logicExpr, splitstring{i}, num2str(tag(i),'%d'));
end
logicExpr = strcat(logicExpr, splitstring{i+1});
flag = eval(logicExpr);
