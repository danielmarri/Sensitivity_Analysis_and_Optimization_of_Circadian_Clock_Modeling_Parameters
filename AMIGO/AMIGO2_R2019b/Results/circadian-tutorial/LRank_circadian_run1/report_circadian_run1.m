   ***********************************
   *    AMIGO2, Copyright @CSIC      *
   *    AMIGO2_R2019a [March 2019]    *
   *********************************** 

Date: 04-Dec-2020
Problem folder:	 Results/circadian-tutorial
Results folder in problem folder:	 Results/circadian-tutorial/LRank_circadian_run1 


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
	vBs      4.6096e-01   2.8358e-01   1.9617e+00   7.4901e-01    5.3848e+00   -3.6211e+00 
	vRes     2.3461e+00   5.8457e-02   3.8868e-01  -1.1939e-01    8.9185e-01   -1.1362e+00 
	vPs      3.1774e+00   4.1106e-02   2.7174e-01   3.1361e-02    8.9891e-01   -7.3814e-01 
	vCs      3.5054e+00   2.9853e-02   1.9878e-01  -3.2519e-04    5.8170e-01   -5.6594e-01 
	vRs      2.9593e+00   2.0460e-02   7.3155e-02   7.3103e-02    6.2993e-01   -2.1724e-04 
____________________________________________________________________________________________


------>RELATIVE Ranking of model unknowns:

			par value		rd_msqr		rd_mabs		rd_mean			rd_max		rd_min
____________________________________________________________________________________________
____________________________________________________________________________________________
	vRes     2.3461e+00   1.0256e-01   6.8185e-01  -2.1911e-01    1.4898e+00   -1.8424e+00 
	vBs      4.6096e-01   9.1678e-02   6.3609e-01   1.6763e-01    5.3848e+00   -3.6211e+00 
	vPs      3.1774e+00   9.0958e-02   6.1767e-01   4.8993e-02    1.6836e+00   -1.4714e+00 
	vCs      3.5054e+00   7.7969e-02   5.1506e-01   1.7539e-02    1.7337e+00   -1.3803e+00 
	vRs      2.9593e+00   5.3452e-02   2.0013e-01   2.0001e-01    1.0004e+00   -5.4660e-04 
____________________________________________________________________________________________


------> RANKING for experiment: 2



------>ABSOLUTE Ranking of model unknowns:

			par value		d_msqr		 d_mabs		 d_mean			d_max		  d_min
____________________________________________________________________________________________
	vBs      4.6096e-01   1.5808e-01   1.0726e+00   1.0596e+00    4.9012e+00   -2.0762e-01 
	vRs      2.9593e+00   3.7049e-02   1.3060e-01   1.3059e-01    1.9968e+00   -5.9317e-05 
	vRes     2.3461e+00   2.9793e-02   1.6203e-01  -3.2400e-02    1.6854e+00   -7.4663e-01 
	vCs      3.5054e+00   2.7833e-02   1.2524e-01   1.1102e-02    1.7944e+00   -5.8810e-01 
	vPs      3.1774e+00   2.7567e-02   1.4430e-01  -1.3784e-02    1.5903e+00   -8.0156e-01 
____________________________________________________________________________________________


------>RELATIVE Ranking of model unknowns:

			par value		rd_msqr		rd_mabs		rd_mean			rd_max		rd_min
____________________________________________________________________________________________
____________________________________________________________________________________________
	vPs      3.1774e+00   6.1136e-02   5.2089e-01  -3.3121e-01    1.5903e+00   -1.1966e+00 
	vBs      4.6096e-01   5.7754e-02   5.4163e-01   5.3103e-01    4.9012e+00   -2.1022e-01 
	vCs      3.5054e+00   5.5601e-02   4.7180e-01  -2.6108e-01    1.7944e+00   -9.7647e-01 
	vRes     2.3461e+00   5.1267e-02   3.7555e-01  -4.1796e-02    1.6854e+00   -1.7587e+00 
	vRs      2.9593e+00   4.0804e-02   1.9995e-01   1.9995e-01    1.9968e+00   -5.9317e-05 
____________________________________________________________________________________________


------> OVERALL RANKING



------>ABSOLUTE Ranking of GLOBAL model unknowns:

			par value		d_msqr		 d_mabs		 d_mean			d_max		  d_min
____________________________________________________________________________________________
____________________________________________________________________________________________
	vBs      4.6096e-01   2.2083e-01   1.5172e+00   9.0432e-01    5.3848e+00   -3.6211e+00 
	vRes     2.3461e+00   4.4125e-02   2.7536e-01  -7.5893e-02    1.6854e+00   -1.1362e+00 
	vPs      3.1774e+00   3.4336e-02   2.0802e-01   8.7883e-03    1.5903e+00   -8.0156e-01 
	vCs      3.5054e+00   2.8843e-02   1.6201e-01   5.3886e-03    1.7944e+00   -5.8810e-01 
	vRs      2.9593e+00   2.8755e-02   1.0188e-01   1.0185e-01    1.9968e+00   -2.1724e-04 
____________________________________________________________________________________________


------>RELATIVE Ranking of GLOBAL model unknowns:

			par value		rd_msqr		rd_mabs		rd_mean			rd_max		rd_min
____________________________________________________________________________________________
	vRes     2.3461e+00   7.6911e-02   5.2870e-01  -1.3045e-01    1.6854e+00   -1.8424e+00 
	vPs      3.1774e+00   7.6047e-02   5.6928e-01  -1.4111e-01    1.6836e+00   -1.4714e+00 
	vBs      4.6096e-01   7.4716e-02   5.8886e-01   3.4933e-01    5.3848e+00   -3.6211e+00 
	vCs      3.5054e+00   6.6785e-02   4.9343e-01  -1.2177e-01    1.7944e+00   -1.3803e+00 
	vRs      2.9593e+00   4.7128e-02   2.0004e-01   1.9998e-01    1.9968e+00   -5.4660e-04 
____________________________________________________________________________________________
> 100.00% of successful simulationn
> 100.00% of successful sensitivity calculations
