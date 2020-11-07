function [OAL DoF] = AMIGO_Chi2LevelofAcceptance(alpha,ndata,npar)
% AMIGO_Chi2LevelofAcceptance(alpha,ndata,npar) calculates the Chi2 objective function value limit
% that would not be rejected on the significance level of alpha.



fprintf('ndata: %d\n', ndata);
fprintf('nestpar: %d\n', npar);
DoF =  ndata - npar;
fprintf('DOF: %d\n',DoF);
fprintf('Significance level: %f\n', 1-alpha);
% objective acceptance level:
OAL = chi2inv(1-alpha,DoF);
fprintf('Obj_LoA: %g\n',OAL);