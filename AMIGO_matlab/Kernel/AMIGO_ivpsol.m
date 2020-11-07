% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_ivpsol.m 2305 2015-11-25 08:20:26Z evabalsa $
function [yteor,privstruct,results]=AMIGO_ivpsol(inputs,privstruct,y_0,par,iexp,results)

% AMIGO_ivpsol: solves the model equations
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%**************************************************************************
%****
%
%*****************************************************************************%
%                                                                             %
% AMIGO_ivpsol:solves the initial value problem by using the user selected    %
%              IVP solver.                                                    %
%              Following options are available:                               %
%              RADAU5:Implicit or explicit Runge-Kutta method or order 5      %
%                     with step size control by:                              %
%                     HAIRER AND G. WANNER. Solving ordinary differential     %
%                     equations II. Stiff and Differential-Algebraic problems.%
%                     SPRINGER SERIES in COMPUTATIONAL MATHEMATICS 14,        %
%                     SPRINGER-VERLAG 1991, SECOND EDITION 1996.              %
%                                                                             %
%                     Prepared to solve models provided in 'char','fortran',  %
%                     'sbml' and 'matlab'                                     %
%                                                                             %
%              RKF45: Runge-Kutta-Fehlberg algorithm for solving ODEs, with   %
%                     automatic error estimation using rules of order 4 and 5.%
%                     Modification from the implementation by                 %
%                     H.A. Watts and L.F. Shampine, Sandia Laboratories       %
%                                                                             %
%                     Prepared to solve models provided in 'char','fortran',  %
%                     'sbml' and 'matlab'                                     %
%                                                                             %
%             ODE15s and ODE113 provided with MATLAB. To solve models         %
%                     provided in 'sbml' and 'matlab'                         %
%                                                                             %
%             'user_integration' User provides a black-box code for solving   %
%                     the model                                               %
%                     function provided should be of the form:                %
%          [yteor privstruct.iflag]=user_fcn(t_f{iexp},n_m{iexp},y_0{iexp},...%
%                            par,u{iexp},t_con{iexp});                        %
%*****************************************************************************%

global n_amigo_sim_success;
global n_amigo_sim_failed;
global report_ivp
if isfield(inputs.model, 'debugmode') && inputs.model.debugmode
    global uV sV;
end

if report_ivp == 0
    report_ivpsolver_options(inputs);
    report_ivp = true;
end

n_int=size(privstruct.t_int{iexp},2);
n_vtout=size(privstruct.vtout{iexp},2);
yteor=zeros(n_int,inputs.model.n_st);
ipar=0;
privstruct.ivpsol.ivp_fail=0;

% HANDLING CONTROL PARAMETERIZATION


AMIGO_uinterp
if inputs.exps.u_delay_flag{iexp}==1    
    AMIGO_uinterp_delay
end


t_old=privstruct.t_con{iexp}(1);

% INTEGRATION LOOP

