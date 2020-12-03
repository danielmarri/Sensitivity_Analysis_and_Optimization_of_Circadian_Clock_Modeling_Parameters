% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_corr_mat.m 2400 2015-12-04 07:06:33Z evabalsa $
function [corr_matrix,var_cov_matrix]= AMIGO_corr_mat(FIM_mat,ntheta,s2)
% AMIGO_corr_mat: computes correlation matrix from the FIM
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
% AMIGO_corr_mat: computes correlation matrix from the FIM                    %
%                                                                             %
%*****************************************************************************%

if nargin < 3
    % for maximum likelihood estimation with known measurement variance, the
    % s2 is not estimated. 
    s2 = 1;
end

% % temporarily remove the empty rows/columns of FIM --> the output does not contains
% % information about that parameters:
nonzero_columns = any(FIM_mat);
if sum(nonzero_columns) < ntheta
    fprintf(1,'\n\n------> Warning message\n\n');
    fprintf(1,'\t\t The Fisher Information Matrix is singular \n');
    fprintf(1,'\t\t The reduced Fisher Information Matrix is computed. \n');
end

nonzero_rows =nonzero_columns;  % symmetry
% reduced FIM:
red_FIM_mat = FIM_mat(nonzero_rows,nonzero_columns);

% index of the parameters
par_index = 1:ntheta;
% indices of the parameters the correspondng columns are non-zeros
par_index_nonzeros = par_index(nonzero_columns);
% number of nonzero columns of the FIM.
npar_nonzero = length(par_index_nonzeros);
% TODO: report unidentifiable parameters by their names/indices.

rcondFIM=rcond(red_FIM_mat);

% Regularize the FIM:
red_FIM_mat = 0.5*(red_FIM_mat + red_FIM_mat');  % symmetrize


%rcondFIM
if rcondFIM<=1e-50 || isnan(rcondFIM)
    
    cprintf('*red','\n--------------------------------------------------');
    cprintf('*red','\n------> ERROR message\n');
    cprintf('*red','\t\tThe Fisher Information Matrix is singular \n');
    cprintf('*red','-------------------------------------------------------\n\n');
    pause(1)
    var_cov_matrix = zeros(ntheta);
    corr_matrix=zeros(ntheta); % +1 removed AG. the matrix is extended only for pcolor. 
    pause(2) ;
    return;
    
elseif (rcondFIM >1e-50) &&  (rcondFIM<1e-10)
    cprintf('*red','\n----------------------------------------------------------');
    cprintf('*red','\n------> WARNING message\n');
    cprintf('*red','\t\tThe Fisher Information Matrix is nearly singular.\n');
    cprintf('*red','----------------------------------------------------------\n\n');
    pause(1)
%     fprintf(1,'\nThe FIM is regularized before inverting: FIM = FIM + e*I\n');
    
    % TODO: better regularization technique. Regularized/stabilized
    % inversion of positive (semi)definite, symmetric matrices. 
    
%     e = min(diag(red_FIM_mat))*0.01; % 1% regularization of the diagonals
%     red_FIM_mat = red_FIM_mat + e*eye(size(red_FIM_mat));

%     iFIM = pinv(red_FIM_mat);
    iFIM = inv(red_FIM_mat);
    % Covariance matrix
    var_cov_matrix = zeros(ntheta);
    for i=1:npar_nonzero
        for j=1:npar_nonzero
            var_cov_matrix(par_index_nonzeros(i),par_index_nonzeros(j)) = iFIM(i,j);
        end
    end
    var_cov_matrix = var_cov_matrix*s2;
    % Correlation matrix containing all the parameters
    corr_matrix=zeros(ntheta);  % +1 removed AG. the matrix is extended only for pcolor. 
    
    for i=1:npar_nonzero
        for j=1:npar_nonzero
            corr_matrix(par_index_nonzeros(i),par_index_nonzeros(j)) = var_cov_matrix(par_index_nonzeros(i),par_index_nonzeros(j))/(abs((var_cov_matrix(par_index_nonzeros(i),par_index_nonzeros(i))*var_cov_matrix(par_index_nonzeros(j),par_index_nonzeros(j))))^0.5);
        end
    end
    
else
    
    iFIM = inv(red_FIM_mat);
    % Covariance matrix
    var_cov_matrix = zeros(ntheta);
    for i=1:npar_nonzero
        for j=1:npar_nonzero
            var_cov_matrix(par_index_nonzeros(i),par_index_nonzeros(j)) = iFIM(i,j);
        end
    end
    var_cov_matrix = var_cov_matrix*s2;
    % Correlation matrix
    corr_matrix=zeros(ntheta);% +1 removed AG. the matrix is extended only for pcolor. 
    
    for i=1:npar_nonzero
        for j=1:npar_nonzero
            corr_matrix(par_index_nonzeros(i),par_index_nonzeros(j)) = var_cov_matrix(par_index_nonzeros(i),par_index_nonzeros(j))/(abs((var_cov_matrix(par_index_nonzeros(i),par_index_nonzeros(i))*var_cov_matrix(par_index_nonzeros(j),par_index_nonzeros(j))))^0.5);
        end
    end
    
end



end