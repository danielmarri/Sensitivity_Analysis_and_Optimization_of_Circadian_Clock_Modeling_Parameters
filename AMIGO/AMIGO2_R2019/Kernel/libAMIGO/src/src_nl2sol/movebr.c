/* movebr.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int movebr_(integer *n, real *a, real *b)
{
    static integer i__;


/*     MOVEBR MOVES N REAL ITEMS FROM A TO B */
/*     USING A BACKWARDS DO LOOP */


    /* Parameter adjustments */
    --b;
    --a;

    /* Function Body */
    i__ = *n;

L10:
    if (i__ <= 0) {
	return 0;
    }
    b[i__] = a[i__];
    --i__;
    goto L10;

} /* movebr_ */

