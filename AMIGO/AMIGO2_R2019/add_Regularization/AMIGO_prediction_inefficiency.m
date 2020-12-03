function [stats cv_stats cv_ref_stats ] = AMIGO_prediction_inefficiency(reg_summary,inputs,theta0,theta2,cv_inputs,plot_flag)
%AMIGO_PREDICTION_INEFFICIENCY computes the prediction inefficiency, the
%error between the Nt dimensional theta0 parameter vector and its estimates
%in the reg_summary.theta.
%
% AMIGO_inefficiency(reg_summary,theta0,theta2) where reg_summary is a structure with
% the following field:
%   alpha   vector of Nr regularization parameter value (1:Nr by default)
%   theta   an Nr x Nt matrix, each row containing an estimate of theta0
% theta0 is the reference parameter vector (nominal/true parameters)
% theta2 (optional) the estimation without the regularization.
theta2_flag = 0;
if nargin > 3 && ~isempty(theta2)
    theta2_flag = 1;
else
    cv_ref_stats = [];
end

cv_flag = 0;
if nargin > 4 && ~isempty(cv_inputs)
    cv_flag = 1;
else
    cv_stats=[];
end
if nargin < 6 || isempty(plot_flag)
    plot_flag = 'noplot';
end
% theta0 = inputs.model.par(index_theta);
% theta2 = results.fit.thetabest;


inputs.plotd.plotlevel = plot_flag;
inputs.nlpsol.regularization.ison = 0;

calibrated_model = inputs;
calibrated_model.nlpsol.regularization.ison = 0;
nominal_model = inputs;
nominal_model.nlpsol.regularization.ison = 0;

 % if the cv_inputs does not contain measurement data, then we have to
 % simulate.
if cv_flag
    cv_inputs.plotd.plotlevel = 'noplot';
    cv_inputs.nlpsol.regularization.ison = 0;
   
    if (strcmpi(cv_inputs.exps.data_type, 'pseudo') || strcmpi(cv_inputs.exps.data_type, 'pseudo_pos')) && (~isfield(cv_inputs.exps,'exp_data') ||  isempty(cv_inputs.exps.exp_data{1}))
    cv_sdata = AMIGO_SData(cv_inputs);

    % set up the calibrated model with validation data:
    cv_inputs.exps.exp_data =  cv_sdata.sim.exp_data;
    cv_inputs.exps.error_data =  cv_sdata.sim.error_data;
    cv_inputs.exps.data_type='real';
    end
end

if ~isempty(theta0)
    nominal_model.PEsol.global_theta_guess = theta0;
end

for ialpha = 1:length(reg_summary.alpha)
%     calibrated_model.PEsol.global_theta_guess = reg_summary.theta(ialpha,:);
    calibrated_model = AMIGO_update_inputs_with_theta(reg_summary.theta(ialpha,:),calibrated_model);
    [stats(ialpha) calibrated_model_sim(ialpha) nominal_model_sim]= AMIGO_CompareModels(calibrated_model,nominal_model);
    
    if cv_flag
        [cv_stats(ialpha)  ]= AMIGO_CompareModels(calibrated_model,cv_inputs);
    end
end

if theta2_flag
    reference_model = inputs;
    reference_model.PEsol.global_theta_guess = theta2;
    [ref_stats reference_model_sim]= AMIGO_CompareModels(reference_model,nominal_model);
    if cv_flag
        [cv_ref_stats]= AMIGO_CompareModels(reference_model,cv_inputs);
    end
end

alpha = reg_summary.alpha;


%% Plot the calibration stistical values for the candidates
figure
subplot(341)
plot(alpha,[stats.Chi2],'.-')
title('Cost function (weighted LS)')
set(gca,'xscale','log')

subplot(342)
plot(alpha,[stats.RSS],'.-')
title('Residuals sum of squares (non-weighted LS)')
set(gca,'xscale','log')

subplot(343)
plot(alpha,[stats.RMSE],'.-')
title('Root mean square prediction error')
set(gca,'xscale','log')

subplot(344)
plot(alpha,[stats.NRMSE],'.-')
title('Normalized root mean square prediction error')
set(gca,'xscale','log')

subplot(345)
plot(alpha,[stats.R2tot],'.-')
title('R2 goodness of fit')
set(gca,'xscale','log')

subplot(346)
plot(alpha,[stats.PEE],'.-')
title({'Parameter estimation error' '2-norm distance'})
set(gca,'xscale','log')

subplot(347)
plot(alpha,[stats.nPEE_2norm],'.-')
title({'Parameter estimation error' '2-norm distance, relative'})
set(gca,'xscale','log')

