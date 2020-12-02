/* g7qts.f -- translated by f2c (version 20100827).
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

static integer c__6 = 6;
static integer c__1 = 1;
static integer c__3 = 3;

/* Subroutine */ int g7qts_(real *d__, real *dig, real *dihdi, integer *ka, 
	real *l, integer *p, real *step, real *v, real *w)
{
    /* Initialized data */

    static real big = 0.f;
    static real dgxfac = 0.f;

    /* System generated locals */
    integer i__1, i__2;
    real r__1, r__2, r__3;

    /* Builtin functions */
    double sqrt(doublereal);

    /* Local variables */
    static integer i__, j, k, q;
    static real t;
    static integer x, k1, q0;
    static real t1, t2, lk, si, sk, uk, wi, sw;
    static integer im1, lk0, uk0;
    static real aki, akk, rad;
    static integer inc, irc;
    static real phi, eps, dst;
    static integer diag, emin, emax;
    static real root;
    static integer diag0;
    extern doublereal r7mdc_(integer *);
    extern /* Subroutine */ int l7ivm_(integer *, real *, real *, real *);
    extern doublereal d7tpr_(integer *, real *, real *), v2nrm_(integer *, 
	    real *);
    extern /* Subroutine */ int l7itv_(integer *, real *, real *, real *);
    extern doublereal l7svn_(integer *, real *, real *, real *);
    extern /* Subroutine */ int l7srt_(integer *, integer *, real *, real *, 
	    integer *);
    static real delta;
    static integer kalim, kamin;
    static real radsq, gtsta, alphak, psifac;
    static integer dggdmx;
    static real oldphi, phimin, phimax;
    static integer phipin, dstsav;
    static logical restrt;
    static real twopsi;


/*  *** COMPUTE GOLDFELD-QUANDT-TROTTER STEP BY MORE-HEBDEN TECHNIQUE *** */
/*  ***  (NL2SOL VERSION 2.2), MODIFIED A LA MORE AND SORENSEN  *** */

/*  ***  PARAMETER DECLARATIONS  *** */

/*     DIMENSION DIHDI(P*(P+1)/2), L(P*(P+1)/2), W(4*P+7) */

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/*  ***  PURPOSE  *** */

/*        GIVEN THE (COMPACTLY STORED) LOWER TRIANGLE OF A SCALED */
/*     HESSIAN (APPROXIMATION) AND A NONZERO SCALED GRADIENT VECTOR, */
/*     THIS SUBROUTINE COMPUTES A GOLDFELD-QUANDT-TROTTER STEP OF */
/*     APPROXIMATE LENGTH V(RADIUS) BY THE MORE-HEBDEN TECHNIQUE.  IN */
/*     OTHER WORDS, STEP IS COMPUTED TO (APPROXIMATELY) MINIMIZE */
/*     PSI(STEP) = (G**T)*STEP + 0.5*(STEP**T)*H*STEP  SUCH THAT THE */
/*     2-NORM OF D*STEP IS AT MOST (APPROXIMATELY) V(RADIUS), WHERE */
/*     G  IS THE GRADIENT,  H  IS THE HESSIAN, AND  D  IS A DIAGONAL */
/*     SCALE MATRIX WHOSE DIAGONAL IS STORED IN THE PARAMETER D. */
/*     (G7QTS ASSUMES  DIG = D**-1 * G  AND  DIHDI = D**-1 * H * D**-1.) */

/*  ***  PARAMETER DESCRIPTION  *** */

/*     D (IN)  = THE SCALE VECTOR, I.E. THE DIAGONAL OF THE SCALE */
/*              MATRIX  D  MENTIONED ABOVE UNDER PURPOSE. */
/*   DIG (IN)  = THE SCALED GRADIENT VECTOR, D**-1 * G.  IF G = 0, THEN */
/*              STEP = 0  AND  V(STPPAR) = 0  ARE RETURNED. */
/* DIHDI (IN)  = LOWER TRIANGLE OF THE SCALED HESSIAN (APPROXIMATION), */
/*              I.E., D**-1 * H * D**-1, STORED COMPACTLY BY ROWS., I.E., */
/*              IN THE ORDER (1,1), (2,1), (2,2), (3,1), (3,2), ETC. */
/*    KA (I/O) = THE NUMBER OF HEBDEN ITERATIONS (SO FAR) TAKEN TO DETER- */
/*              MINE STEP.  KA .LT. 0 ON INPUT MEANS THIS IS THE FIRST */
/*              ATTEMPT TO DETERMINE STEP (FOR THE PRESENT DIG AND DIHDI) */
/*              -- KA IS INITIALIZED TO 0 IN THIS CASE.  OUTPUT WITH */
/*              KA = 0  (OR V(STPPAR) = 0)  MEANS  STEP = -(H**-1)*G. */
/*     L (I/O) = WORKSPACE OF LENGTH P*(P+1)/2 FOR CHOLESKY FACTORS. */
/*     P (IN)  = NUMBER OF PARAMETERS -- THE HESSIAN IS A  P X P  MATRIX. */
/*  STEP (I/O) = THE STEP COMPUTED. */
/*     V (I/O) CONTAINS VARIOUS CONSTANTS AND VARIABLES DESCRIBED BELOW. */
/*     W (I/O) = WORKSPACE OF LENGTH 4*P + 6. */

/*  ***  ENTRIES IN V  *** */

/* V(DGNORM) (I/O) = 2-NORM OF (D**-1)*G. */
/* V(DSTNRM) (OUTPUT) = 2-NORM OF D*STEP. */
/* V(DST0)   (I/O) = 2-NORM OF D*(H**-1)*G (FOR POS. DEF. H ONLY), OR */
/*             OVERESTIMATE OF SMALLEST EIGENVALUE OF (D**-1)*H*(D**-1). */
/* V(EPSLON) (IN)  = MAX. REL. ERROR ALLOWED FOR PSI(STEP).  FOR THE */
/*             STEP RETURNED, PSI(STEP) WILL EXCEED ITS OPTIMAL VALUE */
/*             BY LESS THAN -V(EPSLON)*PSI(STEP).  SUGGESTED VALUE = 0.1. */
/* V(GTSTEP) (OUT) = INNER PRODUCT BETWEEN G AND STEP. */
/* V(NREDUC) (OUT) = PSI(-(H**-1)*G) = PSI(NEWTON STEP)  (FOR POS. DEF. */
/*             H ONLY -- V(NREDUC) IS SET TO ZERO OTHERWISE). */
/* V(PHMNFC) (IN)  = TOL. (TOGETHER WITH V(PHMXFC)) FOR ACCEPTING STEP */
/*             (MORE*S SIGMA).  THE ERROR V(DSTNRM) - V(RADIUS) MUST LIE */
/*             BETWEEN V(PHMNFC)*V(RADIUS) AND V(PHMXFC)*V(RADIUS). */
/* V(PHMXFC) (IN)  (SEE V(PHMNFC).) */
/*             SUGGESTED VALUES -- V(PHMNFC) = -0.25, V(PHMXFC) = 0.5. */
/* V(PREDUC) (OUT) = PSI(STEP) = PREDICTED OBJ. FUNC. REDUCTION FOR STEP. */
/* V(RADIUS) (IN)  = RADIUS OF CURRENT (SCALED) TRUST REGION. */
/* V(RAD0)   (I/O) = VALUE OF V(RADIUS) FROM PREVIOUS CALL. */
/* V(STPPAR) (I/O) IS NORMALLY THE MARQUARDT PARAMETER, I.E. THE ALPHA */
/*             DESCRIBED BELOW UNDER ALGORITHM NOTES.  IF H + ALPHA*D**2 */
/*             (SEE ALGORITHM NOTES) IS (NEARLY) SINGULAR, HOWEVER, */
/*             THEN V(STPPAR) = -ALPHA. */

/*  ***  USAGE NOTES  *** */

/*     IF IT IS DESIRED TO RECOMPUTE STEP USING A DIFFERENT VALUE OF */
/*     V(RADIUS), THEN THIS ROUTINE MAY BE RESTARTED BY CALLING IT */
/*     WITH ALL PARAMETERS UNCHANGED EXCEPT V(RADIUS).  (THIS EXPLAINS */
/*     WHY STEP AND W ARE LISTED AS I/O).  ON AN INITIAL CALL (ONE WITH */
/*     KA .LT. 0), STEP AND W NEED NOT BE INITIALIZED AND ONLY COMPO- */
/*     NENTS V(EPSLON), V(STPPAR), V(PHMNFC), V(PHMXFC), V(RADIUS), AND */
/*     V(RAD0) OF V MUST BE INITIALIZED. */

/*  ***  ALGORITHM NOTES  *** */

/*        THE DESIRED G-Q-T STEP (REF. 2, 3, 4, 6) SATISFIES */
/*     (H + ALPHA*D**2)*STEP = -G  FOR SOME NONNEGATIVE ALPHA SUCH THAT */
/*     H + ALPHA*D**2 IS POSITIVE SEMIDEFINITE.  ALPHA AND STEP ARE */
/*     COMPUTED BY A SCHEME ANALOGOUS TO THE ONE DESCRIBED IN REF. 5. */
/*     ESTIMATES OF THE SMALLEST AND LARGEST EIGENVALUES OF THE HESSIAN */
/*     ARE OBTAINED FROM THE GERSCHGORIN CIRCLE THEOREM ENHANCED BY A */
/*     SIMPLE FORM OF THE SCALING DESCRIBED IN REF. 7.  CASES IN WHICH */
/*     H + ALPHA*D**2 IS NEARLY (OR EXACTLY) SINGULAR ARE HANDLED BY */
/*     THE TECHNIQUE DISCUSSED IN REF. 2.  IN THESE CASES, A STEP OF */
/*     (EXACT) LENGTH V(RADIUS) IS RETURNED FOR WHICH PSI(STEP) EXCEEDS */
/*     ITS OPTIMAL VALUE BY LESS THAN -V(EPSLON)*PSI(STEP).  THE TEST */
/*     SUGGESTED IN REF. 6 FOR DETECTING THE SPECIAL CASE IS PERFORMED */
/*     ONCE TWO MATRIX FACTORIZATIONS HAVE BEEN DONE -- DOING SO SOONER */
/*     SEEMS TO DEGRADE THE PERFORMANCE OF OPTIMIZATION ROUTINES THAT */
/*     CALL THIS ROUTINE. */

/*  ***  FUNCTIONS AND SUBROUTINES CALLED  *** */

/*  D7TPR - RETURNS INNER PRODUCT OF TWO VECTORS. */
/*  L7ITV - APPLIES INVERSE-TRANSPOSE OF COMPACT LOWER TRIANG. MATRIX. */
/*  L7IVM - APPLIES INVERSE OF COMPACT LOWER TRIANG. MATRIX. */
/* L7SRT  - FINDS CHOLESKY FACTOR (OF COMPACTLY STORED LOWER TRIANG.). */
/*  L7SVN - RETURNS APPROX. TO MIN. SING. VALUE OF LOWER TRIANG. MATRIX. */
/*  R7MDC - RETURNS MACHINE-DEPENDENT CONSTANTS. */
/*  V2NRM - RETURNS 2-NORM OF A VECTOR. */

/*  ***  REFERENCES  *** */

/* 1.  DENNIS, J.E., GAY, D.M., AND WELSCH, R.E. (1981), AN ADAPTIVE */
/*             NONLINEAR LEAST-SQUARES ALGORITHM, ACM TRANS. MATH. */
/*             SOFTWARE, VOL. 7, NO. 3. */
/* 2.  GAY, D.M. (1981), COMPUTING OPTIMAL LOCALLY CONSTRAINED STEPS, */
/*             SIAM J. SCI. STATIST. COMPUTING, VOL. 2, NO. 2, PP. */
/*             186-197. */
/* 3.  GOLDFELD, S.M., QUANDT, R.E., AND TROTTER, H.F. (1966), */
/*             MAXIMIZATION BY QUADRATIC HILL-CLIMBING, ECONOMETRICA 34, */
/*             PP. 541-551. */
/* 4.  HEBDEN, M.D. (1973), AN ALGORITHM FOR MINIMIZATION USING EXACT */
/*             SECOND DERIVATIVES, REPORT T.P. 515, THEORETICAL PHYSICS */
/*             DIV., A.E.R.E. HARWELL, OXON., ENGLAND. */
/* 5.  MORE, J.J. (1978), THE LEVENBERG-MARQUARDT ALGORITHM, IMPLEMEN- */
/*             TATION AND THEORY, PP.105-116 OF SPRINGER LECTURE NOTES */
/*             IN MATHEMATICS NO. 630, EDITED BY G.A. WATSON, SPRINGER- */
/*             VERLAG, BERLIN AND NEW YORK. */
/* 6.  MORE, J.J., AND SORENSEN, D.C. (1981), COMPUTING A TRUST REGION */
/*             STEP, TECHNICAL REPORT ANL-81-83, ARGONNE NATIONAL LAB. */
/* 7.  VARGA, R.S. (1965), MINIMAL GERSCHGORIN SETS, PACIFIC J. MATH. 15, */
/*             PP. 719-729. */

/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY. */
/*     THIS SUBROUTINE WAS WRITTEN IN CONNECTION WITH RESEARCH */
/*     SUPPORTED BY THE NATIONAL SCIENCE FOUNDATION UNDER GRANTS */
/*     MCS-7600324, DCR75-10143, 76-14311DSS, MCS76-11989, AND */
/*     MCS-7906671. */

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/*  ***  LOCAL VARIABLES  *** */


/*     ***  CONSTANTS  *** */

/*  ***  INTRINSIC FUNCTIONS  *** */
/* /+ */
/* / */
/*  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  *** */


/*  ***  SUBSCRIPTS FOR V  *** */

/* /6 */
/*     DATA DGNORM/1/, DSTNRM/2/, DST0/3/, EPSLON/19/, GTSTEP/4/, */
/*    1     NREDUC/6/, PHMNFC/20/, PHMXFC/21/, PREDUC/7/, RADIUS/8/, */
/*    2     RAD0/9/, STPPAR/5/ */
/* /7 */
/* / */

/* /6 */
/*     DATA EPSFAC/50.0E+0/, FOUR/4.0E+0/, HALF/0.5E+0/, */
/*    1     KAPPA/2.0E+0/, NEGONE/-1.0E+0/, ONE/1.0E+0/, P001/1.0E-3/, */
/*    2     SIX/6.0E+0/, THREE/3.0E+0/, TWO/2.0E+0/, ZERO/0.0E+0/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --dihdi;
    --l;
    --step;
    --dig;
    --d__;
    --v;
    --w;

    /* Function Body */

/*  ***  BODY  *** */

    if (big <= 0.f) {
	big = r7mdc_(&c__6);
    }

/*     ***  STORE LARGEST ABS. ENTRY IN (D**-1)*H*(D**-1) AT W(DGGDMX). */
    dggdmx = *p + 1;
/*     ***  STORE GERSCHGORIN OVER- AND UNDERESTIMATES OF THE LARGEST */
/*     ***  AND SMALLEST EIGENVALUES OF (D**-1)*H*(D**-1) AT W(EMAX) */
/*     ***  AND W(EMIN) RESPECTIVELY. */
    emax = dggdmx + 1;
    emin = emax + 1;
/*     ***  FOR USE IN RECOMPUTING STEP, THE FINAL VALUES OF LK, UK, DST, */
/*     ***  AND THE INVERSE DERIVATIVE OF MORE*S PHI AT 0 (FOR POS. DEF. */
/*     ***  H) ARE STORED IN W(LK0), W(UK0), W(DSTSAV), AND W(PHIPIN) */
/*     ***  RESPECTIVELY. */
    lk0 = emin + 1;
    phipin = lk0 + 1;
    uk0 = phipin + 1;
    dstsav = uk0 + 1;
/*     ***  STORE DIAG OF (D**-1)*H*(D**-1) IN W(DIAG),...,W(DIAG0+P). */
    diag0 = dstsav;
    diag = diag0 + 1;
/*     ***  STORE -D*STEP IN W(Q),...,W(Q0+P). */
    q0 = diag0 + *p;
    q = q0 + 1;
/*     ***  ALLOCATE STORAGE FOR SCRATCH VECTOR X  *** */
    x = q + *p;
    rad = v[8];
/* Computing 2nd power */
    r__1 = rad;
    radsq = r__1 * r__1;
/*     ***  PHITOL = MAX. ERROR ALLOWED IN DST = V(DSTNRM) = 2-NORM OF */
/*     ***  D*STEP. */
    phimax = v[21] * rad;
    phimin = v[20] * rad;
    psifac = big;
    t1 = v[19] * 2.f / (((v[20] + 1.f) * 4.f * 3.f + 2.f + 2.f) * 3.f * rad);
    if (t1 < big * dmin(rad,1.f)) {
	psifac = t1 / rad;
    }
/*     ***  OLDPHI IS USED TO DETECT LIMITS OF NUMERICAL ACCURACY.  IF */
/*     ***  WE RECOMPUTE STEP AND IT DOES NOT CHANGE, THEN WE ACCEPT IT. */
    oldphi = 0.f;
    eps = v[19];
    irc = 0;
    restrt = FALSE_;
    kalim = *ka + 50;

/*  ***  START OR RESTART, DEPENDING ON KA  *** */

    if (*ka >= 0) {
	goto L290;
    }

/*  ***  FRESH START  *** */

    k = 0;
    uk = -1.f;
    *ka = 0;
    kalim = 50;
    v[1] = v2nrm_(p, &dig[1]);
    v[6] = 0.f;
    v[3] = 0.f;
    kamin = 3;
    if (v[1] == 0.f) {
	kamin = 0;
    }

/*     ***  STORE DIAG(DIHDI) IN W(DIAG0+1),...,W(DIAG0+P)  *** */

    j = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	j += i__;
	k1 = diag0 + i__;
	w[k1] = dihdi[j];
/* L10: */
    }

