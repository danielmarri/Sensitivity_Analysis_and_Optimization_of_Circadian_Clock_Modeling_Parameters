% $Header: svn://.../trunk/AMIGO2R2016/Kernel/libAMIGO/mexAMIGOinterface.m 2468 2015-12-16 15:50:23Z attila $
%$Id: createCompileFile.m 1393 2012-01-30 15:23:05Z davidh $
function str= mexAMIGOinterface(input_file,output_file,use_obs,use_obs_sens,make)

lib_paths={};
include_folders={};
libs={};
src_files={};
flags={};
additional='';

src_dir=which('mexAMIGOinterface');
src_dir=regexprep(src_dir,'mexAMIGOinterface.m','');

switch computer
    
    case 'PCWIN'
        
        lib_paths{end+1}=fullfile(src_dir,'lib_win32');
        lib_paths{end+1}=fullfile(matlabroot,'bin','win32');
        libs{end+1}='sharedAMIGO';

    case 'PCWIN64'
        
        lib_paths{end+1}=fullfile(src_dir,'lib_win64');
        lib_paths{end+1}=fullfile(matlabroot,'bin','win64');
        libs{end+1}='sharedAMIGO';

    case 'MACI64'
        
        lib_paths{end+1}=fullfile(src_dir,'lib_linux64');
        libs{end+1}='mxInterface';
        libs{end+1}='AMIGO';
        libs{end+1}='f2c';
        libs{end+1}='gomp';
        libs{end+1}='mwblas';
        libs{end+1}='mwlapack';
        
        
    case 'GLNXA64'
        
        lib_paths{end+1}=fullfile(src_dir,'lib_linux64');
        lib_paths{end+1}=fullfile(matlabroot,'bin','glnxa64');
        libs{end+1}='mxInterface';
        libs{end+1}='AMIGO';
        libs{end+1}='f2c';
        libs{end+1}='gomp';
        libs{end+1}='mwblas';
        libs{end+1}='mwlapack';
        
    case 'GLNX86'
        
        lib_paths{end+1}=fullfile(src_dir,'lib_linux64');
        lib_paths{end+1}=fullfile(matlabroot,'bin','glnx86');
        libs{end+1}='mxInterface';
        libs{end+1}='AMIGO';
        libs{end+1}='f2c';
        libs{end+1}='mwblas';
        libs{end+1}='mwlapack';
        
        
    otherwise
        
        error('Not supported Yet');
end

include_folders{end+1}= fullfile(src_dir,'include','include_amigo');
include_folders{end+1}= fullfile(src_dir,'include','include_nl2sol');
include_folders{end+1}= fullfile(src_dir,'include','include_mxInterface');
include_folders{end+1}= fullfile(src_dir,'include','include_cvodes');
include_folders{end+1}= fullfile(src_dir,'include','include_f2c');
include_folders{end+1}= fullfile(src_dir,'include','include_de');
include_folders{end+1}= fullfile(src_dir,'include','include_SRES');

counter=0;
src_files{end+1}=input_file;
src_files{end+1}=fullfile(src_dir,'src','src_mxInterface','amigo_mexFunction.c');

extras='';

switch make
    
    case false

      	 switch computer
	
	case {'GLNX','GLNXA64','MACI64'}
		str=sprintf('mex %s -DIMPORT -output %s ...\n',additional',output_file);
	otherwise
      		str=sprintf('mex %s -DIMPORT -output %s ...\n',additional',output_file);
        end

        for i=1:length(include_folders)
            if(i==1)
                str=[str sprintf('-I"%s"... \n',include_folders{i})];
            else
                str=[str sprintf('-I"%s"... \n',include_folders{i})];
            end
        end
        
        for i=1:length(lib_paths)
            str=[str sprintf('-L"%s"... \n',lib_paths{i})];
        end
        
        for i=1:length(libs)
            str=[str sprintf('-l%s... \n',libs{i})];
        end
        
        for i=1:length(flags)
            str=[str sprintf('-D%s... \n',flags{i})];
        end
        
        for i=1:length(src_files)
            str=[str sprintf('"%s"... \n',src_files{i})];
        end
        str
        eval(str);
        
    case true
        
        libs{end+1}='m';
        libs{end+1}='mx';
        libs{end+1}='mat';
        libs{end+1}='mex';
        
        
        switch computer
            
            case 'PCWIN'
                
                extras=sprintf('-o %s','main.exe');
                
            case 'PCWIN64'
                
                extras=sprintf('-m64 -o %s','main.exe');
                
            case 'MACI64'
                
                extras=' -Wl,-rpath,';
                extras=[extras fullfile(matlabroot,'bin','maci64')];
                extras=[extras ' -lmex' ' -lmat' ' -lmx ' ' -lmwblas ' ' -lmwlapack '];
                extras=[extras sprintf('-o %s','main')];
                
            case 'GLNXA64'
                
                extras=' -Wl,-rpath,';
                extras=[extras fullfile(matlabroot,'bin','glnxa64')];
                extras=[extras ' -fopenmp -O2 -fPIC '];
                extras=[extras sprintf('-o %s','main')];
                
            case'GLNX86'
                
                extras=' -Wl,-rpath,';
                extras=[extras fullfile(matlabroot,'bin','glnx86')];
                extras=[extras ' -fopenmp  -O2 -fPIC '];
                extras=[extras sprintf('-o %s','main')];
                
            otherwise
                
                warning('Warning for mexAMIGOinterface: The fullC feature is under development for versions other than windows matlab 32-bits and mac');
        end
        
        str=sprintf('gcc -w  %s ',input_file);
        
        for i=1:length(include_folders)
            if(i==1)
                str=[str sprintf('-I%s ',include_folders{i})];
            else
                str=[str sprintf('-I%s ',include_folders{i})];
            end
        end
        
        str=[str sprintf('-I%s ',fullfile(matlabroot,'extern','include'))];
        
        for i=1:length(lib_paths)
            str=[str sprintf('-L%s ',lib_paths{i})];
        end
        
        for i=1:length(libs)
            str=[str sprintf('-l%s ',libs{i})];
        end
        str=[str extras];

    otherwise
        
        error('mexAMIGOInterface: execution mode not recognized');
end

end
