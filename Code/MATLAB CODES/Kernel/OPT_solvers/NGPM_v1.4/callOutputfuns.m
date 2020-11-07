% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/NGPM_v1.4/callOutputfuns.m 770 2013-08-06 09:41:45Z attila $
function opt = callOutputfuns(opt, state, pop, type)
% Function: opt = callOutputfuns(opt, state, pop, type)
% Description: Call output function(if exist).
% Parameters: 
%   type : output type.  
%       -1 = the last call (close file for instance)
%       other values(or no exist) = normal output
%
%         LSSSSWC, NWPU
%    Revision: 1.1  Data: 2011-07-13
%*************************************************************************


if(nargin <= 3)
    type = 0;   % normal output
end


if( ~isempty(opt.outputfuns) )
    fun = opt.outputfuns{1};
    opt = fun(opt, state, pop, type, opt.outputfuns{2:end});
end


