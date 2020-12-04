% $Header: svn://.../trunk/AMIGO2R2016/Examples/Mammalian_circadian/circadian_pe.m 2410 2015-12-07 13:58:57Z evabalsa $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: The circadian clock in Mammalian
%
%        Type :
%                > help circadian_tutorial
%        for a more detailed description of the model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        INPUT FILE TO ESTIMATE MODEL UKNOWNS
%
%        This is the minimum input file to simualate with real data.
%        Default values are assigned to non defined inputs.
%
%        Minimum required inputs:
%           > Paths related data
%           > Model:               model_type; n_st; n_par; n_stimulus; 
%                                  st_names; par_names; stimulus_names;  
%                                  eqns; par
%           > Experimental scheme: n_exp; exp_y0{iexp}; t_f{iexp}; 
%                                  u_interp{iexp}; t_con{iexp}; u{iexp}
%                                  n_obs{iexp}; obs_names{iexp}; obs{iexp} 
%
%                (AMIGO_PE)==>>    n_s{iexp}; t_s{iexp}; 
%                                  data_type; noise_type; 
%                                  exp_data{iexp}; [error_data{iexp}]
%                                  id_global_theta; [id_global_theta_y0]
%                                  [id_local_theta{iexp}];[id_local_theta_y0{iexp}]global_theta_max; global_theta_min
%                                  [global_theta_y0_max];[global_theta_y0_min]
%                                  [local_theta_max{iexp}];[local_theta_min{iexp}]
%                                  [local_theta_y0_max{iexp}];[local_theta_yo_min{iexp}]
%                                  [global_theta_guess];[global_theta_y0_guess];
%                                  [local_theta_guess{iexp}];[local_theta_y0_guess{iexp}]
%                                  [PEcost_type];[lsq_type];[llk_type]
%                                  []:optional inputs
%                                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='circadian-tutorial';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='circadian';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=23;                                       % Number of states      
inputs.model.n_par=70;                                     % Number of model parameters 
inputs.model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('Per_mRNA','Cry_mRNA' ,'Bmal1_mRNA','Ror_mRNA','Rev_erb_mRNA','CYTOSOLIC_PER_PROTEIN','CYTOSOLIC_CRY_PROTEIN','CYTOSOLIC_BMAL1_PROTEIN',...
    'CYTOSOLIC_ROR_PROTEIN','CYTOSOLIC_REV_ERB_PROTEIN','CYTOSOLIC_PER_CRY_PROTEIN','PHOS_CYTOSOLIC_PER_PROTEIN','PHOS_CYTOSOLIC_CRY_PROTEIN','PHOS_CYTOSOLIC_BMAL1_PROTEIN',...
    'PHOS_CYTOSOLIC_ROR_PROTEIN','PHOS_CYTOSOLIC_REV_ERB_PROTEIN','PHOS_CYTOSOLIC_PER_CRY_PROTEIN','NUCLEAR_BMAL1_PROTEIN','NUCLEAR_ROR_PROTEIN','NUCLEAR_REV_ERB_PROTEIN', ...
    'NUCLEAR_CLOCK_BMAL1_PROTEIN','NUCLEAR_PER_CRY_PROTEIN','NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN');     % Names of the states                                              

inputs.model.par_names=char('n','m','p','q','O','l','r','s','g','h','vPs','kiP','d_mP','vCs','kiC','d_mC','vBs','kiB','d_mB','vRs','kiR','d_mR','vRes','kiRe','d_mRe',...
    'k','Kpc1','Kpco','Kpc','Kppc','dpc','k1','Kcc','Kcpc','dcc','k2','Kbcc','Kbc','Kbpc','dbc','k3','Krcc','Krc','Krpc','drc','k4','Krecc','Krec','Krepc','drec',...
    'Kpcc','Kpcp','Kpcpc','dpcc','dppc','dcpc','dbpc','drpc','drepc','dpcpc','Kclbn','dbn','Krn','drn','Kren','dren','kcbpc','dclbn','dpcn','kdcbpc' );                  % Names of the parameters                     

