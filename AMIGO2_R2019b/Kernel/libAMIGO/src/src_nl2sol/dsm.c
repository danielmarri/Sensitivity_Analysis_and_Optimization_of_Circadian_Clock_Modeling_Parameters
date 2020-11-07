/* dsm.f -- translated by f2c (version 20100827).
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

/* Table of constant values */

static integer c_n1 = -1;

/* Subroutine */ int dsm_(integer *m, integer *n, integer *npairs, integer *
	indrow, integer *indcol, integer *ngrp, integer *maxgrp, integer *
	mingrp, integer *info, integer *ipntr, integer *jpntr, integer *iwa, 
	integer *liwa, logical *bwa)
{
    /* System generated locals */
    integer i__1, i__2, i__3;

    /* Local variables */
    static integer i__, j, k, jp, ir, jpl, jpu, nnz;
    extern /* Subroutine */ int i7do_(integer *, integer *, integer *, 
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    integer *, integer *, integer *, integer *, logical *), d7egr_(
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    integer *, logical *), m7seq_(integer *, integer *, integer *, 
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    logical *), m7slo_(integer *, integer *, integer *, integer *, 
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    integer *, integer *, logical *), s7etr_(integer *, integer *, 
	    integer *, integer *, integer *, integer *, integer *), s7rtdt_(
	    integer *, integer *, integer *, integer *, integer *, integer *),
	     n7msrt_(integer *, integer *, integer *, integer *, integer *, 
	    integer *, integer *);
    static integer maxclq, numgrp;

/*     ********** */

/*     SUBROUTINE DSM */

/*     THE PURPOSE OF DSM IS TO DETERMINE AN OPTIMAL OR NEAR- */
/*     OPTIMAL CONSISTENT PARTITION OF THE COLUMNS OF A SPARSE */
/*     M BY N MATRIX A. */

/*     THE SPARSITY PATTERN OF THE MATRIX A IS SPECIFIED BY */
/*     THE ARRAYS INDROW AND INDCOL. ON INPUT THE INDICES */
/*     FOR THE NON-ZERO ELEMENTS OF A ARE */

/*           INDROW(K),INDCOL(K), K = 1,2,...,NPAIRS. */

/*     THE (INDROW,INDCOL) PAIRS MAY BE SPECIFIED IN ANY ORDER. */
/*     DUPLICATE INPUT PAIRS ARE PERMITTED, BUT THE SUBROUTINE */
/*     ELIMINATES THEM. */

/*     THE SUBROUTINE PARTITIONS THE COLUMNS OF A INTO GROUPS */
/*     SUCH THAT COLUMNS IN THE SAME GROUP DO NOT HAVE A */
/*     NON-ZERO IN THE SAME ROW POSITION. A PARTITION OF THE */
/*     COLUMNS OF A WITH THIS PROPERTY IS CONSISTENT WITH THE */
/*     DIRECT DETERMINATION OF A. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE DSM(M,N,NPAIRS,INDROW,INDCOL,NGRP,MAXGRP,MINGRP, */
/*                      INFO,IPNTR,JPNTR,IWA,LIWA,BWA) */

/*     WHERE */

/*       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER */
/*         OF ROWS OF A. */

/*       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER */
/*         OF COLUMNS OF A. */

/*       NPAIRS IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE */
/*         NUMBER OF (INDROW,INDCOL) PAIRS USED TO DESCRIBE THE */
/*         SPARSITY PATTERN OF A. */

/*       INDROW IS AN INTEGER ARRAY OF LENGTH NPAIRS. ON INPUT INDROW */
/*         MUST CONTAIN THE ROW INDICES OF THE NON-ZERO ELEMENTS OF A. */
/*         ON OUTPUT INDROW IS PERMUTED SO THAT THE CORRESPONDING */
/*         COLUMN INDICES ARE IN NON-DECREASING ORDER. THE COLUMN */
/*         INDICES CAN BE RECOVERED FROM THE ARRAY JPNTR. */

/*       INDCOL IS AN INTEGER ARRAY OF LENGTH NPAIRS. ON INPUT INDCOL */
/*         MUST CONTAIN THE COLUMN INDICES OF THE NON-ZERO ELEMENTS OF */
/*         A. ON OUTPUT INDCOL IS PERMUTED SO THAT THE CORRESPONDING */
/*         ROW INDICES ARE IN NON-DECREASING ORDER. THE ROW INDICES */
/*         CAN BE RECOVERED FROM THE ARRAY IPNTR. */

/*       NGRP IS AN INTEGER OUTPUT ARRAY OF LENGTH N WHICH SPECIFIES */
/*         THE PARTITION OF THE COLUMNS OF A. COLUMN JCOL BELONGS */
/*         TO GROUP NGRP(JCOL). */

/*       MAXGRP IS AN INTEGER OUTPUT VARIABLE WHICH SPECIFIES THE */
/*         NUMBER OF GROUPS IN THE PARTITION OF THE COLUMNS OF A. */

/*       MINGRP IS AN INTEGER OUTPUT VARIABLE WHICH SPECIFIES A LOWER */
/*         BOUND FOR THE NUMBER OF GROUPS IN ANY CONSISTENT PARTITION */
/*         OF THE COLUMNS OF A. */

/*       INFO IS AN INTEGER OUTPUT VARIABLE SET AS FOLLOWS. FOR */
/*         NORMAL TERMINATION INFO = 1. IF M, N, OR NPAIRS IS NOT */
/*         POSITIVE OR LIWA IS LESS THAN MAX(M,6*N), THEN INFO = 0. */
/*         IF THE K-TH ELEMENT OF INDROW IS NOT AN INTEGER BETWEEN */
/*         1 AND M OR THE K-TH ELEMENT OF INDCOL IS NOT AN INTEGER */
/*         BETWEEN 1 AND N, THEN INFO = -K. */

/*       IPNTR IS AN INTEGER OUTPUT ARRAY OF LENGTH M + 1 WHICH */
/*         SPECIFIES THE LOCATIONS OF THE COLUMN INDICES IN INDCOL. */
/*         THE COLUMN INDICES FOR ROW I ARE */

/*               INDCOL(K), K = IPNTR(I),...,IPNTR(I+1)-1. */

/*         NOTE THAT IPNTR(M+1)-1 IS THEN THE NUMBER OF NON-ZERO */
/*         ELEMENTS OF THE MATRIX A. */

/*       JPNTR IS AN INTEGER OUTPUT ARRAY OF LENGTH N + 1 WHICH */
/*         SPECIFIES THE LOCATIONS OF THE ROW INDICES IN INDROW. */
/*         THE ROW INDICES FOR COLUMN J ARE */

/*               INDROW(K), K = JPNTR(J),...,JPNTR(J+1)-1. */

/*         NOTE THAT JPNTR(N+1)-1 IS THEN THE NUMBER OF NON-ZERO */
/*         ELEMENTS OF THE MATRIX A. */

/*       IWA IS AN INTEGER WORK ARRAY OF LENGTH LIWA. */

/*       LIWA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN */
/*         MAX(M,6*N). */

/*       BWA IS A LOGICAL WORK ARRAY OF LENGTH N. */

/*     SUBPROGRAMS CALLED */

/*       MINPACK-SUPPLIED ...D7EGR,I7DO,N7MSRT,M7SEQ,S7ETR,M7SLO,S7RTDT */

/*       FORTRAN-SUPPLIED ... MAX0 */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     CHECK THE INPUT DATA. */

    /* Parameter adjustments */
    --bwa;
    --ngrp;
    --indcol;
    --indrow;
    --ipntr;
    --jpntr;
    --iwa;

    /* Function Body */
    *info = 0;
/* Computing MAX */
    i__1 = *m, i__2 = *n * 6;
    if (*m < 1 || *n < 1 || *npairs < 1 || *liwa < max(i__1,i__2)) {
	goto L130;
    }
    i__1 = *npairs;
    for (k = 1; k <= i__1; ++k) {
	*info = -k;
	if (indrow[k] < 1 || indrow[k] > *m || indcol[k] < 1 || indcol[k] > *
		n) {
	    goto L130;
	}
/* L10: */
    }
    *info = 1;

/*     SORT THE DATA STRUCTURE BY COLUMNS. */

    s7rtdt_(n, npairs, &indrow[1], &indcol[1], &jpntr[1], &iwa[1]);

/*     COMPRESS THE DATA AND DETERMINE THE NUMBER OF */
/*     NON-ZERO ELEMENTS OF A. */

    i__1 = *m;
    for (i__ = 1; i__ <= i__1; ++i__) {
	iwa[i__] = 0;
/* L20: */
    }
    nnz = 0;
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	jpl = jpntr[j];
	jpu = jpntr[j + 1] - 1;
	jpntr[j] = nnz + 1;
	if (jpu < jpl) {
	    goto L60;
	}
	i__2 = jpu;
	for (jp = jpl; jp <= i__2; ++jp) {
	    ir = indrow[jp];
	    if (iwa[ir] != 0) {
		goto L30;
	    }
	    ++nnz;
	    indrow[nnz] = ir;
	    iwa[ir] = 1;
L30:
/* L40: */
	    ;
	}
	jpl = jpntr[j];
	i__2 = nnz;
	for (jp = jpl; jp <= i__2; ++jp) {
	    ir = indrow[jp];
	    iwa[ir] = 0;
/* L50: */
	}
L60:
/* L70: */
	;
    }
    jpntr[*n + 1] = nnz + 1;

