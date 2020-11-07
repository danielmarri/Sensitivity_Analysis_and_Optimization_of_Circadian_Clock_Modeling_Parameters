/* nsgb.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int nsgb_(integer *n, integer *p, integer *l, real *alf, 
	real *b, real *c__, real *y, S_fp calca, S_fp calcb, integer *inc, 
	integer *iinc, integer *iv, integer *liv, integer *lv, real *v, 
	integer *uiparm, real *urparm, U_fp ufparm)
{
    /* System generated locals */
    integer inc_dim1, inc_offset, i__1, i__2;

    /* Local variables */
    static integer i__, k, m, a1, l1, m0, nf, da1, in1, lp1, iv1;
    extern /* Subroutine */ int rnsgb_(real *, real *, real *, real *, real *,
	     integer *, integer *, integer *, integer *, integer *, integer *,
	     integer *, integer *, integer *, integer *, real *, real *), 
	    ivset_(integer *, integer *, integer *, integer *, real *);


/*  ***  SOLVE SEPARABLE NONLINEAR LEAST SQUARES USING  *** */
/*  ***  ANALYTICALLY COMPUTED DERIVATIVES.             *** */

/*  ***  PARAMETER DECLARATIONS  *** */

/* /6 */
/*     INTEGER INC(IINC,P), IV(LIV), UIPARM(1) */
/*     REAL ALF(P), B(2,P), C(L), URPARM(1), V(LV), Y(N) */
/* /7 */
/* / */

/*  ***  PURPOSE  *** */

/* GIVEN A SET OF N OBSERVATIONS Y(1)....Y(N) OF A DEPENDENT VARIABLE */
/* T(1)...T(N),   NSGB ATTEMPTS TO COMPUTE A LEAST SQUARES FIT */
/* TO A FUNCTION  ETA  (THE MODEL) WHICH IS A LINEAR COMBINATION */

/*                  L */
/* ETA(C,ALF,T) =  SUM C * PHI(ALF,T) +PHI   (ALF,T) */
/*                 J=1  J     J           L+1 */

/* OF NONLINEAR FUNCTIONS PHI(J) DEPENDENT ON T AND ALF(1),...,ALF(P) */
/* (.E.G. A SUM OF EXPONENTIALS OR GAUSSIANS).  THAT IS, IT DETERMINES */
/* NONLINEAR PARAMETERS ALF WHICH MINIMIZE */

/*                   2    N                      2 */
/*     NORM(RESIDUAL)  = SUM  (Y - ETA(C,ALF,T )) , */
/*                       I=1    I             I */

/* SUBJECT TO THE SIMPLE BOUND CONSTRAINTS */
/* B(1,I) .LE. ALF(I) .LE. B(2,I), C I = 1(1)P. */

/* THE (L+1)ST TERM IS OPTIONAL. */

/* --------------------------  PARAMETER USAGE  ------------------------- */

/* INPUT PARAMETERS */

/* N     INTEGER        NUMBER OF OBSERVATIONS (MUST BE .GE. MAX(L,P)). */

/* P     INTEGER        NUMBER OF NONLINEAR PARAMETERS (MUST BE .GE. 1). */

/* L     INTEGER        NUMBER OF LINEAR PARAMETERS (MUST BE .GE. 0). */

/* ALF   D.P. ARRAY     P VECTOR = INITIAL ESTIMATE OF THE NONLINEAR */
/*                      PARAMETERS. */

/* CALCA SUBROUTINE     USER PROVIDED FUNCTION TO CALCULATE THE MODEL */
/*                      (I.E., TO CALCULATE PHI) -- SEE THE NOTE BELOW */
/*                      ON THE CALLING SEQUENCE FOR CALCA. */
/*                      CALCA MUST BE DECLARED EXTERNAL IN THE CALLING */
/*                      PROGRAM. */

