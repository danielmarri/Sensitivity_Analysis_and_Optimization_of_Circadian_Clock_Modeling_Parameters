
function [PE_results AMIGO_PE_results_s1 utopia] = AMIGO_solve_REGPE_forPoints(inputs,reg_inputs,reg_results)
% Solves the nonlinear parameter estimation problem for a set of regularization
% parameter in 2 steps:
%   Step 1: solves the problem with each regularization parameter
%   Step 2: for each regularization parameter, starts a multistart from the
%           optima obtained in Step 1. -- this  increases the chance that
%           the solution with all the regularization parameter converged to
%           a global minimum.
% INPUTS:
%   inputs:      description of the estimation problem
%   reg_inputs:  regularization parameter related inputs containing 2 fields
%         .nalpha   number of regularization parameters
%         .alphaSet regularization parameters
%   reg_results: previously obtained results (reg_summary object)

%% INITIALIZATION
% Setup the initial guesses for the parameters/ICs
if isempty(reg_results)
    iguess_set = AMIGO_update_parameter_guesses(inputs);
    n_pre_alpha = 0;
    pre_alpha = [];
else
    iguess_set = AMIGO_update_parameter_guesses(inputs,[],reg_results.theta,reg_results.alpha);
    n_pre_alpha = reg_results.n_results;
    pre_alpha = reg_results.alpha;
end

% find the open figures:
%figHandles_openbefore = findall(0,'Type','figure');

nalpha = reg_inputs.nalpha;
alphaSet = sort( reg_inputs.alphaSet,'descend');

% Set-up inputs for AMIGO_PE:
AMIGO_PE_inputs = inputs;
npar = numel(inputs.model.par);
% Recalculate the time and funeval constraints:
fun_budget = AMIGO_PE_inputs.nlpsol.eSS.maxeval;
fun_budget_each = max(npar*100,fun_budget/(2*nalpha));
AMIGO_PE_inputs.nlpsol.eSS.maxeval = fun_budget_each;

time_budget = AMIGO_PE_inputs.nlpsol.eSS.maxtime;
time_budget_each = max(time_budget/(2*nalpha),5);  % give minimum 5 sec. each.
AMIGO_PE_inputs.nlpsol.eSS.maxtime = time_budget_each;

%% STEP 1: solve the problem with each regularization paramemter
% for plotting:
if inputs.nlpsol.regularization.plotflag
    titlestr = 'Step 1: solving PE with regularization parameters';  % title
    hfig1 = 1001;   % figure handler.
end


