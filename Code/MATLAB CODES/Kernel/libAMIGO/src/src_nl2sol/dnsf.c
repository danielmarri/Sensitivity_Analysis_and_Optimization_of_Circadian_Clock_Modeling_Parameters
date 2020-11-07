/* dnsf.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int dnsf_(integer *n, integer *p, integer *l, doublereal *
	alf, doublereal *c__, doublereal *y, S_fp calca, integer *inc, 
	integer *iinc, integer *iv, integer *liv, integer *lv, doublereal *v, 
	integer *uiparm, doublereal *urparm, U_fp ufparm)
{
    /* Initialized data */

    static doublereal negone = -1.;
    static doublereal one = 1.;
    static doublereal zero = 0.;

    /* System generated locals */
    integer inc_dim1, inc_offset, i__1, i__2, i__3;
    doublereal d__1, d__2;

    /* Local variables */
    static doublereal h__;
    static integer i__, k, m, a0, a1, d0, i1, j1, l1, m0, aj;
    static doublereal di;
    static integer nf, ng;
    static doublereal xi;
    static integer da0, da1, in0, in1, in2, jn1, lp1, iv1, x0i, daj, ini;
    extern /* Subroutine */ int dsm_(integer *, integer *, integer *, integer 
	    *, integer *, integer *, integer *, integer *, integer *, integer 
	    *, integer *, integer *, integer *, integer *);
    static integer bwa1, alp1, iwa1, grp1, grp2, ngrp0, ngrp1, ngrp2, gptr1;
    static doublereal delta;
    static integer inlen;
    extern /* Subroutine */ int drnsg_(doublereal *, doublereal *, doublereal 
	    *, doublereal *, integer *, integer *, integer *, integer *, 
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    doublereal *, doublereal *);
    static logical partj;
    static integer rsave0, rsave1;
    extern /* Subroutine */ int dv7scl_(integer *, doublereal *, doublereal *,
	     doublereal *);
    static integer xsave0, xsave1;
    extern /* Subroutine */ int dv7cpy_(integer *, doublereal *, doublereal *)
	    , dv2axy_(integer *, doublereal *, doublereal *, doublereal *, 
	    doublereal *);
    static integer ipntr1, jpntr1, iwalen;
    extern /* Subroutine */ int divset_(integer *, integer *, integer *, 
	    integer *, doublereal *);
    static integer rsvlen;


/*  ***  SOLVE SEPARABLE NONLINEAR LEAST SQUARES USING */
/*  ***  FINITE-DIFFERENCE DERIVATIVES. */

/*  ***  PARAMETER DECLARATIONS  *** */

/* /6 */
/*     INTEGER INC(IINC,P), IV(LIV), UIPARM(1) */
/*     DOUBLE PRECISION ALF(P), C(L), URPARM(1), V(LV), Y(N) */
/* /7 */
/* / */

/*  ***  PARAMETERS  *** */

