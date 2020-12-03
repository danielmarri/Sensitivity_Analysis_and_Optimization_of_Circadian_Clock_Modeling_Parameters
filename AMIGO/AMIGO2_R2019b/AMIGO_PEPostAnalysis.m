function stats = AMIGO_PEPostAnalysis(PEinputs, PEresults,verbose,plotflag)
%% Posteriori Analysis of Parameter estimation.
% computes the folowing statistical tests and scores for each experiment
% separately and in total:
%   - R2 and adjusted R2
%   - Chi^2 fit test of the sum of squared resudials
%   - Pearson Chi^2 test of the normality of the residuals (MATLAB Statistics Toolbox required)
%   - Shapiro-Wilk parametric hypothesis test (SBToolbox2 is required)
%   - (Normalized) Root Mean Square Prediction Error
%   - Autocorrelation of the residuals
%   - AKAIKE information criteria and corrected AKAIKE criteria
%   - Bayesian Information criteria
%
% SYNTAX:
% stats = AMIGO_PEPostAnalysis(PEinputs,PEresults)
%   PEinputs and PEresults are the inputs and results structures of AMIGO_PE
%   stats      is a cell array of structures of the results of the different tests.
%               each cell contains the results related to an experiment,
%               The last cell contains the overall statistics. 
%
% stats = AMIGO_PEPostAnalysis(PEinputs, PEresults,verbose)
% verbose == 0 will minimize the text written to the console and plottings
% 
% stats = AMIGO_PEPostAnalysis(PEinputs, PEresults,verbose,plotflag)
% plotflag == 0 will not generate plots.
%
% EXAMPLES:
% See the tutorial examples in the Examples/PosterioriAnalysis folder.
%
% coded: Attila G?bor, 17.09.2013
% last update: 12.12.2014
% $Header$


if nargin < 3
    verbose = 1;
end
if nargin <4 || isempty(plotflag)
    plotflag = true;
end

if nargin ==  1 
    postAnalysis = PEinputs;
else
    

% add the default fields/values to the inputs.
[~,PEinputs,~,~]=evalc('AMIGO_Structs_PE(PEinputs)');


nexp = PEinputs.exps.n_exp;
postAnalysis.n_experiment = nexp;
fprintf('----- Posteriory Analysis for Parameter Estimation -------------- \n')

% cost function detection
costFType =  PEinputs.PEsol.PEcost_type;
switch costFType
    case 'llk'
        postAnalysis.costType = 'llk';
        postAnalysis.llktype = PEinputs.PEsol.llk_type;
    case 'lsq'
        postAnalysis.costType = 'lsq';
        postAnalysis.lsqtype = PEinputs.PEsol.lsq_type;
    otherwise
        fprintf('ERROR: The parameter estimation cost function type (inputs.PEsol.PEcost_type) must be either llk or lsq.\n')
        stats = [];
        return;
end


for iexp = 1:nexp
    postAnalysis.residuals{iexp} = PEresults.sim.sim_data{iexp} - PEresults.sim.exp_data{iexp};
    postAnalysis.data{iexp} = PEresults.sim.exp_data{iexp};
    postAnalysis.std_dev{iexp} = PEinputs.exps.error_data{iexp};
    postAnalysis.n_globalParameters = PEresults.PEsol.n_global_theta;
    postAnalysis.n_localParameters{iexp} = PEresults.PEsol.n_local_theta{iexp};
    postAnalysis.obs_names{iexp} = PEinputs.exps.obs_names{iexp};
   % postAnalysis.costType = PEinputs.PEsol.PEcost_type;
end

end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Local tests for each experiment %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nexp = postAnalysis.n_experiment;

