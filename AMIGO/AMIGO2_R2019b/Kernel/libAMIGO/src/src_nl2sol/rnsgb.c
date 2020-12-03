/* rnsgb.f -- translated by f2c (version 20100827).
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
static integer c__0 = 0;
static integer c__3 = 3;

/* Subroutine */ int rnsgb_(real *a, real *alf, real *b, real *c__, real *da, 
	integer *in, integer *iv, integer *l, integer *l1, integer *la, 
	integer *liv, integer *lv, integer *n, integer *nda, integer *p, real 
	*v, real *y)
{
    /* Initialized data */

    static real machep = -1.f;
    static real negone = -1.f;
    static real sngfac = 100.f;
    static real zero = 0.f;

    /* System generated locals */
    integer a_dim1, a_offset, da_dim1, da_offset, i__1;
    real r__1;

    /* Local variables */
    static integer i__, k;
    static real t;
    static integer d1, i1, j1, n1, n2, r1, md, ar1, dr1, rd1, r1l, iv1, ier, 
	    nml, dr1l, jlen, ll1o2, nran;
    extern /* Subroutine */ int rn2gb_(real *, real *, real *, integer *, 
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    integer *, real *, real *, real *, real *);
    extern doublereal r7mdc_(integer *);
    extern /* Subroutine */ int q7apl_(integer *, integer *, integer *, real *
	    , real *, integer *), q7rfh_(integer *, integer *, integer *, 
	    integer *, integer *, integer *, real *, real *, integer *, real *
	    );
    static integer ipiv1;
    extern /* Subroutine */ int s7cpr_(real *, integer *, integer *, integer *
	    ), v7scp_(integer *, real *, real *), l7itv_(integer *, real *, 
	    real *, real *), v7cpy_(integer *, real *, real *);
    extern doublereal l7svn_(integer *, real *, real *, real *);
    extern /* Subroutine */ int v2axy_(integer *, real *, real *, real *, 
	    real *), v7prm_(integer *, integer *, real *);
    extern doublereal l7svx_(integer *, real *, real *, real *);
    extern /* Subroutine */ int ivset_(integer *, integer *, integer *, 
	    integer *, real *), itsum_(real *, real *, integer *, integer *, 
	    integer *, integer *, real *, real *);
    static integer csave1;
    static real singtl;


/*  ***  ITERATION DRIVER FOR SEPARABLE NONLINEAR LEAST SQUARES, */
/*  ***  WITH SIMPLE BOUNDS ON THE NONLINEAR VARIABLES. */

/*  ***  PARAMETER DECLARATIONS  *** */

/*     DIMENSION UIPARM(*) */

/*  ***  PURPOSE  *** */

/* GIVEN A SET OF N OBSERVATIONS Y(1)....Y(N) OF A DEPENDENT VARIABLE */
/* T(1)...T(N),  RNSGB ATTEMPTS TO COMPUTE A LEAST SQUARES FIT */
/* TO A FUNCTION  ETA  (THE MODEL) WHICH IS A LINEAR COMBINATION */

/*                  L */
/* ETA(C,ALF,T) =  SUM C * PHI(ALF,T) +PHI   (ALF,T) */
/*                 J=1  J     J           L+1 */

/* OF NONLINEAR FUNCTIONS PHI(J) DEPENDENT ON T AND ALF(1),...,ALF(P) */
/* (.E.G. A SUM OF EXPONENTIALS OR GAUSSIANS).  THAT IS, IT DETERMINES */
/* NONLINEAR PARAMETERS ALF WHICH MINIMIZE */

/*                   2    N                      2 */
/*     NORM(RESIDUAL)  = SUM  (Y - ETA(C,ALF,T )) , */
/*                       I=1    I             I */

/* SUBJECT TO THE SIMPLE BOUND CONSTRAINTS */
/* B(1,I) .LE. ALF(I) .LE. B(2,I), I = 1(1)P. */

/* THE (L+1)ST TERM IS OPTIONAL. */


/*  ***  PARAMETERS  *** */

/*      A (IN)  MATRIX PHI(ALF,T) OF THE MODEL. */
/*    ALF (I/O) NONLINEAR PARAMETERS. */
/*                 INPUT = INITIAL GUESS, */
/*                 OUTPUT = BEST ESTIMATE FOUND. */
/*      C (OUT) LINEAR PARAMETERS (ESTIMATED). */
/*     DA (IN)  DERIVATIVES OF COLUMNS OF A WITH RESPECT TO COMPONENTS */
/*                 OF ALF, AS SPECIFIED BY THE IN ARRAY... */
/*     IN (IN)  WHEN  RNSGB IS CALLED WITH IV(1) = 2 OR -2, THEN FOR */
/*                 I = 1(1)NDA, COLUMN I OF DA IS THE PARTIAL */
/*                 DERIVATIVE WITH RESPECT TO ALF(IN(1,I)) OF COLUMN */
/*                 IN(2,I) OF A, UNLESS IV(1,I) IS NOT POSITIVE (IN */
/*                 WHICH CASE COLUMN I OF DA IS IGNORED.  IV(1) = -2 */
/*                 MEANS THERE ARE MORE COLUMNS OF DA TO COME AND */
/*                  RNSGB SHOULD RETURN FOR THEM. */
/*     IV (I/O) INTEGER PARAMETER AND SCRATCH VECTOR.   RNSGB RETURNS */
/*                 WITH IV(1) = 1 WHEN IT WANTS A TO BE EVALUATED AT */
/*                 ALF AND WITH IV(1) = 2 WHEN IT WANTS DA TO BE */
/*                 EVALUATED AT ALF.  WHEN CALLED WITH IV(1) = -2 */
/*                 (AFTER A RETURN WITH IV(1) = 2),  RNSGB RETURNS */
/*                 WITH IV(1) = -2 TO GET MORE COLUMNS OF DA. */
/*      L (IN)  NUMBER OF LINEAR PARAMETERS TO BE ESTIMATED. */
/*     L1 (IN)  L+1 IF PHI(L+1) IS IN THE MODEL, L IF NOT. */
/*     LA (IN)  LEAD DIMENSION OF A.  MUST BE AT LEAST N. */
/*    LIV (IN)  LENGTH OF IV.  MUST BE AT LEAST 110 + L + 4*P. */
/*     LV (IN)  LENGTH OF V.  MUST BE AT LEAST */
/*                 105 + 2*N + L*(L+3)/2 + P*(2*P + 21 + N). */
/*      N (IN)  NUMBER OF OBSERVATIONS. */
/*    NDA (IN)  NUMBER OF COLUMNS IN DA AND IN. */
/*      P (IN)  NUMBER OF NONLINEAR PARAMETERS TO BE ESTIMATED. */
/*      V (I/O) FLOATING-POINT PARAMETER AND SCRATCH VECTOR. */
/*      Y (IN)  RIGHT-HAND SIDE VECTOR. */


/*  ***  EXTERNAL SUBROUTINES  *** */


/* IVSET.... SUPPLIES DEFAULT PARAMETER VALUES. */
/* ITSUM.... PRINTS ITERATION SUMMARY, INITIAL AND FINAL ALF. */
/*  L7ITV... APPLIES INVERSE-TRANSPOSE OF COMPACT LOWER TRIANG. MATRIX. */
/*  L7SVX... ESTIMATES LARGEST SING. VALUE OF LOWER TRIANG. MATRIX. */
/*  L7SVN... ESTIMATES SMALLEST SING. VALUE OF LOWER TRIANG. MATRIX. */
/*  RN2GB... UNDERLYING NONLINEAR LEAST-SQUARES SOLVER. */
/*  Q7APL... APPLIES HOUSEHOLDER TRANSFORMS STORED BY Q7RFH. */
/* Q7RFH.... COMPUTES QR FACT. VIA HOUSEHOLDER TRANSFORMS WITH PIVOTING. */
/*  R7MDC... RETURNS MACHINE-DEP. CONSTANTS. */
/*  S7CPR... PRINTS LINEAR PARAMETERS AT SOLUTION. */
/* V2AXY.... ADDS MULTIPLE OF ONE VECTOR TO ANOTHER. */
/* V7CPY.... COPIES ONE VECTOR TO ANOTHER. */
/* V7PRM.... PERMUTES VECTOR. */
/*  V7SCL... SCALES AND COPIES ONE VECTOR TO ANOTHER. */

/*  ***  LOCAL VARIABLES  *** */


/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA AR/110/, CSAVE/105/, D/27/, IERS/108/, IPIVS/109/, */
/*    1     IV1SAV/104/, IVNEED/3/, J/70/, MODE/35/, NEXTIV/46/, */
/*    2     NEXTV/47/, NFCALL/6/, NFGCAL/7/, PERM/58/, R/61/, REGD/67/, */
/*    3     REGD0/82/, RESTOR/9/, TOOBIG/2/, VNEED/4/ */
/* /7 */
/* / */
    /* Parameter adjustments */
    --c__;
    a_dim1 = *la;
    a_offset = 1 + a_dim1;
    a -= a_offset;
    --iv;
    --v;
    --y;
    in -= 3;
    da_dim1 = *la;
    da_offset = 1 + da_dim1;
    da -= da_offset;
    b -= 3;
    --alf;

    /* Function Body */

/* ++++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++ */


    if (iv[1] == 0) {
	ivset_(&c__1, &iv[1], liv, lv, &v[1]);
    }
    n1 = 1;
    nml = *n;
    iv1 = iv[1];
    if (iv1 <= 2) {
	goto L20;
    }

/*  ***  CHECK INPUT INTEGERS  *** */

    if (*p <= 0) {
	goto L240;
    }
    if (*l < 0) {
	goto L240;
    }
    if (*n <= *l) {
	goto L240;
    }
    if (*la < *n) {
	goto L240;
    }
    if (iv1 < 12) {
	goto L20;
    }
    if (iv1 == 14) {
	goto L20;
    }
    if (iv1 == 12) {
	iv[1] = 13;
    }

/*  ***  FRESH START -- COMPUTE STORAGE REQUIREMENTS  *** */

    if (iv[1] > 16) {
	goto L240;
    }
    ll1o2 = *l * (*l + 1) / 2;
    jlen = *n * *p;
    i__ = *l + *p;
    if (iv[1] != 13) {
	goto L10;
    }
    iv[3] += *l;
    iv[4] = iv[4] + *p + (*n << 1) + jlen + ll1o2 + *l;
L10:
    if (iv[58] <= 110) {
	iv[58] = 111;
    }
    rn2gb_(&b[3], &v[1], &v[1], &iv[1], liv, lv, n, n, &n1, &nml, p, &v[1], &
	    v[1], &v[1], &alf[1]);
    if (iv[1] != 14) {
	goto L999;
    }

/*  ***  STORAGE ALLOCATION  *** */

    iv[109] = iv[46];
    iv[46] += *l;
    iv[27] = iv[47];
    iv[82] = iv[27] + *p;
    iv[110] = iv[82] + *n;
    iv[105] = iv[110] + ll1o2;
    iv[70] = iv[105] + *l;
    iv[61] = iv[70] + jlen;
    iv[47] = iv[61] + *n;
    iv[108] = 0;
    if (iv1 == 13) {
	goto L999;
    }

/*  ***  SET POINTERS INTO IV AND V  *** */

L20:
    ar1 = iv[110];
    d1 = iv[27];
    dr1 = iv[70];
    dr1l = dr1 + *l;
    r1 = iv[61];
    r1l = r1 + *l;
    rd1 = iv[82];
    csave1 = iv[105];
    nml = *n - *l;
    if (iv1 <= 2) {
	goto L50;
    }

L30:
    n2 = nml;
    rn2gb_(&b[3], &v[d1], &v[dr1l], &iv[1], liv, lv, &nml, n, &n1, &n2, p, &v[
	    r1l], &v[rd1], &v[1], &alf[1]);
    if ((i__1 = iv[9] - 2, abs(i__1)) == 1 && *l > 0) {
	v7cpy_(l, &c__[1], &v[csave1]);
    }
    iv1 = iv[1];
    if ((i__1 = iv1 - 2) < 0) {
	goto L40;
    } else if (i__1 == 0) {
	goto L150;
    } else {
	goto L230;
    }

/*  ***  NEW FUNCTION VALUE (RESIDUAL) NEEDED  *** */

L40:
    iv[104] = iv[1];
    iv[1] = abs(iv1);
    if (iv[9] == 2 && *l > 0) {
	v7cpy_(l, &v[csave1], &c__[1]);
    }
    goto L999;

/*  ***  COMPUTE NEW RESIDUAL OR GRADIENT  *** */

L50:
    iv[1] = iv[104];
    md = iv[35];
    if (md <= 0) {
	goto L60;
    }
    nml = *n;
    dr1l = dr1;
    r1l = r1;
L60:
    if (iv[2] != 0) {
	goto L30;
    }
    if (abs(iv1) == 2) {
	goto L170;
    }

/*  ***  COMPUTE NEW RESIDUAL  *** */

    if (*l1 <= *l) {
	v7cpy_(n, &v[r1], &y[1]);
    }
    if (*l1 > *l) {
	v2axy_(n, &v[r1], &negone, &a[*l1 * a_dim1 + 1], &y[1]);
    }
    if (md > 0) {
	goto L120;
    }
    ier = 0;
    if (*l <= 0) {
	goto L110;
    }
    ll1o2 = *l * (*l + 1) / 2;
    ipiv1 = iv[109];
    q7rfh_(&ier, &iv[ipiv1], n, la, &c__0, l, &a[a_offset], &v[ar1], &ll1o2, &
	    c__[1]);

/* *** DETERMINE NUMERICAL RANK OF A *** */

    if (machep <= zero) {
	machep = r7mdc_(&c__3);
    }
    singtl = sngfac * (real) max(*l,*n) * machep;
    k = *l;
    if (ier != 0) {
	k = ier - 1;
    }
L70:
    if (k <= 0) {
	goto L90;
    }
    t = l7svx_(&k, &v[ar1], &c__[1], &c__[1]);
    if (t > zero) {
	t = l7svn_(&k, &v[ar1], &c__[1], &c__[1]) / t;
    }
    if (t > singtl) {
	goto L80;
    }
    --k;
    goto L70;

/* *** RECORD RANK IN IV(IERS)... IV(IERS) = 0 MEANS FULL RANK, */
/* *** IV(IERS) .GT. 0 MEANS RANK IV(IERS) - 1. */

L80:
    if (k >= *l) {
	goto L100;
    }
L90:
    ier = k + 1;
    i__1 = *l - k;
    v7scp_(&i__1, &c__[k + 1], &zero);
L100:
    iv[108] = ier;
    if (k <= 0) {
	goto L110;
    }

/* *** APPLY HOUSEHOLDER TRANSFORMATONS TO RESIDUALS... */

    q7apl_(la, n, &k, &a[a_offset], &v[r1], &ier);

/* *** COMPUTING C NOW MAY SAVE A FUNCTION EVALUATION AT */
/* *** THE LAST ITERATION. */

    l7itv_(&k, &c__[1], &v[ar1], &v[r1]);
    v7prm_(l, &iv[ipiv1], &c__[1]);

L110:
    if (iv[1] < 2) {
	goto L220;
    }
    goto L999;


/*  ***  RESIDUAL COMPUTATION FOR F.D. HESSIAN  *** */

L120:
    if (*l <= 0) {
	goto L140;
    }
    i__1 = *l;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L130: */
	r__1 = -c__[i__];
	v2axy_(n, &v[r1], &r__1, &a[i__ * a_dim1 + 1], &v[r1]);
    }
