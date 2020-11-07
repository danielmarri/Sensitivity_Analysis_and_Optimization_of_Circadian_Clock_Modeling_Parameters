% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/sres/sres_PEcost.m 770 2013-08-06 09:41:45Z attila $



function [f,h,g] = sres_PEcost(x,inputs,results,privstruct)

for i=1:size(x,1)
    [f(i,1),h(i,:),g(i,:)]= AMIGO_PEcost(x(i,1:size(x,2)),inputs,results,privstruct);
end

