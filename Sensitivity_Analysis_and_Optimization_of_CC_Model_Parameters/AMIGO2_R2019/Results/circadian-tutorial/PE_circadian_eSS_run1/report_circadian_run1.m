   ***********************************
   *    AMIGO2, Copyright @CSIC      *
   *    AMIGO2_R2019a [March 2019]    *
   *********************************** 

Date: 04-Nov-2020
Problem folder:	 Results\circadian-tutorial
Results folder in problem folder:	 Results\circadian-tutorial\PE_circadian_eSS_run1 


-------------------------------
Optimisation related active settings
-------------------------------


------> Global Optimizer: Enhanced SCATTER SEARCH for parameter estimation

		>Summary of selected eSS options: 
ess_options.
	dim_refset:	'auto'
	inter_save:	0
	iterprint:	1
	local:	(1x1 struct)
	log_var:	[]
	maxeval:	100000
	maxtime:	120
	ndiverse:	'auto'
nl2sol_settings.
	display:	2
	grad:	[]
	iterfun:	[]
	maxfeval:	300
	maxiter:	300
	objrtol:	1e-06
	tolafun:	1e-06
	tolrfun:	1e-06

		>Bounds on the unknowns:

		v_guess(1)=5.000000;  v_min(1)=0.000000; v_max(1)=10.000000;
		v_guess(2)=5.000000;  v_min(2)=0.000000; v_max(2)=10.000000;
		v_guess(3)=5.000000;  v_min(3)=0.000000; v_max(3)=10.000000;
		v_guess(4)=5.000000;  v_min(4)=0.000000; v_max(4)=10.000000;
		v_guess(5)=5.000000;  v_min(5)=0.000000; v_max(5)=10.000000;
		v_guess(6)=5.000000;  v_min(6)=0.000000; v_max(6)=10.000000;
		v_guess(7)=5.000000;  v_min(7)=0.000000; v_max(7)=10.000000;
		v_guess(8)=5.000000;  v_min(8)=0.000000; v_max(8)=10.000000;
		v_guess(9)=5.000000;  v_min(9)=0.000000; v_max(9)=10.000000;



-----------------------------------------------
 Initial value problem related active settings
-----------------------------------------------
ivpsolver: cvodes
RelTol: 1e-07
AbsTol: 1e-07
MaxStepSize: Inf
MaxNumberOfSteps: 1e+06


---------------------------------------------------
Local sensitivity problem related active settings
---------------------------------------------------
senssolver: cvodes
ivp_RelTol: 1e-07
ivp_AbsTol: 1e-07
sensmex: cvodesg_circadian
MaxStepSize: Inf
MaxNumberOfSteps: 1e+06


-------------------------------
   Model related information
-------------------------------

--> Number of states: 7


--> Number of model parameters: 27

--> Vector of parameters (nominal values):

	par0=[   7.50380     0.68010     1.49920     3.04120    10.09820     1.96850     3.75110     2.34220     7.24820     1.89810     1.20000     3.80450     5.30870     4.19460     2.53560     1.44200     4.86000     1.20000     2.19940     9.44400     0.50000     0.28170     0.76760     0.43640     7.30210     4.57030     1.00000  ]


-------------------------------------------
  Experimental scheme related information
-------------------------------------------


-->Number of experiments: 2


-->Initial conditions for each experiment:
		Experiment 1: 
			exp_y0=[0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  ]
		Experiment 2: 
			exp_y0=[0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  ]

-->Final process time for each experiment: 
		Experiment 1: 	 120.000000

-->Final process time for each experiment: 
		Experiment 2: 	 120.000000


-->Sampling times for each experiment: 
		Experiment 1: 	 		Experiment 110: 	 		Experiment 95: 	 		Experiment 115: 	 		Experiment 58: 	 		Experiment 32: 	 		Experiment 37: 	 		Experiment 105: 	 		Experiment 32: 	 		Experiment 92: 	 		Experiment 116: 	 		Experiment 15: 	 0.000e+00  8.571e+00  1.714e+01  2.571e+01  3.429e+01  4.286e+01  5.143e+01  6.000e+01  6.857e+01  7.714e+01  8.571e+01  9.429e+01  1.029e+02  1.114e+02  1.200e+02  

