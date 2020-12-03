

% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_sens.m 2400 2015-12-04 07:06:33Z evabalsa $
function [results,privstruct]=AMIGO_sens(inputs,results,privstruct,iexp)
% AMIGO_sens: Computes local sensitivities with respect to unknowns
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
%  AMIGO_sens: calculates local sensitivities by using user selected method   %
%              ODESSA: computes local sensitivities for initial conditions    %
%                      and parameters. Requiered sensitivites are selected    %
%                      a posteriori.                                          %
%                                                                             %
%              sensmat: uses sens_sys to compute sensitivities for matlab     %
%                      note that it requires two matlab files with odes       %
%                      to compute sensitivites for initial conditions         %
%                                                                             %
%              fdsens: computes sensitivies by finite differences             %
%*****************************************************************************%

global n_amigo_sim_success;
global n_amigo_sim_failed;
global n_amigo_sens_success;
global n_amigo_sens_failed;
global report_sens


if report_sens==0
    report_senssolver_options(inputs);
    report_sens = 1;
end
cont_istate=0;
results.rank.number_int_errors=0;

%SIMULATION FOR ALL EXPERIMENTS
counter_g1=0;
privstruct.istate_sens=2;

n_par=inputs.model.n_par+inputs.PEsol.n_theta_y0;

% compute the sensitivities with respect to the optimisation
% parameters:
index_theta=[inputs.PEsol.index_global_theta inputs.PEsol.index_local_theta{iexp}];
index_estic=[inputs.PEsol.index_global_theta_y0 inputs.PEsol.index_local_theta_y0{iexp}];
isoptpar = zeros(1,inputs.model.n_par);
isoptic = zeros(1,inputs.model.n_st);
isoptpar(index_theta)=1;
isoptic(index_estic)=1;

