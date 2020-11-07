function n_opt = AMIGO_robustGeneralizedCrossValidation(A,R,W,alpha,tau,plot_flag)
%AMIGO_robustGeneralizedCrossValidation(A,x,noiseStd,alpha,tau) computes the optimal regularization parameter
% based on the Robust Generalized Cross-validation method.
%
%   Inputs:
%   A   regression matrix
%   X   solution matrix, each column is the solution corresponding to a reg. par.
%   noiseStd    standard deviation of the noise
%   alpha   regularization parameter vector

fprintf('--> Regularization by the Robust Generalized Cross-validation Method\n')
if nargin < 5 || isempty(plot_flag)
    plot_flag = false;
end
nreg = length(alpha);
if size(A,3) == 1;  % linear problem convention
    A = repmat(A,[1,1,nreg]);
end
[n,m] = size(A(:,:,1));

nR = zeros(nreg,1);
Q = zeros(nreg,1);

for i = 1:nreg
    Ai = A(:,:,i);
    Wi = W(:,:,i);
    nR(i)= norm(R(:,i))^2;
    invA_nreg = (Ai'*Ai + alpha(i)*(Wi'*Wi))\Ai'; %inv(A'*A + alpha(i)*eye(m))*A';
    Q(i)=(1/n*trace(eye(n)-Ai*invA_nreg))^2;
    nR(i) = nR(i)*(tau+(1-tau)*1/n*trace((Ai*invA_nreg)^2));
end

V= nR./Q;

[~, n_opt] = min(V);

if n_opt == 1
    fprintf('--> WARNING: Robust Generalized Cross-validation method\n\t Obtained regularization parameter is on the bound. You may increase the bound for the reg. parameter.\n\n')
elseif n_opt == nreg
    fprintf('--> WARNING: Robust Generalized Cross-validation method\n\t Obtained regularization parameter is on the bound. You may decrease the bound for the reg. parameter.\n\n')
end

if plot_flag
    figure()
    
    plot(alpha,V,'.-'), hold on
    plot(alpha(n_opt),V(n_opt),'r*')
    xlabel('regularization parameter')
    ylabel('crossvalidation error estimate')
    
    set(gca,'xscale','log')
    title('Robust Generalized Crossvalidation')
end