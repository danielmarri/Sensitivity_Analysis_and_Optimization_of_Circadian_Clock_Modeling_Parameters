% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_model.m 2265 2015-10-07 08:51:30Z attila $
function inputs = AMIGO_gen_model(inputs,results)


% AMIGO_gen_model: Generates necessary files for ODEs and observables
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
%  AMIGO_gen_model: Generates necessary fortran or matlaba files attending to %
%                   the type of model provided by the user                    %
%                                                                             %
%               Paths will be added at any AMIGO session so as user does not  %
%               need to modify the MATLAB path                                %
%               Note that folders keeping problem results will be created     %
%               under the Results folder (unless otherwise specified)         %
%               All problem related files (inputs, outputs and intermediate   %
%               files) will be kept in such folder.                           %
%*****************************************************************************%


switch inputs.model.exe_type
    
    case 'standard'
        
        switch inputs.model.input_model_type
            
            %   CASE 1: A FORTRAN FILE HAS BEEN PROVIDED
            case 'fortranmodel'
                
                %fcn.f and sens.f should be provided with full path
                
                fprintf(1,'\n\n------> Fortran files including system dynamics have been provided.\n\n');
                switch computer
                    
                    case {'PCWIN','GLNX86'}
                        
                        AMIGO_gen_mex
                        
                    case {'GLNX86','GLNXA64','MACI','MACI64'}
                        
                        fprintf(1,'\n----> IMPORTANT!!!: Please note that under WIN or Linux 64bits FORTRAN models can not be used.\n');
                        error('error_PE_001','\t\t Impossible to continue. Stopping.\n');
                end
                
            case 'matlabmodel'
                
                fprintf(1,'\n\n------> MATLAB file including system dynamics has been provided, solving with %s.\n\n',inputs.ivpsol.ivpsolver)
                
            case 'charmodelF'
                
                inputs.model.odes_file=strcat(results.pathd.problem_folder_path,filesep,'fcn.f');
                inputs.model.sens_file=strcat(results.pathd.problem_folder_path,filesep,'sens.f');
                
                switch computer
                    
                    case {'PCWIN','GLNX86','GLNXA64','MACI'}
                        
                        if inputs.model.overwrite_model
                            
                            AMIGO_gen_fortran
                            AMIGO_gen_mex
                            
                        end
                        
                    case{'PCWIN64','MACI64'}
                        
                        fprintf(1,'\n----> IMPORTANT!!!: Please note that under WIN or MAC 64bits FORTRAN models can not be used.\n');
                        error('error_PE_001','\t\t Impossible to continue. Stopping.\n');
                        
                end
                
                
            case 'charmodelM'
                
                inputs.model.matlabmodel_file=strcat('fcn_',results.pathd.short_name);
                inputs.model.odes_file=strcat(results.pathd.problem_folder_path,filesep,inputs.model.matlabmodel_file,'.m');
                
                if inputs.model.overwrite_model
                    AMIGO_gen_matlab
                end
                
                addpath(genpath(results.pathd.problem_folder_path))
                
            case 'sbmlmodelM'
                
                fprintf(1,'\n\n------> A sbml file including system dynamics is being provided.\n\n');
                if exist('TranslateSBML.m')==0
                    fprintf(1,'\n\n------> An error has ocurred, either the SBML toolbox is not installed or it is not in the path.\n\n');
                end
            
                AMIGO_getSBMLdata
                AMIGO_SBMLtoMATLAB(SBMLModel,'fcnm',0,results.pathd.problem_folder_path,inputs.model);
                %AMIGO_SBMLtoMATLAB(model,'sensm',1,results.pathd.problem_folder_path);
                addpath(genpath(results.pathd.problem_folder_path));
                
                
            case 'sbmlmodel'
                
                fprintf(1,'\n\n------> A sbml file including system dynamics is being provided.\n\n');
                if exist('TranslateSBML.m')==0
                    fprintf(1,'\n\n------> An error has ocurred, either the SBML toolbox is not installed or it is not in the path.\n\n');
                end
            
                AMIGO_getSBMLdata
                inputs.model.eqns=AMIGO_SBMLtoC(SBMLModel,'amigoRHS',0,results.pathd.problem_folder_path,inputs.model);
            
                if(isempty(inputs.model.odes_file))
                    inputs.model.odes_file=strcat(results.pathd.problem_folder_path,filesep,'amigoRHS.c');
                end
                
          
                     
                if inputs.model.overwrite_model
                    AMIGO_gen_C
                end
                 inputs.ivpsol.ivpsolver='cvodes';
                 inputs.ivpsol.senssolver='cvodes';
                AMIGO_gen_mex
                addpath(genpath(results.pathd.problem_folder_path));  
                
                                
            case 'charmodelC'
                
                if(isempty(inputs.model.odes_file))
                    inputs.model.odes_file=strcat(results.pathd.problem_folder_path,filesep,'amigoRHS.c');
                end
                
                if inputs.model.overwrite_model
                    AMIGO_gen_C
                end
                
                AMIGO_gen_mex
                addpath(genpath(results.pathd.problem_folder_path));
                
                
            case 'blackboxmodel'
                
                fprintf(1,'\n\n------> A balck box file including model simulation is being provided.\n\n');
                
        end
        
        
    case {'costMex','fullMex'}
        
        switch inputs.model.input_model_type
            
            case 'charmodelC'
                
                if ~isempty(inputs.model.eqns) && inputs.model.overwrite_model
                    AMIGO_gen_C
                end
                
                mexAMIGOinterface(...
                    inputs.model.odes_file,...
                    inputs.model.mexfile,...
                    inputs.model.use_user_obs,...
                    inputs.model.use_user_sens_obs,...
                    false...
                    );
                
                addpath(results.pathd.problem_folder_path);
                
            otherwise
                error('costMex or fullMex can only handle models of type charmodelC');
        end
        
    case 'fullC'
        
        switch inputs.model.input_model_type
            
            case 'charmodelC'
                
                if ~isempty(inputs.model.eqns) && inputs.model.overwrite_model
                    AMIGO_gen_C
                end
                
                gcc_command=mexAMIGOinterface(...
                    inputs.model.odes_file,...
                    regexprep(inputs.model.odes_file,'.c',''),...
                    inputs.model.use_user_obs,...
                    inputs.model.use_user_sens_obs,...
                    true...
                    );
                
                inputs.model.comp_fullC=gcc_command;
                fid = fopen(inputs.model.odes_file,'r');
                text_model=fread(fid,'*char');
                fclose(fid);
                
                fid = fopen(fullfile(inputs.pathd.AMIGO_path,'Kernel','libAMIGO','src','src_fullC','fullC.c'),'r');
                text_main=fread(fid,'*char');
                fclose(fid);
                
                fid = fopen(inputs.model.odes_file,'w+');
                
                switch computer
                    case 'PCWIN'
                        inputs.model.comp_fullC=sprintf('/*\nTo compile, use the following command:\n%s\nMake sure that gcc is installed and AMIGO_folder/Kernel/libAMIGO/lib_win32/vs is in your path so that shared library can be loaded.\n*/',gcc_command);
                        fprintf(fid,'/*\nTo compile, use the following command:\n%s\nMake sure that gcc is installed and AMIGO_folder/Kernel/libAMIGO/lib_win32/vs is in your path so that shared library can be loaded.\n*/',gcc_command);
                    otherwise
                        inputs.model.comp_fullC=sprintf('/*\nTo compile, use the following command:\n%s\nMake sure that gcc is installed.\n*/',gcc_command);
                        fprintf(fid,'/*\nTo compile, use the following command:\n%s\nMake sure that gcc.\n*/',gcc_command);
                end
                
                
                fprintf(fid,'%s',text_main);
                
                fprintf(fid,'%s',text_model);
                
                fclose(fid);
                
            otherwise
                
                error('AMIGO_gen_model: fullC can only handle models of type charmodelC');
        end
        
end

return