switch inputs.ivpsol.senssolver
    
    case 'cvodes'
        
        if(size(inputs.model.J,1)>0 || (isfield(inputs.model,'AMIGOjac') && inputs.model.AMIGOjac == 1 ))
            jacobian=1;
        else
            jacobian=0;
        end
        
        sensflag = 1;
        
        if isfield(inputs.model,'AMIGOsensrhs') && inputs.model.AMIGOsensrhs
            % activate the use of the analytic right hand side of
            % sensitivity equations
            sensflag = 2;
        end
        
        AMIGO_uinterp
        
        %Preguntar a David en relaci?n privstruct.exp_y0{iexp}]
         if inputs.pathd.print_details
            disp('--> cvodes_sens()')
         end
         
 
        privstruct.exp_y0=privstruct.y_0;
        [privstruct.yteor privstruct.iflag dydpt_optvar...
            privstruct.ivpsol.dxdt{iexp} privstruct.senssol.dsdt]=feval(inputs.ivpsol.sensmex,...
            length(isoptpar),...Number of parameters
            sensflag,...activate sensitivity
            privstruct.par{iexp},...parameters
            isoptpar,...isoptpar    ones(1,inputs.model.n_par)
            inputs.exps.t_in{iexp},...t initial
            privstruct.t_f{iexp},...t final
            size(privstruct.t_int{iexp},2),...n_times
            privstruct.t_int{iexp},...t
            inputs.model.n_st,...n_states
            privstruct.exp_y0{iexp},...Intiial values for state variables
            inputs.model.n_stimulus,...
            length(privstruct.t_con{iexp}),...Number of controls changes(handle discontinuities)
            privstruct.t_con{iexp},...Times of such discontinuities
            privstruct.u{iexp}',... Values of stimuli
            inputs.exps.pend{iexp},... Slope of the line
            inputs.ivpsol.rtol,...reltol
            inputs.ivpsol.atol,...atol
            inputs.ivpsol.max_step_size,...max_step_size
            inputs.ivpsol.sens_maxnumsteps,...max_num_steps
            50,...%max_error_test_fails
            sensflag,...Sensitivity analysis=false
            jacobian,...)%use of the jacobian
            iexp-1,...
			isoptic); % vector of estimated initial condition 
		if inputs.pathd.print_details
            disp('<-- cvodes_sens()')
        end
        privstruct.senssol.sens = dydpt_optvar;
        if inputs.PEsol.n_theta_y0>0
            n_par=inputs.model.n_par+inputs.model.n_st;
        end
        n_est_par = sum(isoptpar);
        n_est_ic = sum(isoptic);
        
        % initialize with zeros
        dydpt_full = zeros(privstruct.n_s{iexp},inputs.model.n_st,n_par);
        % fill the sensitivities that were computed
        dydpt_full(:,:,[index_theta]) = dydpt_optvar(:,:,1:n_est_par);
        % fill the sensitivities wrt to IC-s that were computed:
        dydpt_full(:,:,inputs.model.n_par  + [index_estic]) = dydpt_optvar(:,:,n_est_par+1 : n_est_par+n_est_ic);
        % add zeros for the sens wrt to the initial conditions
        %dydpt_full(:,:,end+1:(end+inputs.model.n_st ))=0;
        %senst_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par+inputs.model.n_st);
      
        if ~privstruct.iflag
            
            privstruct.istate_sens=1;
            n_amigo_sens_success=n_amigo_sens_success+1;
            n_amigo_sim_success=n_amigo_sim_success+1;
            
        else
            
            privstruct.istate_sens=-1;
            n_amigo_sens_failed=n_amigo_sens_failed+1;
            n_amigo_sim_failed=n_amigo_sim_failed+1;
            
        end
        
        try
            
            results.sim.states{iexp};
            
        catch e
            
            results.sim.states{iexp}=privstruct.yteor;
            
        end
        
    case 'odessa'
        
        % Sensitivities for charmodel and fortranmodel
        % Integration loop for odessa
        
        n_par=inputs.model.n_par+inputs.model.n_st;
        
        % Memory allocation for matrices and some initializations
        dydpt_full=zeros(privstruct.n_s{iexp},inputs.model.n_st,n_par);
        privstruct.yteor=zeros(privstruct.n_s{iexp},inputs.model.n_st);
        senst_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
        r_sens_t_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
        inputs.PEsol.sens0=zeros(inputs.model.n_st,n_par);
        counter_gl=counter_g1+inputs.PEsol.n_local_theta{iexp};
        
        %Initialize sensitivities for initial conditions
        if inputs.PEsol.n_theta_y0>0
            inputs.PEsol.sens0([1:inputs.model.n_st],[inputs.model.n_par+1:inputs.model.n_par+inputs.model.n_st])=eye(inputs.model.n_st);
        end
        %Initialize sensitivities
        
        y_sens_0=[privstruct.y_0{iexp}' inputs.PEsol.sens0];
        sens_y0=inputs.PEsol.sens0;
        
        % HANDLING CONTROL PARAMETERIZATION
        % n_rho: number of steps or ramps
        
        AMIGO_uinterp
        
        % Initialize time
        
        t_old=privstruct.t_con{iexp}(1);
        
        AMIGO_loop_odessa  % Integration with sensitivities
        
        if  privstruct.istate_sens<0
            
            results.rank.number_int_errors=results.rank.number_int_errors+1;
            n_amigo_sens_failed=n_amigo_sens_failed+1;
            n_amigo_sim_failed=n_amigo_sim_failed+1;
            return;
            
        else
            
            n_amigo_sens_success=n_amigo_sens_success+1;
            n_amigo_sim_success=n_amigo_sim_success+1;
            
        end
        
    case 'sensmat'
        
        % Sensitivities for matlabmodel and sbmlmodel
        % Integration loop for sens_sys
        % COMPUTING SENSITIVITIES FOR PARAMETERS
        
        if inputs.PEsol.n_theta_y0>0
            n_par=inputs.model.n_par+inputs.model.n_st;
            dydpt_full=zeros(privstruct.n_s{iexp},inputs.model.n_st,n_par);
            privstruct.yteor=zeros(privstruct.n_s{iexp},inputs.model.n_st);
            senst_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
            r_sens_t_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
            inputs.PEsol.sens0=zeros(inputs.model.n_st,n_par);
            counter_gl=counter_g1+inputs.PEsol.n_local_theta{iexp};
            inputs.ivpsol.senssolver='fdsens5';
            AMIGO_fdsens
        else
            n_par=inputs.model.n_par;
            % Memory allocation for matrices and some initializations
            dydpt_full=zeros(privstruct.n_s{iexp},inputs.model.n_st,n_par);
            privstruct.yteor=zeros(privstruct.n_s{iexp},inputs.model.n_st);
            senst_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
            r_sens_t_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
            inputs.PEsol.sens0=zeros(inputs.model.n_st,n_par);
            counter_gl=counter_g1+inputs.PEsol.n_local_theta{iexp};
            
            %Initialize sensitivities
            y_sens_0=[privstruct.y_0{iexp}' inputs.PEsol.sens0];
            sens_y0=inputs.PEsol.sens0;
            
            % HANDLING CONTROL PARAMETERIZATION
            % n_rho: number of steps or ramps
                     
            if inputs.model.uns==0
            AMIGO_uinterp
            if inputs.exps.u_delay_flag{iexp}==1    
            AMIGO_uinterp_delay
            end
            else
                   
            % Assigns t_con
            privstruct.t_con{iexp}=[inputs.exps.t_in{iexp} inputs.exps.t_f{iexp}];
            privstruct.n_steps{iexp}=1;  
            end %if inputs.model.uns==0
            
            % Initialize time
                      

            t_old=privstruct.t_con{iexp}(1);
            
            % Integration loop for sens_sys. Sens_sys has been selected
            % since it is reported to be more accurate than sens_ind
            
            AMIGO_loop_senssys
            
        end
        
    case {'fdsens2','fdsens5'}
        
        % Finite differences sensitivities
        % Computes finite differences sensitivities for the unkwnown
        % parameters privstruct.par{iexp} and unknwown initial conditions
        % privstruct.y_0{iexp}
        n_par=inputs.model.n_par+inputs.model.n_st;
        dydpt_full=zeros(privstruct.n_s{iexp},inputs.model.n_st,n_par);
        privstruct.yteor=zeros(privstruct.n_s{iexp},inputs.model.n_st);
        senst_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
        r_sens_t_full=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},n_par);
        inputs.PEsol.sens0=zeros(inputs.model.n_st,n_par);
        
        AMIGO_fdsens
        