for iexp = 1:nexp
    fprintf('\n\n\n***************************\n');
    fprintf('******* EXPERIMENT %i *****\n',iexp);
    fprintf('***************************\n\n');
    R = postAnalysis.residuals{iexp};
    D = postAnalysis.data{iexp};
    [n_time n_obs] = size(R);
    
    s  = zeros(n_time,n_obs);
    npars = postAnalysis.n_globalParameters;
    if postAnalysis.n_localParameters{iexp}>0
        fprintf('--> WARNING: the local parameters and local initial conditions are not considered in the statistical analysis.\n');
    end
    
    % see if the user gave the standard deviation for each point:
    error_std_correction = [];  % a correction to the number of degrees of freedom.
    if ~isempty(postAnalysis.std_dev{iexp})
        fprintf('The residuals are standardized by the standard deviation: R(i,j)/std_dev(i,j) \n\n')
        s = postAnalysis.std_dev{iexp};
        error_std_correction = 0;
    else
        fprintf('The standard deviation of the datapoints are not given.\nThey are estimated from the residuals for each observable.\n')
        
        for i = 1:n_obs
            s(:,i) = std(R(:,i))*ones(n_time,1);
        end
        error_std_correction = 1;
        disp('Standard deviation for each column of the residuals:')
        disp(s(1,:))
        %fprintf('This way the degrees of freedom is reduced by 1.\n\n')
        fprintf('The residuals are standardized by the estimated standard deviation: R(i,j)/std(R(:,j)) \n\n')
    end
    
    % identify zero standard deviations.
    is = (s==0);
    if any(R(is)~=0)
        fprintf('---> WARNING: There are non-zero residuals where the standard deviation defined as 0.\n');
        fprintf('\t\t The corresponding residuals are set to zero and standard deviation to 1.')
        R(is) = 0;
    end
    
    % the corresponding residuals are 0:
    s(is)=1;
   
    % normalized residuals:
    nR = R./s;
    
    % keep these values for the global analysis.
    Rexp{iexp} = R;
    nRexp{iexp} = nR;
    Dexp{iexp} = D;
    sexp{iexp} = s;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%  Statistical tests
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Significance level for statistical tests:
    alpha = 0.01;
    
    %%%% TEST 1
    % Pearson's chi-squared test as implemented in the MATLAB Statistics
    % Toolbox
    % test of the residuals if they are from a normal distribution
    if license('test','statistics_toolbox')
        [h,p,dof,chi2] = AMIGO_chi2gof(npars+error_std_correction,nR,alpha,plotflag);
        test1 = struct('rejected',h,'pvalue',p,'dof',dof,'chi2',chi2,'alpha',alpha);
    else
        fprintf('--> Statistics toolbox license is not detected. Part of the analysis is skipped.\n');
        test1 = struct('rejected',[],'pvalue',[],'dof',[],'chi2',[],'alpha',alpha);
    end
    
    %%%% TEST 2
    % R-square value.
    % test the model against the simple sample mean.
    R2 = AMIGO_R2test(R,D);

    
    
    %%%% TEST 3
    % Chi2 goodness of fit test (Press et. al. 2007)
    % test the sum of the residuals
    % the sum of the residuals have Chi2 distribution if the residuals have
    % standard normal distribution.
    [h,p,dof,chi2] = AMIGO_chi2Press(npars,nR,alpha);
    test3 = struct('rejected',h,'pvalue',p,'dof',dof,'chi2',chi2,'alpha',alpha);
    
    
    %%%% TEST 4-5
    % Shapiro-Wilk parametric hypothesis test of compsoite normality as
    % implemented in SBToolbox2  http://www.sbtoolbox2.org/ by Henning Schmidt.
    % 1sided and 2 sided tests, i.e. test against underfit and under- or
    % overfit)
    if exist('swtestSB.m','file')
    [h1,p1,h2,p2] = AMIGO_swtest(nR, alpha);
    test4 = struct('rejected',h1,'pvalue',p1,'alpha',alpha);
    test5 =  struct('rejected',h2,'pvalue',p2,'alpha',alpha);
    else
        fprintf('\n\tWARNING: For the Shapiro-Wilk parametric hypothesis test the SBToolbox2 is required. Available: http://www.sbtoolbox2.org/ \n\n')
        test4 = struct('rejected',[],'pvalue',[],'alpha',[]);
        test5 =  struct('rejected',[],'pvalue',[],'alpha',[]);
    end
    
    %%%% TEST 6
    % Autocorrelation of the residuals.
    [autoCorrCoeff autoCorrCoeff_std lag_pars] = AMIGO_autocorrelation(R);
    if plotflag
        figure()
        subplot(211)
        plot(R,'.-')
        title(sprintf('Residuals of each observable (iexp = %d)',iexp))
        hleg = legend(postAnalysis.obs_names{iexp});
        set(hleg,'interpreter','none');
        xlabel('time')
        ylabel('residuals')
        subplot(212)
        x = repmat(lag_pars',1,n_obs);
        x = x + 0.03*randn(size(x));  % avoid overlapping of error bars
        errorbar(x,autoCorrCoeff,autoCorrCoeff_std,'.-')
        title('autocorrelation of residuals')
        xlabel('lag time')
        ylabel('correlation coefficient')
    end
    
    test6 =  struct('lag_pars',lag_pars,'AutoCorrCoeff',autoCorrCoeff,'AutoCorrCoeff_std',autoCorrCoeff_std);
     
     
    RSS = sum(R(:).^2);
    Chi2 = sum(nR(:).^2);
    %% Statistical indicators

    % Root mean square:
    [rmse nrmse] = AMIGO_RMSE(R,D);
    
    stats(iexp).name = sprintf('experiment %d',iexp);  % filled outside.
    stats(iexp).Pearson_chi2 = test1;
    stats(iexp).R2 = R2;
    stats(iexp).Press_chi2gof = test3;
    stats(iexp).ShapiroWilk_gof_underfit = test4;
    stats(iexp).ShapiroWilk_gof_2sided = test5;
    stats(iexp).RMSE = rmse;
    stats(iexp).NRMSE = nrmse;
    stats(iexp).ndata = n_time*n_obs;
    stats(iexp).npars = npars;
    stats(iexp).residuals = R;
    stats(iexp).normalized_residuals = nR;
    stats(iexp).data = D;
    stats(iexp).level_of_significance = alpha;
    stats(iexp).RSS = RSS;
    stats(iexp).Chi2 = Chi2;
    stats(iexp).AutoCorr = test6;
    
end

%% TODO:
% G_test?   Similar to chi2gof, but ln(O/E)%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Global tests for all experiments %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('\n\n\n***************************\n');
    fprintf('******* EXPERIMENT 1-%i *****\n',nexp);
    fprintf('***************************\n\n');
npars = postAnalysis.n_globalParameters;
R = [];
D = [];
nR = [];
s=[];
for iexp = 1:nexp
    R= [R; Rexp{iexp}(:)];
    nR= [nR;nRexp{iexp}(:)];
    D = [D; Dexp{iexp}(:)];
    s = [s; sexp{iexp}(:)];
end

if license('test','statistics_toolbox')
    [h,p,dof,chi2] = AMIGO_chi2gof(npars,nR,alpha,plotflag);
    test1 = struct('rejected',h,'pvalue',p,'dof',dof,'chi2',chi2,'alpha',alpha);
else
    fprintf('--> Statistics toolbox license is not detected. Part of the analysis is skipped.\n');
    test1 = struct('rejected',[],'pvalue',[],'dof',[],'chi2',[],'alpha',alpha);
end

%%%% TEST 2
% R-square value.
% test the model against the simple sample mean.
% if ~any(any(isnan(R)))
R2 = AMIGO_R2test(Rexp,Dexp);
% else
%     R2 = [];
% end


%%%% TEST 3
% Chi2 goodness of fit test (Press et. al. 2007)
% test the sum of the residuals
% the sum of the residuals have Chi2 distribution if the residuals have
% standard normal distribution.
[h,p,dof,chi2] = AMIGO_chi2Press(npars,nR,alpha);
test3 = struct('rejected',h,'pvalue',p,'dof',dof,'chi2',chi2,'alpha',alpha);


%%%% TEST 4-5
% Shapiro-Wilk parametric hypothesis test of compsoite normality as
% implemented in SBToolbox2  http://www.sbtoolbox2.org/ by Henning Schmidt.
% 1sided and 2 sided tests, i.e. test against underfit and under- or
% overfit)
if exist('swtestSB.m','file')
    [h1,p1,h2,p2] = AMIGO_swtest(nR, alpha);
    test4 = struct('rejected',h1,'pvalue',p1,'alpha',alpha);
    test5 =  struct('rejected',h2,'pvalue',p2,'alpha',alpha);
