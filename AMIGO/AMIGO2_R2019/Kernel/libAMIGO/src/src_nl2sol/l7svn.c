/* l7svn.f -- translated by f2c (version 20100827).
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

doublereal l7svn_(integer *p, real *l, real *x, real *y)
{
    /* System generated locals */
    integer i__1, i__2;
    real ret_val, r__1;

    /* Local variables */
    static real b;
    static integer i__, j;
    static real t;
    static integer j0, ii, ji, jj, ix, jm1, pm1, jjj;
    extern doublereal d7tpr_(integer *, real *, real *), v2nrm_(integer *, 
	    real *);
    extern /* Subroutine */ int v2axy_(integer *, real *, real *, real *, 
	    real *);
    static real splus, xplus, sminus, xminus;


/*  ***  ESTIMATE SMALLEST SING. VALUE OF PACKED LOWER TRIANG. MATRIX L */

/*  ***  PARAMETER DECLARATIONS  *** */

/*     DIMENSION L(P*(P+1)/2) */

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/*  ***  PURPOSE  *** */

/*     THIS FUNCTION RETURNS A GOOD OVER-ESTIMATE OF THE SMALLEST */
/*     SINGULAR VALUE OF THE PACKED LOWER TRIANGULAR MATRIX L. */

/*  ***  PARAMETER DESCRIPTION  *** */

/*  P (IN)  = THE ORDER OF L.  L IS A  P X P  LOWER TRIANGULAR MATRIX. */
/*  L (IN)  = ARRAY HOLDING THE ELEMENTS OF  L  IN ROW ORDER, I.E. */
/*             L(1,1), L(2,1), L(2,2), L(3,1), L(3,2), L(3,3), ETC. */
/*  X (OUT) IF  L7SVN RETURNS A POSITIVE VALUE, THEN X IS A NORMALIZED */
/*             APPROXIMATE LEFT SINGULAR VECTOR CORRESPONDING TO THE */
/*             SMALLEST SINGULAR VALUE.  THIS APPROXIMATION MAY BE VERY */
/*             CRUDE.  IF  L7SVN RETURNS ZERO, THEN SOME COMPONENTS OF X */
/*             ARE ZERO AND THE REST RETAIN THEIR INPUT VALUES. */
/*  Y (OUT) IF  L7SVN RETURNS A POSITIVE VALUE, THEN Y = (L**-1)*X IS AN */
/*             UNNORMALIZED APPROXIMATE RIGHT SINGULAR VECTOR CORRESPOND- */
/*             ING TO THE SMALLEST SINGULAR VALUE.  THIS APPROXIMATION */
/*             MAY BE CRUDE.  IF  L7SVN RETURNS ZERO, THEN Y RETAINS ITS */
/*             INPUT VALUE.  THE CALLER MAY PASS THE SAME VECTOR FOR X */
/*             AND Y (NONSTANDARD FORTRAN USAGE), IN WHICH CASE Y OVER- */
/*             WRITES X (FOR NONZERO  L7SVN RETURNS). */

/*  ***  ALGORITHM NOTES  *** */

/*     THE ALGORITHM IS BASED ON (1), WITH THE ADDITIONAL PROVISION THAT */
/*      L7SVN = 0 IS RETURNED IF THE SMALLEST DIAGONAL ELEMENT OF L */
/*     (IN MAGNITUDE) IS NOT MORE THAN THE UNIT ROUNDOFF TIMES THE */
/*     LARGEST.  THE ALGORITHM USES A RANDOM NUMBER GENERATOR PROPOSED */
/*     IN (4), WHICH PASSES THE SPECTRAL TEST WITH FLYING COLORS -- SEE */
/*     (2) AND (3). */

/*  ***  SUBROUTINES AND FUNCTIONS CALLED  *** */

/*         V2NRM - FUNCTION, RETURNS THE 2-NORM OF A VECTOR. */

/*  ***  REFERENCES  *** */

/*     (1) CLINE, A., MOLER, C., STEWART, G., AND WILKINSON, J.H.(1977), */
/*         AN ESTIMATE FOR THE CONDITION NUMBER OF A MATRIX, REPORT */
/*         TM-310, APPLIED MATH. DIV., ARGONNE NATIONAL LABORATORY. */

/*     (2) HOAGLIN, D.C. (1976), THEORETICAL PROPERTIES OF CONGRUENTIAL */
/*         RANDOM-NUMBER GENERATORS --  AN EMPIRICAL VIEW, */
/*         MEMORANDUM NS-340, DEPT. OF STATISTICS, HARVARD UNIV. */

/*     (3) KNUTH, D.E. (1969), THE ART OF COMPUTER PROGRAMMING, VOL. 2 */
/*         (SEMINUMERICAL ALGORITHMS), ADDISON-WESLEY, READING, MASS. */

