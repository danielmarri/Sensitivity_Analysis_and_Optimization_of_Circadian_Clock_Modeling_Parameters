function n_opt = AMIGO_generalizedCrossValidationGolub(A,R,W,alpha,plot_flag)
%AMIGO_generalizedCrossValidationGolub(A,x,noiseStd,alpha,tau) computes the optimal regularization parameter
% based on the Generalized Cross-validation method. (implementation as
% Golub 1979)
%
%   Inputs:
%   A   regression matrix
%   X   solution matrix, each column is the solution corresponding to a reg. par.
%   noiseStd    standard deviation of the noise
%   alpha   regularization parameter vector

fprintf('--> Regularization by the Generalized Cross-validation Method (Golub''s version)\n')
if nargin < 4 || isempty(plot_flag)
    plot_flag = false;
end

nreg = length(alpha);
if size(A,3) == 1;  % linear problem convention
    A = repmat(A,[1,1,nreg]);
end
[n,m] = size(A(:,:,1));

V = zeros(nreg,1);


for i = 1:nreg
    Ai = A(:,:,i);
    Wi = W(:,:,i);
    V(i) = AMIGO_gcv(R(:,i),Ai,alpha(i),Wi);
end

% figure()
% plot(alpha,V,'.-')
% set(gca,'xscale','log');

[~, n_opt] = min(V);

if n_opt == 1
    fprintf('--> WARNING: Generalized Cross-validation (Golub) method\n\t Obtained regularization parameter is on the bound. You may increase the bound for the reg. parameter.\n\n')
elseif n_opt == nreg
    fprintf('--> WARNING: Generalized Cross-validation (Golub) method\n\t Obtained regularization parameter is on the bound. You may decrease the bound for the reg. parameter.\n\n')
end

if plot_flag
    figure()
    
    plot(alpha,V,'.-'), hold all
    plot(alpha(n_opt),V(n_opt),'r*')
    xlabel('regularization parameter')
    ylabel('crossvalidation error estimate')
    
    set(gca,'xscale','log')
    title('Generalized Crossvalidation (Golub version)')
end