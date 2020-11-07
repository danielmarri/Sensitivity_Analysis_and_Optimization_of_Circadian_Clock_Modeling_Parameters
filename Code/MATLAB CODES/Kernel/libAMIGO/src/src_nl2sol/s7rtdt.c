/* s7rtdt.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int s7rtdt_(integer *n, integer *nnz, integer *indrow, 
	integer *indcol, integer *jpntr, integer *iwa)
{
    /* System generated locals */
    integer i__1, i__2;

    /* Local variables */
    static integer i__, j, k, l;

/*     ********** */

/*     SUBROUTINE S7RTDT */

/*     GIVEN THE NON-ZERO ELEMENTS OF AN M BY N MATRIX A IN */
/*     ARBITRARY ORDER AS SPECIFIED BY THEIR ROW AND COLUMN */
/*     INDICES, THIS SUBROUTINE PERMUTES THESE ELEMENTS SO */
/*     THAT THEIR COLUMN INDICES ARE IN NON-DECREASING ORDER. */

/*     ON INPUT IT IS ASSUMED THAT THE ELEMENTS ARE SPECIFIED IN */

/*           INDROW(K),INDCOL(K), K = 1,...,NNZ. */

/*     ON OUTPUT THE ELEMENTS ARE PERMUTED SO THAT INDCOL IS */
/*     IN NON-DECREASING ORDER. IN ADDITION, THE ARRAY JPNTR */
/*     IS SET SO THAT THE ROW INDICES FOR COLUMN J ARE */

/*           INDROW(K), K = JPNTR(J),...,JPNTR(J+1)-1. */

/*     NOTE THAT THE VALUE OF M IS NOT NEEDED BY S7RTDT AND IS */
/*     THEREFORE NOT PRESENT IN THE SUBROUTINE STATEMENT. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE S7RTDT(N,NNZ,INDROW,INDCOL,JPNTR,IWA) */

/*     WHERE */

/*       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER */
/*         OF COLUMNS OF A. */

/*       NNZ IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER */
/*         OF NON-ZERO ELEMENTS OF A. */

/*       INDROW IS AN INTEGER ARRAY OF LENGTH NNZ. ON INPUT INDROW */
/*         MUST CONTAIN THE ROW INDICES OF THE NON-ZERO ELEMENTS OF A. */
/*         ON OUTPUT INDROW IS PERMUTED SO THAT THE CORRESPONDING */
/*         COLUMN INDICES OF INDCOL ARE IN NON-DECREASING ORDER. */

/*       INDCOL IS AN INTEGER ARRAY OF LENGTH NNZ. ON INPUT INDCOL */
/*         MUST CONTAIN THE COLUMN INDICES OF THE NON-ZERO ELEMENTS */
/*         OF A. ON OUTPUT INDCOL IS PERMUTED SO THAT THESE INDICES */
/*         ARE IN NON-DECREASING ORDER. */

/*       JPNTR IS AN INTEGER OUTPUT ARRAY OF LENGTH N + 1 WHICH */
/*         SPECIFIES THE LOCATIONS OF THE ROW INDICES IN THE OUTPUT */
/*         INDROW. THE ROW INDICES FOR COLUMN J ARE */

/*               INDROW(K), K = JPNTR(J),...,JPNTR(J+1)-1. */

/*         NOTE THAT JPNTR(1) IS SET TO 1 AND THAT JPNTR(N+1)-1 */
/*         IS THEN NNZ. */

/*       IWA IS AN INTEGER WORK ARRAY OF LENGTH N. */

/*     SUBPROGRAMS CALLED */

/*       FORTRAN-SUPPLIED ... MAX0 */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     DETERMINE THE NUMBER OF NON-ZEROES IN THE COLUMNS. */

    /* Parameter adjustments */
    --iwa;
    --indcol;
    --indrow;
    --jpntr;

    /* Function Body */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	iwa[j] = 0;
/* L10: */
    }
    i__1 = *nnz;
    for (k = 1; k <= i__1; ++k) {
	j = indcol[k];
	++iwa[j];
/* L20: */
    }

/*     SET POINTERS TO THE START OF THE COLUMNS IN INDROW. */

    jpntr[1] = 1;
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	jpntr[j + 1] = jpntr[j] + iwa[j];
	iwa[j] = jpntr[j];
/* L30: */
    }
    k = 1;

/*     BEGIN IN-PLACE SORT. */

L40:
    j = indcol[k];
    if (k < jpntr[j] || k >= jpntr[j + 1]) {
	goto L50;
    }

/*           CURRENT ELEMENT IS IN POSITION. NOW EXAMINE THE */
/*           NEXT ELEMENT OR THE FIRST UN-SORTED ELEMENT IN */
/*           THE J-TH GROUP. */

/* Computing MAX */
    i__1 = k + 1, i__2 = iwa[j];
    k = max(i__1,i__2);
    goto L60;
L50:

/*           CURRENT ELEMENT IS NOT IN POSITION. PLACE ELEMENT */
/*           IN POSITION AND MAKE THE DISPLACED ELEMENT THE */
/*           CURRENT ELEMENT. */

    l = iwa[j];
    ++iwa[j];
    i__ = indrow[k];
    indrow[k] = indrow[l];
    indcol[k] = indcol[l];
    indrow[l] = i__;
    indcol[l] = j;
L60:
    if (k <= *nnz) {
	goto L40;
    }
    return 0;

/*     LAST CARD OF SUBROUTINE S7RTDT. */

} /* s7rtdt_ */