switch inputs.ivpsol.ivpsolver
    
    case 'radau5'
        
        privstruct.iflag=1; % Integration control errors
        eval(sprintf('[yteor privstruct.iflag]=%s(inputs.model.n_st,inputs.exps.t_in{iexp},privstruct.vtout{iexp}'',n_vtout,privstruct.t_int{iexp}'',n_int, privstruct.t_con{iexp}'',ncon{iexp},y_0,inputs.ivpsol.rtol,inputs.ivpsol.atol,par,size(par,2),ipar,1,privstruct.u{iexp},inputs.exps.pend{iexp},n_u,privstruct.iflag);',inputs.ivpsol.ivpmex));
        
        if privstruct.iflag<0
            
            %fprintf(1,'\n\nRADAU5 is reporting an integration error: %i\n',privstruct.iflag);
            privstruct.ivpsol.ivp_fail=1;
            n_amigo_sim_failed=n_amigo_sim_failed+1;
            
        else
            
            privstruct.ivpsol.ivp_fail=0;
            n_amigo_sim_success=n_amigo_sim_success+1;
            
        end
        
    case 'lsoda'
        
        privstruct.iflag=1;
        eval(sprintf('[yteor privstruct.iflag]=%s(inputs.model.n_st,inputs.exps.t_in{iexp},privstruct.vtout{iexp}'',n_vtout,privstruct.t_int{iexp}'',n_int, privstruct.t_con{iexp}'',ncon{iexp},y_0,inputs.ivpsol.rtol,inputs.ivpsol.atol,par,size(par,2),ipar,1,privstruct.u{iexp},inputs.exps.pend{iexp},n_u,privstruct.iflag);',inputs.ivpsol.ivpmex));
        
        if privstruct.iflag<0
            
            fprintf(1,'\n\nLSODA is reporting an integration error: %i\n',privstruct.iflag);
            inputs.exps.count_failed_ivp=inputs.exps.count_failed_ivp+1;
            
            n_amigo_sim_failed=n_amigo_sim_failed+1;
            
        else
            
            privstruct.ivpsol.ivp_fail=0;
            n_amigo_sim_success=n_amigo_sim_success+1;
            
        end
        
    case 'lsodes'
        
        privstruct.iflag=1;
        mf=10;
        eval(sprintf('[yteor privstruct.iflag]=%s(inputs.model.n_st,inputs.exps.t_in{iexp},privstruct.vtout{iexp}'',n_vtout,privstruct.t_int{iexp}'',n_int, privstruct.t_con{iexp}'',ncon{iexp},y_0,inputs.ivpsol.rtol,inputs.ivpsol.atol,par,size(par,2),ipar,1,privstruct.u{iexp},inputs.exps.pend{iexp},n_u,privstruct.iflag,mf);',inputs.ivpsol.ivpmex));
        
        if privstruct.iflag<0
            
            fprintf(1,'\n\nLSODES is reporting an integration error: %i\n',privstruct.iflag);
            fprintf(1,'Maybe the model is stiff, try lsodesst\n',privstruct.iflag);
            inputs.exps.count_failed_ivp=inputs.exps.count_failed_ivp+1;
            privstruct.ivpsol.ivp_fail=1;
            n_amigo_sim_failed=n_amigo_sim_failed+1;
        else
            
            privstruct.ivpsol.ivp_fail=0;
            inputs.exps.count_success_ivp=inputs.exps.count_success_ivp+1;
            n_amigo_sim_success=n_amigo_sim_success+1;
        end
        
    case 'lsodesst'
        
        privstruct.iflag=1;
        mf=222;
        eval(sprintf('[yteor privstruct.iflag]=%s(inputs.model.n_st,inputs.exps.t_in{iexp},privstruct.vtout{iexp}'',n_vtout,privstruct.t_int{iexp}'',n_int, privstruct.t_con{iexp}'',ncon{iexp},y_0,inputs.ivpsol.rtol,inputs.ivpsol.atol,par,size(par,2),ipar,1,privstruct.u{iexp},inputs.exps.pend{iexp},n_u,privstruct.iflag,mf);',inputs.ivpsol.ivpmex));
        
        if privstruct.iflag<0
            
            fprintf(1,'\n\nLSODES is reporting an integration error: %i\n',privstruct.iflag);
            privstruct.ivpsol.ivp_fail=1;
            n_amigo_sim_failed=n_amigo_sim_failed+1;
            
        else
            
            privstruct.ivpsol.ivp_fail=0;
            n_amigo_sim_success=n_amigo_sim_success+1;
            
        end
        
    case 'rkf45'
        
        privstruct.iflag=1;
        eval(sprintf('[yteor privstruct.iflag]=%s(inputs.model.n_st,inputs.exps.t_in{iexp},privstruct.vtout{iexp}'',n_vtout,privstruct.t_int{iexp}'',n_int,privstruct.t_con{iexp}'',ncon{iexp},y_0,inputs.ivpsol.rtol,inputs.ivpsol.atol,par,size(par,2),ipar,1,privstruct.u{iexp},inputs.exps.pend{iexp},n_u,privstruct.iflag);',inputs.ivpsol.ivpmex));
        
        if privstruct.iflag>2
            
            disp('\n\nPlease, review your ODEs or change IVP solver, RKF45 is reporting an integration error');
            privstruct.ivpsol.ivp_fail=1;
            
            n_amigo_sim_failed=n_amigo_sim_failed+1;
            
        else
            
            privstruct.ivpsol.ivp_fail=0;
            n_amigo_sim_success=n_amigo_sim_success+1;
            
        end
        
    case {'ode15s'}
        
        % INTEGRATION LOOP
        
        if(isempty(inputs.exps.pend{iexp}))
            inputs.exps.pend{iexp}=zeros(1,inputs.model.n_st);
        end
        
        if isempty(inputs.model.mass_matrix)==0
            options = odeset('RelTol',inputs.ivpsol.rtol,'AbsTol',inputs.ivpsol.atol,'BDF','on','Mass',inputs.model.mass_matrix);
        else
            options = odeset('RelTol',inputs.ivpsol.rtol,'AbsTol',inputs.ivpsol.atol,'BDF','on');
        end
        if privstruct.t_int{iexp}(1)==inputs.exps.t_in{iexp}
            yteor(1,:)=y_0;
            i_int=2;
        else
            i_int=1;
        end
        i_con=1;
        
        if inputs.model.n_stimulus<1
            
            %privstruct.vtout{iexp}=privstruct.t_int{iexp};   % already initialized
            %in AMIGO_init_times.m
            eval(sprintf('[t,yout] = %s(''%s'',privstruct.vtout{iexp},y_0,options, par'',privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.ivpsol.ivpsolver,inputs.model.matlabmodel_file) );
            
            if inputs.exps.n_s{iexp}== 1 && size(privstruct.vtout{iexp},2)<=inputs.exps.n_s{iexp}+1
                
                yteor=yout(end,:);
                
            elseif (inputs.exps.n_s{iexp}== size(privstruct.vtout{iexp},2)-1) && (inputs.exps.n_s{iexp}> 1)
                % first sampling time is not the initial time
                yteor=yout(2:inputs.exps.n_s{iexp}+1,:);
                
            elseif (inputs.exps.n_s{iexp}== size(privstruct.vtout{iexp},2)-2) && (inputs.exps.n_s{iexp}> 1)
                % first sampling time is not the initial time and also the
                % last sampling time is not the final time. 
                 yteor=yout(2:inputs.exps.n_s{iexp}+1,:);
            else
                
                yteor=yout;
                

                if size(yteor,1)<length(privstruct.vtout{iexp})
                    
                    yteor=zeros(length(privstruct.vtout{iexp}),inputs.model.n_st);
                    fprintf(1,'\n\nODE15s is reporting an integration error.\n');
                    privstruct.ivpsol.ivp_fail=1;
                    n_amigo_sim_failed=n_amigo_sim_failed+1;
                    
                else
                    
                    privstruct.ivpsol.ivp_fail=0;
                    n_amigo_sim_success=n_amigo_sim_success+1;
                    
                end
            end
            
            
        else   %if inputs.model.n_stimulus<1
            
            
            switch inputs.exps.u_interp{iexp}
                
                case 'sustained'
                 
                       eval(sprintf('[t,yout] = %s(''%s'',privstruct.vtout{iexp},y_0,options, par'',privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.ivpsol.ivpsolver,inputs.model.matlabmodel_file) );
                    %inputs.exps.n_s{iexp}
                    if inputs.exps.n_s{iexp}== 1 && size(privstruct.vtout{iexp},2)<=inputs.exps.n_s{iexp}+1
                        yteor=yout(end,:);
                    elseif (inputs.exps.n_s{iexp}== size(privstruct.vtout{iexp},2)-1) && (inputs.exps.n_s{iexp}> 1)
                        yteor=yout(2:inputs.exps.n_s{iexp}+1,:);
                    else
                        yteor=yout;
                        
                         if size(yteor,1)<length(privstruct.vtout{iexp})
                    
                         yteor=zeros(length(privstruct.vtout{iexp}),inputs.model.n_st);
                         fprintf(1,'\n\nODE15s is reporting an integration error.\n');
                         privstruct.ivpsol.ivp_fail=1;
                         n_amigo_sim_failed=n_amigo_sim_failed+1;
                    
                         else
                         privstruct.ivpsol.ivp_fail=0;
                         n_amigo_sim_success=n_amigo_sim_success+1;
                         end
  
                        
                    end
                    
                    
                otherwise
                    
                    for i_out=1:size(privstruct.vtout{iexp},2)-1
                        
                        tin=privstruct.vtout{iexp}(i_out);
                        tout=privstruct.vtout{iexp}(i_out+1);
                        eval(sprintf('[t,yout] = %s(''%s'',[tin tout],y_0,options, par'',privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.ivpsol.ivpsolver,inputs.model.matlabmodel_file) );
                        % Keep values to next integration step
                        y_0=yout(size(t,1),:);
                        
                        % If t out= t measurement, keep information
                        if (i_int<=size(privstruct.t_int{iexp},2)) && (tout==privstruct.t_int{iexp}(i_int))
                            yteor(i_int,:)=yout(size(t,1),:);
                            i_int=i_int+1;
                        end
                        % If t out= t control, update control value
                        if (privstruct.n_steps{iexp}+1>1)
                            if (tout>=privstruct.t_con{iexp}(i_con+1)) && ((i_con+1)<privstruct.n_steps{iexp}+1)
                                i_con=i_con+1;
                            end
                        end
                        
                        t_old=privstruct.t_con{iexp}(i_con);
                        
                    end % END INTEGRATION LOOP
                    
            end %switch inputs.exps.u_interp{iexp}
            
        end %inputs.model.n_stimulus<1
        
    case {'ode113','ode45'}
        
        % INTEGRATION LOOP
        
        if(isempty(inputs.exps.pend{iexp}))
            inputs.exps.pend{iexp}=zeros(1,inputs.model.n_st);
        end
        options = odeset('RelTol',inputs.ivpsol.rtol,'AbsTol',inputs.ivpsol.atol);
        
        if privstruct.t_int{iexp}(1)==inputs.exps.t_in{iexp}
            yteor(1,:)=y_0;
            i_int=2;
        else
            i_int=1;
        end
        i_con=1;
        
        if inputs.model.n_stimulus<1
            
     
            eval(sprintf('[t,yout] = %s(''%s'',privstruct.vtout{iexp},y_0,options, par'',privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.ivpsol.ivpsolver,inputs.model.matlabmodel_file) );
            
            if inputs.exps.n_s{iexp}== 1 && size(privstruct.vtout{iexp},2)<=inputs.exps.n_s{iexp}+1
                
                yteor=yout(end,:);
                
            elseif (inputs.exps.n_s{iexp}== size(privstruct.vtout{iexp},2)-1) && (inputs.exps.n_s{iexp}> 1)
                
                yteor=yout(2:inputs.exps.n_s{iexp}+1,:);
                
            else
                
                yteor=yout;
                
            end
            
        else
            
            switch inputs.exps.u_interp{iexp}
                
                case 'sustained'
                    
                    eval(sprintf('[t,yout] = %s(''%s'',privstruct.vtout{iexp},y_0,options, par'',privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.ivpsol.ivpsolver,inputs.model.matlabmodel_file) );
                    
                    if inputs.exps.n_s{iexp}== 1 && size(privstruct.vtout{iexp},2)<=inputs.exps.n_s{iexp}+1
                        
                        yteor=yout(end,:);
                        
                    elseif (inputs.exps.n_s{iexp}== size(privstruct.vtout{iexp},2)-1) && (inputs.exps.n_s{iexp}> 1)
                        
                        yteor=yout(2:inputs.exps.n_s{iexp}+1,:);
                        
                    else
                        
                        yteor=yout;
                        
                    end
                    
                    
                otherwise
                    
                    for i_out=1:size(privstruct.vtout{iexp},2)-1
                        
                        tin=privstruct.vtout{iexp}(i_out);
                        tout=privstruct.vtout{iexp}(i_out+1);
                        eval(sprintf('[t,yout] = %s(''%s'',[tin tout],y_0,options, par'',privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.ivpsol.ivpsolver,inputs.model.matlabmodel_file) );
                        % Keep values to next integration step
                        y_0=yout(size(t,1),:);
                        
                        % If t out= t measurement, keep information
                        if (i_int<=size(privstruct.t_int{iexp},2)) && (tout==privstruct.t_int{iexp}(i_int))
                            
                            yteor(i_int,:)=yout(size(t,1),:);
                            i_int=i_int+1;
                            
                        end
                        % If t out= t control, update control value
                        if (privstruct.n_steps{iexp}+1>1)
                            
                            if (tout>=privstruct.t_con{iexp}(i_con+1)) & ((i_con+1)<privstruct.n_steps{iexp}+1)
                                i_con=i_con+1;
                            end
                            
                        end
                        
                        t_old=privstruct.t_con{iexp}(i_con);
                        
                    end % END INTEGRATION LOOP
                    
            end %switch inputs.exps.u_interp{iexp}
            
        end %  if inputs.model.n_stimulus<1
        
        
    case 'blackboxmodel'
        
        privstruct.iflag=1;
        blackboxmodel_file=strcat(inputs.model.blackboxmodel_file);
        [yteor privstruct.iflag]=feval(blackboxmodel_file,inputs.exps.t_in{iexp},inputs.exps.t_f{iexp},privstruct.t_int{iexp},y_0,par,privstruct.u{iexp},inputs.exps.pend{iexp},privstruct.t_con{iexp},iexp);
        
        privstruct.ivpsol.ivp_fail=0;
        n_amigo_sim_success=n_amigo_sim_success+1;
            
    case 'cvodes'
        
        if(~isfield(inputs.exps,'pend') || isempty(inputs.exps.pend{iexp}))
            inputs.exps.pend{iexp}=zeros(1,length(privstruct.t_con{iexp})-1);
        end
        
        if(size(inputs.model.J,1)>0 || (isfield(inputs.model,'AMIGOjac') && inputs.model.AMIGOjac == 1 ))
            jacobian=1;
        else
            jacobian=0;
        end
        if isfield(inputs.model, 'debugmode') && inputs.model.debugmode,
            fprintf('cvodes_mex starts...\n');
        end
        if isfield(inputs.model, 'debugmode') && inputs.model.debugmode,
            fprintf('cvodes_mex starts...\n');
        end
        neval = n_amigo_sim_success + n_amigo_sim_failed;
%         if mod(neval,10)==0
%             fprintf('#%d.\n',n_amigo_sim_success + n_amigo_sim_failed);
%             fprintf('%.14g ',par);
%             fprintf('\n')
%         end
        if inputs.pathd.print_details
            disp('--> cvodes_ivp()')
        end


        [yteor, privstruct.iflag, sens,  privstruct.ivpsol.dxdt{iexp}]=feval(inputs.ivpsol.ivpmex,...
            inputs.model.n_par,... 0 Number of parameters
            0,... 1 activate sensitivity
            par,...2 parameters
            ones(1,inputs.model.n_par),...3 isoptpar
            inputs.exps.t_in{iexp},...4 t initial
            privstruct.t_f{iexp},...5 t final
            size(privstruct.t_int{iexp},2),...6 n_times
            privstruct.t_int{iexp},...7 t
            inputs.model.n_st,...8 n_states
            y_0,...9 Intiial values for state variables
            inputs.model.n_stimulus,... 10
            length(privstruct.t_con{iexp}),... 11 Number of controls changes(handle discontinuities)
            privstruct.t_con{iexp},...12 Times of such discontinuities
            privstruct.u{iexp}',... 13 Values of stimuli
            inputs.exps.pend{iexp}',... 14 Slope of the line
            inputs.ivpsol.rtol,...15 reltol
            inputs.ivpsol.atol,...16 atol
            inputs.ivpsol.max_step_size,... 17 max_step_size
            inputs.ivpsol.ivp_maxnumsteps,... 18 max_num_steps
            50,...% 19max_error_test_fails
            0,...20 Sensitivity analysis=false
            jacobian,...%21 use of the jacobian
            iexp-1,... %22 experiment number
            zeros(1,inputs.model.n_st)); % 23 estimated initial conditions for sens calc only. 
        %         clear (inputs.ivpsol.ivpmex)
         if inputs.pathd.print_details
            disp('<-- cvodes_ivp()')
        end
        if isfield(inputs.model, 'debugmode') && inputs.model.debugmode,
            fprintf('cvodes_mex ends...\n');
            %             [uV sV] = memory;
            % clear(inputs.ivpsol.ivpmex);
            % fprintf('mex cleared\n');
        end
%          replace the NaN points from the solution by 0 for the further
%          process. Ie. parameter estimaiton
%                  fnanRow = find(isnan(yteor), 1, 'first');
%                  nanFlag = ~isempty(fnanRow);
%                  if nanFlag
%                      yteor(fnanRow:end,:) = 0;
%                      %fprintf('wrn: NaN occured in the solution of the IVP. NaN values are replaced by 0s.\n');
%                  end
        
    
        if privstruct.iflag
            
            privstruct.ivpsol.ivp_fail=1;
            n_amigo_sim_failed=n_amigo_sim_failed+1;
            
        else
            
            privstruct.ivpsol.ivp_fail=0;
            n_amigo_sim_success=n_amigo_sim_success+1;
            
        end
        
end     %switch



return
end

function report_ivpsolver_options(inputs)
if isempty(inputs.pathd.report)
    inputs.pathd.report = 'tmp_report.txt';
end
ffid=fopen(inputs.pathd.report,'a+');
for fid = [1 ffid] % printf on screen then in file
    fprintf(fid,'\n\n-----------------------------------------------\n');
        fprintf(fid,' Initial value problem related active settings\n');
    fprintf(fid,'-----------------------------------------------\n');
    fprintf(fid,'ivpsolver: %s\n',inputs.ivpsol.ivpsolver);
    fprintf(fid,'RelTol: %g\n',inputs.ivpsol.rtol);
    fprintf(fid,'AbsTol: %g\n',inputs.ivpsol.atol);
    switch inputs.ivpsol.ivpsolver
        case 'radau5'
            fprintf(fid,'mexfile: %s\n',inputs.ivpsol.ivpmex);
            % no specific options
        case 'lsoda'
            fprintf(fid,'mexfile: %s\n',inputs.ivpsol.ivpmex);
            % no specific options
        case 'lsodes'
            fprintf(fid,'mexfile: %s\n',inputs.ivpsol.ivpmex);
            printf(fid,'mf = 10. Adams method for mildly stiff problems.\n');  % What is this? Is it s setting?
        case 'lsodesst'
            fprintf(fid,'mexfile: %s\n',inputs.ivpsol.ivpmex);
            fprintf(fid,'mf = 222. BDF method for stiff problems.\n');  % What is this? Is it s setting?
        case 'rkf45'
            fprintf(fid,'mexfile: %s\n',inputs.ivpsol.ivpmex);
        case 'ode15s'
            fprintf(fid,'Backward Differentiation (BDF): on\n');
            if isempty(inputs.model.mass_matrix)==0
                fprintf(fid,'Mass matrix: given\n');
            end
            fprintf(fid,'MATLAB model file: %s\n',inputs.model.matlabmodel_file);
        case {'ode113','ode45'}
            fprintf(fid,'MATLAB model file: %s\n',inputs.model.matlabmodel_file);
        case 'blackboxmodel'
            % no options
        case 'cvodes'
            if size(inputs.model.J,1)>0 || inputs.model.AMIGOjac == 1 
                fprintf(fid,'Jacobian: symbolically given\n');
%             else
%                 fprintf(fid,'Jacobian: internally by Finite Difference\n');
            end
            fprintf(fid,'MaxStepSize: %g\n', inputs.ivpsol.max_step_size);
            fprintf(fid,'MaxNumberOfSteps: %g\n',inputs.ivpsol.ivp_maxnumsteps);
    end
end
fclose(ffid);
end