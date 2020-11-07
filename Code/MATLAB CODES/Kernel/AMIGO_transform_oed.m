% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_transform_oed.m 2480 2016-01-27 12:51:33Z evabalsa $


 function [privstruct,inputs]=AMIGO_transform_oed(inputs,results,privstruct);
% AMIGO_transform_oed: transforma decision variables into an OED
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
%**************************************************************************
%***%
%                                                                             %
%  AMIGO_transform_oed: transforma decision variables into an OED             %
%                                                                             %
%*****************************************************************************%

  
%
% Adding GLOBAL & LOCAL initial conditions for all experiments                                                 
%


if size(privstruct.oed,1)>1
    privstruct.oed=privstruct.oed';
end

nconty0=inputs.PEsol.n_global_theta_y0;


    for iexp=1:inputs.exps.n_exp
     switch inputs.exps.exp_y0_type{iexp}
       case 'od'      
            privstruct.y_0{iexp}=privstruct.oed(1:inputs.OEDsol.n_y0{iexp});
            nconty0=nconty0+inputs.OEDsol.n_y0{iexp};
    end; 
    end;  
    
    conty0=inputs.PEsol.n_global_theta_y0+sum(cell2mat(inputs.PEsol.n_local_theta_y0));
    
   
   
%
% Adding final time and sampling times for all experiments
%    
    

    conttf=nconty0;
    jexp=0;
    for iexp=1:inputs.exps.n_exp
    switch inputs.exps.tf_type{iexp}
        case 'od'
            jexp=jexp+1;
            privstruct.t_f{iexp}=privstruct.oed(conttf+1:nconty0+jexp);
            conttf=conttf+1;
            % Note that for final time 'od' and 'fixed' sampling times, these will be equidistant          
            privstruct.w_sampling{iexp}=ones(1,inputs.exps.n_s{iexp});      
            privstruct.t_s{iexp}=linspace(inputs.exps.ts_0{iexp},privstruct.t_f{iexp},inputs.exps.n_s{iexp});

        otherwise
           if strcmp(inputs.exps.ts_type{iexp},'fixed') 
           privstruct.w_sampling{iexp}=ones(1,inputs.exps.n_s{iexp});
           privstruct.t_s{iexp}=inputs.exps.t_s{iexp};
           end
     end; 

    end;


privstruct.contts=conttf;

   for iexp=1:inputs.exps.n_exp                                                           
   switch inputs.exps.ts_type{iexp}                                                           
      case 'od'      
        
        inputs.OEDsol.ts_guess{iexp}=[inputs.OEDsol.ts_0{iexp}:inputs.OEDsol.ts_min_dist{iexp}:inputs.OEDsol.tf_guess{iexp}];
        privstruct.w_sampling{iexp}=round(privstruct.oed(privstruct.contts+1:privstruct.contts+inputs.OEDsol.ns{iexp}));
          
        if inputs.OEDsol.ts_0{iexp}==0  
            % If it is allowed to meassure at t=0 we need a specific case
            % since w_sampling{}(1,1)*0 will be always 0 independently of
            % the weight
            
            ns=size(inputs.OEDsol.ts_guess{iexp},2);
            privstruct.w_sampling{iexp}=round(privstruct.oed(privstruct.contts+1:privstruct.contts+inputs.OEDsol.ns{iexp}));
            if privstruct.w_sampling{iexp}(1,1)==0
             index=find(privstruct.w_sampling{iexp}(1,2:1:ns).*inputs.OEDsol.ts_guess{iexp}(1,2:1:ns));
             privstruct.t_s{iexp}=inputs.OEDsol.ts_guess{iexp}(index);
                        if sum(privstruct.w_sampling{iexp})==0
                        privstruct.t_s{iexp}=unique(privstruct.w_sampling{iexp}.*inputs.OEDsol.ts_guess{iexp});
                        end
            privstruct.n_s{iexp}=size(privstruct.t_s{iexp},2);
            privstruct.contts=privstruct.contts+inputs.OEDsol.ns{iexp}; 
            end

            if privstruct.w_sampling{iexp}(1,1)==1
            privstruct.t_s{iexp}=unique(privstruct.w_sampling{iexp}.*inputs.OEDsol.ts_guess{iexp});
            privstruct.n_s{iexp}=size(privstruct.t_s{iexp},2);
            privstruct.contts=privstruct.contts+inputs.OEDsol.ns{iexp}; 
            end %privstruct.w_sampling{iexp}(1,1)==0                     
      
        else  
        privstruct.t_s{iexp}=unique(privstruct.w_sampling{iexp}.*inputs.OEDsol.ts_guess{iexp});
        privstruct.n_s{iexp}=size(privstruct.t_s{iexp},2);
        privstruct.contts=privstruct.contts+inputs.OEDsol.ns{iexp};   
        end %if inputs.OEDsol.ts_0{iexp}==0  
   
    end;  end;    
      

% STIMULATION

privstruct.contu=privstruct.contts;
if (inputs.model.n_stimulus==0)
    for iexp=1:inputs.exps.n_exp      
    inputs.OEDsol.u_guess{iexp}=0;
    inputs.exps.u{iexp}=0;
    inputs.exps.u_interp{iexp}='sustained';
    privstruct.t_con{iexp}=[inputs.exps.t_in{iexp} privstruct.t_f{iexp}];
    end
