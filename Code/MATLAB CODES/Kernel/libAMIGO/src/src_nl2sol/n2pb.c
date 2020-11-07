/* n2pb.f -- translated by f2c (version 20100827).
   You must link the resulting object file with libf2c:
	on Microsoft Windows system, link with libf2c.lib;
	on Linux or Unix systems, link with .../path/to/libf2c.a -lm
	or, if you install libf2c.a in a standard place, with -lf2c -lm
	-- in that order, at the end of the command line, as in
		cc *.o -lf2c -lm
	Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

		http://www.netlib.org/f2c/libf2c.zip
*/

#include "f2c.h"

/* Table of constant values */

static integer c__1 = 1;

/* Subroutine */ int n2pb_(integer *n, integer *nd, integer *p, real *x, real 
	*b, S_fp calcr, S_fp calcj, integer *iv, integer *liv, integer *lv, 
	real *v, integer *ui, real *ur, U_fp uf)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, d1, n1, n2, r1, nf, x01, nd1, dr1, rd1, iv1;
    extern /* Subroutine */ int rn2gb_(real *, real *, real *, integer *, 
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    integer *, real *, real *, real *, real *);
    static logical onerd;
    extern /* Subroutine */ int ivset_(integer *, integer *, integer *, 
	    integer *, real *);


/* *** SIMPLY BOUNDED VERSION OF NL2SOL THAT HAS EXPANDED CALLING */
/* *** SEQUENCES FOR CALCR, CALCJ, ALLOWING THEM TO PROVIDE R AND J */
/* *** (RESIDUALS AND JACOBIAN) IN CHUNKS. */

/*  ***  PARAMETERS  *** */

/* /6 */
/*     INTEGER IV(LIV), UI(1) */
/*     REAL B(2,P), X(P), V(LV), UR(1) */
/* /7 */
/* / */


/*  ***  PARAMETER USAGE  *** */

/* N....... TOTAL NUMBER OF RESIDUALS. */
/* ND...... MAXIMUM NUMBER OF RESIDUAL COMPONENTS PROVIDED BY ANY CALL */
/*             ON CALCR. */
/* P....... NUMBER OF PARAMETERS (COMPONENTS OF X) BEING ESTIMATED. */
/* X....... PARAMETER VECTOR BEING ESTIMATED (INPUT = INITIAL GUESS, */
/*             OUTPUT = BEST VALUE FOUND). */
/* CALCR... SUBROUTINE FOR COMPUTING RESIDUAL VECTOR. */
/* CALCJ... SUBROUTINE FOR COMPUTING JACOBIAN MATRIX = MATRIX OF FIRST */
/*             PARTIALS OF THE RESIDUAL VECTOR. */
/* IV...... INTEGER VALUES ARRAY. */
/* LIV..... LENGTH OF IV (SEE DISCUSSION BELOW). */
/* LV...... LENGTH OF V (SEE DISCUSSION BELOW). */
/* V....... FLOATING-POINT VALUES ARRAY. */
/* UI...... PASSED UNCHANGED TO CALCR AND CALCJ. */
/* UR...... PASSED UNCHANGED TO CALCR AND CALCJ. */
/* UF...... PASSED UNCHANGED TO CALCR AND CALCJ. */


/*  ***  DISCUSSION  *** */

/*    THIS ROUTINE IS SIMILAR TO    N2G (WHICH SEE), EXCEPT THAT THE */
/* CALLING SEQUENCE FOR CALCR AND CALCJ IS DIFFERENT -- IT ALLOWS */
/* THE RESIDUAL VECTOR AND JACOBIAN MATRIX TO BE PASSED IN BLOCKS. */

/*   FOR CALCR, THE CALLING SEQUENCE IS... */

/*     CALCR(N, ND1, N1, N2, P, X, NF, R, UI, UR, UF) */

/*   PARAMETERS N, P, X, NF, R, UI, UR, UF ARE AS FOR THE CALCR USED */
/* BY NL2SOL OR    N2G. */
/*   PARAMETERS ND1, N1, AND N2 ARE INPUTS TO CALCR.  CALCR SHOULD NOT */
/* CHANGE ND1 OR N1 (BUT MAY CHANGE N2). */
/*   ND1 = MIN(N,ND) IS THE MAXIMUM NUMBER OF RESIDUAL COMPONENTS THAT */
/* CALCR SHOULD SUPPLY ON ONE CALL. */
/*   N1 IS THE INDEX OF THE FIRST RESIDUAL COMPONENT THAT CALCR SHOULD */
/* SUPPLY ON THIS CALL. */
/*   N2 HAS THE VALUE MIN(N, N1+ND1-1) WHEN CALCR IS CALLED.  CALCR */
/* MAY SET N2 TO A LOWER VALUE (AT LEAST 1) AND FOR N1 .LE. I .LE. N2 */
/* SHOULD RETURN RESIDUAL COMPONENT I IN R(I-N1+1), I.E., IN COMPONENTS */
/* R(1), R(2), ..., R(N2-N1+1). */

/*   FOR CALCJ, THE CALLING SEQUENCE IS... */

/*     CALCJ(N, ND1, N1, N2, P, X, NF, J, UI, UR, UF) */

