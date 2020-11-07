% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/Postprocessor/Post_Plot/AMIGO_post_plot_PC.m 770 2013-08-06 09:41:45Z attila $
function [errorxy,parx,pary]=AMIGO_post_plot_PC_Close2Optim(XBEST,index_theta,inputs,results,privstruct)
% AMIGO_post_plot_CP: computes countours of the lsq or llk by pairs of unknowns
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
%  AMIGO_post_plot_CP:  computes contours of the lsq or llk by pairs of       %
%                       unknowns as part of the identifiability analysis      %
%                       Note that tending to infinite or flat contours may    %
%                       pose large identifiability problems.                  %
%                       Noisy contours or those with several subotimal        %
%                       solutions reveal the necessity of using global        %
%                       optimization solvers.                                 %
%                                                                             %
%                       REMARK: contours are plotted only for parameters      %
%                       as incorporated in inputs.PEsol.theta_guess           %
%                       Bounds for the plots will be the ones provided by     %
%                       the user in                                           %
%                       inputs.PEsol.theta_min-inputs.PEsol.theta_max         %
%*****************************************************************************%
[JacObj,Jacg, JacRes] = AMIGO_PEJac( inputs.PEsol.vtheta_guess,inputs,results,privstruct );
[fopt,h,g] = AMIGO_PEcost(inputs.PEsol.vtheta_guess,inputs,results,privstruct);
flim = 0.1*fopt;
H =2*(JacRes'*JacRes);

dx = sqrt(flim./H(index_theta(1,1),index_theta(1,1)));
dy = sqrt(flim./H(index_theta(1,2),index_theta(1,2)));

n_plot_x=results.plotd.nx_contour;
n_plot_y=results.plotd.ny_contour;

% dx=abs(inputs.PEsol.vtheta_max(1,index_theta(1,1))-inputs.PEsol.vtheta_min(1,index_theta(1,1)))/n_plot_x;
% dy=abs(inputs.PEsol.vtheta_max(1,index_theta(1,2))-inputs.PEsol.vtheta_min(1,index_theta(1,2)))/n_plot_y;

parx=[inputs.PEsol.vtheta_guess(1,index_theta(1,1))-(n_plot_x/2)*dx : dx  : inputs.PEsol.vtheta_guess(1,index_theta(1,1))+((n_plot_x-1)/2)*dx];
pary=[inputs.PEsol.vtheta_guess(1,index_theta(1,2))-(n_plot_y/2)*dy : dy  : inputs.PEsol.vtheta_guess(1,index_theta(1,2))+((n_plot_y-1)/2)*dy];
parx = min(parx,inputs.PEsol.vtheta_max(1,index_theta(1,1)));
parx = max(parx,inputs.PEsol.vtheta_min(1,index_theta(1,1)));
pary = min(pary,inputs.PEsol.vtheta_max(1,index_theta(1,2)));
pary = max(pary,inputs.PEsol.vtheta_min(1,index_theta(1,2)));
% parx=[inputs.PEsol.vtheta_min(1,index_theta(1,1)):dx:inputs.PEsol.vtheta_max(1,index_theta(1,1))];
% pary=[inputs.PEsol.vtheta_min(1,index_theta(1,2)):dy:inputs.PEsol.vtheta_max(1,index_theta(1,2))];

% rtol/atol: integration tolerances
if results.plotd.contour_rtol < inputs.ivpsol.rtol
    inputs.ivpsol.rtol = results.plotd.contour_rtol;
end
if results.plotd.contour_atol < inputs.ivpsol.atol
    inputs.ivpsol.atol = results.plotd.contour_atol;
end
%  Plots least squares

for i=1:n_plot_x%+1
    for j=1:n_plot_y%+1
        theta=inputs.PEsol.vtheta_guess;
        theta(index_theta)=[parx(1,i) pary(1,j)];
        [f,h,g] = AMIGO_PEcost(theta,inputs,results,privstruct);
        errorxy(i,j)=f;
    end
end

switch results.plotd.plotlevel
    case 'noplot'
    otherwise
        
        if numel(inputs.model.par_names)>1 && numel(inputs.model.st_names)>1
            
            if index_theta(1,2)<=inputs.PEsol.n_global_theta
                jpar=inputs.PEsol.index_global_theta(index_theta(1,2));
                ipar=inputs.PEsol.index_global_theta(index_theta(1,1));
                xvalue=inputs.model.par_names(ipar,:);
                yvalue=inputs.model.par_names(jpar,:);
                AMIGO_plot_contours; 
            end;
            
            if (index_theta(1,1)<=inputs.PEsol.n_global_theta) && (index_theta(1,2)>inputs.PEsol.n_global_theta)
                jstate=inputs.PEsol.index_global_theta_y0(1,index_theta(1,2)-inputs.PEsol.n_global_theta);
                ipar=inputs.PEsol.index_global_theta(index_theta(1,1));
                xvalue=inputs.model.par_names(ipar,:);
                yvalue=inputs.model.st_names(jstate,:);
                AMIGO_plot_contours; 
            end;
            
            if (index_theta(1,1)>inputs.PEsol.n_global_theta) && (index_theta(1,2)>inputs.PEsol.n_global_theta)
                jstate=inputs.PEsol.index_global_theta_y0(1,index_theta(1,2)-inputs.PEsol.n_global_theta);
                istate=inputs.PEsol.index_global_theta_y0(1,index_theta(1,1)-inputs.PEsol.n_global_theta);
                xvalue=inputs.model.st_names(istate,:);
                yvalue=inputs.model.st_names(jstate,:);
                AMIGO_plot_contours; 
            end;
            
        else
            
            if index_theta(1,2)<=inputs.PEsol.n_global_theta
                jpar=inputs.PEsol.index_global_theta(index_theta(1,2));
                ipar=inputs.PEsol.index_global_theta(index_theta(1,1));
                xvalue=strcat('\theta_ ',num2str(ipar));
                yvalue=strcat('\theta_ ',num2str(jpar));
                AMIGO_plot_contours; 
            end;
            
            if (index_theta(1,1)<=inputs.PEsol.n_global_theta) && (index_theta(1,2)>inputs.PEsol.n_global_theta)
                jstate=inputs.PEsol.index_global_theta_y0(1,index_theta(1,2)-inputs.PEsol.n_global_theta);
                ipar=inputs.PEsol.index_global_theta(index_theta(1,1));
                xvalue=strcat('\theta_ ',num2str(ipar));
                yvalue=strcat('\y0_ ',num2str(jstate));
                AMIGO_plot_contours; 
            end;
            
            if (index_theta(1,1)>inputs.PEsol.n_global_theta) && (index_theta(1,2)>inputs.PEsol.n_global_theta)
                jstate=inputs.PEsol.index_global_theta_y0(1,index_theta(1,2)-inputs.PEsol.n_global_theta);
                istate=inputs.PEsol.index_global_theta_y0(1,index_theta(1,1)-inputs.PEsol.n_global_theta);
                xvalue=strcat('\y0_ ',num2str(istate));
                yvalue=strcat('\y0_ ',num2str(jstate));
                AMIGO_plot_contours; 
            end;
            
        end
end

return
