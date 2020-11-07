% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_paths_Structs.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_paths_Structs: Generates and adds necessary paths for Structs
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
%  AMIGO_paths_PE: Generates and adds necessary paths for reports and plots   % 
%                                                                             %
%*****************************************************************************%

inputs.pathd.input_file_path=which(input_file);
           
inputs.pathd.structs_path=strcat(inputs.pathd.input_file_path,'at');



           

    