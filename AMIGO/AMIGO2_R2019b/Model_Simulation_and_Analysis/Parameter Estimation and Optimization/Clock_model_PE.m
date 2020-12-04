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
 inputs.exps.n_s{2}=30;                                %    Optative input. By default "continuous" measurements are assumed.
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
		0.82231  0.413105  5.07493  0.413468  0.842461
		3.29587  2.96511  10.8651  2.02008  2.97063
		8.15277  6.33911  9.88859  5.08562  7.25007
		5.43922  5.9272  5.2438  4.42933  6.23027
		2.59863  1.8222  2.34384  1.34865  2.60735
		0.8506  0.452523  1.47693  0.385878  1.31139
		0.580082  0.209608  0.807127  0.128015  0.606643
		0.686751  0.280627  4.22281  0.170356  0.520436
		1.5638  0.906635  8.35251  0.629364  1.90882
		4.95327  6.53399  12.2346  3.4586  5.63402
		6.2111  5.78028  6.19397  8.0376  6.2361
		3.98818  3.89997  3.80406  2.48622  5.64804
		1.58618  1.17468  1.75728  0.78561  1.62978
		0.6202  0.303868  0.974426  0.2097  0.709678
		0.501368  0.227499  1.3875  0.105605  0.507349
		0.73465  0.226014  7.05325  0.219798  0.57476
		4.10578  2.29622  11.0541  2.57355  3.36611
		8.06778  7.83872  9.34943  4.87873  7.12885
		7.32116  6.16966  4.67409  3.85997  6.49855
		2.72589  1.77189  2.78912  1.27785  2.80053
		0.77578  0.590048  1.55429  0.302175  1.18676
		0.49639  0.213088  0.88608  0.134144  0.641147
		0.378217  0.121714  2.76718  0.123171  0.400308
		1.19532  0.696538  9.71654  0.362543  1.21317
		4.88751  4.53448  13.7743  4.59582  5.44914
		5.27133  7.12391  9.41774  5.656  7.23341
		5.0078  3.88985  4.44112  2.37765  5.24676
		1.87555  1.42697  1.86666  0.734852  2.32452
		0.918435  0.414345  1.2913  0.20391  0.846605
		];


    % Experimental noise, n_s{iexp}x n_obs{iexp}
inputs.exps.error_data{1}=[
		0  0  0  0  0
		0.153235  0.0755482  0.467688  0.0604266  0.0927794
		0.485079  0.444442  1.13485  0.35514  0.318168
		1.00208  1.07676  0.900567  0.83799  0.656694
		0.854214  0.848121  0.48092  0.627947  0.649458
		0.361948  0.280971  0.256436  0.187153  0.31827
		0.145056  0.0852155  0.136909  0.0518649  0.121047
		0.0869455  0.0346159  0.0839538  0.0216762  0.0618886
		0.0926662  0.0318778  0.423375  0.0231238  0.0552447
		0.238399  0.136558  1.08223  0.108715  0.167578
		0.839978  0.850778  1.15471  0.672984  0.586401
		1.0286  1.0864  0.622851  0.829556  0.712334
		0.586144  0.497205  0.332119  0.349839  0.514048
		0.217853  0.146686  0.177105  0.0922553  0.197312
		0.0951512  0.0463368  0.0953874  0.027424  0.0758044
		0.0704157  0.0237067  0.137842  0.0155114  0.0450835
		0.104253  0.0381368  0.800617  0.0291103  0.0598066
		0.497454  0.426882  1.31057  0.343149  0.377076
		1.02232  1.07859  0.924387  0.840171  0.680283
		0.915997  0.908257  0.493186  0.676099  0.690545
		0.399931  0.309052  0.262961  0.207242  0.367801
		0.148628  0.0899018  0.140288  0.0543067  0.131251
		0.076562  0.0316435  0.0801703  0.0189184  0.0569182
		0.0718944  0.0227438  0.348356  0.0158566  0.0428589
		0.167121  0.0787389  1.0417  0.0623212  0.110116
		0.761831  0.75296  1.31883  0.5994  0.541511
		1.06827  1.13955  0.733095  0.876604  0.714417
		0.719652  0.647499  0.390923  0.465997  0.602568
		0.274002  0.195262  0.208442  0.125441  0.253267
		0.109195  0.0584649  0.111467  0.034504  0.0917591
		];

