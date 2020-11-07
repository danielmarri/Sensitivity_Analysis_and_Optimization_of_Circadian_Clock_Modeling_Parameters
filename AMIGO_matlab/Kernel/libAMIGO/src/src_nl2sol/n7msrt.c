/* n7msrt.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int n7msrt_(integer *n, integer *nmax, integer *num, integer 
	*mode, integer *index, integer *last, integer *next)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, j, k, l, jp, nmaxp1, nmaxp2;

/*     **********. */

/*     SUBROUTINE N7MSRT */

/*     GIVEN A SEQUENCE OF INTEGERS, THIS SUBROUTINE GROUPS */
/*     TOGETHER THOSE INDICES WITH THE SAME SEQUENCE VALUE */
/*     AND, OPTIONALLY, SORTS THE SEQUENCE INTO EITHER */
/*     ASCENDING OR DESCENDING ORDER. */

/*     THE SEQUENCE OF INTEGERS IS DEFINED BY THE ARRAY NUM, */
/*     AND IT IS ASSUMED THAT THE INTEGERS ARE EACH FROM THE SET */
/*     0,1,...,NMAX. ON OUTPUT THE INDICES K SUCH THAT NUM(K) = L */
/*     FOR ANY L = 0,1,...,NMAX CAN BE OBTAINED FROM THE ARRAYS */
/*     LAST AND NEXT AS FOLLOWS. */

/*           K = LAST(L+1) */
/*           WHILE (K .NE. 0) K = NEXT(K) */

/*     OPTIONALLY, THE SUBROUTINE PRODUCES AN ARRAY INDEX SO THAT */
/*     THE SEQUENCE NUM(INDEX(I)), I = 1,2,...,N IS SORTED. */

/*     THE SUBROUTINE STATEMENT IS */

/*       SUBROUTINE N7MSRT(N,NMAX,NUM,MODE,INDEX,LAST,NEXT) */

/*     WHERE */

/*       N IS A POSITIVE INTEGER INPUT VARIABLE. */

/*       NMAX IS A POSITIVE INTEGER INPUT VARIABLE. */

/*       NUM IS AN INPUT ARRAY OF LENGTH N WHICH CONTAINS THE */
/*         SEQUENCE OF INTEGERS TO BE GROUPED AND SORTED. IT */
/*         IS ASSUMED THAT THE INTEGERS ARE EACH FROM THE SET */
/*         0,1,...,NMAX. */

/*       MODE IS AN INTEGER INPUT VARIABLE. THE SEQUENCE NUM IS */
/*         SORTED IN ASCENDING ORDER IF MODE IS POSITIVE AND IN */
/*         DESCENDING ORDER IF MODE IS NEGATIVE. IF MODE IS 0, */
/*         NO SORTING IS DONE. */

/*       INDEX IS AN INTEGER OUTPUT ARRAY OF LENGTH N SET SO */
/*         THAT THE SEQUENCE */

/*               NUM(INDEX(I)), I = 1,2,...,N */

/*         IS SORTED ACCORDING TO THE SETTING OF MODE. IF MODE */
/*         IS 0, INDEX IS NOT REFERENCED. */

/*       LAST IS AN INTEGER OUTPUT ARRAY OF LENGTH NMAX + 1. THE */
/*         INDEX OF NUM FOR THE LAST OCCURRENCE OF L IS LAST(L+1) */
/*         FOR ANY L = 0,1,...,NMAX UNLESS LAST(L+1) = 0. IN */
/*         THIS CASE L DOES NOT APPEAR IN NUM. */

/*       NEXT IS AN INTEGER OUTPUT ARRAY OF LENGTH N. IF */
/*         NUM(K) = L, THEN THE INDEX OF NUM FOR THE PREVIOUS */
/*         OCCURRENCE OF L IS NEXT(K) FOR ANY L = 0,1,...,NMAX */
/*         UNLESS NEXT(K) = 0. IN THIS CASE THERE IS NO PREVIOUS */
/*         OCCURRENCE OF L IN NUM. */

/*     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1982. */
/*     THOMAS F. COLEMAN, BURTON S. GARBOW, JORGE J. MORE */

/*     ********** */

/*     DETERMINE THE ARRAYS NEXT AND LAST. */

    /* Parameter adjustments */
    --next;
    --index;
    --num;
    --last;

    /* Function Body */
    nmaxp1 = *nmax + 1;
    i__1 = nmaxp1;
    for (i__ = 1; i__ <= i__1; ++i__) {
	last[i__] = 0;
/* L10: */
    }
    i__1 = *n;
    for (k = 1; k <= i__1; ++k) {
	l = num[k];
	next[k] = last[l + 1];
	last[l + 1] = k;
/* L20: */
    }
    if (*mode == 0) {
	goto L60;
    }

/*     STORE THE POINTERS TO THE SORTED ARRAY IN INDEX. */

    i__ = 1;
    nmaxp2 = nmaxp1 + 1;
    i__1 = nmaxp1;
    for (j = 1; j <= i__1; ++j) {
	jp = j;
	if (*mode < 0) {
	    jp = nmaxp2 - j;
	}
	k = last[jp];
L30:
	if (k == 0) {
	    goto L40;
	}
	index[i__] = k;
	++i__;
	k = next[k];
	goto L30;
L40:
/* L50: */
	;
    }
L60:
    return 0;

/*     LAST CARD OF SUBROUTINE N7MSRT. */

} /* n7msrt_ */

