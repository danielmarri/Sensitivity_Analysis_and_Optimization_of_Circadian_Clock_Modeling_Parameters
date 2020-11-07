/* q7rfh.f -- translated by f2c (version 20100827).
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

static integer c__5 = 5;
static integer c__3 = 3;
static integer c__2 = 2;
static integer c__1 = 1;
static integer c__6 = 6;
static real c_b23 = 0.f;

/* Subroutine */ int q7rfh_(integer *ierr, integer *ipivot, integer *n, 
	integer *nn, integer *nopivk, integer *p, real *q, real *r__, integer 
	*rlen, real *w)
{
    /* Initialized data */

    static real bigrt = 0.f;
    static real meps10 = 0.f;
    static real tiny = 0.f;
    static real tinyrt = 0.f;

    /* System generated locals */
    integer q_dim1, q_offset, i__1, i__2;
    real r__1;

    /* Builtin functions */
    double sqrt(doublereal);

    /* Local variables */
    static integer i__, j, k;
    static real s, t, t1, ak;
    static integer ii, kk;
    static real wk;
    static integer km1, nk1, kp1;
    static real big, qkk;
    extern doublereal r7mdc_(integer *);
    extern /* Subroutine */ int v7scl_(integer *, real *, real *, real *);
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int v7scp_(integer *, real *, real *);
    extern doublereal v2nrm_(integer *, real *);
    extern /* Subroutine */ int v2axy_(integer *, real *, real *, real *, 
	    real *), v7swp_(integer *, real *, real *);
    static real singtl;


/*  ***  COMPUTE QR FACTORIZATION VIA HOUSEHOLDER TRANSFORMATIONS */
/*  ***  WITH COLUMN PIVOTING  *** */

/*  ***  PARAMETER DECLARATIONS  *** */

/*     DIMENSION R(P*(P+1)/2) */

/* ----------------------------  DESCRIPTION  ---------------------------- */

/*    THIS ROUTINE COMPUTES A QR FACTORIZATION (VIA HOUSEHOLDER TRANS- */
/* FORMATIONS) OF THE MATRIX  A  THAT ON INPUT IS STORED IN Q. */
/* IF  NOPIVK  ALLOWS IT, THIS ROUTINE DOES COLUMN PIVOTING -- IF */
/* K .GT. NOPIVK,  THEN ORIGINAL COLUMN  K  IS ELIGIBLE FOR PIVOTING. */
/* THE  Q  AND  R  RETURNED ARE SUCH THAT COLUMN  I  OF  Q*R  EQUALS */
/* COLUMN  IPIVOT(I)  OF THE ORIGINAL MATRIX  A.  THE UPPER TRIANGULAR */
/* MATRIX  R  IS STORED COMPACTLY BY COLUMNS, I.E., THE OUTPUT VECTOR  R */
/* CONTAINS  R(1,1), R(1,2), R(2,2), R(1,3), R(2,3), ..., R(P,P) (IN */
/* THAT ORDER).  IF ALL GOES WELL, THEN THIS ROUTINE SETS  IERR = 0. */
/* BUT IF (PERMUTED) COLUMN  K  OF  A  IS LINEARLY DEPENDENT ON */
/* (PERMUTED) COLUMNS 1,2,...,K-1, THEN  IERR  IS SET TO  K AND THE R */
/* MATRIX RETURNED HAS  R(I,J) = 0  FOR  I .GE. K  AND  J .GE. K. */
/*    THE ORIGINAL MATRIX  A  IS AN N BY P MATRIX.  NN  IS THE LEAD */
/* DIMENSION OF THE ARRAY  Q  AND MUST SATISFY  NN .GE. N.  NO */
/* PARAMETER CHECKING IS DONE. */
/*    PIVOTING IS DONE AS THOUGH ALL COLUMNS OF Q WERE FIRST */
/* SCALED TO HAVE THE SAME NORM.  IF COLUMN K IS ELIGIBLE FOR */
/* PIVOTING AND ITS (SCALED) NORM**2 LOSS IS MORE THAN THE */
/* MINIMUM SUCH LOSS (OVER COLUMNS K THRU P), THEN COLUMN K IS */
/* SWAPPED WITH THE COLUMN OF LEAST NORM**2 LOSS. */

/*        CODED BY DAVID M. GAY (FALL 1979, SPRING 1984). */

/* --------------------------  LOCAL VARIABLES  -------------------------- */

/* /+ */
/* / */
/* /6 */
/*     DATA ONE/1.0E+0/, TEN/1.E+1/, WTOL/0.75E+0/, ZERO/0.0E+0/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --w;
    q_dim1 = *nn;
    q_offset = 1 + q_dim1;
    q -= q_offset;
    --ipivot;
    --r__;

    /* Function Body */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    *ierr = 0;
    if (meps10 > 0.f) {
	goto L10;
    }
    bigrt = r7mdc_(&c__5);
    meps10 = r7mdc_(&c__3) * 10.f;
    tinyrt = r7mdc_(&c__2);
    tiny = r7mdc_(&c__1);
    big = r7mdc_(&c__6);
    if (tiny * big < 1.f) {
	tiny = 1.f / big;
    }
L10:
    singtl = (real) max(*n,*p) * meps10;

/*  ***  INITIALIZE W, IPIVOT, AND DIAG(R)  *** */

    j = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	ipivot[i__] = i__;
	t = v2nrm_(n, &q[i__ * q_dim1 + 1]);
	if (t > 0.f) {
	    goto L20;
	}
	w[i__] = 1.f;
	goto L30;
L20:
	w[i__] = 0.f;
L30:
	j += i__;
	r__[j] = t;
/* L40: */
    }

