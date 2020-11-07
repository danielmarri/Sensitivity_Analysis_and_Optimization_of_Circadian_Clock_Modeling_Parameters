function [id_param id_subset id_variables id_param_FilePath]= AMIGO_identifiable_subset2cytoscape(Rjac,variables,fname,CI_threshold)
% determines a largest set of non-collinear parameters and exports to a
% text file for Cytoscape. 


% determine the largest non-collinear set:
% CI_threshold = 30;
id_subset = locally_identifiable_subset(Rjac,CI_threshold);

id_variables = variables(id_subset);


N = size(variables,1);

for i = 1:N
    if ismember(i,id_subset);
        str{i} = 'id param';
    else
        str{i} = 'non-id param';
    end
end

% write to file in cytoscape format
id_param_FilePath = [fname '_param_ID.txt'];
AMIGO_network2file(id_param_FilePath,{'Parameter','Identifiability'},variables,str);

id_param = str';