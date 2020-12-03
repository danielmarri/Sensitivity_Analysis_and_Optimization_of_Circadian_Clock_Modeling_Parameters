function inputs = AMIGO_check_SData_inputs(input_file)
% check the SData related inputs and fill up with defaults.
% Copied from the AMIGO_SData.m  05/12/2014 Attila


%Checks for necessary arguments
if nargin<1
    fprintf(1,'\n\n------> ERROR message\n\n');
    fprintf(1,'\t\t AMIGO requires at least one input argument: input file.');
    error('error_gen_001','\t\t Impossible to continue. Stopping.\n');
end


%Reads defaults
[inputs_def]= AMIGO_private_defaults;


[inputs_def]= AMIGO_public_defaults(inputs_def);
%[inputs_def,results_def]= AMIGO_public_defaults(inputs_def);


inputs_def.pathd.runident=inputs_def.pathd.runident;



%Reads inputs
[inputs,results]=AMIGO_check_model(input_file,inputs_def);
%[inputs,results]=AMIGO_check_model(input_file,inputs_def,results_def);

[inputs,results]=AMIGO_check_exps(inputs,results);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_data(inputs);


%DETECTS PATH
AMIGO_path

%Generates matlab file to compute observables
% AMIGO_gen_obs(inputs,results);

%Generates paths for reporting and plots
AMIGO_paths_SD