% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_names.m 2191 2015-09-23 13:25:27Z evabalsa $
% AMIGO_check_names: Checks names of states, pars, stimuli are introduced
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_check_names: Checks names of states, pars, stimuli are introduced
%                                                                             %
%*****************************************************************************%


switch inputs.model.names_type
    
    case 'custom'
        
        if isempty(inputs.model.st_names)==1 && inputs.model.n_st>1
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected the use of customized names for variables and pars.\n');
            fprintf('\t\tYou must introduce the corresponding names in: inputs.model.st_names, .dst_names, .par_names.\n');
            error('error_model_004','\t\t Impossible to continue. Stopping.\n');
        end
        
        if isempty(inputs.model.par_names)==1 && inputs.model.n_par>1
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected the use of customized names for variables and pars.\n');
            fprintf('\t\tYou must introduce the corresponding names in: inputs.model.st_names, .dst_names, .par_names.\n');
            error('error_model_004','\t\t Impossible to continue. Stopping.\n');
        end
        
        
        if inputs.model.n_stimulus>0 && isempty(inputs.model.stimulus_names)==1
            fprintf(1,'\n\n------> ERROR message\n\n');
            fprintf('\t\tYou have selected the use of customized names for stimuli.\n');
            fprintf('\t\tYou must introduce the corresponding names in: .stimulus_names.\n');
            error('error_model_004','\t\t Impossible to continue. Stopping.\n');
            
        end
        
        
        if isempty(inputs.model.st_names)==0
            
            if size(inputs.model.st_names,1)~=inputs.model.n_st
                fprintf(1,'\n\n------> ERROR message\n\n');
                fprintf('\t\t The number of names for the states you have introduced (%u),\n',size(inputs.model.st_names,1));
                fprintf('\t\t does not correspond with the number of states (%u)\n',inputs.model.n_st);
                error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
            end
            
        end
        
        
        if isempty(inputs.model.par_names)==0
            
            if size(inputs.model.par_names,1)~=inputs.model.n_par
                fprintf(1,'\n\n------> ERROR message\n\n');
                fprintf('\t\t The number of names for the parameters you have introduced (%u),\n',size(inputs.model.par_names,1));
                fprintf('\t\t does not correspond with the number of parameters (%u)\n',inputs.model.n_par);
                error('error_model_010b','\t\t Impossible to continue. Stopping.\n');
            end
            
        end
        
        if isempty(inputs.model.stimulus_names)==0
            
            if size(inputs.model.stimulus_names,1)~=inputs.model.n_stimulus
                fprintf(1,'\n\n------> ERROR message\n\n');
                fprintf('\t\t The number of names for the stimuli you have introduced (%u),\n',size(inputs.model.stimulus_names,1));
                fprintf('\t\t does not correspond with the number of stimuli (%u)\n',inputs.model.n_stimulus);
                error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
            end
            
        end
        
        
        
        
    case 'standard'
        
        x_list='x1';
        dx_list='dx1';
        for ist=2:inputs.model.n_st
            x_list=char(x_list,strcat('x',num2str(ist)));
            dx_list=char(dx_list,strcat('dx',num2str(ist)));
        end
        if inputs.model.n_par >0
        par_list='p1';
        for ipar=2:inputs.model.n_par
            par_list=char(par_list,strcat('p',num2str(ipar)));   end
        else
            par_list=[];
        end
        if inputs.model.n_stimulus >0
        stimulus_list='u1';
        for istimulus=2:inputs.model.n_stimulus
            stimulus_list=char(stimulus_list,strcat('u',num2str(istimulus)));  end
        else
            stimulus_list=[];
        end
        inputs.model.st_names=x_list;
        inputs.model.dst_names=dx_list;
        inputs.model.par_names=par_list;
        inputs.model.stimulus_names=stimulus_list;
        
        
        for iexp=1:inputs.exps.n_exp
                y_list='y1';
            for iobs=2:inputs.exps.n_obs{iexp}
                y_list=char(y_list,strcat('y',num2str(iobs)));
            end
            inputs.exps.obs_names{iexp}=y_list;
        end
        
        
end %switch inputs.model.names_type