inputs.exps.exp_data{2}=[
		0  0  0  0  0
		1.05512  0.449904  5.43552  0.368136  0.736371
		3.31524  2.38016  11.2017  2.34528  2.69083
		7.08094  6.36332  6.41159  5.58235  6.98778
		3.45635  3.94469  4.7601  3.77712  3.7059
		0.748189  1.15148  2.33958  1.40494  0.791482
		0.172809  0.232281  1.96948  0.841745  0.177332
		0.0448973  0.0738063  6.79852  0.783095  0.0347396
		3.44438  4.6428  12.63  2.67686  4.34067
		7.13511  7.07879  9.67033  5.13295  6.43764
		5.40433  5.18175  4.93783  3.79444  7.27907
		1.99442  2.03148  2.43731  1.04222  2.96774
		0.577952  0.43081  1.37324  0.349363  0.70602
		0.114808  0.0809408  0.997944  0.152168  0.119419
		0.018487  0.0236151  8.08409  0.261227  0.0258035
		2.51778  2.44606  12.1305  2.54605  3.30207
		7.60467  5.9878  12.6946  5.89157  6.30522
		5.7598  5.40345  6.62018  4.87457  7.51567
		3.81634  3.61233  3.4926  1.8023  4.87647
		0.697  0.672087  1.71637  0.54894  0.88689
		0.187572  0.221946  1.00676  0.233012  0.227175
		0.0374597  0.0532848  4.30376  0.130977  0.043711
		0.862545  0.374953  10.0762  0.615925  1.20546
		5.90046  4.93326  14.2811  4.96803  5.70404
		8.52826  9.10016  7.15486  6.5152  6.16584
		4.21123  2.88272  4.62049  3.31964  5.65892
		1.31731  1.27472  2.34773  0.849769  2.07838
		0.211703  0.3153  1.03977  0.219068  0.398988
		0.0639558  0.0893193  2.23107  0.132867  0.0781341
		0.0145832  0.0132478  7.16985  0.251452  0.0143254
		];

inputs.exps.error_data{2}=[
		0  0  0  0  0
		0.153235  0.0755482  0.467688  0.0604266  0.0927794
		0.485079  0.444442  1.13485  0.35514  0.318168
		1.00208  1.07676  0.900567  0.83799  0.656694
		0.565726  0.630225  0.480923  0.630529  0.382394
		0.123388  0.154854  0.256605  0.227162  0.0775443
		0.0269125  0.03805  0.157265  0.117804  0.0157254
		0.00586988  0.00934945  0.702031  0.146035  0.00318896
		0.566543  0.541547  1.26871  0.490152  0.440704
		1.00174  1.06394  0.8958  0.836379  0.68795
		0.819945  0.773873  0.477888  0.572304  0.657983
		0.33745  0.25593  0.254808  0.175839  0.315751
		0.073598  0.0628839  0.136032  0.0507747  0.0640277
		0.0160516  0.015451  0.102099  0.0239371  0.0129833
		0.00350097  0.0037965  0.729407  0.0348375  0.00263285
		0.38494  0.348633  1.28672  0.322763  0.304763
		1.01838  1.07919  1.16011  0.851888  0.6687
		1.02973  1.07384  0.619925  0.811033  0.723178
		0.517627  0.420807  0.330534  0.289729  0.472709
		0.12096  0.105966  0.176268  0.0758367  0.105318
		0.0263807  0.0260362  0.0981614  0.0248348  0.0213556
		0.00575376  0.00639738  0.456614  0.0196893  0.0043306
		0.122924  0.0764343  1.13411  0.0950762  0.102371
		0.843211  0.863248  1.4029  0.691923  0.585521
		1.0962  1.1746  0.774395  0.902052  0.725893
		0.731019  0.655899  0.412925  0.471198  0.614605
		0.202675  0.177948  0.220169  0.127104  0.176561
		0.0442015  0.0437218  0.118069  0.0359492  0.0358008
		0.00964085  0.0107431  0.206393  0.0186792  0.00726012
		0.00210276  0.00263974  0.948349  0.0399746  0.00147228
		];

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)


inputs.PEsol.id_global_theta=char('vPs','vCs','vBs','vRs','vRes');  %  'all'|User selected  
inputs.PEsol.global_theta_max=10*ones(1,5);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0*ones(1,5); % Minimum allowed values for the paramters

       
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
