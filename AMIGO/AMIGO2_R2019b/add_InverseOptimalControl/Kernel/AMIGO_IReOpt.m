%% Mesh refinement technique
%  AMIGO_ReOpt: performs a mesh refining an re-optimizes
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
%  This script will be used for stepf control interpolations
%  the underlying idea is to iteratively increase control discretization
%  level. Typically run with local optimizers.
%%

%% Reads previous optimal solution and refines control discretization

                results.ioc.reopt.t_f{1}=results.ioc.t_f;
                results.ioc.reopt.u{1}=results.ioc.u;
                results.ioc.reopt.t_con{1}=results.ioc.t_con;
                results.ioc.reopt.fbest{1}=results.nlpsol.fbest;
                results.ioc.reopt.cpu_time{1}=results.nlpsol.cpu_time;
                       
              
               
                switch inputs.IOCsol.u_interp
                
                case 'stepf'                 
                  
                  for iopt=1:inputs.nlpsol.n_reOpts
                      
                  if inputs.IOCsol.n_par>0, results.ioc.reopt.upar{iopt}=results.ioc.upar; inputs.IOCsol.par_guess=results.ioc.reopt.upar{iopt};end    
                  for iexp=1:inputs.exps.n_exp    
                  inputs.IOCsol.tf_guess=results.ioc.t_f;
                  inputs.IOCsol.n_steps{iexp}=2*inputs.IOCsol.n_steps{iexp};
                  inputs.exps.n_steps=inputs.IOCsol.n_steps;
                  for iu=1:inputs.model.n_stimulus
                  count_step=1;    
                  for istep=1:inputs.IOCsol.n_steps{iexp}/2    
                  inputs.IOCsol.u_guess{iexp}(iu,count_step)=results.ioc.u{iexp}(iu,istep);
                  inputs.IOCsol.u_guess{iexp}(iu,count_step+1)=results.ioc.u{iexp}(iu,istep);
                  inputs.IOCsol.u_min{iexp}(iu,count_step)=inputs.IOCsol.u_min{iexp}(iu,istep);
                  inputs.IOCsol.u_min{iexp}(iu,count_step+1)=inputs.IOCsol.u_min{iexp}(iu,istep);
                  inputs.IOCsol.u_max{iexp}(iu,count_step)=inputs.IOCsol.u_max{iexp}(iu,istep);
                  inputs.IOCsol.u_max{iexp}(iu,count_step+1)=inputs.IOCsol.u_max{iexp}(iu,istep);
                  
                  if ~isempty(inputs.IOCsol.u_ref{iexp})
                  inputs.IOCsol.u_ref{iexp}(iu,count_step)=results.ioc.u{iexp}(iu,istep);
                  inputs.IOCsol.u_ref{iexp}(iu,count_step+1)=results.ioc.u{iexp}(iu,istep);
                  end
                                   
                  
                  count_step=count_step+2;
                  end %for istep=1:inputs.IOCsol.n_steps{iexp}/2 
                  end %for iu=1:inputs.model.n_stimulus
                  inputs.IOCsol.t_con{iexp}=[0:inputs.IOCsol.tf_guess{iexp}/inputs.IOCsol.n_steps{iexp}:inputs.IOCsol.tf_guess{iexp}];
                  end %for iexp=1:inputs.exps.n_exp  
                  
                  
                  
 %%              
 % * Calls AMIGO_initi_OD_guess_bounds
 
%% Generation of the cost function and constraints

                AMIGO_init_IOC_guess_bounds
%%
% * Calls AMIGO_gen_DOcost 

             
                [inputs,results]=AMIGO_gen_IOCcost(inputs,inputs.nlpsol.reopt,iopt);

%% Starts successive reoptimizations

%%
% * Calls AMIGO_call_ODOPTsolver             
                fprintf(1,'\n\n>>>>> RE-OPTIMIZATION %u\n\n', iopt);
                inputs.ivpsol.rtol=0.1*inputs.ivpsol.rtol;
                inputs.ivpsol.atol=0.1*inputs.ivpsol.atol;
                [results]=AMIGO_call_IOCOPTsolver(inputs.nlpsol.reopt_solver,inputs.IOCsol.vdo_guess,inputs.IOCsol.vdo_min,inputs.IOCsol.vdo_max,inputs,results,privstruct);        
              
