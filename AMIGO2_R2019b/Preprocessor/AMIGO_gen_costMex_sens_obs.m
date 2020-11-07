
function AMIGO_gen_costMex_sens_obs(inputs,fid)
% generate the right hand side of the ODEs

if(numel(inputs.model.st_names)>0)
    for i=0:inputs.model.n_st-1
        
        fprintf(fid,'#define\t %s (amigo_model->sens_results[%d][j][k]) \n',inputs.model.st_names(i+1,:),i);
        
    end
end


fprintf(fid,sprintf('\n\n\nvoid amigoRHS_get_sens_OBS(void* data){\n'));

fprintf(fid,'\tint j,k;\n\n');

fprintf(fid,'\tAMIGO_model* amigo_model=(AMIGO_model*)data;\n\n');

fprintf(fid,'\n\t switch (amigo_model->exp_num){\n\n');

for iexp=1:inputs.exps.n_exp
    
    fprintf(fid,'\n\t\t case %d:\n\n',iexp-1);
    
    if(inputs.exps.n_obs{iexp}>0)
        
        for i=1:inputs.exps.n_obs{iexp}
            
            fprintf(fid,'\t\t#define\t %s amigo_model->sens_obs[%d][j][k] \n',inputs.exps.obs_names{iexp}(i,:),i-1);
            
        end
        
        fprintf(fid,'\n\t\t\t for (j = 0; j < amigo_model->n_total_x; ++j){');
        
        fprintf(fid,'\n\t\t\t\t for (k = 0; k < amigo_model->n_times; ++k){\n');
        
        for i=1:size(inputs.exps.obs{iexp},1)
            
            temp_expr=regexprep(inputs.exps.obs{iexp}(i,:),'[\s.]','');
            for j=1:inputs.exps.n_obs{iexp}
                temp_expr=regexprep(temp_expr,regexprep(inputs.exps.obs_names{iexp}(j,:),'\s',''),sprintf('%s',regexprep(inputs.exps.obs_names{iexp}(j,:),'\s','')));
            end
            fprintf(fid,'\t\t\t\t\t%s;\n',temp_expr);
            
        end
        
        fprintf(fid,'\t\t\t\t}\n\t\t\t}');
        
    end
    
    fprintf(fid,'\n\t\t break;\n');
    
end

fprintf(fid,'\t}\n}');

end