/*     ***  DETERMINE W(DGGDMX), THE LARGEST ELEMENT OF DIHDI  *** */

    t1 = 0.f;
    j = *p * (*p + 1) / 2;
    i__1 = j;
    for (i__ = 1; i__ <= i__1; ++i__) {
	t = (r__1 = dihdi[i__], dabs(r__1));
	if (t1 < t) {
	    t1 = t;
	}
/* L20: */
    }
    w[dggdmx] = t1;

/*  ***  TRY ALPHA = 0  *** */

L30:
    l7srt_(&c__1, p, &l[1], &dihdi[1], &irc);
    if (irc == 0) {
	goto L50;
    }
/*        ***  INDEF. H -- UNDERESTIMATE SMALLEST EIGENVALUE, USE THIS */
/*        ***  ESTIMATE TO INITIALIZE LOWER BOUND LK ON ALPHA. */
    j = irc * (irc + 1) / 2;
    t = l[j];
    l[j] = 1.f;
    i__1 = irc;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L40: */
	w[i__] = 0.f;
    }
    w[irc] = 1.f;
    l7itv_(&irc, &w[1], &l[1], &w[1]);
    t1 = v2nrm_(&irc, &w[1]);
    lk = -t / t1 / t1;
    v[3] = -lk;
    if (restrt) {
	goto L210;
    }
    goto L70;

