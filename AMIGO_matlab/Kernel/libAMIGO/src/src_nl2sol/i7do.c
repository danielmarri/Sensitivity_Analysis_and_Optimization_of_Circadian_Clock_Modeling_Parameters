/* i7do.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int i7do_(integer *m, integer *n, integer *indrow, integer *
	jpntr, integer *indcol, integer *ipntr, integer *ndeg, integer *list, 
	integer *maxclq, integer *iwa1, integer *iwa2, integer *iwa3, integer 
	*iwa4, logical *bwa)
{
    /* System generated locals */
    integer i__1, i__2, i__3;

    /* Local variables */
    static integer l, ic, ip, jp, ir, deg, ipl, jpl, ipu, jpu, head, jcol, 
	    ncomp;
    extern /* Subroutine */ int n7msrt_(integer *, integer *, integer *, 
	    integer *, integer *, integer *, integer *);
    static integer maxinc, numinc, numord, maxlst, numwgt, numlst;

/*     ********** */

/*     SUBROUTINE I7DO */

/*     GIVEN THE SPARSITY PATTERN OF AN M BY N MATRIX A, THIS */
/*     SUBROUTINE DETERMINES AN INCIDENCE-DEGREE ORDERING OF THE */
/*     COLUMNS OF A. */

/*     THE INCIDENCE-DEGREE ORDERING IS DEFINED FOR THE LOOPLESS */
/*     GRAPH G WITH VERTICES A(J), J = 1,2,...,N WHERE A(J) IS THE */
/*     J-TH COLUMN OF A AND WITH EDGE (A(I),A(J)) IF AND ONLY IF */
/*     COLUMNS I AND J HAVE A NON-ZERO IN THE SAME ROW POSITION. */

/*     AT EACH STAGE OF I7DO, A COLUMN OF MAXIMAL INCIDENCE IS */
/*     CHOSEN AND ORDERED. IF JCOL IS AN UN-ORDERED COLUMN, THEN */
/*     THE INCIDENCE OF JCOL IS THE NUMBER OF ORDERED COLUMNS */
/*     ADJACENT TO JCOL IN THE GRAPH G. AMONG ALL THE COLUMNS OF */
/*     MAXIMAL INCIDENCE,I7DO CHOOSES A COLUMN OF MAXIMAL DEGREE. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE I7DO(M,N,INDROW,JPNTR,INDCOL,IPNTR,NDEG,LIST, */
/*                      MAXCLQ,IWA1,IWA2,IWA3,IWA4,BWA) */

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
/*         THE INCIDENCE-DEGREE ORDERING OF THE COLUMNS OF A. THE J-TH */
/*         COLUMN IN THIS ORDER IS LIST(J). */

/*       MAXCLQ IS AN INTEGER OUTPUT VARIABLE SET TO THE SIZE */
/*         OF THE LARGEST CLIQUE FOUND DURING THE ORDERING. */

/*       IWA1,IWA2,IWA3, AND IWA4 ARE INTEGER WORK ARRAYS OF LENGTH N. */

/*       BWA IS A LOGICAL WORK ARRAY OF LENGTH N. */

/*     SUBPROGRAMS CALLED */

/*       MINPACK-SUPPLIED ... N7MSRT */

/*       FORTRAN-SUPPLIED ... MAX0 */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     SORT THE DEGREE SEQUENCE. */

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
    i__1 = *n - 1;
    n7msrt_(n, &i__1, &ndeg[1], &c_n1, &iwa4[1], &iwa1[1], &iwa3[1]);

/*     INITIALIZATION BLOCK. */

/*     CREATE A DOUBLY-LINKED LIST TO ACCESS THE INCIDENCES OF THE */
/*     COLUMNS. THE POINTERS FOR THE LINKED LIST ARE AS FOLLOWS. */

/*     EACH UN-ORDERED COLUMN JCOL IS IN A LIST (THE INCIDENCE LIST) */
/*     OF COLUMNS WITH THE SAME INCIDENCE. */

/*     IWA1(NUMINC+1) IS THE FIRST COLUMN IN THE NUMINC LIST */
/*     UNLESS IWA1(NUMINC+1) = 0. IN THIS CASE THERE ARE */
/*     NO COLUMNS IN THE NUMINC LIST. */

/*     IWA2(JCOL) IS THE COLUMN BEFORE JCOL IN THE INCIDENCE LIST */
/*     UNLESS IWA2(JCOL) = 0. IN THIS CASE JCOL IS THE FIRST */
/*     COLUMN IN THIS INCIDENCE LIST. */

/*     IWA3(JCOL) IS THE COLUMN AFTER JCOL IN THE INCIDENCE LIST */
/*     UNLESS IWA3(JCOL) = 0. IN THIS CASE JCOL IS THE LAST */
/*     COLUMN IN THIS INCIDENCE LIST. */

/*     IF JCOL IS AN UN-ORDERED COLUMN, THEN LIST(JCOL) IS THE */
/*     INCIDENCE OF JCOL IN THE GRAPH. IF JCOL IS AN ORDERED COLUMN, */
/*     THEN LIST(JCOL) IS THE INCIDENCE-DEGREE ORDER OF COLUMN JCOL. */

    maxinc = 0;
    i__1 = *n;
    for (jp = 1; jp <= i__1; ++jp) {
	list[jp] = 0;
	bwa[jp] = FALSE_;
	iwa1[jp] = 0;
	l = iwa4[jp];
	if (jp != 1) {
	    iwa2[l] = iwa4[jp - 1];
	}
	if (jp != *n) {
	    iwa3[l] = iwa4[jp + 1];
	}
/* L10: */
    }
    iwa1[1] = iwa4[1];
    l = iwa4[1];
    iwa2[l] = 0;
    l = iwa4[*n];
    iwa3[l] = 0;