L140:
    if (iv[1] > 0) {
	goto L30;
    }
    iv[1] = 2;
    goto L160;

/*  ***  NEW GRADIENT (JACOBIAN) NEEDED  *** */

L150:
    iv[104] = iv1;
    if (iv[7] != iv[6]) {
	iv[1] = 1;
    }
L160:
    i__1 = *n * *p;
    v7scp_(&i__1, &v[dr1], &zero);
    goto L999;

/*  ***  COMPUTE NEW JACOBIAN  *** */

L170:
    if (*nda <= 0) {
	goto L240;
    }
    i__1 = *nda;
    for (i__ = 1; i__ <= i__1; ++i__) {
	i1 = in[(i__ << 1) + 1] - 1;
	if (i1 < 0) {
	    goto L180;
	}
	j1 = in[(i__ << 1) + 2];
	k = dr1 + i1 * *n;
	t = negone;
	if (j1 <= *l) {
	    t = -c__[j1];
	}
	v2axy_(n, &v[k], &t, &da[i__ * da_dim1 + 1], &v[k]);
L180:
	;
    }
    if (iv1 == 2) {
	goto L190;
    }
    iv[1] = iv1;
    goto L999;
L190:
    if (*l <= 0) {
	goto L30;
    }
    if (md > 0) {
	goto L30;
    }
    k = dr1;
    ier = iv[108];
    nran = *l;
    if (ier > 0) {
	nran = ier - 1;
    }
    if (nran <= 0) {
	goto L210;
    }
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	q7apl_(la, n, &nran, &a[a_offset], &v[k], &ier);
	k += *n;
/* L200: */
    }
L210:
    v7cpy_(l, &v[csave1], &c__[1]);
L220:
    if (ier == 0) {
	goto L30;
    }

/*     *** ADJUST SUBSCRIPTS DESCRIBING R AND DR... */

    nran = ier - 1;
    dr1l = dr1 + nran;
    nml = *n - nran;
    r1l = r1 + nran;
    goto L30;

/*  ***  CONVERGENCE OR LIMIT REACHED  *** */

L230:
    if (iv[67] == 1) {
	iv[67] = rd1;
    }
    if (iv[1] <= 11) {
	s7cpr_(&c__[1], &iv[1], l, liv);
    }
    goto L999;

L240:
    iv[1] = 66;
    itsum_(&v[1], &v[1], &iv[1], liv, lv, p, &v[1], &alf[1]);

L999:
    return 0;

/*  ***  LAST CARD OF  RNSGB FOLLOWS  *** */
} /* rnsgb_ */

