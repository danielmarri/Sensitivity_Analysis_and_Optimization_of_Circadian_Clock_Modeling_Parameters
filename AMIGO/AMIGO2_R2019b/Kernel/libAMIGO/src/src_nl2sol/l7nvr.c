/* l7nvr.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int l7nvr_(integer *n, real *lin, real *l)
{
    /* System generated locals */
    integer i__1, i__2, i__3;

    /* Local variables */
    static integer i__, k;
    static real t;
    static integer j0, j1, k0, ii, jj, im1, np1;


/*  ***  COMPUTE  LIN = L**-1,  BOTH  N X N  LOWER TRIANG. STORED   *** */
/*  ***  COMPACTLY BY ROWS.  LIN AND L MAY SHARE THE SAME STORAGE.  *** */

/*  ***  PARAMETERS  *** */

/*     DIMENSION L(N*(N+1)/2), LIN(N*(N+1)/2) */

/*  ***  LOCAL VARIABLES  *** */

/* /6 */
/*     DATA ONE/1.E+0/, ZERO/0.E+0/ */
/* /7 */
/* / */

/*  ***  BODY  *** */

    /* Parameter adjustments */
    --l;
    --lin;

    /* Function Body */
    np1 = *n + 1;
    j0 = *n * np1 / 2;
    i__1 = *n;
    for (ii = 1; ii <= i__1; ++ii) {
	i__ = np1 - ii;
	lin[j0] = 1.f / l[j0];
	if (i__ <= 1) {
	    goto L999;
	}
	j1 = j0;
	im1 = i__ - 1;
	i__2 = im1;
	for (jj = 1; jj <= i__2; ++jj) {
	    t = 0.f;
	    j0 = j1;
	    k0 = j1 - jj;
	    i__3 = jj;
	    for (k = 1; k <= i__3; ++k) {
		t -= l[k0] * lin[j0];
		--j0;
		k0 = k0 + k - i__;
/* L10: */
	    }
	    lin[j0] = t / l[k0];
/* L20: */
	}
	--j0;
/* L30: */
    }
L999:
    return 0;
/*  ***  LAST CARD OF  L7NVR FOLLOWS  *** */
} /* l7nvr_ */

