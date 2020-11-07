%% Transforms vector of decision variables into controls, parameters, initial conditions and process duration
%
% [privstruct,inputs]=AMIGO_transform_od(inputs,results,privstruct)
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
%  Script that generates:
%           - Final time
%           - Control values (steps, linear interpolation)
%           - Elements durations
% from the decision variables vector (privstruct.ioc)
%%


function [privstruct,inputs,results]=AMIGO_transform_ioc(inputs,results,privstruct);
vector_IOC=privstruct.ioc;
privstruct.iflag=2;   
if size(vector_IOC,1)>1
privstruct.ioc=vector_IOC';
end

% EBC -- consider the case with initial conditions to be designed
%        needs update for the multi-experiment case


for iexp=1:inputs.exps.n_exp
 privstruct.y_0{iexp}=inputs.exps.exp_y0{iexp};
if inputs.IOCsol.n_y0>0
 privstruct.y_0{iexp}(inputs.IOCsol.index_y0)=privstruct.ioc(1,1:inputs.IOCsol.n_y0);
 privstruct.uy0=privstruct.ioc(1,1:inputs.IOCsol.n_y0);
end
end


% EBC -- consider the case with parameters /sustained stimulation and time
% varying stimulation

for iexp=1:inputs.exps.n_exp
privstruct.par{iexp}=inputs.model.par;

if inputs.IOCsol.n_par>0
 privstruct.par{iexp}(inputs.IOCsol.index_par)=privstruct.ioc(1,inputs.IOCsol.n_y0+1:inputs.IOCsol.n_y0+inputs.IOCsol.n_par);
 privstruct.upar=privstruct.ioc(1,inputs.IOCsol.n_y0+1:inputs.IOCsol.n_y0+inputs.IOCsol.n_par);
end
end
  
%% Final time     

    conttf=inputs.IOCsol.n_y0+inputs.IOCsol.n_par;
    jexp=0;
  

    for iexp=1:inputs.exps.n_exp
    switch inputs.IOCsol.tf_type
        case 'od'
                  switch inputs.IOCsol.u_interp  
                  case {'stepf','linearf'}
                  privstruct.t_f{iexp}=privstruct.ioc(conttf+1);
                  conttf=conttf+1;
                  end
        case 'fixed'
                  privstruct.t_f{iexp}=inputs.IOCsol.tf_guess{iexp};
     end; 
    end

%% Stimulation
%
contu=conttf;



      switch inputs.IOCsol.u_interp 

%%
% *  Sustained stimulation          
      case 'sustained'                 

        for iexp=1:inputs.exps.n_exp  
        inputs.exps.u{iexp}=privstruct.ioc(contu+1:contu+inputs.model.n_stimulus);   
        privstruct.t_con{iexp}=[inputs.exps.t_in{iexp} privstruct.t_f{iexp}];
        privstruct.n_steps{iexp}=1;
        contu=contu+inputs.model.n_stimulus;
        end
%%
% *  Pulse-up stimulation ___|---|___   
      case 'pulse-up'  %  ___|---|___                  
        
        for iexp=1:inputs.exps.n_exp  
        inputs.exps.u{iexp}=[repmat([inputs.exps.u_min{iexp} inputs.exps.u_max{iexp}],1,inputs.exps.n_pulses{iexp}) inputs.exps.u_min{iexp}];
        privstruct.t_con{iexp}=[inputs.exps.t_in{iexp} privstruct.ioc(contu+1:contu+2*inputs.exps.n_pulses{iexp})];
        contu=contu+2*inputs.exps.n_pulses{iexp};
        privstruct.n_steps{iexp}=2*inputs.exps.n_pulses{iexp}+1;
        privstruct.t_con{iexp}(privstruct.n_steps{iexp}+1)=privstruct.t_f{iexp};
        end