%% Keeps outputs in the results.ioc structure and gives control back to AMIGO_OD for postprocessing              
                privstruct.ioc=results.nlpsol.vbest;
                [privstruct,inputs,results]=AMIGO_transform_ioc(inputs,results,privstruct);
              
                results.ioc.t_f=privstruct.t_f;
                results.ioc.u=privstruct.u;
                results.ioc.t_con=privstruct.t_con; 
                if inputs.IOCsol.n_par>0, results.ioc.upar=privstruct.upar;results.ioc.reopt.upar{iopt}=privstruct.upar;end
                results.ioc.reopt.t_f{iopt+1}=results.ioc.t_f;
                results.ioc.reopt.u{iopt+1}=results.ioc.u;
                results.ioc.reopt.t_con{iopt+1}=results.ioc.t_con;
                results.ioc.reopt.fbest{iopt+1}=results.nlpsol.fbest;
                results.ioc.reopt.cpu_time{iopt+1}=results.nlpsol.cpu_time;
                
               end %for iopt=1:inputs.nlpsol.n_reOpts
                
                  
               case 'linearf'
                 
                  
                  for iopt=1:inputs.nlpsol.n_reOpts
                  if inputs.IOCsol.n_par>0, results.ioc.reopt.upar{iopt}=results.ioc.upar; inputs.IOCsol.par_guess=results.ioc.reopt.upar{iopt};end    
                  for iexp=1:inputs.exps.n_exp  
                  inputs.IOCsol.tf_guess=results.ioc.t_f;
                  inputs.IOCsol.n_linear{iexp}=2*inputs.IOCsol.n_linear{iexp};
                  inputs.exps.n_linear=inputs.IOCsol.n_linear;
                  for iu=1:inputs.model.n_stimulus
                  count_step=1;    
                  for istep=1:inputs.IOCsol.n_linear{iexp}/2    
                  inputs.IOCsol.u_guess{iexp}(iu,count_step)=results.ioc.u{iexp}(iu,istep);
                  inputs.IOCsol.u_guess{iexp}(iu,count_step+1)=results.ioc.u{iexp}(iu,istep);
                  inputs.IOCsol.u_min{iexp}(iu,count_step)=inputs.IOCsol.u_min{iexp}(iu,istep);
                  inputs.IOCsol.u_min{iexp}(iu,count_step+1)=inputs.IOCsol.u_min{iexp}(iu,istep);
                  inputs.IOCsol.u_max{iexp}(iu,count_step)=inputs.IOCsol.u_max{iexp}(iu,istep);
                  inputs.IOCsol.u_max{iexp}(iu,count_step+1)=inputs.IOCsol.u_max{iexp}(iu,istep);
                  if ~isempty(inputs.IOCsol.u_ref{iexp})
                  inputs.IOCsol.u_ref{iexp}(iu,count_step)=results.ioc.u{iexp}(iu,istep);
                  inputs.IOCsol.u_ref{iexp}(iu,count_step+1)=results.ioc.u{iexp}(iu,istep);
                  end
                  count_step=count_step+2;
                  end % for istep=1:inputs.IOCsol.n_linear{iexp}/2 
                  end %for iu=1:inputs.model.n_stimulus
                  inputs.IOCsol.t_con{iexp}=linspace(0,inputs.exps.t_f{iexp},inputs.IOCsol.n_linear{iexp});
                  end %for iexp=1:inputs.exps.n_exp
                  
 %%              
 % * Calls AMIGO_initi_OD_guess_bounds
 
%% Generation of the cost function and constraints

                AMIGO_init_IOC_guess_bounds
%%
% * Calls AMIGO_gen_DOcost 

             
              [results]=AMIGO_gen_IOCcost(inputs,inputs.nlpsol.reopt,iopt);

%% Starts successive reoptimizations

%%
% * Calls AMIGO_call_ODOPTsolver             
              fprintf(1,'\n\n>>>>> RE-OPTIMIZATION %u\n\n', iopt);
              inputs.ivpsol.rtol=0.1*inputs.ivpsol.rtol;
              inputs.ivpsol.atol=0.1*inputs.ivpsol.atol;
              [results]=AMIGO_call_IOCOPTsolver(inputs.nlpsol.reopt_solver,inputs.IOCsol.vdo_guess,inputs.IOCsol.vdo_min,inputs.IOCsol.vdo_max,inputs,results,privstruct);        
              
%% Keeps outputs in the results.ioc structure and gives control back to AMIGO_DO for postprocessing              
              privstruct.ioc=results.nlpsol.vbest;
              [privstruct,inputs,results]=AMIGO_transform_IOC(inputs,results,privstruct);
              
              results.ioc.t_f=privstruct.t_f;
              results.ioc.u=privstruct.u;
              results.ioc.t_con=privstruct.t_con; 
              if inputs.IOCsol.n_par>0, results.ioc.upar=privstruct.upar;results.ioc.reopt.upar{iopt}=privstruct.upar;end
          
                results.ioc.reopt.t_f{iopt+1}=results.ioc.t_f;
                results.ioc.reopt.u{iopt+1}=results.ioc.u;
                results.ioc.reopt.t_con{iopt+1}=results.ioc.t_con;
                results.ioc.reopt.fbest{iopt+1}=results.nlpsol.fbest;
                results.ioc.reopt.cpu_time{iopt+1}=results.nlpsol.cpu_time;
              
               end %for iopt=1:inputs.nlpsol.n_reOpts
                  
                  
                  
               
                
                end %switch inputs.IOCsol.u_interp