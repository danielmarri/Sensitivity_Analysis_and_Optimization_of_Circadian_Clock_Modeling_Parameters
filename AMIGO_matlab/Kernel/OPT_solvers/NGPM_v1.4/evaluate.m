% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/evaluate.m 770 2013-08-06 09:41:45Z attila $
function [pop, state] = evaluate(opt, pop, state, inputs,results,privstruct)
% Function: [pop, state] = evaluate(opt, pop, state, varargin)
% Description: Evaluate the objective functions of each individual in the
%   population.
%
%         LSSSSWC, NWPU
%    Revision: 1.0  Data: 2011-04-20
%*************************************************************************



N = length(pop);
allTime = zeros(N, 1);  % allTime : use to calculate average evaluation times

%*************************************************************************
% Evaluate objective function in parallel
%*************************************************************************
if( strcmpi(opt.useParallel, 'yes') == 1 )
    curPoolsize = matlabpool('size');

    % There isn't opened worker process
    if(curPoolsize == 0)
        if(opt.poolsize == 0)
            matlabpool open local
        else
            matlabpool(opt.poolsize)
        end
    % Close and recreate worker process
    else
        if(opt.poolsize ~= curPoolsize)
            matlabpool close
            matlabpool(opt.poolsize)
        end
    end

    parfor i = 1:N
        fprintf('\nEvaluating the objective function... Generation: %d / %d , Individual: %d / %d \n', state.currentGen, opt.maxGen, i, N);
        [pop(i), allTime(i)] = evalIndividual(pop(i), opt.objfun, inputs,results,privstruct);
    end

%*************************************************************************
% Evaluate objective function in serial
%*************************************************************************
else
    for i = 1:N
        fprintf('\nEvaluating the objective function... Generation: %d / %d , Individual: %d / %d \n', state.currentGen, opt.maxGen, i, N);
        [pop(i), allTime(i)] = evalIndividual(pop(i), opt.objfun, inputs,results,privstruct);
    end
   
end

%*************************************************************************
% Statistics
%*************************************************************************
state.avgEvalTime   = sum(allTime) / length(allTime);
state.evaluateCount = state.evaluateCount + length(pop);




function [indi, evalTime] = evalIndividual(indi, cost_func, inputs,results,privstruct)
% Function: [indi, evalTime] = evalIndividual(indi, objfun, varargin)
% Description: Evaluate one objective function.
%
%         LSSSSWC, NWPU
%    Revision: 1.1  Data: 2011-07-25
%*************************************************************************

tStart = tic;
% EBC modification over call to cost function
eval(sprintf('[f,g]=%s(indi.var,inputs,results,privstruct);',cost_func));

%[f, g] = cost_func( indi.var, inputs,results,privstruct );

evalTime = toc(tStart);

% Save the objective values and constraint violations
indi.obj = f;
if( ~isempty(indi.cons) )
    idx = find( g );
    if( ~isempty(idx) )
        indi.nViol = length(idx);
        indi.violSum = sum( abs(g) );
    else
        indi.nViol = 0;
        indi.violSum = 0;
    end
end


