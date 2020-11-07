function u_inputs = AMIGO_updatePEinputsbyPEresults(inputs,results)
% AMIGO_updatePEinputsbyPEresults updates the AMIGO_PE inputs by the
% results of the AMIGO_PE. I.e. the best parameter vector is copied to the
% inputs.PEsol initial guess structures.
%
% NOTE: there is no input checking coded here, thus some nuisance
% parameters, for example the number of global/local parameters/initial
% conditions should be already initializedin the inputs.
%
% See also: AMIGO_update_inputs_with_PEresults


% create an initial guess structure:
iguess_set = AMIGO_update_parameter_guesses(inputs,[],results.fit.thetabest);

u_inputs = inputs;
% update the inputs:
[u_inputs.PEsol.global_theta_guess,...
 u_inputs.PEsol.global_theta_y0_guess,...
 u_inputs.PEsol.local_theta_guess,...
 u_inputs.PEsol.local_theta_y0_guess] = AMIGO_init_parameter_guesses(inputs,iguess_set);