inputs.model.stimulus_names=char('light');                                        % Names of the stimuli, inputs or controls                      

inputs.model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dPer_mRNA=((vPs*(light*NUCLEAR_CLOCK_BMAL1_PROTEIN)^m)/(kiP^m + ((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN))^n + (NUCLEAR_CLOCK_BMAL1_PROTEIN)^m))  - d_mP*Per_mRNA',...
                    'dCry_mRNA=((vCs*(light*NUCLEAR_CLOCK_BMAL1_PROTEIN)^p)/(kiC^p + ((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN))^q + (NUCLEAR_CLOCK_BMAL1_PROTEIN)^p))  - d_mC*Cry_mRNA',...
                    'dBmal1_mRNA= ((vBs*((NUCLEAR_ROR_PROTEIN)^O))/(kiB^O + ((NUCLEAR_ROR_PROTEIN)*(NUCLEAR_REV_ERB_PROTEIN))^l+ (NUCLEAR_ROR_PROTEIN)^O))  - d_mB*Bmal1_mRNA',...
                    'dRor_mRNA =((vRs*(NUCLEAR_CLOCK_BMAL1_PROTEIN)^r)/(kiR^r + ((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN))^s + (NUCLEAR_CLOCK_BMAL1_PROTEIN)^r))  - d_mR*Ror_mRNA',...
                    'dRev_erb_mRNA=((vRes*(light*NUCLEAR_CLOCK_BMAL1_PROTEIN)^g)/(kiRe^g + ((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN))^h + (NUCLEAR_CLOCK_BMAL1_PROTEIN)^g))  - d_mRe*Rev_erb_mRNA',... 
                    'dCYTOSOLIC_PER_PROTEIN=k*Per_mRNA + Kpc1*(CYTOSOLIC_PER_CRY_PROTEIN) - Kpco*(CYTOSOLIC_PER_PROTEIN)*(CYTOSOLIC_CRY_PROTEIN) - Kpc*((CYTOSOLIC_PER_PROTEIN)) + Kppc*(PHOS_CYTOSOLIC_PER_PROTEIN) -  dpc*(CYTOSOLIC_PER_PROTEIN)',...
                    'dCYTOSOLIC_CRY_PROTEIN= k1*Cry_mRNA + Kpc1*(CYTOSOLIC_PER_CRY_PROTEIN) - Kpco*(CYTOSOLIC_PER_PROTEIN)*(CYTOSOLIC_CRY_PROTEIN) - Kcc*((CYTOSOLIC_CRY_PROTEIN))  + Kcpc*(PHOS_CYTOSOLIC_CRY_PROTEIN)- dcc*(CYTOSOLIC_CRY_PROTEIN)',...
                    'dCYTOSOLIC_BMAL1_PROTEIN=k2*Bmal1_mRNA - Kbcc*(CYTOSOLIC_BMAL1_PROTEIN)- Kbc*(CYTOSOLIC_BMAL1_PROTEIN) + Kbpc*(PHOS_CYTOSOLIC_BMAL1_PROTEIN) - dbc*(CYTOSOLIC_BMAL1_PROTEIN)',...
                    'dCYTOSOLIC_ROR_PROTEIN= k3*Ror_mRNA - Krcc*(CYTOSOLIC_ROR_PROTEIN)- Krc*((CYTOSOLIC_ROR_PROTEIN)) + Krpc*(PHOS_CYTOSOLIC_ROR_PROTEIN) - drc*(CYTOSOLIC_ROR_PROTEIN)',...
                    'dCYTOSOLIC_REV_ERB_PROTEIN= k4*Rev_erb_mRNA  - Krecc*(CYTOSOLIC_REV_ERB_PROTEIN)- Krec*((CYTOSOLIC_REV_ERB_PROTEIN)) + Krepc*(PHOS_CYTOSOLIC_REV_ERB_PROTEIN) - drec*(CYTOSOLIC_REV_ERB_PROTEIN)',...
                    'dCYTOSOLIC_PER_CRY_PROTEIN=Kpco*((CYTOSOLIC_PER_PROTEIN)*(CYTOSOLIC_CRY_PROTEIN))  - Kpcc*(CYTOSOLIC_PER_CRY_PROTEIN) - Kpc1*(CYTOSOLIC_PER_CRY_PROTEIN)- Kpcp*((CYTOSOLIC_PER_CRY_PROTEIN))+ Kpcpc*(PHOS_CYTOSOLIC_PER_CRY_PROTEIN)-dpcc*(CYTOSOLIC_PER_CRY_PROTEIN)',...
                    'dPHOS_CYTOSOLIC_PER_PROTEIN=Kpc*(CYTOSOLIC_PER_PROTEIN)  - Kppc*(PHOS_CYTOSOLIC_PER_PROTEIN) - dppc*(PHOS_CYTOSOLIC_PER_PROTEIN)',...
                    'dPHOS_CYTOSOLIC_CRY_PROTEIN= Kcc*(CYTOSOLIC_CRY_PROTEIN)  - Kcpc*(PHOS_CYTOSOLIC_CRY_PROTEIN) - dcpc*(PHOS_CYTOSOLIC_CRY_PROTEIN)',...
                    'dPHOS_CYTOSOLIC_BMAL1_PROTEIN=Kbc*(CYTOSOLIC_BMAL1_PROTEIN)  - Kbpc*(PHOS_CYTOSOLIC_BMAL1_PROTEIN) - dbpc*(PHOS_CYTOSOLIC_BMAL1_PROTEIN)',...
                    'dPHOS_CYTOSOLIC_ROR_PROTEIN= Krc*(CYTOSOLIC_ROR_PROTEIN)  - Krpc*(PHOS_CYTOSOLIC_ROR_PROTEIN) - drpc*(PHOS_CYTOSOLIC_ROR_PROTEIN)',...
                    'dPHOS_CYTOSOLIC_REV_ERB_PROTEIN=Krec*(CYTOSOLIC_REV_ERB_PROTEIN) - Krepc*(PHOS_CYTOSOLIC_REV_ERB_PROTEIN) - drepc*(PHOS_CYTOSOLIC_REV_ERB_PROTEIN)',...
                    'dPHOS_CYTOSOLIC_PER_CRY_PROTEIN= Kpcp*((CYTOSOLIC_PER_CRY_PROTEIN))  - Kpcpc*(PHOS_CYTOSOLIC_PER_CRY_PROTEIN) - dpcpc*(PHOS_CYTOSOLIC_PER_CRY_PROTEIN)',...
                    'dNUCLEAR_BMAL1_PROTEIN=Kbcc*(CYTOSOLIC_BMAL1_PROTEIN) - Kclbn*(NUCLEAR_BMAL1_PROTEIN)  -  dbn*(NUCLEAR_BMAL1_PROTEIN)',...
                    'dNUCLEAR_ROR_PROTEIN= Krcc*(CYTOSOLIC_ROR_PROTEIN) - Krn*(NUCLEAR_ROR_PROTEIN)  -  drn*(NUCLEAR_ROR_PROTEIN)',...
                    'dNUCLEAR_REV_ERB_PROTEIN=Krecc*(CYTOSOLIC_REV_ERB_PROTEIN) - Kren*(NUCLEAR_REV_ERB_PROTEIN)  -  dren*(NUCLEAR_REV_ERB_PROTEIN)',...
                    'dNUCLEAR_CLOCK_BMAL1_PROTEIN=Kclbn*(NUCLEAR_BMAL1_PROTEIN)  - kcbpc*(NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN) + kdcbpc*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN) -  dclbn*(NUCLEAR_CLOCK_BMAL1_PROTEIN) + dpcn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)',...
                    'dNUCLEAR_PER_CRY_PROTEIN= Kpcc*(CYTOSOLIC_PER_CRY_PROTEIN)  - kcbpc*(NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN) + kdcbpc*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN) - dpcn*(NUCLEAR_PER_CRY_PROTEIN) + dclbn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)',...
                    'dNUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN= kcbpc*(NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN) - kdcbpc*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN) -  dclbn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)-dpcn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)');              
                             
                
