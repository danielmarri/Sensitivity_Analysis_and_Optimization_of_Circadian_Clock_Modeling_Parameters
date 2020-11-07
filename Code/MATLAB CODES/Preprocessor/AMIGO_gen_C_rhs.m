% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_C_rhs.m 1867 2014-09-25 08:31:19Z attila $
function AMIGO_gen_C_rhs(inputs,fid)
% generate the right hand side of the ODEs

fprintf(fid,sprintf('/* Right hand side of the system (f(t,x,p))*/\n'));
fprintf(fid,'int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){\n');
fprintf(fid,sprintf('\tAMIGO_model* amigo_model=(AMIGO_model*)data;\n'));


% test for mex user interruption
if strcmpi(inputs.model.exe_type,'standard')
    fprintf(fid,'\tctrlcCheckPoint(__FILE__, __LINE__);\n\n');
end
% test for negative states
if isfield(inputs.model, 'positiveStates') && inputs.model.positiveStates == 1
fprintf(fid,'\n\t/* *** Test for negative states *** */\n\n');
    if(numel(inputs.model.st_names)>0)
        for i=0:inputs.model.n_st-1
            %str=[str sprintf('\tif(%s <0.0) %s = 0;\n',inputs.model.st_names(i+1,:),inputs.model.st_names(i+1,:))];
            fprintf(fid,'\tif(%s <0.0) %s = 0;\n',inputs.model.st_names(i+1,:),inputs.model.st_names(i+1,:));
        end
    end
end

% test for state constraints:
if isfield(inputs.model, 'st_max') && ~isempty(inputs.model.st_max)
fprintf(fid,'\n\t/* *** Test for  state constraints (max)*** */\n\n');
    if(numel(inputs.model.st_names)>0)
        for i=0:inputs.model.n_st-1
            %str=[str sprintf('\tif(%s <0.0) %s = 0;\n',inputs.model.st_names(i+1,:),inputs.model.st_names(i+1,:))];
            fprintf(fid,'\tif(%s >%g) return 1;\n',inputs.model.st_names(i+1,:),inputs.model.st_max(i+1));
        end
    end
end
if isfield(inputs.model, 'st_min') && ~isempty(inputs.model.st_min)
fprintf(fid,'\n\t/* *** Test for  state constraints (min) *** */\n\n');
    if(numel(inputs.model.st_names)>0)
        for i=0:inputs.model.n_st-1
            %str=[str sprintf('\tif(%s <0.0) %s = 0;\n',inputs.model.st_names(i+1,:),inputs.model.st_names(i+1,:))];
            fprintf(fid,'\tif(%s <%g) return 1;\n',inputs.model.st_names(i+1,:),inputs.model.st_min(i+1));
        end
    end
end

% equations:
fprintf(fid,'\n\t/* *** Equations *** */\n\n');

for i=1:size(inputs.model.eqns,1)

    eqn=convertPowerOperator(inputs.model.eqns(i,:));
    %     eqn=regexprep(eqn,'d00','');
    %     eqn=regexprep(eqn,'d0','');
   if(~isempty(regexp(eqn,'[\w)(]$','ONCE')))...
            %str=[str sprintf('\t%s;\n',eqn)];
            fprintf(fid,'\t%s;\n',eqn);
    else
        %str=[str sprintf('\t%s\n',eqn)];
        fprintf(fid,'\t%s\n',eqn);
    end
end


if isfield(inputs.model, 'positiveStates') && inputs.model.positiveStates == 2
fprintf(fid,'\n\t/* *** Test for negative states *** */\n\n');
    if(numel(inputs.model.st_names)>0)
        for i=0:inputs.model.n_st-1
            %str=[str sprintf('\tif(%s <0.0) %s = 0;\n',inputs.model.st_names(i+1,:),inputs.model.st_names(i+1,:))];
            fprintf(fid,'\tif(%s <0.0) return(1);\n',inputs.model.st_names(i+1,:));
        end
    end
end

% %Debug the computation:
%     if isfield(inputs, 'debug') && isfield(inputs.debug, 'states') && inputs.debug.states
%         fprintf(fid,'\n/* ********** Debug because: AMIGO_gen_C_rhs.m L.50******** */\n');
%         if numel(inputs.model.st_names)>0
%             for i=0:inputs.model.n_st-1
%                 %fprintf(fid,'\tmexPrintf("%s =',inputs.model.st_names(i+1,:)) ' %%-6g;\\n ", ' sprintf('Ith(y,%d));\n',i)];
%                 fprintf(fid, '%s', [sprintf('\tmexPrintf("') ' %-.10g;\\n ", ' sprintf('Ith(y,%d));\n',i)]);
%             end
%         end
%         count_ij = 0;
%         for i=1:inputs.model.n_st
%             for j=1:inputs.model.n_st
%                 count_ij=count_ij+1;
%                 Jij=convertPowerOperator(inputs.model.J(count_ij,:));
%                 if ~strcmp(Jij,'0')
%                     fprintf(fid, '%s', [sprintf('\tmexPrintf("J(%d,%d)= ', i,j) '%-.10g;\\n",'      sprintf('IJth(J,%d,%d));\n',i-1,j-1)]);
%                 end
%             end
%         end
%     end
    

% str=[str sprintf('\n\treturn(0);\n\n}\n\n')];
fprintf(fid,'\n\treturn(0);\n\n}\n\n');