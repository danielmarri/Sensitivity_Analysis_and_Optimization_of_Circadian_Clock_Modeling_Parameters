% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_init_OED_guess_bounds.m 2149 2015-09-21 13:11:13Z evabalsa $

% AMIGO_init_OED_guess_bounds: initializes some necessary vectors for optimization
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
%  AMIGO_init_PE_guess_bounds: generates guess and bounds for the vector of   %
%                           OED variables (u,tf,ts,y0)                        %
%*****************************************************************************%

 if isempty(cell2mat(inputs.exps.n_pulses))==0
 inputs.OEDsol.n_pulses=privstruct.n_pulses;    
 end
 if isempty(cell2mat(inputs.exps.n_steps))==0
 inputs.OEDsol.n_steps=privstruct.n_steps;
 end
 if isempty(cell2mat(inputs.exps.n_linear))==0
 inputs.OEDsol.n_linear=privstruct.n_linear;
 end
 if isempty(cell2mat(inputs.exps.u_min))==0
 inputs.OEDsol.u_min=privstruct.u_min;
 end
 if isempty(cell2mat(inputs.exps.u_max))==0
 inputs.OEDsol.u_max=privstruct.u_max;
 end
 
 inputs.OEDsol.u_guess=privstruct.u_guess;
  
 if isempty(cell2mat(inputs.exps.tcon_guess))==0    
 inputs.OEDsol.tcon_guess=privstruct.tcon_guess; 
 else
 inputs.OEDsol.tcon_guess=inputs.exps.tcon_guess;   
 end

 if isempty(cell2mat(inputs.exps.y0_min))==0
 inputs.OEDsol.y0_min=privstruct.y0_min;
 end
 if isempty(cell2mat(inputs.exps.y0_max))==0
 inputs.OEDsol.y0_max=privstruct.y0_max;
 end
 if isempty(cell2mat(inputs.exps.y0_guess))==0
 inputs.OEDsol.y0_guess=privstruct.y0_guess;
 end
 if isempty(cell2mat(inputs.exps.ts_0))==0
 inputs.OEDsol.ts_0=privstruct.ts_0;
 end
 if isempty(cell2mat(inputs.exps.ts_min_dist))==0
 inputs.OEDsol.ts_min_dist=inputs.exps.ts_min_dist;
 end
 
 if isempty(cell2mat(inputs.exps.index_obs_guess))==0
     inputs.OEDsol.index_obs_guess=inputs.exps.index_obs_guess;
 end
 
 if isempty(cell2mat(inputs.exps.index_obs_max))==0
     inputs.OEDsol.index_obs_max=inputs.exps.index_obs_max;
 end

 
if isempty(inputs.exps.id_y0)==0
    inputs.OEDsol.id_y0=inputs.exps.id_y0;
end

% DEFINES INITIAL GUESS AND BOUNDS FOR OPTIMIZATION   
    
   inputs.OEDsol.voed_guess=[];
   inputs.OEDsol.voed_min=[];
   inputs.OEDsol.voed_max=[];
   
% DEFINES THE PARAMETERS AND INITIAL CONDITIONS TO BE CONSIDERED FOR OED
   AMIGO_set_theta_index  
   privstruct.theta=[inputs.PEsol.global_theta_guess  inputs.PEsol.global_theta_y0_guess  cell2mat(inputs.PEsol.local_theta_guess)  cell2mat(inputs.PEsol.local_theta_y0_guess)];
   
   privstruct=AMIGO_transform_theta(inputs,results,privstruct);  
   
