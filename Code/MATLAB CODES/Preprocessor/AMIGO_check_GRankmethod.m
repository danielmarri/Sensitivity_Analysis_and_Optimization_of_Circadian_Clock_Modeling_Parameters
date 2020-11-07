% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_check_GRankmethod.m 770 2013-08-06 09:41:45Z attila $
  function [inputs,privstruct]= AMIGO_check_GRankmethod(inputs,grank_method,privstruct);
% AMIGO_check_NLPSolver: Checks opt solver when introduced as optional input
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
%  AMIGO_check_NLPSolver: Checks opt solver when introduced as optional input % 
%                                                                             %
%*****************************************************************************%
        privstruct.GRankmethod=grank_method;

        
        switch privstruct.GRankmethod
        case {'lhs','sobol','eem','rbd'}
        inputs.PEsol.GRankmethod=grank_method;
                     
        otherwise
        fprintf(1,'\n\n------> ERROR message\n\n');    
        fprintf(1,'\t\t The GRank method: %s, you selected is not available.\n', privstruct.GRankmethod);
        fprintf(1,'\t\t Available methods are: lhs, sobol, eem, rbd.\n');
        error('error_GRANK_001','\t\t Impossible to continue. Stopping.\n');          
        end
