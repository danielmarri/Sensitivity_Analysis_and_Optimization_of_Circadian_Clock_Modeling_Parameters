/* drmnfb.f -- translated by f2c (version 20100827).
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

static integer c__2 = 2;
static doublereal c_b9 = 0.;

/* Subroutine */ int drmnfb_(doublereal *b, doublereal *d__, doublereal *fx, 
	integer *iv, integer *liv, integer *lv, integer *p, doublereal *v, 
	doublereal *x)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, j, k, w, g1, iv1, ipi, alpha, alpha0;
    extern /* Subroutine */ int ds3grd_(doublereal *, doublereal *, 
	    doublereal *, doublereal *, doublereal *, doublereal *, integer *,
	     integer *, doublereal *, doublereal *);
    extern doublereal dd7tpr_(integer *, doublereal *, doublereal *);
    extern /* Subroutine */ int dv7scp_(integer *, doublereal *, doublereal *)
	    , drmngb_(doublereal *, doublereal *, doublereal *, doublereal *, 
	    integer *, integer *, integer *, integer *, doublereal *, 
	    doublereal *), divset_(integer *, integer *, integer *, integer *,
	     doublereal *);


/*  ***  ITERATION DRIVER FOR  DMNF... */
/*  ***  MINIMIZE GENERAL UNCONSTRAINED OBJECTIVE FUNCTION USING */
/*  ***  FINITE-DIFFERENCE GRADIENTS AND SECANT HESSIAN APPROXIMATIONS. */

/*     DIMENSION IV(59 + P), V(77 + P*(P+23)/2) */

/*  ***  PURPOSE  *** */

/*        THIS ROUTINE INTERACTS WITH SUBROUTINE  DRMNGB  IN AN ATTEMPT */
/*     TO FIND AN P-VECTOR  X*  THAT MINIMIZES THE (UNCONSTRAINED) */
/*     OBJECTIVE FUNCTION  FX = F(X)  COMPUTED BY THE CALLER.  (OFTEN */
/*     THE  X*  FOUND IS A LOCAL MINIMIZER RATHER THAN A GLOBAL ONE.) */

/*  ***  PARAMETERS  *** */

/*        THE PARAMETERS FOR DRMNFB ARE THE SAME AS THOSE FOR  DMNG */
/*     (WHICH SEE), EXCEPT THAT CALCF, CALCG, UIPARM, URPARM, AND UFPARM */
/*     ARE OMITTED, AND A PARAMETER  FX  FOR THE OBJECTIVE FUNCTION */
/*     VALUE AT X IS ADDED.  INSTEAD OF CALLING CALCG TO OBTAIN THE */
/*     GRADIENT OF THE OBJECTIVE FUNCTION AT X, DRMNFB CALLS DS3GRD, */
/*     WHICH COMPUTES AN APPROXIMATION TO THE GRADIENT BY FINITE */
/*     (FORWARD AND CENTRAL) DIFFERENCES USING THE METHOD OF REF. 1. */
/*     THE FOLLOWING INPUT COMPONENT IS OF INTEREST IN THIS REGARD */
/*     (AND IS NOT DESCRIBED IN  DMNG). */

/* V(ETA0)..... V(42) IS AN ESTIMATED BOUND ON THE RELATIVE ERROR IN THE */
/*             OBJECTIVE FUNCTION VALUE COMPUTED BY CALCF... */
/*                  (TRUE VALUE) = (COMPUTED VALUE) * (1 + E), */
/*             WHERE ABS(E) .LE. V(ETA0).  DEFAULT = MACHEP * 10**3, */
/*             WHERE MACHEP IS THE UNIT ROUNDOFF. */

/*        THE OUTPUT VALUES IV(NFCALL) AND IV(NGCALL) HAVE DIFFERENT */
/*     MEANINGS FOR  DMNF THAN FOR  DMNG... */

/* IV(NFCALL)... IV(6) IS THE NUMBER OF CALLS SO FAR MADE ON CALCF (I.E., */
/*             FUNCTION EVALUATIONS) EXCLUDING THOSE MADE ONLY FOR */
/*             COMPUTING GRADIENTS.  THE INPUT VALUE IV(MXFCAL) IS A */
/*             LIMIT ON IV(NFCALL). */
/* IV(NGCALL)... IV(30) IS THE NUMBER OF FUNCTION EVALUATIONS MADE ONLY */
/*             FOR COMPUTING GRADIENTS.  THE TOTAL NUMBER OF FUNCTION */
/*             EVALUATIONS IS THUS  IV(NFCALL) + IV(NGCALL). */

