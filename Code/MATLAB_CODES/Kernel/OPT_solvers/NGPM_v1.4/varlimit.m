% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/varlimit.m 770 2013-08-06 09:41:45Z attila $
function var = varlimit(var, lb, ub)
% Function: var = varlimit(var, lb, ub)
% Description: Limit the variables in [lb, ub].
%
%         LSSSSWC, NWPU
%    Revision: 1.0  Data: 2011-04-20
%*************************************************************************

numVar = length(var);
for i = 1:numVar
    if( var(i) < lb(i) )
        var(i) = lb(i);
    elseif( var(i) > ub(i) )
        var(i) = ub(i);
    end
end