/*     EXTEND THE DATA STRUCTURE TO ROWS. */

    s7etr_(m, n, &indrow[1], &jpntr[1], &indcol[1], &ipntr[1], &iwa[1]);

/*     DETERMINE A LOWER BOUND FOR THE NUMBER OF GROUPS. */

    *mingrp = 0;
    i__1 = *m;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* Computing MAX */
	i__2 = *mingrp, i__3 = ipntr[i__ + 1] - ipntr[i__];
	*mingrp = max(i__2,i__3);
/* L80: */
    }

/*     DETERMINE THE DEGREE SEQUENCE FOR THE INTERSECTION */
/*     GRAPH OF THE COLUMNS OF A. */

    d7egr_(n, &indrow[1], &jpntr[1], &indcol[1], &ipntr[1], &iwa[*n * 5 + 1], 
	    &iwa[*n + 1], &bwa[1]);

/*     COLOR THE INTERSECTION GRAPH OF THE COLUMNS OF A */
/*     WITH THE SMALLEST-LAST (SL) ORDERING. */

    m7slo_(n, &indrow[1], &jpntr[1], &indcol[1], &ipntr[1], &iwa[*n * 5 + 1], 
	    &iwa[(*n << 2) + 1], &maxclq, &iwa[1], &iwa[*n + 1], &iwa[(*n << 
	    1) + 1], &iwa[*n * 3 + 1], &bwa[1]);
    m7seq_(n, &indrow[1], &jpntr[1], &indcol[1], &ipntr[1], &iwa[(*n << 2) + 
	    1], &ngrp[1], maxgrp, &iwa[*n + 1], &bwa[1]);
    *mingrp = max(*mingrp,maxclq);
    if (*maxgrp == *mingrp) {
	goto L130;
    }

