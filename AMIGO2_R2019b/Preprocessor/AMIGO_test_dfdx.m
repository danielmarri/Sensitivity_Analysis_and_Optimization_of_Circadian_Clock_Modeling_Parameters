function AMIGO_test_dfdx(inputs)
% test the Jacobian computation.
% here we compare the symbolic computation of the dfdx hand side with
% finite difference method.



% create a matlab function for the symbolically computed Jacobian function
AMIGO_gen_matlab_jacobian(inputs,'Jac_temp123456');
rehash

% compare the Jacobians at some points:
t = 0;
x = inputs.exps.exp_y0{1};
iexp = 1;
AMIGO_uinterp
u = inputs.exps.u{1};

p = inputs.model.par;


J = Jac_temp123456(t,x,[],p,u,zeros(1,length(inputs.exps.u{1})),t);

Jfd = FD_Jacobian(x,length(x),@(x)wrapper_numdiff(x,inputs),0.01*(abs(x)+inputs.ivpsol.atol),'cfd');

% see the larger than 0.01% differences:
% spy(abs(J - Jfd)>0.0001*abs(J+Jfd))

% 

rel_diff = norm(J-Jfd,'fro')/(0.5*norm(abs(J) + abs(Jfd),'fro'));
if rel_diff > 1e-3
    fprintf('--->Warning: the accuracy test of the Jacobian is faild.\nRelative difference between the central finite difference and symbolic J is %g > 1e-3\n',rel_diff);
end



% % algebraic  equations
%     if inputs.model.AMIGOjac == 1
% inputs.model.J
end

function ydot = wrapper_numdiff(y,inputs)
iexp = 1;
AMIGO_uinterp
[J,ydot]=Jac_temp123456(0,y,[],inputs.model.par,inputs.exps.u{1},zeros(1,length(inputs.exps.u{1})),0);
end