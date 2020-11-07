function ms=AMIGO_gen_obs_circadian(y,inputs,par,iexp)
	Per_mRNA                           =y(:,1);
	Cry_mRNA                           =y(:,2);
	Bmal1_mRNA                         =y(:,3);
	Ror_mRNA                           =y(:,4);
	Rev_erb_mRNA                       =y(:,5);
	CYTOSOLIC_PER_PROTEIN              =y(:,6);
	CYTOSOLIC_CRY_PROTEIN              =y(:,7);
	CYTOSOLIC_BMAL1_PROTEIN            =y(:,8);
	CYTOSOLIC_ROR_PROTEIN              =y(:,9);
	CYTOSOLIC_REV_ERB_PROTEIN          =y(:,10);
	CYTOSOLIC_PER_CRY_PROTEIN          =y(:,11);
	PHOS_CYTOSOLIC_PER_PROTEIN         =y(:,12);
	PHOS_CYTOSOLIC_CRY_PROTEIN         =y(:,13);
	PHOS_CYTOSOLIC_BMAL1_PROTEIN       =y(:,14);
	PHOS_CYTOSOLIC_ROR_PROTEIN         =y(:,15);
	PHOS_CYTOSOLIC_REV_ERB_PROTEIN     =y(:,16);
	PHOS_CYTOSOLIC_PER_CRY_PROTEIN     =y(:,17);
	NUCLEAR_BMAL1_PROTEIN              =y(:,18);
	NUCLEAR_ROR_PROTEIN                =y(:,19);
	NUCLEAR_REV_ERB_PROTEIN            =y(:,20);
	NUCLEAR_CLOCK_BMAL1_PROTEIN        =y(:,21);
	NUCLEAR_PER_CRY_PROTEIN            =y(:,22);
	NUCLEAR_CLOCK_BMAL1_PER_CRY_PROTEIN=y(:,23);
	n     =par(1);
	m     =par(2);
	p     =par(3);
	q     =par(4);
	O     =par(5);
	l     =par(6);
	r     =par(7);
	s     =par(8);
	g     =par(9);
	h     =par(10);
	vPs   =par(11);
	kiP   =par(12);
	d_mP  =par(13);
	vCs   =par(14);
	kiC   =par(15);
	d_mC  =par(16);
	vBs   =par(17);
	kiB   =par(18);
	d_mB  =par(19);
	vRs   =par(20);
	kiR   =par(21);
	d_mR  =par(22);
	vRes  =par(23);
	kiRe  =par(24);
	d_mRe =par(25);
	k     =par(26);
	Kpc1  =par(27);
	Kpco  =par(28);
	Kpc   =par(29);
	Kppc  =par(30);
	dpc   =par(31);
	k1    =par(32);
	Kcc   =par(33);
	Kcpc  =par(34);
	dcc   =par(35);
	k2    =par(36);
	Kbcc  =par(37);
	Kbc   =par(38);
	Kbpc  =par(39);
	dbc   =par(40);
	k3    =par(41);
	Krcc  =par(42);
	Krc   =par(43);
	Krpc  =par(44);
	drc   =par(45);
	k4    =par(46);
	Krecc =par(47);
	Krec  =par(48);
	Krepc =par(49);
	drec  =par(50);
	Kpcc  =par(51);
	Kpcp  =par(52);
	Kpcpc =par(53);
	dpcc  =par(54);
	dppc  =par(55);
	dcpc  =par(56);
	dbpc  =par(57);
	drpc  =par(58);
	drepc =par(59);
	dpcpc =par(60);
	Kclbn =par(61);
	dbn   =par(62);
	Krn   =par(63);
	drn   =par(64);
	Kren  =par(65);
	dren  =par(66);
	kcbpc =par(67);
	dclbn =par(68);
	dpcn  =par(69);
	kdcbpc=par(70);
 

switch iexp

case 1
Per_mRNA=Per_mRNA        ;
Cry_mRNA=Cry_mRNA        ;
Bmal1_mRNA=Bmal1_mRNA    ;
Ror_mRNA=Ror_mRNA        ;
Rev_erb_mRNA=Rev_erb_mRNA;
ms(:,1)=Per_mRNA    ;ms(:,2)=Cry_mRNA    ;ms(:,3)=Bmal1_mRNA  ;ms(:,4)=Ror_mRNA    ;ms(:,5)=Rev_erb_mRNA;

case 2
Per_mRNA=Per_mRNA        ;
Cry_mRNA=Cry_mRNA        ;
Bmal1_mRNA=Bmal1_mRNA    ;
Ror_mRNA=Ror_mRNA        ;
Rev_erb_mRNA=Rev_erb_mRNA;
ms(:,1)=Per_mRNA    ;ms(:,2)=Cry_mRNA    ;ms(:,3)=Bmal1_mRNA  ;ms(:,4)=Ror_mRNA    ;ms(:,5)=Rev_erb_mRNA;
end

return