/*     ***  POSITIVE DEFINITE H -- COMPUTE UNMODIFIED NEWTON STEP.  *** */
L50:
    lk = 0.f;
    t = l7svn_(p, &l[1], &w[q], &w[q]);
    if (t >= 1.f) {
	goto L60;
    }
    if (v[1] >= t * t * big) {
	goto L70;
    }
L60:
    l7ivm_(p, &w[q], &l[1], &dig[1]);
    gtsta = d7tpr_(p, &w[q], &w[q]);
    v[6] = gtsta * .5f;
    l7itv_(p, &w[q], &l[1], &w[q]);
    dst = v2nrm_(p, &w[q]);
    v[3] = dst;
    phi = dst - rad;
    if (phi <= phimax) {
	goto L260;
    }
    if (restrt) {
	goto L210;
    }

/*  ***  PREPARE TO COMPUTE GERSCHGORIN ESTIMATES OF LARGEST (AND */
/*  ***  SMALLEST) EIGENVALUES.  *** */

L70:
    k = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	wi = 0.f;
	if (i__ == 1) {
	    goto L90;
	}
	im1 = i__ - 1;
	i__2 = im1;
	for (j = 1; j <= i__2; ++j) {
	    ++k;
	    t = (r__1 = dihdi[k], dabs(r__1));
	    wi += t;
	    w[j] += t;
/* L80: */
	}
