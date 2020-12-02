% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/eSS/local_solvers/lbfgsb/call_lbfgsb.m 770 2013-08-06 09:41:45Z attila $
%
function [x,fval,exitflag] = call_lbfgsb(x0,grad, lb, ub,opts)



[x, fval, exitflag, iter, feval] = lbfgsb(@objf_lbfgsb,grad,lb,ub,x0,opts);

%Collect Results

switch(exitflag)
    case 1
        info.Status = 'Optimal';
    case 0
        info.Status = 'Exceeded Iterations';
    case -1
        info.Status = 'Infeasible / Could not Converge';
    case -2
        info.Status = 'L-BFGS-B Error';
    case -5
        info.Status = 'User Exited';
    otherwise        
        info.Status = 'L-BFGS-B Error';
end

fprintf('L-BFGS-B ended after %d iteration and %d function evaluation:\n', iter,feval);
fprintf('       Results: %s\n',info.Status);