%
% Initial conditions for all experiments                                                 
%



    for iexp=1:inputs.exps.n_exp
    switch inputs.exps.exp_y0_type{iexp}
       case 'od'      
                if inputs.model.st_names==0
                inputs.OEDsol.index_y0{iexp}=inputs.OEDsol.id_y0{iexp};
                inputs.OEDsol.n_y0{iexp}=size(inputs.OEDsol.id_y0{iexp},2);
                else
                inputs.OEDsol.n_y0{iexp}=size(inputs.OEDsol.id_y0{iexp},1);
                indexly0{iexp}=strmatch(inputs.OEDsol.id_y0{iexp}(1,:),inputs.model.st_names,'exact');    
                for ithetay0=2:size(inputs.OEDsol.id_y0{iexp},1)
                indexly0{iexp}=[indexly0{iexp} strmatch(inputs.OEDsol.id_y0{iexp}(ithetay0,:),inputs.model.st_names,'exact')];end    
                inputs.OEDsol.index_y0{iexp}=indexly0{iexp};
                end            
            inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.y0_guess{iexp}];
            inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.y0_min{iexp}];
            inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.y0_max{iexp}];
    end; end;  
    
   
   
   
%
% Final time for all experiments
%    
    for iexp=1:inputs.exps.n_exp
    switch inputs.exps.tf_type{iexp}
        
        case 'fixed'
             
            inputs.OEDsol.tf_guess{iexp}=inputs.exps.t_f{iexp};
            inputs.OEDsol.tf_max{iexp}=inputs.exps.t_f{iexp};
            inputs.OEDsol.tf_min{iexp}=inputs.exps.t_f{iexp};
            
        case 'od'
   
            inputs.OEDsol.tf_min{iexp}=inputs.exps.tf_min{iexp};
            inputs.OEDsol.tf_max{iexp}=inputs.exps.tf_max{iexp};
            inputs.OEDsol.tf_guess{iexp}=inputs.exps.tf_guess{iexp};

            inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.tf_guess{iexp}];
            inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.tf_min{iexp}];
            inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.tf_max{iexp}];
            
    end; end;
  
 

%
% Adding Sampling times for all experiments   
%     

   inputs.OEDsol.n_ts_od=0;
   inputs.OEDsol.exp_ts_od=[];
   for iexp=1:inputs.exps.n_exp                                                           
   switch inputs.exps.ts_type{iexp}
       
      case 'fixed' 
      if isempty(inputs.exps.t_s{iexp})==1
         inputs.exps.t_s{iexp}=linspace(inputs.exps.ts_0{iexp},inputs.OEDsol.tf_guess{iexp},inputs.exps.n_s{iexp});         
      end    
          
      case 'od'  
        inputs.OEDsol.ts_guess{iexp}=[inputs.OEDsol.ts_0{iexp}:inputs.OEDsol.ts_min_dist{iexp}:inputs.OEDsol.tf_guess{iexp}];
        inputs.OEDsol.ns{iexp}=size(inputs.OEDsol.ts_guess{iexp},2);
        privstruct.w_sampling{iexp}=0.51.*ones(1,inputs.OEDsol.ns{iexp});       
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess privstruct.w_sampling{iexp}];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min zeros(1,inputs.OEDsol.ns{iexp})];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max ones(1,inputs.OEDsol.ns{iexp})];
        inputs.OEDsol.n_ts_od=inputs.OEDsol.n_ts_od+1;
        inputs.OEDsol.exp_ts_od=[inputs.OEDsol.exp_ts_od iexp];
     end;  %switch inputs.exps.ts_type{iexp}
   end; %for iexp=1:inputs.exps.n_exp       
        


 
 
% STIMULATION

if (inputs.model.n_stimulus==0)
    for iexp=1:inputs.exps.n_exp     
    inputs.OEDsol.u_guess{iexp}=0;  
   end
