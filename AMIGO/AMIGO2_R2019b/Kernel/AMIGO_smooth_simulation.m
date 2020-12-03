% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_smooth_simulation.m 2487 2016-02-23 14:01:49Z evabalsa $
% AMIGO_smooth_simulation: Smooth solution of the model equations
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
%  AMIGO_smooth_simulation: solves the intial value problem solver assuming   %
%                           continuous sampling times                         %
%*****************************************************************************%


ntplot_def=inputs.plotd.n_t_plot;



for iexp=1:inputs.exps.n_exp

    if isempty(inputs.exps.n_s{iexp})==1
        inputs.exps.n_s{iexp}=ntplot_def;
    end
   
    if inputs.exps.n_s{iexp} >= ntplot_def
        inputs.plotd.n_t_plot=inputs.exps.n_s{iexp};
        if (isempty(inputs.exps.t_s{iexp})==1)
            delta=(privstruct.t_f{iexp}-inputs.exps.t_in{iexp})/(inputs.plotd.n_t_plot-1);
            privstruct.t_int{iexp}=[inputs.exps.t_in{iexp}:delta:privstruct.t_f{iexp}];
        else
            privstruct.t_int{iexp}=inputs.exps.t_s{iexp};
        end
        privstruct.ts_index{iexp}=[1:1:inputs.plotd.n_t_plot];
        
    % EBC   n_s{iexp}<=ntplot_def   
    else  
        
        delta=(privstruct.t_f{iexp}-inputs.exps.t_in{iexp})/(ntplot_def-1);
    % EBC   In this case we want to get the value at sampling times plus at
    % EBC   plot times 
    % privstruct.t_s{iexp} instead of inputs.exps.t_s 
        privstruct.t_int{iexp}=union(privstruct.t_s{iexp},[inputs.exps.t_in{iexp}:delta:privstruct.t_f{iexp}]);
        
    % EBC   We need to detect indexes where sampling times are located in the vector t_int
        [privstruct.tint{iexp}, privstruct.tint_index]=setdiff(privstruct.t_int{iexp},privstruct.t_s{iexp});
        privstruct.ts_index{iexp}=setdiff([1:1:length(privstruct.t_int{iexp})],privstruct.tint_index);
           
    end

    %     if size(privstruct.t_con{iexp},2) > ntplot_def
    %         inputs.plotd.n_t_plot=size(privstruct.t_con{iexp},2);
    %     end

    privstruct.vtout{iexp}=sort(union(privstruct.t_int{iexp},privstruct.t_con{iexp}));
    results.sim.tsim=privstruct.t_int;
end



switch inputs.model.exe_type

    case 'standard'
      
        for iexp=1:inputs.exps.n_exp

               [results.sim.states{iexp} privstruct]=AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par{iexp},iexp);

            if inputs.model.obsfile==1
                obsfunc=inputs.pathd.obs_function;
                results.sim.obs{iexp}=feval(obsfunc,results.sim.states{iexp},inputs,privstruct.par{iexp},iexp);
                % EBC, keeps in a different field model predictions at
                % sampling times
   
                results.sim.sim_data{iexp}=results.sim.obs{iexp}(privstruct.ts_index{iexp},:);
                
            else
                results.sim.obs{iexp}=results.sim.states{iexp}(:,inputs.exps.index_observables{iexp});
            end
        end

    case {'costMex','fullMex'}

        temp_inputs=inputs;
        temp_privstruct=privstruct;
        
        inputs.model.par=privstruct.par{1};
        inputs.exps.exp_y0=privstruct.y_0;
        
        for iexp=1:inputs.exps.n_exp
            privstruct.n_s{iexp}=length(privstruct.t_int{iexp});
            privstruct.Q{iexp}=ones(privstruct.n_obs{iexp},privstruct.n_s{iexp});
        end
        privstruct.t_int=privstruct.t_int;

        feval(inputs.model.mexfunction,'sim_CVODES');
        results.sim.obs=outputs.observables;
        results.sim.states=outputs.simulation;
        
        inputs=temp_inputs;
        privstruct=temp_privstruct;
        
         for iexp=1:inputs.exps.n_exp
            
            if(outputs.success{iexp})
                
               privstruct.ivpsol.ivp_fail=0;
               privstruct.count_success_ivp=privstruct.count_success_ivp+1;
                
            else
                
                privstruct.ivpsol.ivp_fail=1;
                privstruct.count_failed_ivp=privstruct.count_failed_ivp+1;
                
            end
        end
        

    otherwise
        
        error('AMIGO_smooth_simulation: No such execution mode.');
end

%for iexp=1:inputs.n_exp