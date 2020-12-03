% $Header: svn://.../trunk/AMIGO2R2016/Kernel/IVP_solvers/cvodes/C_src4Amigo/createCompileFile_AMIGO_model.m 2395 2015-12-04 02:32:57Z davidh $
%$Id: createCompileFile.m 1393 2012-01-30 15:23:05Z davidh $
function createCompileFile_AMIGO_model(input_file,output_file,path_amigo,debugmode)

flags='';

switch computer
    
    case 'PCWIN'
        
        lapacklib_file = 'libmwlapack.lib';
        lapacklib_dir = fullfile(matlabroot, ...
            'extern', 'lib', 'win32', 'microsoft');
        lapacklib = fullfile(matlabroot, ...
            'extern', 'lib', 'win32', 'microsoft','libmwlapack.lib');
        blaslib = fullfile(matlabroot, ...
            'extern', 'lib', 'win32', 'microsoft', 'libmwblas.lib');
        
        libutlib = 'libut';
        
    case 'PCWIN64'
        
        lapacklib_file = 'libmwlapack.lib';
        lapacklib_dir = fullfile(matlabroot, ...
            'extern', 'lib', 'win64', 'microsoft');
        lapacklib = fullfile(matlabroot, ...
            'extern', 'lib', 'win64', 'microsoft','libmwlapack.lib');
        blaslib = fullfile(matlabroot, ...
            'extern', 'lib', 'win64', 'microsoft', 'libmwblas.lib');
        libutlib = 'libut';
        
    otherwise

        blaslib= '-lmwblas';
        lapacklib= '-lmwlapack';
        flags='';
        
end

mex_list={};
counter=0;


counter=counter+1;
mex_list{counter}=input_file;

current_folder=fullfile(path_amigo,'Kernel','IVP_solvers','cvodes','C_src4Amigo','src','src_amigo');
folders=dir(current_folder);
for i=1:length(folders)
    temp_name=folders(i).name;
    if(any(regexp(temp_name,'\.c')))
        counter=counter+1;
        mex_list{counter}=fullfile(current_folder,temp_name);
    end
end


current_folder=fullfile(path_amigo,'Kernel','IVP_solvers','cvodes','C_src4Amigo','src','src_interface');
folders=dir(current_folder);
for i=1:length(folders)
    temp_name=folders(i).name;
    if(any(regexp(temp_name,'\.c')))
        counter=counter+1;
        mex_list{counter}=fullfile(current_folder,temp_name);
    end
end

current_folder=fullfile(path_amigo,'Kernel','IVP_solvers','cvodes','C_src4Amigo','src','src_cvodes');
folders=dir(current_folder);
for i=1:length(folders)
    temp_name=folders(i).name;
    if(any(regexp(temp_name,'\.c')))
        counter=counter+1;
        mex_list{counter}=fullfile(current_folder,temp_name);
    end
end

if debugmode
	flags  = ['-g -v' flags];
end

str='';
include_folder=fullfile(path_amigo,'Kernel','IVP_solvers','cvodes','C_src4Amigo','include');

%if (strcmp(version('-release'),'2017b'))
 ver=version('-release');
  if (str2num(ver(1:4))>=2017) % versions from 2017 and up
  if(strcmp(computer,'PCWIN'))
        str=sprintf('mex -compatibleArrayDims %s -I%s -I%s -L%s -L%s -lmwblas -lmwlapack -l%s...\n',flags,fullfile(include_folder,'include_amigo'),fullfile(include_folder,'include_cvodes'),fullfile(matlabroot,'bin','win32'),lapacklib_dir,libutlib);

    elseif (strcmp(computer,'PCWIN64'))

        str=sprintf('mex -compatibleArrayDims %s -I%s -I%s -lmwblas -lmwlapack -l%s...\n',flags,fullfile(include_folder,'include_amigo'),fullfile(include_folder,'include_cvodes'),libutlib);

    else

        str=sprintf('mex -compatibleArrayDims %s -I%s -I%s -lmwblas -lmwlapack ...\n',flags,fullfile(include_folder,'include_amigo'),fullfile(include_folder,'include_cvodes'));
      
    end
else
    if(strcmp(computer,'PCWIN'))
        str=sprintf('mex %s -I%s -I%s -L%s -L%s -lmwblas -lmwlapack -l%s...\n',flags,fullfile(include_folder,'include_amigo'),fullfile(include_folder,'include_cvodes'),fullfile(matlabroot,'bin','win32'),lapacklib_dir,libutlib);

    elseif (strcmp(computer,'PCWIN64'))

        str=sprintf('mex %s -I%s -I%s -lmwblas -lmwlapack -l%s...\n',flags,fullfile(include_folder,'include_amigo'),fullfile(include_folder,'include_cvodes'),libutlib);

    else

        str=sprintf('mex %s -I%s -I%s -lmwblas -lmwlapack ...\n',flags,fullfile(include_folder,'include_amigo'),fullfile(include_folder,'include_cvodes'));
      
    end
end


str=[str sprintf('%s',sprintf('-output %s...\n',output_file))];

for i=1:length(mex_list)-1
    str=[str sprintf('%s ...\n',mex_list{i})];
end

str=[str sprintf('%s ;\n',mex_list{end})];

eval(str);

end
