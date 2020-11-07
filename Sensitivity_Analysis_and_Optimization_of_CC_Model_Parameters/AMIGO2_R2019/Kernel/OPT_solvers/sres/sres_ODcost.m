% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/sres/sres_ODcost.m 770 2013-08-06 09:41:45Z attila $



function [f,h,g] = sres_ODcost(x,inputs,results,privstruct)

cost_function=results.pathd.OD_function; 
for i=1:size(x,1)
    eval(sprintf('[f(i,1),h(i,:),g(i,:)]=%s(x(i,1:size(x,2)),inputs,results,privstruct);',cost_function));
    
end

