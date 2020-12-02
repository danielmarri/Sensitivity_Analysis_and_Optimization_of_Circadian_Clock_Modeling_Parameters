% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_initial_conditions.m 770 2013-08-06 09:41:45Z attila $
% AMIGO_initial_conditions: assigns initial conditions
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
%  AMIGO_initial_conditions: assigns initial conditions to the different      % 
%                            experiments when they are to be estimated.       %
%*****************************************************************************%    


index_y0=[];
   
     switch inputs.theta_y0_type
        case 'global'
           if inputs.n_theta_y0{1}>=1
           y_0(inputs.index_theta_y0{1})=theta(1,inputs.n_theta+1:inputs.n_theta+...
               inputs.n_theta_y0{1}); 
           index_y0=inputs.n_par.*ones(size(inputs.index_theta_y0{1}))+inputs.index_theta_y0{1};
           end 
           n_theta_y0=inputs.n_theta_y0{1};
           ndim_theta=inputs.n_theta+n_theta_y0;
           
        case 'local'
           if inputs.n_theta_y0{iexp}>=1
           y_0(inputs.index_theta_y0{iexp})=theta(1,inputs.n_theta+1:inputs.n_theta+...
               inputs.n_theta_y0{iexp});
           inputs.n_theta=inputs.n_theta+inputs.n_theta_y0{iexp};    
           index_y0=inputs.n_par.*ones(size(inputs.index_theta_y0{iexp}))+inputs.index_theta_y0{iexp};
           end
           n_theta_y0=inputs.n_theta_y0{iexp};
           ndim_theta=inputs.n_theta+n_theta_y0;
    end %switch inputs.theta_y0_type

