/* m7seq.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int m7seq_(integer *n, integer *indrow, integer *jpntr, 
	integer *indcol, integer *ipntr, integer *list, integer *ngrp, 
	integer *maxgrp, integer *iwa, logical *bwa)
{
    /* System generated locals */
    integer i__1, i__2, i__3;

    /* Local variables */
    static integer j, l, ic, ip, jp, ir, deg, ipl, jpl, ipu, jpu, jcol, 
	    numgrp;

/*     ********** */

/*     SUBROUTINE M7SEQ */

/*     GIVEN THE SPARSITY PATTERN OF AN M BY N MATRIX A, THIS */
/*     SUBROUTINE DETERMINES A CONSISTENT PARTITION OF THE */
/*     COLUMNS OF A BY A SEQUENTIAL ALGORITHM. */

/*     A CONSISTENT PARTITION IS DEFINED IN TERMS OF THE LOOPLESS */
/*     GRAPH G WITH VERTICES A(J), J = 1,2,...,N WHERE A(J) IS THE */
/*     J-TH COLUMN OF A AND WITH EDGE (A(I),A(J)) IF AND ONLY IF */
/*     COLUMNS I AND J HAVE A NON-ZERO IN THE SAME ROW POSITION. */

/*     A PARTITION OF THE COLUMNS OF A INTO GROUPS IS CONSISTENT */
/*     IF THE COLUMNS IN ANY GROUP ARE NOT ADJACENT IN THE GRAPH G. */
/*     IN GRAPH-THEORY TERMINOLOGY, A CONSISTENT PARTITION OF THE */
/*     COLUMNS OF A CORRESPONDS TO A COLORING OF THE GRAPH G. */

/*     THE SUBROUTINE EXAMINES THE COLUMNS IN THE ORDER SPECIFIED */
/*     BY THE ARRAY LIST, AND ASSIGNS THE CURRENT COLUMN TO THE */
/*     GROUP WITH THE SMALLEST POSSIBLE NUMBER. */

/*     NOTE THAT THE VALUE OF M IS NOT NEEDED BY M7SEQ AND IS */
/*     THEREFORE NOT PRESENT IN THE SUBROUTINE STATEMENT. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE M7SEQ(N,INDROW,JPNTR,INDCOL,IPNTR,LIST,NGRP,MAXGRP, */
/*                      IWA,BWA) */

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

/*       LIST IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH SPECIFIES */
/*         THE ORDER TO BE USED BY THE SEQUENTIAL ALGORITHM. */
/*         THE J-TH COLUMN IN THIS ORDER IS LIST(J). */

/*       NGRP IS AN INTEGER OUTPUT ARRAY OF LENGTH N WHICH SPECIFIES */
/*         THE PARTITION OF THE COLUMNS OF A. COLUMN JCOL BELONGS */
/*         TO GROUP NGRP(JCOL). */

/*       MAXGRP IS AN INTEGER OUTPUT VARIABLE WHICH SPECIFIES THE */
/*         NUMBER OF GROUPS IN THE PARTITION OF THE COLUMNS OF A. */

/*       IWA IS AN INTEGER WORK ARRAY OF LENGTH N. */

/*       BWA IS A LOGICAL WORK ARRAY OF LENGTH N. */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     INITIALIZATION BLOCK. */

    /* Parameter adjustments */
    --bwa;
    --iwa;
    --ngrp;
    --list;
    --indrow;
    --jpntr;
    --indcol;
    --ipntr;

    /* Function Body */
    *maxgrp = 0;
    i__1 = *n;
    for (jp = 1; jp <= i__1; ++jp) {
	ngrp[jp] = *n;
	bwa[jp] = FALSE_;
/* L10: */
    }
    bwa[*n] = TRUE_;

/*     BEGINNING OF ITERATION LOOP. */

    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	jcol = list[j];

/*        FIND ALL COLUMNS ADJACENT TO COLUMN JCOL. */

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
		l = ngrp[ic];

/*              ARRAY BWA MARKS THE GROUP NUMBERS OF THE */
/*              COLUMNS WHICH ARE ADJACENT TO COLUMN JCOL. */
/*              ARRAY IWA RECORDS THE MARKED GROUP NUMBERS. */

		if (bwa[l]) {
		    goto L20;
		}
		bwa[l] = TRUE_;
		++deg;
		iwa[deg] = l;
L20:
/* L30: */
		;
	    }
/* L40: */
	}
L50:

/*        ASSIGN THE SMALLEST UN-MARKED GROUP NUMBER TO JCOL. */

	i__2 = *n;
	for (jp = 1; jp <= i__2; ++jp) {
	    numgrp = jp;
	    if (! bwa[jp]) {
		goto L70;
	    }
/* L60: */
	}
L70:
	ngrp[jcol] = numgrp;
	*maxgrp = max(*maxgrp,numgrp);

/*        UN-MARK THE GROUP NUMBERS. */

	if (deg < 1) {
	    goto L90;
	}
	i__2 = deg;
	for (jp = 1; jp <= i__2; ++jp) {
	    l = iwa[jp];
	    bwa[l] = FALSE_;
/* L80: */
	}
L90:
/* L100: */
	;
    }

/*        END OF ITERATION LOOP. */

    return 0;

/*     LAST CARD OF SUBROUTINE M7SEQ. */

} /* m7seq_ */