end  %switch inputs.ivpsol.senssolver


%  Calls AMIGO_gen_measurement, to generate measurementes for sensitivity calculation
%  OJO!!! ESTA SENTENCIA HABRA DE MODIFICARSE PARA PODER CONSIDERAR
%  PARAMETROS EN LOS OBSERVABLES!!!


obsfunc=inputs.pathd.obs_function;

if isfield(inputs.exps,'NLObs') && inputs.exps.NLObs
    % nonlinear observation functions
    obssensfunc = inputs.pathd.obs_sens_function;
else
    % linear observation functions
    obssensfunc = inputs.pathd.obs_function;
end


if exist(obssensfunc,'file') == 2
    % observation function exists
    if isfield(inputs.exps,'NLObs') && inputs.exps.NLObs   
        senst_full = feval(obssensfunc,privstruct.yteor,permute(dydpt_full,[2 3 1]),inputs,privstruct.par{iexp},iexp);
        senst_full = permute(senst_full,[3,1,2]);
    else
        for ipar=1:n_par
            senst_full(:,:,ipar)=feval(obssensfunc,dydpt_full(:,:,ipar),inputs,privstruct.par{iexp},iexp);
        end
    end
else
    % observation function was not generated, try index observables
    for ipar=1:n_par
        warning('AMIGO_sens: Not observation function found. Tryign index_observables');
        senst_full(:,:,ipar)=dydpt_full(:,inputs.exps.index_observables{iexp},ipar);
    end
end

%   SELECTS THE REQUIRED SENSITIVITIES FOR FIM and RANK CALCULATIONS
% KEEPS SENSITIVITIES CORRESPONDING TO PARS AND INITIAL CONDITIONS

index_theta=[inputs.PEsol.index_global_theta inputs.PEsol.index_local_theta{iexp}];
index_y0=[];
if inputs.PEsol.n_global_theta_y0>=1
    index_y0=inputs.model.n_par.*ones(size(inputs.PEsol.index_global_theta_y0))+inputs.PEsol.index_global_theta_y0;
end
index_local_y0=[];
if inputs.PEsol.ntotal_local_theta_y0>=1
    index_local_y0=inputs.model.n_par.*ones(size(inputs.PEsol.index_local_theta_y0{iexp}))+inputs.PEsol.index_local_theta_y0{iexp};
end
index_y0=[index_y0 index_local_y0];


privstruct.sens_t{iexp}=senst_full(:,:,[index_theta index_y0]);

%  CALCULATE RELATIVE SENSITIVITIES

%  First check if any state becomes zero at any temporal node to remove it from sensitivities calculation

privstruct.row_yms_0{iexp}=[];
n_t_sampling=size(privstruct.t_s{iexp},2);

try
    privstruct.ms{iexp}=feval(obsfunc,privstruct.yteor,inputs,privstruct.par{iexp},iexp);