/* CALCB SUBROUTINE     USER PROVIDED FUNCTION TO CALCULATE THE DERIVA- */
/*                      TIVE OF THE MODEL (I.E., OF PHI) WITH RESPECT TO */
/*                      ALF -- SEE THE NOTE BELOW ON THE CALLING */
/*                      SEQUENCE FOR CALCB.  CALCB MUST BE DECLARED */
/*                      EXTERNAL IN THE CALLING PROGRAM. */

/* Y     D.P. ARRAY     VECTOR OF OBSERVATIONS. */

/* INC   INTEGER ARRAY  A 2 DIM. ARRAY OF DIMENSION AT LEAST (L+1,P) */
/*                      INDICATING THE POSITION OF THE NONLINEAR PARA- */
/*                      METERS IN THE MODEL.  SET INC(J,K) = 1 IF ALF(K) */
/*                      APPEARS IN PHI(J).  OTHERWISE SET INC(J,K) = 0. */
/*                      IF PHI((L+1)) IS NOT IN THE MODEL, SET THE L+1ST */
/*                      ROW OF INC TO ALL ZEROS.  EVERY COLUMN OF INC */
/*                      MUST CONTAIN AT LEAST ONE 1. */

/* IINC   INTEGER       DECLARED ROW DIMENSION OF INC, WHICH MUST BE AT */
/*                      LEAST L+1. */

/* IV     INTEGER       ARRAY OF LENGTH AT LEAST LIV THAT CONTAINS */
/*                      VARIOUS PARAMETERS FOR THE SUBROUTINE, SUCH AS */
/*                      THE ITERATION AND FUNCTION EVALUATION LIMITS AND */
/*                      SWITCHES THAT CONTROL PRINTING.  THE INPUT COM- */
/*                      PONENTS OF IV ARE DESCRIBED IN DETAIL IN THE */
/*                      PORT OPTIMIZATION DOCUMENTATION. */
/*                         IF IV(1)=0 ON INPUT, THEN DEFAULT PARAMETERS */
/*                      ARE SUPPLIED TO IV AND V.  THE CALLER MAY SUPPLY */
/*                      NONDEFAULT PARAMETERS TO IV AND V BY EXECUTING A */
/*                      CALL IVSET(1,IV,LIV,LV,V) AND THEN ASSIGNING */
/*                      NONDEFAULT VALUES TO THE APPROPRIATE COMPONENTS */
/*                      OF IV AND V BEFORE CALLING   NSGB. */

/* LIV     INTEGER      LENGTH OF IV.  MUST BE AT LEAST */
/*                      115 + 4*P + L + 2*M, */
/*                      WHERE  M  IS THE NUMBER OF ONES IN INC. */

/* LV      INTEGER      LENGTH OF V.  MUST BE AT LEAST */
/*                      105 + N*(L+M+P+3) + L*(L+3)/2 + P*(2*P+21), */
/*                      WHERE  M  IS AS FOR LIV (SEE ABOVE).  IF THE */
/*                      LAST ROW OF INC CONTAINS ONLY ZEROS, THEN LV */
/*                      CAN BE N LESS THAN JUST DESCRIBED. */

/* V       D.P. ARRAY   WORK AND PARAMETER ARRAY OF LENGTH AT LEAST LV */
/*                      THAT CONTAINS SUCH INPUT COMPONENTS AS THE */
/*                      CONVERGENCE TOLERANCES.  THE INPUT COMPONENTS OF */
/*                      V MAY BE SUPPLIED AS FOR IV (SEE ABOVE).  NOTE */
/*                      THAT V(35) CONTAINS THE INITIAL STEP BOUND, */
/*                      WHICH, IF TOO LARGE, MAY LEAD TO OVERFLOW. */

/* UIPARM INTEGER ARRAY SCRATCH SPACE FOR USER TO SEND INFORMATION */
/*                      TO CALCA AND CALCB. */

/* URPARM D.P. ARRAY    SCRATCH SPACE FOR USER TO SEND INFORMATION */
/*                      TO CALCA AND CALCB. */

