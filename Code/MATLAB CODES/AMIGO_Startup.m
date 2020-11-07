% AMIGO_Startup: Adds AMIGO paths to current MATLAB session and generates
%                necessary files for mexing
%
%******************************************************************************
% AMIGO Advanced Model Identification using Global Optimization               %
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_Startup: Adds AMIGO paths to current MATLAB session                  %
%                                                                             %
%*****************************************************************************%
% $Header: svn://172.19.32.13/trunk/AMIGO2R2016/AMIGO_Startup.m 2486 2016-02-18 11:21:26Z davidh $

% ADDS PATHS TO CURRENT MATLAB SESSION

fprintf(1,'\n----> Adding paths to current MATLAB session....\n');

AMIGO_path;

% DETECTS MALTLAB VERSION
matlab_version = ver('matlab');

% ADDS to current path
% addpath(genpath(inputs.pathd.AMIGO_path));
% add some folders to the path:
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'add_DynamicOpt')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'add_InverseOptimalControl')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'GUI')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'Examples')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'Inputs')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'Release_Info')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'Postprocessor')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'Preprocessor')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'Kernel')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'add_Regularization')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'tests')));
addpath(genpath(fullfile(inputs.pathd.AMIGO_path,'Help')));
addpath(inputs.pathd.AMIGO_path);

% DETECTS OPERATING SYSTEM & GENERATES MEX OPTIONS FILES

fprintf(1,'\n----> To use C models run mex -setup and choose a valid compiler. Alternatively use GNUMEX.\n');


switch computer
    
    case {'PCWIN'}
        
        AMIGO_path;
        my_amigo_path=amigodir.path;
        setenv('PATH', [getenv('PATH') ';' fullfile(my_amigo_path,'Kernel','libAMIGO','lib_win32','vs')]);
        
    case 'PCWIN64'
        
        AMIGO_path;
        my_amigo_path=amigodir.path;
        setenv('PATH', [getenv('PATH') ';' fullfile(my_amigo_path,'Kernel','libAMIGO','lib_win64')]);
        
    case 'MACI64'
        AMIGO_path;
        my_amigo_path=amigodir.path;
        %setenv('DYLD_LIBRARY_PATH', ['/usr/local/lib:' getenv('DYLD_LIBRARY_PATH')]);
        %setenv('DYLD_LIBRARY_PATH', '/usr/local/gfortran/lib/');
        
        %!export DYLD_LIBRARY_PATH
end

if  ~isempty(strfind(amigodir.path,' '))
    fprintf(2,'WARNING:\n\n\t\tYour AMIGO was installed in the path: %s\n\t\tThe path contains whitespace character, which can lead to errors using  C compilers.\n\t\tWe highly recommend to relocate AMIGO.\n',matlabroot)
end

fprintf(1,'\n----> Startup finished....\n');
clear amigodir  current_dir  fid matlab_version  mexoptsbatpath  path_matlab
clear dll_mex  inputs  mexoptsbatfile  my_amigo_path   toolbox_path