/*  ***  REFERENCES  *** */

/* 1. STEWART, G.W. (1967), A MODIFICATION OF DAVidoN*S MINIMIZATION */
/*        METHOD TO ACCEPT DIFFERENCE APPROXIMATIONS OF DERIVATIVES, */
/*        J. ASSOC. COMPUT. MACH. 14, PP. 72-83. */
/* . */
/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY (AUGUST 1982). */

/* ----------------------------  DECLARATIONS  --------------------------- */


/* DIVSET.... SUPPLIES DEFAULT PARAMETER VALUES. */
/* DD7TPR... RETURNS INNER PRODUCT OF TWO VECTORS. */
/* DS3GRD... COMPUTES FINITE-DIFFERENCE GRADIENT APPROXIMATION. */
/* DRMNGB... REVERSE-COMMUNICATION ROUTINE THAT DOES  DMNGB ALGORITHM. */
/* DV7SCP... SETS ALL ELEMENTS OF A VECTOR TO A SCALAR. */


/*  ***  SUBSCRIPTS FOR IV   *** */


/* /6 */
/*     DATA ETA0/42/, F/10/, G/28/, LMAT/42/, NEXTV/47/, NGCALL/30/, */
/*    1     NITER/31/, PERM/58/, SGIRC/57/, TOOBIG/2/, VNEED/4/ */
/* /7 */
/* / */
/* /6 */
/*     DATA ZERO/0.D+0/ */
/* /7 */
/* / */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    /* Parameter adjustments */
    --iv;
    --v;
    --x;
    --d__;
    b -= 3;

    /* Function Body */
    iv1 = iv[1];
    if (iv1 == 1) {
	goto L10;
    }
    if (iv1 == 2) {
	goto L50;
    }
    if (iv[1] == 0) {
	divset_(&c__2, &iv[1], liv, lv, &v[1]);
    }
    iv1 = iv[1];
    if (iv1 == 12 || iv1 == 13) {
	iv[4] = iv[4] + (*p << 1) + 6;
    }
    if (iv1 == 14) {
	goto L10;
    }
    if (iv1 > 2 && iv1 < 12) {
	goto L10;
    }
    g1 = 1;
    if (iv1 == 12) {
	iv[1] = 13;
    }
    goto L20;

L10:
    g1 = iv[28];

L20:
    drmngb_(&b[3], &d__[1], fx, &v[g1], &iv[1], liv, lv, p, &v[1], &x[1]);
    if ((i__1 = iv[1] - 2) < 0) {
	goto L999;
    } else if (i__1 == 0) {
	goto L30;
    } else {
	goto L80;
    }

/*  ***  COMPUTE GRADIENT  *** */

L30:
    if (iv[31] == 0) {
	dv7scp_(p, &v[g1], &c_b9);
    }
    j = iv[42];
    alpha0 = g1 - *p - 1;
    ipi = iv[58];
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	k = alpha0 + iv[ipi];
	v[k] = dd7tpr_(&i__, &v[j], &v[j]);
	++ipi;
	j += i__;
/* L40: */
    }
/*     ***  UNDO INCREMENT OF IV(NGCALL) DONE BY DRMNGB  *** */
    --iv[30];
/*     ***  STORE RETURN CODE FROM DS3GRD IN IV(SGIRC)  *** */
    iv[57] = 0;
/*     ***  X MAY HAVE BEEN RESTORED, SO COPY BACK FX... *** */
    *fx = v[10];
    goto L60;

/*     ***  GRADIENT LOOP  *** */

L50:
    if (iv[2] != 0) {
	goto L10;
    }

L60:
    g1 = iv[28];
    alpha = g1 - *p;
    w = alpha - 6;
    ds3grd_(&v[alpha], &b[3], &d__[1], &v[42], fx, &v[g1], &iv[57], p, &v[w], 
	    &x[1]);
    i__ = iv[57];
    if (i__ == 0) {
	goto L10;
    }
    if (i__ <= *p) {
	goto L70;
    }
    iv[2] = 1;
    goto L10;

L70:
    ++iv[30];
    goto L999;

L80:
    if (iv[1] != 14) {
	goto L999;
    }

/*  ***  STORAGE ALLOCATION  *** */

    iv[28] = iv[47] + *p + 6;
    iv[47] = iv[28] + *p;
    if (iv1 != 13) {
	goto L10;
    }

L999:
    return 0;
/*  ***  LAST CARD OF DRMNFB FOLLOWS  *** */
} /* drmnfb_ */

