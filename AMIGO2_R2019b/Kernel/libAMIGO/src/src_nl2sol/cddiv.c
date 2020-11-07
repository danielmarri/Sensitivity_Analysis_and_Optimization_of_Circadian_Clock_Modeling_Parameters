/* cddiv.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int cddiv_(doublereal *a, doublereal *b, doublereal *c__)
{
    static doublereal g, h__, t;


/* THIS ROUTINE DOES COMPLEX DOUBLE PRECISION */
/* DIVISION (C=A/B), FOLLOWING THE METHOD */
/* GIVEN IN ALGOL ON PAGES 357 AND 358 OF */
/* WILKINSON AND REINSCHS  BOOK- */
/* HANDBOOK FOR AUTOMATIC COMPUTATION */
/* SPRINGER-VERLAG 1971 */

/* THIS VERSION HAS BEEN CHANGED SLIGHTLY TO PREVENT */
/* INPUTS A AND B FROM BEING DESTROYED. */
/* WRITTEN MARCH 20, 1975 BY P. FOX */

/* FOR ACCURACY THE COMPUTATION IS DONE DIFFERENTLY */
/* DEPENDING ON WHETHER THE REAL OR IMAGINARY PART OF */
/* B IS LARGER */

    /* Parameter adjustments */
    --c__;
    --b;
    --a;

    /* Function Body */
    if (abs(b[1]) > abs(b[2])) {
	goto L10;
    }
    h__ = b[1] / b[2];
    g = h__ * b[1] + b[2];
    t = a[1];
    c__[1] = (h__ * t + a[2]) / g;
    c__[2] = (h__ * a[2] - t) / g;
    return 0;

/* IF THE REAL PART OF B IS LARGER THAN THE IMAGINARY- */
L10:
    h__ = b[2] / b[1];
    g = h__ * b[2] + b[1];
    t = a[1];
    c__[1] = (t + h__ * a[2]) / g;
    c__[2] = (a[2] - h__ * t) / g;
    return 0;
} /* cddiv_ */

