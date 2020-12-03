/* q7rad.f -- translated by f2c (version 20100827).
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
static integer c__6 = 6;
static integer c__5 = 5;
static integer c__2 = 2;

/* Subroutine */ int q7rad_(integer *n, integer *nn, integer *p, real *qtr, 
	logical *qtrset, real *rmat, real *w, real *y)
{
    /* Initialized data */

    static real big = -1.f;
    static real bigrt = -1.f;
    static real one = 1.f;
    static real tiny = 0.f;
    static real tinyrt = 0.f;
    static real zero = 0.f;

    /* System generated locals */
    integer w_dim1, w_offset, i__1, i__2;
    real r__1;

    /* Builtin functions */
    double sqrt(doublereal);

    /* Local variables */
    static integer i__, j, k;
    static real s, t;
    static integer ii, ij, nk;
    static real ri, wi;
    static integer ip1;
    static real ari, qri;
    extern doublereal r7mdc_(integer *);
    extern /* Subroutine */ int v7scl_(integer *, real *, real *, real *);
    extern doublereal d7tpr_(integer *, real *, real *), v2nrm_(integer *, 
	    real *);
    extern /* Subroutine */ int v2axy_(integer *, real *, real *, real *, 
	    real *);


/*  ***  ADD ROWS W TO QR FACTORIZATION WITH R MATRIX RMAT AND */
/*  ***  Q**T * RESIDUAL = QTR.  Y = NEW COMPONENTS OF RESIDUAL */
/*  ***  CORRESPONDING TO W.  QTR, Y REFERENCED ONLY IF QTRSET = .TRUE. */

/*     DIMENSION RMAT(P*(P+1)/2) */
/* /+ */
/* / */

/*  ***  LOCAL VARIABLES  *** */

/* /7 */
/* / */
    /* Parameter adjustments */
    --y;
    w_dim1 = *nn;
    w_offset = 1 + w_dim1;
    w -= w_offset;
    --qtr;
    --rmat;

    /* Function Body */

/* ------------------------------ BODY ----------------------------------- */

    if (tiny > zero) {
	goto L10;
    }
    tiny = r7mdc_(&c__1);
    big = r7mdc_(&c__6);
    if (tiny * big < one) {
	tiny = one / big;
    }
L10:
    k = 1;
    nk = *n;
    ii = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	ii += i__;
	ip1 = i__ + 1;
	ij = ii + i__;
	if (nk <= 1) {
	    t = (r__1 = w[k + i__ * w_dim1], dabs(r__1));
	}
	if (nk > 1) {
	    t = v2nrm_(&nk, &w[k + i__ * w_dim1]);
	}
	if (t < tiny) {
	    goto L180;
	}
	ri = rmat[ii];
	if (ri != zero) {
	    goto L100;
	}
	if (nk > 1) {
	    goto L30;
	}
	ij = ii;
	i__2 = *p;
	for (j = i__; j <= i__2; ++j) {
	    rmat[ij] = w[k + j * w_dim1];
	    ij += j;
/* L20: */
	}
	if (*qtrset) {
	    qtr[i__] = y[k];
	}
	w[k + i__ * w_dim1] = zero;
	goto L999;
L30:
	wi = w[k + i__ * w_dim1];
	if (bigrt > zero) {
	    goto L40;
	}
	bigrt = r7mdc_(&c__5);
	tinyrt = r7mdc_(&c__2);
L40:
	if (t <= tinyrt) {
	    goto L50;
	}
	if (t >= bigrt) {
	    goto L50;
	}
	if (wi < zero) {
	    t = -t;
	}
	wi += t;
	s = sqrt(t * wi);
	goto L70;
L50:
	s = sqrt(t);
	if (wi < zero) {
	    goto L60;
	}
	wi += t;
	s *= sqrt(wi);
	goto L70;
L60:
	t = -t;
	wi += t;
	s *= sqrt(-wi);
L70:
	w[k + i__ * w_dim1] = wi;
	r__1 = one / s;
	v7scl_(&nk, &w[k + i__ * w_dim1], &r__1, &w[k + i__ * w_dim1]);
	rmat[ii] = -t;
	if (! (*qtrset)) {
	    goto L80;
	}
	r__1 = -d7tpr_(&nk, &y[k], &w[k + i__ * w_dim1]);
	v2axy_(&nk, &y[k], &r__1, &w[k + i__ * w_dim1], &y[k]);
	qtr[i__] = y[k];
L80:
	if (ip1 > *p) {
	    goto L999;
	}
	i__2 = *p;
	for (j = ip1; j <= i__2; ++j) {
	    r__1 = -d7tpr_(&nk, &w[k + j * w_dim1], &w[k + i__ * w_dim1]);
	    v2axy_(&nk, &w[k + j * w_dim1], &r__1, &w[k + i__ * w_dim1], &w[k 
		    + j * w_dim1]);
	    rmat[ij] = w[k + j * w_dim1];
	    ij += j;
/* L90: */
	}
	if (nk <= 1) {
	    goto L999;
	}
	++k;
	--nk;
	goto L180;

L100:
	ari = dabs(ri);
	if (ari > t) {
	    goto L110;
	}
/* Computing 2nd power */
	r__1 = ari / t;
	t *= sqrt(one + r__1 * r__1);
	goto L120;
L110:
/* Computing 2nd power */
	r__1 = t / ari;
	t = ari * sqrt(one + r__1 * r__1);
L120:
	if (ri < zero) {
	    t = -t;
	}
	ri += t;
	rmat[ii] = -t;
	s = -ri / t;
	if (nk <= 1) {
	    goto L150;
	}
	r__1 = one / ri;
	v7scl_(&nk, &w[k + i__ * w_dim1], &r__1, &w[k + i__ * w_dim1]);
	if (! (*qtrset)) {
	    goto L130;
	}
	qri = qtr[i__];
	t = s * (qri + d7tpr_(&nk, &y[k], &w[k + i__ * w_dim1]));
	qtr[i__] = qri + t;
L130:
	if (ip1 > *p) {
	    goto L999;
	}
	if (*qtrset) {
	    v2axy_(&nk, &y[k], &t, &w[k + i__ * w_dim1], &y[k]);
	}
	i__2 = *p;
	for (j = ip1; j <= i__2; ++j) {
	    ri = rmat[ij];
	    t = s * (ri + d7tpr_(&nk, &w[k + j * w_dim1], &w[k + i__ * w_dim1]
		    ));
	    v2axy_(&nk, &w[k + j * w_dim1], &t, &w[k + i__ * w_dim1], &w[k + 
		    j * w_dim1]);
	    rmat[ij] = ri + t;
	    ij += j;
/* L140: */
	}
	goto L180;

L150:
	wi = w[k + i__ * w_dim1] / ri;
	w[k + i__ * w_dim1] = wi;
	if (! (*qtrset)) {
	    goto L160;
	}
	qri = qtr[i__];
	t = s * (qri + y[k] * wi);
	qtr[i__] = qri + t;
L160:
	if (ip1 > *p) {
	    goto L999;
	}
	if (*qtrset) {
	    y[k] = t * wi + y[k];
	}
	i__2 = *p;
	for (j = ip1; j <= i__2; ++j) {
	    ri = rmat[ij];
	    t = s * (ri + w[k + j * w_dim1] * wi);
	    w[k + j * w_dim1] += t * wi;
	    rmat[ij] = ri + t;
	    ij += j;
/* L170: */
	}
L180:
	;
    }

L999:
    return 0;
/*  ***  LAST LINE OF Q7RAD FOLLOWS  *** */
} /* q7rad_ */