else   
    
   for iexp=1:inputs.exps.n_exp                                                           
   switch inputs.exps.u_type{iexp}   
       
     case 'od' 
         
         
      switch inputs.exps.u_interp{iexp}     
       
      case 'sustained'    
        if isempty(inputs.OEDsol.u_guess{iexp})==1
        for iu=1:inputs.model.n_stimulus
            inputs.OEDsol.u_guess{iexp}(1,iu)=mean([inputs.OEDsol.u_min{iexp}(iu,1); inputs.OEDsol.u_max{iexp}(iu,1)]);
        end    
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.u_guess{iexp}];
        else 
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.u_guess{iexp}'];    
        end  
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.u_min{iexp}'];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.u_max{iexp}'];
       
      case 'pulse-up'  %  ___|---|___                  
        pulse_duration_min=(inputs.OEDsol.tf_min{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_pulses{iexp}*2+1);
        pulse_duration_guess=(inputs.OEDsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_pulses{iexp}*2+1);  
        pulse_duration_max=(inputs.OEDsol.tf_max{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_pulses{iexp}*2+1);
        inputs.OEDsol.tcon_min{iexp}=union([0.25*pulse_duration_min:pulse_duration_min:inputs.OEDsol.tf_min{iexp}-pulse_duration_min],inputs.OEDsol.tf_min{iexp});
        if isempty(inputs.OEDsol.tcon_guess{iexp})
        inputs.OEDsol.tcon_guess{iexp}=union([0.75*pulse_duration_guess:pulse_duration_guess:inputs.OEDsol.tf_guess{iexp}-pulse_duration_guess],inputs.OEDsol.tf_guess{iexp});
        end
        inputs.OEDsol.tcon_max{iexp}=[1.0*pulse_duration_max:pulse_duration_max:1.0*inputs.OEDsol.tf_max{iexp}];    
        
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.tcon_guess{iexp}(1:inputs.exps.n_pulses{iexp}*2)];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.tcon_min{iexp}(1:inputs.exps.n_pulses{iexp}*2)];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.tcon_max{iexp}(1:inputs.exps.n_pulses{iexp}*2)];    
        
                     
      case 'pulse-down'% |---|_____
              
        pulse_duration=(inputs.OEDsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_pulses{iexp}*2);  
        inputs.OEDsol.tcon_min{iexp}=union([0.25*pulse_duration:pulse_duration:inputs.OEDsol.tf_min{iexp}-pulse_duration],inputs.OEDsol.tf_min{iexp});
        if isempty(inputs.OEDsol.tcon_guess{iexp})
        inputs.OEDsol.tcon_guess{iexp}=union([0.75*pulse_duration:pulse_duration:inputs.OEDsol.tf_guess{iexp}-pulse_duration],inputs.OEDsol.tf_guess{iexp});
        end
        inputs.OEDsol.tcon_max{iexp}=[1.0*pulse_duration:pulse_duration:1.0*inputs.OEDsol.tf_max{iexp}];

        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.tcon_guess{iexp}(1:inputs.exps.n_pulses{iexp}*2-1)];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.tcon_min{iexp}(1:inputs.exps.n_pulses{iexp}*2-1)];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.tcon_max{iexp}(1:inputs.exps.n_pulses{iexp}*2-1)];
      
      case 'stepf'

        if isempty(inputs.OEDsol.u_guess{iexp})==1
        for iu=1:inputs.model.n_stimulus
            inputs.OEDsol.u_guess{iexp}(iu,1:inputs.exps.n_steps{iexp})=mean([inputs.OEDsol.u_min{iexp}(iu,1:inputs.exps.n_steps{iexp}); inputs.OEDsol.u_max{iexp}(iu,1:inputs.exps.n_steps{iexp})]);
        end    
        end

        for iu=1:inputs.model.n_stimulus    
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.u_guess{iexp}(iu,1:inputs.exps.n_steps{iexp})];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.u_min{iexp}(iu,1:inputs.exps.n_steps{iexp})];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.u_max{iexp}(iu,1:inputs.exps.n_steps{iexp})];               
        end    
        

        if isempty(inputs.exps.t_con{iexp})
        step_duration=(inputs.OEDsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/inputs.OEDsol.n_steps{iexp};      
        inputs.OEDsol.tcon_guess{iexp}=[inputs.exps.t_in{1}:step_duration:inputs.OEDsol.tf_guess{iexp}];
        else
        inputs.OEDsol.tcon_guess{iexp}=inputs.exps.t_con{iexp};    
      
        end

                
        
      case 'step'

        if isempty(inputs.OEDsol.u_guess{iexp})==1
        for iu=1:inputs.model.n_stimulus
            inputs.OEDsol.u_guess{iexp}(iu,1:inputs.exps.n_steps{iexp})=mean([inputs.OEDsol.u_min{iexp}(iu,1:inputs.exps.n_steps{iexp}); inputs.OEDsol.u_max{iexp}(iu,1:inputs.exps.n_steps{iexp})]);
        end    
        end

        for iu=1:inputs.model.n_stimulus    
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.u_guess{iexp}(iu,1:inputs.exps.n_steps{iexp})];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.u_min{iexp}(iu,1:inputs.exps.n_steps{iexp})];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.u_max{iexp}(iu,1:inputs.exps.n_steps{iexp})];               
        end    

        
        if inputs.exps.n_steps{iexp}==2
        inputs.OEDsol.tcon_guess{iexp}=[inputs.OEDsol.tf_min{iexp} inputs.OEDsol.tf_guess{iexp}];
        inputs.OEDsol.tcon_min{iexp}=[0 inputs.OEDsol.tf_max{iexp}/2];    
        inputs.OEDsol.tcon_max{iexp}=[inputs.OEDsol.tf_min{iexp} inputs.OEDsol.tf_max{iexp}];
        else 
        step_duration=(inputs.OEDsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/inputs.exps.n_steps{iexp};  
        inputs.OEDsol.tcon_guess{iexp}=[step_duration:step_duration:inputs.OEDsol.tf_guess{iexp}];
        inputs.OEDsol.tcon_min{iexp}=[step_duration/2:step_duration:inputs.OEDsol.tf_min{iexp}];
               if size(inputs.OEDsol.tcon_min{iexp},2)==inputs.exps.n_steps{iexp}; %% MRG
        if inputs.OEDsol.tcon_min{iexp}(inputs.exps.n_steps{iexp})~=inputs.OEDsol.tf_min{iexp} 
            inputs.OEDsol.tcon_min{iexp}(inputs.exps.n_steps{iexp})=inputs.OEDsol.tf_min{iexp};
        end
        else inputs.OEDsol.tcon_min{iexp}(inputs.exps.n_steps{iexp})=inputs.OEDsol.tf_min{iexp}; end%%MRG
        inputs.OEDsol.tcon_max{iexp}=[2*step_duration:step_duration:inputs.OEDsol.tf_max{iexp} inputs.OEDsol.tf_max{iexp}];
         
        if inputs.OEDsol.tcon_max{iexp}(inputs.exps.n_steps{iexp})~=inputs.OEDsol.tf_max{iexp}
            inputs.OEDsol.tcon_max{iexp}(inputs.exps.n_steps{iexp})=inputs.OEDsol.tf_max{iexp};
        end
        end     %if inputs.exps.n_steps{iexp}==1 
        
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.tcon_guess{iexp}];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.tcon_min{iexp}];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.tcon_max{iexp}(1:inputs.exps.n_steps{iexp})]; 
       
        
       case 'linear'
        
        if isempty(inputs.OEDsol.u_guess{iexp})==1
        for iu=1:inputs.model.n_stimulus
            inputs.OEDsol.u_guess{iexp}(iu,1:inputs.exps.n_linear{iexp})=mean([inputs.OEDsol.u_min{iexp}(iu,1:inputs.exps.n_linear{iexp}); inputs.OEDsol.u_max{iexp}(iu,1:inputs.exps.n_linear{iexp})]);
        end    
        end

        for iu=1:inputs.model.n_stimulus    
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.u_guess{iexp}(iu,1:inputs.exps.n_linear{iexp})];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.u_min{iexp}(iu,1:inputs.exps.n_linear{iexp})];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.u_max{iexp}(iu,1:inputs.exps.n_linear{iexp})];               
        end    
        

        step_duration=(inputs.OEDsol.tf_guess{iexp}-inputs.exps.t_in{iexp})/(inputs.exps.n_linear{iexp}-1);  
        if isempty(inputs.OEDsol.tcon_guess{iexp})
        inputs.OEDsol.tcon_guess{iexp}=[step_duration:step_duration:inputs.OEDsol.tf_guess{iexp}];
        end
        inputs.OEDsol.tcon_min{iexp}=[step_duration/2:step_duration:inputs.OEDsol.tf_min{iexp}];
        if inputs.OEDsol.tcon_min{iexp}(inputs.exps.n_linear{iexp}-1)~=inputs.OEDsol.tf_min{iexp}
            inputs.OEDsol.tcon_min{iexp}(inputs.exps.n_linear{iexp}-1)=inputs.OEDsol.tf_min{iexp};
        end
        inputs.OEDsol.tcon_max{iexp}=[1.5*step_duration:step_duration:inputs.OEDsol.tf_max{iexp} inputs.OEDsol.tf_max{iexp}];

        if inputs.OEDsol.tcon_max{iexp}(inputs.exps.n_linear{iexp}-1)~=inputs.OEDsol.tf_max{iexp}
            inputs.OEDsol.tcon_max{iexp}(inputs.exps.n_linear{iexp}-1)=inputs.OEDsol.tf_max{iexp};
        end
       
        
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess inputs.OEDsol.tcon_guess{iexp}];
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min inputs.OEDsol.tcon_min{iexp}];
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.tcon_max{iexp}(1:inputs.exps.n_linear{iexp}-1)];    
   
      
        
        end; %switch inputs.exps.u_interp{iexp} 
   
   end;  %switch inputs.exps.u_type{iexp}  
   
     
   end; %for iexp=1:inputs.exps.n_exp    

   
