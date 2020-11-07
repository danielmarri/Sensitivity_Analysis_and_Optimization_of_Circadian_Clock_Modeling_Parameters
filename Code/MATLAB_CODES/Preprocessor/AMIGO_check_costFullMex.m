function [inputs results] = AMIGO_check_costFullMex(inputs,results)

switch inputs.model.exe_type
    
    case {'costMex','fullMex'}
        
        switch inputs.model.input_model_type
            
            case 'charmodelC'
                
                if(~isfield(inputs.model,'odes_file') || isempty(inputs.model.odes_file))
                    inputs.model.odes_file=fullfile(results.pathd.problem_folder_path,'amigoRHS.c');
                end
                
                if(~isfield(inputs.model,'mexfile') || isempty(inputs.model.mexfile))
                    inputs.model.mexfile=fullfile(results.pathd.problem_folder_path,strcat([inputs.model.exe_type '_'],results.pathd.short_name));
                end
                
                if(regexp(inputs.model.mexfile,'\w+$'))
                    inputs.model.mexfunction=inputs.model.mexfile(regexp(inputs.model.mexfile,'\w+$'):end);
                else
                    inputs.model.mexfunction=inputs.model.mexfile(regexp(inputs.model.mexfile,'/w+$'):end);
                end
                
                if(~isfield(inputs.model,'use_user_obs'))
                    inputs.model.use_user_obs=0;
                elseif inputs.model.use_user_obs
                    edit(inputs.model.odes_file);
                    keyboard
                end
                
                if(~isfield(inputs.model,'use_user_sens_obs'))
                    inputs.model.use_user_sens_obs=0;
                elseif inputs.model.use_user_obs
                    edit(inputs.model.odes_file)
                    keyboard
                end
                
            otherwise
                
               warning('costMex or fullMex can only handle models of type charmodelC changing');
               inputs.model.input_model_type='charmodelC';
               [inputs results]=AMIGO_check_costFullMex(inputs,results);
        end
        
    case 'fullC'
        
        switch inputs.model.input_model_type
            
            case 'charmodelC'
                
               if(~isfield(inputs.model,'odes_file') || isempty(inputs.model.odes_file))
                    inputs.model.odes_file=fullfile(results.pathd.problem_folder_path,'amigoRHS.c');
                end
                
                if(~isfield(inputs.model,'mexfile') || isempty(inputs.model.mexfile))
                    inputs.model.mexfile=fullfile(results.pathd.problem_folder_path,strcat([inputs.model.exe_type '_'],results.pathd.short_name));
                end
                
                if(regexp(inputs.model.mexfile,'\w+$'))
                    inputs.model.mexfunction=inputs.model.mexfile(regexp(inputs.model.mexfile,'\w+$'):end);
                else
                    inputs.model.mexfunction=inputs.model.mexfile(regexp(inputs.model.mexfile,'/w+$'):end);
                end
                
                if(~isfield(inputs.model,'use_user_obs'))
                    inputs.model.use_user_obs=0;
                elseif inputs.model.use_user_obs
                    edit(inputs.model.odes_file);
                    keyboard
                end
                
                if(~isfield(inputs.model,'use_user_sens_obs'))
                    inputs.model.use_user_sens_obs=0;
                elseif inputs.model.use_user_obs
                    edit(inputs.model.odes_file)
                    keyboard
                end
                
            otherwise
                
                error('fullC can only handle models of type charmodelC');
                
        end
        
end

if(strcmp(inputs.model.exe_type,'costMex') || strcmp(inputs.model.exe_type,'fullMex')  || strcmp(inputs.model.exe_type,'fullC'))
    
    if(~strcmp(inputs.model.input_model_type,'charmodelC'))
        error('AMIGO_Prep: Execution type costMex, fullMex or fullC can only be used with charmodelC');
    end
    
    inputs = AMIGO_check_exps(inputs,results);
    inputs = AMIGO_check_obs(inputs,results);
    inputs = AMIGO_check_data(inputs,results);
    inputs = AMIGO_check_Q(inputs);
    
    AMIGO_check_exps(inputs,results);
    
    inputs = AMIGO_check_theta(inputs);
    inputs.PEsol.n_global_theta=length(inputs.PEsol.id_global_theta);
    AMIGO_init_theta
    inputs = AMIGO_check_theta_bounds(inputs);
    
    for iexp=1:inputs.exps.n_exp
        AMIGO_uinterp
        inputs.exps.t_int{iexp}=inputs.exps.t_s{iexp};
    end
end

end

