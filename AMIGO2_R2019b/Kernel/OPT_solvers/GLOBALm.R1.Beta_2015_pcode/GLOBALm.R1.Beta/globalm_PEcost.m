% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/GLOBALM.R1.beta.PUBLIC/globalm_PEcost.m 770 2013-08-06 09:41:45Z attila $

function [f,h] = globalm_PEcost(x,inputs,results,privstruct)
[f,h,g]= AMIGO_PEcost(x',inputs,results,privstruct);

