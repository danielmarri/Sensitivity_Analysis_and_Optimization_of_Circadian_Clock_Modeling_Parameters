% Computes Arabidopsis circadian clock model global parametric sensitivities and 
% rank or parameters 

clear all;

cprintf('*[1,0.5,0]','\n\n --->Computing global sensitivities, this may take a while...');


Clock_Sensitivity_Degradation % Calls the script with the inputs: 
                                  % Model
                                   % Experimental scheme 
                                   % Rank problem formulation: unknowns to be
                                   % considered + value of unkwnowns for which the
                                   % analysis is performed
                                   % Numerical approaches for simulation and sensitivity
                                   % analysis

AMIGO_Prep(inputs)         % Calls the task for pre-processing
    

AMIGO_GRank(inputs)        % Calls the task for Global Rank