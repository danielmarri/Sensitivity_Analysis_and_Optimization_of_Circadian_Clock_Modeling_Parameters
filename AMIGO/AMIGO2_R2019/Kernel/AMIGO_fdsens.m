% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_fdsens.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_fdsens: Computes local sensitivities with respect to unknowns by FD
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
%  AMIGO_fdsens:       computes sensitivies by finite differences             %
%*****************************************************************************%   


            % Computes finite differences sensitivities for the unkwnown
            % parameters privstruct.par{iexp} and unknwown initial conditions 
            % privstruct.y_0{iexp}
            
            % Simulates for the given value of parameters and i.c.
                [yteor_nominal,privstruct,results]=AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par{iexp},iexp,results);
                privstruct.yteor=yteor_nominal;
            % Computes delta for the FD scheme
            
           
                delta_theta=zeros(1,size(privstruct.par{iexp},2));
                delta_theta=abs(sqrt(1e13*eps).*privstruct.par{iexp});   %1e3
                delta_y0=zeros(1,size(privstruct.y_0{iexp},2));
                delta_y0=abs(sqrt(1e3*eps).*privstruct.y_0{iexp});
                delta_theta([find(delta_theta==0)])=abs(sqrt(1e3*eps))*1e-10;
                delta_y0([find(delta_y0==0)])=abs(sqrt(1e3*eps))*1e-10;
             
               
                
                switch inputs.ivpsol.senssolver
                
                    case 'fdsens2'                       
                    % Loop of FD for parameters
    
                    for ipar=1:size(privstruct.par{iexp},2)
                    privstruct.par_fd{iexp}=privstruct.par{iexp};
                    privstruct.par_fd{iexp}(ipar)=privstruct.par{iexp}(ipar)+delta_theta(ipar);
                    [yteor_fd, privstruct,results]=AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par_fd{iexp},iexp,results);
             
                    if isnan(sum(yteor_fd))
                    privstruct.istate_sens=-5;
                    yteor_fd=privstruct.yteor;
                    return ;  
                    end
                    dydpt_full(:,:,ipar)=(yteor_fd-privstruct.yteor)./delta_theta(ipar); 
                    end                

      
                    % Loop of FD for i.c.       
                    if inputs.PEsol.n_global_theta_y0>0
                    for istate=1:inputs.model.n_st
                    privstruct.y0_fd{iexp}=privstruct.y_0{iexp};
                    privstruct.y0_fd{iexp}(istate)=privstruct.y_0{iexp}(istate)+delta_y0(istate);
                    [yteor_fd , privstruct,results]=AMIGO_ivpsol(inputs,privstruct,privstruct.y0_fd{iexp},privstruct.par{iexp},iexp,results);
                    if isnan(sum(yteor_fd))
                    privstruct.istate_sens=-5;
                    yteor_fd=privstruct.yteor;
                    return ;  
                    end
                    dydpt_full(:,:,istate+inputs.model.n_par)=(yteor_fd-privstruct.yteor)./delta_y0(istate);                 
                    end
                    end %  if inputs.PEsol.n_global_theta_y0>0
                    privstruct.istate_sens=2; 
                    
                    case 'fdsens5'
                    
                    
                    % Loop of FD for parameters
                    for ipar=1:size(privstruct.par{iexp},2)    
                    privstruct.par_fdM1{iexp}       = privstruct.par{iexp};
                    privstruct.par_fdM2{iexp}       = privstruct.par{iexp};
                    privstruct.par_fdm1{iexp}       = privstruct.par{iexp};
                    privstruct.par_fdm2{iexp}       = privstruct.par{iexp};   
                    privstruct.par_fdM1{iexp}(ipar) = privstruct.par{iexp}(ipar)+delta_theta(ipar);
                    privstruct.par_fdM2{iexp}(ipar) = privstruct.par{iexp}(ipar)+2*delta_theta(ipar);
                    privstruct.par_fdm1{iexp}(ipar) = privstruct.par{iexp}(ipar)-delta_theta(ipar);
                    privstruct.par_fdm2{iexp}(ipar) = privstruct.par{iexp}(ipar)-2*delta_theta(ipar);

                    [yteor_fdM1, privstruct,results] = AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par_fdM1{iexp},iexp,results);
                    [yteor_fdM2,privstruct,results] = AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par_fdM2{iexp},iexp,results);                                               
                    [yteor_fdm1, privstruct,results]= AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par_fdm1{iexp},iexp,results);
                    [yteor_fdm2,privstruct,results] = AMIGO_ivpsol(inputs,privstruct,privstruct.y_0{iexp},privstruct.par_fdm2{iexp},iexp,results); 
               
                    if isnan(sum(yteor_fdM1))
                    privstruct.istate_sens = -5;  yteor_fdM1 = privstruct.yteor; return ; end
                    if isnan(sum(yteor_fdm1))
                    privstruct.istate_sens = -5;  yteor_fdm1 = privstruct.yteor; return ; end
                    if isnan(sum(yteor_fdM2))
                    privstruct.istate_sens = -5;  yteor_fdM2 = privstruct.yteor; return ; end
                    if isnan(sum(yteor_fdm2))
                    privstruct.istate_sens = -5;  yteor_fdm2 = privstruct.yteor; return ; end
                   
                    dydpt_full(:,:,ipar) = (yteor_fdm2-8*yteor_fdm1+8*yteor_fdM1-yteor_fdM2)./(12*delta_theta(ipar));
                    end


                    % Loop of FD for i.c.
                    if inputs.PEsol.n_global_theta_y0>0
                    for istate=1:inputs.model.n_st
                    privstruct.y0_fdM1{iexp}       = privstruct.y_0{iexp};
                    privstruct.y0_fdM2{iexp}       = privstruct.y_0{iexp};
                    privstruct.y0_fdm1{iexp}       = privstruct.y_0{iexp};
                    privstruct.y0_fdm2{iexp}       = privstruct.y_0{iexp};    
                
                    privstruct.y0_fdM1{iexp}(istate)=privstruct.y_0{iexp}(istate)+delta_y0(istate);
                    privstruct.y0_fdM2{iexp}(istate)=privstruct.y_0{iexp}(istate)+2*delta_y0(istate);
                    privstruct.y0_fdm1{iexp}(istate)=privstruct.y_0{iexp}(istate)-delta_y0(istate);
                    privstruct.y0_fdm2{iexp}(istate)=privstruct.y_0{iexp}(istate)-2*delta_y0(istate);
                    
                    [yteor_fdM1 , privstruct,results]=AMIGO_ivpsol(inputs,privstruct,privstruct.y0_fdM1{iexp},privstruct.par{iexp},iexp,results);
                    [yteor_fdM2, privstruct,results]=AMIGO_ivpsol(inputs,privstruct,privstruct.y0_fdM2{iexp},privstruct.par{iexp},iexp,results);
                    [yteor_fdm1, privstruct,results]=AMIGO_ivpsol(inputs,privstruct,privstruct.y0_fdm1{iexp},privstruct.par{iexp},iexp,results);
                    [yteor_fdm2, privstruct,results]=AMIGO_ivpsol(inputs,privstruct,privstruct.y0_fdm2{iexp},privstruct.par{iexp},iexp,results);
                    
                    if isnan(sum(yteor_fdM1))
                    privstruct.istate_sens = -5;  yteor_fdM1 = privstruct.yteor; return ; end
                    if isnan(sum(yteor_fdm1))
                    privstruct.istate_sens = -5;  yteor_fdm1 = privstruct.yteor; return ; end
                    if isnan(sum(yteor_fdM2))
                    privstruct.istate_sens = -5;  yteor_fdM2 = privstruct.yteor; return ; end
                    if isnan(sum(yteor_fdm2))
                    privstruct.istate_sens = -5;  yteor_fdm2 = privstruct.yteor; return ; end
                
                    dydpt_full(:,:,istate+inputs.model.n_par)=(yteor_fdm2-8*yteor_fdm1+8*yteor_fdM1-yteor_fdM2)./(12*delta_y0(istate));                 
                    end   
                    end %if inputs.PEsol.n_global_theta_y0>0    
                        
                    
                        
                end % switch inputs.ivpsol.senssolver
                    
                    