% AMIGO_uinterp_delay: interpretes the inputs u for simulation & sens
% computation - with delay
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
% AMIGO_uinterp_delay: interpretes the inputs u for simulation & sens 
%                      with delay                                             %
%                                                                             %
%*****************************************************************************%


% MANAGES DELAYED INPUTS

          
    
    switch inputs.exps.u_delay_type{iexp}
        case 'cte'
               eval(inputs.exps.u_delay{iexp});
        case 'par'
            
            for ipar=1:inputs.model.n_par
            eval(sprintf('\t%s=par(%u);\n',inputs.model.par_names(ipar,:),ipar));
            end    
   
            evalc(inputs.exps.u_delay{iexp});
    end %switch inputs.exps.u_delay_type{iexp}

    dtu=0;
    tu=privstruct.t_con{iexp};
    u=privstruct.u{iexp};
    tudelay(1)=0;
    for i=1:numel(u)-1
        dtu=(tu(i+1)-tu(i));
        if u(i+1)<u(i) % --|__
           tudelay(i+1)=tu(i)+dtu+udelay; end;
        if u(i+1)>u(i) % __|--
           tudelay(i+1)=tu(i)+dtu+udelay; end
    end
    
                    
    privstruct.t_con{iexp}=tudelay;

