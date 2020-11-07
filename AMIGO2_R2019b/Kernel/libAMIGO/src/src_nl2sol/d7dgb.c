/* d7dgb.f -- translated by f2c (version 20100827).
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

static integer c__3 = 3;
static real c_b5 = 0.f;
static integer c__1 = 1;
static integer c_n1 = -1;
static logical c_false = FALSE_;
static real c_b23 = 1.f;

/* Subroutine */ int d7dgb_(real *b, real *d__, real *dig, real *dst, real *g,
	 integer *ipiv, integer *ka, real *l, integer *lv, integer *p, 
	integer *pc, real *nwtst, real *step, real *td, real *tg, real *v, 
	real *w, real *x0)
{
    /* Initialized data */

    static real meps2 = 0.f;

    /* System generated locals */
    integer i__1, i__2;
    real r__1, r__2, r__3, r__4;

    /* Local variables */
    static integer i__, j, k;
    static real t;
    static integer p1;
    static real t1, t2, ti, xi, x0i, rad;
    static integer p1m1;
    static real nred, pred;
    extern /* Subroutine */ int d7dog_(real *, integer *, integer *, real *, 
	    real *, real *);
    extern doublereal r7mdc_(integer *);
    extern /* Subroutine */ int v7shf_(integer *, integer *, real *), l7ivm_(
	    integer *, real *, real *, real *);
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int l7vml_(integer *, real *, real *, real *), 
	    v7scp_(integer *, real *, real *);
    extern doublereal v2nrm_(integer *, real *);
    extern /* Subroutine */ int l7itv_(integer *, real *, real *, real *), 
	    q7rsh_(integer *, integer *, logical *, real *, real *, real *), 
	    v7ipr_(integer *, integer *, real *), v7cpy_(integer *, real *, 
	    real *), l7tvm_(integer *, real *, real *, real *), v2axy_(
	    integer *, real *, real *, real *, real *), v7vmp_(integer *, 
	    real *, real *, real *, integer *);
    static real gnorm, gnorm0;
    extern /* Subroutine */ int i7shft_(integer *, integer *, integer *);
    static real ghinvg, dnwtst;


/*  ***  COMPUTE DOUBLE-DOGLEG STEP, SUBJECT TO SIMPLE BOUNDS ON X  *** */


/*     DIMENSION L(P*(P+1)/2) */


/*  ***  LOCAL VARIABLES  *** */


/*  ***  V SUBSCRIPTS  *** */


/* /6 */
/*     DATA DGNORM/1/, DST0/3/, DSTNRM/2/, GRDFAC/45/, GTHG/44/, */
/*    1     GTSTEP/4/, NREDUC/6/, NWTFAC/46/, PREDUC/7/, RADIUS/8/, */
/*    2     STPPAR/5/ */
/* /7 */
/* / */
/* /6 */
/*     DATA HALF/0.5E+0/, ONE/1.E+0/, TWO/2.E+0/, ZERO/0.E+0/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --l;
    --v;
    --x0;
    --w;
    --tg;
    --td;
    --step;
    --nwtst;
    --ipiv;
    --g;
    --dst;
    --dig;
    --d__;
    b -= 3;

    /* Function Body */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    if (meps2 <= 0.f) {
	meps2 = 2.f * r7mdc_(&c__3);
    }
    gnorm0 = v[1];
    v[2] = 0.f;
    if (*ka < 0) {
	goto L10;
    }
    dnwtst = v[3];
    nred = v[6];
L10:
    pred = 0.f;
    v[5] = 0.f;
    rad = v[8];
    if (*pc > 0) {
	goto L20;
    }
    dnwtst = 0.f;
    v7scp_(p, &step[1], &c_b5);
    goto L140;

L20:
    p1 = *pc;
    v7cpy_(p, &td[1], &d__[1]);
    v7ipr_(p, &ipiv[1], &td[1]);
    v7scp_(pc, &dst[1], &c_b5);
    v7cpy_(p, &tg[1], &g[1]);
    v7ipr_(p, &ipiv[1], &tg[1]);

L30:
    l7ivm_(&p1, &nwtst[1], &l[1], &tg[1]);
    ghinvg = d7tpr_(&p1, &nwtst[1], &nwtst[1]);
    v[6] = ghinvg * .5f;
    l7itv_(&p1, &nwtst[1], &l[1], &nwtst[1]);
    v7vmp_(&p1, &step[1], &nwtst[1], &td[1], &c__1);
    v[3] = v2nrm_(pc, &step[1]);
    if (*ka >= 0) {
	goto L40;
    }
    *ka = 0;
    dnwtst = v[3];
    nred = v[6];
L40:
    v[8] = rad - v[2];
    if (v[8] <= 0.f) {
	goto L100;
    }
    v7vmp_(&p1, &dig[1], &tg[1], &td[1], &c_n1);
    gnorm = v2nrm_(&p1, &dig[1]);
    if (gnorm <= 0.f) {
	goto L100;
    }
    v[1] = gnorm;
    v7vmp_(&p1, &dig[1], &dig[1], &td[1], &c_n1);
    l7tvm_(&p1, &w[1], &l[1], &dig[1]);
    v[44] = v2nrm_(&p1, &w[1]);
    ++(*ka);
    d7dog_(&dig[1], lv, &p1, &nwtst[1], &step[1], &v[1]);

/*     ***  FIND T SUCH THAT X - T*STEP IS STILL FEASIBLE. */

    t = 1.f;
    k = 0;
    i__1 = p1;
    for (i__ = 1; i__ <= i__1; ++i__) {
	j = ipiv[i__];
	x0i = x0[j] + dst[i__] / td[i__];
	xi = x0i + step[i__];
	if (xi < b[(j << 1) + 1]) {
	    goto L50;
	}
	if (xi <= b[(j << 1) + 2]) {
	    goto L70;
	}
	ti = (b[(j << 1) + 2] - x0i) / step[i__];
	j = i__;
	goto L60;
L50:
	ti = (b[(j << 1) + 1] - x0i) / step[i__];
	j = -i__;
L60:
	if (t <= ti) {
	    goto L70;
	}
	k = j;
	t = ti;
L70:
	;
    }

/*  ***  UPDATE DST, TG, AND PRED  *** */

    v7vmp_(&p1, &step[1], &step[1], &td[1], &c__1);
    v2axy_(&p1, &dst[1], &t, &step[1], &dst[1]);
    v[2] = v2nrm_(pc, &dst[1]);
    t1 = t * v[45];
    t2 = t * v[46];
/* Computing 2nd power */
    r__1 = v[44] * t1;
    pred = pred - t1 * gnorm * ((t2 + 1.f) * gnorm) - t2 * (t2 * .5f + 1.f) * 
	    ghinvg - r__1 * r__1 * .5f;
    if (k == 0) {
	goto L100;
    }
    l7vml_(&p1, &w[1], &l[1], &w[1]);
    t2 = 1.f - t2;
    i__1 = p1;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L80: */
	tg[i__] = t2 * tg[i__] - t1 * w[i__];
    }

