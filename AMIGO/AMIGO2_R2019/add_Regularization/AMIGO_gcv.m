function [V A] = AMIGO_gcv(R,J,alpha,W)
% V = AMIGO_gcv(R,J,alpha,W) computes the prediction error estimate V.
% based on GOLUBetAl(1979)
% 
% orignally works for linear estimation problems and ridge regression. 
%    || Ax-b||^2 + alpha||x||^2
% this implementation includes W (instead of the Identity in ridge, but 
% the reference regularization vector is not included. How to incorporate that bias???)

[n , p] = size(J);
% scaling for the convention:
lambda = alpha/n;



A = J*((J'*J + n*lambda*(W'*W))\J'); % A = J*inv(J'*J + n*lambda*(W'*W))*J';
%         V = 1/n*(R(:)'*R(:))  / (1/n*trace(eye(n)-A))^2;
V = 1/n*norm((eye(n)-A)*R)^2  / (1/n*trace(eye(n)-A))^2;
