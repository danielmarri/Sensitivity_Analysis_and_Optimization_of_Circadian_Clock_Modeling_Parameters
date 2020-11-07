% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_set_theta_index.m 1896 2014-10-30 08:58:29Z davidh $
% AMIGO_set_theta_index: computes vectors of indexes for estimation
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
%  AMIGO_set_theta_index: computes vectors of indexes for estimation          %
%*****************************************************************************%



% GLOBAL PARAMETERS


switch inputs.PEsol.id_global_theta
    case 'all'
        inputs.PEsol.id_global_theta=inputs.model.par_names;
        inputs.PEsol.index_global_theta=[1:1:inputs.model.n_par];
        inputs.PEsol.n_global_theta=inputs.model.n_par;
    case 'none'
        inputs.PEsol.index_global_theta=[];
        inputs.PEsol.n_global_theta=0;
    otherwise
        if inputs.model.par_names==1
            inputs.PEsol.index_global_theta=inputs.PEsol.id_global_theta;
            inputs.PEsol.n_global_theta=size(inputs.PEsol.index_global_theta,2);
        else
            inputs.PEsol.n_global_theta=size(inputs.PEsol.id_global_theta,1);
            indextheta=strmatch(inputs.PEsol.id_global_theta(1,:),inputs.model.par_names,'exact');
            for itheta0=2:size(inputs.PEsol.id_global_theta,1)
                indextheta=[indextheta strmatch(inputs.PEsol.id_global_theta(itheta0,:),inputs.model.par_names,'exact')];
            end
            inputs.PEsol.index_global_theta=indextheta;
        end;
end

% LOCAL PARAMETERS


for iexp=1:inputs.exps.n_exp
    
    
    switch inputs.PEsol.id_local_theta{iexp}
        
        case 'all'
            
            inputs.PEsol.id_local_theta_y0{iexp}=inputs.model.st_names;
            inputs.PEsol.index_local_theta{iexp}=[1:1:inputs.model.n_par];
            inputs.PEsol.n_local_theta{iexp}=inputs.model.n_par;
            
        case 'none'

            inputs.PEsol.index_local_theta{iexp}=[];
            inputs.PEsol.n_local_theta{iexp}=0;
            
        otherwise
            
            if inputs.model.par_names==1
                inputs.PEsol.index_local_theta{iexp}=inputs.PEsol.id_local_theta{iexp};
                inputs.PEsol.n_local_theta{iexp}=size(inputs.PEsol.index_local_theta{iexp},2);
             else
                inputs.PEsol.n_local_theta{iexp}=size(inputs.PEsol.id_local_theta{iexp},1);
                indextheta=strmatch(inputs.PEsol.id_local_theta{iexp}(1,:),inputs.model.par_names,'exact');
                for itheta0=2:size(inputs.PEsol.id_local_theta{iexp},1)
                    indextheta=[indextheta strmatch(inputs.PEsol.id_local_theta{iexp}(itheta0,:),inputs.model.par_names,'exact')];end
                inputs.PEsol.index_local_theta{iexp}=indextheta;
            end
            
    end
end


%GLOBAL INITIAL CONDITIONS

switch inputs.PEsol.id_global_theta_y0
    
    case 'all'
        
        inputs.PEsol.id_global_theta_y0=inputs.model.st_names;
        inputs.PEsol.index_global_theta_y0=[1:1:inputs.model.n_st];
        inputs.PEsol.n_global_theta_y0=inputs.model.n_st;
        
    case 'none'
        
        inputs.PEsol.index_global_theta_y0=[];
        inputs.PEsol.n_global_theta_y0=0;
        
    otherwise
        
        if inputs.model.st_names==1
            inputs.PEsol.index_global_theta_y0=inputs.PEsol.id_global_theta_y0;
            inputs.PEsol.n_global_theta_y0=size(inputs.PEsol.index_global_theta_y0,2);
        else
            inputs.PEsol.n_global_theta_y0=size(inputs.PEsol.id_global_theta_y0,1);
            indexy0=strmatch(inputs.PEsol.id_global_theta_y0(1,:),inputs.model.st_names,'exact');
            for ithetay0=2:size(inputs.PEsol.id_global_theta_y0,1)
                indexy0=[indexy0 strmatch(inputs.PEsol.id_global_theta_y0(ithetay0,:),inputs.model.st_names,'exact')];end
            inputs.PEsol.index_global_theta_y0=indexy0;
        end
end


%LOCAL INITIAL CONDITIONS

for iexp=1:inputs.exps.n_exp
    
    
    switch inputs.PEsol.id_local_theta_y0{iexp}
        
        case 'all'
            
            inputs.PEsol.id_local_theta_y0{iexp}=inputs.model.st_names;
            inputs.PEsol.index_local_theta_y0{iexp}=[1:1:inputs.model.n_st];
            inputs.PEsol.n_local_theta_y0{iexp}=inputs.model.n_st;
            
        case 'none'
            
            inputs.PEsol.index_local_theta_y0{iexp}=[];
            inputs.PEsol.n_local_theta_y0{iexp}=0;
            
        otherwise
            
            if inputs.model.st_names==0
                
                inputs.PEsol.index_local_theta_y0{iexp}=inputs.PEsol.id_local_theta_y0{iexp};
                inputs.PEsol.n_local_theta_y0{iexp}=size(inputs.PEsol.index_local_theta_y0{iexp},2);
                
            else
                
                inputs.PEsol.n_local_theta_y0{iexp}=size(inputs.PEsol.id_local_theta_y0{iexp},1);
                indexly0{iexp}=strmatch(inputs.PEsol.id_local_theta_y0{iexp}(1,:),inputs.model.st_names,'exact');
                
                for ithetay0=2:size(inputs.PEsol.id_local_theta_y0{iexp},1)
                    indexly0{iexp}=[indexly0{iexp} strmatch(inputs.PEsol.id_local_theta_y0{iexp}(ithetay0,:),inputs.model.st_names,'exact')];
                end
                
                inputs.PEsol.index_local_theta_y0{iexp}=indexly0{iexp};
                
            end
            
    end
    
end





% TOTAL NUMBER OF PARAMETERS (TO BE ESTIMATED)

inputs.PEsol.ntotal_local_theta=sum(cell2mat(inputs.PEsol.n_local_theta));
inputs.PEsol.n_theta=inputs.PEsol.n_global_theta+inputs.PEsol.ntotal_local_theta;

% TOTAL NUMBER OF INITIAL CONDITIONS (TO BE ESTIMATED)

inputs.PEsol.ntotal_local_theta_y0=sum(cell2mat(inputs.PEsol.n_local_theta_y0));
inputs.PEsol.n_theta_y0=inputs.PEsol.n_global_theta_y0+inputs.PEsol.ntotal_local_theta_y0;

inputs.PEsol.ntotal_theta=inputs.PEsol.n_theta+inputs.PEsol.n_theta_y0;