subplot(348)
plot(alpha,[stats.nPEE_rel],'.-')
title({'Parameter estimation error' 'Mean relative error'})
set(gca,'xscale','log')

subplot(349)
plot(alpha,[stats.PE],'.-')
title({'Prediction error' 'from undisturbed trajectories'})
set(gca,'xscale','log')

subplot(3,4,10)
plot(alpha,[stats.NPE],'.-')
title({'Normalized prediction error' 'from undisturbed trajectories'})
set(gca,'xscale','log')




if theta2_flag
    alphaREF = min(alpha)/10;
    subplot(341)
    hold on
    plot(alphaREF,[ref_stats.Chi2],'*r')
    
    subplot(342)
    hold on
    plot(alphaREF,[ref_stats.RSS],'*r')
    
    
    subplot(343)
    hold on
    plot(alphaREF,[ref_stats.RMSE],'*r')
    
    subplot(344)
    hold on
    plot(alphaREF,[ref_stats.NRMSE],'*r')
    
    subplot(345)
    hold on
    plot(alphaREF,[ref_stats.R2tot],'*r')
    
    
    subplot(346)
    hold on
    plot(alphaREF,[ref_stats.PEE],'*r')
    
    
    subplot(347)
    hold on
    plot(alphaREF,[ref_stats.nPEE_2norm],'*r')
    
    
    subplot(348)
    hold on
    plot(alphaREF,[ref_stats.nPEE_rel],'*r')
    
    subplot(349)
    hold on
    plot(alphaREF,[ref_stats.PE],'*r')
    
    subplot(3,4,10)
    hold on
    plot(alphaREF,[ref_stats.NPE],'*r')
    
end
AMIGO_supertitle('Calibration data based stats')
%% Cross-validation plots
if cv_flag
    figure
    subplot(331)
    plot(alpha,[cv_stats.Chi2],'.-')
    title('Cost function (weighted LS)')
    set(gca,'xscale','log')
    
    subplot(332)
    plot(alpha,[cv_stats.RSS],'.-')
    title('Residuals sum of squares (non-weighted LS)')
    set(gca,'xscale','log')
    
    subplot(333)
    plot(alpha,[cv_stats.RMSE],'.-')
    title('Root mean square prediction error')
    set(gca,'xscale','log')
    
    subplot(334)
    plot(alpha,[cv_stats.NRMSE],'.-')
    title('Normalized root mean square prediction error')
    set(gca,'xscale','log')
    
    subplot(335)
    plot(alpha,[cv_stats.R2tot],'.-')
    title('R2 goodness of fit')
    set(gca,'xscale','log')
    
    % subplot(346)
    % plot(alpha,[cv_stats.PEE],'.-')
    % title({'Parameter estimation error' '2-norm distance'})
    % set(gca,'xscale','log')
    
    % subplot(347)
    % plot(alpha,[cv_stats.nPEE_2norm],'.-')
    % title({'Parameter estimation error' '2-norm distance, relative'})
    % set(gca,'xscale','log')
    
    % subplot(348)
    % plot(alpha,[cv_stats.nPEE_rel],'.-')
    % title({'Parameter estimation error' 'Mean relative error'})
    % set(gca,'xscale','log')
    
    subplot(336)
    plot(alpha,[cv_stats.PE],'.-')
    title({'Prediction error' 'from undisturbed trajectories'})
    set(gca,'xscale','log')
    
    subplot(3,3,7)
    plot(alpha,[cv_stats.NPE],'.-')
    title({'Normalized prediction error' 'from undisturbed trajectories'})
    set(gca,'xscale','log')
    
    
    
    if theta2_flag
        alphaREF = min(alpha)/10;
        subplot(331)
        hold on
        plot(alphaREF,[cv_ref_stats.Chi2],'*r')
        
        subplot(332)
        hold on
        plot(alphaREF,[cv_ref_stats.RSS],'*r')
        
        
        subplot(333)
        hold on
        plot(alphaREF,[cv_ref_stats.RMSE],'*r')
        
        subplot(334)
        hold on
        plot(alphaREF,[cv_ref_stats.NRMSE],'*r')
        
        subplot(335)
        hold on
        plot(alphaREF,[cv_ref_stats.R2tot],'*r')
        
               
        subplot(336)
        hold on
        plot(alphaREF,[cv_ref_stats.PE],'*r')
        
        subplot(337)
        hold on
        plot(alphaREF,[cv_ref_stats.NPE],'*r')
        
    end
    AMIGO_supertitle('Cross-validation data based stats')
    
end