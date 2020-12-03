/* l7msb.f -- translated by f2c (version 20100827).
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
static integer c__1 = 1;
static logical c_true = TRUE_;

/* Subroutine */ int l7msb_(real *b, real *d__, real *g, integer *ierr, 
	integer *ipiv, integer *ipiv1, integer *ipiv2, integer *ka, real *
	lmat, integer *lv, integer *p, integer *p0, integer *pc, real *qtr, 
	real *rmat, real *step, real *td, real *tg, real *v, real *w, real *
	wlm, real *x, real *x0)
{
    /* Initialized data */

    static real one = 1.f;
    static real zero = 0.f;

    /* System generated locals */
    integer step_dim1, step_offset, i__1;

    /* Local variables */
    static integer i__, j, k, l, k0, p1, kb, p10, p11, ns;
    static real ds0, rad, nred, pred;
    extern /* Subroutine */ int d7mlp_(integer *, real *, real *, real *, 
	    integer *), s7bqn_(real *, real *, real *, integer *, integer *, 
	    integer *, integer *, real *, integer *, integer *, integer *, 
	    integer *, real *, real *, real *, real *, real *, real *, real *)
	    ;
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int v7scp_(integer *, real *, real *), q7rsh_(
	    integer *, integer *, logical *, real *, real *, real *), l7mst_(
	    real *, real *, integer *, integer *, integer *, integer *, real *
	    , real *, real *, real *, real *), v7ipr_(integer *, integer *, 
	    real *), v7cpy_(integer *, real *, real *), l7tvm_(integer *, 
	    real *, real *, real *), v2axy_(integer *, real *, real *, real *,
	     real *), v7vmp_(integer *, real *, real *, real *, integer *);
    static integer kinit;


/*  ***  COMPUTE HEURISTIC BOUNDED NEWTON STEP  *** */

/*     DIMENSION LMAT(P*(P+1)/2), RMAT(P*(P+1)/2), WLM(P*(P+5)/2 + 4) */


/*  ***  LOCAL VARIABLES  *** */


/*  ***  V SUBSCRIPTS  *** */


/* /6 */
/*     DATA DST0/3/, DSTNRM/2/, GTSTEP/4/, NREDUC/6/, PREDUC/7/, */
/*    1     RADIUS/8/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --lmat;
    --v;
    --x0;
    --x;
    --w;
    --tg;
    --td;
    step_dim1 = *p;
    step_offset = 1 + step_dim1;
    step -= step_offset;
    --qtr;
    --ipiv2;
    --ipiv1;
    --ipiv;
    --g;
    --d__;
    b -= 3;
    --rmat;
    --wlm;

    /* Function Body */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    p1 = *pc;
    if (*ka < 0) {
	goto L10;
    }
    nred = v[6];
    ds0 = v[3];
    goto L20;
L10:
    *p0 = 0;
    *ka = -1;

L20:
    kinit = -1;
    if (*p0 == p1) {
	kinit = *ka;
    }
    v7cpy_(p, &x[1], &x0[1]);
    v7cpy_(p, &td[1], &d__[1]);
/*     *** USE STEP(1,3) AS TEMP. COPY OF QTR *** */
    v7cpy_(p, &step[step_dim1 * 3 + 1], &qtr[1]);
    v7ipr_(p, &ipiv[1], &td[1]);
    pred = zero;
    rad = v[8];
    kb = -1;
    v[2] = zero;
    if (p1 > 0) {
	goto L30;
    }
    nred = zero;
    ds0 = zero;
    v7scp_(p, &step[step_offset], &zero);
    goto L90;

L30:
    v7vmp_(p, &tg[1], &g[1], &d__[1], &c_n1);
    v7ipr_(p, &ipiv[1], &tg[1]);
    p10 = p1;
L40:
    k = kinit;
    kinit = -1;
    v[8] = rad - v[2];
    v7vmp_(&p1, &tg[1], &tg[1], &td[1], &c__1);
    i__1 = p1;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L50: */
	ipiv1[i__] = i__;
    }
    k0 = max(0,k);
    l7mst_(&td[1], &tg[1], ierr, &ipiv1[1], &k, &p1, &step[step_dim1 * 3 + 1],
	     &rmat[1], &step[step_offset], &v[1], &wlm[1]);
    v7vmp_(&p1, &tg[1], &tg[1], &td[1], &c_n1);
    *p0 = p1;
    if (*ka >= 0) {
	goto L60;
    }
    nred = v[6];
    ds0 = v[3];

L60:
    *ka = k;
    v[8] = rad;
    l = p1 + 5;
    if (k <= k0) {
	d7mlp_(&p1, &lmat[1], &td[1], &rmat[1], &c_n1);
    }
    if (k > k0) {
	d7mlp_(&p1, &lmat[1], &td[1], &wlm[l], &c_n1);
    }
    s7bqn_(&b[3], &d__[1], &step[(step_dim1 << 1) + 1], &ipiv[1], &ipiv1[1], &
	    ipiv2[1], &kb, &lmat[1], lv, &ns, p, &p1, &step[step_offset], &td[
	    1], &tg[1], &v[1], &w[1], &x[1], &x0[1]);
    pred += v[7];
    if (ns == 0) {
	goto L80;
    }
    *p0 = 0;

/*  ***  UPDATE RMAT AND QTR  *** */

    p11 = p1 + 1;
    l = p10 + p11;
    i__1 = p10;
    for (k = p11; k <= i__1; ++k) {
	j = l - k;
	i__ = ipiv2[j];
	if (i__ < j) {
	    q7rsh_(&i__, &j, &c_true, &qtr[1], &rmat[1], &w[1]);
	}
/* L70: */
    }

L80:
    if (kb > 0) {
	goto L90;
    }

/*  ***  UPDATE LOCAL COPY OF QTR  *** */

    v7vmp_(&p10, &w[1], &step[(step_dim1 << 1) + 1], &td[1], &c_n1);
    l7tvm_(&p10, &w[1], &lmat[1], &w[1]);
    v2axy_(&p10, &step[step_dim1 * 3 + 1], &one, &w[1], &qtr[1]);
    goto L40;

L90:
    v[3] = ds0;
    v[6] = nred;
    v[7] = pred;
    v[4] = d7tpr_(p, &g[1], &step[step_offset]);

/* L999: */
    return 0;
/*  ***  LAST LINE OF  L7MSB FOLLOWS  *** */
} /* l7msb_ */