L90:
	w[i__] = wi;
	++k;
/* L100: */
    }

/*  ***  (UNDER-)ESTIMATE SMALLEST EIGENVALUE OF (D**-1)*H*(D**-1)  *** */

    k = 1;
    t1 = w[diag] - w[1];
    if (*p <= 1) {
	goto L120;
    }
    i__1 = *p;
    for (i__ = 2; i__ <= i__1; ++i__) {
	j = diag0 + i__;
	t = w[j] - w[i__];
	if (t >= t1) {
	    goto L110;
	}
	t1 = t;
	k = i__;
L110:
	;
    }

L120:
    sk = w[k];
    j = diag0 + k;
    akk = w[j];
    k1 = k * (k - 1) / 2 + 1;
    inc = 1;
    t = 0.f;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	if (i__ == k) {
	    goto L130;
	}
	aki = (r__1 = dihdi[k1], dabs(r__1));
	si = w[i__];
	j = diag0 + i__;
	t1 = (akk - w[j] + si - aki) * .5f;
	t1 += sqrt(t1 * t1 + sk * aki);
	if (t < t1) {
	    t = t1;
	}
	if (i__ < k) {
	    goto L140;
	}
L130:
	inc = i__;
L140:
	k1 += inc;
/* L150: */
    }

    w[emin] = akk - t;
    uk = v[1] / rad - w[emin];
    if (v[1] == 0.f) {
	uk = uk + .001f + uk * .001f;
    }
    if (uk <= 0.f) {
	uk = .001f;
    }

