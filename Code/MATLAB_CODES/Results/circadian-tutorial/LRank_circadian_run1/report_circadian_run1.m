   ***********************************
   *    AMIGO2, Copyright @CSIC      *
   *    AMIGO2_R2019a [March 2019]    *
   *********************************** 

Date: 06-Nov-2020
Problem folder:	 Results\circadian-tutorial
Results folder in problem folder:	 Results\circadian-tutorial\LRank_circadian_run1 


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

--> Number of states: 23


--> Number of model parameters: 70

--> Vector of parameters (nominal values):

	par0=[   5.00000     6.00000     8.00000     7.00000     8.00000     8.00000     8.00000     7.00000     8.00000     6.00000     3.90000     0.25000     0.46000     3.87000     0.26200     0.42400     3.63000     0.13000     0.19000     3.24000     0.27000     0.47200     3.71000     0.25000     0.48200     0.40800     0.36200     0.30000     0.30400     0.39000     0.23000     0.39000     0.36500     0.30600     0.18000     0.47000     0.34200     0.29800     0.38500     0.07000     0.40200     0.39400     0.36100     0.16600     0.05000     0.41900     0.37400     0.36110     0.33630     0.06000     0.37500     0.24412     0.36230     0.01700     0.02300     0.01900     0.01300     0.02000     0.23000     0.02500     0.37000     0.09000     0.34820     0.07040     0.34900     0.06080     0.39000     0.30000     0.15000     0.46000  ]


-------------------------------------------
  Experimental scheme related information
-------------------------------------------


-->Number of experiments: 2


-->Initial conditions for each experiment:
		Experiment 1: 
			exp_y0=[0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  2.015e+00  2.215e+00  2.015e+00  2.035e+00  1.904e+00  2.035e+00  ]
		Experiment 2: 
			exp_y0=[0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  0.000e+00  2.015e+00  2.215e+00  2.015e+00  2.035e+00  1.904e+00  2.035e+00  ]

-->Final process time for each experiment: 
		Experiment 1: 	 96.000000

-->Final process time for each experiment: 
		Experiment 2: 	 96.000000


-->Sampling times for each experiment: 
		Experiment 1: 	 		Experiment 110: 	 		Experiment 95: 	 		Experiment 115: 	 		Experiment 58: 	 		Experiment 32: 	 		Experiment 37: 	 		Experiment 105: 	 		Experiment 32: 	 		Experiment 92: 	 		Experiment 116: 	 		Experiment 15: 	 0.000e+00  6.857e+00  1.371e+01  2.057e+01  2.743e+01  3.429e+01  4.114e+01  4.800e+01  5.486e+01  6.171e+01  6.857e+01  7.543e+01  8.229e+01  8.914e+01  9.600e+01  

-->Sampling times for each experiment: 
		Experiment 2: 	 		Experiment 110: 	 		Experiment 95: 	 		Experiment 115: 	 		Experiment 58: 	 		Experiment 32: 	 		Experiment 37: 	 		Experiment 105: 	 		Experiment 32: 	 		Experiment 92: 	 		Experiment 116: 	 		Experiment 25: 	 0.000e+00  4.000e+00  8.000e+00  1.200e+01  1.600e+01  2.000e+01  2.400e+01  2.800e+01  3.200e+01  3.600e+01  4.000e+01  4.400e+01  4.800e+01  5.200e+01  5.600e+01  6.000e+01  6.400e+01  6.800e+01  7.200e+01  7.600e+01  8.000e+01  8.400e+01  8.800e+01  9.200e+01  9.600e+01  

-->Number of manipulable (control, stimulus, input) variables: 1


-->Input values/temporal elements for Experiment 1:
		sustained interpolation is being used.
			Control values:
			Input 1:	  1.0000


-->Input values/temporal elements for Experiment 2:
		pulse-down interpolation is being used.
			Control values:
 			Input 1:	  1.0000	  0.0000	  1.0000	  0.0000	  1.0000	  0.0000	  1.0000	  0.0000	
			Control switching times: 	  0.0000	 12.0000	 24.0000	 36.0000	 48.0000	 60.0000	 72.0000	 84.0000	 96.0000


-->Number of observables:
	Experiment 1: 5
	Experiment 2: 5

-->Observables:
		Experiment 1:
			Per_mRNA=Per_mRNA        
			Cry_mRNA=Cry_mRNA        
			Bmal1_mRNA=Bmal1_mRNA    
			Ror_mRNA=Ror_mRNA        
			Rev_erb_mRNA=Rev_erb_mRNA
		Experiment 2:
			Per_mRNA=Per_mRNA        
			Cry_mRNA=Cry_mRNA        
			Bmal1_mRNA=Bmal1_mRNA    
			Ror_mRNA=Ror_mRNA        
			Rev_erb_mRNA=Rev_erb_mRNA


------> RANKING for experiment: 1



------>ABSOLUTE Ranking of model unknowns:

			par value		d_msqr		 d_mabs		 d_mean			d_max		  d_min
