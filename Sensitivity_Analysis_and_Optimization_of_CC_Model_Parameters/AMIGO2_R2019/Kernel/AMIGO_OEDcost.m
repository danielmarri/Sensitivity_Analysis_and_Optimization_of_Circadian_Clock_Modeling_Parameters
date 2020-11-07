% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_OEDcost.m 2088 2015-09-15 08:21:32Z evabalsa $
function [f,h,g] = AMIGO_OEDcost(oed,inputs,results,privstruct);
% AMIGO_OEDcost: Cost function to be minimized for experimental design
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
%  AMIGO_OEDcost: computes the cost function to be minimized for experimental %
%                 design, i.e. provides a measure of the Fisher information   %
%                 matrix depending on the type of experimental noise          %
%                 (homoscedastic or heteroscedastic)                          %
%                 The following measures of the FIM have been incorporated:   %
%                   D-optimality                                              %
%                   E-optimality                                              %
%                   E-modified                                                %
%                   A-optimality                                              %
%                   User-defined cost: 'user_OEDcost'                         %
%                           Should be defined in the following manner:        %
%                           [f, h ,g]=user_cost(oed);                         %
%                           being oed: all uknowns to be computed             %
%                                 f: objective function                       %
%                                 h: constraints if any                       %
%                                 g: dummy vector                             %
%*****************************************************************************%



    % Initialice cost
        f=0.0;
        g=[];
        h=[];
        privstruct.oed=oed;
  
        [privstruct,inputs]=AMIGO_transform_oed(inputs,results,privstruct);
                            

        inputs.exps.n_s=privstruct.n_s;
      
   
        
        [results,privstruct]=AMIGO_CramerRao(inputs,results,privstruct,inputs.exps.n_fixed_exp+1,inputs.exps.n_exp);
            
        
        
        switch inputs.OEDsol.OEDcost_type
        
            case 'Dopt'
            f=-det(results.fit.g_FIM);
            
            case 'Aopt'
            f= trace(inv(results.fit.g_FIM));  
            
            case 'Eopt'
            if isnan(results.fit.g_FIM)
             f=1e30;    
            else 
            f=-min(abs(eig(results.fit.g_FIM)));     
            end
            case 'Emod'
            f=max(abs(eig(results.fit.g_FIM)))/min(abs(eig(results.fit.g_FIM)));    
        
            case 'DoverE'
            f=-det(results.fit.g_FIM)/(max(abs(eig(results.fit.g_FIM)))/min(abs(eig(results.fit.g_FIM))));    
        
            case 'sloppy'
            ndata=0;    
            for iexp=1:inputs.exps.n_exp
            nexpdata(iexp) = inputs.exps.n_s{iexp}*inputs.exps.n_obs{iexp};
            ndata=ndata+nexpdata(iexp);
            end   
            if isnan(results.fit.g_FIM)
             f=1e30;    
            else    
            eigsFIM=eig(full((1/ndata)*results.fit.g_FIM)) ;
            f=-min(eigsFIM/max(eigsFIM));   
            end
            
            case 'anticorr'
            np=size(results.fit.g_corr_mat,2);         
            f=(sum(sum(abs(triu(results.fit.g_corr_mat))))-np)/sum([1:1:np-1]);    
            
        end
        
        h=privstruct.h_constraints; % They are coming from CramerRao
        g(1) = 0;
        


return