/*     COLOR THE INTERSECTION GRAPH OF THE COLUMNS OF A */
/*     WITH THE INCIDENCE-DEGREE (ID) ORDERING. */

    i7do_(m, n, &indrow[1], &jpntr[1], &indcol[1], &ipntr[1], &iwa[*n * 5 + 1]
	    , &iwa[(*n << 2) + 1], &maxclq, &iwa[1], &iwa[*n + 1], &iwa[(*n <<
	     1) + 1], &iwa[*n * 3 + 1], &bwa[1]);
    m7seq_(n, &indrow[1], &jpntr[1], &indcol[1], &ipntr[1], &iwa[(*n << 2) + 
	    1], &iwa[1], &numgrp, &iwa[*n + 1], &bwa[1]);
    *mingrp = max(*mingrp,maxclq);
    if (numgrp >= *maxgrp) {
	goto L100;
    }
    *maxgrp = numgrp;
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	ngrp[j] = iwa[j];
/* L90: */
    }
    if (*maxgrp == *mingrp) {
	goto L130;
    }
L100:

/*     COLOR THE INTERSECTION GRAPH OF THE COLUMNS OF A */
/*     WITH THE LARGEST-FIRST (LF) ORDERING. */

    i__1 = *n - 1;
    n7msrt_(n, &i__1, &iwa[*n * 5 + 1], &c_n1, &iwa[(*n << 2) + 1], &iwa[(*n 
	    << 1) + 1], &iwa[*n + 1]);
    m7seq_(n, &indrow[1], &jpntr[1], &indcol[1], &ipntr[1], &iwa[(*n << 2) + 
	    1], &iwa[1], &numgrp, &iwa[*n + 1], &bwa[1]);
    if (numgrp >= *maxgrp) {
	goto L120;
    }
    *maxgrp = numgrp;
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	ngrp[j] = iwa[j];
/* L110: */
    }
L120:

/*     EXIT FROM PROGRAM. */

L130:
    return 0;

/*     LAST CARD OF SUBROUTINE DSM. */

} /* dsm_ */