inputs.model.par=[5 6 8 7 8 8 8 7 8 6 3.90 0.25 0.46 3.87 0.262 0.424 3.63 0.13 0.19 3.24 0.27 0.472 3.71 0.25 0.482 0.408 0.362 0.3 0.304 0.39 0.23...
                  0.39 0.365 0.306 0.18 0.47 0.342 0.298 0.385 0.07 0.402 0.394 0.361 0.166 0.05 0.419 0.374 0.3611 0.3363 0.06...
                  0.375 0.24412 0.3623 0.017 0.023 0.019 0.013 0.02 0.23 0.025 0.37 0.09 0.3482 0.0704 0.349 0.0608 0.39 0.30 0.15 0.46]; % These values may be updated during optimization  


%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
 inputs.exps.n_exp=2;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
 inputs.exps.exp_y0{iexp}=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2.0153 2.2153 2.0153 2.0353 1.9043 2.0353];  %Initial conditions for each experiment          
 inputs.exps.t_f{iexp}=96;                            %Experiments duration
           
% OBSEVABLES DEFINITION  
 inputs.exps.n_obs{iexp}=5;                            % Number of observed quantities per experiment  
 inputs.exps.obs_names{iexp}=char('Per_mRNA','Cry_mRNA' ,'Bmal1_mRNA','Ror_mRNA','Rev_erb_mRNA');      % Name of the observed quantities per experiment    
 inputs.exps.obs{iexp}=char('Per_mRNA=Per_mRNA','Cry_mRNA=Cry_mRNA' ,'Bmal1_mRNA=Bmal1_mRNA','Ror_mRNA=Ror_mRNA','Rev_erb_mRNA=Rev_erb_mRNA');   % Observation function
 end 
 
 
 
 inputs.exps.u_interp{1}='sustained';                  %Stimuli definition for experiment 1:
                                                       %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down' 
 inputs.exps.t_con{1}=[0 96];                         % Input swithching times: Initial and final time    
 inputs.exps.u{1}=[1];                                 % Values of the inputs 
 
 inputs.exps.u_interp{2}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{2}=4;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u_min{2}=0;inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{2}=[0 :12: 96];                    %Times of switching: Initial time, Intermediate times, Final time
                           
