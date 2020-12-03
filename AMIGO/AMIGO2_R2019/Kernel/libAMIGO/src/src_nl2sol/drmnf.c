/* drmnf.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int drmnf_(doublereal *d__, doublereal *fx, integer *iv, 
	integer *liv, integer *lv, integer *n, doublereal *v, doublereal *x)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, j, k, w, g1, iv1, alpha;
    extern /* Subroutine */ int drmng_(doublereal *, doublereal *, doublereal 
	    *, integer *, integer *, integer *, integer *, doublereal *, 
	    doublereal *), ds7grd_(doublereal *, doublereal *, doublereal *, 
	    doublereal *, doublereal *, integer *, integer *, doublereal *, 
	    doublereal *);
    extern doublereal dd7tpr_(integer *, doublereal *, doublereal *);
    extern /* Subroutine */ int dv7scp_(integer *, doublereal *, doublereal *)
	    , divset_(integer *, integer *, integer *, integer *, doublereal *
	    );


/*  ***  ITERATION DRIVER FOR  DMNF... */
/*  ***  MINIMIZE GENERAL UNCONSTRAINED OBJECTIVE FUNCTION USING */
/*  ***  FINITE-DIFFERENCE GRADIENTS AND SECANT HESSIAN APPROXIMATIONS. */

/*     DIMENSION V(77 + N*(N+17)/2) */

/*  ***  PURPOSE  *** */

/*        THIS ROUTINE INTERACTS WITH SUBROUTINE  DRMNG  IN AN ATTEMPT */
/*     TO FIND AN N-VECTOR  X*  THAT MINIMIZES THE (UNCONSTRAINED) */
/*     OBJECTIVE FUNCTION  FX = F(X)  COMPUTED BY THE CALLER.  (OFTEN */
/*     THE  X*  FOUND IS A LOCAL MINIMIZER RATHER THAN A GLOBAL ONE.) */

/*  ***  PARAMETERS  *** */

/*        THE PARAMETERS FOR DRMNF ARE THE SAME AS THOSE FOR  DMNG */
/*     (WHICH SEE), EXCEPT THAT CALCF, CALCG, UIPARM, URPARM, AND UFPARM */
/*     ARE OMITTED, AND A PARAMETER  FX  FOR THE OBJECTIVE FUNCTION */
/*     VALUE AT X IS ADDED.  INSTEAD OF CALLING CALCG TO OBTAIN THE */
/*     GRADIENT OF THE OBJECTIVE FUNCTION AT X, DRMNF CALLS DS7GRD, */
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
/* DS7GRD... COMPUTES FINITE-DIFFERENCE GRADIENT APPROXIMATION. */
/* DRMNG.... REVERSE-COMMUNICATION ROUTINE THAT DOES  DMNG ALGORITHM. */
/* DV7SCP... SETS ALL ELEMENTS OF A VECTOR TO A SCALAR. */


/*  ***  SUBSCRIPTS FOR IV   *** */


/* /6 */
/*     DATA ETA0/42/, F/10/, G/28/, LMAT/42/, NEXTV/47/, NGCALL/30/, */
/*    1     NITER/31/, SGIRC/57/, TOOBIG/2/, VNEED/4/ */
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
	iv[4] = iv[4] + (*n << 1) + 6;
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
    drmng_(&d__[1], fx, &v[g1], &iv[1], liv, lv, n, &v[1], &x[1]);
    if ((i__1 = iv[1] - 2) < 0) {
	goto L999;
    } else if (i__1 == 0) {
	goto L30;
    } else {
	goto L70;
    }

/*  ***  COMPUTE GRADIENT  *** */

L30:
    if (iv[31] == 0) {
	dv7scp_(n, &v[g1], &c_b9);
    }
    j = iv[42];
    k = g1 - *n;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[k] = dd7tpr_(&i__, &v[j], &v[j]);
	++k;
	j += i__;
/* L40: */
    }
/*     ***  UNDO INCREMENT OF IV(NGCALL) DONE BY DRMNG  *** */
    --iv[30];
/*     ***  STORE RETURN CODE FROM DS7GRD IN IV(SGIRC)  *** */
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
    alpha = g1 - *n;
    w = alpha - 6;
    ds7grd_(&v[alpha], &d__[1], &v[42], fx, &v[g1], &iv[57], n, &v[w], &x[1]);
    if (iv[57] == 0) {
	goto L10;
    }
    ++iv[30];
    goto L999;

L70:
    if (iv[1] != 14) {
	goto L999;
    }

/*  ***  STORAGE ALLOCATION  *** */

    iv[28] = iv[47] + *n + 6;
    iv[47] = iv[28] + *n;
    if (iv1 != 13) {
	goto L10;
    }

L999:
    return 0;
/*  ***  LAST CARD OF DRMNF FOLLOWS  *** */
} /* drmnf_ */

