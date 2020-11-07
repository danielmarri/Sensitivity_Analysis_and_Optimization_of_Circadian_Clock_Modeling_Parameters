/* h2rfa.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int h2rfa_(integer *n, real *a, real *b, real *x, real *y, 
	real *z__)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__;
    static real t;


/*  ***  APPLY 2X2 HOUSEHOLDER REFLECTION DETERMINED BY X, Y, Z TO */
/*  ***  N-VECTORS A, B  *** */

    /* Parameter adjustments */
    --b;
    --a;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	t = a[i__] * *x + b[i__] * *y;
	a[i__] += t;
	b[i__] += t * *z__;
/* L10: */
    }
/* L999: */
    return 0;
/*  ***  LAST LINE OF  H2RFA FOLLOWS  *** */
} /* h2rfa_ */

