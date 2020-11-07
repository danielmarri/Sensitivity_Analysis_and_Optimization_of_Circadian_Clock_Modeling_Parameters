% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_matlab.m 2204 2015-09-24 07:11:53Z evabalsa $
% AMIGO_gen_matlab: Generates necessary matlab files for the model 'charmodelM'
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
%  AMIGO_gen_matlab: Generates necessary matlab files for the model type      %
%                     'charmodelM'                                            %
%                                                                             %
%                     Generates fcn.m from the inputs.model                   %
%                     provided by the user                                    %
%                                                                             %
%*****************************************************************************%

fprintf(1,'\n\n------> Generating Matlab file...\n\n');
openfile=sprintf('fid=fopen(''%s'',''w'');',inputs.model.odes_file);
fprintf(1,'\t\t%s\n',inputs.model.odes_file);
eval(openfile)
fprintf(fid,'\tfunction ydot= %s(t,y,flag,par,v,pend,tlast) \n',inputs.model.matlabmodel_file);
if numel(inputs.model.st_names)>0
    for i=1:inputs.model.n_st
        fprintf(fid,'\t%s=y(%u);\n',inputs.model.st_names(i,:),i);
    end;  end

if numel(inputs.model.par_names)>0
    for i=1:inputs.model.n_par
        fprintf(fid,'\t%s=par(%u);\n',inputs.model.par_names(i,:),i);
    end;  end


%EBC-- this has been modified to consider universal approximation of the
%control for IPE
n_par=inputs.model.n_par;
if numel(inputs.model.stimulus_names)>0
if inputs.model.uns>0
    
    for i=1:inputs.model.n_stimulus
        fprintf(fid,'\tu(%u)=',i);
    end; % for i=1:inputs.model.n_stimulus
    
    for i=1:inputs.model.n_stimulus
        fprintf(fid,'\t%s=u(%u);\n',inputs.model.stimulus_names(i,:),i);
    end;  
    
  
else
    
    for i=1:inputs.model.n_stimulus
    fprintf(fid,'\tu(%u)=v(%u)+(t-tlast)*pend(%u);\n',i,i,i);
    end
    
    for i=1:inputs.model.n_stimulus
        fprintf(fid,'\t%s=u(%u);\n',inputs.model.stimulus_names(i,:),i);
    end;  
    
end %inputs.model.uns>0
end %if numel(inputs.model.stimulus_names)>0

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

if numel(inputs.model.st_names)>1
    for i=1:inputs.model.n_st
        fprintf(fid,'\tydot(%u,1)=d%s;\n',i,inputs.model.st_names(i,:));
    end;     end


fprintf(fid,'\treturn\n');
fclose(fid);


