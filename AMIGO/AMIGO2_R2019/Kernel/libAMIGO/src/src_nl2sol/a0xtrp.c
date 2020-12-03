/* a0xtrp.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int a0xtrp_(real *tm, integer *m, integer *nvar, real *ng, 
	integer *kmax, logical *xpoly, real *t, real *error, real *ebest, 
	real *rhg, real *emag, logical *esave)
{
    /* System generated locals */
    integer t_dim1, t_offset, error_dim1, error_offset, i__1, i__2;
    real r__1;

    /* Local variables */
    static integer i__, j;
    static real u, v, ti;
    static integer mr;
    static real tv;
    static integer mmj;
    static real err, temp;
    static integer jbest;


/*     REAL RHG(MIN(M-1,KMAX)) */
/*     REAL ERROR(NVAR,MIN(M-1,KMAX)),EMAG(MIN(M-1,KMAX)) */


    /* Parameter adjustments */
    --ng;
    --ebest;
    error_dim1 = *nvar;
    error_offset = 1 + error_dim1;
    error -= error_offset;
    --tm;
    t_dim1 = *nvar;
    t_offset = 1 + t_dim1;
    t -= t_offset;
    --rhg;
    --emag;

    /* Function Body */
    if (*m > 1) {
	goto L20;
    }

/* ... INITIALIZE T. */

    i__1 = *nvar;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L10: */
	t[i__ + t_dim1] = tm[i__];
    }

    goto L80;

L20:
/* Computing MIN */
    i__1 = *m - 1;
    mr = min(i__1,*kmax);

    i__1 = mr;
    for (j = 1; j <= i__1; ++j) {
	mmj = *m - j;
	rhg[j] = ng[*m] / ng[mmj];
	emag[j] = 1.f / (rhg[j] - 1.f) + 1.f;
	if (*xpoly) {
	    rhg[j] += -1.f;
	}
/* L30: */
    }

    i__1 = *nvar;
    for (i__ = 1; i__ <= i__1; ++i__) {

	v = 0.f;
	u = t[i__ + t_dim1];
	ti = tm[i__];
	t[i__ + t_dim1] = ti;

	i__2 = mr;
	for (j = 1; j <= i__2; ++j) {

/* ......... OBTAIN SIGNED ERROR ESTIMATE. */

	    err = (t[i__ + j * t_dim1] - u) * emag[j];
	    if (*esave) {
		error[i__ + j * error_dim1] = err;
	    }
	    err = dabs(err);
	    if (j == 1) {
		ebest[i__] = err;
	    }
/* Computing MIN */
	    r__1 = ebest[i__];
	    ebest[i__] = dmin(r__1,err);
	    if (ebest[i__] == err) {
		jbest = j;
	    }

	    if (j == *kmax) {
		goto L60;
	    }

	    if (*xpoly) {
		goto L40;
	    }

/* ......... RATIONAL EXTRAPOLATION. */

	    tv = ti - v;
	    temp = rhg[j] * (u - v) - tv;
	    if (temp != 0.f) {
		ti += (ti - u) * (tv / temp);
	    }
	    v = u;
	    goto L50;

/* ......... POLYNOMIAL EXTRAPOLATION. */

L40:
	    ti += (ti - u) / rhg[j];

L50:
	    u = t[i__ + (j + 1) * t_dim1];
	    t[i__ + (j + 1) * t_dim1] = ti;
L60:
	    ;
	}

/* L70: */
	tm[i__] = t[i__ + jbest * t_dim1];
    }

L80:
    return 0;

} /* a0xtrp_ */

