% $Header: svn://192.168.32.71/trunk/AMIGO_R2012_cvodes/Postprocessor/Post_Plot/AMIGO_post_plot_PC_1D.m 927 2013-09-11 12:32:16Z evabalsa $
function [errorx,parx]=AMIGO_post_plot_PC_1D_Close2Optim(XBEST,index_theta,inputs,results,privstruct)
% AMIGO_post_plot_CP_1D2: computes cost function vs one parameter near the
% optimum.
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
%  AMIGO_post_plot_CP_1D: computes lsq or llk cost evolution with respect     %
%                       to the model unknowns as part of the identifiability  %
%                       analysis                                              %
%                       Bounds for the plots will be the ones provided by     %
%                       the user in                                           %
%                       inputs.PEsol.theta_min-inputs.PEsol.theta_max         %
%*****************************************************************************%

% compute the optimal cost:
[fopt,h,g] = AMIGO_PEcost(inputs.PEsol.vtheta_guess,inputs,results,privstruct);
flim = 0.1*fopt;
x = inputs.PEsol.vtheta_guess;
% compute the Jacobian near the optimum.
[JacObj,Jacg, JacRes] = AMIGO_PEJac( inputs.PEsol.vtheta_guess,inputs,results,privstruct );
% approximate the Hessian:
H =2*JacRes'*JacRes;
% np2 = 11;
% dx = zeros(length(x),np2);
% dx(1,:) = linspace(-0.05,0.05,np2)*x(1);
%     
% for i = 1: np2
%     [fnum(i),h,g] = AMIGO_PEcost(x+dx(:,i),inputs,results,privstruct);
%     fnumA1(i) = fopt + 1/2*dx(:,i)'*H*dx(:,i); %+ J*dx(:,i)
% end
% plot(x(1)+dx(1,:),fnum,x(1)+dx(1,:),fnumA1)
%%

n_plot_x = results.plotd.nx_contour;
dx = sqrt(flim./H(index_theta,index_theta));
%dx=abs(inputs.PEsol.vtheta_max(1,index_theta(1,1))-inputs.PEsol.vtheta_min(1,index_theta(1,1)))/n_plot_x;

%parx=[inputs.PEsol.vtheta_min(1,index_theta(1,1)):dx:inputs.PEsol.vtheta_max(1,index_theta(1,1))];

parx=[x(1,index_theta(1,1))-(n_plot_x/2)*dx : dx  : x(1,index_theta(1,1))+((n_plot_x-1)/2)*dx];

parx = min(parx,inputs.PEsol.vtheta_max(1,index_theta(1,1)));
parx = max(parx,inputs.PEsol.vtheta_min(1,index_theta(1,1)));
% rtol/atol: integration tolerances
inputs.ivpsol.rtol = results.plotd.contour_rtol;
inputs.ivpsol.atol = results.plotd.contour_atol;

%  Plots least squares

for i=1:n_plot_x
    theta=inputs.PEsol.vtheta_guess;
    theta(index_theta)=[parx(1,i)];
    [f,h,g] = AMIGO_PEcost(theta,inputs,results,privstruct);
    errorx(i)=f;
    
end


switch results.plotd.plotlevel
    case 'noplot'
    otherwise
        
        if numel(inputs.model.par_names)>0 && numel(inputs.model.st_names)>0
            
            if index_theta<=inputs.PEsol.n_global_theta
                ipar=inputs.PEsol.index_global_theta(index_theta);
                xvalue=inputs.model.par_names(ipar,:);
                figure
                plot(parx(1,:),errorx)
                title(strcat('Cost function vs  ',xvalue));
                xlabel(xvalue);
                ylabel('Cost function');
                hold on
                plot(inputs.PEsol.vtheta_guess(1,index_theta(1,1)),fopt,'.')
                contour1D_file_path_fig=strcat(inputs.pathd.contour1D_plot_path,'_',xvalue);
                saveas(gcf, contour1D_file_path_fig, 'fig');
                if results.plotd.epssave==1;
                    print( gcf, '-depsc', contour1D_file_path_fig);    end
                
            else
                
                istate=inputs.PEsol.index_global_theta(index_theta)-inputs.PEsol.n_global_theta;
                xvalue=inputs.model.st_names(istate,:);
                plot(parx(1,:),errorx)
                title(strcat('Cost function vs  ',xvalue));
                xlabel(xvalue);
                ylabel('Cost function');
                hold on
                plot(inputs.PEsol.vtheta_guess(1,index_theta(1,1)),fopt)
                contour1D_file_path_fig=strcat(inputs.pathd.contour1D_plot_path,'_',xvalue);
                saveas(gcf, contour1D_file_path_fig, 'fig');
                if results.plotd.epssave==1;
                    print( gcf, '-depsc', contour1D_file_path_fig);    end
                
            end % if index_theta<=inputs.PEsol.n_global_theta
            
        else
            
            if index_theta<=inputs.PEsol.n_global_theta
                ipar=inputs.PEsol.index_global_theta(index_theta);
                xvalue=strcat('\theta_ ',num2str(ipar));
                figure
                plot(parx(1,:),errorx)
                title(strcat('Cost function vs  ',xvalue));
                xlabel(xvalue);
                ylabel('Cost function');
                contour1D_file_path_fig=strcat(inputs.pathd.contour1D_plot_path,'_theta_',num2str(ipar));
                saveas(gcf, contour1D_file_path_fig, 'fig');
                if results.plotd.epssave==1;
                    print( gcf, '-depsc', contour1D_file_path_fig);    end
                
            else
                
                istate=inputs.PEsol.index_global_theta(index_theta)-inputs.PEsol.n_global_theta;
                xvalue=strcat('\y0_ ',num2str(istate));;
                plot(parx(1,:),errorx)
                title(strcat('Cost function vs  ',xvalue));
                xlabel(xvalue);
                ylabel('Cost function');
                contour1D_file_path_fig=strcat(inputs.pathd.contour1D_plot_path,'_y0_',num2str(istate));
                saveas(gcf, contour1D_file_path_fig, 'fig');
                if results.plotd.epssave==1;
                    print( gcf, '-depsc', contour1D_file_path_fig);    end
                
            end
            
            
        end %  numel(inputs.model.par_names)>0 && numel(inputs.model.st_names)>0
        
        
end

return
