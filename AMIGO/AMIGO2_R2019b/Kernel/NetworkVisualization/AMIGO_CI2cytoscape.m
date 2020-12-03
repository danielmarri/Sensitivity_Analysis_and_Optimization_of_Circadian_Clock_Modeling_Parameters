function [CI_networkFilePath CI_edgeFilePath] = AMIGO_CI2cytoscape(CI,variables,fname,CI_threshold)
% write collinearity index to Cytoscape files
% CI_threshold determines a critical value, below this value the edge is
% not written. 

N = size(CI,1);

indx_CI = 0;
CI_str={};
edge_name={};
from={};
to={};
type={};

for i = 1:N-1
    for j = i+1:N
        
        if CI(i,j)>CI_threshold
            indx_CI = indx_CI +1;
            CI_str{indx_CI} =sprintf('%g',CI(i,j));
            edge_name{indx_CI} = sprintf('%s (pp) %s',variables{i},variables{j});
            from{indx_CI} = sprintf('%s',variables{i});
            to{indx_CI} = sprintf('%s',variables{j});
            type{indx_CI} = sprintf('pp');
        end
        
    end
end

% list all the parameters.
for i = 1:N
    indx_CI = indx_CI +1;
    from{indx_CI} = sprintf('%s',variables{i});
    to{indx_CI} = '';
    type{indx_CI} = '';
end

CI_edgeFilePath = [fname '_CI.txt'];
AMIGO_network2file(CI_edgeFilePath,{'edgename','CI'},edge_name,CI_str);

CI_networkFilePath = [fname '_CI.sif'];
AMIGO_network2file(CI_networkFilePath,{},from,type,to);