/*     ***  PERMUTE L, ETC. IF NECESSARY  *** */

    p1m1 = p1 - 1;
    j = abs(k);
    if (j == p1) {
	goto L90;
    }
    q7rsh_(&j, &p1, &c_false, &tg[1], &l[1], &w[1]);
    i7shft_(&p1, &j, &ipiv[1]);
    v7shf_(&p1, &j, &tg[1]);
    v7shf_(&p1, &j, &td[1]);
    v7shf_(&p1, &j, &dst[1]);
L90:
    if (k < 0) {
	ipiv[p1] = -ipiv[p1];
    }
    p1 = p1m1;
    if (p1 > 0) {
	goto L30;
    }

/*     ***  UNSCALE STEP, UPDATE X AND DIHDI  *** */

L100:
    v7scp_(p, &step[1], &c_b5);
    i__1 = *pc;
    for (i__ = 1; i__ <= i__1; ++i__) {
	j = (i__2 = ipiv[i__], abs(i__2));
	step[j] = dst[i__] / td[i__];
/* L110: */
    }

/*  ***  FUDGE STEP TO ENSURE THAT IT FORCES APPROPRIATE COMPONENTS */
/*  ***  TO THEIR BOUNDS  *** */

    if (p1 >= *pc) {
	goto L140;
    }
    v2axy_(p, &td[1], &c_b23, &step[1], &x0[1]);
    k = p1 + 1;
    i__1 = *pc;
    for (i__ = k; i__ <= i__1; ++i__) {
	j = ipiv[i__];
	t = meps2;
	if (j > 0) {
	    goto L120;
	}
	t = -t;
	j = -j;
	ipiv[i__] = j;
L120:
/* Computing MAX */
	r__3 = (r__1 = td[j], dabs(r__1)), r__4 = (r__2 = x0[j], dabs(r__2));
	t *= dmax(r__3,r__4);
	step[j] += t;
/* L130: */
    }

L140:
    v[1] = gnorm0;
    v[6] = nred;
    v[7] = pred;
    v[8] = rad;
    v[3] = dnwtst;
    v[4] = d7tpr_(p, &step[1], &g[1]);

/* L999: */
    return 0;
/*  ***  LAST LINE OF  D7DGB FOLLOWS  *** */
} /* d7dgb_ */