/* UFPARM EXTERNAL      SUBROUTINE SENT TO CALCA AND CALCB FOR THEIR */
/*                      USE.  NOTE THAT THE SUBROUTINE PASSED FOR UFPARM */
/*                      MUST BE DECLARED EXTERNAL IN THE CALLING PROGRAM. */


/* OUTPUT PARAMETERS */

/* ALF    D.P. ARRAY    FINAL NONLINEAR PARAMETERS. */

/* C      D.P. ARRAY    L VECTOR OF LINEAR PARAMETERS -- NOTE THAT NO */
/*                      INITIAL GUESS FOR C IS REQUIRED. */

/* IV                   IV(1) CONTAINS A RETURN CODE DESCRIBED IN THE */
/*                      PORT OPTIMIZATION DOCUMENTATION.  IF IV(1) LIES */
/*                      BETWEEN 3 AND 7, THEN THE ALGORITHM HAS */
/*                      CONVERGED (BUT IV(1) = 7 INDICATES POSSIBLE */
/*                      TROUBLE WITH THE MODEL).  IV(1) = 9 OR 10 MEANS */
/*                      FUNCTION EVALUATION OR ITERATION LIMIT REACHED. */
/*                      IV(1) = 66 MEANS BAD PARAMETERS (INCLUDING A */
/*                      COLUMN OF ZEROS IN INC).  NOTE THAT THE */
/*                      ALGORITHM CAN BE RESTARTED AFTER ANY RETURN WITH */
/*                      IV(1) .LT. 12 -- SEE THE PORT DOCUMENTATION. */

/* V                    VARIOUS ITEMS OF INTEREST, INCLUDING THE NORM OF */
/*                      THE GRADIENT(1) AND THE FUNCTION VALUE(10).  SEE */
/*                      THE PORT DOCUMENTATION FOR A COMPLETE LIST. */



/* PARAMETERS FOR CALCA(N,P,L,ALF,NF,PHI, UIPARM,URPARM,UFPARM) */

/* N,L,P,ALF ARE INPUT PARAMETERS AS DESCRIBED ABOVE */

/* PHI    D.P. ARRAY  N*(L+1) ARRAY WHOSE COLUMNS CONTAIN THE TERMS OF */
/*                    THE MODEL.  CALCA MUST EVALUATE PHI(ALF) AND STORE */
/*                    THE RESULT IN PHI.  IF THE (L+1)ST TERM IS NOT IN */
/*                    THE MODEL, THEN NOTHING SHOULD BE STORED IN THE */
/*                    (L+1)ST COLUMN OF PHI. */

/* NF     INTEGER     CURRENT INVOCATION COUNT FOR CALCA.  IF PHI CANNOT */
/*                    BE EVALUATED AT ALF (E.G. BECAUSE AN ARGUMENT TO */
/*                    AN INTRINSIC FUNCTION IS OUT OF RANGE), THEN CALCA */
/*                    SHOULD SIMPLY SET NF TO 0 AND RETURN.  THIS */
/*                    TELLS THE ALGORITHM TO TRY A SMALLER STEP. */

/* UIPARM,URPARM,UFPARM ARE AS DESCRIBED ABOVE */

/* N.B. THE DEPENDENT VARIABLE T IS NOT EXPLICITLY PASSED.  IF REQUIRED, */
/* IT MAY BE PASSED IN UIPARM OR URPARM OR STORED IN NAMED COMMON. */


/* PARAMETERS FOR CALCB(N,P,L,ALF,NF,DER, UIPARM,URPARM,UFPARM) */

/* N,P,L,ALF,NF,UIPARM,URPARM,UFPARM ARE AS FOR CALCA */

