#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>

#include <amigo_terminate.h>


	/* *** Definition of the states *** */

#define	Per_mRNA                            Ith(y,0)
#define	Cry_mRNA                            Ith(y,1)
#define	Bmal1_mRNA                          Ith(y,2)
#define	Ror_mRNA                            Ith(y,3)
#define	Rev_erb_mRNA                        Ith(y,4)
#define	CYTOSOLIC_PER_PROTEIN               Ith(y,5)
#define	CYTOSOLIC_CRY_PROTEIN               Ith(y,6)
#define	CYTOSOLIC_BMAL1_PROTEIN             Ith(y,7)
#define	CYTOSOLIC_ROR_PROTEIN               Ith(y,8)
#define	CYTOSOLIC_REV_ERB_PROTEIN           Ith(y,9)
#define	CYTOSOLIC_PER_CRY_PROTEIN           Ith(y,10)
#define	PHOS_CYTOSOLIC_PER_PROTEIN          Ith(y,11)
#define	PHOS_CYTOSOLIC_CRY_PROTEIN          Ith(y,12)
#define	PHOS_CYTOSOLIC_BMAL1_PROTEIN        Ith(y,13)
#define	PHOS_CYTOSOLIC_ROR_PROTEIN          Ith(y,14)
#define	PHOS_CYTOSOLIC_REV_ERB_PROTEIN      Ith(y,15)
#define	PHOS_CYTOSOLIC_PER_CRY_PROTEIN      Ith(y,16)
#define	NUCLEAR_BMAL1_PROTEIN               Ith(y,17)
#define	NUCLEAR_ROR_PROTEIN                 Ith(y,18)
#define	NUCLEAR_REV_ERB_PROTEIN             Ith(y,19)
#define	NUCLEAR_CLOCK_BMAL1_PROTEIN         Ith(y,20)
#define	NUCLEAR_PER_CRY_PROTEIN             Ith(y,21)
#define	NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN Ith(y,22)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dPer_mRNA                            Ith(ydot,0)
#define	dCry_mRNA                            Ith(ydot,1)
#define	dBmal1_mRNA                          Ith(ydot,2)
#define	dRor_mRNA                            Ith(ydot,3)
#define	dRev_erb_mRNA                        Ith(ydot,4)
#define	dCYTOSOLIC_PER_PROTEIN               Ith(ydot,5)
#define	dCYTOSOLIC_CRY_PROTEIN               Ith(ydot,6)
#define	dCYTOSOLIC_BMAL1_PROTEIN             Ith(ydot,7)
#define	dCYTOSOLIC_ROR_PROTEIN               Ith(ydot,8)
#define	dCYTOSOLIC_REV_ERB_PROTEIN           Ith(ydot,9)
#define	dCYTOSOLIC_PER_CRY_PROTEIN           Ith(ydot,10)
#define	dPHOS_CYTOSOLIC_PER_PROTEIN          Ith(ydot,11)
#define	dPHOS_CYTOSOLIC_CRY_PROTEIN          Ith(ydot,12)
#define	dPHOS_CYTOSOLIC_BMAL1_PROTEIN        Ith(ydot,13)
#define	dPHOS_CYTOSOLIC_ROR_PROTEIN          Ith(ydot,14)
#define	dPHOS_CYTOSOLIC_REV_ERB_PROTEIN      Ith(ydot,15)
#define	dPHOS_CYTOSOLIC_PER_CRY_PROTEIN      Ith(ydot,16)
#define	dNUCLEAR_BMAL1_PROTEIN               Ith(ydot,17)
#define	dNUCLEAR_ROR_PROTEIN                 Ith(ydot,18)
#define	dNUCLEAR_REV_ERB_PROTEIN             Ith(ydot,19)
#define	dNUCLEAR_CLOCK_BMAL1_PROTEIN         Ith(ydot,20)
#define	dNUCLEAR_PER_CRY_PROTEIN             Ith(ydot,21)
#define	dNUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN Ith(ydot,22)

	/* *** Definition of the parameters *** */

