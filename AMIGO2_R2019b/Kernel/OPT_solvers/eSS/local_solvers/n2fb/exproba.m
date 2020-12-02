% Proba

function [f,gg,R] = exproba(x,t,yexp)

%Inicializacion necesaria en Matlab 5.0
f = [];
   
yteor = x(1)*t' + x(2);

   
% Objective function:   
R  = (yteor-yexp);
R  = reshape(R,numel(R),1);
f  = sum(sum((yteor-yexp).^2));
gg = 0;



   
     
   
 
 
 