%==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================                                                            
 inputs.exps.n_s{1}=30;                                % [] Number of sampling times for each experiment.
 inputs.exps.n_s{2}=35;                                %    Optative input. By default "continuous" measurements are assumed.
% inputs.exps.t_s{1}=[1 2 3 ...];                      % [] Sampling times for each experiment, by default equidistant
% inputs.exps.t_s{2}=[0 5 7 ...];                      % [] Sampling times for each experiment, by default equidistant

 inputs.exps.data_type='real';                         % Type of experimental data: 'real'|'pseudo'|'pseudo_pos'(>=0)  
 inputs.exps.noise_type='homo_var';                    % Type of experimental noise: Gaussian with zero mean and 
                                                       %                             Homoscedastic with constant variance: 'homo'
                                                       %                             Homoscedastic with varying variance:'homo_var'
                                                       %                             Heteroscedastic: 'hetero' 

% Experimental data per experiment n_s{iexp}x n_obs{iexp}
inputs.exps.exp_data{1}=[
		0  0  0  0  0
		1.03356  0.556106  5.22121  0.442173  0.78354
		3.55633  2.80378  10.6886  3.25712  3.28999
		8.45149  12.1725  8.16686  5.54484  7.39176
		6.24749  4.75561  4.92219  4.45027  7.21814
		1.73476  1.96629  2.31733  1.33905  3.1814
		1.10562  0.357933  1.20484  0.31389  1.17419
		0.600992  0.30408  0.802346  0.127638  0.647424
		0.738257  0.165671  3.93944  0.115536  0.555957
		1.55461  0.854669  11.5875  0.700826  1.9787
		5.21657  5.08874  10.4968  4.17583  5.88679
		5.80571  7.51047  7.12534  5.96789  6.37729
		3.48243  2.88663  2.74468  2.04725  4.90753
		1.17551  1.01531  1.7594  0.618866  1.91519
		0.50868  0.282558  1.04584  0.116125  0.809465
		0.411449  0.139656  1.32887  0.0961693  0.449454
		0.67365  0.19247  7.46887  0.188357  0.620225
		2.97219  2.70692  11.1915  1.99596  4.84879
		7.44439  9.56309  8.65324  5.917  7.55284
		7.0452  6.83805  6.02172  3.36076  7.40909
		2.35348  2.05447  2.44538  1.09454  4.19853
		0.804417  0.597384  1.45722  0.287536  1.52766
		0.431839  0.219951  0.738027  0.108238  0.603567
		0.463982  0.157787  3.96176  0.130812  0.39334
		1.34533  0.386322  9.93872  0.446463  1.0194
		4.89478  4.35131  12.968  4.97599  5.60634
		6.47666  12.6017  7.72641  4.06528  7.71345
		5.13033  3.8641  3.73369  3.12817  5.70566
		1.46088  1.41663  1.79976  1.17922  2.44035
		0.917808  0.314987  1.20317  0.248064  0.933238
		];

    % Experimental noise, n_s{iexp}x n_obs{iexp}
