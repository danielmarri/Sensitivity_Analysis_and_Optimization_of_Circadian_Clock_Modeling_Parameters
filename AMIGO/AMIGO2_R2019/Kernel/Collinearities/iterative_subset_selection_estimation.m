function [fitted_model select_parameters pe_results] = iterative_subset_selection_estimation(tot_estim_inputs, opts)
% iterative estimation of orthogonal subsets

if nargin <2
    opts = [];
end

pse_opts = check_opts(opts);

% check inputs and get AMIGO structures.
[~,tot_estim_inputs,AMIGOresults,AMIGOprivstruct]=evalc('AMIGO_Structs_PE(tot_estim_inputs)');



% initialize: estimate all parameters without local solver to get a good
% starting point.
if pse_opts.init_global_estimation
    init_inputs = tot_estim_inputs;
    init_inputs.nlpsol.eSS.local.solver = 0;
    init_inputs.nlpsol.eSS.local.finish = 0;
    init_results = AMIGO_PE(init_inputs);
    tot_estim_inputs.PEsol.global_theta_guess = init_results.fit.thetabest(:)';
end

iter = 0;
stop = false;

while ~stop
    iter = iter +1;
    
    %% select independent subset of parameters
    totaltheta =[tot_estim_inputs.PEsol.global_theta_guess ];
    [~,~,Rjac] = AMIGO_PEJac(totaltheta,tot_estim_inputs,AMIGOresults,AMIGOprivstruct);
    Rjac = Rjac.*repmat(totaltheta,size(Rjac,1),1);
    
    selected_pars{iter} = locally_identifiable_subset(Rjac,pse_opts.collinearity_threshold);
    selected_pars{iter} = sort(selected_pars{iter});
    
    red_estim_inputs{iter} = reduce_estim_problem(selected_pars{iter}, tot_estim_inputs);
    
    %% Estimate the parameters in the reduced estimation problem
    red_estim_results{iter} = AMIGO_PE(red_estim_inputs{iter});
    %      keyboard
    
    % report some iterative results
    
    % update the total problem
    
    tot_estim_inputs = update_estim_problem(selected_pars{iter}, red_estim_results{iter},tot_estim_inputs);
    
    
    % check conditions
    
    if iter == pse_opts.max_iter
        stop = true;
    end
    
end

if pse_opts.all_par
    % final refinement of the total model.
    red_estim_results{iter+1} = AMIGO_PE(tot_estim_inputs);
end

fitted_model = tot_estim_inputs;
select_parameters = selected_pars;
pe_results = red_estim_results;

end

function pse_opts = check_opts(opts)

% number of iteration
if isfield(opts,'max_iter') && not(isempty(opts.max_iter))
    pse_opts.max_iter = opts.max_iter;
else
    pse_opts.max_iter = 3;
end

% ranking
if isfield(opts,'ranking_method') && not(isempty(opts.ranking_method))
    pse_opts.ranking_method = opts.ranking_method;
else
    pse_opts.ranking_method = 'proj_rel_jacobian';
end


% initial estimation of all parameters
if isfield(opts,'init_global_estimation') && not(isempty(opts.init_global_estimation))
    pse_opts.init_global_estimation = opts.init_global_estimation;
else
    pse_opts.init_global_estimation = 0;
end


% final estimation of all parameters
if isfield(opts,'all_par') && not(isempty(opts.all_par))
    pse_opts.all_par = opts.all_par;
else
    pse_opts.all_par = 0;
end


% collinearity threshold
if isfield(opts,'collinearity_threshold') && not(isempty(opts.collinearity_threshold))
    pse_opts.collinearity_threshold = opts.collinearity_threshold;
else
    pse_opts.collinearity_threshold = 20;
end



end


function [prank crit] =  rank_estimated_parmeters(inputs,method,results,privstruct)
% returns the ranked indexes of the global_theta_guess and the value of the ranking criteria



theta =[inputs.PEsol.global_theta_guess ]; %inputs.PEsol.global_theta_y0_guess  cell2mat(inputs.PEsol.local_theta_guess)  cell2mat(inputs.PEsol.local_theta_y0_guess)

rank_limit = min(numel(theta),50);
switch method
    case 'proj_jacobian'
        [~,~,Rjac] = AMIGO_PEJac(theta,inputs,results,privstruct);
        [prank, proj]= AMIGO_rankbyprojection(Rjac,[],rank_limit);
        crit = proj;
    case 'proj_rel_jacobian'
        [~,~,Rjac] = AMIGO_PEJac(theta,inputs,results,privstruct);
        
        % rank by the relative Jacobians of the residuals
        Rjac = Rjac.*repmat(inputs.PEsol.global_theta_guess,size(Rjac,1),1);
        
        [prank, proj]= AMIGO_rankbyprojection(Rjac,[],rank_limit);
        crit = proj;
        
    case 'sensitivity'
        % based on the commulative sensitivity of the parameters
        
    case 'uncorrelated'
        % do a correlation analysis and select a non-correlated subset.
        
    otherwise
        error('no such method in rank_parameters(): %s',method)
end
end

function u_inputs = reduce_estim_problem(prank, inputs)
% works only for global parameters...

% keep only the estimated parameters in the PEsol
u_inputs = inputs;

% fill the non-estimated parameters with the guess!
u_inputs.model.par(inputs.PEsol.index_global_theta) = inputs.PEsol.global_theta_guess;

u_inputs.PEsol.n_global_theta = length(prank);
u_inputs.PEsol.index_global_theta = inputs.PEsol.index_global_theta(prank);
u_inputs.PEsol.id_global_theta = inputs.PEsol.id_global_theta(prank,:);
u_inputs.PEsol.global_theta_guess = inputs.PEsol.global_theta_guess(:,prank);
u_inputs.PEsol.global_theta_max = inputs.PEsol.global_theta_max(:,prank);
u_inputs.PEsol.global_theta_min = inputs.PEsol.global_theta_min(:,prank);

% update the logarithmic scaling indices in eSS.log_var
% 1. find the logarithmic parameters that are estimated after subset selection:
rem_log = intersect(inputs.nlpsol.eSS.log_var,prank);
% 2. determine their new indices.
characteristic_set = ismember(prank,rem_log);
indices = 1:numel(prank);
u_inputs.nlpsol.eSS.log_var =indices(characteristic_set);

u_inputs.PEsol.ntotal_theta= length(prank);
u_inputs.PEsol.vtheta_guess = inputs.PEsol.vtheta_guess(:,prank);
u_inputs.PEsol.vtheta_max = inputs.PEsol.vtheta_max(:,prank);
u_inputs.PEsol.vtheta_min = inputs.PEsol.vtheta_min(:,prank);

if inputs.PEsol. ntotal_local_theta + inputs.PEsol.ntotal_local_theta_y0 > 0
    fprintf(2,'ERROR: local parameters are detected. Subset selection was tested only for global parameters.\n');
    error('ERROR: local parameters are detected. Subset selection was tested only for global parameters.\n Consider to formulate the problem with global parameters only.')
end
end


function tot_estim_inputs = update_estim_problem(selected_pars, red_estim_results,tot_estim_inputs)

tot_estim_inputs.PEsol.global_theta_guess(selected_pars) = red_estim_results.fit.thetabest;
tot_estim_inputs.PEsol.vtheta_guess(selected_pars) = red_estim_results.fit.thetabest;
% update the model parameters, because they are used in the next iteration
% if they are not estimated.
tot_estim_inputs.model.par(tot_estim_inputs.PEsol.index_global_theta(selected_pars)) = red_estim_results.fit.thetabest;
end
