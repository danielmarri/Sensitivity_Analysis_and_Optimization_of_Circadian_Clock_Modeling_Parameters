function AMIGO_linux_macOS_build ()
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% AMIGO_linux_macOS_build code development:     David Henriques               %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************

AMIGO_Startup;
AMIGO_path;
fclose all;
initial_dir=cd;
switch computer

    case 'GLNX86'
        
        matlab_path=['MATLAB_PATH=' matlabroot];
        matlab_lib_path=['MATLAB_LIB=' fullfile(matlabroot,'bin','glnx86')];
        AMIGO_libs='AMIGO_LIBS=lib_linux64';
        
        fprintf(1,'----> If you want to use FORTRAN models in LINUX you need to install g95 compiler.\n');
        fprintf(1,'      Please follow instructions in the AMIGO installation guide.\n');
        
    case  'GLNXA64'

        matlab_path=['MATLAB_PATH=' matlabroot];
        matlab_lib_path=['MATLAB_LIB=' fullfile(matlabroot,'bin','glnxa64')];
        AMIGO_libs='AMIGO_LIBS=lib_linux64';
        
        fprintf(1,'----> If you want to use FORTRAN models in LINUX you need to install g95 compiler.\n');
        fprintf(1,'      Please follow instructions in the AMIGO installation guide.\n');

    case {'MACI64'}
        
        matlab_path=['MATLAB_PATH=' matlabroot];
        matlab_lib_path=['MATLAB_LIB=' fullfile(matlabroot,'bin','maci64')];
        AMIGO_libs=['AMIGO_LIBS=' fullfile('lib_mac64')];
        
        fprintf(1,'----> IMPORTANT!!!: Please note that under WIN or MAC 64bits FORTRAN models can not be used.\n');
    

    case 'PCWIN'
        
        matlab_path=['MATLAB_PATH=' matlabroot];
        matlab_lib_path=['MATLAB_LIB=' fullfile(matlabroot,'bin','win32')];
        AMIGO_libs=['AMIGO_LIBS=' fullfile('lib_win32','vs')];
        
        warning('OS does not need installation');
        
    otherwise

end

cd(fullfile(pwd,'Kernel','libAMIGO','lib_linux64'));
!chmod +x installf2c.sh
!./installf2c.sh

cd ..;

setenv('MATLAB_PATH',matlabroot);

switch computer
    case 'MACI64'
        setenv('CC','/usr/local/bin/gcc');
    otherwise
        setenv('CC','gcc');
end



!make clean
!make libAMIGO.a
!make libmxInterface.a

cd(initial_dir);

end


