% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_gFIM.m 2115 2015-09-18 12:20:13Z attila $

function [FIM]= AMIGO_gFIM(ntheta,ssquare,sens,dssdy,inputs,privstruct,ini_exp,fin_exp)

% AMIGO_gFIM: computes the Fisher Information Matrix for global unknowns
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
%  AMIGO_gFIM: computes the Fisher Information Matrix from the sensitivities   %
%             and the definition of the noise variance                        %
%                                                                             %
%            You may see details on the formula for the general FIM in:       %
%             M.R.Garcia. Identification and Real Time Optimisation in the    %
%             Food Processing and Biotechnology Indutries. PhD, Appendix B,   %
%             Dept. Applied Mathematics II, University of Vigo (Spain),       %
%             2008                                                            %
%*****************************************************************************%

FIM=privstruct.g_fixedFIM;

% Computes sens for observables


for iexp=ini_exp:fin_exp
    
  
    for iobs=1:inputs.exps.n_obs{iexp}
        
        if privstruct.w_obs{iexp}(1,iobs)>0
            
          
            for iout=1:privstruct.n_s{iexp}
                
                if inputs.exps.missing_data{iexp}
                    if ~inputs.exps.nanfilter{iexp}(iout,iobs)  % the iouts and iobs must be in this order.
                        % do not add anything to the FIM, if the corresponding
                        % information is missing from the measurements.
                        continue;
                    end
                end
                if ssquare{iexp}(iobs,iout)==0
                    % This is for the heterocesdastic case and observable zero.
                    ssquare{iexp}(iobs,iout)=inputs.ivpsol.atol;
                end
                
                var_ij = ((1/ssquare{iexp}(iobs,iout))+(0.5/ssquare{iexp}(iobs,iout)^2)*...
                    (dssdy{iexp}(iobs,iout)^2));
                Jij = reshape(sens{iexp}(iout,iobs,:),1,ntheta);
                
                FIM=FIM+privstruct.w_sampling{iexp}(1,iout).*var_ij*(Jij'*Jij);
                
                %FIM=FIM+privstruct.w_sampling{iexp}(1,iout).*(((1/ssquare{iexp}(iobs,iout))+(0.5/ssquare{iexp}(iobs,iout)^2)*...
                %    (dssdy{iexp}(iobs,iout)^2)).*reshape(sens{iexp}(iout,iobs,:),1,ntheta)'*reshape(sens{iexp}(iout,iobs,:),1,ntheta));
                
            end
        end
    end
    

end

if inputs.nlpsol.regularization.ison && inputs.nlpsol.regularization.isinFIM
    
    switch inputs.nlpsol.regularization.method
        case 'tikhonov'
            W = inputs.nlpsol.regularization.tikhonov.gW;
            alpha = inputs.nlpsol.regularization.alpha;
            FIM = FIM + alpha * (W'*W);
    end   

end
end