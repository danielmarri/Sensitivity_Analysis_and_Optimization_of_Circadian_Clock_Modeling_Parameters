% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_identifiability.m 1891 2014-10-29 11:43:56Z evabalsa $
function [results,privstruct]=AMIGO_identifiability(inputs,results,privstruct)
% AMIGO_identifiability: Identifiability using a Monte-Carlo based mthd 
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
%  AMIGO_identifiability: Performs a robust analysis of practical             %
%                         identifiability by computing robust confidence      %
%                         regions or expected uncertainty for the             %
%                         parameters using a Monte-Carlo based approach.      %
%                                                                             %
%                         This analysis requires the solution of the          %
%                         parameter estimation problem hundreds of times      %
%                         (by default:1000) thus the overall computational    %
%                         cost may increase rapidly.                          %
%                                                                             %
%                         REMARK 1: The bounds to be used for solving the     %
%                         problem will be the ones fixed in the opt_solver    %
%                         structure. It will be assumed that the best value   %
%                         for the unknowns corresponds to the "guess"         %
%                         inputs.PEsol.theta_guess, inputs.PEsol.y0_guess     %
%                                                                             %
%                         REMARK 2: In order to guarantee that the global     %
%                         solution is achieved ssm (default) is being used for% 
%                         computing confidence regions.                       %
%                         Depending on the model size and search space you may% 
%                         need to modify the maximum allowable CPU time for   %
%                         the solution of the PE problem in ssm_options &     % 
%                         ssm_options_conf                                    %   
%                                                                             %
%                         Details on how the identifiability analysis is      %
%                         performed may be found in:                          %
%                         Balsa-Canto, E., A.A. Alonso and J.R. Banga         %
%                         Computational Procedures for Optimal Experimental   %
%                         Design in Biological Systems.                       %
%                         IET Systems Biology, 2(4): 163-172, 2008            %
%                                                                             %
%*****************************************************************************%


xdim=inputs.PEsol.ntotal_theta;
XBEST_norm=ones(1,xdim);

best_population=zeros(inputs.rid.conf_ntrials,xdim+1);
fprintf(1,'\n>>>>> GENERATION OF ROBUST CONFIDENCE REGIONS %d\n\n');
results.rid.ecc=ones(xdim+1);
results.rid.alfa=zeros(xdim);

% First step is to read the 'real' experimental data or to generate a 
% set of simulated data. 
%    for iexp=1:inputs.exps.n_exp
%        plot(inputs.exps.exp_data{iexp})
%        hold on
%    end
%    pause
 switch inputs.exps.data_type
% Generates noisy experimental data        
        case {'pseudo','pseudo_pos'}  
          [results.sim.exp_data,results.fit.residuals,results.fit.norm_residuals]=AMIGO_pseudo_data(inputs,results,privstruct);
          inputs.exps.exp_data=results.sim.exp_data;
 end

 inputs.exps.original_exp_data=inputs.exps.exp_data;
 inputs.exps.original_error_data=inputs.exps.error_data;
 
 results.rid.vtheta_guess=inputs.PEsol.vtheta_guess;  
 vtheta_guess=inputs.PEsol.vtheta_guess;  %inputs.PEsol.vtheta_min + rand(1,xdim).*(inputs.PEsol.vtheta_max - inputs.PEsol.vtheta_min);    
    
 
for itrial=1:inputs.rid.conf_ntrials
    
      fprintf(1,'\n>>>>> TRIAL %d\n ',itrial);
      
     % Estimates parameters
       privstruct.print_flag=0;
       [results,privstruct]=AMIGO_call_OPTsolver('PE',inputs.nlpsol.nlpsolver,vtheta_guess,inputs.PEsol.vtheta_min,inputs.PEsol.vtheta_max,inputs,results,privstruct);     
       close all;
       best_population(itrial,2:xdim+1)=results.nlpsol.vbest; 
       best_population(itrial,1)=results.nlpsol.fbest;
      
      
     %  Calculates the distance to the optimum* 
    
   euclid_dist(itrial)=norm(results.nlpsol.vbest-inputs.PEsol.vtheta_guess); 
   euclid_dist_max(itrial)=max(abs(results.nlpsol.vbest-inputs.PEsol.vtheta_guess));  
   euclid_dist_matrix(itrial,:)=results.nlpsol.vbest-inputs.PEsol.vtheta_guess;  % with correct sign
  
   vtheta_guess=results.nlpsol.vbest; 
   %vtheta_guess=inputs.PEsol.vtheta_min + rand(1,xdim).*(inputs.PEsol.vtheta_max - inputs.PEsol.vtheta_min);
   [inputs.exps.exp_data,inputs.exps.error_data]=AMIGO_MC_data(vtheta_guess,inputs,results,privstruct);

   

%  
%  for iexp=1:inputs.exps.n_exp
%              figure
%              plot(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp},'*')
%              hold on
%              plot(inputs.exps.t_s{iexp},inputs.exps.original_exp_data{iexp})
%              pause
%              figure
%              plot(inputs.exps.original_error_data{iexp}-inputs.exps.error_data{iexp},'r*')
%              pause
%              %hold on
%              %plot(inputs.exps.t_s{iexp},inputs.exps.original_error_data{iexp},'r')
% end

   
end %for itrial=1:inputs.PEsol.conf_ntrials



% Only those values within the 5% are considered for the confidence....
    index_global=[1:inputs.rid.conf_ntrials];

