function [statistics  calibrated_model_sdata validation_model_sdata]= AMIGO_CompareModels(calibrated_model,validation_model,plot_flag,calibrated_model_SData,validation_model_SData)
% [] = AMIGO_CompareModels(calibrated_model,validation_model)
% compares the calibrated_model to the validation_model. The calibrated
% model is filled with the experimental design (conditions and
% measurements) from the validation model. Then the simulation results are
% compared based on metrics. 
%
% Inputs:
%   calibrated_model    a general AMIGO input structure required for
%                       AMIGO_SData to simulate the trajectories, this
%                       contains the model to be validated.
%   validation_model    a general AMIGO inputs structure for AMIGO_SData.
%                       Its experimental conditions are used to test the calibrated_model.
%   plot_flag (optional) indicate plotting the simulated models.
%   calibrated_model_SData (optional) simulation results of the calibrated model with AMIGO_SData
%   validation_model_SData (optional) simulation results of the validation model with AMIGO Sdata
%                      
% NOTE:
%    - if the validation_model does not contain experimental data, for
%    example, when pseudo-data is generated, then the
%    validation_model.inputs.par vector is used to generate the data, but!
%    the validation_model.PEsol.***_guess is used to calculate the distance
%    of the parameters from the calibrated_model's parameters.
% 
%   See also: AMIGO_PEPostAnalysis
%
% INTRODUCTION:
% AMIGO_CompareModels compute statistics corresponding to the model based on the conditions in validation_model.
% For examples:
%   (1) if validation_model is identical to the calibrated_model, one get
%   the statistics based on the trainig data.
%
%   (2) if validation_model contains experimental data, which is not used to
%   calibrate the model, one get statistics about the perfomance of the
%   calibrated model in cross validation
%
%   (3) if the validation_model is the true(nominal) model that generated the data,
%   one also get information about the distance of the true and the
%   calibrated model.
%
% COMPUTED STATISTICS:
% 1. Statistics based on the the calibration model and the validation model.
%       Here we measure the distance of the two models (measured data is not explicitly considered):
%
%       -PEE: parameter estimation error, i.e the 2-norm distance of the
%       parameters of the calibration_model and validation_model. (||pc-pv||)
%
%       -nPEE_2norm: normalized parameter estimation error: normalized by the
%       norm of the validation parameter vector. (||pc-pv||/||pv||)
%
%       -nPEE_rel: normalized parameter estimation error: each deviation is 
%       normalized (elementwise) by the validation model parameters (||(pci-pvi)/(pvi)||
%
%       -PE:  prediction error. The root mean square error in the
%       observables, but here the validation_model trajectories
%       (noise-free) are used instead of the data.
%
%       -nPE: normalized prediction error. The normalized root mean square
%       error equivalent, but computed from the noisefree simulation.
%
% 2. Statistics based on the calibration model and the DATA of the
% validation model: (validation model is not explicitly considered)
%
%       -Chi2: sum of squares prediction error between calibrated model and validation
%       data weighted by error in the data.
%
%       -RSS: sum of squares prediction error between calibrated model and validation
%       data (no weights)
%
%       -RMSE root mean square prediction error
%
%       -NRMSE normalized root mean square error
%
%       -R2: goodness of fit statistic observation function wise
%       -R2tot: global R2 statistics
%       -adjR2 adjusted R2 (number of fitted parameters is considered)
%
%   NOTEs:
%       To obtain:
%       -PSE: prediction state error. The root mean square error between
%       the calibrated and validation model.
%           -> define a validation model, where the observables are the
%           states.
%           -> also consider to refine the number of time points.

if nargin < 3 
    plot_flag = [];
end

simCalibFlag=0;simValidFlag=0; 
if nargin < 4 || isempty(calibrated_model_SData)
    simCalibFlag = 1;
end
    
if nargin < 5 || isempty(validation_model_SData)
    simValidFlag = 1;
end


if (strcmpi(validation_model.exps.data_type, 'pseudo') || strcmpi(validation_model.exps.data_type, 'pseudo_pos')) && (~isfield(validation_model.exps,'exp_data') ||  isempty(validation_model.exps.exp_data{1}))
    fprintf(2,'\n\n WARNING: AMIGO_CompareModels()\n\tNote that the validation_model.model.par is used to generate the data,\n\tbut the parametric distances are calculated from validation_model.PEsol.***guess vector\n\n');
end

% Simulation:
if ~isempty(plot_flag)
validation_model.plotd.plotlevel = plot_flag;
calibrated_model.plotd.plotlevel = plot_flag;
end


if simValidFlag
    
    validation_model = AMIGO_check_SData_inputs(validation_model);
    if isfield(validation_model.plotd,'data_plot_title')
        validation_model.plotd.data_plot_title = ['Simulation of validation model; ' validation_model.plotd.data_plot_title];
    else
        validation_model.plotd.data_plot_title = 'Simulation of validation model';
    end
    
    % Simulate the validation model
    validation_model_sdata = AMIGO_SData(validation_model);
    
else
    validation_model = AMIGO_check_SData_inputs(validation_model);
    validation_model_sdata = validation_model_SData;
end


if simCalibFlag
    % overwrite the experimental conditions:
    calibrated_model.exps = validation_model.exps;
    calibrated_model = AMIGO_check_SData_inputs(calibrated_model);
    if isfield(calibrated_model.plotd,'data_plot_title')
        calibrated_model.plotd.data_plot_title = [ 'Simulation of calibrated model; ' calibrated_model.plotd.data_plot_title];
    else
        calibrated_model.plotd.data_plot_title = 'Simulation of calibrated model';
    end
    
    % set up the calibrated model with validation data:
    calibrated_model.exps.exp_data =  validation_model_sdata.sim.exp_data;
    calibrated_model.exps.error_data =  validation_model_sdata.sim.error_data;
    calibrated_model.exps.data_type='real';
    % simulate the calibrated model:
    calibrated_model_sdata = AMIGO_SData(calibrated_model);
    
else
    calibrated_model_sdata = calibrated_model_SData;
end

estimated_parameters = [calibrated_model.PEsol.global_theta_guess  calibrated_model.PEsol.global_theta_y0_guess  cell2mat(calibrated_model.PEsol.local_theta_guess)  cell2mat(calibrated_model.PEsol.local_theta_y0_guess)];
validation_parameters = [validation_model.PEsol.global_theta_guess  validation_model.PEsol.global_theta_y0_guess  cell2mat(validation_model.PEsol.local_theta_guess)  cell2mat(validation_model.PEsol.local_theta_y0_guess)];

if isempty(validation_parameters)
    validation_parameters = validation_model.model.par;
end

% Compute statistics:
nexp = calibrated_model.exps.n_exp;

RSS =  AMIGO_RSS( calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.exp_data,1:nexp);
Chi2 = computeChi2(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.exp_data,validation_model_sdata.sim.error_data,nexp);
RMSE = computeRMSE(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.exp_data,nexp);
NRMSE= computeNRMSE(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.exp_data,nexp);
ANRMSE= computeANRMSE(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.exp_data,nexp);
[R2 R2tot adjR2]  = computeR2(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.exp_data,nexp,length(estimated_parameters));

%  statistics (includes the true model):
PEE         = computePEE(estimated_parameters, validation_parameters);
nPEE_2norm  = computeNPEE_2norm(estimated_parameters, validation_parameters);
nPEE_rel    = computeNPEE_rel(estimated_parameters, validation_parameters);
PE          = computeRMSE(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.sim_data,nexp);
NPE         = computeNRMSE(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.sim_data,nexp);
ANPE        = computeANRMSE(calibrated_model_sdata.sim.sim_data,validation_model_sdata.sim.sim_data,nexp);


% process results:
statistics.Chi2 = Chi2;
statistics.RSS = RSS;
statistics.RMSE = RMSE;
statistics.NRMSE = NRMSE;
statistics.ANRMSE = ANRMSE;
statistics.R2 = R2;
statistics.R2tot = R2tot;
statistics.adjR2 = adjR2;

statistics.PEE = PEE;
statistics.nPEE_2norm = nPEE_2norm;
statistics.nPEE_rel = nPEE_rel;
statistics.PE = PE;
statistics.NPE = NPE;
statistics.ANPE = ANPE;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RSS =  computeRSS( sim_data,exp_data,nexp)
% residual sum of squares
RSS = 0;
for iexp = 1:nexp
    RSS  = RSS  + sum(sum(( exp_data{iexp} - sim_data{iexp}).^2));
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Chi2 = computeChi2(sim_data,exp_data,error_data,nexp)
% the weighted residual sum of squares
Chi2 = 0;
for iexp = 1:nexp
    if isempty(error_data{iexp})
        fprintf('-->Experimental error is not given in experiment %d (error_data{%d} is empty). Chi2 is not computed.\n',iexp,iexp)
        Chi2 = nan;
        return;
    end
    Chi2 = Chi2 + sum(sum(((exp_data{iexp} - sim_data{iexp})./error_data{iexp}).^2));
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RMSE = computeRMSE(sim_data,exp_data,nexp)
% root mean square prediction error
rss = 0;
ndata = 0;
for iexp = 1:nexp
    ndata = ndata + numel(sim_data{iexp});
    rss  = rss  + sum(sum(( exp_data{iexp} - sim_data{iexp}).^2));
    
end
RMSE = sqrt(rss/ndata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NRMSE= computeNRMSE(sim_data,exp_data,nexp)
% normalized root mean squared prediction error 
nrss = 0;
ndata = 0;
for iexp = 1:nexp
    ndata = ndata + numel(sim_data{iexp});
    squared_residuals = ( exp_data{iexp} - sim_data{iexp}).^2;
    % take the column sum, i.e. the sum over the observables, separately.
    sum_squared_residuals_by_observables = sum(squared_residuals);
    % normalize by the mean^2 of the measurements, for each observables
    % separately and sum together
    
    nrss  = nrss  + sum(sum_squared_residuals_by_observables./(max(exp_data{iexp},[],1) - min(exp_data{iexp},[],1)).^2);
    
end
NRMSE = sqrt(nrss/ndata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ANRMSE= computeANRMSE(sim_data,exp_data,nexp)
% averaged normalized root mean squared prediction error 
n_tot_obs = 0;
for iexp = 1:nexp
    for jobs = 1:size(sim_data{iexp},2)
        n_tot_obs = n_tot_obs +1;
        NRMSE(n_tot_obs) = computeNRMSE({sim_data{iexp}(:,jobs)},{exp_data{iexp}(:,jobs)},1);
    end
end

ANRMSE = sqrt(1/n_tot_obs * sum(NRMSE.^2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PEE = computePEE(x_calib, x_valid)
% error in the estimated parameters
PEE = norm(x_calib - x_valid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nPEE_2norm = computeNPEE_2norm(x_calib, x_valid)
% computes the normalized parameter estimation error using the norm of the
% validation parameter
nPEE_2norm = norm(x_calib - x_valid)/norm(x_valid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NPEE = computeNPEE_rel(x_calib, x_valid)
% computes the normalized parameter estimation error using an elementwise
% normalization
NPEE = norm((x_calib - x_valid)./x_valid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R2 R2tot adjR2] = computeR2(sim_data,exp_data,nexp,npar)
% R2 statistics
% observable and experimental wise
for iexp = 1:nexp
    
    squared_residuals = ( exp_data{iexp} - sim_data{iexp}).^2;
    % take the column sum, i.e. the sum over the observables, separately.
    sum_squared_residuals_by_observables = sum(squared_residuals);
    
    for iobs = 1:size(exp_data{iexp},2)
        squared_deviation_by_observables(iobs) = sum((exp_data{iexp}(:,iobs) - mean(exp_data{iexp}(:,iobs))).^2);
    end
    R2{iexp} = 1 - sum_squared_residuals_by_observables./squared_deviation_by_observables;
end
% overall:
data = [];
pred = [];
SSD = 0;
for iexp = 1:nexp
    data = cat(1,data,exp_data{iexp}(:));
    pred = cat(1,pred,sim_data{iexp}(:));
    SSD = SSD +   sum(sum((exp_data{iexp} - repmat(mean(exp_data{iexp}),size(exp_data{iexp},1),1)).^2));
end

SSP = sum((data-pred).^2);
% SSD = sum((data  - mean(data)).^2);

R2tot = 1-SSP/SSD;
% adjusted R2
adjR2 = 1- (1-R2tot)*(numel(data)-1)/(numel(data)-npar-1);

end