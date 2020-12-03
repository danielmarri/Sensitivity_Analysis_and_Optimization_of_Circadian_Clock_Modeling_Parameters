
1. About compilation of your own version

 Source files can be found on the SVN: 
 trunk/utilities/solvers/NL2SOL2015

Note that the MEX interface for WIN and LINUX is slightly different (for compatibility issues).

**** 1.1 WIN32/64
On Windows machine use Visual Fortran to generate dynamic libraries from the NL2SOL FORTRAN code and then Visual C in MATLAB mex to compile  the interface and link to the library as explained in the OPTI Toolbox. Thanks for J.Currie.

- It works similar ways for 32/64 bit. However, note that it requires some path-adjustment. 

**** 1.2 GLNX64/86

On Linux 32/64 bit you can use ifortran and gcc.
there are compile_*.sh files prepared for (i) the compilation of the FORTRAN to static libraries and (ii) compilation of the MEX interface and linking to the FORTRAN libraries. 








2. What changed from the OPTI interface. 
Here is an explanaton what changed in the MexInterface of NL2SOL.

nl2solmex_originalMACHEPS:
	is the original mex interface coming with OPTI toolbox
	
nl2solmex_float:
	every function was rewritten to floating point calculation in order to compare the performance of the single and double
	precision code (dn2fb and n2fb). It turned out the floating point algorithm uses higher perturbation parameter to compute the Jacobian
	and this is why it worked better than dn2fb. By setting the perturbation parameter properly the double precision algorithm performs better.
	
nl2solmex_double.c
	based on nl2solmex_originalMACHEPS.
	V(DLTFDC) and V(DLTFDJ) are adjusted to RTol = 1e-7 gradient computation precision.
	
nl2solmex_tuned.c == nl2solmex_v2_0
	the precision of the gradient and the objective function can be an input of NL2SOL passed through the "objrtol" field of the option structure.
	the perturbation parameters (V(DLTFDC) and V(DLTFDJ)) for the Jacobian and the Hessian is adjusted to this value.

nl2solmex_2.1.c
	if the gradient computation fails in CVODES, the CALCJ function inside the NL2SOL mex interface detects it (CVODES sets the sensitivities to NaN). 
	NL2SOL reports an internal error, but the best parameters and objective function is returned.
	
	