/*     DETERMINE THE MAXIMAL SEARCH LENGTH FOR THE LIST */
/*     OF COLUMNS OF MAXIMAL INCIDENCE. */

    maxlst = 0;
    i__1 = *m;
    for (ir = 1; ir <= i__1; ++ir) {
/* Computing 2nd power */
	i__2 = ipntr[ir + 1] - ipntr[ir];
	maxlst += i__2 * i__2;
/* L20: */
    }
    maxlst /= *n;
    *maxclq = 1;

/*     BEGINNING OF ITERATION LOOP. */

    i__1 = *n;
    for (numord = 1; numord <= i__1; ++numord) {

/*        CHOOSE A COLUMN JCOL OF MAXIMAL DEGREE AMONG THE */
/*        COLUMNS OF MAXIMAL INCIDENCE. */

	jp = iwa1[maxinc + 1];
	numlst = 1;
	numwgt = -1;
L30:
	if (ndeg[jp] <= numwgt) {
	    goto L40;
	}
	numwgt = ndeg[jp];
	jcol = jp;
L40:
	jp = iwa3[jp];
	++numlst;
	if (jp > 0 && numlst <= maxlst) {
	    goto L30;
	}
	list[jcol] = numord;

/*        DELETE COLUMN JCOL FROM THE LIST OF COLUMNS OF */
/*        MAXIMAL INCIDENCE. */

	l = iwa2[jcol];
	if (l == 0) {
	    iwa1[maxinc + 1] = iwa3[jcol];
	}
	if (l > 0) {
	    iwa3[l] = iwa3[jcol];
	}
	l = iwa3[jcol];
	if (l > 0) {
	    iwa2[l] = iwa2[jcol];
	}

/*        UPDATE THE SIZE OF THE LARGEST CLIQUE */
/*        FOUND DURING THE ORDERING. */

	if (maxinc == 0) {
	    ncomp = 0;
	}
	++ncomp;
	if (maxinc + 1 == ncomp) {
	    *maxclq = max(*maxclq,ncomp);
	}

/*        UPDATE THE MAXIMAL INCIDENCE COUNT. */

L50:
	if (iwa1[maxinc + 1] > 0) {
	    goto L60;
	}
	--maxinc;
	if (maxinc >= 0) {
	    goto L50;
	}
L60:

/*        FIND ALL COLUMNS ADJACENT TO COLUMN JCOL. */

	bwa[jcol] = TRUE_;
	deg = 0;

/*        DETERMINE ALL POSITIONS (IR,JCOL) WHICH CORRESPOND */
/*        TO NON-ZEROES IN THE MATRIX. */

	jpl = jpntr[jcol];
	jpu = jpntr[jcol + 1] - 1;
	if (jpu < jpl) {
	    goto L100;
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

/*              ARRAY BWA MARKS COLUMNS WHICH ARE ADJACENT TO */
/*              COLUMN JCOL. ARRAY IWA4 RECORDS THE MARKED COLUMNS. */

		if (bwa[ic]) {
		    goto L70;
		}
		bwa[ic] = TRUE_;
		++deg;
		iwa4[deg] = ic;
L70:
/* L80: */
		;
	    }
/* L90: */
	}
L100:

/*        UPDATE THE POINTERS TO THE INCIDENCE LISTS. */

	if (deg < 1) {
	    goto L130;
	}
	i__2 = deg;
	for (jp = 1; jp <= i__2; ++jp) {
	    ic = iwa4[jp];
	    if (list[ic] > 0) {
		goto L110;
	    }
	    numinc = -list[ic] + 1;
	    list[ic] = -numinc;
	    maxinc = max(maxinc,numinc);

/*           DELETE COLUMN IC FROM THE NUMINC-1 LIST. */

	    l = iwa2[ic];
	    if (l == 0) {
		iwa1[numinc] = iwa3[ic];
	    }
	    if (l > 0) {
		iwa3[l] = iwa3[ic];
	    }
	    l = iwa3[ic];
	    if (l > 0) {
		iwa2[l] = iwa2[ic];
	    }

/*           ADD COLUMN IC TO THE NUMINC LIST. */

	    head = iwa1[numinc + 1];
	    iwa1[numinc + 1] = ic;
	    iwa2[ic] = 0;
	    iwa3[ic] = head;
	    if (head > 0) {
		iwa2[head] = ic;
	    }
L110:

/*           UN-MARK COLUMN IC IN THE ARRAY BWA. */

	    bwa[ic] = FALSE_;
/* L120: */
	}
L130:
	bwa[jcol] = FALSE_;

/*        END OF ITERATION LOOP. */

/* L140: */
    }

/*     INVERT THE ARRAY LIST. */

    i__1 = *n;
    for (jcol = 1; jcol <= i__1; ++jcol) {
	numord = list[jcol];
	iwa1[numord] = jcol;
/* L150: */
    }
    i__1 = *n;
    for (jp = 1; jp <= i__1; ++jp) {
	list[jp] = iwa1[jp];
/* L160: */
    }
    return 0;

/*     LAST CARD OF SUBROUTINE I7DO. */

} /* i7do_ */

