function AMIGO_gen_matlab_jacobian(inputs,filename)
% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/Preprocessor/AMIGO_gen_matlab.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_gen_matlab_jacobian: Generates necessary matlab files for the model
% 'charmodelM' to compute the jacobian of the dynamics
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% AMIGO_gen_matlab_jacobian                                                   %
% Code development:     Attila Gábor                                          %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
%  AMIGO_gen_matlab_jacobian: Generates necessary matlab files for the model type      %
%                     'charmodelM' for the jacobian computation               %
%                                                                             %                             %
%                                                                             %
%*****************************************************************************%


fid = fopen([filename '.m'],'w');
fprintf(fid,'\tfunction [J ydot]= %s(t,y,flag,par,v,pend,tlast) \n',filename);
if numel(inputs.model.st_names)>0
    for i=1:inputs.model.n_st
        fprintf(fid,'\t%s=y(%u);\n',inputs.model.st_names(i,:),i);
    end;  end

if numel(inputs.model.par_names)>0
    for i=1:inputs.model.n_par
        fprintf(fid,'\t%s=par(%u);\n',inputs.model.par_names(i,:),i);
    end;  end

for i=1:inputs.model.n_stimulus
    fprintf(fid,'\tu(%u)=v(%u)+(t-tlast)*pend(%u);\n',i,i,i);
end

if numel(inputs.model.stimulus_names)>0
    for i=1:inputs.model.n_stimulus
        fprintf(fid,'\t%s=u(%u);\n',inputs.model.stimulus_names(i,:),i);
    end;  end

for i=1:size(inputs.model.eqns,1)
    eqn=inputs.model.eqns(i,:);
     if(~isempty(regexp(eqn,'{','ONCE')))...
       
     eqn=regexprep(eqn,'[{]','');
     fprintf(fid,'\t%s\n',eqn);
        
     elseif (~isempty(regexp(eqn,'}','ONCE')))
       
        eqn=regexprep(eqn,'[}]','end');
        fprintf(fid,'\t%s\n',eqn);
        
     else
        fprintf(fid,'\t%s;\n',eqn);
        
    end
end


fprintf(fid,'J = zeros(%d);',inputs.model.n_st);
count_ij=0;
fprintf(fid,'\n\t%% *** Jacobian *** \n\n');
for i=1:inputs.model.n_st
    for j=1:inputs.model.n_st
        count_ij=count_ij+1;
        Jij=strtrim(inputs.model.J{count_ij});
        if ~strcmp(Jij,'0')
            fprintf(fid,'\tJ(%d,%d)=%s;\n',i,j,Jij);
        end
    end
end

if numel(inputs.model.st_names)>1
    for i=1:inputs.model.n_st
        fprintf(fid,'\tydot(%u,1)=d%s;\n',i,inputs.model.st_names(i,:));
    end;     
end

fprintf(fid,'\treturn\n');
fclose(fid);