for ialpha = 1:nalpha
    fprintf(1,'-->   REGULARIZATION Report:\n');
    fprintf(1,'      Forward computation for the %d regularization parameter\n\n',ialpha);
    AMIGO_PE_inputs.nlpsol.regularization.alpha = alphaSet(ialpha);
    
    [AMIGO_PE_inputs.PEsol.global_theta_guess,...
        AMIGO_PE_inputs.PEsol.global_theta_y0_guess,...
        AMIGO_PE_inputs.PEsol.local_theta_guess,...
        AMIGO_PE_inputs.PEsol.local_theta_y0_guess] = AMIGO_init_parameter_guesses(inputs,iguess_set);
    
    
    AMIGO_PE_inputs.pathd.runident = sprintf('%s_regstep1_alpha%d',inputs.pathd.runident,ialpha);
    
    
    AMIGO_PE_results_s1(ialpha) = AMIGO_PE(AMIGO_PE_inputs);
    
    a = AMIGO_get_reg_summary(AMIGO_PE_results_s1(ialpha));
    Q_cost(ialpha) = a.Q_LS;
    Q_penalty(ialpha) = a.Q_penalty;
    theta_pre(ialpha,:) = a.theta;
    
    if inputs.nlpsol.regularization.plotflag
        AMIGO_update_LCurve_plot(hfig1,Q_cost(ialpha),Q_penalty(ialpha),alphaSet(ialpha),titlestr);
    end
    iguess_set = AMIGO_update_parameter_guesses(inputs,iguess_set,AMIGO_PE_results_s1(ialpha).fit.thetabest(:)',alphaSet(ialpha));
end


%% Compute Utopia points:
% no penalty:
AMIGO_PE_inputs.nlpsol.regularization.alpha = 0;
[AMIGO_PE_inputs.PEsol.global_theta_guess,...
    AMIGO_PE_inputs.PEsol.global_theta_y0_guess,...
    AMIGO_PE_inputs.PEsol.local_theta_guess,...
    AMIGO_PE_inputs.PEsol.local_theta_y0_guess] = AMIGO_init_parameter_guesses(inputs,iguess_set);

AMIGO_PE_inputs.pathd.runident = sprintf('%s_regstep1_alpha%d',inputs.pathd.runident,ialpha);


utopia.nopenalty.PEresults = AMIGO_PE(AMIGO_PE_inputs);
a = AMIGO_get_reg_summary(utopia.nopenalty.PEresults);

utopia.nopenalty.Q_cost = a.Q_LS;
utopia.nopenalty.Q_penalty = a.Q_penalty;
utopia.nopenalty.theta = a.theta;

if inputs.nlpsol.regularization.plotflag
    AMIGO_update_LCurve_plot(hfig1,utopia.nopenalty.Q_cost,utopia.nopenalty.Q_penalty,0,titlestr,'bs');
end
% No fit:
AMIGO_PE_inputs.nlpsol.regularization.alpha = 1;
theta_ref = [AMIGO_PE_inputs.nlpsol.regularization.tikhonov.gx0 AMIGO_PE_inputs.nlpsol.regularization.tikhonov.gy0 AMIGO_PE_inputs.nlpsol.regularization.tikhonov.lx0{:} AMIGO_PE_inputs.nlpsol.regularization.tikhonov.ly0{:}];
[f,~,~,regobj,~] = AMIGO_getPEcost( theta_ref  ,AMIGO_PE_inputs);

utopia.nofit.Q_cost = f;
utopia.nofit.Q_penalty = regobj;
utopia.nofit.theta = [AMIGO_PE_inputs.nlpsol.regularization.tikhonov.gx0 AMIGO_PE_inputs.nlpsol.regularization.tikhonov.gy0];

if inputs.nlpsol.regularization.plotflag
    AMIGO_update_LCurve_plot(hfig1,utopia.nofit.Q_cost,utopia.nofit.Q_penalty,inf,titlestr,'bs');
    plot(utopia.nopenalty.Q_cost,utopia.nofit.Q_penalty,'b*','Markersize',10)
end

%% Step 2: Smooth the Lcurve: multistart with the local solver of the ess (hopefully NL2SOL)
% Set-up inputs for AMIGO_PE
AMIGO_PE_inputs.nlpsol.nlpsolver =['multi_' AMIGO_PE_inputs.nlpsol.eSS.local.solver];% 'multi_nl2sol';
AMIGO_PE_inputs.nlpsol.multi_starts = 0; %this is the # of excess points.  iguess_set.n_guess;

% [AMIGO_PE_inputs.PEsol.global_theta_guess,...
%  AMIGO_PE_inputs.PEsol.global_theta_y0_guess,...
%  AMIGO_PE_inputs.PEsol.local_theta_guess,...
%  AMIGO_PE_inputs.PEsol.local_theta_y0_guess] = AMIGO_init_parameter_guesses(inputs,iguess_set);

if inputs.nlpsol.regularization.plotflag
    hfig2=1002;
    titlestr = 'Step 2: multistart local solver from the previous optima';
end
    
%AMIGO_update_LCurve_plot(hfig2,Q_cost,Q_penalty,alphaSet,titlestr);

% run for the newly asked points and the previously obtained points (for
% consistency)
nalpha = nalpha + n_pre_alpha;
alphaSet = sort([alphaSet pre_alpha],'descend');

% solve in the reverse order.
for ialpha = nalpha:-1:1
    fprintf(1,'-->   REGULARIZATION Report:\n');
    fprintf(1,'      Backward computation for the %d regularization parameter\n\n',ialpha);
    AMIGO_PE_inputs.nlpsol.regularization.alpha = alphaSet(ialpha);
    AMIGO_PE_inputs.pathd.runident = sprintf('%s_regstep2_alpha%d',inputs.pathd.runident,ialpha);
    
    % include in the initial guess the 6 nearest neighbour.
    [AMIGO_PE_inputs.PEsol.global_theta_guess,...
        AMIGO_PE_inputs.PEsol.global_theta_y0_guess,...
        AMIGO_PE_inputs.PEsol.local_theta_guess,...
        AMIGO_PE_inputs.PEsol.local_theta_y0_guess] = AMIGO_init_parameter_guesses(inputs,iguess_set,alphaSet(ialpha),3);
    
    PE_results(ialpha) = AMIGO_PE(AMIGO_PE_inputs);
    
    iguess_set = AMIGO_update_parameter_guesses(inputs,iguess_set,PE_results(ialpha).fit.thetabest(:)',alphaSet(ialpha));
    
    
    a = AMIGO_get_reg_summary(PE_results((ialpha)));
    Q_cost = a.Q_LS;
    Q_penalty = a.Q_penalty;
    %     theta(ialpha,:) = PE_results(ialpha).fit.thetabest;
    
    if inputs.nlpsol.regularization.plotflag
        AMIGO_update_LCurve_plot(hfig2,Q_cost,Q_penalty,alphaSet(ialpha),titlestr,'.m');
    end
end


end

