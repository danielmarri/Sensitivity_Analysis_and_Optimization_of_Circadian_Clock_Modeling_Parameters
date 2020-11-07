function AMIGO_verifyRegularization (reg_inputs, reg_results,index_theta)


if nargin<3
    index_theta =1:length( reg_inputs.model.par);
end
theta_true = reg_inputs.model.par(index_theta);

n_results = numel(reg_results.regularization.PEiter);
n_reg_theta = numel(reg_results.regularization.ref_par.gx0);

nexp = length(reg_results.regularization.PEiter(1).fit.ms);
ndata = 0;
for iexp = 1:nexp
ndata = ndata + numel(reg_results.regularization.PEiter(1).fit.ms{iexp});
end


for i =1:n_results
    
    Jreg = reg_results.regularization.PEiter(i).fit.Rjac;
    J = Jreg(1:end-n_reg_theta,:);
    
    H = J'*J;
    
    s = eig(H);
    
    alpha(i) = reg_results.regularization.PEiter(i).regularization.alpha;
    SoS = reg_results.regularization.PEiter(i).regularization.cost;
    theta_ref = reg_results.regularization.ref_par.gx0;
    
    % effective number of parameters:
    d(i) = sum(s.^2./(s+alpha(i)).^2);
    
    bias(i) = alpha(i)/8 * norm(theta_true- theta_ref)^2;
    variance(i) = SoS/(2*ndata)*d(i);
    
end

figure()
plot(alpha,bias,'.--',alpha,variance,'.--')
set(gca,'xscale','log')
legend('Bias','M. Variance')

figure()
plot(alpha,d,'.--')
title('effective number of parameters')
    