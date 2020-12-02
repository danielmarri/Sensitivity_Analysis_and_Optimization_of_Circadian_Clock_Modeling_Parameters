/* m7slo.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int m7slo_(integer *n, integer *indrow, integer *jpntr, 
	integer *indcol, integer *ipntr, integer *ndeg, integer *list, 
	integer *maxclq, integer *iwa1, integer *iwa2, integer *iwa3, integer 
	*iwa4, logical *bwa)
{
    /* System generated locals */
    integer i__1, i__2, i__3;

    /* Local variables */
    static integer l, ic, ip, jp, ir, deg, ipl, jpl, ipu, jpu, head, jcol, 
	    mindeg, numdeg, numord;

/*     ********** */

/*     SUBROUTINE M7SLO */

/*     GIVEN THE SPARSITY PATTERN OF AN M BY N MATRIX A, THIS */
/*     SUBROUTINE DETERMINES THE SMALLEST-LAST ORDERING OF THE */
/*     COLUMNS OF A. */

/*     THE SMALLEST-LAST ORDERING IS DEFINED FOR THE LOOPLESS */
/*     GRAPH G WITH VERTICES A(J), J = 1,2,...,N WHERE A(J) IS THE */
/*     J-TH COLUMN OF A AND WITH EDGE (A(I),A(J)) IF AND ONLY IF */
/*     COLUMNS I AND J HAVE A NON-ZERO IN THE SAME ROW POSITION. */

/*     THE SMALLEST-LAST ORDERING IS DETERMINED RECURSIVELY BY */
/*     LETTING LIST(K), K = N,...,1 BE A COLUMN WITH LEAST DEGREE */
/*     IN THE SUBGRAPH SPANNED BY THE UN-ORDERED COLUMNS. */

/*     NOTE THAT THE VALUE OF M IS NOT NEEDED BY M7SLO AND IS */
/*     THEREFORE NOT PRESENT IN THE SUBROUTINE STATEMENT. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE M7SLO(N,INDROW,JPNTR,INDCOL,IPNTR,NDEG,LIST, */
/*                      MAXCLQ,IWA1,IWA2,IWA3,IWA4,BWA) */

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

/*       NDEG IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH SPECIFIES */
/*         THE DEGREE SEQUENCE. THE DEGREE OF THE J-TH COLUMN */
/*         OF A IS NDEG(J). */

/*       LIST IS AN INTEGER OUTPUT ARRAY OF LENGTH N WHICH SPECIFIES */
/*         THE SMALLEST-LAST ORDERING OF THE COLUMNS OF A. THE J-TH */
/*         COLUMN IN THIS ORDER IS LIST(J). */

/*       MAXCLQ IS AN INTEGER OUTPUT VARIABLE SET TO THE SIZE */
/*         OF THE LARGEST CLIQUE FOUND DURING THE ORDERING. */

/*       IWA1,IWA2,IWA3, AND IWA4 ARE INTEGER WORK ARRAYS OF LENGTH N. */

/*       BWA IS A LOGICAL WORK ARRAY OF LENGTH N. */

/*     SUBPROGRAMS CALLED */

/*       FORTRAN-SUPPLIED ... MIN0 */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     INITIALIZATION BLOCK. */

    /* Parameter adjustments */
    --bwa;
    --iwa4;
    --iwa3;
    --iwa2;
    --iwa1;
    --list;
    --ndeg;
    --indrow;
    --jpntr;
    --indcol;
    --ipntr;

    /* Function Body */
    mindeg = *n;
    i__1 = *n;
    for (jp = 1; jp <= i__1; ++jp) {
	iwa1[jp] = 0;
	bwa[jp] = FALSE_;
	list[jp] = ndeg[jp];
/* Computing MIN */
	i__2 = mindeg, i__3 = ndeg[jp];
	mindeg = min(i__2,i__3);
/* L10: */
    }

/*     CREATE A DOUBLY-LINKED LIST TO ACCESS THE DEGREES OF THE */
/*     COLUMNS. THE POINTERS FOR THE LINKED LIST ARE AS FOLLOWS. */

/*     EACH UN-ORDERED COLUMN JCOL IS IN A LIST (THE DEGREE */
/*     LIST) OF COLUMNS WITH THE SAME DEGREE. */

/*     IWA1(NUMDEG+1) IS THE FIRST COLUMN IN THE NUMDEG LIST */
/*     UNLESS IWA1(NUMDEG+1) = 0. IN THIS CASE THERE ARE */
/*     NO COLUMNS IN THE NUMDEG LIST. */

/*     IWA2(JCOL) IS THE COLUMN BEFORE JCOL IN THE DEGREE LIST */
/*     UNLESS IWA2(JCOL) = 0. IN THIS CASE JCOL IS THE FIRST */
/*     COLUMN IN THIS DEGREE LIST. */

/*     IWA3(JCOL) IS THE COLUMN AFTER JCOL IN THE DEGREE LIST */
/*     UNLESS IWA3(JCOL) = 0. IN THIS CASE JCOL IS THE LAST */
/*     COLUMN IN THIS DEGREE LIST. */

