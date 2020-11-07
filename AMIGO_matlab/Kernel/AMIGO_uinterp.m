% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_uinterp.m 2046 2015-08-24 12:43:55Z attila $
% AMIGO_uinterp: interpretes the inputs u for simulation & sens computation
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_uinterp: interpretes the inputs u for simulation & sens computation   %
%                                                                             %
%*****************************************************************************%


if inputs.model.n_stimulus==0
    inputs.exps.pend{iexp}(1,1)=0;
    inputs.exps.u{iexp}(1,1)=0;
    privstruct.u{iexp}(1,1)=0;
    n_u=1;
    ncon{iexp}=1;
else
    n_u=inputs.model.n_stimulus;
    
    
    switch inputs.exps.u_interp{iexp}
        case {'sustained'}
            inputs.exps.pend{iexp}(1:inputs.model.n_stimulus,1)=0;
            inputs.exps.n_steps{iexp}=1;
            ncon{iexp}=inputs.exps.n_steps{iexp};
            privstruct.u{iexp}=[inputs.exps.u{iexp}];
            privstruct.pend{iexp}=inputs.exps.pend{iexp};
            
        case {'step','stepf'}
            inputs.exps.pend{iexp}(1:inputs.model.n_stimulus,1:inputs.exps.n_steps{iexp})=0;
            ncon{iexp}=inputs.exps.n_steps{iexp};
            privstruct.u{iexp}=[inputs.exps.u{iexp}];
            privstruct.pend{iexp}=inputs.exps.pend{iexp};
        case {'pulse-up'}
            inputs.exps.n_steps{iexp}=2*inputs.exps.n_pulses{iexp}+1;
            inputs.exps.pend{iexp}(1:inputs.model.n_stimulus,1:inputs.exps.n_steps{iexp})=0;
            for iu=1:inputs.model.n_stimulus
                inputs.exps.u{iexp}(iu,1:inputs.exps.n_steps{iexp})=[repmat([inputs.exps.u_min{iexp}(iu) inputs.exps.u_max{iexp}(iu)],1,inputs.exps.n_pulses{iexp}) inputs.exps.u_min{iexp}(iu)];
            end
            privstruct.u{iexp}=[inputs.exps.u{iexp}];
            ncon{iexp}=inputs.exps.n_steps{iexp};
            privstruct.pend{iexp}=inputs.exps.pend{iexp};
            
        case {'pulse-down'}
            inputs.exps.n_steps{iexp}=2*inputs.exps.n_pulses{iexp};
            inputs.exps.pend{iexp}(1:inputs.model.n_stimulus,1:inputs.exps.n_steps{iexp})=0;
            for iu=1:inputs.model.n_stimulus
                inputs.exps.u{iexp}(iu,1:inputs.exps.n_steps{iexp})=repmat([inputs.exps.u_max{iexp}(iu) inputs.exps.u_min{iexp}(iu)],1,inputs.exps.n_pulses{iexp});
            end
            privstruct.u{iexp}=[inputs.exps.u{iexp}];
            ncon{iexp}=inputs.exps.n_steps{iexp};
            privstruct.pend{iexp}=inputs.exps.pend{iexp};
            
        case {'linear','linearf'}
            
            ncon{iexp}=inputs.exps.n_linear{iexp}-1;
            
            for iu=1:inputs.model.n_stimulus
                for irho=1:inputs.exps.n_linear{iexp}-1
                    tins=inputs.exps.t_con{iexp}(irho);
                    tfs=inputs.exps.t_con{iexp}(irho+1);
                    if tfs>tins
                        inputs.exps.pend{iexp}(iu,irho)=(inputs.exps.u{iexp}(iu,irho+1)-inputs.exps.u{iexp}(iu,irho))/(tfs-tins);
                    else
                        inputs.exps.pend{iexp}(iu,irho)=0;%(inputs.exps.u{iexp}(iu,irho+1)-inputs.exps.u{iexp}(iu,irho))/1e-5;
                    end
                end
            end
            privstruct.u{iexp}=inputs.exps.u{iexp}(:,1:inputs.exps.n_linear{iexp}-1);
            results.oed.u_full{iexp}=inputs.exps.u{iexp};
            privstruct.pend{iexp}=inputs.exps.pend{iexp};
    end
end

privstruct.n_steps{iexp}=ncon{iexp};                          