/*     (4) SMITH, C.S. (1971), MULTIPLICATIVE PSEUDO-RANDOM NUMBER */
/*         GENERATORS WITH PRIME MODULUS, J. ASSOC. COMPUT. MACH. 18, */
/*         PP. 586-593. */

/*  ***  HISTORY  *** */

/*     DESIGNED AND CODED BY DAVID M. GAY (WINTER 1977/SUMMER 1978). */

/*  ***  GENERAL  *** */

/*     THIS SUBROUTINE WAS WRITTEN IN CONNECTION WITH RESEARCH */
/*     SUPPORTED BY THE NATIONAL SCIENCE FOUNDATION UNDER GRANTS */
/*     MCS-7600324, DCR75-10143, 76-14311DSS, AND MCS76-11989. */

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/*  ***  LOCAL VARIABLES  *** */


/*  ***  CONSTANTS  *** */


/*  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  *** */


/* /6 */
/*     DATA HALF/0.5E+0/, ONE/1.E+0/, R9973/9973.E+0/, ZERO/0.E+0/ */
/* /7 */
/* / */

/*  ***  BODY  *** */

    /* Parameter adjustments */
    --y;
    --x;
    --l;

    /* Function Body */
    ix = 2;
    pm1 = *p - 1;

/*  ***  FIRST CHECK WHETHER TO RETURN  L7SVN = 0 AND INITIALIZE X  *** */

    ii = 0;
    j0 = *p * pm1 / 2;
    jj = j0 + *p;
    if (l[jj] == 0.f) {
	goto L110;
    }
    ix = ix * 3432 % 9973;
    b = ((real) ix / 9973.f + 1.f) * .5f;
    xplus = b / l[jj];
    x[*p] = xplus;
    if (*p <= 1) {
	goto L60;
    }
    i__1 = pm1;
    for (i__ = 1; i__ <= i__1; ++i__) {
	ii += i__;
	if (l[ii] == 0.f) {
	    goto L110;
	}
	ji = j0 + i__;
	x[i__] = xplus * l[ji];
/* L10: */
    }

/*  ***  SOLVE (L**T)*X = B, WHERE THE COMPONENTS OF B HAVE RANDOMLY */
/*  ***  CHOSEN MAGNITUDES IN (.5,1) WITH SIGNS CHOSEN TO MAKE X LARGE. */

/*     DO J = P-1 TO 1 BY -1... */
    i__1 = pm1;
    for (jjj = 1; jjj <= i__1; ++jjj) {
	j = *p - jjj;
/*       ***  DETERMINE X(J) IN THIS ITERATION. NOTE FOR I = 1,2,...,J */
/*       ***  THAT X(I) HOLDS THE CURRENT PARTIAL SUM FOR ROW I. */
	ix = ix * 3432 % 9973;
	b = ((real) ix / 9973.f + 1.f) * .5f;
	xplus = b - x[j];
	xminus = -b - x[j];
	splus = dabs(xplus);
	sminus = dabs(xminus);
	jm1 = j - 1;
	j0 = j * jm1 / 2;
	jj = j0 + j;
	xplus /= l[jj];
	xminus /= l[jj];
	if (jm1 == 0) {
	    goto L30;
	}
	i__2 = jm1;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    ji = j0 + i__;
	    splus += (r__1 = x[i__] + l[ji] * xplus, dabs(r__1));
	    sminus += (r__1 = x[i__] + l[ji] * xminus, dabs(r__1));
/* L20: */
	}
L30:
	if (sminus > splus) {
	    xplus = xminus;
	}
	x[j] = xplus;
/*       ***  UPDATE PARTIAL SUMS  *** */
	if (jm1 > 0) {
	    v2axy_(&jm1, &x[1], &xplus, &l[j0 + 1], &x[1]);
	}
/* L50: */
    }

/*  ***  NORMALIZE X  *** */

L60:
    t = 1.f / v2nrm_(p, &x[1]);
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L70: */
	x[i__] = t * x[i__];
    }

/*  ***  SOLVE L*Y = X AND RETURN  L7SVN = 1/TWONORM(Y)  *** */

    i__1 = *p;
    for (j = 1; j <= i__1; ++j) {
	jm1 = j - 1;
	j0 = j * jm1 / 2;
	jj = j0 + j;
	t = 0.f;
	if (jm1 > 0) {
	    t = d7tpr_(&jm1, &l[j0 + 1], &y[1]);
	}
	y[j] = (x[j] - t) / l[jj];
/* L100: */
    }

    ret_val = 1.f / v2nrm_(p, &y[1]);
    goto L999;

L110:
    ret_val = 0.f;
L999:
    return ret_val;
/*  ***  LAST CARD OF  L7SVN FOLLOWS  *** */
} /* l7svn_ */