/*   ALL PARAMETERS EXCEPT N2 AND J ARE AS FOR CALCR.  N2 MAY NOT BE */
/* CHANGED, BUT OTHERWISE IS AS FOR CALCR.  (WHENEVER CALCJ IS CALLED, */
/* CALCR WILL JUST HAVE BEEN CALLED WITH THE SAME VALUE OF N1 BUT */
/* POSSIBLY A DIFFERENT X -- NF IDENTIFIES THE X PASSED.  IF CALCR */
/* CHANGES N2, THEN THIS CHANGED VALUE IS PASSED TO CALCJ.) */
/*   J IS A FLOATING-POINT ARRAY DIMENSIONED J(ND1,P).  FOR I = N1(1)N2 */
/* AND K = 1(1)P, CALCJ MUST STORE THE PARTIAL DERIVATIVE AT X OF */
/* RESIDUAL COMPONENT I WITH RESPECT TO X(K) IN J(I-N1+1,K). */

/*   LIV MUST BE AT LEAST 82 + P.  LV MUST BE AT LEAST */
/*         105 + P*(17 + 2*P) + (P+1)*MIN(ND,N) + N */
/* IF ND .LT. N AND NO REGRESSION DIAGNOSTIC ARRAY IS REQUESTED */
/* (I.E., IV(RDREQ) = 0 OR 1), THEN LV CAN BE N LESS THAN THIS. */

/* +++++++++++++++++++++++++++  DECLARATIONS  +++++++++++++++++++++++++++ */

/*  ***  EXTERNAL SUBROUTINES  *** */

/* IVSET.... PROVIDES DEFAULT IV AND V INPUT COMPONENTS. */
/*  RN2GB... CARRIES OUT OPTIMIZATION ITERATIONS. */

/*  ***  LOCAL VARIABLES  *** */


/*  ***  IV COMPONENTS  *** */

/* /6 */
/*     DATA D/27/, J/70/, NEXTV/47/, NF00/81/, NFCALL/6/, NFGCAL/7/, */
/*    1     R/61/, REGD0/82/, TOOBIG/2/, VNEED/4/, X0/43/ */
/* /7 */
/* / */
/* ---------------------------------  BODY  ------------------------------ */

    /* Parameter adjustments */
    b -= 3;
    --x;
    --iv;
    --v;
    --ui;
    --ur;

    /* Function Body */
    if (iv[1] == 0) {
	ivset_(&c__1, &iv[1], liv, lv, &v[1]);
    }
    nd1 = min(*nd,*n);
    iv1 = iv[1];
    if (iv1 == 14) {
	goto L10;
    }
    if (iv1 > 2 && iv1 < 12) {
	goto L10;
    }
    if (iv1 == 12) {
	iv[1] = 13;
    }
    i__ = iv[4] + *p + nd1 * (*p + 1);
    onerd = *nd >= *n;
    if (onerd) {
	i__ += *n;
    }
    if (iv[1] == 13) {
	iv[4] = i__;
    }
    rn2gb_(&b[3], &v[1], &v[1], &iv[1], liv, lv, n, &nd1, &n1, &n2, p, &v[1], 
	    &v[1], &v[1], &x[1]);
    if (iv[1] != 14) {
	goto L999;
    }

/*  ***  STORAGE ALLOCATION  *** */

    iv[27] = iv[47];
    iv[61] = iv[27] + *p;
    i__ = iv[61] + nd1;
    iv[82] = i__;
    if (onerd) {
	i__ += *n;
    }
    iv[70] = i__;
    iv[47] = i__ + nd1 * *p;
    if (iv1 == 13) {
	goto L999;
    }

L10:
    d1 = iv[27];
    dr1 = iv[70];
    r1 = iv[61];
    rd1 = iv[82];

L20:
    rn2gb_(&b[3], &v[d1], &v[dr1], &iv[1], liv, lv, n, &nd1, &n1, &n2, p, &v[
	    r1], &v[rd1], &v[1], &x[1]);
    iv1 = iv[1];
    if ((i__1 = iv1 - 2) < 0) {
	goto L40;
    } else if (i__1 == 0) {
	goto L30;
    } else {
	goto L999;
    }
L30:
    if (*nd >= *n) {
	goto L70;
    }

/*  ***  FIRST COMPUTE RELEVANT PORTION OF R  *** */

L40:
    nf = iv[6];
    if (abs(iv1) >= 2) {
	nf = iv[7];
    }
    (*calcr)(n, &nd1, &n1, &n2, p, &x[1], &nf, &v[r1], &ui[1], &ur[1], (U_fp)
	    uf);
    if (nf > 0) {
	goto L50;
    }
    iv[2] = 1;
    goto L20;
L50:
    i__ = iv1 + 4;
    switch (i__) {
	case 1:  goto L70;
	case 2:  goto L60;
	case 3:  goto L70;
	case 4:  goto L20;
	case 5:  goto L20;
	case 6:  goto L70;
    }
L60:
    x01 = iv[43];
    (*calcj)(n, &nd1, &n1, &n2, p, &v[x01], &iv[81], &v[dr1], &ui[1], &ur[1], 
	    (U_fp)uf);
    if (iv[81] <= 0) {
	iv[2] = 1;
    }
    goto L20;

/*  ***  COMPUTE DR = GRADIENT OF R COMPONENTS  *** */

L70:
    (*calcj)(n, &nd1, &n1, &n2, p, &x[1], &iv[7], &v[dr1], &ui[1], &ur[1], (
	    U_fp)uf);
    if (iv[7] == 0) {
	iv[2] = 1;
    }
    goto L20;

L999:
    return 0;

/*  ***  LAST LINE OF   N2PB FOLLOWS  *** */
} /* n2pb_ */

