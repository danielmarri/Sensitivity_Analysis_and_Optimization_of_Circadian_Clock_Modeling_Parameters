% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_overfitting.m 2204 2015-09-24 07:11:53Z evabalsa $
% AMIGO_check_overfitting: Checks possibility of overfitting
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
%   AMIGO_check_overfitting: Checks the possibility of overfitting taking into%
%                            account the relationship between the number of   %
%                            experimental data points and the number of       %
%                            unkwnowns                                        %
%*****************************************************************************%
   ndata=0;
   
   for iexp=1:inputs.exps.n_exp
   ndata=ndata+numel(inputs.exps.exp_data{iexp});
   end

   if ndata<= 2*inputs.PEsol.ntotal_theta+1
       fprintf(1,'----> WARNING!!!!: The number of data you have (%u) is not enough to estimate %u unknowns.\n',ndata,inputs.PEsol.ntotal_theta);
       fprintf(1,'---->              You may experience overfitting and you may expect lack of (or poor) practical identifiability.\n');
       
       if (inputs.PEsol.ntotal_theta>inputs.PEsol.n_global_theta)
           fprintf(1,'---->           ADVICE: Try to eliminate local unknowns from the estimation problem.');
       end    
       
       if(inputs.PEsol.n_theta>inputs.PEsol.n_global_theta)
            fprintf(1,'---->           ADVICE: Try to eliminate unknown initial conditions from the estimation problem.');
       end    
          
       pause(3)
       
   end    
   
 