/* DER   D.P. ARRAY   N*M ARRAY, WHERE M IS THE NUMBER OF ONES IN INC. */
/*                    CALCB MUST SET DER TO THE DERIVATIVES OF THE MODEL */
/*                    WITH RESPECT TO ALF.  IF THE MODEL HAS K TERMS THAT */
/*                    DEPEND ON ALF(I), THEN DER WILL HAVE K CONSECUTIVE */
/*                    COLUMNS OF DERIVATIVES WITH RESPECT TO ALF(I).  THE */
/*                    COLUMNS OF DER CORRESPOND TO THE ONES IN INC WHEN */
/*                    ONE TRAVELS THROUGH INC BY COLUMNS.  FOR EXAMPLE, */
/*                    IF INC HAS THE FORM... */
/*                      1  1  0 */
/*                      0  1  0 */
/*                      1  0  0 */
/*                      0  0  1 */
/*                    THEN THE FIRST TWO COLUMNS OF DER ARE FOR THE */
/*                    DERIVATIVES OF COLUMNS 1 AND 3 OF PHI WITH RESPECT */
/*                    TO ALF(1), COLUMNS 3 AND 4 OF DER ARE FOR THE */
/*                    DERIVATIVES OF COLUMNS 1 AND 2 OF PHI WITH RESPECT */
/*                    TO ALF(2), AND COLUMN 5 OF DER IS FOR THE DERIVA- */
/*                    TIVE OF COLUMN 4 OF PHI WITH RESPECT TO ALF(3). */
/*                    MORE SPECIFICALLY, DER(I,2) IS FOR THE DERIVATIVE */
/*                    OF PHI(I,3) WITH RESPECT TO ALF(1) AND DER(I,5) IS */
/*                    FOR THE DERIVATIVE OF PHI(I,4) WITH RESPECT TO */
/*                    ALF(3) (FOR I = 1,2,...,N). */
/*                       THE VALUE OF ALF PASSED TO CALCB IS THE SAME AS */
/*                    THAT PASSED TO CALCA THE LAST TIME IT WAS CALLED. */
/*                    (IF DER CANNOT BE EVALUATED, THEN CALCB SHOULD SET */
/*                    NF TO 0.  THIS WILL CAUSE AN ERROR RETURN.) */

/* N.B. DER IS FOR DERIVATIVES WITH RESPECT TO ALF, NOT T. */

/* ------------------------------  NOTES  ------------------------------- */

/*      THIS PROGRAM WAS WRITTEN BY LINDA KAUFMAN AT BELL LABS, MURRAY */
/* HILL, N.J. IN 1977 AND EXTENSIVELY REVISED BY HER AND DAVID GAY IN */
/* 1980, 1981, 1983, 1984.  THE WORK OF DAVID GAY WAS SUPPORTED IN PART */
/* BY NATIONAL SCIENCE FOUNDATION GRANT MCS-7906671. */

/* --------------------------  DECLARATIONS  ---------------------------- */


/*  ***  EXTERNAL SUBROUTINES  *** */


/* IVSET.... PROVIDES DEFAULT IV AND V VALUES. */
/*  RNSGB... CARRIES OUT NL2SOL ALGORITHM. */

/*  ***  LOCAL VARIABLES  *** */


/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA AMAT/113/, DAMAT/114/, IN/112/, IVNEED/3/, L1SAV/111/, */
/*    1     MSAVE/115/, NEXTIV/46/, NEXTV/47/, NFCALL/6/, NFGCAL/7/, */
/*    2     PERM/58/, TOOBIG/2/, VNEED/4/ */
/* /7 */
/* / */

