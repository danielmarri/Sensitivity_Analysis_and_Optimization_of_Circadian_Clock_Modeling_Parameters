% $Header: svn://.../trunk/AMIGO2R2016/Kernel/IVP_solvers/sens_analysis_1.1/AMIGO_loop_senssys.m 1803 2014-07-14 14:28:02Z attila $
options = odeset('RelTol',inputs.ivpsol.rtol,'AbsTol',inputs.ivpsol.atol,'BDF','on');


y_0=privstruct.y_0{iexp};
sens_y0=inputs.PEsol.sens0;


if privstruct.t_int{iexp}(1)==inputs.exps.t_in{iexp}
    privstruct.yteor(1,:)=y_0;
    i_int=2;
else
    i_int=1;
end
i_con=1;
vecpar=0;


for i_out=1:size(privstruct.vtout{iexp},2)-1
    tin=privstruct.vtout{iexp}(i_out);
    tout=privstruct.vtout{iexp}(i_out+1);
    %                      if inputs.PEsol.n_theta_y0>0
    %                      eval(sprintf('[t,yout,dydp] = sens_sys(''%s'',[tin tout],y_0'',options,par,vecpar,''sensy0'',par,privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.model.matlabmodel_file) );
    %                      else
    
    eval(sprintf('[t,yout,dydp] = sens_sys(''%s'',[tin tout],y_0'',sens_y0,options,privstruct.par{iexp}'',vecpar,[],privstruct.u{iexp}(:,i_con),inputs.exps.pend{iexp}(:,i_con),t_old);',inputs.model.matlabmodel_file) );
    %                     end
    
    % Keep values to next integration step
    y_0=yout(size(t,1),:);
    
    for ipar=1:n_par
        sens_y0(:,ipar)=reshape(dydp(size(t,1),:,ipar),inputs.model.n_st,1);
    end
    
    % If t out= t measurement, keep information
    if (i_int<=size(privstruct.t_int{iexp},2)) & (tout==privstruct.t_int{iexp}(i_int))
        privstruct.yteor(i_int,:)=yout(size(t,1),:);
        dydpt_full(i_int,:,:)=dydp(size(t,1),:,:);
        i_int=i_int+1;
    end
    % If t out= t control, update control value
    %    [tout  inputs.exps.t_con{iexp}(i_con)]
    if (privstruct.n_steps{iexp}+1>1)
        if (tout>=privstruct.t_con{iexp}(i_con+1)) & ((i_con+1)<privstruct.n_steps{iexp}+1)
            i_con=i_con+1;
        end
    end
    t_old=privstruct.t_con{iexp}(i_con);
end % END INTEGRATION LOOP