/*     IF JCOL IS AN UN-ORDERED COLUMN, THEN LIST(JCOL) IS THE */
/*     DEGREE OF JCOL IN THE GRAPH INDUCED BY THE UN-ORDERED */
/*     COLUMNS. IF JCOL IS AN ORDERED COLUMN, THEN LIST(JCOL) */
/*     IS THE SMALLEST-LAST ORDER OF COLUMN JCOL. */

    i__1 = *n;
    for (jp = 1; jp <= i__1; ++jp) {
	numdeg = ndeg[jp];
	head = iwa1[numdeg + 1];
	iwa1[numdeg + 1] = jp;
	iwa2[jp] = 0;
	iwa3[jp] = head;
	if (head > 0) {
	    iwa2[head] = jp;
	}
/* L20: */
    }
    *maxclq = 0;
    numord = *n;

/*     BEGINNING OF ITERATION LOOP. */

L30:

/*        MARK THE SIZE OF THE LARGEST CLIQUE */
/*        FOUND DURING THE ORDERING. */

    if (mindeg + 1 == numord && *maxclq == 0) {
	*maxclq = numord;
    }

/*        CHOOSE A COLUMN JCOL OF MINIMAL DEGREE MINDEG. */

L40:
    jcol = iwa1[mindeg + 1];
    if (jcol > 0) {
	goto L50;
    }
    ++mindeg;
    goto L40;
L50:
    list[jcol] = numord;
    --numord;

/*        TERMINATION TEST. */

    if (numord == 0) {
	goto L120;
    }

/*        DELETE COLUMN JCOL FROM THE MINDEG LIST. */

    l = iwa3[jcol];
    iwa1[mindeg + 1] = l;
    if (l > 0) {
	iwa2[l] = 0;
    }

/*        FIND ALL COLUMNS ADJACENT TO COLUMN JCOL. */

    bwa[jcol] = TRUE_;
    deg = 0;

/*        DETERMINE ALL POSITIONS (IR,JCOL) WHICH CORRESPOND */
/*        TO NON-ZEROES IN THE MATRIX. */

    jpl = jpntr[jcol];
    jpu = jpntr[jcol + 1] - 1;
    if (jpu < jpl) {
	goto L90;
    }
    i__1 = jpu;
    for (jp = jpl; jp <= i__1; ++jp) {
	ir = indrow[jp];

/*           FOR EACH ROW IR, DETERMINE ALL POSITIONS (IR,IC) */
/*           WHICH CORRESPOND TO NON-ZEROES IN THE MATRIX. */

	ipl = ipntr[ir];
	ipu = ipntr[ir + 1] - 1;
	i__2 = ipu;
	for (ip = ipl; ip <= i__2; ++ip) {
	    ic = indcol[ip];

/*              ARRAY BWA MARKS COLUMNS WHICH ARE ADJACENT TO */
/*              COLUMN JCOL. ARRAY IWA4 RECORDS THE MARKED COLUMNS. */

	    if (bwa[ic]) {
		goto L60;
	    }
	    bwa[ic] = TRUE_;
	    ++deg;
	    iwa4[deg] = ic;
L60:
/* L70: */
	    ;
	}
/* L80: */
    }
L90:

/*        UPDATE THE POINTERS TO THE CURRENT DEGREE LISTS. */

    if (deg < 1) {
	goto L110;
    }
    i__1 = deg;
    for (jp = 1; jp <= i__1; ++jp) {
	ic = iwa4[jp];
	numdeg = list[ic];
	--list[ic];
/* Computing MIN */
	i__2 = mindeg, i__3 = list[ic];
	mindeg = min(i__2,i__3);

/*           DELETE COLUMN IC FROM THE NUMDEG LIST. */

	l = iwa2[ic];
	if (l == 0) {
	    iwa1[numdeg + 1] = iwa3[ic];
	}
	if (l > 0) {
	    iwa3[l] = iwa3[ic];
	}
	l = iwa3[ic];
	if (l > 0) {
	    iwa2[l] = iwa2[ic];
	}

/*           ADD COLUMN IC TO THE NUMDEG-1 LIST. */

	head = iwa1[numdeg];
	iwa1[numdeg] = ic;
	iwa2[ic] = 0;
	iwa3[ic] = head;
	if (head > 0) {
	    iwa2[head] = ic;
	}

/*           UN-MARK COLUMN IC IN THE ARRAY BWA. */

	bwa[ic] = FALSE_;
/* L100: */
    }
L110:

/*        END OF ITERATION LOOP. */

    goto L30;
L120:

/*     INVERT THE ARRAY LIST. */

    i__1 = *n;
    for (jcol = 1; jcol <= i__1; ++jcol) {
	numord = list[jcol];
	iwa1[numord] = jcol;
/* L130: */
    }
    i__1 = *n;
    for (jp = 1; jp <= i__1; ++jp) {
	list[jp] = iwa1[jp];
/* L140: */
    }
    return 0;

/*     LAST CARD OF SUBROUTINE M7SLO. */

} /* m7slo_ */

