%% Transforms vector of decision variables into controls and process duration
%
% [privstruct,inputs]=AMIGO_transform_od(inputs,results,privstruct)
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
%  Script that generates:
%           - Final time
%           - Control values (steps, linear interpolation)
%           - Elements durations
% from the decision variables vector (privstruct.do)
%%


function [privstruct,inputs,results]=AMIGO_transform_do(inputs,results,privstruct);
vector_do=privstruct.do;
privstruct.iflag=2;   
if size(vector_do,1)>1
privstruct.do=vector_do';
end


% EBC -- consider the case with initial conditions to be designed
privstruct.y0{1}=inputs.DOsol.y0;
 
if inputs.DOsol.n_y0>0
 privstruct.y0{1}(inputs.DOsol.index_y0)=privstruct.do(1,1:inputs.DOsol.n_y0);
 privstruct.uy0=privstruct.do(1,1:inputs.DOsol.n_y0);
end



% EBC -- consider the case with parameters /sustained stimulation and time
% varying stimulation
privstruct.par{1}=inputs.model.par;
 
if inputs.DOsol.n_par>0
 privstruct.par{1}(inputs.DOsol.index_par)=privstruct.do(1,inputs.DOsol.n_y0+1:inputs.DOsol.n_y0+inputs.DOsol.n_par);
 privstruct.upar=privstruct.do(1,inputs.DOsol.n_y0+1:inputs.DOsol.n_y0+inputs.DOsol.n_par);
end

  
%% Final time     

    conttf=inputs.DOsol.n_y0+inputs.DOsol.n_par;
    jexp=0;
  

    
    switch inputs.DOsol.tf_type
        case 'od'
                  switch inputs.exps.u_interp{1}  
                  case {'stepf','linearf'}
                  privstruct.t_f{1}=privstruct.do(conttf+1);
                  conttf=conttf+1;
                  end
        case 'fixed'
                  privstruct.t_f{1}=inputs.DOsol.tf_guess;
     end; 


%% Stimulation
%
contu=conttf;

  
      switch inputs.exps.u_interp{1}     

%%
% *  Sustained stimulation          
      case 'sustained'                 
          
        inputs.exps.u{1}=privstruct.do(contu+1:contu+inputs.model.n_stimulus);   
        privstruct.t_con{1}=[inputs.exps.t_in{1} privstruct.t_f{1}];
        privstruct.n_steps{1}=1;
        contu=contu+inputs.model.n_stimulus;
        
%%
% *  Pulse-up stimulation ___|---|___   
      case 'pulse-up'  %  ___|---|___                  
        
        inputs.exps.u{1}=[repmat([inputs.exps.u_min{1} inputs.exps.u_max{1}],1,inputs.exps.n_pulses{1}) inputs.exps.u_min{1}];
        privstruct.t_con{1}=[inputs.exps.t_in{1} privstruct.do(contu+1:contu+2*inputs.exps.n_pulses{1})];
        contu=contu+2*inputs.exps.n_pulses{1};
        privstruct.n_steps{1}=2*inputs.exps.n_pulses{1}+1;
        privstruct.t_con{1}(privstruct.n_steps{1}+1)=privstruct.t_f{1};
 
%%
% *  Pulse-down stimulation |---|_____  
        
      case 'pulse-down'% |---|_____

        inputs.exps.u{1}=[repmat([inputs.exps.u_max{1} inputs.exps.u_min{1}],1,inputs.exps.n_pulses{1})];
 
        privstruct.t_con{1}=[inputs.exps.t_in{1} privstruct.do(contu+1:contu+2*inputs.exps.n_pulses{1}-1)];
        contu=contu+2*inputs.exps.n_pulses{1}-1;
        privstruct.n_steps{1}=2*inputs.exps.n_pulses{1}+1;
        privstruct.t_con{1}(privstruct.n_steps{1})=privstruct.t_f{1};
%%
% *  Step-wise stimulation, elements of free duration       
      case 'step'
      
        for iu=1:inputs.model.n_stimulus   
        inputs.exps.u{1}(iu,:)=privstruct.do(contu+1:contu+inputs.DOsol.n_steps);
        contu=contu+inputs.DOsol.n_steps;
        end
        
        contt_con=contu;      
        if sum(privstruct.do(contt_con+1:contt_con+inputs.DOsol.n_steps-1))>inputs.DOsol.tf_max
        privstruct.iflag=-2;  
        else
        privstruct.t_con{1}(1,1)=inputs.exps.t_in{1};
        for icon=2:inputs.DOsol.n_steps
        privstruct.t_con{1}(1,icon)=privstruct.t_con{1}(1,icon-1)+privstruct.do(contt_con+icon-1);
        end
        end
        privstruct.t_con{1}(1,inputs.DOsol.n_steps+1)=sum(privstruct.do(contt_con+1:contt_con+inputs.DOsol.n_steps-1));
        contu=contu+inputs.DOsol.n_steps-1;
        privstruct.n_steps{1}=inputs.DOsol.n_steps;
        
            
        switch inputs.DOsol.tf_type
        case 'od'
            privstruct.t_f{1}=privstruct.t_con{1}(1,inputs.DOsol.n_steps+1);
            conttf=conttf+1;
        case 'fixed'
            privstruct.t_con{1}(1,inputs.DOsol.n_steps+1)=inputs.DOsol.tf_guess;             
            conttf=conttf+1;     
        end;        
        