/*      N (IN)  NUMBER OF OBSERVATIONS. */
/*      P (IN)  NUMBER OF NONLINEAR PARAMETERS TO BE ESTIMATED. */
/*      L (IN)  NUMBER OF LINEAR PARAMETERS TO BE ESTIMATED. */
/*    ALF (I/O) NONLINEAR PARAMETERS. */
/*                 INPUT = INITIAL GUESS, */
/*                 OUTPUT = BEST ESTIMATE FOUND. */
/*      C (OUT) LINEAR PARAMETERS (ESTIMATED). */
/*      Y (IN)  RIGHT-HAND SIDE VECTOR. */
/*  CALCA (IN)  SUBROUTINE TO COMPUTE A MATRIX. */
/*    INC (IN)  INCIDENCE MATRIX OF DEPENDENCIES OF COLUMNS OF A ON */
/*                 COMPONENTS OF ALF -- INC(I,J) = 1 MEANS COLUMN I */
/*                 OF A DEPENDS ON ALF(J). */
/*   IINC (IN)  DECLARED LEAD DIMENSION OF INC.  MUST BE AT LEAST L+1. */
/*     IV (I/O) INTEGER PARAMETER AND SCRATCH VECTOR. */
/*    LIV (IN)  LENGTH OF IV.  MUST BE AT LEAST */
/*                 122 + 2*M + 4*P + 2*L + MAX(L+1,6*P), WHERE  M  IS */
/*                 THE NUMBER OF ONES IN INC. */
/*     LV (IN)  LENGTH OF V.  MUST BE AT LEAST */
/*                 105 + 2*N*(L+3) + JLEN + L*(L+3)/2 + P*(2*P + 18), */
/*                 WHERE  JLEN = (L+P)*(N+L+P+1),  UNLESS NEITHER A */
/*                 COVARIANCE MATRIX NOR REGRESSION DIAGNOSTICS ARE */
/*                 REQUESTED, IN WHICH CASE  JLEN = N*P.  IF THE LAST */
/*                 ROW OF INC CONTAINS ONLY ZEROS, THEN LV CAN BE 4*N */
/*                 LESS THAN JUST DESCRIBED. */
/*      V (I/O) FLOATING-POINT PARAMETER AND SCRATCH VECTOR. */
/*              IF A COVARIANCE ESTIMATE IS REQUESTED, IT IS FOR */
/*              (ALF,C) -- NONLINEAR PARAMETERS ORDERED FIRST, */
/*              FOLLOWED BY LINEAR PARAMETERS. */
/* UIPARM (I/O) INTEGER VECTOR PASSED WITHOUT CHANGE TO CALCA. */
/* URPARM (I/O) FLOATING-POINT VECTOR PASSED WITHOUT CHANGE TO CALCA. */
/* UFPARM (I/O) SUBROUTINE PASSED (WITHOUT HAVING BEEN CALLED) TO CALCA. */


/* --------------------------  DECLARATIONS  ---------------------------- */


/*  ***  EXTERNAL SUBROUTINES  *** */


/* DIVSET.... PROVIDES DEFAULT IV AND V VALUES. */
/* DSM...... DETERMINES EFFICIENT ORDER FOR FINITE DIFFERENCES. */
/*  DRNSG... CARRIES OUT NL2SOL ALGORITHM. */
/* DV2AXY.... ADDS A MULTIPLE OF ONE VECTOR TO ANOTHER. */
/* DV7CPY.... COPIES ONE VECTOR TO ANOTHER. */
/* DV7SCL... SCALES AND COPIES ONE VECTOR TO ANOTHER. */

/*  ***  LOCAL VARIABLES  *** */


/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA AMAT/113/, COVREQ/15/, D/27/, DAMAT/114/, DLTFDJ/43/, */
/*    1     GPTR/117/, GRP/118/, IN/112/, IVNEED/3/, L1SAV/111/, */
/*    2     MAXGRP/116/, MODE/35/, MSAVE/115/, NEXTIV/46/, NEXTV/47/, */
/*    3     NFCALL/6/, NFGCAL/7/, PERM/58/, RESTOR/9/, TOOBIG/2/, */
/*    4     VNEED/4/, XSAVE/119/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --y;
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

/* ++++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++ */

    lp1 = *l + 1;
    if (iv[1] == 0) {
	divset_(&c__1, &iv[1], liv, lv, &v[1]);
    }
    if (*p <= 0 || *l < 0 || *iinc <= *l) {
	goto L80;
    }
    iv1 = iv[1];
    if (iv1 == 14) {
	goto L120;
    }
    if (iv1 > 2 && iv1 < 12) {
	goto L120;
    }
    if (iv1 == 12) {
	iv[1] = 13;
    }
    if (iv[1] != 13) {
	goto L50;
    }

/*  ***  FRESH START *** */

    if (iv[58] <= 119) {
	iv[58] = 120;
    }

/*  ***  CHECK INC, COUNT ITS NONZEROS */

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
		goto L80;
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
	    goto L80;
	}
/* L40: */
    }

/*     *** NOW L1 = 1 MEANS A HAS COLUMN L+1 *** */

/*     *** COMPUTE STORAGE REQUIREMENTS *** */

