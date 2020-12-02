function cytoscape_command_file = AMIGO_gen_cytoscape_command_file_for_modelnetwork(networkName,networkFilePath,nodeFilePath,styleFilePath,style)
% write a file containing Cytoscape commands to plot the network.


cytoscape_command_file = strcat(networkName,'_cytoscape_command');
fid = fopen(cytoscape_command_file,'w');



fprintf(fid,'network import file file="%s" indexColumnSourceInteraction=1 indexColumnTargetInteraction=3 indexColumnTypeInteraction=2 firstRowAsColumnNames=false startLoadRow=1\n',networkFilePath);
fprintf(fid,'table import file file="%s" keyColumnIndex=1 firstRowAsColumnNames=true startLoadRow=1\n',nodeFilePath);
fprintf(fid,'vizmap load file file="%s"\n',styleFilePath);
fprintf(fid,'vizmap apply styles = %s\n', style);
fprintf(fid,'layout "force-directed"\n');


fclose(fid);