/*  ***  COMPUTE GERSCHGORIN (OVER-)ESTIMATE OF LARGEST EIGENVALUE  *** */

    k = 1;
    t1 = w[diag] + w[1];
    if (*p <= 1) {
	goto L170;
    }
    i__1 = *p;
    for (i__ = 2; i__ <= i__1; ++i__) {
	j = diag0 + i__;
	t = w[j] + w[i__];
	if (t <= t1) {
	    goto L160;
	}
	t1 = t;
	k = i__;
L160:
	;
    }

L170:
    sk = w[k];
    j = diag0 + k;
    akk = w[j];
    k1 = k * (k - 1) / 2 + 1;
    inc = 1;
    t = 0.f;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	if (i__ == k) {
	    goto L180;
	}
	aki = (r__1 = dihdi[k1], dabs(r__1));
	si = w[i__];
	j = diag0 + i__;
	t1 = (w[j] + si - aki - akk) * .5f;
	t1 += sqrt(t1 * t1 + sk * aki);
	if (t < t1) {
	    t = t1;
	}
	if (i__ < k) {
	    goto L190;
	}
L180:
	inc = i__;
L190:
	k1 += inc;
/* L200: */
    }

    w[emax] = akk + t;
/* Computing MAX */
    r__1 = lk, r__2 = v[1] / rad - w[emax];
    lk = dmax(r__1,r__2);

