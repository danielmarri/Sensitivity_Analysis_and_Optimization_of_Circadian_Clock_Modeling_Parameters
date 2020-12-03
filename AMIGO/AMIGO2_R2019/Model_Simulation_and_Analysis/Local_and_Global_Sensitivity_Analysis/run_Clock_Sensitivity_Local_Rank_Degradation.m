% Computes the Mammalian circadian clock model local parametric sensitivities and 
% rank or parameters 
clear all;

Clock_Sensitivity_Degradation   % Calls the script with the inputs: 
                                % Model
                                % Experimental scheme 
                                % Rank problem formulation: unknowns to be
                                % considered + value of unkwnowns for which the
                                % analysis is performed
                                % Numerical approaches for simulation and sensitivity
                                % analysis

AMIGO_Prep(inputs)             % Calls the task for pre-processing

AMIGO_LRank(inputs)            % Calls the task for Local Rank
