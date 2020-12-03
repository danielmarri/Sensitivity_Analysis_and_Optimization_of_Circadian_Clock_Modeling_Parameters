/* zero.f -- translated by f2c (version 20100827).
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

static integer c__1 = 1;
static integer c__46 = 46;
static integer c__4 = 4;

doublereal zero_(E_fp f, real *a, real *b, real *t)
{
    /* System generated locals */
    real ret_val, r__1, r__2;

    /* Builtin functions */
    double r_sign(real *, real *);

    /* Local variables */
    static real c__, d__, e, m, p, q, r__, s, fa, fb, fc, sa, sb, tt, tol;
    extern doublereal r1mach_(integer *);
    extern /* Subroutine */ int seterr_(char *, integer *, integer *, integer 
	    *, ftnlen);


/*  FINDS THE REAL ROOT OF THE FUNCTION F LYING BETWEEN A AND B */
/*  TO WITHIN A TOLERANCE OF */

/*         6*R1MACH(3) * ABS(ZERO) + 2 * T */

/*  F(A) AND F(B) MUST HAVE OPPOSITE SIGNS */

/*  THIS IS BRENTS ALGORITHM */

/*  A, STORED IN SA, IS THE PREVIOUS BEST APPROXIMATION (I.E. THE OLD B) */
/*  B, STORED IN SB, IS THE CURRENT BEST APPROXIMATION */
/*  C IS THE MOST RECENTLY COMPUTED POINT SATISFYING F(B)*F(C) .LT. 0 */
/*  D CONTAINS THE CORRECTION TO THE APPROXIMATION */
/*  E CONTAINS THE PREVIOUS VALUE OF D */
/*  M CONTAINS THE BISECTION QUANTITY (C-B)/2 */


    tt = *t;
    if (*t <= 0.f) {
	tt = r1mach_(&c__1) * 10.f;
    }

    sa = *a;
    sb = *b;
    fa = (*f)(&sa);
    fb = (*f)(&sb);
    if (fa != 0.f) {
	goto L5;
    }
    ret_val = sa;
    return ret_val;
L5:
    if (fb == 0.f) {
	goto L140;
    }
/* /6S */
/*     IF (SIGN(FA,FB) .EQ. FA) CALL SETERR( */
/*    1   46H ZERO - F(A) AND F(B) ARE NOT OF OPPOSITE SIGN, 46, 1, 1) */
/* /7S */
    if (r_sign(&fa, &fb) == fa) {
	seterr_(" ZERO - F(A) AND F(B) ARE NOT OF OPPOSITE SIGN", &c__46, &
		c__1, &c__1, (ftnlen)46);
    }
/* / */

L10:
    c__ = sa;
    fc = fa;
    e = sb - sa;
    d__ = e;

/*  INTERCHANGE B AND C IF ABS F(C) .LT. ABS F(B) */

L20:
    if (dabs(fc) >= dabs(fb)) {
	goto L30;
    }
    sa = sb;
    sb = c__;
    c__ = sa;
    fa = fb;
    fb = fc;
    fc = fa;

L30:
    tol = r1mach_(&c__4) * 2.f * dabs(sb) + tt;
    m = (c__ - sb) * .5f;

/*  SUCCESS INDICATED BY M REDUCES TO UNDER TOLERANCE OR */
/*  BY F(B) = 0 */

    if (dabs(m) <= tol || fb == 0.f) {
	goto L140;
    }

/*  A BISECTION IS FORCED IF E, THE NEXT-TO-LAST CORRECTION */
/*  WAS LESS THAN THE TOLERANCE OR IF THE PREVIOUS B GAVE */
/*  A SMALLER F(B).  OTHERWISE GO TO 40. */

    if (dabs(e) >= tol && dabs(fa) >= dabs(fb)) {
	goto L40;
    }
    e = m;
    d__ = e;
    goto L100;
L40:
    s = fb / fa;

/*  QUADRATIC INTERPOLATION CAN ONLY BE DONE IF A (IN SA) */
/*  AND C ARE DIFFERENT POINTS. */
/*  OTHERWISE DO THE FOLLOWING LINEAR INTERPOLATION */

    if (sa != c__) {
	goto L50;
    }
    p = m * 2.f * s;
    q = 1.f - s;
    goto L60;

/*  INVERSE QUADRATIC INTERPOLATION */

L50:
    q = fa / fc;
    r__ = fb / fc;
    p = s * (m * 2.f * q * (q - r__) - (sb - sa) * (r__ - 1.f));
    q = (q - 1.f) * (r__ - 1.f) * (s - 1.f);
L60:
    if (p <= 0.f) {
	goto L70;
    }
    q = -q;
    goto L80;
L70:
    p = -p;

/*  UPDATE THE QUANTITIES USING THE NEWLY COMPUTED */
/*  INTERPOLATE UNLESS IT WOULD EITHER FORCE THE */
/*  NEW POINT TOO FAR TO ONE SIDE OF THE INTERVAL */
/*  OR WOULD REPRESENT A CORRECTION GREATER THAN */
/*  HALF THE PREVIOUS CORRECTION. */

/*  IN THESE LAST TWO CASES - DO THE BISECTION */
/*  BELOW (FROM STATEMENT 90 TO 100) */

L80:
    s = e;
    e = d__;
    if (p * 2.f >= m * 3.f * q - (r__1 = tol * q, dabs(r__1)) || p >= (r__2 = 
	    s * .5f * q, dabs(r__2))) {
	goto L90;
    }
    d__ = p / q;
    goto L100;
L90:
    e = m;
    d__ = e;

/*  SET A TO THE PREVIOUS B */

L100:
    sa = sb;
    fa = fb;

/*  IF THE CORRECTION TO BE MADE IS SMALLER THAN */
/*  THE TOLERANCE, JUST TAKE A  DELTA STEP  (DELTA=TOLERANCE) */
/*         B = B + DELTA * SIGN(M) */

    if (dabs(d__) <= tol) {
	goto L110;
    }
    sb += d__;
    goto L130;

L110:
    if (m <= 0.f) {
	goto L120;
    }
    sb += tol;
    goto L130;

L120:
    sb -= tol;
L130:
    fb = (*f)(&sb);

/*  IF F(B) AND F(C) HAVE THE SAME SIGN ONLY */
/*  LINEAR INTERPOLATION (NOT INVERSE QUADRATIC) */
/*  CAN BE DONE */

    if (fb > 0.f && fc > 0.f) {
	goto L10;
    }
    if (fb <= 0.f && fc <= 0.f) {
	goto L10;
    }
    goto L20;

/* ***SUCCESS*** */
L140:
    ret_val = sb;
    return ret_val;
} /* zero_ */

