function [results]=AMIGO_GRank(input_file,run_ident,grank_method);
% AMIGO_GRank: computes global ranking of model unknowns
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_GRank: - Computes local sensitivities for a sample of values of model %
%                unknowns. Sampling is performed by using the Latin Hipercube %
%                sampling method within the bounds defined for the unknowns   %
%              - Computes overall (for all experimental schemes and           %
%                observables) ranking of global unknowns (experiment          %
%                independent parameters and initial conditions                %
%              - Plots/Reports overall global ranking of global unknowns      %
%              - Plots bars and 2D figures of global sensitivities for all    %
%                observables and all experiments for global and local unknowns%
%                                                                             %
%               > usage:  AMIGO_GRank('input_file',options)                   %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                         different runs, this avoids overwriting             %
%                                                                             %
%               > usage examples:  AMIGO_GRank('NFKB_rank')                   %
%                                  AMIGO_GRank('NFKB_rank','r1')              %
%                                  AMIGO_GRank('NFKB_rank','r2')              %
%                                                                             %
%*****************************************************************************%
% EBC (17-April-2012) THIS SCRIPT HAS BEEN MODIFIED TO ALLOW FOR THE USE OF   %
% OTHER GLOBAL SENSITIVITY ANALYSIS METHODS:                                  %
%       LATIN HYPERCUBE SAMPLING (ORIGINALLY INCLUDED)                        %
%       SOBOL, CONTRIBUTED BY GROUP ALAIN VANDE WOUWER                        %
%       RANDOM BALANCE DESIGN, RBD,CONTRIBUTED BY GROUP ALAIN VANDE WOUWER    %
%       ELEMENTARY EFFECTS METHDOD, EEM, CONTRIBUTED BY GROUP ALAIN VANDE     %
%       WOUWER                                                                %
%*****************************************************************************%
% $Header: svn://.../trunk/AMIGO2R2016/AMIGO_GRank.m 2305 2015-11-25 08:20:26Z evabalsa $
close all;

%Checks for necessary arguments
if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end



%AMIGO_PE header
AMIGO_report_header

%Starts Check of inputs
fprintf(1,'\n\n------>Checking inputs....\n');

%Reads defaults
[inputs_def]= AMIGO_private_defaults;

%[inputs_def, results_def]= AMIGO_public_defaults(inputs_def);
[inputs_def]= AMIGO_public_defaults(inputs_def);
%
%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
end

%Reads inputs
[inputs,results]=AMIGO_check_model(input_file,inputs_def); %,results_def
[inputs]=AMIGO_check_exps(inputs);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_sampling(inputs);
[inputs]= AMIGO_check_theta(inputs);
[inputs]= AMIGO_check_theta_bounds(inputs);

if nargin>2
    [inputs]=AMIGO_check_GRankmethod(inputs,grank_method);
else
    [inputs]=AMIGO_check_GRankmethod(inputs,inputs.PEsol.GRankmethod);
end

%DETECTS PATH
AMIGO_path

%Generates matlab file to compute observables
AMIGO_gen_obs(inputs,results);


%Creates necessary paths
AMIGO_paths_GR
AMIGO_init_report(inputs.pathd.report,inputs.pathd.problem_folder_path,inputs.pathd.task_folder)


%Memory allocation and some necesary assignements

privstruct=inputs.exps;
AMIGO_init_PE_guess_bounds

switch inputs.model.exe_type
    
    case 'standard'
        
    otherwise
        
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO_GRank: Global Ranking of the parameter can only be computed for standard execution mode.\n\n');
    return;
      
end

%********************************************************************************************************
%Computes global rank by using the Latin Hypercube sampling method

fprintf(1,'\n\n------>Global Ranking of parameters, this may take some time\n\n');

switch inputs.PEsol.GRankmethod
    
    % LATIN HYPERCUBE SAMPLING
    case 'lhs'
        [results,privstruct]=AMIGO_GRank_LHS(inputs,results,privstruct);
        fprintf(1,'\n\n>>> Global Ranking calculated over %u different vectors of parameters\n\n',results.rank.n_global_samples);
        fprintf(1,'\n\n------>Plotting results....\n\n')
        % Plots and saves results
        [results]=AMIGO_post_report_GR(inputs,results);
        switch inputs.plotd.plotlevel
            case {'full','medium','min'}
                AMIGO_post_plot_GR(inputs,results,privstruct);
            otherwise
                fprintf(1,'\n------>No plots are being generated, since inputs.plotd.plotlevel=''noplot''.\n');
                fprintf(1,'         Change inputs.plotd.plotlevel to ''full'',''medium'' or ''min'' to obtain authomatic plots.\n');
        end
        
        % SOBOL METHOD
    case 'sobol'
        
        
        % RANDOM BALANCE DESIGN
    case 'rbd'
        
        
        % ELEMENTARY EFFECTS METHODS
        
    case 'eem'
        
        
end    % switch inputs.PEsol.GRankmethod




%********************************************************************************************************
%
% SAVES STRUCTURE WITH USEFUL DATA
%


AMIGO_del_GR
results.pathd=inputs.pathd;
results.plotd=inputs.plotd;
save(inputs.pathd.struct_results,'inputs','results');
cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
if nargout<1
    clear;
end
return