%   SORTED MATRIX ...

   [sorted_dist sort_index]=sort(-euclid_dist(index_global));  % ordena por distancia eclidea descending order
   results.rid.sorted_dist=-sorted_dist;
   [sorted_dist_max sort_index_max]=sort(-euclid_dist_max(index_global)); % sorts descending order OJO!!!!!  
   results.rid.sorted_dist_max=-sorted_dist_max;                          % tiende a eliminar outliers
                                                                          % en direcciones especificas
                                                                          
%   95 % confidence. In this case it is stablished by the 
%   quantiles: q95 and q05.

              
    n_globals=size(index_global,2);

    n_quantiles=fix(n_globals*0.95*0.95);
    
%   First the quantiles are computed in specific directions.
    
    results.rid.sorted_dist_max95=sorted_dist_max(1:n_quantiles)';
    sorted_index_max95=sort_index_max(1:n_quantiles)';
    
    % Indexes to be eliminated 
      index_max_to_remove=sort_index_max(1:n_globals-n_quantiles);
    
%   Quantiles are computed attending to euclidean distance
    results.rid.sorted_dist95=sorted_dist(1:n_quantiles)';
    sort_index95=sort_index(1:n_quantiles)';
    
     % Indexes to be eliminated 
    
    index_to_remove=sort_index(1:n_globals-n_quantiles);

    results.rid.sort_index_95=setdiff([1:1:n_globals],index_to_remove);
    results.rid.best_population=best_population;
    results.rid.best95=results.rid.best_population(results.rid.sort_index_95,2:xdim+1);

%  Mean value and deviation from theta* =[1...1]

    for ipar=1:xdim
    results.rid.mu(ipar)=mean(results.rid.best95(:,ipar));
    results.rid.lambda(ipar)=abs(results.rid.mu(ipar)-inputs.PEsol.vtheta_guess(ipar));
    end      
   
%   Normalization of the best population over the mu value

    results.rid.best95_norm=results.rid.best95./(ones(size(results.rid.best95,1),1)*results.rid.mu);
    
    
%   Confidence intervals are computed by the quantiles.... of course there
%   will be two values since the confidence region may be not symetric with
%   respect to mu, therefore the maximum is used as a measure...

    
    results.rid.right_conf=max(results.rid.best95)-results.rid.mu;   
    results.rid.left_conf=abs(min(results.rid.best95)-results.rid.mu);
    results.rid.confidence_interval=max([results.rid.right_conf;results.rid.left_conf]);   
    results.rid.confidence_norm= results.rid.confidence_interval./results.rid.mu;    
    
 %   IPAR-JPAR Ellipse orientation and semi-axes. REMARK this is done for
 %   the normalized best95
    results.rid.ecc=zeros(xdim);
    for ipar=1:xdim-1
        for jpar=ipar+1:xdim
            %[PC, SCORE, LATENT, TSQUARE] = PRINCOMP(results.rid.best95_norm(:,[ipar,jpar]));
            % Principal component analysis
            [m,n] = size(results.rid.best95_norm(:,[ipar,jpar]));
            r = min(m-1,n);     % max possible rank of x
            avg = mean(results.rid.best95_norm(:,[ipar,jpar]));
            centerx = (results.rid.best95_norm(:,[ipar,jpar]) - avg(ones(m,1),:));
            [U,LATENT,PC] = svd(centerx./sqrt(m-1),0);
            SCORE = centerx*PC;
            LATENT = diag(LATENT).^2;
            if (r<n)
            LATENT = [LATENT(1:r); zeros(n-r,1)];
            SCORE(:,r+1:end) = 0;
            end
            tmp = sqrt(diag(1./LATENT(1:r)))*SCORE(:,1:r)';
            TSQUARE = sum(tmp.*tmp)';
                                           
            
            
            results.rid.alfa(ipar,jpar)=0.5*pi-atan(PC(1,1)/PC(2,1));
            results.rid.alfa(jpar,ipar)=-results.rid.alfa(ipar,jpar);
            e_axes=2.75*sqrt(LATENT)';
            results.rid.semi_major(ipar,jpar)=e_axes(1);
            results.rid.semi_minor(ipar,jpar)=e_axes(2);
            results.rid.ecc(ipar,jpar)=sqrt(1-(results.rid.semi_minor(ipar,jpar)/results.rid.semi_major(ipar,jpar))^2);
            results.rid.ecc(jpar,ipar)=results.rid.ecc(ipar,jpar);
            
        end
    end   
    results.rid.ecc_max=max(results.rid.ecc(:)); 
    for ipar=1:xdim-1
    ecc_min(ipar)=min(diag(results.rid.ecc,ipar));
    ecc_mean(ipar)=mean(diag(results.rid.ecc,ipar));
    end
    results.rid.ecc_min=min(ecc_min);
    results.rid.ecc_mean=mean(ecc_mean);
    
    for ipar=1:xdim
        results.rid.ecc(ipar,ipar)=1;
    end
    
    results.rid.alfa_max=max(results.rid.alfa(:));
    
    for ipar=1:xdim-1
    alfa_min(ipar)=min(diag(results.rid.alfa,ipar));
    alfa_mean(ipar)=mean(diag(results.rid.alfa,ipar));
    end
    results.rid.alfa_min=min(alfa_min);
    results.rid.alfa_mean=mean(alfa_mean);

    results.rid.ellipse_pseudo_vol= prod(diag(results.rid.semi_major,1)); 
    results.rid.lambda_total=norm(results.rid.mu-inputs.PEsol.vtheta_guess);
    
%   Correlation matrix

    results.rid.mc_corrmat=ones(xdim+1);
    results.rid.mc_corrmat(1:xdim,1:xdim)=corrcoef(results.rid.best95);

    

    
    
return;