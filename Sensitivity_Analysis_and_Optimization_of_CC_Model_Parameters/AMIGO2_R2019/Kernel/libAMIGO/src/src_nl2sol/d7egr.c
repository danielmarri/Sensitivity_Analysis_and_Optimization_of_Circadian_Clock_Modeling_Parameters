/* d7egr.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int d7egr_(integer *n, integer *indrow, integer *jpntr, 
	integer *indcol, integer *ipntr, integer *ndeg, integer *iwa, logical 
	*bwa)
{
    /* System generated locals */
    integer i__1, i__2, i__3;

    /* Local variables */
    static integer ic, ip, jp, ir, deg, ipl, jpl, ipu, jpu, jcol;

/*     ********** */

/*     SUBROUTINE D7EGR */

/*     GIVEN THE SPARSITY PATTERN OF AN M BY N MATRIX A, */
/*     THIS SUBROUTINE DETERMINES THE DEGREE SEQUENCE FOR */
/*     THE INTERSECTION GRAPH OF THE COLUMNS OF A. */

/*     IN GRAPH-THEORY TERMINOLOGY, THE INTERSECTION GRAPH OF */
/*     THE COLUMNS OF A IS THE LOOPLESS GRAPH G WITH VERTICES */
/*     A(J), J = 1,2,...,N WHERE A(J) IS THE J-TH COLUMN OF A */
/*     AND WITH EDGE (A(I),A(J)) IF AND ONLY IF COLUMNS I AND J */
/*     HAVE A NON-ZERO IN THE SAME ROW POSITION. */

/*     NOTE THAT THE VALUE OF M IS NOT NEEDED BY D7EGR AND IS */
/*     THEREFORE NOT PRESENT IN THE SUBROUTINE STATEMENT. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE D7EGR(N,INDROW,JPNTR,INDCOL,IPNTR,NDEG,IWA,BWA) */

/*     WHERE */

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

/*       INDCOL IS AN INTEGER INPUT ARRAY WHICH CONTAINS THE */
/*         COLUMN INDICES FOR THE NON-ZEROES IN THE MATRIX A. */

/*       IPNTR IS AN INTEGER INPUT ARRAY OF LENGTH M + 1 WHICH */
/*         SPECIFIES THE LOCATIONS OF THE COLUMN INDICES IN INDCOL. */
/*         THE COLUMN INDICES FOR ROW I ARE */

/*               INDCOL(K), K = IPNTR(I),...,IPNTR(I+1)-1. */

/*         NOTE THAT IPNTR(M+1)-1 IS THEN THE NUMBER OF NON-ZERO */
/*         ELEMENTS OF THE MATRIX A. */

/*       NDEG IS AN INTEGER OUTPUT ARRAY OF LENGTH N WHICH */
/*         SPECIFIES THE DEGREE SEQUENCE. THE DEGREE OF THE */
/*         J-TH COLUMN OF A IS NDEG(J). */

/*       IWA IS AN INTEGER WORK ARRAY OF LENGTH N. */

/*       BWA IS A LOGICAL WORK ARRAY OF LENGTH N. */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     INITIALIZATION BLOCK. */

    /* Parameter adjustments */
    --bwa;
    --iwa;
    --ndeg;
    --indrow;
    --jpntr;
    --indcol;
    --ipntr;

    /* Function Body */
    i__1 = *n;
    for (jp = 1; jp <= i__1; ++jp) {
	ndeg[jp] = 0;
	bwa[jp] = FALSE_;
/* L10: */
    }

/*     COMPUTE THE DEGREE SEQUENCE BY DETERMINING THE CONTRIBUTIONS */
/*     TO THE DEGREES FROM THE CURRENT(JCOL) COLUMN AND FURTHER */
/*     COLUMNS WHICH HAVE NOT YET BEEN CONSIDERED. */

    if (*n < 2) {
	goto L90;
    }
    i__1 = *n;
    for (jcol = 2; jcol <= i__1; ++jcol) {
	bwa[jcol] = TRUE_;
	deg = 0;

/*        DETERMINE ALL POSITIONS (IR,JCOL) WHICH CORRESPOND */
/*        TO NON-ZEROES IN THE MATRIX. */

	jpl = jpntr[jcol];
	jpu = jpntr[jcol + 1] - 1;
	if (jpu < jpl) {
	    goto L50;
	}
	i__2 = jpu;
	for (jp = jpl; jp <= i__2; ++jp) {
	    ir = indrow[jp];

/*           FOR EACH ROW IR, DETERMINE ALL POSITIONS (IR,IC) */
/*           WHICH CORRESPOND TO NON-ZEROES IN THE MATRIX. */

	    ipl = ipntr[ir];
	    ipu = ipntr[ir + 1] - 1;
	    i__3 = ipu;
	    for (ip = ipl; ip <= i__3; ++ip) {
		ic = indcol[ip];

/*              ARRAY BWA MARKS COLUMNS WHICH HAVE CONTRIBUTED TO */
/*              THE DEGREE COUNT OF COLUMN JCOL. UPDATE THE DEGREE */
/*              COUNTS OF THESE COLUMNS. ARRAY IWA RECORDS THE */
/*              MARKED COLUMNS. */

		if (bwa[ic]) {
		    goto L20;
		}
		bwa[ic] = TRUE_;
		++ndeg[ic];
		++deg;
		iwa[deg] = ic;
L20:
/* L30: */
		;
	    }
/* L40: */
	}
L50:

/*        UN-MARK THE COLUMNS RECORDED BY IWA AND FINALIZE THE */
/*        DEGREE COUNT OF COLUMN JCOL. */

	if (deg < 1) {
	    goto L70;
	}
	i__2 = deg;
	for (jp = 1; jp <= i__2; ++jp) {
	    ic = iwa[jp];
	    bwa[ic] = FALSE_;
/* L60: */
	}
	ndeg[jcol] += deg;
L70:
/* L80: */
	;
    }
L90:
    return 0;

/*     LAST CARD OF SUBROUTINE D7EGR. */

} /* d7egr_ */