#define	n      (*amigo_model).pars[0]
#define	m      (*amigo_model).pars[1]
#define	p      (*amigo_model).pars[2]
#define	q      (*amigo_model).pars[3]
#define	O      (*amigo_model).pars[4]
#define	l      (*amigo_model).pars[5]
#define	r      (*amigo_model).pars[6]
#define	s      (*amigo_model).pars[7]
#define	g      (*amigo_model).pars[8]
#define	h      (*amigo_model).pars[9]
#define	vPs    (*amigo_model).pars[10]
#define	kiP    (*amigo_model).pars[11]
#define	d_mP   (*amigo_model).pars[12]
#define	vCs    (*amigo_model).pars[13]
#define	kiC    (*amigo_model).pars[14]
#define	d_mC   (*amigo_model).pars[15]
#define	vBs    (*amigo_model).pars[16]
#define	kiB    (*amigo_model).pars[17]
#define	d_mB   (*amigo_model).pars[18]
#define	vRs    (*amigo_model).pars[19]
#define	kiR    (*amigo_model).pars[20]
#define	d_mR   (*amigo_model).pars[21]
#define	vRes   (*amigo_model).pars[22]
#define	kiRe   (*amigo_model).pars[23]
#define	d_mRe  (*amigo_model).pars[24]
#define	k      (*amigo_model).pars[25]
#define	Kpc1   (*amigo_model).pars[26]
#define	Kpco   (*amigo_model).pars[27]
#define	Kpc    (*amigo_model).pars[28]
#define	Kppc   (*amigo_model).pars[29]
#define	dpc    (*amigo_model).pars[30]
#define	k1     (*amigo_model).pars[31]
#define	Kcc    (*amigo_model).pars[32]
#define	Kcpc   (*amigo_model).pars[33]
#define	dcc    (*amigo_model).pars[34]
#define	k2     (*amigo_model).pars[35]
#define	Kbcc   (*amigo_model).pars[36]
#define	Kbc    (*amigo_model).pars[37]
#define	Kbpc   (*amigo_model).pars[38]
#define	dbc    (*amigo_model).pars[39]
#define	k3     (*amigo_model).pars[40]
#define	Krcc   (*amigo_model).pars[41]
#define	Krc    (*amigo_model).pars[42]
#define	Krpc   (*amigo_model).pars[43]
#define	drc    (*amigo_model).pars[44]
#define	k4     (*amigo_model).pars[45]
#define	Krecc  (*amigo_model).pars[46]
#define	Krec   (*amigo_model).pars[47]
#define	Krepc  (*amigo_model).pars[48]
#define	drec   (*amigo_model).pars[49]
#define	Kpcc   (*amigo_model).pars[50]
#define	Kpcp   (*amigo_model).pars[51]
#define	Kpcpc  (*amigo_model).pars[52]
#define	dpcc   (*amigo_model).pars[53]
#define	dppc   (*amigo_model).pars[54]
#define	dcpc   (*amigo_model).pars[55]
#define	dbpc   (*amigo_model).pars[56]
#define	drpc   (*amigo_model).pars[57]
#define	drepc  (*amigo_model).pars[58]
#define	dpcpc  (*amigo_model).pars[59]
#define	Kclbn  (*amigo_model).pars[60]
#define	dbn    (*amigo_model).pars[61]
#define	Krn    (*amigo_model).pars[62]
#define	drn    (*amigo_model).pars[63]
#define	Kren   (*amigo_model).pars[64]
#define	dren   (*amigo_model).pars[65]
#define	kcbpc  (*amigo_model).pars[66]
#define	dclbn  (*amigo_model).pars[67]
#define	dpcn   (*amigo_model).pars[68]
#define	kdcbpc (*amigo_model).pars[69]
#define light	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])

	/* *** Definition of the algebraic variables *** */

