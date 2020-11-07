/* dortra.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int dortra_(integer *nm, integer *n, integer *low, integer *
	igh, doublereal *a, doublereal *ort, doublereal *z__)
{
    /* System generated locals */
    integer a_dim1, a_offset, z_dim1, z_offset, i__1, i__2, i__3;

    /* Local variables */
    static doublereal g;
    static integer i__, j, kl, mm, mp, mp1;



/*     THIS IS A DOUBLE-PRECISION VERSION OF THE */
/*     EISPACK SINGLE-PRECISION ROUTINE ORTRAN. */
/*     IT WAS ADAPTED BY PHYLLIS FOX, MAY 28, 1975. */

/*     ORTRAN IS A TRANSLATION OF THE ALGOL PROCEDURE ORTRANS, */
/*     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON. */
/*     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971). */

/*     THIS SUBROUTINE ACCUMULATES THE ORTHOGONAL SIMILARITY */
/*     TRANSFORMATIONS USED IN THE REDUCTION OF A REAL GENERAL */
/*     MATRIX TO UPPER HESSENBERG FORM BY  DORTHE. */

/*     ON INPUT- */

/*        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL */
/*          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM */
/*          DIMENSION STATEMENT, */

/*        N IS THE ORDER OF THE MATRIX, */

/*        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING */
/*          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED, */
/*          SET LOW=1, IGH=N, */

/*        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS- */
/*          FORMATIONS USED IN THE REDUCTION BY  DORTHE */
/*          IN ITS STRICT LOWER TRIANGLE, */

/*        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANS- */
/*          FORMATIONS USED IN THE REDUCTION BY  DORTHE. */
/*          ONLY ELEMENTS LOW THROUGH IGH ARE USED. */

/*     ON OUTPUT- */

/*        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE */
/*          REDUCTION BY  DORTHE, */

/*        ORT HAS BEEN ALTERED. */


/*     ------------------------------------------------------------------ */

/*     ********** INITIALIZE Z TO IDENTITY MATRIX ********** */
    /* Parameter adjustments */
    z_dim1 = *nm;
    z_offset = 1 + z_dim1;
    z__ -= z_offset;
    --ort;
    a_dim1 = *nm;
    a_offset = 1 + a_dim1;
    a -= a_offset;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {

	i__2 = *n;
	for (j = 1; j <= i__2; ++j) {
/* L60: */
	    z__[i__ + j * z_dim1] = 0.;
	}

	z__[i__ + i__ * z_dim1] = 1.;
/* L80: */
    }

    kl = *igh - *low - 1;
    if (kl < 1) {
	goto L200;
    }
/*     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- ********** */
    i__1 = kl;
    for (mm = 1; mm <= i__1; ++mm) {
	mp = *igh - mm;
	if (a[mp + (mp - 1) * a_dim1] == 0.) {
	    goto L140;
	}
	mp1 = mp + 1;

	i__2 = *igh;
	for (i__ = mp1; i__ <= i__2; ++i__) {
/* L100: */
	    ort[i__] = a[i__ + (mp - 1) * a_dim1];
	}

	i__2 = *igh;
	for (j = mp; j <= i__2; ++j) {
	    g = 0.;

	    i__3 = *igh;
	    for (i__ = mp; i__ <= i__3; ++i__) {
/* L110: */
		g += ort[i__] * z__[i__ + j * z_dim1];
	    }
/*     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN DORTHE. */
/*                DOUBLE DIVISION AVOIDS POSSIBLE UNDERFLOW ********** */
	    g = g / ort[mp] / a[mp + (mp - 1) * a_dim1];

	    i__3 = *igh;
	    for (i__ = mp; i__ <= i__3; ++i__) {
/* L120: */
		z__[i__ + j * z_dim1] += g * ort[i__];
	    }

/* L130: */
	}

L140:
	;
    }

L200:
    return 0;
/*     ********** LAST CARD OF DORTRA ********** */
} /* dortra_ */

