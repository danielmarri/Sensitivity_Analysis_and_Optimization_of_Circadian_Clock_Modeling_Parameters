/* s7lup.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int s7lup_(real *a, real *cosmin, integer *p, real *size, 
	real *step, real *u, real *w, real *wchmtd, real *wscale, real *y)
{
    /* System generated locals */
    integer i__1, i__2;
    real r__1, r__2, r__3;

    /* Local variables */
    static integer i__, j, k;
    static real t, ui, wi;
    extern doublereal d7tpr_(integer *, real *, real *), v2nrm_(integer *, 
	    real *);
    extern /* Subroutine */ int s7lvm_(integer *, real *, real *, real *);
    static real denmin, sdotwm;


/*  ***  UPDATE SYMMETRIC  A  SO THAT  A * STEP = Y  *** */
/*  ***  (LOWER TRIANGLE OF  A  STORED ROWWISE       *** */

/*  ***  PARAMETER DECLARATIONS  *** */

/*     DIMENSION A(P*(P+1)/2) */

/*  ***  LOCAL VARIABLES  *** */


/*     ***  CONSTANTS  *** */

/*  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  *** */


/* /6 */
/*     DATA HALF/0.5E+0/, ONE/1.E+0/, ZERO/0.E+0/ */
/* /7 */
/* / */

/* ----------------------------------------------------------------------- */

    /* Parameter adjustments */
    --a;
    --y;
    --wchmtd;
    --w;
    --u;
    --step;

    /* Function Body */
    sdotwm = d7tpr_(p, &step[1], &wchmtd[1]);
    denmin = *cosmin * v2nrm_(p, &step[1]) * v2nrm_(p, &wchmtd[1]);
    *wscale = 1.f;
    if (denmin != 0.f) {
/* Computing MIN */
	r__2 = 1.f, r__3 = (r__1 = sdotwm / denmin, dabs(r__1));
	*wscale = dmin(r__2,r__3);
    }
    t = 0.f;
    if (sdotwm != 0.f) {
	t = *wscale / sdotwm;
    }
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L10: */
	w[i__] = t * wchmtd[i__];
    }
    s7lvm_(p, &u[1], &a[1], &step[1]);
    t = (*size * d7tpr_(p, &step[1], &u[1]) - d7tpr_(p, &step[1], &y[1])) * 
	    .5f;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L20: */
	u[i__] = t * w[i__] + y[i__] - *size * u[i__];
    }

/*  ***  SET  A = A + U*(W**T) + W*(U**T)  *** */

    k = 1;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	ui = u[i__];
	wi = w[i__];
	i__2 = i__;
	for (j = 1; j <= i__2; ++j) {
	    a[k] = *size * a[k] + ui * w[j] + wi * u[j];
	    ++k;
/* L30: */
	}
/* L40: */
    }

/* L999: */
    return 0;
/*  ***  LAST CARD OF  S7LUP FOLLOWS  *** */
} /* s7lup_ */

