% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_customnames.m 770 2013-08-06 09:41:45Z attila $

function [inputs]= AMIGO_check_customnames(inputs);
% AMIGO_check_customnames: Checks custom names provided by user
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
%  AMIGO_check_customnames: Checks custom names provided by user do not       %
%                           correspond to reserved words                      %
%                           This check is only applicable to fortran and      %
%                           matlab models:'charmodelF' and 'charmodelM'       %
%*****************************************************************************%
 
if isempty(strmatch('u',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('u',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('u',lower(inputs.model.stimulus_names),'exact'))==0
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''u'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end

if isempty(strmatch('t',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('t',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('t',lower(inputs.model.stimulus_names),'exact'))==0  
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''t'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end

if isempty(strmatch('v',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('v',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('v',lower(inputs.model.stimulus_names),'exact'))==0
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''v'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end


if isempty(strmatch('y',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('y',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('y',lower(inputs.model.stimulus_names),'exact'))==0
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''y'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end


if isempty(strmatch('ydot',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('ydot',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('ydot',lower(inputs.model.stimulus_names),'exact'))==0
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''ydot'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end

if isempty(strmatch('tlast',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('tlast',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('tlast',lower(inputs.model.stimulus_names),'exact'))==0
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''tlast'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end

if isempty(strmatch('told',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('told',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('told',lower(inputs.model.stimulus_names),'exact'))==0
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''told'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end

if isempty(strmatch('pend',lower(inputs.model.st_names),'exact'))==0 || isempty(strmatch('pend',lower(inputs.model.par_names),'exact'))==0 || isempty(strmatch('pend',lower(inputs.model.stimulus_names),'exact'))==0
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\t Reserved word ''pend'' has been used in the declaration of states, par or stimulus names.\n');
            fprintf('\t\tPlease, use another name to continue. \n');
            error('error_model_010a','\t\t Impossible to continue. Stopping.\n');
end

for ieq=1:size(inputs.model.eqns,1)
   
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''u='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tReserved word ''u'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end
   
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''t='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tReserved word ''t'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end
              
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''y='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tReserved word ''y'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end
   
    if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''ydot='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tReserved word ''ydot'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end  
   
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''par='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tReserved word ''par'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end
   
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''tlast='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tReserved word ''tlast'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end
   
   
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''told='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tReserved word ''told'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end

   
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''pend='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tCustom name ''pend'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end
   
   if isempty(strfind(lower(inputs.model.eqns(ieq,:)),'''v='))==0 
            fprintf(1,'\n\n------> ERROR message\n\n'); 
            fprintf('\t\tCustom name ''v'' has been used in a declaration in the model equations.\n',ieq);
            fprintf('\t\tPlease, change the name of the variable to continue. \n');
            error('error_model_010c','\t\t Impossible to continue. Stopping.\n');
   end
end   
    