%
% Adding observables for all experiments   
%     
 inputs.OEDsol.n_obs_od=0;
 inputs.OEDsol.exp_obs_od=[];
   for iexp=1:inputs.exps.n_exp                                                           
   switch inputs.exps.obs_type{iexp} 
       
     case 'fixed'
       inputs.OEDsol.obs_guess{iexp}=inputs.exps.obs{iexp};
       inputs.OEDsol.n_obs{iexp}=inputs.exps.n_obs{iexp};
       privstruct.w_obs{iexp}=ones(1,inputs.OEDsol.n_obs{iexp});
          
      case 'od'               
        inputs.OEDsol.obs_guess{iexp}=inputs.exps.obs{iexp};
        inputs.OEDsol.n_obs{iexp}=inputs.exps.n_obs{iexp};
        inputs.OEDsol.index_obs_guess{iexp}=inputs.exps.index_obs_guess{iexp};
        if isempty(inputs.OEDsol.index_obs_guess{iexp})
        privstruct.w_obs{iexp}=[1 zeros(1,inputs.OEDsol.n_obs{iexp}-1)]; %0.51.*ones(1,inputs.OEDsol.n_obs{iexp});      
        else
        privstruct.w_obs{iexp}=inputs.OEDsol.index_obs_guess{iexp};    
        end    
        inputs.OEDsol.voed_guess=[inputs.OEDsol.voed_guess privstruct.w_obs{iexp}];  
        inputs.OEDsol.voed_min=[inputs.OEDsol.voed_min zeros(1,inputs.OEDsol.n_obs{iexp})];
%         if isempty(inputs.OEDsol.index_obs_max{iexp})
        inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max ones(1,inputs.OEDsol.n_obs{iexp})];
%         else
%         inputs.OEDsol.voed_max=[inputs.OEDsol.voed_max inputs.OEDsol.index_obs_max{iexp}];
%         end    
        inputs.OEDsol.n_obs_od=inputs.OEDsol.n_obs_od+1;
        inputs.OEDsol.exp_obs_od=[inputs.OEDsol.exp_obs_od iexp];
     end;  end;  


end; %if (inputs.model.n_stimulus==0)



