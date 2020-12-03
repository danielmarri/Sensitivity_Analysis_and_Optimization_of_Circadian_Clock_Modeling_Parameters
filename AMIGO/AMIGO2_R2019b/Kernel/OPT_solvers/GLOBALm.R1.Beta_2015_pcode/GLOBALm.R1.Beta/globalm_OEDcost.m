% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/GLOBALM.R1.beta.PUBLIC/globalm_OEDcost.m 770 2013-08-06 09:41:45Z attila $

function [f,h] = globalm_OEDcost(x,inputs,results,privstruct)

    [f,h,g]= AMIGO_OEDcost(x,inputs,results,privstruct);

