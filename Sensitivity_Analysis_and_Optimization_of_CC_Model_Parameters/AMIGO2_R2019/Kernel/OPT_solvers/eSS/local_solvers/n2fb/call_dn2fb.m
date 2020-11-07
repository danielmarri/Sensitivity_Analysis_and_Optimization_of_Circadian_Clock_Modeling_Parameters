%             [NAGWare Gateway Generator]
%
%Copyright (c) 1993-97 by the Numerical Algorithms Group Ltd 2.0a
%

function fobj = call_dn2fb(X,N,P,xl,xu,opts)

% Parameters for calling N2FB
LIV = 82+4*P;
LTY = N;
LV  = 98+P*(3*P+25)/2+7+P+N*(P+2)+P*(P+15)/2;
for i = 1:N
    TY(i,2) = 0;
end
for i = 1:N
    TY(i,1) = 0;
end

% SUPPLY LEAD DIMENSION OF TY IN UI(1)...
% (MOST COMPILERS WOULD LET US SIMPLY PASS LTY FOR UI,
% BUT SOME, E.G. WATFIV, WILL NOT.)
UI(1)     = LTY;
IV(1:LIV) = 0;
IV(17)    = opts(1); % MXFCAL
IV(18)    = opts(2); % MXITER
V(1:LV)   = 0;

% SUPPLY BOUNDS...
B(1,:) = xl;
B(2,:) = xu;

% Call the MEX function
[X,IV,V,TY] = wdn2fb(N,P,X,B,IV,LIV,LV,V,UI,TY);

fobj = X';

