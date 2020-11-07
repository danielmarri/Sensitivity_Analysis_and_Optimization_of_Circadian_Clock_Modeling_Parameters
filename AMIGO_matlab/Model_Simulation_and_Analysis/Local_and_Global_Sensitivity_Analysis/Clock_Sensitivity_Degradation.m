%%$Header: svn://.../trunk/AMIGO2R2016/Examples/Arabidopsis_circadian/circadian_pe.m 2410 2015-12-07 13:58:57Z evabalsa $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE:The mammalian circadian clock model. 
%
%
%        Type :
%                >  

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
                  0.375 0.24412 0.3623 0.017 0.023 0.019 0.013 0.02 0.23 0.025 0.37 0.09 0.3482 0.0704 0.349 0.0608 0.39 0.30 0.15 0.46];
             % Nominal value for the parameters, this allows to fix known parameters
             % These values may be updated during optimization  
                                                                      

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
                                 % Values of the inputs 
 
 inputs.exps.u_interp{2}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{2}=4;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u_min{2}=0;inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{2}=[0 :12: 96];                    %Times of switching: Initial time, Intermediate times, Final time
                           
%==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================                                                            
 inputs.exps.n_s{1}=15;                                % [] Number of sampling times for each experiment.
 inputs.exps.n_s{2}=25;                                %    Optative input. By default "continuous" measurements are assumed.
% inputs.exps.t_s{1}=[1 2 3 ...];                      % [] Sampling times for each experiment, by default equidistant
% inputs.exps.t_s{2}=[0 5 7 ...];                      % [] Sampling times for each experiment, by default equidistant


%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.PEsol.id_global_theta=char('d_mP','d_mC','d_mB','d_mR','d_mRe');  %  'all'|User selected  
inputs.PEsol.global_theta_max=10*ones(1,5);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0*ones(1,5); % Minimum allowed values for the paramters
inputs.PESol.global_theta_guess= rand(1,5).*inputs.model.par([13 16 19 22 25]);  % Value of the parameters for which the analysis will be performed    

 %==================================
 % SIMULATION
 inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|


 inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)


 inputs.ivpsol.rtol=1.0D-7;                            % [] IVP solver integration tolerances
 inputs.ivpsol.atol=1.0D-7; 


 
%==================================
% GRank DATA
%==================================
 
 inputs.rank.gr_samples=100000;                         % [] Number of samples for global sensitivities and global rank within LHS (default: 10000)    
 
 
%==================================
% DISPLAY OF RESULTS
%==================================
% 
% 
inputs.plotd.plotlevel='full';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 
% inputs.plotd.figsave=1;
% inputs.plotd.epssave=0;                              % [] Figures may be saved in .eps (1) or only in .fig format (0) (default)
% inputs.plotd.number_max_states=8;                    % [] Maximum number of states per figure
% inputs.plotd.number_max_obs=8;                       % [] Maximum number of observables per figure
% inputs.plotd.n_t_plot=100;                           % [] Number of times to be used for observables and states plots
% inputs.plotd.number_max_hist=8;                      % [] Maximum number of unknowns histograms per figure (multistart)
% inputs.plotd.nx_contour=100;                          % Number of points for plotting the contours x and y direction
% inputs.plotd.ny_contour=100;                          % ADVISE: >50
