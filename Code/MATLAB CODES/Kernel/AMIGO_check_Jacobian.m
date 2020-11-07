function [J, JacRes]= AMIGO_check_Jacobian(theta, inputs,Tindex)
% check the Jacobian computation for the set of inputs
% Syntax:
%   [relJerr dt rdt]= AMIGO_check_Jacobian(theta, inputs,[Tindex])
%   Tindex: index vector of the theta: only the corresponding Jacobians are
%       visualized. 
%   


[inputs,results,privstruct]=REG_Structs_PE(inputs);

ntheta = size(theta,2);

if nargin < 3 | isempty(Tindex)
    Tindex = 1:ntheta;
end

Nscenarios = size(theta,1);
relJerr = zeros(Nscenarios,1);
dt = zeros(Nscenarios,1);
rdt = zeros(Nscenarios,1);

for iscen = 1:Nscenarios
   
    fprintf('AMIGO_PEJac() ....\n')
    tic
    [JacObj,~, JacRes, ~,   ~] = AMIGO_PEJac(theta(iscen,:),inputs,results,privstruct);
    t1 = toc;
    fprintf('Elapsed time: %f seconds...\n',t1);
    fprintf('Central finite difference os AMIGO_PEcost()....\n')
    tic
    J = FD_Jacobian(theta(iscen,:),size(JacRes,1),@(x)fun_residuals(x,inputs,results,privstruct),1e-5*theta(iscen,:),'cfd');
    t2 = toc;
    fprintf('Elapsed time: %f seconds...\n',t2);
    
    if Nscenarios == 1
        
        for itheta = Tindex
        figure()
        subplot(211)
        plot(abs(J(:,itheta)),'ro')
        title(sprintf('Comparison of the Jacobian, theta: %d',itheta))
        hold on
        set(gca,'yscale','log')
        plot(abs(JacRes(:,itheta)),'k*')
        legend({'Centr. FD','AMIGO_PEJac'})
        
        
        subplot(212)
        plot(abs(J(:,itheta)-JacRes(:,itheta)),'.')
        set(gca,'yscale','log')
        title('Differences')
        end
    end
    
    relJerr(iscen) = mean (abs(J(:)-JacRes(:)))/mean(abs(0.5*J(:)+0.5*JacRes(:)));
    fprintf('Relative error: %g \n',relJerr(iscen))
    dt(iscen) = t2-t1;
    rdt(iscen) = (t2-t1)/t2;
    
    
end



end



function R = fun_residuals(theta,inputs,results,privstruct)
[f,h,g,regobj,regres] = AMIGO_PEcost(theta,inputs,results,privstruct);
R = g(:);
end