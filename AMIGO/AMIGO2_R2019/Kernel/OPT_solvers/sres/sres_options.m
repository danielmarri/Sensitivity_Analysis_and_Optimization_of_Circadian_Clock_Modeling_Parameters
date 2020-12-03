% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/sres/sres_options.m 770 2013-08-06 09:41:45Z attila $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           SRES INPUT DATA                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [opts]=sres_options;

% NP:  population size (number of offspring) (100 to 200)
opts.NP =200;  	

% itermax:  maximum number of iterations (generations)
opts.itermax = 200;  

%mu:    parent number (mu/NP usually 1/7)

opts.mu=ceil(opts.NP/7);

%pf:    pressure on fitness in [0 0.5] try around 0.45
%       for unconstrained cases try >0.5
opts.pf=0.45; %0.525; %

%varphi: expected rate of convergence (usually 1)

opts.varphi=1;


% var: for the initial population

opts.var=1.0;

opts.vareta=1.0;

% convergence criterium

opts.cvarmax=1.0e-10;

return