/* d7tpr.f -- translated by f2c (version 20100827).
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

doublereal d7tpr_(integer *p, real *x, real *y)
{
    /* Initialized data */

    static real sqteta = 0.f;

    /* System generated locals */
    integer i__1;
    real ret_val, r__1, r__2, r__3, r__4;

    /* Local variables */
    static integer i__;
    static real t;
    extern doublereal r7mdc_(integer *);


/*  ***  RETURN THE INNER PRODUCT OF THE P-VECTORS X AND Y.  *** */



/*  ***   R7MDC(2) RETURNS A MACHINE-DEPENDENT CONSTANT, SQTETA, WHICH */
/*  ***  IS SLIGHTLY LARGER THAN THE SMALLEST POSITIVE NUMBER THAT */
/*  ***  CAN BE SQUARED WITHOUT UNDERFLOWING. */

/* /6 */
/*     DATA ONE/1.E+0/, SQTETA/0.E+0/, ZERO/0.E+0/ */
/* /7 */
    /* Parameter adjustments */
    --y;
    --x;

    /* Function Body */
/* / */

    ret_val = 0.f;
    if (*p <= 0) {
	goto L999;
    }
    if (sqteta == 0.f) {
	sqteta = r7mdc_(&c__2);
    }
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* Computing MAX */
	r__3 = (r__1 = x[i__], dabs(r__1)), r__4 = (r__2 = y[i__], dabs(r__2))
		;
	t = dmax(r__3,r__4);
	if (t > 1.f) {
	    goto L10;
	}
	if (t < sqteta) {
	    goto L20;
	}
	t = x[i__] / sqteta * y[i__];
	if (dabs(t) < sqteta) {
	    goto L20;
	}
L10:
	ret_val += x[i__] * y[i__];
L20:
	;
    }

L999:
    return ret_val;
/*  ***  LAST LINE OF  D7TPR FOLLOWS  *** */
} /* d7tpr_ */

