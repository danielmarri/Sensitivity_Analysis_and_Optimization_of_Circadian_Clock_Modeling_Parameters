%% Initializes vector of decision variables and corresponding bounds
%
% AMIGO_init_OD_guess_bounds: initializes some necessary vectors for optimization
%
% *Version details*
%
%   AMIGO_OD version:     March 2013
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



if isempty(inputs.DOsol.u_guess)==1
    inputs.DOsol.u_guess=inputs.DOsol.u_min+ 0.5*(inputs.DOsol.u_max-inputs.DOsol.u_min);
end



% EBC -- consider the case with initial conditions to be designed

inputs.DOsol.n_y0=size(inputs.DOsol.id_y0,1);
indexy0=[];
if inputs.DOsol.n_y0>0 
    
    indexy0=strmatch(inputs.DOsol.id_y0(1,:),inputs.model.st_names,'exact');

    for iy0=2:inputs.DOsol.n_y0
    indexy0=[indexy0 strmatch(inputs.DOsol.id_y0(iy0,:),inputs.model.st_names,'exact')];
    end
    inputs.DOsol.index_y0=indexy0;
    
    if isempty(inputs.DOsol.y0_guess)
    inputs.DOsol.y0_guess=inputs.DOsol.y0_min+ 0.5*(inputs.DOsol.y0_max-inputs.DOsol.y0_min);                                 
    end

end %inputs.DOsol.n_y0>0 



% EBC -- consider the case with parameters /sustained stimulation and time
% varying stimulation

inputs.DOsol.n_par=size(inputs.DOsol.id_par,1);
indexpar=[];
if inputs.DOsol.n_par>0 
    
    indexpar=strmatch(inputs.DOsol.id_par(1,:),inputs.model.par_names,'exact');

    for ipar=2:inputs.DOsol.n_par
    indexpar=[indexpar strmatch(inputs.DOsol.id_par(ipar,:),inputs.model.par_names,'exact')];
    end
    inputs.DOsol.index_par=indexpar;
    
    if isempty(inputs.DOsol.par_guess)
    inputs.DOsol.par_guess=inputs.DOsol.par_min+ 0.5*(inputs.DOsol.par_max-inputs.DOsol.par_min);                                 
    end

end %inputs.DOsol.n_par>0 
    


% DEFINES INITIAL GUESS AND BOUNDS FOR OPTIMIZATION

inputs.DOsol.vdo_guess=[];
inputs.DOsol.vdo_min=[];
inputs.DOsol.vdo_max=[];



%% Final time
%

switch  inputs.DOsol.tf_type
    
    case 'fixed'
        inputs.DOsol.tf_guess=privstruct.t_f{1};
        inputs.DOsol.tf_max=privstruct.t_f{1};
        inputs.DOsol.tf_min=privstruct.t_f{1};
        
    case 'od'
        
        switch inputs.exps.u_interp{1}
            case {'stepf','linearf'}
                if isempty(inputs.DOsol.tf_guess)
                    inputs.DOsol.tf_guess=mean(inputs.DOsol.tf_min, inputs.DOsol.tf_max);
                end
                
                inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.tf_guess];
                inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.tf_min];
                inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.tf_max];
        end
        
end;



%% Stimulation



