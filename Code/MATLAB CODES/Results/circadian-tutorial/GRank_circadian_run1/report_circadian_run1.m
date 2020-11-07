   ***********************************
   *    AMIGO2, Copyright @CSIC      *
   *    AMIGO2_R2019a [March 2019]    *
   *********************************** 

Date: 06-Nov-2020
Problem folder:	 Results\circadian-tutorial
Results folder in problem folder:	 Results\circadian-tutorial\GRank_circadian_run1 


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


------> GLOBAL RANKING



------>ABSOLUTE Ranking of GLOBAL unknown PARAMETERS:

			d_msqr		 d_mabs		 d_mean			d_max		  d_min
____________________________________________________________________________________________
	vPs      2.1463e-01   1.1101e+00  -1.0487e-01    7.1855e+00   -6.1003e+00 
	vCs      1.8927e-01   9.6752e-01  -8.6177e-02    6.3585e+00   -5.4094e+00 
	vBs      1.8474e-01   1.1734e+00   6.0529e-01    6.6940e+00   -4.4356e+00 
	vRs      1.4776e-01   6.6195e-01   4.1401e-01    6.2650e+00   -2.9010e+00 
	vRes     1.4735e-01   9.5879e-01  -4.9709e-01    2.3680e+00   -4.1038e+00 
____________________________________________________________________________________________


------>RELATIVE Ranking of GLOBAL unknown PARAMETERS: 

			rd_msqr		rd_mabs		rd_mean			rd_max		rd_min
____________________________________________________________________________________________
	vBs      1.5034e-01   1.1896e+00   5.1213e-01    6.8272e+00   -4.5746e+00 
	vPs      1.4318e-01   1.0437e+00  -9.3584e-02    7.2839e+00   -6.2452e+00 
	vRes     1.2785e-01   1.0271e+00  -4.0492e-01    2.7233e+00   -4.8293e+00 
	vCs      1.1606e-01   8.5553e-01  -1.5155e-01    6.4534e+00   -5.6176e+00 
	vRs      9.9047e-02   5.8990e-01   4.7575e-01    6.4021e+00   -2.9593e+00 
____________________________________________________________________________________________
> 100.00% of successful simulationn
> 100.00% of successful sensitivity calculations
