% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_exps.m 2056 2015-08-24 13:05:26Z attila $
function [inputs,results]= AMIGO_check_exps(inputs,results)
% AMIGO_check_exps: Checks experimental scheme supplied information
% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_exps.m 2056 2015-08-24 13:05:26Z attila $
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
%  AMIGO_check_exps: Checks the user supplied information related to the      %
%                    experimental scheme                                      %
%                                                                             %
%*****************************************************************************%



%   ----------------------------------------------------------------------------------
%    EXPERIMENTAL SCHEME.


% inputs.exps.n_exp: number of experiments

if(isempty(inputs.exps.n_exp)==1)
    
    fprintf(1,'\n\n------> WARNING message\n\n');
    fprintf(1,'\t\tA number of experiments >=1 must be introduced: inputs.exps.n_exp.');
    fprintf(1,'\t\tDefault is assumed, n_exp=1');
    inputs.exps.n_exp=1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(inputs.exps.exp_y0) < inputs.exps.n_exp
    fprintf(1,'\n\n------> ERROR message\n\n');
    fprintf(1,'\t\t The size of exp_y0 does not match with n_exp.\n');    
    fprintf(1,'\t\t Please specify initial conditions for every experiment.\n');
    error('Exps_checking:inticond','\t\t Impossible to continue. Stopping.\n');
end

for iexp=1:inputs.exps.n_exp
    
    if numel(inputs.exps.exp_y0{iexp})==0
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\t Initial conditions are missing in experiment %u\n',iexp);
        fprintf(1,'\t\t Please add inputs.exps.exp_y0{iexp} to your input file.');
        error('Exps_checking:inticond','\t\t Impossible to continue. Stopping.\n');
    end
    
    if length(inputs.exps.exp_y0{iexp}) ~= inputs.model.n_st
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\t Initial conditions are missing in experiment %u\n',iexp);
        fprintf(1,'\t\t Please specify initial conditions for every state variable.\n\n');
        error('Exps_checking:inticond','\t\t Impossible to continue. Stopping.\n');
    end
    
end


% Process duration

for iexp=1:inputs.exps.n_exp
    if isempty(inputs.exps.t_f{iexp})
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\t Final simulation time should be provided.\n');
        fprintf(1,'\t\t Please add inputs.exps.t_f{iexp} to your input file. Experiment %u',iexp);
        error('error_exps_002','\t\t Impossible to continue. Stopping.\n');
    end
    if isempty(inputs.exps.t_in{iexp})
        fprintf(1,'\n\n------> WARNING message\n\n');
        fprintf(1,'         Initial time for simulation should be included, default inputs.exps.t_in{iexp}=0.\n');
        inputs.exps.t_in{iexp}=0.0;
    end
    if(inputs.exps.t_in{iexp}>=inputs.exps.t_f{iexp})
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\tFinal time is lower or equal than initial time, this should be corrected.');
        error('error_exps_003','\t\t Impossible to continue. Stopping.\n');
    end
    if(inputs.exps.t_in{iexp}<0 || inputs.exps.t_f{iexp}<0)
        fprintf(1,'\n\n------> ERROR message\n\n');
        fprintf(1,'\t\tNegative initial or final times have been introduced.');
        error('error_exps_004','\t\t Impossible to continue. Stopping.\n');
        
    end
end