/* Computing MAX */
    i__1 = lp1, i__2 = *p * 6;
    iwalen = max(i__1,i__2);
    inlen = m << 1;
    iv[3] = iv[3] + inlen + *p * 3 + *l + iwalen + 3;
    rsvlen = (l1 << 1) * *n;
    l1 = *l + l1;
    iv[4] = iv[4] + (*n << 1) * l1 + rsvlen + *p;

L50:
    drnsg_(&v[1], &alf[1], &c__[1], &v[1], &iv[1], &iv[1], l, &c__1, n, liv, 
	    lv, n, &m, p, &v[1], &y[1]);
    if (iv[1] != 14) {
	goto L999;
    }

/*  ***  STORAGE ALLOCATION  *** */

    iv[112] = iv[46];
    iv[113] = iv[47];
    iv[114] = iv[113] + *n * l1;
    iv[119] = iv[114] + *n * l1;
    iv[47] = iv[119] + *p + rsvlen;
    iv[111] = l1;
    iv[115] = m;

/*  ***  DETERMINE HOW MANY GROUPS FOR FINITE DIFFERENCES */
/*  ***  (SET UP TO CALL DSM) */

    in1 = iv[112];
    jn1 = in1 + m;
    i__1 = *p;
    for (k = 1; k <= i__1; ++k) {
	i__2 = lp1;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    if (inc[i__ + k * inc_dim1] == 0) {
		goto L60;
	    }
	    iv[in1] = i__;
	    ++in1;
	    iv[jn1] = k;
	    ++jn1;
L60:
	    ;
	}
/* L70: */
    }
    in1 = iv[112];
    jn1 = in1 + m;
    iwa1 = in1 + inlen;
    ngrp1 = iwa1 + iwalen;
    bwa1 = ngrp1 + *p;
    ipntr1 = bwa1 + *p;
    jpntr1 = ipntr1 + *l + 2;
    dsm_(&lp1, p, &m, &iv[in1], &iv[jn1], &iv[ngrp1], &ng, &k, &i__, &iv[
	    ipntr1], &iv[jpntr1], &iv[iwa1], &iwalen, &iv[bwa1]);
    if (i__ == 1) {
	goto L90;
    }
    iv[1] = 69;
    goto L50;
L80:
    iv[1] = 66;
    goto L50;

/*  ***  SET UP GRP AND GPTR ARRAYS FOR COMPUTING FINITE DIFFERENCES */

/*  ***  THERE ARE NG GROUPS.  GROUP I CONTAINS ALF(GRP(J)) FOR */
/*  ***  GPTR(I) .LE. J .LE. GPTR(I+1)-1. */

L90:
    iv[116] = ng;
    iv[117] = in1 + (l1 << 1);
    gptr1 = iv[117];
    iv[118] = gptr1 + ng + 1;
    iv[46] = iv[118] + *p;
    grp1 = iv[118];
    ngrp0 = ngrp1 - 1;
    ngrp2 = ngrp0 + *p;
    i__1 = ng;
    for (i__ = 1; i__ <= i__1; ++i__) {
	iv[gptr1] = grp1;
	++gptr1;
	i__2 = ngrp2;
	for (i1 = ngrp1; i1 <= i__2; ++i1) {
	    if (iv[i1] != i__) {
		goto L100;
	    }
	    iv[grp1] = i1 - ngrp0;
	    ++grp1;
L100:
	    ;
	}
/* L110: */
    }
    iv[gptr1] = grp1;
    if (iv1 == 13) {
	goto L999;
    }

/*  ***  INITIALIZE POINTERS  *** */

L120:
    a1 = iv[113];
    a0 = a1 - *n;
    da1 = iv[114];
    da0 = da1 - *n;
    in1 = iv[112];
    in0 = in1 - 2;
    l1 = iv[111];
    in2 = in1 + (l1 << 1) - 1;
    d0 = iv[27] - 1;
    ng = iv[116];
    xsave1 = iv[119];
    xsave0 = xsave1 - 1;
    rsave1 = xsave1 + *p;
    rsave0 = rsave1 + *n;
    alp1 = a1 + *l * *n;
    delta = v[43];
    iv[15] = -abs(iv[15]);

