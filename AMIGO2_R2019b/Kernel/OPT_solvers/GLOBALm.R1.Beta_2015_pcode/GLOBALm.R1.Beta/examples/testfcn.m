function [f,ci] = testfcn(x,problem)

x = x(:);
ci = []; 

switch problem

    case {'trp'}
        xx = x(1); yy = x(2); zz = x(3); ki = x(4);
        
        alfa1=0.9;
        alfa2=0.02;
        alfa3=0.0;
        alfa6=7.5;
        k=0.005;

        u = xx/yy - alfa2;   
        r = 1.0/zz*( (zz+1)/((alfa1+u)*xx) - 1.0) - 1.0;
        alfa4 = 2.2464e-3*r;
        alfa5 = ( - u*zz - alfa4*zz/(1+zz) + yy*ki^2/(ki^2+zz^2))/((1-alfa6*u)*u*zz/(zz+k)) ;
        
        vprod = alfa5*(1-alfa6*u)*u*zz/(zz+k);
        f = -vprod;
        
        ci(1,:) = 0.0 - u;
        ci(2,:) = u - 0.2;
        ci(3,:) = 4.0 - r;
        ci(4,:) = r - 10;
        ci(5,:) = 0 - alfa5;
        ci(6,:) = alfa5 - 1000;
        
    case {'fpdesign'}
         h=x(1);fc=x(2);ff=x(3);s=x(4);
         
         R=3.00; R2=R*R;
         sf=0.3; sc=1.00;
         a=5.4; b=180.; k=1.00; kk=0.12;
         
         c1=5.00; c2=10.8; c3=150.0; c4=0.04;
         fbmv=4.5; fbmc=3.4; bv=1836.5; bc=54325.0;
         
         xx=( (ff*(sf-s)+fc*(sc-s))/(pi*R2*h) ) * (a+b*s)/(k*s*exp(-s/kk));
         fv=(k*s*exp(-s/kk))*pi*R2*(h^0.5);
         alfa=1.- (ff+fc)/(fv*h^0.5);
         
         P= 1.0e-7*(c1*xx*fv*h^0.5 - c2*ff - c3*fc - (c4*xx*fv*h^0.5)/3600)*504000.;
         FCI= 1.18e-7*(fbmv*bv*(pi*R2*h)^0.724 + fbmc*bc*(xx*fv*h^0.5)^0.444);
         ROR=0.15;  
         
         FI= P - ROR*FCI;
         
         if isreal(FI)
             f = -FI;
         else
             f = 1.e5;
         end
         
         ci(1,:) = h - 1.9*R;
         ci(2,:) = - alfa;
         ci(3,:) = 1 - (xx*fv*h^0.5);
    
end