inputs.exps.error_data{1}=[
		0  0  0  0  0
		0.153235  0.0755482  0.467688  0.0816351  0.0927794
		0.485079  0.444442  1.13485  0.479787  0.318168
		1.00208  1.07676  0.900567  1.13211  0.656694
		0.854214  0.848121  0.48092  0.848343  0.649458
		0.361948  0.280971  0.256436  0.252839  0.31827
		0.145056  0.0852155  0.136909  0.0700684  0.121047
		0.0869455  0.0346159  0.0839538  0.0292841  0.0618886
		0.0926662  0.0318778  0.423375  0.0312398  0.0552447
		0.238399  0.136558  1.08223  0.146871  0.167578
		0.839978  0.850778  1.15471  0.909188  0.586401
		1.0286  1.0864  0.622851  1.12071  0.712334
		0.586144  0.497205  0.332119  0.472626  0.514048
		0.217853  0.146686  0.177105  0.124635  0.197312
		0.0951512  0.0463368  0.0953874  0.0370493  0.0758044
		0.0704157  0.0237067  0.137842  0.0209556  0.0450835
		0.104253  0.0381368  0.800617  0.0393274  0.0598066
		0.497454  0.426882  1.31057  0.463588  0.377076
		1.02232  1.07859  0.924387  1.13505  0.680283
		0.915997  0.908257  0.493186  0.913396  0.690545
		0.399931  0.309052  0.262961  0.27998  0.367801
		0.148628  0.0899018  0.140288  0.0733672  0.131251
		0.076562  0.0316435  0.0801703  0.0255583  0.0569182
		0.0718944  0.0227438  0.348356  0.0214219  0.0428589
		0.167121  0.0787389  1.0417  0.0841946  0.110116
		0.761831  0.75296  1.31883  0.809777  0.541511
		1.06827  1.13955  0.733095  1.18427  0.714417
		0.719652  0.647499  0.390923  0.629553  0.602568
		0.274002  0.195262  0.208442  0.169469  0.253267
		0.109195  0.0584649  0.111467  0.0466142  0.0917591
		];