/*     ***  ALPHAK = CURRENT VALUE OF ALPHA (SEE ALG. NOTES ABOVE).  WE */
/*     ***  USE MORE*S SCHEME FOR INITIALIZING IT. */
    alphak = dabs(v[5]) * v[9] / rad;
/* Computing MIN */
    r__1 = uk, r__2 = dmax(alphak,lk);
    alphak = dmin(r__1,r__2);

    if (irc != 0) {
	goto L210;
    }

/*  ***  COMPUTE L0 FOR POSITIVE DEFINITE H  *** */

    l7ivm_(p, &w[1], &l[1], &w[q]);
    t = v2nrm_(p, &w[1]);
    w[phipin] = rad / t / t;
/* Computing MAX */
    r__1 = lk, r__2 = phi * w[phipin];
    lk = dmax(r__1,r__2);

/*  ***  SAFEGUARD ALPHAK AND ADD ALPHAK*I TO (D**-1)*H*(D**-1)  *** */

L210:
    ++(*ka);
    if (-v[3] >= alphak || alphak < lk || alphak >= uk) {
/* Computing MAX */
	r__1 = .001f, r__2 = sqrt(lk / uk);
	alphak = uk * dmax(r__1,r__2);
    }
    if (alphak <= 0.f) {
	alphak = uk * .5f;
    }
    if (alphak <= 0.f) {
	alphak = uk;
    }
    k = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	k += i__;
	j = diag0 + i__;
	dihdi[k] = w[j] + alphak;
/* L220: */
    }

/*  ***  TRY COMPUTING CHOLESKY DECOMPOSITION  *** */

    l7srt_(&c__1, p, &l[1], &dihdi[1], &irc);
    if (irc == 0) {
	goto L240;
    }

/*  ***  (D**-1)*H*(D**-1) + ALPHAK*I  IS INDEFINITE -- OVERESTIMATE */
/*  ***  SMALLEST EIGENVALUE FOR USE IN UPDATING LK  *** */

    j = irc * (irc + 1) / 2;
    t = l[j];
    l[j] = 1.f;
    i__1 = irc;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L230: */
	w[i__] = 0.f;
    }
    w[irc] = 1.f;
    l7itv_(&irc, &w[1], &l[1], &w[1]);
    t1 = v2nrm_(&irc, &w[1]);
    lk = alphak - t / t1 / t1;
    v[3] = -lk;
    if (uk < lk) {
	uk = lk;
    }
    if (alphak < lk) {
	goto L210;
    }

/*  ***  NASTY CASE -- EXACT GERSCHGORIN BOUNDS.  FUDGE LK, UK... */

    t = alphak * .001f;
    if (t <= 0.f) {
	t = .001f;
    }
    lk = alphak + t;
    if (uk <= lk) {
	uk = lk + t;
    }
    goto L210;

/*  ***  ALPHAK MAKES (D**-1)*H*(D**-1) POSITIVE DEFINITE. */
/*  ***  COMPUTE Q = -D*STEP, CHECK FOR CONVERGENCE.  *** */

L240:
    l7ivm_(p, &w[q], &l[1], &dig[1]);
    gtsta = d7tpr_(p, &w[q], &w[q]);
    l7itv_(p, &w[q], &l[1], &w[q]);
    dst = v2nrm_(p, &w[q]);
    phi = dst - rad;
    if (phi <= phimax && phi >= phimin) {
	goto L270;
    }
    if (phi == oldphi) {
	goto L270;
    }
    oldphi = phi;
    if (phi < 0.f) {
	goto L330;
    }

/*  ***  UNACCEPTABLE ALPHAK -- UPDATE LK, UK, ALPHAK  *** */

L250:
    if (*ka >= kalim) {
	goto L270;
    }
