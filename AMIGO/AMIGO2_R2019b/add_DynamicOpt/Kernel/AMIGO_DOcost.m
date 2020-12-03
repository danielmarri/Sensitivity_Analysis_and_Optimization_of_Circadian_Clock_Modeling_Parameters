%% Obejctive functional
% [yteor] = AMIGO_ODcost(od,inputs,results,privstruct)
%
%  Arguments: od (current value of decision variables)
%             inputs,results,privstruct
%             yteor (value of the states for the given 
%                    decision variables)
% *Version details*
% 
%   AMIGO_OD version:     March 2013
%   Code development:     Eva Balsa-Canto
%   Address:              Process Engineering Group, IIM-CSIC
%                         C/Eduardo Cabello 6, 36208, Vigo-Spain
%   e-mail:               ebalsa@iim.csic.es 
%   Copyright:            CSIC, Spanish National Research Council
%
% *Brief description*
%
%  Function that provides the necessary inputs for the OD 
%  cost function and constraints. Note that problem dependent
%  functions will be generated for cost function and constraints.
%   
%%



function [yteor] = AMIGO_DOcost(od,inputs,results,privstruct);

    % Initialice cost
        f=0.0;
        g=[];
        h=[];
        privstruct.do=od;
        
%% CVP approach
%
% * Calls AMIGO_transform_od to generate u and tf from the vector od
        [privstruct,inputs,results]=AMIGO_transform_do(inputs,results,privstruct);
        
              
        yt=zeros(length(privstruct.t_int{1}),inputs.model.n_st);
        
%% Inner iteration: IVP solution
%
% * Calls AMIGO_ivpsol
        %if privstruct.iflag==2   
        [yt,privstruct]=AMIGO_ivpsol(inputs,privstruct,privstruct.y0{1},privstruct.par{1},1);
        %end

        if privstruct.iflag<0 || sum(sum(isnan(yt)))>=1
            switch inputs.DOsol.DOcost_type
                case 'max'
                    yteor=-1e30*ones(size(yt));%-inf(size(yt));
                case 'min'
                    yteor=1e30*ones(size(yt));%inf(size(yt));
            end         
        else
        yteor=yt;    
        end    
        
return