% %Stimulus related data
% 
% if inputs.model.n_stimulus==0
%     
%     for iexp=1:inputs.exps.n_exp
%         
%         inputs.exps.u_interp{iexp}='sustained';
%         inputs.exps.u{iexp}=[0];
%         inputs.exps.t_con{iexp}=[inputs.exps.t_in{iexp} inputs.exps.t_f{iexp}];
%         
%     end
%     
% else %inputs.model.n_stimulus>=1
%     
%    
%     
%     for iexp=1:inputs.exps.n_exp
%             
%         switch inputs.exps.u_interp{iexp}
%             
%             case 'sustained' 
%                 
%                  if isempty(inputs.exps.u{iexp})
%                     fprintf(1,'\n\n------> ERROR message\n\n');
%                     fprintf(1,'\t\t You have not provided controls/stimuli values for simulation.\n');
%                     fprintf(1,'\t\t Please add in your input file the values for inputs.exps.u{iexp}\n');
%                     error('error_exps_005','\t\t Impossible to continue. Stopping.\n');
%                  end
%                 
%                 for iu=1:inputs.model.n_stimulus
%                     if numel(inputs.exps.u{iexp}(iu,:)) < 1
%                         fprintf(1,'\n\n------> ERROR message\n\n');
%                         fprintf(1,'\t\t The value of the stimuli should be provided.\n');
%                         error('error_exps_006','There are errors in introducing the control variables or stimuli: inputs.exps.u{iexp}. Stopping.');
%                     end
%                 end
%                 
%                 inputs.exps.n_con{iexp}=length(inputs.exps.t_con{iexp});
%                 
%             case {'step','stepf'}
%                 
%                 if isempty(inputs.exps.u{iexp})==1
%                     fprintf(1,'\n\n------> ERROR message\n\n');
%                     fprintf(1,'\t\t You have not provided controls/stimuli values for simulation.\n');
%                     fprintf(1,'\t\t Please add in your input file the values for inputs.exps.u{iexp}\n');
%                     error('error_exps_005','\t\t Impossible to continue. Stopping.\n');
%                 end;
%                 
%                 for iu=1:inputs.model.n_stimulus
%                     if numel(inputs.exps.u{iexp}(iu,:)) < 1
%                         fprintf(1,'\n\n------> ERROR message\n\n');
%                         fprintf(1,'\t\t The value of the stimuli should be provided.\n');
%                         error('error_exps_006','There are errors in introducing the control variables or stimuli: inputs.exps.u{iexp}. Stopping.');
%                     end
%                 end
%                 
%                 if(inputs.exps.n_steps{iexp}<=1)
%                     inputs.exps.n_steps{iexp}=1;
%                     inputs.exps.n_con{iexp}=1;
%                     inputs.exps.t_con{iexp}=[inputs.exps.t_in{iexp} inputs.exps.t_f{iexp}];
%                 end
%                 
%                 if(size(inputs.exps.t_con{iexp},2)<inputs.exps.n_steps{iexp}+1)
%                     fprintf(1,'\n\n------> ERROR message\n\n');
%                     fprintf(1,'\t\t The number of components in inputs.exps.t_con{%u} does not correspond with inputs.exps.n_steps{%u}+1.\n',iexp,iexp);
%                     error('CheckEps:error_exps_007','There are errors in introducing t_con: inputs.exps.t_con{iexp}. Dimensions...');
%                 end
%                 
%                 
%             case {'linear'}
%                 
%                 if isempty(inputs.exps.u{iexp})==1
%                     fprintf(1,'\n\n------> ERROR message\n\n');
%                     fprintf(1,'\t\t You have not provided controls/stimuli values for simulation.\n');
%                     fprintf(1,'\t\t Please add in your input file the values for inputs.exps.u{%u}\n',iexp);
%                     error('error_exps_005','\t\t Impossible to continue. Stopping.\n');
%                 end;
%                 
%                 for iu=1:inputs.model.n_stimulus
%                     if numel(inputs.exps.u{iexp}(iu,:)) < 1
%                         fprintf(1,'\n\n------> ERROR message\n\n');
%                         fprintf(1,'\t\t The value of the stimuli should be provided.\n');
%                         error('error_exps_006','There are errors in introducing the control variables or stimuli: inputs.exps.u{iexp}. Stopping.');
%                     end;
%                 end;
%                 
%                 if(inputs.exps.n_linear{iexp}<=1)
%                     inputs.exps.n_linear{iexp}=2;
%                     inputs.exps.n_con{iexp}=2;
%                     inputs.exps.t_con{iexp}=[inputs.exps.t_in{iexp} inputs.exps.t_f{iexp}];
%                 end;
%                 
%                 if(size(inputs.exps.t_con{iexp},2)<inputs.exps.n_linear{iexp})
%                     fprintf(1,'\n\n------> ERROR message\n\n');
%                     fprintf(1,'\t\t The number of components in inputs.exps.t_con{iexp} does not correspond with inputs.exps.n_steps{iexp}+1.\n');
%                     error('error_exps_007','There are errors in introducing t_con: inputs.exps.t_con{iexp}. Dimensions...');
%                 end;
%                 
%             case {'pulse-up', 'pulse-down'}
%                 inputs.exps.n_steps{iexp}=2*inputs.exps.n_pulses{iexp}+1;
%                
%                 % either u_max/u_min or u must be given.
%                 if isempty(inputs.exps.u_min{iexp}) && isempty(inputs.exps.u_max{iexp})
%                     if isempty(inputs.exps.u{iexp})
%                         fprintf(1,'\n\n------> ERROR message\n\n');
%                         fprintf(1,'\t\t For pulse-up, pulse-down stimuli fill inputs.exps.u_min{iexp} and inputs.exps.u_max{iexp}. \n');
%                         error('error_exps_008','There is an error in the stimuli definition. No maximal and minimal value for stimuli/control input is given.');
%                     else
%                         % if u is given: assume pulses between 0 and u.
%                         inputs.exps.u_min{iexp} = 0;
%                         inputs.exps.u_max{iexp} = inputs.exps.u{iexp};
%                     end
%                 elseif  ~isempty(inputs.exps.u_min{iexp}) && ~isempty(inputs.exps.u_max{iexp})
%                     % they are correctly given. 
%                     inputs.exps.u{iexp} = [];
%                 else
%                     fprintf(1,'\n\n------> ERROR message\n\n');
%                     fprintf(1,'\t\t For pulse-up, pulse-down stimuli fill inputs.exps.u_min{iexp} and inputs.exps.u_max{iexp}. \n');
%                     error('error_exps_008','There is an error in the stimuli definition. No maximal and minimal value for stimuli/control input is given.');
%                 end
%                 
%             otherwise
%                 
%                 error('No such stimuli profile: inputs.exps.u_interp{%d} = %s',iexp, inputs.exps.u_interp{iexp});
%         end
%         
%         if isempty(inputs.exps.ts_type) || length(inputs.exps.ts_type)<iexp
%             inputs.exps.ts_type{iexp}='fixed';
%         end
%         
%          if isempty(inputs.exps.ts_0) || length(inputs.exps.ts_0)<iexp
%             inputs.exps.ts_0{iexp}=0;
%          end
%         
%         if isempty(inputs.exps.n_steps) || length(inputs.exps.n_steps)<iexp
%             inputs.exps.n_steps{iexp}=[];
%         end
%         
%          if isempty(inputs.exps.t_con{iexp})
%              inputs.exps.t_con{iexp}=[inputs.exps.t_in{iexp} inputs.exps.t_f{iexp}];
%          end;
%     end
    

    
% 
% end% if inputs.model.n_stimulus==0

 

 if isempty(inputs.exps.t_con{iexp})
              inputs.exps.t_con{iexp}=[inputs.exps.t_in{iexp} inputs.exps.t_f{iexp}];
          end;



