% $Header: svn://.../trunk/AMIGO_R2012_cvodes/Preprocessor/AMIGO_gen_mex.m 2212 2015-09-28 10:49:54Z evabalsa $
% AMIGO_gen_mex: Generates necessary mex files for fortran solvers
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto, David Henriques                      %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_gen_mex: Generates necessary mex files for fortran solvers           %
%                                                                             %
%                     Generates fcn.f and sens.f from the inputs.model        %
%                     provided by the user                                    %
%                                                                             %
%*****************************************************************************%



fprintf(1,'\n\n------> Mexing files....\n\n');

% GENERATES SOME NECESSARY PATHS, SELECTS UTILITY FILES AND MEXOPTS FILES

AMIGO_path

%eval(sprintf('cd ''%s''',inputs.pathd.AMIGO_path))

flag_vodes=false;



switch inputs.model.input_model_type
    
       
    case {'charmodelC','sbmlmodel'}
        
        inputs.model.sens_file=fullfile(results.pathd.problem_folder_path,'sens.c');
        
    case 'c_model'
        
        inputs.model.odes_file=fullfile(inputs.model.fortranmodel_file,'.c');
        inputs.model.sens_file=fullfile(inputs.model.fortransens_file,'.c');
end

switch inputs.ivpsol.ivpsolver

       
    case 'cvodes'
        
        flag_cvodes=true;
        cvodes_mex_results_dir=fullfile(results.pathd.problem_folder_path,strcat('cvodesg_',results.pathd.short_name));
        createCompileFile_AMIGO_model(inputs.model.odes_file,cvodes_mex_results_dir,inputs.pathd.AMIGO_path,inputs.model.debugmode);
        addpath(results.pathd.problem_folder_path);
        
end


switch inputs.ivpsol.senssolver
    
       
    case 'cvodes'
        
        %No need to compile two times, it is slow enough as it is :)
        if(~flag_cvodes)
            
            cvodes_mex_results_dir=fullfile(results.pathd.problem_folder_path,strcat('cvodesg_',results.pathd.short_name));
            createCompileFile_AMIGO_model(inputs.model.odes_file,cvodes_mex_results_dir,inputs.pathd.AMIGO_path,inputs.model.debugmode);
            addpath(results.pathd.problem_folder_path);
            
        end
        
end