inputs.exps.exp_data{2}=[
		0  0  0  0  0
		0.768102  0.364981  2.82482  0.284922  0.981687
		2.1275  1.38971  8.55811  1.09871  2.01047
		4.07313  6.48825  12.3337  3.49974  6.09426
		9.41235  4.73561  8.65913  8.03342  7.59641
		2.31614  2.8747  3.74961  3.23587  2.68504
		0.791278  0.968541  2.15947  1.54962  0.648432
		0.155085  0.247743  1.62139  0.698239  0.141113
		0.0483185  0.0677558  7.40889  0.989519  0.0410862
		2.42978  1.7596  11.1203  2.24553  2.94069
		4.91856  6.21871  10.3902  5.38877  5.90568
		6.4709  8.47808  7.36088  4.61201  6.78384
		4.60769  3.98651  3.1291  3.62939  4.90608
		2.01853  1.56903  2.58678  1.00587  3.03374
		0.509639  0.567814  1.14936  0.317958  0.756279
		0.136191  0.13304  0.867907  0.137483  0.1767
		0.0364502  0.0356757  4.20327  0.189391  0.0409152
		0.0104961  0.0112241  10.363  0.54775  0.0127209
		4.10965  5.23987  15.9726  3.06612  4.51168
		5.25345  6.31763  11.7436  6.42261  7.93309
		7.70516  7.53265  5.1661  5.91649  7.77121
		3.95229  2.39517  3.03755  1.64306  4.21653
		1.37559  1.08817  1.9614  0.840277  1.24876
		0.299341  0.291962  1.02274  0.194645  0.563854
		0.0903593  0.0841911  1.27119  0.123719  0.0967284
		0.0194312  0.0228707  5.75287  0.180165  0.0266587
		1.33929  1.10044  11.5671  1.0266  2.00534
		5.33105  4.67578  14.2674  3.50806  5.59059
		8.18476  7.9235  6.99028  6.96574  7.02732
		5.25486  4.9319  4.95278  4.71661  7.92999
		2.41082  1.62449  2.87308  1.66824  3.59732
		0.755336  0.720011  1.50517  0.390885  0.929582
		0.21723  0.23123  0.915709  0.182007  0.24385
		0.0515014  0.0467396  3.09758  0.108742  0.0643119
		0.0133877  0.0182848  8.81171  0.245042  0.0140353
		];


inputs.exps.error_data{2}=[
		0  0  0  0  0
		0.131278  0.0601675  0.334591  0.0652732  0.0817086
		0.324793  0.2464  0.982511  0.265604  0.197104
		0.837486  0.877778  1.15938  0.936148  0.555693
		1.03609  1.11975  0.696049  1.16062  0.695642
		0.378049  0.434649  0.40719  0.659567  0.250658
		0.103151  0.131283  0.238422  0.2746  0.0642727
		0.0281452  0.0396537  0.156805  0.160383  0.016481
		0.00767951  0.0119773  0.564444  0.177057  0.00422605
		0.328779  0.281053  1.12393  0.432055  0.274451
		0.869781  0.902427  1.19305  0.993189  0.614829
		1.00944  1.06467  0.70466  1.10814  0.708946
		0.703413  0.622314  0.412158  0.608647  0.600393
		0.295024  0.226118  0.241055  0.21189  0.274285
		0.0804951  0.0682964  0.141113  0.0732805  0.0703286
		0.0219622  0.020628  0.0918972  0.0350008  0.0180325
		0.0059924  0.00623056  0.446761  0.035123  0.00462383
		0.00163501  0.00188189  1.05095  0.116797  0.00118561
		0.681302  0.687319  1.41089  0.775257  0.490668
		1.06918  1.14171  1.0209  1.20552  0.696195
		1.00944  1.04222  0.597413  1.05969  0.719311
		0.56252  0.467261  0.349394  0.438999  0.506356
		0.173082  0.147434  0.204353  0.139959  0.153306
		0.0472233  0.0445303  0.120063  0.0483652  0.0393079
		0.0128845  0.0134499  0.127498  0.0257681  0.0100788
		0.00351554  0.00406245  0.716361  0.0335246  0.00258437
		0.231979  0.16712  1.21717  0.21756  0.194302
		0.859423  0.882494  1.38739  0.953899  0.593811
		1.09627  1.1745  0.833814  1.22366  0.720461
		0.879503  0.84837  0.48772  0.84422  0.682552
		0.379416  0.317172  0.285239  0.300114  0.340593
		0.103521  0.0957983  0.166869  0.0953895  0.0873307
		0.0282444  0.0289344  0.100831  0.036301  0.0223916
		0.00770658  0.00873952  0.304376  0.0252665  0.00574167
		0.00210276  0.00263974  0.948349  0.0540049  0.00147228
		];

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)


