function AMIGO_ShowNetwork(input_file)
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% AMIGO_ShowNetwork code development:     Attila Gábor                        %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************


% show the network in Cytoscape.

%Checks for necessary arguments
if nargin<1
    cprintf('*red','\n\n------> ERROR message\n\n');
    cprintf('red','\t\t AMIGO requires at least one input argument: input file.\n\n');
    return;
end
%% General AMIGO checks of the model
%Reads defaults
[inputs_def]= AMIGO_private_defaults;
[inputs_def]= AMIGO_public_defaults(inputs_def);
%Reads inputs
[inputs,results]=AMIGO_check_model(input_file,inputs_def);

AMIGO_path
inputs.pathd.problem_folder_path=fullfile(inputs.pathd.AMIGO_path,inputs.pathd.results_path,inputs.pathd.results_folder);


%% ShowNetwork related checks
% check model format
switch inputs.model.input_model_type
	case {'charmodelC','charmodelF','charmodelM'}
		% further checks
	otherwise %{blackbox, etc}
		fprintf('\n---->ERROR:\n')
		fprintf('\t\tinputs.model.input_model_type = ''%s'' was detected\n',inputs.model.input_model_type)
		fprintf('\t\tNetwork visualization requires charmodel{C,F,M} for symbolic processing.\n\n')
		return
end

% Check architecture
switch computer
    case {'PCWIN','PCWIN64'}
    otherwise
        fprintf('\n\tWARNING: Network visualization is available for Windows machines. This feature was not tested on LINUX.\n\n')
        return
end

% Check Symbolic Toolbox
if license('test','symbolic_toolbox')
    v = ver('Symbolic');
    
    if str2double(v.Version(1)) < 4
        fprintf('--> WARNING: Network visualization requires version(Symbolic Toolbox) >= 4.0.\n')
        return
    end
else
    fprintf('--> WARNING: Network visualization requires Symbolic Toolbox 4.0 or newer\n');
    return
end


%%  try to locate cytoscape

cytoscapePath = locateCytoscape(inputs.pathd.AMIGO_path);
if isempty(cytoscapePath)
    fprintf('--> ERROR:\n\t\tCytoscape could not be found. Please download Cytoscape for network visualization (<a href="matlab: web(''http://www.cytoscape.org/'', ''-browser'')">http://www.cytoscape.org/</a>) \n\n')
    return
end



% write the model to network and edge files
network_name = fullfile(inputs.pathd.problem_folder_path,[inputs.pathd.short_name]);
[networkFilePath nodeFilePath]= AMIGO_network2Cytoscape(inputs,network_name);


%% create cytoscape command scripts

% select style file and style
styleFilePath = fullfile(inputs.pathd.AMIGO_path, 'Kernel','NetworkVisualization','AMIGO_Cytoscape_styleFile.xml');
style = 'NetworkStructure_parID';

% create the cytoscape command script
cytoscape_command_file =AMIGO_gen_cytoscape_command_file_for_modelnetwork(network_name,networkFilePath,nodeFilePath,styleFilePath,style);




system(['"' cytoscapePath '"'  ' -S ' '"' cytoscape_command_file '" &' ]);







