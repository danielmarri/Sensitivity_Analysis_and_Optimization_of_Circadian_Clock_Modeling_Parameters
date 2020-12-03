clear mex;
clear all;
close all;

% This simple problem consist of finding the parameters a and b
% which resut into the best fit to the experimental data
% 
% yteor = a*t + b;
%
% global optimum
% a = pi
% b = sqrt(2)

global t yexp

% Problem specifications
np  = 2;     
xL  = zeros(1,np);
xU  = 10*ones(1,np);
x0  = 0*ones(1,np);

% Solver options
max_fcall = 2000;
max_iter  = 3000;
s_opts    = [max_fcall max_iter];

% Time intervals
t = [0, 0.1653, 0.3307, 0.4960, 0.6614, 0.8267, 0.9921, 1.1574, 1.3228,...
     1.4881, 1.6535, 1.8188, 1.9842, 2.1495, 2.3149, 2.4802, 2.6456, 2.8109,...
     2.9762, 3.1416];
 
% Experimental data
yexp = [1.5069
        1.9406
        2.6614
        3.2502
        3.7290
        4.3154
        4.8676
        5.2485
        5.9349
        6.1935
        7.0753
        7.1509
        7.8594
        8.2048
        8.7709
        9.9641
       10.4012
       10.5698
       11.7872
       11.3227 ];

fobj = call_dn2fb(x0,length(yexp),np,xL,xU,s_opts);