/*  ***  MAIN LOOP  *** */

    kk = 0;
    nk1 = *n + 1;
    i__1 = *p;
    for (k = 1; k <= i__1; ++k) {
	if (nk1 <= 1) {
	    goto L999;
	}
	--nk1;
	kk += k;
	kp1 = k + 1;
	if (k <= *nopivk) {
	    goto L60;
	}
	if (k >= *p) {
	    goto L60;
	}

/*        ***  FIND COLUMN WITH MINIMUM WEIGHT LOSS  *** */

	t = w[k];
	if (t <= 0.f) {
	    goto L60;
	}
	j = k;
	i__2 = *p;
	for (i__ = kp1; i__ <= i__2; ++i__) {
	    if (w[i__] >= t) {
		goto L50;
	    }
	    t = w[i__];
	    j = i__;
L50:
	    ;
	}
	if (j == k) {
	    goto L60;
	}

/*             ***  INTERCHANGE COLUMNS K AND J  *** */

	i__ = ipivot[k];
	ipivot[k] = ipivot[j];
	ipivot[j] = i__;
	w[j] = w[k];
	w[k] = t;
	i__ = j * (j + 1) / 2;
	t1 = r__[i__];
	r__[i__] = r__[kk];
	r__[kk] = t1;
	v7swp_(n, &q[k * q_dim1 + 1], &q[j * q_dim1 + 1]);
	if (k <= 1) {
	    goto L60;
	}
	i__ = i__ - j + 1;
	j = kk - k + 1;
	i__2 = k - 1;
	v7swp_(&i__2, &r__[i__], &r__[j]);

/*        ***  COLUMN K OF Q SHOULD BE NEARLY ORTHOGONAL TO THE PREVIOUS */
/*        ***  COLUMNS.  NORMALIZE IT, TEST FOR SINGULARITY, AND DECIDE */
/*        ***  WHETHER TO REORTHOGONALIZE IT. */

L60:
	ak = r__[kk];
	if (ak <= 0.f) {
	    goto L140;
	}
	wk = w[k];

/*        *** SET T TO THE NORM OF (Q(K,K),...,Q(N,K)) */
/*        *** AND CHECK FOR SINGULARITY. */

	if (wk < .75f) {
	    goto L70;
	}
	t = v2nrm_(&nk1, &q[k + k * q_dim1]);
	if (t / ak <= singtl) {
	    goto L140;
	}
	goto L80;
L70:
	t = sqrt(1.f - wk);
	if (t <= singtl) {
	    goto L140;
	}
	t *= ak;

/*        *** DETERMINE HOUSEHOLDER TRANSFORMATION *** */

L80:
	qkk = q[k + k * q_dim1];
	if (t <= tinyrt) {
	    goto L90;
	}
	if (t >= bigrt) {
	    goto L90;
	}
	if (qkk < 0.f) {
	    t = -t;
	}
	qkk += t;
	s = sqrt(t * qkk);
	goto L110;
L90:
	s = sqrt(t);
	if (qkk < 0.f) {
	    goto L100;
	}
	qkk += t;
	s *= sqrt(qkk);
	goto L110;
L100:
	t = -t;
	qkk += t;
	s *= sqrt(-qkk);
L110:
	q[k + k * q_dim1] = qkk;

/*         ***  SCALE (Q(K,K),...,Q(N,K)) TO HAVE NORM SQRT(2)  *** */

	if (s <= tiny) {
	    goto L140;
	}
	r__1 = 1.f / s;
	v7scl_(&nk1, &q[k + k * q_dim1], &r__1, &q[k + k * q_dim1]);

	r__[kk] = -t;

/*        ***  COMPUTE R(K,I) FOR I = K+1,...,P AND UPDATE Q  *** */

	if (k >= *p) {
	    goto L999;
	}
	j = kk + k;
	ii = kk;
	i__2 = *p;
	for (i__ = kp1; i__ <= i__2; ++i__) {
	    ii += i__;
	    r__1 = -d7tpr_(&nk1, &q[k + k * q_dim1], &q[k + i__ * q_dim1]);
	    v2axy_(&nk1, &q[k + i__ * q_dim1], &r__1, &q[k + k * q_dim1], &q[
		    k + i__ * q_dim1]);
	    t = q[k + i__ * q_dim1];
	    r__[j] = t;
	    j += i__;
	    t1 = r__[ii];
	    if (t1 > 0.f) {
/* Computing 2nd power */
		r__1 = t / t1;
		w[i__] += r__1 * r__1;
	    }
/* L120: */
	}
/* L130: */
    }

/*  ***  SINGULAR Q  *** */

L140:
    *ierr = k;
    km1 = k - 1;
    j = kk;
    i__1 = *p;
    for (i__ = k; i__ <= i__1; ++i__) {
	i__2 = i__ - km1;
	v7scp_(&i__2, &r__[j], &c_b23);
	j += i__;
/* L150: */
    }

L999:
    return 0;
/*  ***  LAST CARD OF Q7RFH FOLLOWS  *** */
} /* q7rfh_ */

