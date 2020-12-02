% AMIGO_path: Detects the path of the current version of AMIGO
%
%**************************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    %  and control in systems biology %
% Current release:      R2016a                                                        %
% Date of release:      April 2016                                                    %
% Code development:     Eva Balsa-Canto, David Henriques, Attila Gabor                %
% Address:              Process Engineering Group, IIM-CSIC                           %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                        %
% e-mail:               ebalsa@iim.csic.es                                            %
% Copyright:            CSIC, Spanish National Research Council                       %
%**************************************************************************************
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_path:  Detects the path of the current version of AMIGO              % 
%                                                                             %
%*****************************************************************************%

amigoversion='AMIGO2_R2019b';
amigodir=what(amigoversion);

if(length(amigodir)<1)
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO_path: The amigo version %s could be found.\n\n',amigoversion);
    cprintf('red','\t\t Please modify amigoversion in line 20 - AMIGO_path.\n\n',amigoversion);
    return;
   
end

if(length(amigodir)>1)
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO_path: You have multpile amigo_versions in your path, clear you path to avoid problems.\n\n');
    return;
    
end

inputs.pathd.AMIGO_path=amigodir.path;