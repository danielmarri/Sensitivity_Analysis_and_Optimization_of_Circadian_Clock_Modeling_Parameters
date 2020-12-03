%% Initializes vector of decision variables and corresponding bounds
%
% AMIGO_init_OD_guess_bounds: initializes some necessary vectors for optimization
%
% *Version details*
%
%   AMIGO_IOC version:     March 2017
%   Code development:     Eva Balsa-Canto
%   Address:              Process Engineering Group, IIM-CSIC
%                         C/Eduardo Cabello 6, 36208, Vigo-Spain
%   e-mail:               ebalsa@iim.csic.es
%   Copyright:            CSIC, Spanish National Research Council
%
% *Brief description*
%
%  Script that generates initial guess and bounds using the CVP approach
%  Decision variables are ordered as follows:
%           - Final time
%           - Control values (steps, linear interpolation)
%           - Elements durations
%%


% BOUNDS FOR STIMULI + PARAMETERS --- CURRENTLY FOR ONE EXPERIMENT ----  TO
% BE MODIFIED FOR MULTIPLE EXPERIMENT

for iexp=1:inputs.exps.n_exp
if isempty(inputs.IOCsol.u_guess)==1
    inputs.IOCsol.u_guess{iexp}=inputs.IOCsol.u_min{iexp}+ 0.5*(inputs.IOCsol.u_max{iexp}-inputs.IOCsol.u_min{iexp});
end
end


% EBC -- consider the case with initial conditions to be designed

inputs.IOCsol.n_y0=size(inputs.IOCsol.id_y0,1);
indexy0=[];
if inputs.IOCsol.n_y0>0 
    
    indexy0=strmatch(inputs.IOCsol.id_y0(1,:),inputs.model.st_names,'exact');

    for iy0=2:inputs.IOCsol.n_y0
    indexy0=[indexy0 strmatch(inputs.IOCsol.id_y0(iy0,:),inputs.model.st_names,'exact')];
    end
    inputs.IOCsol.index_y0=indexy0;
    
    if isempty(inputs.IOCsol.y0_guess)
    inputs.IOCsol.y0_guess=inputs.IOCsol.y0_min+ 0.5*(inputs.IOCsol.y0_max-inputs.IOCsol.y0_min);                                 
    end

end %inputs.IOCsol.n_y0>0 



% EBC -- consider the case with parameters /sustained stimulation and time
% varying stimulation

inputs.IOCsol.n_par=size(inputs.IOCsol.id_par,1);
indexpar=[];
if inputs.IOCsol.n_par>0 
    
    indexpar=strmatch(inputs.IOCsol.id_par(1,:),inputs.model.par_names,'exact');

    for ipar=2:inputs.IOCsol.n_par
    indexpar=[indexpar strmatch(inputs.IOCsol.id_par(ipar,:),inputs.model.par_names,'exact')];
    end
    inputs.IOCsol.index_par=indexpar;
    
    if isempty(inputs.IOCsol.par_guess)
    inputs.IOCsol.par_guess=inputs.IOCsol.par_min+ 0.5*(inputs.IOCsol.par_max-inputs.IOCsol.par_min);                                 
    end

end %inputs.IOCsol.n_par>0 
    


% DEFINES INITIAL GUESS AND BOUNDS FOR OPTIMIZATION

inputs.IOCsol.vdo_guess=[];
inputs.IOCsol.vdo_min=[];
inputs.IOCsol.vdo_max=[];



%% Final time
%

switch  inputs.IOCsol.tf_type
    
    case 'fixed'
        inputs.IOCsol.tf_guess=privstruct.t_f;
        inputs.IOCsol.tf_max=privstruct.t_f;
        inputs.IOCsol.tf_min=privstruct.t_f;
        
    case 'od'
        
        switch  inputs.IOCsol.u_interp
            case {'stepf','linearf'}
                
                if isempty(inputs.IOCsol.tf_guess)
                    inputs.IOCsol.tf_guess=mean(inputs.IOCsol.tf_min{iexp}, inputs.IOCsol.tf_max{iexp});
                end
                for iexp=1:inputs.exps.n_exp
                inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.tf_guess{iexp}];
                inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.tf_min{iexp}];
                inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.tf_max{iexp}];
                end
        end
        
end;


%% Stimulation