inputs.PEsol.id_global_theta=char('vPs','vCs','vBs','vRs','vRes','d_mP','d_mC','d_mB','d_mR','d_mRe');  %  'all'|User selected  
inputs.PEsol.global_theta_max=10*ones(1,10);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0*ones(1,10); % Minimum allowed values for the paramters

       
% inputs.PEsol.global_theta_guess=[   5.082824695230836
%    0.745885509439732
%    7.750612254239743
%    3.167859540291811
%    2.476253863567990
%    6.008054327045663
%    4.696372709251819
%    3.346472917415490
%    3.185933721977777]';
% inputs.PEsol.global_theta_max=2.*inputs.PEsol.global_theta_guess;  % Maximum allowed values for the paramters
% inputs.PEsol.global_theta_min=0*ones(1,9); % Minimum allowed values for the paramters






% GLOBAL INITIAL CONDITIONS
%inputs.PEsol.id_global_theta_y0='none';               % [] 'all'|User selected| 'none' (default)
% inputs.PEsol.global_theta_y0_max=[];                % Maximum allowed values for the initial conditions
% inputs.PEsol.global_theta_y0_min=[];                % Minimum allowed values for the initial conditions
% inputs.PEsol.global_theta_y0_guess=[];              % [] Initial guess

% LOCAL UNKNOWNS (DIFFERENT VALUES FOR DIFFERENT EXPERIMENTS)

%inputs.PEsol.id_local_theta{1}='none';                % [] 'all'|User selected| 'none' (default)
% inputs.PEsol.local_theta_max{iexp}=[];              % Maximum allowed values for the paramters
% inputs.PEsol.local_theta_min{iexp}=[];              % Minimum allowed values for the parameters
% inputs.PEsol.local_theta_guess{iexp}=[];            % [] Initial guess
%inputs.PEsol.id_local_theta_y0{1}='none';             % [] 'all'|User selected| 'none' (default)
% inputs.PEsol.local_theta_y0_max{iexp}=[];           % Maximum allowed values for the initial conditions
% inputs.PEsol.local_theta_y0_min{iexp}=[];           % Minimum allowed values for the initial conditions
% inputs.PEsol.local_theta_y0_guess{iexp}=[];         % [] Initial guess


%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.PEsol.PEcost_type='llk';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero' 



%==================================
% NUMERICAL METHODS
%==================================

%
% SIMULATION
%
 inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|


 inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)


 inputs.ivpsol.rtol=1.0D-7;                            % [] IVP solver integration tolerances
 inputs.ivpsol.atol=1.0D-7; 
 