/*     ***  THE FOLLOWING AMIN1 IS NECESSARY BECAUSE OF RESTARTS  *** */
    if (phi < 0.f) {
	uk = dmin(uk,alphak);
    }
/*     *** KAMIN = 0 ONLY IFF THE GRADIENT VANISHES  *** */
    if (kamin == 0) {
	goto L210;
    }
    l7ivm_(p, &w[1], &l[1], &w[q]);
/*     *** THE FOLLOWING, COMMENTED CALCULATION OF ALPHAK IS SOMETIMES */
/*     *** SAFER BUT WORSE IN PERFORMANCE... */
/*     T1 = DST /  V2NRM(P, W) */
/*     ALPHAK = ALPHAK  +  T1 * (PHI/RAD) * T1 */
    t1 = v2nrm_(p, &w[1]);
    alphak += phi / t1 * (dst / t1) * (dst / rad);
    lk = dmax(lk,alphak);
    alphak = lk;
    goto L210;

/*  ***  ACCEPTABLE STEP ON FIRST TRY  *** */

L260:
    alphak = 0.f;

/*  ***  SUCCESSFUL STEP IN GENERAL.  COMPUTE STEP = -(D**-1)*Q  *** */

L270:
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	j = q0 + i__;
	step[i__] = -w[j] / d__[i__];
/* L280: */
    }
    v[4] = -gtsta;
    v[7] = (dabs(alphak) * dst * dst + gtsta) * .5f;
    goto L410;


/*  ***  RESTART WITH NEW RADIUS  *** */

L290:
    if (v[3] <= 0.f || v[3] - rad > phimax) {
	goto L310;
    }

/*     ***  PREPARE TO RETURN NEWTON STEP  *** */

    restrt = TRUE_;
    ++(*ka);
    k = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	k += i__;
	j = diag0 + i__;
	dihdi[k] = w[j];
/* L300: */
    }
    uk = -1.f;
    goto L30;

L310:
    kamin = *ka + 3;
    if (v[1] == 0.f) {
	kamin = 0;
    }
    if (*ka == 0) {
	goto L50;
    }

    dst = w[dstsav];
    alphak = dabs(v[5]);
    phi = dst - rad;
    t = v[1] / rad;
    uk = t - w[emin];
    if (v[1] == 0.f) {
	uk = uk + .001f + uk * .001f;
    }
    if (uk <= 0.f) {
	uk = .001f;
    }
    if (rad > v[9]) {
	goto L320;
    }

/*        ***  SMALLER RADIUS  *** */
    lk = 0.f;
    if (alphak > 0.f) {
	lk = w[lk0];
    }
/* Computing MAX */
    r__1 = lk, r__2 = t - w[emax];
    lk = dmax(r__1,r__2);
    if (v[3] > 0.f) {
/* Computing MAX */
	r__1 = lk, r__2 = (v[3] - rad) * w[phipin];
	lk = dmax(r__1,r__2);
    }
    goto L250;

/*     ***  BIGGER RADIUS  *** */
L320:
    if (alphak > 0.f) {
/* Computing MIN */
	r__1 = uk, r__2 = w[uk0];
	uk = dmin(r__1,r__2);
    }
/* Computing MAX */
    r__1 = 0.f, r__2 = -v[3], r__1 = max(r__1,r__2), r__2 = t - w[emax];
    lk = dmax(r__1,r__2);
    if (v[3] > 0.f) {
/* Computing MAX */
	r__1 = lk, r__2 = (v[3] - rad) * w[phipin];
	lk = dmax(r__1,r__2);
    }
    goto L250;

/*  ***  DECIDE WHETHER TO CHECK FOR SPECIAL CASE... IN PRACTICE (FROM */
/*  ***  THE STANDPOINT OF THE CALLING OPTIMIZATION CODE) IT SEEMS BEST */
/*  ***  NOT TO CHECK UNTIL A FEW ITERATIONS HAVE FAILED -- HENCE THE */
/*  ***  TEST ON KAMIN BELOW. */

L330:
    delta = alphak + dmin(0.f,v[3]);
    twopsi = alphak * dst * dst + gtsta;
    if (*ka >= kamin) {
	goto L340;
    }
/*     *** IF THE TEST IN REF. 2 IS SATISFIED, FALL THROUGH TO HANDLE */
/*     *** THE SPECIAL CASE (AS SOON AS THE MORE-SORENSEN TEST DETECTS */
/*     *** IT). */
    if (psifac >= big) {
	goto L340;
    }
    if (delta >= psifac * twopsi) {
	goto L370;
    }