%%
% *  Pulse-down stimulation |---|_____  
        
      case 'pulse-down'% |---|_____
        for iexp=1:inputs.exps.n_exp  
        inputs.exps.u{iexp}=[repmat([inputs.exps.u_max{iexp} inputs.exps.u_min{iexp}],1,inputs.exps.n_pulses{iexp})];
 
        privstruct.t_con{iexp}=[inputs.exps.t_in{iexp} privstruct.ioc(contu+1:contu+2*inputs.exps.n_pulses{iexp}-1)];
        contu=contu+2*inputs.exps.n_pulses{iexp}-1;
        privstruct.n_steps{iexp}=2*inputs.exps.n_pulses{iexp}+1;
        privstruct.t_con{iexp}(privstruct.n_steps{iexp})=privstruct.t_f{iexp};
        end
%%
% *  Step-wise stimulation, elements of free duration       
      case 'step'
        for iexp=1:inputs.exps.n_exp  
        for iu=1:inputs.model.n_stimulus   
        inputs.exps.u{iexp}(iu,:)=privstruct.ioc(contu+1:contu+inputs.IOCsol.n_steps{iexp});
        contu=contu+inputs.IOCsol.n_steps{iexp};
        end
        
        contt_con=contu;      
        if sum(privstruct.ioc(contt_con+1:contt_con+inputs.IOCsol.n_steps{iexp}-1))>inputs.IOCsol.tf_max{iexp}
        privstruct.iflag=-2;  
        else
        privstruct.t_con{iexp}(1,1)=inputs.exps.t_in{iexp};
        for icon=2:inputs.IOCsol.n_steps{iexp}
        privstruct.t_con{iexp}(1,icon)=privstruct.t_con{iexp}(1,icon-1)+privstruct.ioc(contt_con+icon-1);
        end
        end
        privstruct.t_con{iexp}(1,inputs.IOCsol.n_steps{iexp}+1)=sum(privstruct.ioc(contt_con+1:contt_con+inputs.IOCsol.n_steps{iexp}-1));
        contu=contu+inputs.IOCsol.n_steps{iexp}-1;
        privstruct.n_steps{iexp}=inputs.IOCsol.n_steps{iexp};
        
            
        switch inputs.IOCsol.tf_type
        case 'od'
            privstruct.t_f{iexp}=privstruct.t_con{iexp}(1,inputs.IOCsol.n_steps{iexp}+1);
            conttf=conttf+1;
        case 'fixed'
            privstruct.t_con{iexp}(1,inputs.IOCsol.n_steps{iexp}+1)=inputs.IOCsol.tf_guess{iexp};             
            conttf=conttf+1;     
        end;        
        end      
%%
% *  Step-wise stimulation, elements of fixed duration       
        
       case 'stepf'
        for iexp=1:inputs.exps.n_exp
        privstruct.n_steps{iexp}=inputs.IOCsol.n_steps{iexp};
        privstruct.t_con{iexp}=inputs.IOCsol.tcon_guess{iexp};
        for iu=1:inputs.model.n_stimulus  
        inputs.exps.u{iexp}(iu,1:inputs.IOCsol.n_steps{iexp})=privstruct.ioc(contu+1:contu+inputs.IOCsol.n_steps{iexp});
        contu=contu+inputs.IOCsol.n_steps{iexp};
        end

        end
%%
% *  Linear-wise stimulation, elements of fixed duration      
                
        case 'linearf'
       for iexp=1:inputs.exps.n_exp
        privstruct.n_linear{iexp}=inputs.IOCsol.n_linear{iexp};
    
        privstruct.t_con{iexp}=inputs.IOCsol.tcon_guess{iexp};
           
        for iu=1:inputs.model.n_stimulus  
        inputs.exps.u{iexp}(iu,1:inputs.IOCsol.n_linear{iexp})=privstruct.ioc(contu+1:contu+inputs.IOCsol.n_linear{iexp});
        contu=contu+inputs.IOCsol.n_linear{iexp};
        end
       end
        
        
        
