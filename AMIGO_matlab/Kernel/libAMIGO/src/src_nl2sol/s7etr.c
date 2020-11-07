/* s7etr.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int s7etr_(integer *m, integer *n, integer *indrow, integer *
	jpntr, integer *indcol, integer *ipntr, integer *iwa)
{
    /* System generated locals */
    integer i__1, i__2;

    /* Local variables */
    static integer l, jp, ir, jpl, jpu, nnz, jcol;

/*     ********** */

/*     SUBROUTINE S7ETR */

/*     GIVEN A COLUMN-ORIENTED DEFINITION OF THE SPARSITY PATTERN */
/*     OF AN M BY N MATRIX A, THIS SUBROUTINE DETERMINES A */
/*     ROW-ORIENTED DEFINITION OF THE SPARSITY PATTERN OF A. */

/*     ON INPUT THE COLUMN-ORIENTED DEFINITION IS SPECIFIED BY */
/*     THE ARRAYS INDROW AND JPNTR. ON OUTPUT THE ROW-ORIENTED */
/*     DEFINITION IS SPECIFIED BY THE ARRAYS INDCOL AND IPNTR. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE S7ETR(M,N,INDROW,JPNTR,INDCOL,IPNTR,IWA) */

/*     WHERE */

/*       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER */
/*         OF ROWS OF A. */

/*       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER */
/*         OF COLUMNS OF A. */

/*       INDROW IS AN INTEGER INPUT ARRAY WHICH CONTAINS THE ROW */
/*         INDICES FOR THE NON-ZEROES IN THE MATRIX A. */

/*       JPNTR IS AN INTEGER INPUT ARRAY OF LENGTH N + 1 WHICH */
/*         SPECIFIES THE LOCATIONS OF THE ROW INDICES IN INDROW. */
/*         THE ROW INDICES FOR COLUMN J ARE */

/*               INDROW(K), K = JPNTR(J),...,JPNTR(J+1)-1. */

/*         NOTE THAT JPNTR(N+1)-1 IS THEN THE NUMBER OF NON-ZERO */
/*         ELEMENTS OF THE MATRIX A. */

/*       INDCOL IS AN INTEGER OUTPUT ARRAY WHICH CONTAINS THE */
/*         COLUMN INDICES FOR THE NON-ZEROES IN THE MATRIX A. */

/*       IPNTR IS AN INTEGER OUTPUT ARRAY OF LENGTH M + 1 WHICH */
/*         SPECIFIES THE LOCATIONS OF THE COLUMN INDICES IN INDCOL. */
/*         THE COLUMN INDICES FOR ROW I ARE */

/*               INDCOL(K), K = IPNTR(I),...,IPNTR(I+1)-1. */

/*         NOTE THAT IPNTR(1) IS SET TO 1 AND THAT IPNTR(M+1)-1 IS */
/*         THEN THE NUMBER OF NON-ZERO ELEMENTS OF THE MATRIX A. */

/*       IWA IS AN INTEGER WORK ARRAY OF LENGTH M. */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     DETERMINE THE NUMBER OF NON-ZEROES IN THE ROWS. */

    /* Parameter adjustments */
    --iwa;
    --indrow;
    --jpntr;
    --indcol;
    --ipntr;

    /* Function Body */
    i__1 = *m;
    for (ir = 1; ir <= i__1; ++ir) {
	iwa[ir] = 0;
/* L10: */
    }
    nnz = jpntr[*n + 1] - 1;
    i__1 = nnz;
    for (jp = 1; jp <= i__1; ++jp) {
	ir = indrow[jp];
	++iwa[ir];
/* L20: */
    }

/*     SET POINTERS TO THE START OF THE ROWS IN INDCOL. */

    ipntr[1] = 1;
    i__1 = *m;
    for (ir = 1; ir <= i__1; ++ir) {
	ipntr[ir + 1] = ipntr[ir] + iwa[ir];
	iwa[ir] = ipntr[ir];
/* L30: */
    }

/*     FILL INDCOL. */

    i__1 = *n;
    for (jcol = 1; jcol <= i__1; ++jcol) {
	jpl = jpntr[jcol];
	jpu = jpntr[jcol + 1] - 1;
	if (jpu < jpl) {
	    goto L50;
	}
	i__2 = jpu;
	for (jp = jpl; jp <= i__2; ++jp) {
	    ir = indrow[jp];
	    l = iwa[ir];
	    indcol[l] = jcol;
	    ++iwa[ir];
/* L40: */
	}
L50:
/* L60: */
	;
    }
    return 0;

/*     LAST CARD OF SUBROUTINE S7ETR. */

} /* s7etr_ */

