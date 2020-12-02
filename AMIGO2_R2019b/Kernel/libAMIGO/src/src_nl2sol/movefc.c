/* movefc.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int movefc_(integer *n, complex *a, complex *b)
{
    /* System generated locals */
    integer i__1, i__2, i__3;

    /* Local variables */
    static integer i__;


/*     MOVEFC MOVES N COMPLEX ITEMS FROM A TO B */
/*     USING A FORWARDS DO LOOP */

/* /R */
/*     REAL A(2,N), B(2,N) */
/* /C */
/* / */

    /* Parameter adjustments */
    --b;
    --a;

    /* Function Body */
    if (*n <= 0) {
	return 0;
    }

    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* /R */
/*       B(1,I) = A(1,I) */
/* 10     B(2,I) = A(2,I) */
/* /C */
/* L10: */
	i__2 = i__;
	i__3 = i__;
	b[i__2].r = a[i__3].r, b[i__2].i = a[i__3].i;
    }
/* / */

    return 0;

} /* movefc_ */

