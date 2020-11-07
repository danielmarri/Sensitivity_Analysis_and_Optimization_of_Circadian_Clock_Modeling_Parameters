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

                results.do.reopt.t_f{1}=results.do.t_f;
                results.do.reopt.u{1}=results.do.u;
                results.do.reopt.t_con{1}=results.do.t_con;
                results.do.reopt.fbest{1}=results.nlpsol.fbest;
                results.do.reopt.cpu_time{1}=results.nlpsol.cpu_time;
                if inputs.DOsol.n_par>0, results.do.reopt.upar=results.do.upar;end
                switch inputs.DOsol.u_interp
                
                case 'stepf'
                  for iopt=1:inputs.nlpsol.n_reOpts
                  inputs.DOsol.tf_guess=results.do.t_f;
                  inputs.DOsol.n_steps=2*inputs.DOsol.n_steps;
                  inputs.exps.n_steps{1}=inputs.DOsol.n_steps;
                  for iu=1:inputs.model.n_stimulus
                  count_step=1;    
                  for istep=1:inputs.DOsol.n_steps/2    
                  inputs.DOsol.u_guess(iu,count_step)=results.do.u(iu,istep);
                  inputs.DOsol.u_guess(iu,count_step+1)=results.do.u(iu,istep);
                  inputs.DOsol.u_min(iu,count_step)=inputs.DOsol.u_min(iu,istep);
                  inputs.DOsol.u_min(iu,count_step+1)=inputs.DOsol.u_min(iu,istep);
                  inputs.DOsol.u_max(iu,count_step)=inputs.DOsol.u_max(iu,istep);
                  inputs.DOsol.u_max(iu,count_step+1)=inputs.DOsol.u_max(iu,istep);
                  
                  if inputs.DOsol.n_par>0,
                      inputs.DOsol.par_guess=results.do.reopt.upar;
                  end
                  
                  count_step=count_step+2;
                  end
                  end
                  inputs.DOsol.t_con=[0:inputs.DOsol.tf_guess/inputs.DOsol.n_steps:inputs.DOsol.tf_guess];
                  
                  
 %%              
 % * Calls AMIGO_initi_OD_guess_bounds
 
%% Generation of the cost function and constraints

                AMIGO_init_DO_guess_bounds
%%
% * Calls AMIGO_gen_DOcost 

             
              [inputs,results]=AMIGO_gen_DOcost(inputs,inputs.nlpsol.reopt,iopt);

%% Starts successive reoptimizations

%%
% * Calls AMIGO_call_ODOPTsolver             
                fprintf(1,'\n\n>>>>> RE-OPTIMIZATION %u\n\n', iopt);
                inputs.ivpsol.rtol=0.1*inputs.ivpsol.rtol;
                inputs.ivpsol.atol=0.1*inputs.ivpsol.atol;
                [results]=AMIGO_call_DOOPTsolver(inputs.nlpsol.reopt_solver,inputs.DOsol.vdo_guess,inputs.DOsol.vdo_min,inputs.DOsol.vdo_max,inputs,results,privstruct);        
              
%% Keeps outputs in the results.do structure and gives control back to AMIGO_OD for postprocessing              
                privstruct.do=results.nlpsol.vbest;
                [privstruct,inputs,results]=AMIGO_transform_do(inputs,results,privstruct);
              
                results.do.t_f=privstruct.t_f{1};
                results.do.u=privstruct.u{1};
                results.do.t_con=privstruct.t_con{1}; 
                if inputs.DOsol.n_par>0, results.do.upar=privstruct.upar;end
                results.do.reopt.t_f{iopt+1}=results.do.t_f;
                results.do.reopt.u{iopt+1}=results.do.u;
                results.do.reopt.t_con{iopt+1}=results.do.t_con;
                results.do.reopt.fbest{iopt+1}=results.nlpsol.fbest;
                results.do.reopt.cpu_time{iopt+1}=results.nlpsol.cpu_time;
               
                  end
                
                  
                  case 'linearf'
                  for iopt=1:inputs.nlpsol.n_reOpts
                  inputs.DOsol.tf_guess=results.do.t_f;
                  inputs.DOsol.n_linear=2*inputs.DOsol.n_linear;
                  inputs.exps.n_linear{1}=inputs.DOsol.n_linear;
                  for iu=1:inputs.model.n_stimulus
                  count_step=1;    
                  for istep=1:inputs.DOsol.n_linear/2    
                  inputs.DOsol.u_guess(iu,count_step)=results.do.u(iu,istep);
                  inputs.DOsol.u_guess(iu,count_step+1)=results.do.u(iu,istep);
                  inputs.DOsol.u_min(iu,count_step)=inputs.DOsol.u_min(iu,istep);
                  inputs.DOsol.u_min(iu,count_step+1)=inputs.DOsol.u_min(iu,istep);
                  inputs.DOsol.u_max(iu,count_step)=inputs.DOsol.u_max(iu,istep);
                  inputs.DOsol.u_max(iu,count_step+1)=inputs.DOsol.u_max(iu,istep);
                  count_step=count_step+2;
                  end
                  end
                  inputs.DOsol.t_con=[0:inputs.DOsol.tf_guess/(inputs.DOsol.n_linear-1):inputs.DOsol.tf_guess];
                  
                  
 %%              
 % * Calls AMIGO_initi_OD_guess_bounds
 
%% Generation of the cost function and constraints

                AMIGO_init_DO_guess_bounds
%%
% * Calls AMIGO_gen_DOcost 

             
              [results]=AMIGO_gen_DOcost(inputs,inputs.nlpsol.reopt,iopt);

%% Starts successive reoptimizations

%%
% * Calls AMIGO_call_ODOPTsolver             
              fprintf(1,'\n\n>>>>> RE-OPTIMIZATION %u\n\n', iopt);
              inputs.ivpsol.rtol=0.1*inputs.ivpsol.rtol;
              inputs.ivpsol.atol=0.1*inputs.ivpsol.atol;
              [results]=AMIGO_call_DOOPTsolver(inputs.nlpsol.reopt_solver,inputs.DOsol.vdo_guess,inputs.DOsol.vdo_min,inputs.DOsol.vdo_max,inputs,results,privstruct);        
              
%% Keeps outputs in the results.do structure and gives control back to AMIGO_DO for postprocessing              
              privstruct.do=results.nlpsol.vbest;
              [privstruct,inputs,results]=AMIGO_transform_do(inputs,results,privstruct);
              
              results.do.t_f=privstruct.t_f{1};
              results.do.u=privstruct.u{1};
              results.do.t_con=privstruct.t_con{1}; 
               if inputs.DOsol.n_par>0, results.do.upar=privstruct.upar;end
              
                results.do.reopt.t_f{iopt+1}=results.do.t_f;
                results.do.reopt.u{iopt+1}=results.do.u;
                results.do.reopt.t_con{iopt+1}=results.do.t_con;
                results.do.reopt.fbest{iopt+1}=results.nlpsol.fbest;
                results.do.reopt.cpu_time{iopt+1}=results.nlpsol.cpu_time;
              
                end
                  
                  
                  
               
                
                end %switch inputs.DOsol.u_interp