-->Sampling times for each experiment: 
		Experiment 2: 	 		Experiment 110: 	 		Experiment 95: 	 		Experiment 115: 	 		Experiment 58: 	 		Experiment 32: 	 		Experiment 37: 	 		Experiment 105: 	 		Experiment 32: 	 		Experiment 92: 	 		Experiment 116: 	 		Experiment 25: 	 0.000e+00  5.000e+00  1.000e+01  1.500e+01  2.000e+01  2.500e+01  3.000e+01  3.500e+01  4.000e+01  4.500e+01  5.000e+01  5.500e+01  6.000e+01  6.500e+01  7.000e+01  7.500e+01  8.000e+01  8.500e+01  9.000e+01  9.500e+01  1.000e+02  1.050e+02  1.100e+02  1.150e+02  1.200e+02  

-->Number of manipulable (control, stimulus, input) variables: 1


-->Input values/temporal elements for Experiment 1:
		sustained interpolation is being used.
			Control values:
			Input 1:	  1.0000


-->Input values/temporal elements for Experiment 2:
		pulse-down interpolation is being used.
			Control values:
 			Input 1:	  1.0000	  0.0000	  1.0000	  0.0000	  1.0000	  0.0000	  1.0000	  0.0000	  1.0000	  0.0000	
			Control switching times: 	  0.0000	 12.0000	 24.0000	 36.0000	 48.0000	 60.0000	 72.0000	 84.0000	 96.0000	108.0000	120.0000


-->Number of observables:
	Experiment 1: 2
	Experiment 2: 2

-->Observables:
		Experiment 1:
			Lum=CL_m  
			mRNAa=CT_m
		Experiment 2:
			Lum=CL_m  
			mRNAa=CT_m

-->Number of sampling times for each experiment:
		Experiment 1: 	 15
		Experiment 2: 	 25

-->Sampling times for each experiment:
		Experiment 1, 
			t_s=[   0.000     8.571    17.143    25.714    34.286    42.857    51.429    60.000    68.571    77.143    85.714    94.286   102.857   111.429   120.000  ]
		Experiment 2, 
			t_s=[   0.000     5.000    10.000    15.000    20.000    25.000    30.000    35.000    40.000    45.000    50.000    55.000    60.000    65.000    70.000    75.000    80.000    85.000    90.000    95.000   100.000   105.000   110.000   115.000   120.000  ]


--------------------------------------------------------------------------

-->Experimental data for each experiment:
		
Experiment 1: 
		inputs.exp_data{1}=[
		0.037642  0.059832
		1.39862  0.983442
		1.60676  0.433379
		0.265345  0.628819
		1.41729  0.858973
		1.38161  0.496637
		0.504584  0.717923
		1.24025  0.862584
		1.18019  0.634508
		0.775945  0.679648
		1.51451  0.735783
		0.904653  0.593644
		0.753736  0.759013
		1.38931  0.678665
		0.833228  0.574736
		];

		
Experiment 2: 
		inputs.exp_data{2}=[
		0.146016  0.018152
		0.831813  1.0025
		1.87487  0.816779
		1.92758  0.544111
		1.13954  0.354476
		0.876938  0.520424
		0.5596  0.802322
		1.27355  0.939453
		1.69648  0.687495
		1.0655  0.577896
		0.84746  0.524076
		0.51752  0.738095
		1.16223  0.826737
		1.4215  0.779833
		1.34064  0.550493
		0.563822  0.515605
		0.402755  0.714877
		1.02986  0.871118
		1.49074  0.840174
		1.58087  0.692047
		0.69661  0.459481
		0.141546  0.646803
		0.804194  0.925806
		1.62238  0.824711
		1.52519  0.537398
		];


-->Noise type:homo_var

		Error data 1: 
		inputs.exps.error_data{1}=[
		0.037642  0.059832
		0.072461  0.013999
		0.002877  0.020809
		0.050324  0.002705
		0.042936  0.017832
		0.044338  0.022538
		0.016335  0.017981
		0.164745  0.035301
		0.010631  0.102381
		0.127745  0.065791
		0.081671  0.049568
		0.126739  0.050306
		0.006308  0.018894
		0.054665  0.066953
		0.082163  0.015295
		];


		Error data 2: 
		inputs.exps.error_data{2}=[
		0.146016  0.018152
		0.066547  0.045194
		0.184009  0.101495
		0.047431  0.030858
		0.17528  0.033712
		0.031945  0.048733
		0.107148  0.008715
		0.019847  0.072804
		0.111892  0.00184
		0.104932  0.058752
		0.059721  0.033324
		0.056537  0.00036
		0.051815  0.037473
		0.103393  0.028094
		0.008084  0.012024
		0.188444  0.022982
		0.046354  0.031981
		0.043436  0.003749
		0.030177  0.04256
		0.116245  0.110535
		0.059345  0.025112
		0.218587  0.000564
		0.115783  0.043708
		0.099239  0.002678
		0.010644  0.05299
		];



