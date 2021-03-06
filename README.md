# Dynamical_Optimization_of_Circadian_Clock_Modeling_Parameters.
Sensitivity Analysis and Optimization of Parameters of the Mammalian Circadian Clock Systems of Ordinary Differential Equation Model.

This project is to use the Advanced Model Identification using Global Optimization (AMIGO2_R2019b) Toolbox in Matlab to discuss the Sensitivity Analysis and Optimization of Parameters of the Mammalian Circadian Clock Systems of Ordinary Differential Equation Model.


# Directory information

- Reports/ : Contains biweekly assignments and reports for the course
- AMIGO/  : Contains the AMIGO_R2019b folder where the codes for the project can be found and Tests folder where testing codes for the project can be found.

# Install MinGW-w64 Compiler for windows users.

MinGW-w64 is a compiler suite for Windows based on the GNU tool chain. It includes a GCC compiler and related tools for compiling C and C++ applications for Windows. C and C++ 
applications compiled with MinGW-w64 GCC can be called from MATLAB using MEX. This GCC compiler can also be helpful for other MathWorks products that require a C or C++ 
compiler.

To install the compiler, use the Add-Ons menu.

1. On the MATLAB Home tab, in the Environment section, click Add-Ons > Get Add-Ons.

2. Search for MinGW or select from Features.



# Installation

1. Download all the documents from the folder 
./AMIGO_R2019b/

2. Start a Matlab session and change the working directory to the AMIGO2_R2019b folder

3. Type:
> AMIGO_Startup

This add all the paths needed for the project to the MATLAB session.
      
# The AMIGO2_R2019b folder is a developed Toolbox in MATLAB. The codes that I wrote and added to thia Toolbox is found in the 
AMIGO2_R2019b/Model_Simulation_and_Analysis/Model_Simulation/  folder and the  AMIGO2_R2019b/Model_Simulation_and_Analysis/Local_and_Global_Sensitivity_Analysis/



# Run the Simulation

The  Mammalian Circadian Clock Systems of Ordinary Differential Equation Model is found in the folder:
AMIGO/AMIGO2_R2019b/Model_Simulation_and_Analysis/Model_Simulation/

run the run_My_Clock_model.m file to see the output dynamics of the system.  The run_My_Clock_model.m calls the My_Clock_model.m file wich contains the code for the systems of 
equations for the model


The Sensitivity Analysis code for the Mammalian Circadian Clock Systems of Ordinary Differential Equation Model is found in the folder: 
AMIGO/AMIGO2_R2019b/Model_Simulation_and_Analysis/Local_and_Global_Sensitivity_Analysis/

To get the outputs for the sensitivity analysis of the model parameters, run the run_.m file for either the local or global sensitivity analysis.


# Results of the simulations

The results of the simulation can be found in the folder ./Sensitivity_Analysis_and_Optimization_of_Circadian_Clock_Modeling_Parameters/AMIGO/AMIGO2_R2019b/Results/circadian-tutorial/'

1. The SObs_circadian_run1/ folder contains the results output for the Mammalian Circadian Clock Systems of Ordinary Differential Equation Model

2. The LRank_circadian_run1/ folder contains the outputs of the Local Sensitivity analysis of the model parameters 

3. The GRank_circadian_run1/ folder contains the outputs of the Global Sensitivity analysis of the model parameters


# Final Presentation video

https://mediaspace.msu.edu/media/t/1_50nej548

