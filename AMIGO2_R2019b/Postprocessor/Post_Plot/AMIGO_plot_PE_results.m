function AMIGO_plot_PE_results(inputs,results)
% AMIGO_plot_PE_results plots the PE results from the inputs and results. 
% In a sense this is a wrapper for AMIGO_post_plot_PE but also includes:
% -- 




% add the default fields/values to the inputs and generate the privstruct.
[~,inputs,~,privstruct]=evalc('AMIGO_Structs_PE(inputs)');

%% update the privstruct with the results from the PE.
% optimal parameters:
privstruct.theta = results.fit.thetabest;

% check if sensitivities were calculated:
privstruct.istate_sens = 1;
for iexp = 1:inputs.exps.n_exp
    if any(isnan(results.fit.SM{iexp}))
        privstruct.istate_sens = -1;
    end
end

if ~isempty(results.fit.conf_interval)
     privstruct.conf_intervals = 1;
else
     privstruct.conf_intervals = 0;
end

privstruct.theta
pause
AMIGO_post_plot_PE(inputs,results,privstruct);