-------------------------------------------------------------------------------------------
>>>>    Mean / Maximum value of the residuals in percentage (100*(data-model)/data):

		Experiment 1 : 
		 Observable 1 --> mean error: 13.239279 %	 max error: 100.000000 %
		 Observable 2 --> mean error: 11.709972 %	 max error: 100.000000 %

		Experiment 2 : 
		 Observable 1 --> mean error: 18.360883 %	 max error: 157.541058 %
		 Observable 2 --> mean error: 8.986187 %	 max error: 100.000000 %

--------------------------------------------------------------------------

--------------------------------------------------------------------
>>>>  Maximum absolute value of the residuals (data-model):

		Experiment 1 : 
		 Observable 1 -->  max residual: 0.160768 max data: 1.606762
		 Observable 2 -->  max residual: 0.104116 max data: 0.983442

		Experiment 2 : 
		 Observable 1 -->  max residual: 0.225575 max data: 1.927580
		 Observable 2 -->  max residual: 0.109901 max data: 1.002499

--------------------------------------------------------------------------	   

>>>> Best objective function: 72.728846 
	   

>>>> Computational cost: 120.953125 s
> 99.92% of successful simulationn
> 100.00% of successful sensitivity calculations


>>> Best values found and the corresponding asymptotic confidence intervals



>>> Estimated global parameters: 

	n1 : 6.1199e+00  +-  1.6289e+00 (    26.6%); 
	n2 : 7.1008e-01  +-  4.0158e-02 (    5.66%); 
	m1 : 9.0049e+00  +-  1.4531e+00 (    16.1%); 
	m4 : 2.3766e+00  +-  1.9123e-01 (    8.05%); 
	m6 : 2.1066e+00  +-  4.4918e-01 (    21.3%); 
	m7 : 1.2695e+00  +-  8.3288e-01 (    65.6%); 
	k1 : 4.3476e+00  +-  1.0347e+00 (    23.8%); 
	k4 : 2.4427e+00  +-  3.0544e-01 (    12.5%); 
	p3 : 4.8029e-01  +-  3.6423e-01 (    75.8%); 


>>> Correlation matrix for the global unknowns:

	 1.000000e+00	 -9.274421e-01	 8.109416e-01	 -3.053153e-02	 -9.215647e-01	 -4.580725e-01	 -8.553736e-01	 5.285590e-01	 -3.060022e-01
	 -9.274421e-01	 1.000000e+00	 -6.540869e-01	 7.964559e-02	 7.615722e-01	 4.803356e-01	 8.676101e-01	 -5.194087e-01	 3.436168e-01
	 8.109416e-01	 -6.540869e-01	 1.000000e+00	 -2.814614e-01	 -7.179403e-01	 -6.474631e-01	 -3.916428e-01	 1.846752e-01	 -5.409894e-01
	 -3.053153e-02	 7.964559e-02	 -2.814614e-01	 1.000000e+00	 -5.625655e-02	 4.120906e-01	 -1.984384e-01	 8.077063e-01	 4.218696e-01
	 -9.215647e-01	 7.615722e-01	 -7.179403e-01	 -5.625655e-02	 1.000000e+00	 2.976489e-01	 8.266090e-01	 -4.958285e-01	 1.495060e-01
	 -4.580725e-01	 4.803356e-01	 -6.474631e-01	 4.120906e-01	 2.976489e-01	 1.000000e+00	 1.344775e-01	 4.389306e-02	 9.862032e-01
	 -8.553736e-01	 8.676101e-01	 -3.916428e-01	 -1.984384e-01	 8.266090e-01	 1.344775e-01	 1.000000e+00	 -6.577913e-01	 -1.141731e-02
	 5.285590e-01	 -5.194087e-01	 1.846752e-01	 8.077063e-01	 -4.958285e-01	 4.389306e-02	 -6.577913e-01	 1.000000e+00	 1.326088e-01
	 -3.060022e-01	 3.436168e-01	 -5.409894e-01	 4.218696e-01	 1.495060e-01	 9.862032e-01	 -1.141731e-02	 1.326088e-01	 1.000000e+00