catch e
    warning('AMIGO_sens: Not observation function found. Tryign index_observables');
    privstruct.ms{iexp}=privstruct.yteor(:,inputs.exps.index_observables{iexp});
end


% Checks if some of the observables is fully zero

privstruct.row_yms_0{iexp}=[];

for i=1:n_t_sampling
    
    if isempty(find(privstruct.ms{iexp}(i,:)==0)),
        privstruct.row_yms_0{iexp}=[privstruct.row_yms_0{iexp}, i];
    else
        %  fprintf(1,'>>> Exp %u: Obs(s)is/are zero at the %ust sampling time. Data not used for relative sensitivities.\n', iexp,i);
        % results.rank.par_obs0=[results.rank.par_obs0; privstruct.par{iexp}];
    end
end

% Computes relative sensitivities for the parameters and the initial
% conditions


if privstruct.row_yms_0{iexp}>0
    for j=1:inputs.model.n_par
        % This line causes error if the sensitivity calculation fails.
        % 26/02/2015
        % Matrix dimensions must agree...
        r_sens_t_full(privstruct.row_yms_0{iexp},:,j)=(privstruct.par{iexp}(1,j)./privstruct.ms{iexp}(privstruct.row_yms_0{iexp},:)).*senst_full(privstruct.row_yms_0{iexp},:,j);
    end
    
    if inputs.PEsol.n_theta_y0>0
        for j=1:inputs.model.n_st
            r_sens_t_full(privstruct.row_yms_0{iexp},:,inputs.model.n_par+j)=(privstruct.y_0{iexp}(1,j)./privstruct.ms{iexp}(privstruct.row_yms_0{iexp},:)).*...
                senst_full(privstruct.row_yms_0{iexp},:,inputs.model.n_par+j);
        end
    end
    
    % KEEPS RELATIVE SENSITIVITIES CORRESPONDING TO PARS AND INITIAL CONDITIONS
    
    privstruct.r_sens_t{iexp}=r_sens_t_full(:,:,[index_theta index_y0]);
else
    fprintf(1,'>>> Relative sensitivities may not be computed one or more observables are zero over time in experiment %u\n',iexp);
    privstruct.r_sens_t{iexp}=zeros(privstruct.n_s{iexp},inputs.exps.n_obs{iexp},inputs.PEsol.n_theta+inputs.PEsol.n_theta_y0);
end



return
end

function report_senssolver_options(inputs)

ffid=fopen(inputs.pathd.report,'a+');
for fid = [1 ffid] % printf on screen then in file
    fprintf(fid,'\n\n---------------------------------------------------\n');
         fprintf(fid,'Local sensitivity problem related active settings\n');
    fprintf(fid,'---------------------------------------------------\n');
    fprintf(fid,'senssolver: %s\n',inputs.ivpsol.senssolver);
    fprintf(fid,'ivp_RelTol: %g\n',inputs.ivpsol.rtol);
    fprintf(fid,'ivp_AbsTol: %g\n',inputs.ivpsol.atol);
    
    switch inputs.ivpsol.senssolver
    
        case 'cvodes'
            fprintf('sens_RelTol: ~%g\n',inputs.ivpsol.rtol)
            fprintf(fid,'sensmex: %s\n',inputs.ivpsol.sensmex);
            if(size(inputs.model.J,1)>0 || inputs.model.AMIGOjac == 1 )
                fprintf(fid,'Jacobian: symbolically given\n');
            end
            if isfield(inputs.model,'AMIGOsensrhs') && inputs.model.AMIGOsensrhs
                fprintf(fid,'Forward Sensitivity Equations: symbolically given\n');
            end
            fprintf(fid,'MaxStepSize: %g\n', inputs.ivpsol.max_step_size);
            fprintf(fid,'MaxNumberOfSteps: %g\n',inputs.ivpsol.sens_maxnumsteps);
            
        case 'odessa'
            fprintf(fid,'sensmex: %s\n',inputs.ivpsol.sensmex);
            % no further options ? there are some integer inputs that are
            % not commented.
        case 'sensmat'
            if inputs.PEsol.n_theta_y0>0
                fprintf(fid,'sensolver is changed to fdens5');
            end
            fprintf(fid,'Backward Differentiation (BDF): on\n');
            fprintf(fid, 'modified sens_sys.m is used (ode15s based). For further info type ''help sens_sys''.\n');
        case {'fdsens2','fdsens5'}
            % no specific options.
    end
end
fclose(ffid);
end