%
% OPTIMIZATION
%
inputs.nlpsol.nlpsolver='eSS';                        % [] NLP solver: 
%                                                       % LOCAL: 'local_fmincon'|'local_n2fb'|'local_dn2fb'|'local_dhc'|
%                                                       %        'local_ipopt'|'local_solnp'|'local_nomad'||'local_nl2sol'
%                                                       %        'local_lsqnonlin'
%                                                       % MULTISTART:'multi_fmincon'|'multi_n2fb'|'multi_dn2fb'|'multi_dhc'|
%                                                       %            'multi_ipopt'|'multi_solnp'|'multi_nomad'|'multi_nl2sol'
%                                                       %            'multi_lsqnonlin'
%                                                       % GLOBAL: 'de'|'sres'
%                                                       % HYBRID: 'hyb_de_fmincon'|'hyb_de_n2fb'|'hyb_de_dn2fb'|'hyb_de_dhc'|'hyp_de_ipopt'|
%                                                       %         'hyb_de_solnp'|'hyb_de_nomad'|
%                                                       %         'hyb_sres_fmincon'|'hyb_sres_n2fb'|'hyb_sres_dn2fb'|'hyb_sres_dhc'|
%                                                       %         'hyp_sres_ipopt'|'hyb_sres_solnp'|'hyb_sres_nomad'
%                                                       % METAHEURISTICS:
%                                                       % 'ess' or 'eSS' (default)
%                                                       % Note that the corresponding defaults are in files: 
%                                                       % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
%                                                       % OPT_solvers\eSS_**\ess_options.m
%                                                       
                                                       
%inputs.nlpsol.eSS.log_var = 1:9;
inputs.nlpsol.eSS.maxeval = 100000;
inputs.nlpsol.eSS.maxtime = 96;

inputs.nlpsol.eSS.local.solver = 'nl2sol';
inputs.nlpsol.eSS.local.finish = 'nl2sol';

% inputs.nlpsol.multi_starts=500;                       % [] Number of different initial guesses to run local methods in the multistart approach
% inputs.nlpsol.multistart.maxeval = 100000;            % Maximum number of function evaluations for the multistart
% inputs.nlpsol.multistart.maxtime = 300;               % Maximum allowed time for the optimization
% 
% inputs.nlpsol.DE.NP = 9*10;                           % Initial population size (around 10*npar)
% inputs.nlpsol.DE.itermax = 2000;                      % Maximum number of iteratios in DE
% inputs.nlpsol.DE.F = 1; %0.75;  %1                    % F: DE-stepsize F ex [0, 2]
% inputs.nlpsol.DE.CR =0.85;                            %CR: crossover probabililty constant ex [0, 1]
% inputs.nlpsol.DE.strategy =2;                         % strategy       1 --> DE/best/1/exp                                            
%                                                       %                2 --> DE/rand/1/exp           
%                                                       %                3 --> DE/rand-to-best/1/exp   
%                                                       %                4 --> DE/best/2/exp          
%                                                       %                5 --> DE/rand/2/exp           
 

% 
% %==================================
% % RIdent or GRank DATA
% %==================================
% %
% 
% inputs.rid.conf_ntrials=500;                          % [] Number of trials for the robust confidence computation (default: 500)
% inputs.rank.gr_samples=10000;                         % [] Number of samples for global sensitivities and global rank within LHS (default: 10000)    
% 
% 
% %==================================
% % DISPLAY OF RESULTS
% %==================================
% 
% 
inputs.plotd.plotlevel='full';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 
%inputs.plotd.figsave=1;
% inputs.plotd.epssave=0;                              % [] Figures may be saved in .eps (1) or only in .fig format (0) (default)
% inputs.plotd.number_max_states=8;                    % [] Maximum number of states per figure
% inputs.plotd.number_max_obs=8;                       % [] Maximum number of observables per figure
% inputs.plotd.n_t_plot=100;                           % [] Number of times to be used for observables and states plots
% inputs.plotd.number_max_hist=8;                      % [] Maximum number of unknowns histograms per figure (multistart)
%inputs.plotd.nx_contour=100;                          % Number of points for plotting the contours x and y direction
%inputs.plotd.ny_contour=100;                          % ADVISE: >50