/* ++++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++ */

    /* Parameter adjustments */
    --y;
    b -= 3;
    --alf;
    --c__;
    inc_dim1 = *iinc;
    inc_offset = 1 + inc_dim1;
    inc -= inc_offset;
    --iv;
    --v;
    --uiparm;
    --urparm;

    /* Function Body */
    if (iv[1] == 0) {
	ivset_(&c__1, &iv[1], liv, lv, &v[1]);
    }
    if (*p <= 0 || *l < 0 || *iinc <= *l) {
	goto L50;
    }
    iv1 = iv[1];
    if (iv1 == 14) {
	goto L90;
    }
    if (iv1 > 2 && iv1 < 12) {
	goto L90;
    }
    if (iv1 == 12) {
	iv[1] = 13;
    }
    if (iv[1] != 13) {
	goto L60;
    }
    if (iv[58] <= 115) {
	iv[58] = 116;
    }
    lp1 = *l + 1;
    l1 = 0;
    m = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	m0 = m;
	if (*l == 0) {
	    goto L20;
	}
	i__2 = *l;
	for (k = 1; k <= i__2; ++k) {
	    if (inc[k + i__ * inc_dim1] < 0 || inc[k + i__ * inc_dim1] > 1) {
		goto L50;
	    }
	    if (inc[k + i__ * inc_dim1] == 1) {
		++m;
	    }
/* L10: */
	}
L20:
	if (inc[lp1 + i__ * inc_dim1] != 1) {
	    goto L30;
	}
	++m;
	l1 = 1;
L30:
	if (m == m0 || inc[lp1 + i__ * inc_dim1] < 0 || inc[lp1 + i__ * 
		inc_dim1] > 1) {
	    goto L50;
	}
/* L40: */
    }

    iv[3] += m << 1;
    l1 = *l + l1;
    iv[4] += *n * (l1 + m);
    goto L60;

L50:
    iv[1] = 66;

L60:
    rnsgb_(&v[1], &alf[1], &b[3], &c__[1], &v[1], &iv[1], &iv[1], l, &c__1, n,
	     liv, lv, n, &m, p, &v[1], &y[1]);
    if (iv[1] != 14) {
	goto L999;
    }

/*  ***  STORAGE ALLOCATION  *** */

    iv[112] = iv[46];
    iv[46] = iv[112] + (m << 1);
    iv[113] = iv[47];
    iv[114] = iv[113] + *n * l1;
    iv[47] = iv[114] + *n * m;
    iv[111] = l1;
    iv[115] = m;

/*  ***  SET UP IN ARRAY  *** */

    in1 = iv[112];
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	i__2 = lp1;
	for (k = 1; k <= i__2; ++k) {
	    if (inc[k + i__ * inc_dim1] == 0) {
		goto L70;
	    }
	    iv[in1] = i__;
	    iv[in1 + 1] = k;
	    in1 += 2;
L70:
	    ;
	}
/* L80: */
    }
    if (iv1 == 13) {
	goto L999;
    }

L90:
    a1 = iv[113];
    da1 = iv[114];
    in1 = iv[112];
    l1 = iv[111];
    m = iv[115];

L100:
    rnsgb_(&v[a1], &alf[1], &b[3], &c__[1], &v[da1], &iv[in1], &iv[1], l, &l1,
	     n, liv, lv, n, &m, p, &v[1], &y[1]);
    if ((i__1 = iv[1] - 2) < 0) {
	goto L110;
    } else if (i__1 == 0) {
	goto L120;
    } else {
	goto L999;
    }

/*  ***  NEW FUNCTION VALUE (R VALUE) NEEDED  *** */

L110:
    nf = iv[6];
    (*calca)(n, p, l, &alf[1], &nf, &v[a1], &uiparm[1], &urparm[1], (U_fp)
	    ufparm);
    if (nf <= 0) {
	iv[2] = 1;
    }
    goto L100;

/*  ***  COMPUTE DR = GRADIENT OF R COMPONENTS  *** */

L120:
    (*calcb)(n, p, l, &alf[1], &iv[7], &v[da1], &uiparm[1], &urparm[1], (U_fp)
	    ufparm);
    if (iv[7] == 0) {
	iv[2] = 1;
    }
    goto L100;

L999:
    return 0;

/*  ***  LAST CARD OF   NSGB FOLLOWS  *** */
} /* nsgb_ */

