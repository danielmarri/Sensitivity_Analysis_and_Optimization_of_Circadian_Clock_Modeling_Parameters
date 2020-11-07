% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_obs.m 2487 2016-02-23 14:01:49Z evabalsa $

function [flag]= AMIGO_gen_obs(inputs,results)

% AMIGO_gen_model: Generates necessary files for ODEs and observables
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
%  AMIGO_gen_obs: Generates a matlab file to compute provided observables     %
%                 from the states                                             %
%                                                                             %
%               Paths will be added at any AMIGO session so as user does not  %
%               need to modify the MATLAB path                                %
%               Note that folders keeping problem results will be created     %
%               under the Results folder (unless otherwise specified)         %
%               All problem related files (inputs, outputs and intermediate   %
%               files) will be kept in such folder.                           %
%*****************************************************************************%
% flag: 0       OK
%      -1       Nonlinear observables' sensitivties could not generated
%                   because Symbolic Math licencing problem 
flag = 0;

% EBC: Generation of paths for dif operative systems


inputs.pathd.problem_folder_path=strcat(inputs.pathd.results_path,filesep,inputs.pathd.results_folder);
if isdir(inputs.pathd.problem_folder_path)==0
    mkdir(strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path));
    addpath([inputs.pathd.AMIGO_path filesep inputs.pathd.problem_folder_path])
end
inputs.pathd.obs_function=strcat('AMIGO_gen_obs_',inputs.pathd.short_name);
inputs.pathd.obs_file=strcat(inputs.pathd.AMIGO_path,filesep,inputs.pathd.problem_folder_path,filesep,inputs.pathd.obs_function,'.m');


%
% Generates MATLAB code with observables supplied by user
%

if inputs.pathd.force_gen_obs
    % by default this is TRUE, i.e. the observables are generated. 
    
    if exist(inputs.pathd.obs_file,'file')
        clear(inputs.pathd.obs_file),delete(inputs.pathd.obs_file)
    end
    
    fid2=fopen(inputs.pathd.obs_file,'w');
    

%    fprintf(fid2,'function ms=%s(y,theta,inputs,iexp)\n',inputs.pathd.obs_function);
    %     fprintf(fid2,' par=inputs.par;\n');
    %     fprintf(fid2,' par(inputs.PEsol.index_theta)=theta(1,1:inputs.n_theta);\n');

    fprintf(fid2,'function ms=%s(y,inputs,par,iexp)\n',inputs.pathd.obs_function);
    if numel(inputs.model.st_names)>0

        for i=1:inputs.model.n_st
            fprintf(fid2,'\t%s=y(:,%u);\n',inputs.model.st_names(i,:),i);
        end
    end
    
    if numel(inputs.model.par_names)>1
        for i=1:inputs.model.n_par
            fprintf(fid2,'\t%s=par(%u);\n',inputs.model.par_names(i,:),i);
        end
    end
    
    

    
    fprintf(fid2,' \n\nswitch iexp');
 
   for iexp=1:inputs.exps.n_exp
        fprintf(fid2,'\n\ncase %i\n',iexp);
        for i=1:size(inputs.exps.obs{iexp},1)
            fprintf(fid2,'%s;\n',inputs.exps.obs{iexp}(i,:));
        end 
   
      
        if numel(inputs.exps.obs_names{iexp})>0

            for iobs=1:inputs.exps.n_obs{iexp}
                fprintf(fid2,'ms(:,%u)=%s;',iobs,inputs.exps.obs_names{iexp}(iobs,:));
            end
        end

   end
    
    fprintf(fid2,'\nend');
    fprintf(fid2,'\n\nreturn');
    fclose(fid2);
    rehash;
    
    if inputs.exps.NLObs
        flag = AMIGO_gen_obs_sens(inputs,results);
        rehash;
    end
end

addpath(inputs.pathd.obs_file)
inputs.pathd.obs_file
return