/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	/* *** Equations *** */

	dPer_mRNA=((vPs*pow(light*NUCLEAR_CLOCK_BMAL1_PROTEIN,m))/(pow(kiP,m)+pow((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN),n)+pow(NUCLEAR_CLOCK_BMAL1_PROTEIN,m)))-d_mP*Per_mRNA;
	dCry_mRNA=((vCs*pow(light*NUCLEAR_CLOCK_BMAL1_PROTEIN,p))/(pow(kiC,p)+pow((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN),q)+pow(NUCLEAR_CLOCK_BMAL1_PROTEIN,p)))-d_mC*Cry_mRNA;
	dBmal1_mRNA=((vBs*(pow(NUCLEAR_ROR_PROTEIN,O)))/(pow(kiB,O)+pow((NUCLEAR_ROR_PROTEIN)*(NUCLEAR_REV_ERB_PROTEIN),l)+pow(NUCLEAR_ROR_PROTEIN,O)))-d_mB*Bmal1_mRNA;
	dRor_mRNA=((vRs*pow(NUCLEAR_CLOCK_BMAL1_PROTEIN,r))/(pow(kiR,r)+pow((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN),s)+pow(NUCLEAR_CLOCK_BMAL1_PROTEIN,r)))-d_mR*Ror_mRNA;
	dRev_erb_mRNA=((vRes*pow(light*NUCLEAR_CLOCK_BMAL1_PROTEIN,g))/(pow(kiRe,g)+pow((NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN),h)+pow(NUCLEAR_CLOCK_BMAL1_PROTEIN,g)))-d_mRe*Rev_erb_mRNA;
	dCYTOSOLIC_PER_PROTEIN=k*Per_mRNA+Kpc1*(CYTOSOLIC_PER_CRY_PROTEIN)-Kpco*(CYTOSOLIC_PER_PROTEIN)*(CYTOSOLIC_CRY_PROTEIN)-Kpc*((CYTOSOLIC_PER_PROTEIN))+Kppc*(PHOS_CYTOSOLIC_PER_PROTEIN)-dpc*(CYTOSOLIC_PER_PROTEIN);
	dCYTOSOLIC_CRY_PROTEIN=k1*Cry_mRNA+Kpc1*(CYTOSOLIC_PER_CRY_PROTEIN)-Kpco*(CYTOSOLIC_PER_PROTEIN)*(CYTOSOLIC_CRY_PROTEIN)-Kcc*((CYTOSOLIC_CRY_PROTEIN))+Kcpc*(PHOS_CYTOSOLIC_CRY_PROTEIN)-dcc*(CYTOSOLIC_CRY_PROTEIN);
	dCYTOSOLIC_BMAL1_PROTEIN=k2*Bmal1_mRNA-Kbcc*(CYTOSOLIC_BMAL1_PROTEIN)-Kbc*(CYTOSOLIC_BMAL1_PROTEIN)+Kbpc*(PHOS_CYTOSOLIC_BMAL1_PROTEIN)-dbc*(CYTOSOLIC_BMAL1_PROTEIN);
	dCYTOSOLIC_ROR_PROTEIN=k3*Ror_mRNA-Krcc*(CYTOSOLIC_ROR_PROTEIN)-Krc*((CYTOSOLIC_ROR_PROTEIN))+Krpc*(PHOS_CYTOSOLIC_ROR_PROTEIN)-drc*(CYTOSOLIC_ROR_PROTEIN);
	dCYTOSOLIC_REV_ERB_PROTEIN=k4*Rev_erb_mRNA-Krecc*(CYTOSOLIC_REV_ERB_PROTEIN)-Krec*((CYTOSOLIC_REV_ERB_PROTEIN))+Krepc*(PHOS_CYTOSOLIC_REV_ERB_PROTEIN)-drec*(CYTOSOLIC_REV_ERB_PROTEIN);
	dCYTOSOLIC_PER_CRY_PROTEIN=Kpco*((CYTOSOLIC_PER_PROTEIN)*(CYTOSOLIC_CRY_PROTEIN))-Kpcc*(CYTOSOLIC_PER_CRY_PROTEIN)-Kpc1*(CYTOSOLIC_PER_CRY_PROTEIN)-Kpcp*((CYTOSOLIC_PER_CRY_PROTEIN))+Kpcpc*(PHOS_CYTOSOLIC_PER_CRY_PROTEIN)-dpcc*(CYTOSOLIC_PER_CRY_PROTEIN);
	dPHOS_CYTOSOLIC_PER_PROTEIN=Kpc*(CYTOSOLIC_PER_PROTEIN)-Kppc*(PHOS_CYTOSOLIC_PER_PROTEIN)-dppc*(PHOS_CYTOSOLIC_PER_PROTEIN);
	dPHOS_CYTOSOLIC_CRY_PROTEIN=Kcc*(CYTOSOLIC_CRY_PROTEIN)-Kcpc*(PHOS_CYTOSOLIC_CRY_PROTEIN)-dcpc*(PHOS_CYTOSOLIC_CRY_PROTEIN);
	dPHOS_CYTOSOLIC_BMAL1_PROTEIN=Kbc*(CYTOSOLIC_BMAL1_PROTEIN)-Kbpc*(PHOS_CYTOSOLIC_BMAL1_PROTEIN)-dbpc*(PHOS_CYTOSOLIC_BMAL1_PROTEIN);
	dPHOS_CYTOSOLIC_ROR_PROTEIN=Krc*(CYTOSOLIC_ROR_PROTEIN)-Krpc*(PHOS_CYTOSOLIC_ROR_PROTEIN)-drpc*(PHOS_CYTOSOLIC_ROR_PROTEIN);
	dPHOS_CYTOSOLIC_REV_ERB_PROTEIN=Krec*(CYTOSOLIC_REV_ERB_PROTEIN)-Krepc*(PHOS_CYTOSOLIC_REV_ERB_PROTEIN)-drepc*(PHOS_CYTOSOLIC_REV_ERB_PROTEIN);
	dPHOS_CYTOSOLIC_PER_CRY_PROTEIN=Kpcp*((CYTOSOLIC_PER_CRY_PROTEIN))-Kpcpc*(PHOS_CYTOSOLIC_PER_CRY_PROTEIN)-dpcpc*(PHOS_CYTOSOLIC_PER_CRY_PROTEIN);
	dNUCLEAR_BMAL1_PROTEIN=Kbcc*(CYTOSOLIC_BMAL1_PROTEIN)-Kclbn*(NUCLEAR_BMAL1_PROTEIN)-dbn*(NUCLEAR_BMAL1_PROTEIN);
	dNUCLEAR_ROR_PROTEIN=Krcc*(CYTOSOLIC_ROR_PROTEIN)-Krn*(NUCLEAR_ROR_PROTEIN)-drn*(NUCLEAR_ROR_PROTEIN);
	dNUCLEAR_REV_ERB_PROTEIN=Krecc*(CYTOSOLIC_REV_ERB_PROTEIN)-Kren*(NUCLEAR_REV_ERB_PROTEIN)-dren*(NUCLEAR_REV_ERB_PROTEIN);
	dNUCLEAR_CLOCK_BMAL1_PROTEIN=Kclbn*(NUCLEAR_BMAL1_PROTEIN)-kcbpc*(NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN)+kdcbpc*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)-dclbn*(NUCLEAR_CLOCK_BMAL1_PROTEIN)+dpcn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN);
	dNUCLEAR_PER_CRY_PROTEIN=Kpcc*(CYTOSOLIC_PER_CRY_PROTEIN)-kcbpc*(NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN)+kdcbpc*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)-dpcn*(NUCLEAR_PER_CRY_PROTEIN)+dclbn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN);
	dNUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN=kcbpc*(NUCLEAR_CLOCK_BMAL1_PROTEIN)*(NUCLEAR_PER_CRY_PROTEIN)-kdcbpc*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)-dclbn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN)-dpcn*(NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN);

	return(0);

}


/* Jacobian of the system (dfdx)*/
int amigoJAC(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3){
	AMIGO_model* amigo_model=(AMIGO_model*)user_data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	return(0);
}

/* R.H.S of the sensitivity dsi/dt = (df/dx)*si + df/dp_i */
int amigoSensRHS(int Ns, realtype t, N_Vector y, N_Vector ydot, int iS, N_Vector yS, N_Vector ySdot, void *data, N_Vector tmp1, N_Vector tmp2){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	return(0);

}