____________________________________________________________________________________________
	d_mP     7.2502e-02   7.2834e+00   3.3090e+01  -2.2840e+01    6.1650e+01   -2.0957e+02 
	d_mB     1.8186e-01   3.2880e+00   1.7824e+01   1.8086e+00    1.2818e+02   -3.9855e+01 
	d_mC     4.1153e-01   2.7285e+00   1.4988e+01  -1.4119e+00    4.6890e+01   -7.6182e+01 
	d_mRe    3.8574e-01   2.1973e+00   1.0927e+01   2.5734e+00    7.0831e+01   -4.3215e+01 
	d_mR     2.2910e-01   5.6496e-01   1.8808e+00  -1.8806e+00    1.8665e-03   -2.2177e+01 
____________________________________________________________________________________________


------>RELATIVE Ranking of model unknowns:

			par value		rd_msqr		rd_mabs		rd_mean			rd_max		rd_min
____________________________________________________________________________________________
____________________________________________________________________________________________
	d_mC     4.1153e-01   3.5737e-01   2.0825e+00   2.1551e-01    4.6890e+01   -7.6182e+01 
	d_mRe    3.8574e-01   2.7761e-01   1.4975e+00   1.0459e-01    7.0831e+01   -4.3215e+01 
	d_mB     1.8186e-01   1.7042e-01   1.1253e+00  -3.8979e-01    1.2818e+02   -3.9855e+01 
	d_mR     2.2910e-01   7.7102e-02   2.5932e-01  -2.5930e-01    1.8665e-03   -2.2177e+01 
	d_mP     7.2502e-02   7.0412e-02   4.4000e-01  -1.8127e-01    6.1650e+01   -2.0957e+02 
____________________________________________________________________________________________


------> RANKING for experiment: 2



------>ABSOLUTE Ranking of model unknowns:

			par value		d_msqr		 d_mabs		 d_mean			d_max		  d_min
____________________________________________________________________________________________
	d_mP     7.2502e-02   5.1963e+00   2.8829e+01  -2.2530e+01    3.1955e+01   -1.6226e+02 
	d_mB     1.8186e-01   1.3022e+00   9.4018e+00  -7.1975e+00    2.2057e+01   -5.5734e+01 
	d_mRe    3.8574e-01   1.1747e+00   7.6450e+00   4.0306e+00    5.2537e+01   -2.4056e+01 
	d_mC     4.1153e-01   1.0476e+00   7.2516e+00   2.6912e-01    4.1708e+01   -3.0748e+01 
	d_mR     2.2910e-01   5.4517e-01   2.4326e+00  -2.4326e+00    6.1728e-04   -2.1856e+01 
____________________________________________________________________________________________


------>RELATIVE Ranking of model unknowns:

			par value		rd_msqr		rd_mabs		rd_mean			rd_max		rd_min
____________________________________________________________________________________________
____________________________________________________________________________________________
	d_mC     4.1153e-01   2.0864e-01   1.3733e+00  -3.3370e-01    4.1708e+01   -3.0748e+01 
	d_mRe    3.8574e-01   1.6836e-01   1.1180e+00  -2.1387e-01    5.2537e+01   -2.4056e+01 
	d_mB     1.8186e-01   8.7043e-02   5.9397e-01  -4.6228e-01    2.2057e+01   -5.5734e+01 
	d_mR     2.2910e-01   5.6239e-02   2.4446e-01  -2.4446e-01    6.1728e-04   -2.1856e+01 
	d_mP     7.2502e-02   4.4882e-02   3.1066e-01  -1.5279e-01    3.1955e+01   -1.6226e+02 
____________________________________________________________________________________________


------> OVERALL RANKING



------>ABSOLUTE Ranking of GLOBAL model unknowns:

			par value		d_msqr		 d_mabs		 d_mean			d_max		  d_min
____________________________________________________________________________________________
____________________________________________________________________________________________
	d_mP     7.2502e-02   6.2399e+00   3.0959e+01  -2.2685e+01    6.1650e+01   -2.0957e+02 
	d_mB     1.8186e-01   2.2951e+00   1.3613e+01  -2.6944e+00    1.2818e+02   -5.5734e+01 
	d_mC     4.1153e-01   1.8880e+00   1.1120e+01  -5.7139e-01    4.6890e+01   -7.6182e+01 
	d_mRe    3.8574e-01   1.6860e+00   9.2858e+00   3.3020e+00    7.0831e+01   -4.3215e+01 
	d_mR     2.2910e-01   5.5506e-01   2.1567e+00  -2.1566e+00    1.8665e-03   -2.2177e+01 
____________________________________________________________________________________________


------>RELATIVE Ranking of GLOBAL model unknowns:

			par value		rd_msqr		rd_mabs		rd_mean			rd_max		rd_min
____________________________________________________________________________________________
	d_mC     4.1153e-01   2.8301e-01   1.7279e+00  -5.9092e-02    4.6890e+01   -7.6182e+01 
	d_mRe    3.8574e-01   2.2299e-01   1.3077e+00  -5.4639e-02    7.0831e+01   -4.3215e+01 
	d_mB     1.8186e-01   1.2873e-01   8.5963e-01  -4.2604e-01    1.2818e+02   -5.5734e+01 
	d_mR     2.2910e-01   6.6671e-02   2.5189e-01  -2.5188e-01    1.8665e-03   -2.2177e+01 
	d_mP     7.2502e-02   5.7647e-02   3.7533e-01  -1.6703e-01    6.1650e+01   -2.0957e+02 
____________________________________________________________________________________________
> 100.00% of successful simulationn
> 100.00% of successful sensitivity calculations