if inputs.model.n_stimulus>0
switch inputs.IOCsol.u_interp
    %%
    % *  Sustained stimulation
    case 'sustained'
        for iexp=1:inputs.exps.n_exp
        if isempty(inputs.IOCsol.u_guess)==1
            for iu=1:inputs.model.n_stimulus
                inputs.IOCsol.u_guess{iexp}(iu,1)=mean([inputs.IOCsol.u_min{iexp}(iu,1); inputs.IOCsol.u_max{iexp}(iu,1)]);
            end
        end
        inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.u_guess{iexp}'];
        inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.u_min{iexp}'];
        inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.u_max{iexp}'];
        
        end
        %%
        % *  Pulse-up stimulation ___|---|___
        
    case 'pulse-up'
        for iexp=1:inputs.exps.n_exp
        pulse_duration_min=(inputs.IOCsol.tf_min{iexp}-inputs.exps.t_in{iexp})/(inputs.IOCsol.n_pulses{iexp}*2+1);
        pulse_duration_guess=(inputs.IOCsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.IOCsol.n_pulses{iexp}*2+1);
        pulse_duration_max=(inputs.IOCsol.tf_max{iexp}-inputs.exps.t_in{iexp})/(inputs.IOCsol.n_pulses{iexp}*2+1);
        inputs.IOCsol.tcon_min{iexp}=union([0.25*pulse_duration_min:pulse_duration_min:inputs.IOCsol.tf_min{iexp}-pulse_duration_min],inputs.IOCsol.tf_min{iexp});
        inputs.IOCsol.tcon_guess{iexp}{iexp}=union([0.75*pulse_duration_guess:pulse_duration_guess:inputs.IOCsol.tf_guess-pulse_duration_guess],inputs.IOCsol.tf_guess{iexp});
        inputs.IOCsol.tcon_max{iexp}=[1.0*pulse_duration_max:pulse_duration_max:1.0*inputs.IOCsol.tf_max{iexp}];
        
        inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.tcon_guess{iexp}{iexp}(1:inputs.IOCsol.n_pulses{iexp}*2)];
        inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.tcon_min{iexp}(1:inputs.IOCsol.n_pulses{iexp}*2)];
        inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.tcon_max{iexp}(1:inputs.IOCsol.n_pulses{iexp}*2)];
        end
        %%
        % *  Pulse-down stimulation |---|_____
    case 'pulse-down'
        
        for iexp=1:inputs.exps.n_exp
        pulse_duration=(inputs.IOCsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.IOCsol.n_pulses{iexp}*2);
        inputs.IOCsol.tcon_min=union([0.25*pulse_duration:pulse_duration:inputs.IOCsol.tf_min{iexp}-pulse_duration],inputs.IOCsol.tf_min{iexp});
        inputs.IOCsol.tcon_guess{iexp}{iexp}=union([0.75*pulse_duration:pulse_duration:inputs.IOCsol.tf_guess{iexp}-pulse_duration],inputs.IOCsol.tf_guess{iexp});
        inputs.IOCsol.tcon_max{iexp}=[1.0*pulse_duration:pulse_duration:1.0*inputs.IOCsol.tf_max{iexp}];
        
        inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.tcon_guess{iexp}{iexp}(1:inputs.IOCsol.n_pulses{iexp}*2-1)];
        inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.tcon_min{iexp}(1:inputs.IOCsol.n_pulses{iexp}*2-1)];
        inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.tcon_max{iexp}(1:inputs.IOCsol.n_pulses{iexp}*2-1)];
        end
        %%
        % *  Step-wise stimulation, elements of free duration
    case {'step'}
        
        for iexp=1:inputs.exps.n_exp
        if isempty(inputs.IOCsol.u_guess{iexp})==1
            for iu=1:inputs.model.n_stimulus
                inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})=mean([inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_steps{iexp}); inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})]);
            end
        end
        
        for iu=1:inputs.model.n_stimulus
            inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})];
            inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})];
            inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})];
        end
        
        step_duration=(inputs.IOCsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.IOCsol.n_steps{iexp});
        if isempty(inputs.IOCsol.min_stepduration{iexp})
            max_step_duration=inputs.IOCsol.tf_max{iexp}-step_duration; %%OJO !!! aquí se admitía el máximo
            min_step_duration=inputs.IOCsol.tf_min{iexp}/(5*inputs.IOCsol.n_steps{iexp}+1); %%% OJO!!! aquí ponia 1000
        else
            max_step_duration=inputs.IOCsol.max_stepduration{iexp};
            min_step_duration=inputs.IOCsol.min_stepduration{iexp};
        end
        inputs.IOCsol.step_duration_min=min_step_duration*ones(1,inputs.IOCsol.n_steps{iexp});
        inputs.IOCsol.step_duration_max=max_step_duration*ones(1,inputs.IOCsol.n_steps{iexp});
        
        
        if isempty(inputs.IOCsol.t_con{iexp})
            
            inputs.IOCsol.step_duration_guess{iexp}=step_duration*ones(1,inputs.IOCsol.n_steps{iexp});
            inputs.IOCsol.tcon_max{iexp}=[1.5*step_duration:step_duration:inputs.IOCsol.tf_max{iexp} ];
            inputs.IOCsol.tcon_guess{iexp}{iexp}(1,1)=inputs.exps.t_in{iexp};
            for icon=2:inputs.IOCsol.n_steps{iexp}
                inputs.IOCsol.tcon_guess{iexp}{iexp}(1,icon)=inputs.IOCsol.tcon_guess{iexp}{iexp}(1,icon-1)+inputs.IOCsol.step_duration_guess{iexp}(1,icon);
            end
            inputs.IOCsol.tcon_guess{iexp}{iexp}(1,inputs.IOCsol.n_steps{iexp})=inputs.IOCsol.tf_guess{iexp};
            
            inputs.exps.t_con=inputs.IOCsol.tcon_guess{iexp};
            
        else %if isempty(inputs.IOCsol.t_con{iexp})
            
            for icon=2:inputs.IOCsol.n_steps{iexp}
                inputs.IOCsol.step_duration_guess{iexp}(icon-1)=inputs.IOCsol.t_con{iexp}(icon)-inputs.IOCsol.t_con{iexp}(icon-1);
            end
            inputs.IOCsol.tcon_guess{iexp}=inputs.IOCsol.t_con{iexp};
            
        end
        
        
        inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.step_duration_guess{iexp}];
        inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.step_duration_min(1:inputs.IOCsol.n_steps{iexp}-1)];
        inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.step_duration_max(1:inputs.IOCsol.n_steps{iexp}-1)];
        
        end
        %%
        % *  Step-wise stimulation, elements of fixed duration
    case 'stepf'
        
        
        for iexp=1:inputs.exps.n_exp
        if isempty(inputs.IOCsol.u_guess{iexp})==1
            for iu=1:inputs.model.n_stimulus
                inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})=mean([inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_steps{iexp}); inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})]);
            end
        end

        for iu=1:inputs.model.n_stimulus
            inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})];
            inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})];
            inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})];
        end

        if isempty(inputs.IOCsol.t_con{iexp})
            step_duration=(inputs.IOCsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/inputs.IOCsol.n_steps{iexp};
            inputs.IOCsol.tcon_guess{iexp}=[inputs.exps.t_in{iexp}:step_duration:inputs.IOCsol.tf_guess{iexp}];
        else
            inputs.IOCsol.tcon_guess{iexp}=inputs.IOCsol.t_con{iexp};
        end
 
        end
   
        
           %%
        % *  Linear-wise stimulation, elements of fixed duration
    case 'linearf'
        
        for iexp=1:inputs.exps.n_exp
        if isempty(inputs.IOCsol.u_guess{iexp})==1
            for iu=1:inputs.model.n_stimulus
                inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})=mean([inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_linear{iexp}); inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})]);
            end
        end
        
        for iu=1:inputs.model.n_stimulus
            inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})];
            inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})];
            inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})];
        end
        
        
        if isempty(inputs.IOCsol.t_con{iexp})
            step_duration=(inputs.IOCsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.IOCsol.n_linear{iexp}-1);
            inputs.IOCsol.tcon_guess{iexp}{iexp}=[inputs.exps.t_in{iexp}:step_duration:inputs.IOCsol.tf_guess{iexp}];
        else
            inputs.IOCsol.tcon_guess{iexp}=inputs.IOCsol.t_con{iexp};
        end
             
        end
        
        %%
        % *  Linear-wise stimulation, elements of free duration
        
    case {'linear'}
        for iexp=1:inputs.exps.n_exp
        if isempty(inputs.IOCsol.u_guess{iexp})==1
            for iu=1:inputs.model.n_stimulus
                inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})=mean([inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_linear{iexp}); inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})]);
            end
        end
        
        for iu=1:inputs.model.n_stimulus
            inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.u_guess{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})];
            inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.u_min{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})];
            inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.u_max{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})];
        end
        
        
        step_duration=(inputs.IOCsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.IOCsol.n_linear{iexp}-1);
        if isempty(inputs.IOCsol.min_stepduration{iexp})
            max_step_duration=inputs.IOCsol.tf_max{iexp}-step_duration; %%OJO !!! aquí se admitía el máximo
            min_step_duration=inputs.IOCsol.tf_min{iexp}/(5*inputs.IOCsol.n_linear{iexp}); %%% OJO!!! aquí ponia 1000
        else
            max_step_duration=inputs.IOCsol.max_stepduration{iexp};
            min_step_duration=inputs.IOCsol.min_stepduration{iexp};
        end
        inputs.IOCsol.step_duration_min{iexp}=min_step_duration*ones(1,inputs.IOCsol.n_linear{iexp}-1);
        inputs.IOCsol.step_duration_max{iexp}=max_step_duration*ones(1,inputs.IOCsol.n_linear{iexp}-1);
        
        
        if isempty(inputs.IOCsol.t_con{iexp})
            
            inputs.IOCsol.step_duration_guess{iexp}=step_duration*ones(1,inputs.IOCsol.n_linear{iexp}-1);
            inputs.IOCsol.tcon_max{iexp}=[1.5*step_duration:step_duration:inputs.IOCsol.tf_max{iexp} ];
            inputs.IOCsol.tcon_guess{iexp}{iexp}(1,1)=inputs.exps.t_in{iexp};
            for icon=2:inputs.IOCsol.n_linear{iexp}-1
                inputs.IOCsol.tcon_guess{iexp}{iexp}(1,icon)=inputs.IOCsol.tcon_guess{iexp}{iexp}(1,icon-1)+inputs.IOCsol.step_duration_guess{iexp}(1,icon);
            end
            inputs.IOCsol.tcon_guess{iexp}{iexp}(1,inputs.IOCsol.n_linear{iexp})=inputs.IOCsol.tf_guess{iexp};
            
           
        else %if isempty(inputs.IOCsol.t_con{iexp})
            
            for icon=2:inputs.IOCsol.n_linear{iexp}
                inputs.IOCsol.step_duration_guess{iexp}(icon-1)=inputs.IOCsol.t_con{iexp}(icon)-inputs.IOCsol.t_con{iexp}(icon-1);
            end
            inputs.IOCsol.tcon_guess{iexp}=inputs.IOCsol.t_con{iexp};
            
        end
        
        inputs.IOCsol.vdo_guess=[inputs.IOCsol.vdo_guess inputs.IOCsol.step_duration_guess{iexp}];
        inputs.IOCsol.vdo_min=[inputs.IOCsol.vdo_min inputs.IOCsol.step_duration_min{iexp}];
        inputs.IOCsol.vdo_max=[inputs.IOCsol.vdo_max inputs.IOCsol.step_duration_max{iexp}(1:inputs.IOCsol.n_linear{iexp}-1)];
        end
        
        
end

inputs.exps.t_con=inputs.IOCsol.tcon_guess;


 inputs.IOCsol.vdo_guess=[inputs.IOCsol.y0_guess inputs.IOCsol.par_guess inputs.IOCsol.vdo_guess];
 inputs.IOCsol.vdo_min=[inputs.IOCsol.y0_min inputs.IOCsol.par_min inputs.IOCsol.vdo_min];
 inputs.IOCsol.vdo_max=[inputs.IOCsol.y0_max inputs.IOCsol.par_max inputs.IOCsol.vdo_max];
 
else
 inputs.IOCsol.vdo_guess=[inputs.IOCsol.y0_guess inputs.IOCsol.par_guess ];
 inputs.IOCsol.vdo_min=[inputs.IOCsol.y0_min inputs.IOCsol.par_min ];
 inputs.IOCsol.vdo_max=[inputs.IOCsol.y0_max inputs.IOCsol.par_max ];  
    
end