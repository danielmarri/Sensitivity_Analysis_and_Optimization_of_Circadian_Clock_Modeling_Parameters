/* rldst.f -- translated by f2c (version 20100827).
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

doublereal rldst_(integer *p, real *d__, real *x, real *x0)
{
    /* System generated locals */
    integer i__1;
    real ret_val, r__1, r__2;

    /* Local variables */
    static integer i__;
    static real t, emax, xmax;


/*  ***  COMPUTE AND RETURN RELATIVE DIFFERENCE BETWEEN X AND X0  *** */
/*  ***  NL2SOL VERSION 2.2  *** */


/* /6 */
/*     DATA ZERO/0.E+0/ */
/* /7 */
/* / */

/*  ***  BODY  *** */

    /* Parameter adjustments */
    --x0;
    --x;
    --d__;

    /* Function Body */
    emax = 0.f;
    xmax = 0.f;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	t = (r__1 = d__[i__] * (x[i__] - x0[i__]), dabs(r__1));
	if (emax < t) {
	    emax = t;
	}
	t = d__[i__] * ((r__1 = x[i__], dabs(r__1)) + (r__2 = x0[i__], dabs(
		r__2)));
	if (xmax < t) {
	    xmax = t;
	}
/* L10: */
    }
    ret_val = 0.f;
    if (xmax > 0.f) {
	ret_val = emax / xmax;
    }
/* L999: */
    return ret_val;
/*  ***  LAST CARD OF  RLDST FOLLOWS  *** */
} /* rldst_ */

