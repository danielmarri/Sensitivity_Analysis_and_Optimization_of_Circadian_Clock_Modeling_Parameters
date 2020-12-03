function sc_eqns = AMIGO_scale_variables_in_equations(eqns,var,factor)
% scale_variable_in_equation(eqns,var,factor) scales the variable by the
% factor in the right hand side of the equation eqns. 
% if an element of factor is NaN, the corresponding element is not scaled.

nvar = size(var,1);
nfac = length(factor);

if nvar~=nfac
    error('scale_variable_in_equation:wrongDimensions','the number of variables and scaling factors should be equal.')
end
if any(factor==0)
    fprintf(2,'WARNING:\n\t\tScaling with zero is not recommended\n\n');
end

for i = 1:nvar
    if isnan(factor(i))
        exprstr{i} = char();
        repstr{i} =char();
    else
        exprstr{i} = ['(\W)' strtrim(var(i,:)) '(\W|$)'];  % we want to find the variable for example x, but not for example dx or tmp_x_ instead of x
        repstr{i} = sprintf('$1(%s*%.8g)$2',strtrim(var(i,:)),factor(i));
    end
end
c_eqns = cellstr(eqns);
sc_eqns  = regexprep(c_eqns,exprstr,repstr);

% scale the right hand side, if the differential variable appears in the left hand side
for i = 1:nvar
    if isnan(factor(i))
        exprstr{i} = char();
        repstr{i} =char();
    else
        exprstr{i} = ['^d' strtrim(var(i,:)) '\s*=(.*)'];  % we want to find the variable for example x, but not for example dx or tmp_x_ instead of x
        repstr{i} = sprintf('d%s = %.8g*$1',strtrim(var(i,:)),1/factor(i));
    end
end
sc_eqns  = regexprep(sc_eqns,exprstr,repstr);
sc_eqns = char(sc_eqns);
end
