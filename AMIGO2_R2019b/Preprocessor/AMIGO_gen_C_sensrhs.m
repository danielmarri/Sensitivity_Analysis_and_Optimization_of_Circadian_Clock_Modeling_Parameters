% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_gen_C_sensrhs.m 2060 2015-08-24 13:07:59Z attila $
function AMIGO_gen_C_sensrhs(inputs,fid)

fprintf(fid,'\n/* R.H.S of the sensitivity dsi/dt = (df/dx)*si + df/dp_i */\n');
fprintf(fid,'int amigoSensRHS(int Ns, realtype t, N_Vector y, N_Vector ydot, int iS, N_Vector yS, N_Vector ySdot, void *data, N_Vector tmp1, N_Vector tmp2){\n');
fprintf(fid,'\tAMIGO_model* amigo_model=(AMIGO_model*)data;\n');



%Is there a Sensitivity RHS?!
if isfield(inputs.model, 'AMIGOsensrhs') && isfield(inputs.model, 'sens') %&& (size(inputs.model.sens.rhs,1)>0)
    
    % declare variables:
    fprintf(fid,'\tint iSlist = (*amigo_model).plist[iS];\n');
    
    if strcmpi(inputs.model.exe_type,'standard')
        % test for mex user interruption
        fprintf(fid,'\tctrlcCheckPoint(__FILE__, __LINE__); // Interuption point for MATLAB\n\n');
    end
    % calculation of the RHS.
    fprintf(fid,'\t// Common expression for all equations: df/dx*s\n');
    for j=1:inputs.model.n_st
        rhs=convertPowerOperator(inputs.model.sens.rhsI{j});
        fprintf(fid,'\t\tIth(ySdot,%d)=%s;  // (ds/dt(%d)\n',j-1,rhs,j-1);
    end
    
    
    
    fprintf(fid,'\n\tswitch(iSlist){\n   ');
    index = 0;
    for i=1:inputs.model.n_par
        fprintf(fid,'\tcase (%d):    // rhs with respect to %s\n',i-1,inputs.model.par_names(i,:));
        for j=1:inputs.model.n_st
            index = index+1;
            rhs=convertPowerOperator(inputs.model.sens.rhsII{index});
            if ~strcmp(rhs, '0')
                fprintf(fid,'\t\tIth(ySdot,%d)=Ith(ySdot,%d) + (%s);  // (ds/dt(%d)\n',j-1,j-1,rhs,j-1);
            end
        end
        fprintf(fid,'\t\tbreak;\n');
    end
    
    
    % wrt the initial conditions: note that the difference is only in the
    % initial conditions of the equations, the right hand side is the same.
    i = inputs.model.n_par;
    for j = 1 : inputs.model.n_st
        i = i+1;
        fprintf(fid,'\tcase (%d):    // rhs with respect to initial condition %s\n',i-1,inputs.model.st_names(j,:));
    end
    
    %     for i = 1:inputs.model.n_st
    %         rhs=convertPowerOperator(inputs.model.sens.rhsIC(i,:));
    %         fprintf(fid,'\t\tIth(ySdot,%d)=%s;  // (ds/dt(y0)\n',i-1,rhs);
    %     end
    fprintf(fid,'\t//No additional term for sensitivities wrt ICs.\n');
    fprintf(fid,'\t\tbreak;\n');
    fprintf(fid,'\t default:\n\t\tmexPrintf("Error in CVODES: check isoptpar!");\n\t\treturn(-1);\n');
    
    
    fprintf(fid,'\n}');
end



fprintf(fid,'\n\treturn(0);\n\n}');