%%
% *  Step-wise stimulation, elements of fixed duration       
        
       case 'stepf'
       
        privstruct.n_steps{1}=inputs.DOsol.n_steps;
        step_duration=(privstruct.t_f{1}-inputs.exps.t_in{1})/inputs.DOsol.n_steps;
        privstruct.t_con{1}=[inputs.exps.t_in{1}:step_duration:privstruct.t_f{1}];
        for iu=1:inputs.model.n_stimulus  
        inputs.exps.u{1}(iu,1:inputs.DOsol.n_steps)=privstruct.do(contu+1:contu+inputs.DOsol.n_steps);
        contu=contu+inputs.DOsol.n_steps;
        end
        
%%
% *  Linear-wise stimulation, elements of fixed duration      
                
        case 'linearf'
       
        privstruct.n_linear{1}=inputs.DOsol.n_linear;
        step_duration=(privstruct.t_f{1}-inputs.exps.t_in{1})/(inputs.DOsol.n_linear-1);
        privstruct.t_con{1}=[inputs.exps.t_in{1}:step_duration:privstruct.t_f{1}];
        for iu=1:inputs.model.n_stimulus  
        inputs.exps.u{1}(iu,1:inputs.DOsol.n_linear)=privstruct.do(contu+1:contu+inputs.DOsol.n_linear);
        contu=contu+inputs.DOsol.n_linear;
        end
        
        
        
%%
% *  Linear-wise stimulation, elements of free duration      
        
        case 'linear'
            
        % Control values
        for iu=1:inputs.model.n_stimulus   
        inputs.exps.u{1}(iu,:)=privstruct.do(contu+1:contu+inputs.DOsol.n_linear);
        contu=contu+inputs.DOsol.n_linear;
        end
        contt_con=contu;    
        
        % CVP t nodes
        privstruct.t_con{1}=zeros(1,inputs.DOsol.n_linear);         
            switch inputs.DOsol.tf_type
        
                case 'fixed'
                  
                  privstruct.t_con{1}(1,1)=inputs.exps.t_in{1};
                  for icon=2:inputs.DOsol.n_linear-1
                  privstruct.t_con{1}(1,icon)=privstruct.t_con{1}(1,icon-1)+privstruct.do(contt_con+icon-1);
                  deltat=inputs.DOsol.tf_guess/500;
                  if privstruct.t_con{1}(1,icon)>inputs.DOsol.tf_guess 
                  privstruct.t_con{1}(1,icon)=inputs.DOsol.tf_guess-(inputs.DOsol.n_linear-icon)*deltat; % no se permite solapamiento
                  end                
                  end
                  privstruct.t_con{1}(1,inputs.DOsol.n_linear)=inputs.DOsol.tf_guess;             
                  privstruct.t_f{1}=inputs.DOsol.tf_guess;
                  privstruct.t_con{1}=sort(privstruct.t_con{1});
                case 'od'
                  privstruct.t_con{1}(1,1)=inputs.exps.t_in{1};
                  for icon=2:inputs.DOsol.n_linear-1
                  privstruct.t_con{1}(1,icon)=privstruct.t_con{1}(1,icon-1)+privstruct.do(contt_con+icon-1);
                  end    
                  privstruct.t_con{1}(1,inputs.DOsol.n_linear)=sum(privstruct.do(contt_con+1:contt_con+inputs.DOsol.n_linear-1)); 
                  % If constraint on max time is violated times are
                  % resampled
                  if privstruct.t_con{1}(1,inputs.DOsol.n_linear)>inputs.DOsol.tf_max
                  for icon=1:inputs.DOsol.n_linear    
                  privstruct.t_con{1}(1,icon)=(privstruct.t_con{1}(1,icon)/privstruct.t_con{1}(1,inputs.DOsol.n_linear))*inputs.DOsol.tf_max; 
                  end
                  end
                  privstruct.t_f{1}=privstruct.t_con{1}(1,inputs.DOsol.n_linear);         
            end              
    %        contu=contu+inputs.DOsol.n_linear-2;
    %        privstruct.n_steps{1}=inputs.DOsol.n_linear-1;      
            
                
        
        end %switch inputs.exps.u_interp{1} 
           


   % INTEGRATION TIMES
  
    privstruct.t_s{1}=privstruct.t_con{1}; %[inputs.exps.t_in{1} inputs.DOsol.tpointc privstruct.t_f{1}];
    privstruct.vtout{1}=sort(union(privstruct.t_s{1},privstruct.t_con{1}));
    privstruct.t_int{1}=privstruct.t_s{1};
    inputs.exps.t_con{1}=privstruct.t_con{1};
    privstruct.u{1}=inputs.exps.u{1};
    

    return;
    
    
    