switch inputs.DOsol.u_interp
    %%
    % *  Sustained stimulation
    case 'sustained'
        if isempty(inputs.DOsol.u_guess)==1
            for iu=1:inputs.model.n_stimulus
                inputs.DOsol.u_guess(iu,1)=mean([inputs.DOsol.u_min(iu,1); inputs.DOsol.u_max(iu,1)]);
            end
        end
        inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.u_guess];
        inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.u_min];
        inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.u_max];
        
        %%
        % *  Pulse-up stimulation ___|---|___
        
    case 'pulse-up'
        pulse_duration_min=(inputs.DOsol.tf_min-inputs.exps.t_in{1})/(inputs.DOsol.n_pulses*2+1);
        pulse_duration_guess=(inputs.DOsol.tf_guess-inputs.exps.t_in{1})/(inputs.DOsol.n_pulses*2+1);
        pulse_duration_max=(inputs.DOsol.tf_max-inputs.exps.t_in{1})/(inputs.DOsol.n_pulses*2+1);
        inputs.DOsol.tcon_min=union([0.25*pulse_duration_min:pulse_duration_min:inputs.DOsol.tf_min-pulse_duration_min],inputs.DOsol.tf_min);
        inputs.DOsol.tcon_guess=union([0.75*pulse_duration_guess:pulse_duration_guess:inputs.DOsol.tf_guess-pulse_duration_guess],inputs.DOsol.tf_guess);
        inputs.DOsol.tcon_max=[1.0*pulse_duration_max:pulse_duration_max:1.0*inputs.DOsol.tf_max];
        
        inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.tcon_guess(1:inputs.DOsol.n_pulses*2)];
        inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.tcon_min(1:inputs.DOsol.n_pulses*2)];
        inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.tcon_max(1:inputs.DOsol.n_pulses*2)];
        
        %%
        % *  Pulse-down stimulation |---|_____
    case 'pulse-down'
        
        pulse_duration=(inputs.DOsol.tf_guess-inputs.exps.t_in{1})/(inputs.DOsol.n_pulses*2);
        inputs.DOsol.tcon_min=union([0.25*pulse_duration:pulse_duration:inputs.DOsol.tf_min-pulse_duration],inputs.DOsol.tf_min);
        inputs.DOsol.tcon_guess=union([0.75*pulse_duration:pulse_duration:inputs.DOsol.tf_guess-pulse_duration],inputs.DOsol.tf_guess);
        inputs.DOsol.tcon_max=[1.0*pulse_duration:pulse_duration:1.0*inputs.DOsol.tf_max];
        
        inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.tcon_guess(1:inputs.DOsol.n_pulses*2-1)];
        inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.tcon_min(1:inputs.DOsol.n_pulses*2-1)];
        inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.tcon_max(1:inputs.DOsol.n_pulses*2-1)];
        
        %%
        % *  Step-wise stimulation, elements of free duration
    case {'step'}
        
        if isempty(inputs.DOsol.u_guess)==1
            for iu=1:inputs.model.n_stimulus
                inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_steps)=mean([inputs.DOsol.u_min(iu,1:inputs.DOsol.n_steps); inputs.DOsol.u_max(iu,1:inputs.DOsol.n_steps)]);
            end
        end
        
        for iu=1:inputs.model.n_stimulus
            inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_steps)];
            inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.u_min(iu,1:inputs.DOsol.n_steps)];
            inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.u_max(iu,1:inputs.DOsol.n_steps)];
        end
        
        step_duration=(inputs.DOsol.tf_guess-inputs.exps.t_in{1})/(inputs.DOsol.n_steps);
        if isempty(inputs.DOsol.min_stepduration)
            max_step_duration=inputs.DOsol.tf_max-step_duration; %%OJO !!! aquí se admitía el máximo
            min_step_duration=inputs.DOsol.tf_min/(5*inputs.DOsol.n_steps+1); %%% OJO!!! aquí ponia 1000
        else
            max_step_duration=inputs.DOsol.max_stepduration;
            min_step_duration=inputs.DOsol.min_stepduration;
        end
        inputs.DOsol.step_duration_min=min_step_duration*ones(1,inputs.DOsol.n_steps);
        inputs.DOsol.step_duration_max=max_step_duration*ones(1,inputs.DOsol.n_steps);
        
        
        if isempty(inputs.DOsol.t_con)
            
            inputs.DOsol.step_duration_guess=step_duration*ones(1,inputs.DOsol.n_steps);
            inputs.DOsol.tcon_max=[1.5*step_duration:step_duration:inputs.DOsol.tf_max ];
            inputs.DOsol.tcon_guess(1,1)=inputs.exps.t_in{1};
            for icon=2:inputs.DOsol.n_steps
                inputs.DOsol.tcon_guess(1,icon)=inputs.DOsol.tcon_guess(1,icon-1)+inputs.DOsol.step_duration_guess(1,icon);
            end
            inputs.DOsol.tcon_guess(1,inputs.DOsol.n_steps)=inputs.DOsol.tf_guess;
            
            inputs.exps.t_con{1}=inputs.DOsol.tcon_guess;
            
        else %if isempty(inputs.DOsol.t_con)
            
            for icon=2:inputs.DOsol.n_steps
                inputs.DOsol.step_duration_guess(icon-1)=inputs.DOsol.t_con(icon)-inputs.DOsol.t_con(icon-1);
            end
            inputs.DOsol.tcon_guess=inputs.DOsol.t_con;
            
        end
        
        
        inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.step_duration_guess];
        inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.step_duration_min(1:inputs.DOsol.n_steps-1)];
        inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.step_duration_max(1:inputs.DOsol.n_steps-1)];
        %%
        % *  Step-wise stimulation, elements of fixed duration
    case 'stepf'
        if isempty(inputs.DOsol.u_guess)==1
            for iu=1:inputs.model.n_stimulus
                inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_steps)=mean([inputs.DOsol.u_min(iu,1:inputs.DOsol.n_steps); inputs.DOsol.u_max(iu,1:inputs.DOsol.n_steps)]);
            end
        end
        
        for iu=1:inputs.model.n_stimulus
            inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_steps)];
            inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.u_min(iu,1:inputs.DOsol.n_steps)];
            inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.u_max(iu,1:inputs.DOsol.n_steps)];
        end
        
        
        if isempty(inputs.DOsol.t_con)
            step_duration=(inputs.DOsol.tf_guess-inputs.exps.t_in{1})/inputs.DOsol.n_steps;
            inputs.DOsol.tcon_guess=[inputs.exps.t_in{1}:step_duration:inputs.DOsol.tf_guess];
        else
            inputs.DOsol.tcon_guess=inputs.DOsol.t_con;
        end
        
        
        
           %%
        % *  Linear-wise stimulation, elements of fixed duration
    case 'linearf'
        if isempty(inputs.DOsol.u_guess)==1
            for iu=1:inputs.model.n_stimulus
                inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_linear)=mean([inputs.DOsol.u_min(iu,1:inputs.DOsol.n_linear); inputs.DOsol.u_max(iu,1:inputs.DOsol.n_linear)]);
            end
        end
        
        for iu=1:inputs.model.n_stimulus
            inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_linear)];
            inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.u_min(iu,1:inputs.DOsol.n_linear)];
            inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.u_max(iu,1:inputs.DOsol.n_linear)];
        end
        
        
        if isempty(inputs.DOsol.t_con)
            step_duration=(inputs.DOsol.tf_guess-inputs.exps.t_in{1})/(inputs.DOsol.n_linear-1);
            inputs.DOsol.tcon_guess=[inputs.exps.t_in{1}:step_duration:inputs.DOsol.tf_guess];
        else
            inputs.DOsol.tcon_guess=inputs.DOsol.t_con;
        end
             
        
        
        %%
        % *  Linear-wise stimulation, elements of free duration
        
    case {'linear'}
        
        if isempty(inputs.DOsol.u_guess)==1
            for iu=1:inputs.model.n_stimulus
                inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_linear)=mean([inputs.DOsol.u_min(iu,1:inputs.DOsol.n_linear); inputs.DOsol.u_max(iu,1:inputs.DOsol.n_linear)]);
            end
        end
        
        for iu=1:inputs.model.n_stimulus
            inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.u_guess(iu,1:inputs.DOsol.n_linear)];
            inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.u_min(iu,1:inputs.DOsol.n_linear)];
            inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.u_max(iu,1:inputs.DOsol.n_linear)];
        end
        
        
        step_duration=(inputs.DOsol.tf_guess-inputs.exps.t_in{1})/(inputs.DOsol.n_linear-1);
        if isempty(inputs.DOsol.min_stepduration)
            max_step_duration=inputs.DOsol.tf_max-step_duration; %%OJO !!! aquí se admitía el máximo
            min_step_duration=inputs.DOsol.tf_min/(5*inputs.DOsol.n_linear); %%% OJO!!! aquí ponia 1000
        else
            max_step_duration=inputs.DOsol.max_stepduration;
            min_step_duration=inputs.DOsol.min_stepduration;
        end
        inputs.DOsol.step_duration_min=min_step_duration*ones(1,inputs.DOsol.n_linear-1);
        inputs.DOsol.step_duration_max=max_step_duration*ones(1,inputs.DOsol.n_linear-1);
        
        
        if isempty(inputs.DOsol.t_con)
            
            inputs.DOsol.step_duration_guess=step_duration*ones(1,inputs.DOsol.n_linear-1);
            inputs.DOsol.tcon_max=[1.5*step_duration:step_duration:inputs.DOsol.tf_max ];
            inputs.DOsol.tcon_guess(1,1)=inputs.exps.t_in{1};
            for icon=2:inputs.DOsol.n_linear-1
                inputs.DOsol.tcon_guess(1,icon)=inputs.DOsol.tcon_guess(1,icon-1)+inputs.DOsol.step_duration_guess(1,icon);
            end
            inputs.DOsol.tcon_guess(1,inputs.DOsol.n_linear)=inputs.DOsol.tf_guess;
            
            inputs.exps.t_con{1}=inputs.DOsol.tcon_guess;
            
        else %if isempty(inputs.DOsol.t_con)
            
            for icon=2:inputs.DOsol.n_linear
                inputs.DOsol.step_duration_guess(icon-1)=inputs.DOsol.t_con(icon)-inputs.DOsol.t_con(icon-1);
            end
            inputs.DOsol.tcon_guess=inputs.DOsol.t_con;
            
        end
        
        inputs.DOsol.vdo_guess=[inputs.DOsol.vdo_guess inputs.DOsol.step_duration_guess];
        inputs.DOsol.vdo_min=[inputs.DOsol.vdo_min inputs.DOsol.step_duration_min];
        inputs.DOsol.vdo_max=[inputs.DOsol.vdo_max inputs.DOsol.step_duration_max(1:inputs.DOsol.n_linear-1)];
        
        
        
end

inputs.exps.t_con{1}=inputs.DOsol.tcon_guess;

 inputs.DOsol.vdo_guess=[inputs.DOsol.y0_guess inputs.DOsol.par_guess inputs.DOsol.vdo_guess];
 inputs.DOsol.vdo_min=[inputs.DOsol.y0_min inputs.DOsol.par_min inputs.DOsol.vdo_min];
 inputs.DOsol.vdo_max=[inputs.DOsol.y0_max inputs.DOsol.par_max inputs.DOsol.vdo_max];
 
 