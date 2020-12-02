function delta_cross = AMIGO_illposedness(inputs,global_theta_est,global_theta_y0_est,globl_theta_ref, global_theta_y0_ref)
% AMIGO_illposedness(inputs) computes the ill-posedness of the
% problem (using the nominal parameters) based on the Ljung criteria.
%
% This criteria compares the regularization bias to the reduced variance.
% 1)  The variance of the parameters increases with the number of parameters
% and this variance is propagated to the predictions. The reduced variance
% is the "eliminated" number of superflous parameters time the variance
% contribution of one parameter. 
%
% For the bias Ljung estimates an upper bound based on local linearization
% of the prediction error.
%
% Note that in our computation we use different scaling of the cost
% function and regularization term. I.e. the least squares cost is not
% normalized by the number of datapoints.


% compute the mean variance of the measurement error:
if isempty(inputs.exps.error_data), error('error data is needed.'),end;
lambda0 = mean(reshape([inputs.exps.error_data{:}],[],1).^2);

% compute the FIM
FIMinp = inputs;
% make sure we use the nominal parameters:
theta_est = [global_theta_est global_theta_y0_est];
theta_ref = [globl_theta_ref, global_theta_y0_ref];
FIMinp.PEsol.global_theta_guess = global_theta_est;
FIMinp.PEsol.global_theta_y0_guess = global_theta_y0_est;
FIMinp.plotd.plotlevel = 'noplot';
FIMinp.nlpsol.regularization.ison = 0;

[~, rFIM] = evalc(' AMIGO_FIM(FIMinp);');

J = rFIM.fit.Rjac;
N = size(J,1);
Q = 1/N * J'*J; % the approximated (first order based) Hessian

sQ = sort(real(eig(Q)),'ascend');
if any(sQ<=0)
    fprintf('The problem is badly conditioned, the FIM is singular\n');
end
sQ(sQ<0) = 0;

npar = length(theta_est);

% compute for the regualarization parameters that are in the range. 
delta0 = sQ(sQ>0)';
delta = [];
for i = 1:length(delta0)-1
    delta = [delta logspace(log10(delta0(i)),log10(delta0(i+1)),5)];
end
for i = 1:numel(delta)
    bias(i) = Tikhonov_bias(delta(i),Q,theta_est,theta_ref);
    dvariance(i) = lambda0/(2*N)*(npar - AMIGO_effective_npar(Q,delta(i)));
end

% find the crossing point
[ ub_ind ] =  find(bias>dvariance,1);
[ lb_ind ] =  find(bias<dvariance,1,'last');

if isempty(lb_ind)
    lb = 0;
else
    lb = delta(lb_ind);
end
opt_fun = @(d)abs(Tikhonov_bias(d,Q,theta_est,theta_ref) - (lambda0/(2*N)*(npar - AMIGO_effective_npar(Q,d))));
delta_opt = fminbnd(opt_fun,lb,delta(ub_ind),optimset('TolX',1e-10*delta(ub_ind),'Display','final'));
delta_cross = delta_opt*N;

bias_cross = Tikhonov_bias(delta_opt,Q,theta_est,theta_ref);
dvar_cross =  lambda0/(2*N)*(npar - AMIGO_effective_npar(Q,delta_opt));

if lb == 0  % add the optimal to the curve:
bias = [bias_cross bias];
dvariance = [dvar_cross dvariance];
delta = [delta_opt delta];
end


delta_amigo = delta*N; % because of the different formulation of the regularization term


% evaluate the values at the singular values of the Q matrix
for i = 1:numel(delta0)
    bias0(i) = Tikhonov_bias(delta0(i),Q,theta_est,theta_ref);
    dvariance0(i) = lambda0/(2*N)*(npar - AMIGO_effective_npar(Q,delta0(i)));
end


figure('color','w')
plot(delta_amigo,bias,'.--'), hold all
plot(delta_amigo,dvariance,'.--')
plot(N*delta0,bias0,'mo',N*delta0,dvariance0,'mo')
plot(delta_cross,dvar_cross,'r*')
xlabel('regularization parameter')
h = legend('bias','reduced variance','eig.val. of Q');
set(h,'location','northwest');
set(gca,'xscale','log')
set(gca,'yscale','log')
AMIGO_fig2publish([],14,2,16)

