/* w7zbf.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int w7zbf_(real *l, integer *n, real *s, real *w, real *y, 
	real *z__)
{
    /* System generated locals */
    integer i__1;

    /* Builtin functions */
    double sqrt(doublereal);

    /* Local variables */
    static integer i__;
    static real cs, cy, ys, shs;
    extern /* Subroutine */ int l7ivm_(integer *, real *, real *, real *);
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int l7tvm_(integer *, real *, real *, real *);
    static real theta, epsrt;


/*  ***  COMPUTE  Y  AND  Z  FOR   L7UPD  CORRESPONDING TO BFGS UPDATE. */

/*     DIMENSION L(N*(N+1)/2) */

/* --------------------------  PARAMETER USAGE  -------------------------- */

/* L (I/O) CHOLESKY FACTOR OF HESSIAN, A LOWER TRIANG. MATRIX STORED */
/*             COMPACTLY BY ROWS. */
/* N (INPUT) ORDER OF  L  AND LENGTH OF  S,  W,  Y,  Z. */
/* S (INPUT) THE STEP JUST TAKEN. */
/* W (OUTPUT) RIGHT SINGULAR VECTOR OF RANK 1 CORRECTION TO L. */
/* Y (INPUT) CHANGE IN GRADIENTS CORRESPONDING TO S. */
/* Z (OUTPUT) LEFT SINGULAR VECTOR OF RANK 1 CORRECTION TO L. */

/* -------------------------------  NOTES  ------------------------------- */

/*  ***  ALGORITHM NOTES  *** */

/*        WHEN  S  IS COMPUTED IN CERTAIN WAYS, E.G. BY  GQTSTP  OR */
/*     DBLDOG,  IT IS POSSIBLE TO SAVE N**2/2 OPERATIONS SINCE  (L**T)*S */
/*     OR  L*(L**T)*S IS THEN KNOWN. */
/*        IF THE BFGS UPDATE TO L*(L**T) WOULD REDUCE ITS DETERMINANT TO */
/*     LESS THAN EPS TIMES ITS OLD VALUE, THEN THIS ROUTINE IN EFFECT */
/*     REPLACES  Y  BY  THETA*Y + (1 - THETA)*L*(L**T)*S,  WHERE  THETA */
/*     (BETWEEN 0 AND 1) IS CHOSEN TO MAKE THE REDUCTION FACTOR = EPS. */

/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY (FALL 1979). */
/*     THIS SUBROUTINE WAS WRITTEN IN CONNECTION WITH RESEARCH SUPPORTED */
/*     BY THE NATIONAL SCIENCE FOUNDATION UNDER GRANTS MCS-7600324 AND */
/*     MCS-7906671. */

/* ------------------------  EXTERNAL QUANTITIES  ------------------------ */

/*  ***  FUNCTIONS AND SUBROUTINES CALLED  *** */

/*  D7TPR RETURNS INNER PRODUCT OF TWO VECTORS. */
/*  L7IVM MULTIPLIES L**-1 TIMES A VECTOR. */
/*  L7TVM MULTIPLIES L**T TIMES A VECTOR. */

/*  ***  INTRINSIC FUNCTIONS  *** */
/* /+ */
/* / */
/* --------------------------  LOCAL VARIABLES  -------------------------- */


/*  ***  DATA INITIALIZATIONS  *** */

/* /6 */
/*     DATA EPS/0.1E+0/, ONE/1.E+0/ */
/* /7 */
/* / */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    /* Parameter adjustments */
    --l;
    --z__;
    --y;
    --w;
    --s;

    /* Function Body */
    l7tvm_(n, &w[1], &l[1], &s[1]);
    shs = d7tpr_(n, &w[1], &w[1]);
    ys = d7tpr_(n, &y[1], &s[1]);
    if (ys >= shs * .1f) {
	goto L10;
    }
    theta = shs * .90000000000000002f / (shs - ys);
    epsrt = sqrt(.1f);
    cy = theta / (shs * epsrt);
    cs = ((theta - 1.f) / epsrt + 1.f) / shs;
    goto L20;
L10:
    cy = 1.f / (sqrt(ys) * sqrt(shs));
    cs = 1.f / shs;
L20:
    l7ivm_(n, &z__[1], &l[1], &y[1]);
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L30: */
	z__[i__] = cy * z__[i__] - cs * w[i__];
    }

/* L999: */
    return 0;
/*  ***  LAST CARD OF  W7ZBF FOLLOWS  *** */
} /* w7zbf_ */