L130:
    drnsg_(&v[a1], &alf[1], &c__[1], &v[da1], &iv[in1], &iv[1], l, &l1, n, 
	    liv, lv, n, &l1, p, &v[1], &y[1]);
    if ((i__1 = iv[1] - 2) < 0) {
	goto L140;
    } else if (i__1 == 0) {
	goto L150;
    } else {
	goto L999;
    }

/*  ***  NEW FUNCTION VALUE (R VALUE) NEEDED  *** */

L140:
    nf = iv[6];
    (*calca)(n, p, l, &alf[1], &nf, &v[a1], &uiparm[1], &urparm[1], (U_fp)
	    ufparm);
    if (nf <= 0) {
	iv[2] = 1;
    }
    if (l1 <= *l) {
	goto L130;
    }
    if (iv[9] == 2) {
	dv7cpy_(n, &v[rsave0], &v[rsave1]);
    }
    dv7cpy_(n, &v[rsave1], &v[alp1]);
    goto L130;

/*  ***  COMPUTE DR = GRADIENT OF R COMPONENTS  *** */

L150:
    if (l1 > *l && iv[7] == iv[6]) {
	dv7cpy_(n, &v[rsave0], &v[rsave1]);
    }
    gptr1 = iv[117];
    i__1 = ng;
    for (k = 1; k <= i__1; ++k) {
	dv7cpy_(p, &v[xsave1], &alf[1]);
	grp1 = iv[gptr1];
	grp2 = iv[gptr1 + 1] - 1;
	++gptr1;
	i__2 = grp2;
	for (i1 = grp1; i1 <= i__2; ++i1) {
	    i__ = iv[i1];
	    xi = alf[i__];
	    j1 = d0 + i__;
	    di = v[j1];
	    if (di <= zero) {
		di = one;
	    }
/* Computing MAX */
	    d__1 = abs(xi), d__2 = one / di;
	    h__ = delta * max(d__1,d__2);
	    if (xi < zero) {
		h__ = -h__;
	    }
	    x0i = xsave0 + i__;
	    v[x0i] = xi + h__;
/* L160: */
	}
	(*calca)(n, p, l, &v[xsave1], &iv[7], &v[da1], &uiparm[1], &urparm[1],
		 (U_fp)ufparm);
	if (iv[7] > 0) {
	    goto L170;
	}
	iv[2] = 1;
	goto L130;
L170:
	jn1 = in1;
	i__2 = in2;
	for (i__ = in1; i__ <= i__2; ++i__) {
/* L180: */
	    iv[i__] = 0;
	}
	partj = iv[35] <= *p;
	i__2 = grp2;
	for (i1 = grp1; i1 <= i__2; ++i1) {
	    i__ = iv[i1];
	    i__3 = l1;
	    for (j1 = 1; j1 <= i__3; ++j1) {
		if (inc[j1 + i__ * inc_dim1] == 0) {
		    goto L210;
		}
		ini = in0 + (j1 << 1);
		iv[ini] = i__;
		iv[ini + 1] = j1;
		x0i = xsave0 + i__;
		h__ = one / (v[x0i] - alf[i__]);
		daj = da0 + j1 * *n;
		if (partj) {
		    goto L190;
		}
/*                 *** FULL FINITE DIFFERENCE FOR COV. AND REG. DIAG. *** */
		aj = a0 + j1 * *n;
		dv2axy_(n, &v[daj], &negone, &v[aj], &v[daj]);
		goto L200;
L190:
		if (j1 > *l) {
		    dv2axy_(n, &v[daj], &negone, &v[rsave0], &v[daj]);
		}
L200:
		dv7scl_(n, &v[daj], &h__, &v[daj]);
L210:
		;
	    }
/* L220: */
	}
	if (k >= ng) {
	    goto L240;
	}
	iv[1] = -2;
	drnsg_(&v[a1], &alf[1], &c__[1], &v[da1], &iv[in1], &iv[1], l, &l1, n,
		 liv, lv, n, &l1, p, &v[1], &y[1]);
	if (-2 != iv[1]) {
	    goto L999;
	}
/* L230: */
    }
L240:
    iv[1] = 2;
    goto L130;

L999:
    return 0;

/*  ***  LAST CARD OF   DNSF FOLLOWS  *** */
} /* dnsf_ */

