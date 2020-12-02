 function  xstr = AMIGO_num2latexstr(x,precision)
% converts the array of numbers to a cell of strings, interpretable with latex.
% Example:
%       x = [10e10 1000 1000 10  0.156 .65188 0.000015616 0.00556 11.154e-6 ];
%       xstr = num2latexstr(x);
%       xstr'


if nargin < 2
prec = 3;
else
    prec = precision;
end

[nx,ny] = size(x);
x = x(:);



expressn = '(?<sign>[+\-]?)(?<digs>[0-9]+)\.?(?<fracdigs>[0-9]*)(e?)(?<expsign>[+\-]?)(?<expdig>[0-9]*)';
for i = 1:length(x)
    if isinf(x(i))
        if (x(i)>0)
            xstr{i} = 'inf';
        else
            xstr{i} = '-inf';
        end
        continue;
    end
    if isinf(x(i))
        xstr{i} = 'inf';
        continue;
    end
    
    if abs(x(i))> 10^(prec+1) || abs(x(i))< 10^(-prec+1)
        tmpstr = strtrim(cellstr(num2str(x(i),sprintf('%%#3.%de',prec))));
    else
        tmpstr = strtrim(cellstr(num2str(x(i),sprintf('%%#3.%dg',prec+1))));
    end
    
    str = tmpstr{1};
    [tok match names] = regexp(str,expressn,'tokens', 'match','names','warnings');
    
    % dont put leading positive sign
    if ~isempty(names.expsign) && strcmp(names.expsign,'+')
        names.expsign = '';
    end
    
    
    % mantissa:
    if isempty(names.fracdigs)
    mantissa =  [names.sign names.digs];
    else
    mantissa = [names.sign, names.digs,'.' , names.fracdigs];
    end
    
    % exponent
    if ~isempty(names.expdig)
        nfrac = str2double(names.expdig);
        names.expdig = num2str(str2double(names.expdig),'%i');
    end
    
    % treat case 1.0*10^d => 10^d    
    if strcmp(names.digs,'1') && str2double(names.fracdigs)==0 && ~isempty(names.expdig)
        xstr{i} = strcat( names.sign,'10^{',names.expsign,names.expdig,'}');
        continue;
    end
    
    % treat non-exponential case
    if isempty(names.expdig)
        xstr{i} = mantissa;
     
    else
        xstr{i} = strcat( mantissa,'\cdot10^{',names.expsign,names.expdig,'}');
    end
end

xstr = reshape(xstr,nx,ny);

