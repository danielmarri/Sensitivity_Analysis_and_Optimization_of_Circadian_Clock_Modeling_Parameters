% test FD_Hessian
clear
syms x Y a b

% model
Y = a^2*20*exp(-b*x/2) + a*sin(b*x) + b;
% derivatives
J = jacobian(Y,[a,b]);
H = jacobian(J,[a,b]);
% general functions:
y = matlabFunction(Y,'vars',{x,a,b});
h = matlabFunction(H,'vars',{x,a,b});
j = matlabFunction(J,'vars',{x,a,b});

% example:
x = [1:0.1:10]';
b = 3;
a = 2;

% generate data
yhat = y(x,a,b) + 0.4*randn(size(x));

plot(x,y(x,a,b),'--'),hold on,
plot(x,yhat,'.');

% funtions for this examlpe (fixing variable x)
r = @(p)(yhat - y(x,p(1),p(2)));
ri = @(p,i)(yhat(i) - y(x(i),p(1),p(2)));
jex = @(p)j(x,p(1),p(2));


plot(x,r([a,b]),'*');
% parameterized model:
[JtJ rr2 ] = FD_Hessian([a,b],length(x),r,jex);
approxH = JtJ - rr2;

Hexact = zeros(2);
for i = 1:length(x)
    Hexact = Hexact - ri([a,b],i)*h(x(i),a,b);
end
Hexact = Hexact + jex([a,b])'*jex([a,b]);

(Hexact - approxH)./ Hexact