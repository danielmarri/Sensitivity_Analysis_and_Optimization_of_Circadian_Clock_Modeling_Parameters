function [nvars,u,v,neq,nic,pw,x0] = testinputs(problem)

x0 = [];
switch problem
        
    case {'trp'}
        nvars = 4;
        u = [0.147723; 6.389404; 1135.145555; 500.0];
        v = [0.221584; 9.584107; 1702.718332; 5000.0];
        neq = 0;
        nic = 6; 
        pw = 10.0;
        x0 = [ 0.1846536
            7.986748
            1421.301
            2283 ];

    case {'fpdesign'}
        nvars = 4;
        u = 1.e-6*ones(4,1);
        v = [7.0; 10; 10; 1];
        neq = 0;
        nic = 3;
        pw = 100;
    
end

    