%%
% *  Linear-wise stimulation, elements of free duration      
        
        case 'linear'
            
        % Control values
        for iexp=1:inputs.exps.n_exp
        for iu=1:inputs.model.n_stimulus   
        inputs.exps.u{iexp}(iu,:)=privstruct.ioc(contu+1:contu+inputs.IOCsol.n_linear{iexp});
        contu=contu+inputs.IOCsol.n_linear{iexp};
        end
        contt_con=contu;    
        
        % CVP t nodes
        privstruct.t_con{iexp}=zeros(1,inputs.IOCsol.n_linear{iexp});         
            switch inputs.IOCsol.tf_type
        
                case 'fixed'
                  
                  privstruct.t_con{iexp}(1,1)=inputs.exps.t_in{iexp};
                  
                  if max(privstruct.t_con{iexp})>inputs.IOCsol.tf_guess{iexp}
                  inputs.IOCsol.t_con{iexp}= linspace(0,inputs.exps.t_f{iexp},inputs.IOCsol.n_linear{iexp});
                  else
                      
                  for icon=2:inputs.IOCsol.n_linear{iexp}-1
                  privstruct.t_con{iexp}(1,icon)=privstruct.t_con{iexp}(1,icon-1)+privstruct.ioc(contt_con+icon-1);
                  deltat=inputs.IOCsol.tf_guess{iexp}/500;
%                   if privstruct.t_con{iexp}(1,icon)>inputs.IOCsol.tf_guess{iexp} 
%                   privstruct.t_con{iexp}(1,icon)=inputs.IOCsol.tf_guess{iexp}-(inputs.IOCsol.n_linear{iexp}-icon)*deltat; % no se permite solapamiento
%                   end                
                  end
                  end
                  privstruct.t_con{iexp}(1,inputs.IOCsol.n_linear{iexp})=inputs.IOCsol.tf_guess{iexp};             
                  privstruct.t_f{iexp}=inputs.IOCsol.tf_guess{iexp};
                  privstruct.t_con{iexp}=sort(privstruct.t_con{iexp});
                case 'od'
                  privstruct.t_con{iexp}(1,1)=inputs.exps.t_in{iexp};
                  for icon=2:inputs.IOCsol.n_linear{iexp}-1
                  privstruct.t_con{iexp}(1,icon)=privstruct.t_con{iexp}(1,icon-1)+privstruct.ioc(contt_con+icon-1);
                  end    
                  privstruct.t_con{iexp}(1,inputs.IOCsol.n_linear{iexp})=sum(privstruct.ioc(contt_con+1:contt_con+inputs.IOCsol.n_linear{iexp}-1)); 
                  % If constraint on max time is violated times are
                  % resampled
                  if privstruct.t_con{iexp}(1,inputs.IOCsol.n_linear{iexp})>inputs.IOCsol.tf_max{iexp}
                  for icon=1:inputs.IOCsol.n_linear{iexp}    
                  privstruct.t_con{iexp}(1,icon)=(privstruct.t_con{iexp}(1,icon)/privstruct.t_con{iexp}(1,inputs.IOCsol.n_linear{iexp}))*inputs.IOCsol.tf_max{iexp}; 
                  end
                  end
                  privstruct.t_f{iexp}=privstruct.t_con{iexp}(1,inputs.IOCsol.n_linear{iexp});         
            end              
    %        contu=contu+inputs.IOCsol.n_linear{iexp}-2;
    %        privstruct.n_steps{iexp}=inputs.IOCsol.n_linear{iexp}-1;      
        end
                
        
        end %switch inputs.exps.u_interp{iexp} 
           


   % INTEGRATION TIMES
    for iexp=1:inputs.exps.n_exp 
    privstruct.t_s{iexp}=inputs.exps.t_s{iexp}; %[inputs.exps.t_in{iexp} inputs.IOCsol.tpointc privstruct.t_f{iexp}];
    privstruct.vtout{iexp}=sort(union(privstruct.t_s{iexp},privstruct.t_con{iexp}));
    privstruct.t_int{iexp}=privstruct.t_s{iexp};
    inputs.exps.t_con{iexp}=privstruct.t_con{iexp};
    privstruct.u{iexp}=inputs.exps.u{iexp};
    end
    


return;
    
    
    