else


   for iexp=1:inputs.exps.n_exp
       
   switch inputs.exps.u_type{iexp}   
       
     case 'od' 
 
      switch inputs.exps.u_interp{iexp}     
       
      case 'sustained'                 
          
        inputs.exps.u{iexp}=privstruct.oed(privstruct.contu+1:privstruct.contu+inputs.model.n_stimulus)';   
        privstruct.t_con{iexp}=[inputs.exps.t_in{iexp} privstruct.t_f{iexp}];
        privstruct.n_steps{iexp}=1;
        privstruct.contu=privstruct.contu+inputs.model.n_stimulus;
       
      case 'pulse-up'  %  ___|---|___                  
        
        inputs.exps.u{iexp}=[repmat([inputs.exps.u_min{iexp} inputs.exps.u_max{iexp}],1,inputs.exps.n_pulses{iexp}) inputs.exps.u_min{iexp}];
        privstruct.t_con{iexp}=sort([inputs.exps.t_in{iexp} privstruct.oed(privstruct.contu+1:privstruct.contu+2*inputs.exps.n_pulses{iexp})]);
        privstruct.contu=privstruct.contu+2*inputs.exps.n_pulses{iexp};
        privstruct.n_steps{iexp}=2*inputs.exps.n_pulses{iexp}+1;
        privstruct.t_con{iexp}(privstruct.n_steps{iexp}+1)=privstruct.t_f{iexp};
        
      case 'pulse-down'% |---|_____

        inputs.exps.u{iexp}=[repmat([inputs.exps.u_max{iexp} inputs.exps.u_min{iexp}],1,inputs.exps.n_pulses{iexp})];
 
        privstruct.t_con{iexp}=sort([inputs.exps.t_in{iexp} privstruct.oed(privstruct.contu+1:privstruct.contu+2*inputs.exps.n_pulses{iexp}-1)]);
        privstruct.contu=privstruct.contu+2*inputs.exps.n_pulses{iexp}-1;
        privstruct.n_steps{iexp}=2*inputs.exps.n_pulses{iexp}+1;
        privstruct.t_con{iexp}(privstruct.n_steps{iexp})=privstruct.t_f{iexp};
      
       case 'stepf'
     
        for iu=1:inputs.model.n_stimulus   
        inputs.exps.u{iexp}(iu,:)=privstruct.oed(privstruct.contu+1:privstruct.contu+inputs.OEDsol.n_steps{iexp});
        privstruct.contu=privstruct.contu+inputs.OEDsol.n_steps{iexp};
        end
        contt_con=privstruct.contu;
        privstruct.t_con{iexp}=inputs.OEDsol.tcon_guess{iexp};
        privstruct.n_steps{iexp}=inputs.OEDsol.n_steps{iexp};

         
        
        
      case 'step'

        for iu=1:inputs.model.n_stimulus   
        inputs.exps.u{iexp}(iu,:)=privstruct.oed(privstruct.contu+1:privstruct.contu+inputs.OEDsol.n_steps{iexp});
        privstruct.contu=privstruct.contu+inputs.OEDsol.n_steps{iexp};
        end
        contt_con=privstruct.contu;
        privstruct.contu=privstruct.contu+1;
        privstruct.t_con{iexp}=sort([inputs.exps.t_in{iexp} privstruct.oed(contt_con+1:contt_con+inputs.OEDsol.n_steps{iexp})]);
        privstruct.contu=privstruct.contu+inputs.OEDsol.n_steps{iexp}-1;
        privstruct.n_steps{iexp}=inputs.OEDsol.n_steps{iexp};
        privstruct.t_con{iexp}(privstruct.n_steps{iexp}+1)=privstruct.t_f{iexp};
 
        case 'linear'
        
   
        for iu=1:inputs.model.n_stimulus   
        inputs.exps.u{iexp}(iu,:)=privstruct.oed(privstruct.contu+1:privstruct.contu+inputs.OEDsol.n_linear{iexp});
        privstruct.contu=privstruct.contu+inputs.OEDsol.n_linear{iexp};
        end

        contt_con=privstruct.contu;    
        privstruct.t_con{iexp}=sort([inputs.exps.t_in{iexp} privstruct.oed(contt_con+1:contt_con+inputs.OEDsol.n_linear{iexp}-1)]);
        privstruct.contu=privstruct.contu+inputs.OEDsol.n_linear{iexp}-1;
        privstruct.n_steps{iexp}=inputs.OEDsol.n_linear{iexp}-1;
        privstruct.t_con{iexp}(privstruct.n_linear{iexp})=privstruct.t_f{iexp};

       end; %switch inputs.exps.u_interp{iexp} 
       otherwise
        AMIGO_uinterp
        
        privstruct.t_con{iexp}=inputs.exps.t_con{iexp};
        
   end; %switch inputs.exps.u_type{iexp} 
    
   end; %for iexp=1:inputs.exps.n_exp  
end; %if (inputs.model.n_stimulus==0)




privstruct.contobs=privstruct.contu;


 for iexp=1:inputs.exps.n_exp                                                           
   switch inputs.exps.obs_type{iexp}                                                           
      case 'od'                     

        privstruct.w_obs{iexp}=round(privstruct.oed(privstruct.contu+1:privstruct.contu+inputs.OEDsol.n_obs{iexp}));
        inputs.exps.index_observables{iexp}=find(privstruct.w_obs{iexp}.*[1:1:inputs.OEDsol.n_obs{iexp}]);
    end;  end; 


   % INTEGRATION TIMES

    for iexp=1:inputs.exps.n_exp
    privstruct.vtout{iexp}=sort(union(privstruct.t_s{iexp},privstruct.t_con{iexp}));
    end

    privstruct.t_int=privstruct.t_s;
    inputs.exps.t_con=privstruct.t_con;
    
    
    return;
    
    
    