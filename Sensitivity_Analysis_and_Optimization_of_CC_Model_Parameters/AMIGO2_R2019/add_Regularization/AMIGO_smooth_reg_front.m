function [ output_args ] = AMIGO_smooth_reg_front( AMIGO_PE_inputs, reg_summary )
%AMIGO_SMOOTH_REG_FRONT smooth the L curve pareto front by multistarted
%optimization.
%   The function takes previously obtained regularization results. The goal
%   is to obtain a smooth pareto front, that does not have dominated
%   points. 
%   For each regularzation parameter a multistart optimization is launched.
%   The initial points of the multistart are the 'optimal' parameters
%   obtained with each regularization.

AMIGO_PE_inputs.nlpsol.nlpsolver = 'multi_nl2sol';
AMIGO_PE_inputs.nlpsol.multi_starts = 0; %this is the # of excess points.  iguess_set.n_guess;

[AMIGO_PE_inputs.PEsol.global_theta_guess,...
 AMIGO_PE_inputs.PEsol.global_theta_y0_guess,...
 AMIGO_PE_inputs.PEsol.local_theta_guess,...
 AMIGO_PE_inputs.PEsol.local_theta_y0_guess] = init_parameter_guesses(inputs,iguess_set);


hfig2=1002;
titlestr = 'Step 2: multistart nl2sol from the previous optima';
%AMIGO_update_LCurve_plot(hfig2,Q_cost,Q_penalty,alphaSet,titlestr);


Q_cost = [];
Q_penalty = [];
% run for the newly asked points and the previously obtained points (for
% consistency)
nalpha = nalpha + n_pre_alpha;
alphaSet = [alphaSet pre_alpha];

for ialpha = 1:nalpha
    AMIGO_PE_inputs.nlpsol.regularization.alpha = alphaSet(ialpha);
    AMIGO_PE_inputs.pathd.runident = sprintf('%s_regstep2_alpha%d',inputs.pathd.runident,ialpha);
    
    PE_results(ialpha) = AMIGO_PE(AMIGO_PE_inputs);
    a = AMIGO_get_reg_summary(PE_results((ialpha)));
    Q_cost = a.Q_LS;
    Q_penalty = a.Q_penalty;
%     theta(ialpha,:) = PE_results(ialpha).fit.thetabest;
    
    AMIGO_update_LCurve_plot(hfig2,Q_cost,Q_penalty,alphaSet(ialpha),titlestr,'.m');
end





end

