/* g7qsb.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int g7qsb_(real *b, real *d__, real *dihdi, real *g, integer 
	*ipiv, integer *ipiv1, integer *ipiv2, integer *ka, real *l, integer *
	lv, integer *p, integer *p0, integer *pc, real *step, real *td, real *
	tg, real *v, real *w, real *x, real *x0)
{
    /* Initialized data */

    static real zero = 0.f;

    /* System generated locals */
    integer step_dim1, step_offset;

    /* Local variables */
    static integer k, p1, kb, p10, ns;
    static real ds0, rad, nred, pred;
    extern /* Subroutine */ int s7bqn_(real *, real *, real *, integer *, 
	    integer *, integer *, integer *, real *, integer *, integer *, 
	    integer *, integer *, real *, real *, real *, real *, real *, 
	    real *, real *);
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int v7scp_(integer *, real *, real *), s7ipr_(
	    integer *, integer *, real *), g7qts_(real *, real *, real *, 
	    integer *, real *, integer *, real *, real *, real *), v7ipr_(
	    integer *, integer *, real *), v7cpy_(integer *, real *, real *), 
	    v7vmp_(integer *, real *, real *, real *, integer *);
    static integer kinit;


/*  ***  COMPUTE HEURISTIC BOUNDED NEWTON STEP  *** */

/*     DIMENSION DIHDI(P*(P+1)/2), L(P*(P+1)/2) */


/*  ***  LOCAL VARIABLES  *** */


/*  ***  V SUBSCRIPTS  *** */


/* /6 */
/*     DATA DST0/3/, DSTNRM/2/, GTSTEP/4/, NREDUC/6/, PREDUC/7/, */
/*    1     RADIUS/8/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --dihdi;
    --l;
    --v;
    --x0;
    --x;
    --w;
    --tg;
    --td;
    step_dim1 = *p;
    step_offset = 1 + step_dim1;
    step -= step_offset;
    --ipiv2;
    --ipiv1;
    --ipiv;
    --g;
    --d__;
    b -= 3;

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
    goto L60;

L30:
    v7cpy_(p, &td[1], &d__[1]);
    v7ipr_(p, &ipiv[1], &td[1]);
    v7vmp_(p, &tg[1], &g[1], &d__[1], &c_n1);
    v7ipr_(p, &ipiv[1], &tg[1]);
L40:
    k = kinit;
    kinit = -1;
    v[8] = rad - v[2];
    g7qts_(&td[1], &tg[1], &dihdi[1], &k, &l[1], &p1, &step[step_offset], &v[
	    1], &w[1]);
    *p0 = p1;
    if (*ka >= 0) {
	goto L50;
    }
    nred = v[6];
    ds0 = v[3];

L50:
    *ka = k;
    v[8] = rad;
    p10 = p1;
    s7bqn_(&b[3], &d__[1], &step[(step_dim1 << 1) + 1], &ipiv[1], &ipiv1[1], &
	    ipiv2[1], &kb, &l[1], lv, &ns, p, &p1, &step[step_offset], &td[1],
	     &tg[1], &v[1], &w[1], &x[1], &x0[1]);
    if (ns > 0) {
	s7ipr_(&p10, &ipiv1[1], &dihdi[1]);
    }
    pred += v[7];
    if (ns != 0) {
	*p0 = 0;
    }
    if (kb <= 0) {
	goto L40;
    }

L60:
    v[3] = ds0;
    v[6] = nred;
    v[7] = pred;
    v[4] = d7tpr_(p, &g[1], &step[step_offset]);

/* L999: */
    return 0;
/*  ***  LAST LINE OF  G7QSB FOLLOWS  *** */
} /* g7qsb_ */

