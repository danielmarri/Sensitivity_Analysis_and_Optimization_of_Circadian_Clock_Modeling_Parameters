% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_C_jacobian.m 2057 2015-08-24 13:06:14Z attila $
function AMIGO_gen_C_jacobian(inputs,fid)
% generate the Jacobian of the system for CVODES

fprintf(fid,'\n/* Jacobian of the system (dfdx)*/\n');
% fprintf(fid,'int amigoJAC(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat J, void *data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3){\n');
% fprintf(fid,'int amigoJAC( N,  t,  y,  fy,  J, user_data,  tmp1, tmp2, tmp3){\n');
fprintf(fid,'int amigoJAC(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3){\n');
fprintf(fid,'\tAMIGO_model* amigo_model=(AMIGO_model*)user_data;\n');

if strcmpi(inputs.model.exe_type,'standard')
    % test for mex user interruption
    fprintf(fid,'\tctrlcCheckPoint(__FILE__, __LINE__);\n\n');
end
%Is there a JACOBIAN?!
if(size(inputs.model.J,1)>0)


     % test for negative states
     fprintf(fid,'\n\t/* *** Test for negative states *** */\n\n');
        if isfield(inputs.model, 'positiveStates') && inputs.model.positiveStates
            if(numel(inputs.model.st_names)>0)
                for i=0:inputs.model.n_st-1
                    fprintf(fid,'\tif(%s <0.0) %s = 0;\n',inputs.model.st_names(i+1,:),inputs.model.st_names(i+1,:));
                end
            end
        end
    
    % algebraic  equations
    if inputs.model.AMIGOjac == 1
        % everything is in the inputs.model.eqns...
        fprintf(fid,'\n\t/* *** Algebraic equations *** */\n\n');
        if isfield(inputs.model, 'algeqns')
            n_algeqns = size(inputs.model.algeqns,1);
            for i=1:n_algeqns
                eqn=convertPowerOperator(char(inputs.model.algeqns{i}));
                fprintf(fid,'\t%s = %s;\n',char(inputs.model.algvarnames{i}), eqn);
            end
        end
    end

% Jacobian
    count_ij=0;
    fprintf(fid,'\n\t/* *** Jacobian *** */\n\n');
    for i=1:inputs.model.n_st
        for j=1:inputs.model.n_st
            count_ij=count_ij+1;
            Jij=convertPowerOperator(inputs.model.J{count_ij});
            if ~strcmp(Jij,'0')
                fprintf(fid,'\tIJth(J,%d,%d)=%s;\n',i-1,j-1,Jij);
            end
        end
    end

    %Debug the Jacobian:
    if isfield(inputs, 'debug') && isfield(inputs.debug, 'jacobi') && inputs.debug.jacobi
        fprintf(fid,'\n/* ********** Debug because: AMIGO_gen_C_jacobian.m L.50******** */\n');
        if numel(inputs.model.st_names)>0
            for i=0:inputs.model.n_st-1
                %fprintf(fid,'\tmexPrintf("%s =',inputs.model.st_names(i+1,:)) ' %%-6g;\\n ", ' sprintf('Ith(y,%d));\n',i)];
                fprintf(fid, '%s', [sprintf('\tmexPrintf("') ' %-.10g;\\n ", ' sprintf('Ith(y,%d));\n',i)]);
            end
        end
        count_ij = 0;
        for i=1:inputs.model.n_st
            for j=1:inputs.model.n_st
                count_ij=count_ij+1;
                Jij=convertPowerOperator(inputs.model.J{count_ij});
                if ~strcmp(Jij,'0')
                    fprintf(fid, '%s', [sprintf('\tmexPrintf("J(%d,%d)= ', i,j) '%-.10g;\\n",'      sprintf('IJth(J,%d,%d));\n',i-1,j-1)]);
                end
            end
        end
    end
        % Debud ends here....
end
%
fprintf(fid,'\n\treturn(0);\n}\n');