[inputs]= AMIGO_check_sampling(inputs);

inputs.exps.ts_type=inputs.exps.ts_type(1:inputs.exps.n_exp);
inputs.exps.t_in=inputs.exps.t_in(1:inputs.exps.n_exp);
inputs.exps.ts_0=inputs.exps.ts_0(1:inputs.exps.n_exp);
%inputs.exps.obs_names=inputs.exps.obs_names(1:inputs.exps.n_exp);
inputs.exps.u_interp=inputs.exps.u_interp(1:inputs.exps.n_exp);
inputs.exps.exp_y0=inputs.exps.exp_y0(1:inputs.exps.n_exp);
inputs.exps.t_f=inputs.exps.t_f(1:inputs.exps.n_exp);
inputs.exps.u=inputs.exps.u(1:inputs.exps.n_exp);
inputs.exps.n_steps=inputs.exps.n_steps(1:inputs.exps.n_exp);
%inputs.exps.std_dev=inputs.exps.std_dev(1:inputs.exps.n_exp);
inputs.exps.n_s=inputs.exps.n_s(1:inputs.exps.n_exp);
inputs.exps.t_s=inputs.exps.t_s(1:inputs.exps.n_exp);


for iexp=1:inputs.exps.n_exp
    AMIGO_uinterp
end

return


