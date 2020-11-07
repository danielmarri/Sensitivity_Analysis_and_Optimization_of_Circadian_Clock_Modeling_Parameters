% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/convertPowerOperator.m 770 2013-08-06 09:41:45Z attila $

function [formula] = convertPowerOperator(formula)
% remove whitespaces from formula
formula = regexprep(formula,'\s','');
% first fix the simple problem
formula = regexprep(formula,'([\w]+[.]?[\w]*)\^([\w]+[.]?[\w]*)','pow($1,$2)');
% replace sbml power
formula = regexprep(formula,'power','pow');
% then do the more complicated stuff
indices = strfind(formula,'^');

formula = regexprep(formula,'elseif','else if');

if iscell(indices)
    indices=cell2mat(indices);
end
if iscell(formula)
    formula=cell2mat(formula);
end

while ~isempty(indices),
    index = indices(1);   
    formula1 = strtrim(formula(1:index-1));
    formula2 = strtrim(formula(index+1:end));
    % check formula1 from the right
    firstargument = regexp(formula1,'([\w]+[.]?[\w]*)$','match');
    if isempty(firstargument),
        % check if last character is a closing parenthesis
        if formula1(end) ~= ')',
            error(sprintf('Error in formula: %s',formula));
        end
        % count parentheses
        pc = 1; 
        cend = length(formula1);
        cstart = cend;
        while pc ~= 0,
            cstart = cstart - 1;
            if formula1(cstart) == ')',
                pc = pc+1;
            elseif formula1(cstart) == '(',
                pc = pc-1;
            end
        end
        firstargument = formula1(cstart+1:cend-1);
    else
        firstargument = firstargument{1};
        cstart = length(formula1)-length(firstargument)+1; 
    end
    cendfirst = cstart;
    % check formula2 from the left
    secondargument = regexp(formula2,'^([\w]+[.]?[\w]*)','match');
    if isempty(secondargument),
        % check if first character is an opening parenthesis
        if formula2(1) ~= '(',
            error(sprintf('Error in formula: %s',formula));
        end
        % count parentheses
        pc = 1; 
        cstart = 1;
        cend = cstart;
        while pc ~= 0,
            cend = cend + 1;
            if formula2(cend) == '(',
                pc = pc+1;
            elseif formula2(cend) == ')',
                pc = pc-1;
            end
        end
        secondargument = formula2(cstart+1:cend-1);
    else
        secondargument = secondargument{1};    
        cend = length(secondargument);
    end
    cstartsecond = cend;
    % construct power expression
    powerexp = sprintf('pow(%s,%s)',firstargument,secondargument);
    % construct new formula
    formula = [formula1(1:cendfirst-1) powerexp formula2(cstartsecond+1:end)];
    % get new indices for '^' character
    indices = strfind(formula,'^');
end
return