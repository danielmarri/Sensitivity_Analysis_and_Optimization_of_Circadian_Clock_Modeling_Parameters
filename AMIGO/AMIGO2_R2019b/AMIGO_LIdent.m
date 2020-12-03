function  results=AMIGO_LIdent(input_file,results)
% AMIGO_LIdent: identifies the correlated groups of parameters
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
% AMIGO_LIdent: - Based on the AMIGO_FIM computes the clustering of the
%                   covariance matrix of the parameters.
%
%                                                                             %
%               > usage:  AMIGO_LIdent('input_file',options)                   %
%                                                                             %
%               > options: 'run_identifier' to keep different folders for     %
%                         different runs, this avoids overwriting             %
%                                                                             %
%               > usage examples:                                             %
%                                                                             %
%*****************************************************************************%
% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/AMIGO_LRank.m 847 2013-09-01 10:15:33Z davidh $

%Checks for necessary arguments
if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end

%Reads defaults
[inputs_def]= AMIGO_private_defaults;

[inputs_def]= AMIGO_public_defaults(inputs_def);

%Checks for optional arguments
if nargin>1
    inputs_def.pathd.runident_cl=run_ident;
    inputs_def.pathd.runident=run_ident;
else
    %results_def.pathd.runident_cl=results_def.pathd.runident;
    inputs_def.pathd.runident=inputs_def.pathd.runident;
end


%Checks for optional arguments

[inputs,results]=AMIGO_check_model(input_file,inputs_def);
[inputs,results]=AMIGO_check_exps(inputs,results);
[inputs]=AMIGO_check_obs(inputs);
[inputs]=AMIGO_check_data(inputs);
inputs = AMIGO_check_Q(inputs);
[inputs]= AMIGO_check_theta(inputs);
[inputs]= AMIGO_check_theta_bounds(inputs);
[inputs]=AMIGO_check_nlp_options(inputs);
AMIGO_set_theta_index
[results inputs] = AMIGO_FIM(input_file);

g_corr_mat = results.fit.g_corr_mat;
g_corr_mat = results.fit.g_FIM;
% g_corr_mat = results.fit.Rjac;


par_names= strvcat(inputs.model.par_names(inputs.PEsol.index_global_theta,:),inputs.model.st_names(inputs.PEsol.index_global_theta_y0,:));
n_par=size(par_names,1);

% Bioinformatics toolbox:
if license('test','bioinformatics_toolbox')
    gco2 = clustergram(abs(g_corr_mat),'Standardize',2,'Linkage','Average','RowPDist', ...
        'Euclidean','ColumnPDist','Euclidean','Cluster',2,'OptimalLeafOrder', 1,'Colormap','hot');
    set(gco2,'ColumnLabels',cellstr(par_names))
    %set(gco2,'RowLabels',cellstr(par_names))
    
else
    fprintf('--> Bioinformatics toolbox license is not detected. Part of the analysis is skipped.\n');
end

% Statistics toolbox:
if license('test','statistics_toolbox')
    fprintf('\n\n**********************************************************\n')
    fprintf('*** Local identifiability analysis based on clustering ***\n')
    fprintf('**********************************************************\n\n')
    fprintf('The parameters are grouped into clusters based on their pair-correlations.\n');
    
    % construct the cluster tree for the correlations
    Z = linkage(abs(g_corr_mat'),'average','euclidean');
    % the parameters with less distance will be sorted to the same goup
    % hint: keep the value reasonably low.
    cutoff = 1.0;
    
    % for the groups based on the distance:
    par_groups = cluster(Z,'cutoff',cutoff,'criterion','distance');
    n_groups = max(par_groups);
    
    % Plot figures
    
    figure('Name','Grouped parameters based on correlation (dend.)')
    drawall = 0; % draw all the parameters to the dendrogram
    [H] = dendrogram(Z,drawall,'orientation','left','labels',par_names,'colorthreshold',0.5);
    set(H,'LineWidth',2);
    title('Parametric correlation based on hierarchical clustering')
    xlabel('Distance of the (goup of) parameters')
    
    
    % Report to the user
    
    n_real_groups = 0;  % the number of groups that contains more than 1 parameters
    n_independent_parameters = 0;
    independent_parameter_index = [];
    par_index = 1:n_par;
    for i = 1 : n_groups
        gi_pname = par_names(par_groups==i,:);  % parameters name in group(i)
        gi_pindex = par_index(par_groups==i); % parameter index in group i
        
        groupi_npar = size(gi_pname,1);     % number of parameters in group(i)
        
        if groupi_npar > 1
            n_real_groups = n_real_groups + 1;
            fprintf('Group %d\n',n_real_groups);
            for j = 1:groupi_npar
                fprintf('\tpar(%2d) %s\n',gi_pindex(j),gi_pname(j,:));
            end
            fprintf('\n');
        else
            n_independent_parameters = n_independent_parameters +1;
            independent_parameters(n_independent_parameters,:) = gi_pname;
            independent_parameter_index = [independent_parameter_index gi_pindex];
        end
        
    end
    fprintf('Independent parameters\n')
    for j = 1:n_independent_parameters
        fprintf('\tpar(%2d) %s\n',independent_parameter_index(j), independent_parameters(j,:));
    end
    
else
    fprintf('--> Statistics toolbox license is not detected. Part of the analysis is skipped.\n');
end


%**************************************************************************
% SAVES STRUCTURE WITH USEFUL DATA

%AMIGO_del_LR

save(inputs.pathd.struct_results,'inputs','results');

cprintf('*blue','\n\n------>Results (report and struct_results.mat) and plots were kept in the directory:\n\n\t\t');
cprintf('*blue','%s', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder]);
fprintf(1,'\n\n\t\tClick <a href="matlab: cd(''%s'')">here</a> to go to the results folder or <a href="matlab: load(''%s'')">here</a> to load the results.\n', [inputs.pathd.AMIGO_path filesep inputs.pathd.task_folder],inputs.pathd.struct_results);
if nargout<1
    clear;
end

end