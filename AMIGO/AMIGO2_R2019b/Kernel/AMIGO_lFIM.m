% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_lFIM.m 770 2013-08-06 09:41:45Z attila $

function [FIM]= AMIGO_lFIM(ntheta,ssquare,sens,dssdy,inputs,privstruct,iexp);

% AMIGO_lFIM: computes the Fisher Information Matrix for local unknowns
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
%  AMIGO_lFIM: computes the Fisher Information Matrix from the sensitivities  %
%             and the definition of the noise variance                        %
%                                                                             %
%            You may see details on the formula for the general FIM in:       %
%             M.R.Garcia. Identification and Real Time Optimisation in the    %
%             Food Processing and Biotechnology Indutries. PhD, Appendix B,   %
%             Dept. Applied Mathematics II, University of Vigo (Spain),       %
%             2008                                                            %
%*****************************************************************************%

FIM=zeros(ntheta);

for iobs=1:inputs.exps.n_obs{iexp}
    if privstruct.w_obs{iexp}(1,iobs)>0
        for iout=1:privstruct.n_s{iexp}
            if ssquare(iobs,iout)==0
                % This is for the heterocesdastic case and observable zero.
                ssquare(iobs,iout)=inputs.ivpsol.atol;
            end
            FIM=FIM+privstruct.w_sampling{iexp}(1,iout).*(((1/ssquare(iobs,iout))+(0.5/ssquare(iobs,iout)^2)*...
                (dssdy(iobs,iout)^2)).*reshape(sens(iout,iobs,:),1,ntheta)'*reshape(sens(iout,iobs,:),1,ntheta));
            
        end
    end
end

return