/*  ***  CHECK FOR THE SPECIAL CASE OF  H + ALPHA*D**2  (NEARLY) */
/*  ***  SINGULAR.  USE ONE STEP OF INVERSE POWER METHOD WITH START */
/*  ***  FROM  L7SVN TO OBTAIN APPROXIMATE EIGENVECTOR CORRESPONDING */
/*  ***  TO SMALLEST EIGENVALUE OF (D**-1)*H*(D**-1).   L7SVN RETURNS */
/*  ***  X AND W WITH  L*W = X. */

L340:
    t = l7svn_(p, &l[1], &w[x], &w[1]);

/*     ***  NORMALIZE W  *** */
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L350: */
	w[i__] = t * w[i__];
    }
/*     ***  COMPLETE CURRENT INV. POWER ITER. -- REPLACE W BY (L**-T)*W. */
    l7itv_(p, &w[1], &l[1], &w[1]);
    t2 = 1.f / v2nrm_(p, &w[1]);
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L360: */
	w[i__] = t2 * w[i__];
    }
    t = t2 * t;

/*  ***  NOW W IS THE DESIRED APPROXIMATE (UNIT) EIGENVECTOR AND */
/*  ***  T*X = ((D**-1)*H*(D**-1) + ALPHAK*I)*W. */

    sw = d7tpr_(p, &w[q], &w[1]);
    t1 = (rad + dst) * (rad - dst);
    root = sqrt(sw * sw + t1);
    if (sw < 0.f) {
	root = -root;
    }
    si = t1 / (sw + root);

/*  ***  THE ACTUAL TEST FOR THE SPECIAL CASE... */

/* Computing 2nd power */
    r__1 = t2 * si;
/* Computing 2nd power */
    r__2 = dst;
    if (r__1 * r__1 <= eps * (r__2 * r__2 + alphak * radsq)) {
	goto L380;
    }

/*  ***  UPDATE UPPER BOUND ON SMALLEST EIGENVALUE (WHEN NOT POSITIVE) */
/*  ***  (AS RECOMMENDED BY MORE AND SORENSEN) AND CONTINUE... */

    if (v[3] <= 0.f) {
/* Computing MIN */
/* Computing 2nd power */
	r__3 = t2;
	r__1 = v[3], r__2 = r__3 * r__3 - alphak;
	v[3] = dmin(r__1,r__2);
    }
/* Computing MAX */
    r__1 = lk, r__2 = -v[3];
    lk = dmax(r__1,r__2);

/*  ***  CHECK WHETHER WE CAN HOPE TO DETECT THE SPECIAL CASE IN */
/*  ***  THE AVAILABLE ARITHMETIC.  ACCEPT STEP AS IT IS IF NOT. */

/*     ***  IF NOT YET AVAILABLE, OBTAIN MACHINE DEPENDENT VALUE DGXFAC. */
L370:
    if (dgxfac == 0.f) {
	dgxfac = r7mdc_(&c__3) * 50.f;
    }

    if (delta > dgxfac * w[dggdmx]) {
	goto L250;
    }
    goto L270;

/*  ***  SPECIAL CASE DETECTED... NEGATE ALPHAK TO INDICATE SPECIAL CASE */

L380:
    alphak = -alphak;
    v[7] = twopsi * .5f;

/*  ***  ACCEPT CURRENT STEP IF ADDING SI*W WOULD LEAD TO A */
/*  ***  FURTHER RELATIVE REDUCTION IN PSI OF LESS THAN V(EPSLON)/3. */

    t1 = 0.f;
    t = si * (alphak * sw - si * .5f * (alphak + t * d7tpr_(p, &w[x], &w[1])))
	    ;
    if (t < eps * twopsi / 6.f) {
	goto L390;
    }
    v[7] += t;
    dst = rad;
    t1 = -si;
L390:
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	j = q0 + i__;
	w[j] = t1 * w[i__] - w[j];
	step[i__] = w[j] / d__[i__];
/* L400: */
    }
    v[4] = d7tpr_(p, &dig[1], &w[q]);

/*  ***  SAVE VALUES FOR USE IN A POSSIBLE RESTART  *** */

L410:
    v[2] = dst;
    v[5] = alphak;
    w[lk0] = lk;
    w[uk0] = uk;
    v[9] = rad;
    w[dstsav] = dst;

/*     ***  RESTORE DIAGONAL OF DIHDI  *** */

    j = 0;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	j += i__;
	k = diag0 + i__;
	dihdi[j] = w[k];
/* L420: */
    }

/* L999: */
    return 0;

/*  ***  LAST CARD OF G7QTS FOLLOWS  *** */
} /* g7qts_ */

