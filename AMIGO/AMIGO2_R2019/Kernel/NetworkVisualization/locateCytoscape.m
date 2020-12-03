function path = locateCytoscape(AMIGO_path)
% Find cytoscape in the system

% check if we saved the path to cytoscape
cytoscape_path_file = fullfile(AMIGO_path,'Kernel','NetworkVisualization','cytoscape_path');

if exist(cytoscape_path_file,'file')
    % read cytoscape path from the file
    fid = fopen(cytoscape_path_file,'r');
    path_str  = fgetl(fid);
    fclose(fid);
    if exist(path_str,'file')
        path = path_str;
        return;
    end
end
    
    


% try to find in Program Files

CS64 = dir('C:\Program Files\Cytoscape*');
CS32 = dir('C:\Program Files (x86)\Cytoscape*');




if ~isempty(CS64)
    path = fullfile('C:\Program Files\', CS64.name,'Cytoscape.exe');
    
elseif ~isempty(CS32)
    path = fullfile('C:\Program Files (x86)\', CS32.name,'Cytoscape.exe');
    
else
    fprintf(2, 'WARNING:\n\n\t\tWe could not locate CytoScape on your machine.\n')
    [FileName,PathName] = uigetfile('.exe','Please locate CytosCape','Cytoscape.exe');
    if FileName == 0
        path = [];
        return;
    else
        path = fullfile(PathName,FileName);
    end
end

% save path for later use.
fid = fopen(cytoscape_path_file,'w');
fprintf(fid,regexprep(path,'\\','\\\\'));
fclose(fid);

