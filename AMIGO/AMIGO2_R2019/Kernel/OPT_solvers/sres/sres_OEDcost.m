% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/sres/sres_OEDcost.m 770 2013-08-06 09:41:45Z attila $



function [f,h,g] = sres_OEDcost(x,inputs,results,privstruct)

for i=1:size(x,1)
    [f(i,1),h(i,:),g(i,:)]= AMIGO_OEDcost(x(i,1:size(x,2)),inputs,results,privstruct);
end

