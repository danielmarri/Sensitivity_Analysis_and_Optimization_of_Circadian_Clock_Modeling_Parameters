% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Plot/AMIGO_post_plot_PC_1D.m 2203 2015-09-24 07:11:27Z evabalsa $
function [errorx,parx]=AMIGO_post_plot_PC_1D(XBEST,index_theta,inputs,results,privstruct)
% AMIGO_post_plot_CP_1D: computes cost function vs one parameter
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

n_plot_x=results.plotd.nx_contour;
dx=abs(inputs.PEsol.vtheta_max(1,index_theta(1,1))-inputs.PEsol.vtheta_min(1,index_theta(1,1)))/n_plot_x;
parx=[inputs.PEsol.vtheta_min(1,index_theta(1,1)):dx:inputs.PEsol.vtheta_max(1,index_theta(1,1))];


% rtol/atol: integration tolerances
inputs.ivpsol.rtol = results.plotd.contour_rtol;
inputs.ivpsol.atol = results.plotd.contour_atol;

 %  Plots least squares 
    
    for i=1:n_plot_x+1
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
        contour1D_file_path_fig=strcat(inputs.pathd.contour1D_plot_path,'_',xvalue);
        saveas(gcf, contour1D_file_path_fig, 'fig');
            if results.plotd.epssave==1;
            print( gcf, '-depsc', contour1D_file_path_fig);    end
    
        else
        istate=inputs.PEsol.index_global_theta_y0(index_theta-inputs.PEsol.n_global_theta);
        xvalue=inputs.model.st_names(istate,:);
        plot(parx(1,:),errorx)  
        title(strcat('Cost function vs  ',xvalue)); 
        xlabel(xvalue);
        ylabel('Cost function');            
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
        
        istate=inputs.PEsol.index_global_theta_y0(index_theta-inputs.PEsol.n_global_theta);  
        xvalue=strcat('\y0_ ',num2str(istate));
        plot(parx(1,:),errorx)  
        title(strcat('Cost function vs  ',xvalue)); 
        xlabel(xvalue);
        ylabel('Cost function');            
        contour1D_file_path_fig=strcat(inputs.pathd.contour1D_plot_path,'_y0_',num2str(istate));
        saveas(gcf, contour1D_file_path_fig, 'fig');
        if results.plotd.epssave==1;
        print( gcf, '-depsc', contour1D_file_path_fig);    end   
    
        end
    
    
        end % numel(inputs.model.par_names)>0 && numel(inputs.model.st_names)>0
    
    
    end 
 
return
