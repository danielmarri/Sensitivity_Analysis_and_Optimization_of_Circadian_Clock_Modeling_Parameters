clear all

% main script for global
% function []=runglob(problem)

problem = 'trp';

[nvars,u,v,neq,nic,pw,x0] = testinputs(problem);

options.nsampl = 100;
options.nsel = 2;
options.maxnc = 20;
options.tolx = 1.e-6;
options.tolcon = 1.e-6;
options.maxfeval = 1.e6;
options.maxtime = 1.e6;

options.local = 'fmincon';
options.pweight = pw;

fprintf('\n***** Problem : %s ***** \n\n',upper(problem));
[x,f,clusters,info] = globalm(@testfcn,x0,u,v,neq,nic,options,problem)