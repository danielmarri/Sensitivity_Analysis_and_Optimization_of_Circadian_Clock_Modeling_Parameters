/* v2nrm.f -- translated by f2c (version 20100827).
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

doublereal v2nrm_(integer *p, real *x)
{
    /* Initialized data */

    static real sqteta = 0.f;

    /* System generated locals */
    integer i__1;
    real ret_val, r__1;

    /* Builtin functions */
    double sqrt(doublereal);

    /* Local variables */
    static integer i__, j;
    static real r__, t, xi;
    extern doublereal r7mdc_(integer *);
    static real scale;


/*  ***  RETURN THE 2-NORM OF THE P-VECTOR X, TAKING  *** */
/*  ***  CARE TO AVOID THE MOST LIKELY UNDERFLOWS.    *** */


/* /+ */
/* / */

/* /6 */
/*     DATA ONE/1.E+0/, ZERO/0.E+0/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --x;

    /* Function Body */

    if (*p > 0) {
	goto L10;
    }
    ret_val = 0.f;
    goto L999;
L10:
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	if (x[i__] != 0.f) {
	    goto L30;
	}
/* L20: */
    }
    ret_val = 0.f;
    goto L999;

L30:
    scale = (r__1 = x[i__], dabs(r__1));
    if (i__ < *p) {
	goto L40;
    }
    ret_val = scale;
    goto L999;
L40:
    t = 1.f;
    if (sqteta == 0.f) {
	sqteta = r7mdc_(&c__2);
    }

/*     ***  SQTETA IS (SLIGHTLY LARGER THAN) THE SQUARE ROOT OF THE */
/*     ***  SMALLEST POSITIVE FLOATING POINT NUMBER ON THE MACHINE. */
/*     ***  THE TESTS INVOLVING SQTETA ARE DONE TO PREVENT UNDERFLOWS. */

    j = i__ + 1;
    i__1 = *p;
    for (i__ = j; i__ <= i__1; ++i__) {
	xi = (r__1 = x[i__], dabs(r__1));
	if (xi > scale) {
	    goto L50;
	}
	r__ = xi / scale;
	if (r__ > sqteta) {
	    t += r__ * r__;
	}
	goto L60;
L50:
	r__ = scale / xi;
	if (r__ <= sqteta) {
	    r__ = 0.f;
	}
	t = t * r__ * r__ + 1.f;
	scale = xi;
L60:
	;
    }

    ret_val = scale * sqrt(t);
L999:
    return ret_val;
/*  ***  LAST LINE OF  V2NRM FOLLOWS  *** */
} /* v2nrm_ */

