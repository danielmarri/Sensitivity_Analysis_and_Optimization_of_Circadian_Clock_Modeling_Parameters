% RUNThe mammalian circadian clock model simulation - shows observables
clear all;
close all;


My_Clock_model   % Calls the script with the inputs: 
                             % Model
                             % Experimental scheme (number of experiments, initial 
                             % & stimulation conditions, OBSERVABLES, final time - per experiment) 
                             % Numerical approaches for simulation 

AMIGO_Prep(inputs)           % Calls the task for pre-processing

AMIGO_SObs(inputs)           % Calls the task for simulating observables
