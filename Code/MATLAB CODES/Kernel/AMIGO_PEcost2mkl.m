% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_PEcost2mkl.m 770 2013-08-06 09:41:45Z attila $
function g = AMIGO_PEcost2mkl(theta,inputs,results,privstruct)
% extract the residual vector from the returned values of the cost function.
% For the computation of the sensitivities of the residuals with MKL in AMIGO_PEJac 
[~,~,g] = AMIGO_PEcost(theta,inputs,results,privstruct);