else
    test4 = struct('rejected',[],'pvalue',[],'alpha',[]);
    test5 =  struct('rejected',[],'pvalue',[],'alpha',[]);
end

%%% TEST 6
% Autocorrelation of the residuals.
[autoCorrCoeff autoCorrCoeff_std lag_pars] = AMIGO_autocorrelation(R);
if plotflag
    figure()
    subplot(211)
    plot(R,'.-')
    title('Concatenated residuals')
    
    xlabel('time')
    %ylabel('residuals')
    subplot(212)
    x = lag_pars';
    x = x + 0.03*randn(size(x));  % avoid overlapping of error bars
    errorbar(x,autoCorrCoeff,autoCorrCoeff_std,'.-')
    title('autocorrelation of residuals')
    xlabel('lag time')
    ylabel('correlation coefficient')
end
test6 =  struct('lag_pars',lag_pars,'AutoCorrCoeff',autoCorrCoeff,'AutoCorrCoeff_std',autoCorrCoeff_std);

%% Statistical indicators

% Root mean square:
[rmse nrmse] = AMIGO_RMSE(Rexp,Dexp);

%% stats
stats(nexp+1).name = sprintf('all experiments');  % filled outside.
stats(nexp+1).Pearson_chi2 = test1;
stats(nexp+1).R2 = R2;
stats(nexp+1).Press_chi2gof = test3;
stats(nexp+1).ShapiroWilk_gof_underfit = test4;
stats(nexp+1).ShapiroWilk_gof_2sided = test5;
stats(iexp+1).RMSE = rmse;
stats(iexp+1).NRMSE = nrmse;
stats(iexp+1).ndata = numel(R);
stats(iexp+1).npars = npars;
stats(iexp+1).residuals = R;
stats(iexp+1).normalized_residuals = nR;
stats(iexp+1).data = D;
stats(iexp+1).level_of_significance = alpha;
stats(iexp+1).AutoCorr = test6;
% AKAIKE and Bayesian information criteria
switch postAnalysis.costType 
    case 'llk'
        [aic, corr_aic] = AMIGO_aic(R,D,s,npars,postAnalysis.llktype);
        [bic] = AMIGO_bic(R,D,s,npars,postAnalysis.llktype);
    case 'lsq'
        fprintf('WARNING: The AKAIKE information and Bayesian information are originally for maximum likelihood estimation problems\n')
        [aic, corr_aic] = AMIGO_aic(R,D,s,npars,'homo_var');
        [bic] = AMIGO_bic(R,D,s,npars,'homo_var');
    otherwise  % model not fitted
        aic = [];
        corr_aic = [];
        bic=[];
        
end

stats(nexp+1).AkaikeInformationCrit.AIC = aic;
stats(nexp+1).AkaikeInformationCrit.cAIC = corr_aic;
stats(nexp+1).BayesianInformationCrit = bic;


end









