/* rnsg.f -- translated by f2c (version 20100827).
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
static logical c_false = FALSE_;
static integer c__4 = 4;

/* Subroutine */ int rnsg_(real *a, real *alf, real *c__, real *da, integer *
	in, integer *iv, integer *l, integer *l1, integer *la, integer *liv, 
	integer *lv, integer *n, integer *nda, integer *p, real *v, real *y)
{
    /* Initialized data */

    static real machep = -1.f;
    static real negone = -1.f;
    static real sngfac = 100.f;
    static real zero = 0.f;

    /* System generated locals */
    integer a_dim1, a_offset, da_dim1, da_offset, i__1, i__2;
    real r__1;

    /* Local variables */
    static integer i__, k;
    static real t;
    static integer d1, i1, j1, n1, n2, r1, md, lh, li, pp, ar1, dr1, rd1, r1l,
	     iv1, pp1, dri, ier, nml, fdh0, dri1, dr1l;
    extern /* Subroutine */ int rn2g_(real *, real *, integer *, integer *, 
	    integer *, integer *, integer *, integer *, integer *, integer *, 
	    real *, real *, real *, real *);
    static integer jlen, ll1o2, nran;
    extern doublereal r7mdc_(integer *);
    extern /* Subroutine */ int q7rad_(integer *, integer *, integer *, real *
	    , logical *, real *, real *, real *), n2lrd_(real *, integer *, 
	    real *, integer *, integer *, integer *, integer *, integer *, 
	    integer *, real *, real *, real *), c7vfn_(integer *, real *, 
	    integer *, integer *, integer *, integer *, integer *, real *), 
	    q7apl_(integer *, integer *, integer *, real *, real *, integer *)
	    , n2rdp_(integer *, integer *, integer *, integer *, real *, real 
	    *);
    static integer temp1;
    extern /* Subroutine */ int q7rfh_(integer *, integer *, integer *, 
	    integer *, integer *, integer *, real *, real *, integer *, real *
	    ), n2cvp_(integer *, integer *, integer *, integer *, real *);
    static integer ipiv1;
    extern /* Subroutine */ int s7cpr_(real *, integer *, integer *, integer *
	    ), v7scl_(integer *, real *, real *, real *);
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int v7scp_(integer *, real *, real *), l7itv_(
	    integer *, real *, real *, real *), v7cpy_(integer *, real *, 
	    real *);
    extern doublereal l7svn_(integer *, real *, real *, real *);
    extern /* Subroutine */ int v2axy_(integer *, real *, real *, real *, 
	    real *), l7srt_(integer *, integer *, real *, real *, integer *), 
	    v7prm_(integer *, integer *, real *);
    extern doublereal l7svx_(integer *, real *, real *, real *);
    static integer hsave;
    static logical nocov;
    extern /* Subroutine */ int ivset_(integer *, integer *, integer *, 
	    integer *, real *), itsum_(real *, real *, integer *, integer *, 
	    integer *, integer *, real *, real *);
    static integer csave1;
    static real singtl;


/*  ***  ITERATION DRIVER FOR SEPARABLE NONLINEAR LEAST SQUARES. */

/*  ***  PARAMETER DECLARATIONS  *** */

/*     DIMENSION UIPARM(*) */

/*  ***  PURPOSE  *** */

/* GIVEN A SET OF N OBSERVATIONS Y(1)....Y(N) OF A DEPENDENT VARIABLE */
/* T(1)...T(N),   RNSG ATTEMPTS TO COMPUTE A LEAST SQUARES FIT */
/* TO A FUNCTION  ETA  (THE MODEL) WHICH IS A LINEAR COMBINATION */

/*                  L */
/* ETA(C,ALF,T) =  SUM C * PHI(ALF,T) +PHI   (ALF,T) */
/*                 J=1  J     J           L+1 */

/* OF NONLINEAR FUNCTIONS PHI(J) DEPENDENT ON T AND ALF(1),...,ALF(P) */
/* (.E.G. A SUM OF EXPONENTIALS OR GAUSSIANS).  THAT IS, IT DETERMINES */
/* NONLINEAR PARAMETERS ALF WHICH MINIMIZE */

/*                   2    N                      2 */
/*     NORM(RESIDUAL)  = SUM  (Y - ETA(C,ALF,T )). */
/*                       I=1    I             I */

/* THE (L+1)ST TERM IS OPTIONAL. */


/*  ***  PARAMETERS  *** */

/*      A (IN)  MATRIX PHI(ALF,T) OF THE MODEL. */
/*    ALF (I/O) NONLINEAR PARAMETERS. */
/*                 INPUT = INITIAL GUESS, */
/*                 OUTPUT = BEST ESTIMATE FOUND. */
/*      C (OUT) LINEAR PARAMETERS (ESTIMATED). */
/*     DA (IN)  DERIVATIVES OF COLUMNS OF A WITH RESPECT TO COMPONENTS */
/*                 OF ALF, AS SPECIFIED BY THE IN ARRAY... */
/*     IN (IN)  WHEN   RNSG IS CALLED WITH IV(1) = 2 OR -2, THEN FOR */
/*                 I = 1(1)NDA, COLUMN I OF DA IS THE PARTIAL */
/*                 DERIVATIVE WITH RESPECT TO ALF(IN(1,I)) OF COLUMN */
/*                 IN(2,I) OF A, UNLESS IV(1,I) IS NOT POSITIVE (IN */
/*                 WHICH CASE COLUMN I OF DA IS IGNORED.  IV(1) = -2 */
/*                 MEANS THERE ARE MORE COLUMNS OF DA TO COME AND */
/*                   RNSG SHOULD RETURN FOR THEM. */
/*     IV (I/O) INTEGER PARAMETER AND SCRATCH VECTOR.    RNSG RETURNS */
/*                 WITH IV(1) = 1 WHEN IT WANTS A TO BE EVALUATED AT */
/*                 ALF AND WITH IV(1) = 2 WHEN IT WANTS DA TO BE */
/*                 EVALUATED AT ALF.  WHEN CALLED WITH IV(1) = -2 */
/*                 (AFTER A RETURN WITH IV(1) = 2),   RNSG RETURNS */
/*                 WITH IV(1) = -2 TO GET MORE COLUMNS OF DA. */
/*      L (IN)  NUMBER OF LINEAR PARAMETERS TO BE ESTIMATED. */
/*     L1 (IN)  L+1 IF PHI(L+1) IS IN THE MODEL, L IF NOT. */
/*     LA (IN)  LEAD DIMENSION OF A.  MUST BE AT LEAST N. */
/*    LIV (IN)  LENGTH OF IV.  MUST BE AT LEAST 110 + L + P. */
/*     LV (IN)  LENGTH OF V.  MUST BE AT LEAST */
/*                 105 + 2*N + JLEN + L*(L+3)/2 + P*(2*P + 17), */
/*                 WHERE  JLEN = (L+P)*(N+L+P+1),  UNLESS NEITHER A */
/*                 COVARIANCE MATRIX NOR REGRESSION DIAGNOSTICS ARE */
/*                 REQUESTED, IN WHICH CASE  JLEN = N*P. */
/*      N (IN)  NUMBER OF OBSERVATIONS. */
/*    NDA (IN)  NUMBER OF COLUMNS IN DA AND IN. */
/*      P (IN)  NUMBER OF NONLINEAR PARAMETERS TO BE ESTIMATED. */
/*      V (I/O) FLOATING-POINT PARAMETER AND SCRATCH VECTOR. */
/*              IF A COVARIANCE ESTIMATE IS REQUESTED, IT IS FOR */
/*              (ALF,C) -- NONLINEAR PARAMETERS ORDERED FIRST, */
/*              FOLLOWED BY LINEAR PARAMETERS. */
/*      Y (IN)  RIGHT-HAND SIDE VECTOR. */


/*  ***  EXTERNAL SUBROUTINES  *** */


/*  C7VFN... FINISHES COVARIANCE COMPUTATION. */
/* IVSET.... SUPPLIES DEFAULT PARAMETER VALUES. */
/*  D7TPR... RETURNS INNER PRODUCT OF TWO VECTORS. */
/* ITSUM.... PRINTS ITERATION SUMMARY, INITIAL AND FINAL ALF. */
/*  L7ITV... APPLIES INVERSE-TRANSPOSE OF COMPACT LOWER TRIANG. MATRIX. */
/* L7SRT.... COMPUTES (PARTIAL) CHOLESKY FACTORIZATION. */
/*  L7SVX... ESTIMATES LARGEST SING. VALUE OF LOWER TRIANG. MATRIX. */
/*  L7SVN... ESTIMATES SMALLEST SING. VALUE OF LOWER TRIANG. MATRIX. */
/*  N2CVP... PRINTS COVARIANCE MATRIX. */
/*  N2LRD... COMPUTES COVARIANCE AND REGRESSION DIAGNOSTICS. */
/*  N2RDP... PRINTS REGRESSION DIAGNOSTICS. */
/*   RN2G... UNDERLYING NONLINEAR LEAST-SQUARES SOLVER. */
/*  Q7APL... APPLIES HOUSEHOLDER TRANSFORMS STORED BY Q7RFH. */
/* Q7RFH.... COMPUTES QR FACT. VIA HOUSEHOLDER TRANSFORMS WITH PIVOTING. */
/* Q7RAD.... QR FACT., NO PIVOTING. */
/*  R7MDC... RETURNS MACHINE-DEP. CONSTANTS. */
/*  S7CPR... PRINTS LINEAR PARAMETERS AT SOLUTION. */
/* V2AXY.... ADDS MULTIPLE OF ONE VECTOR TO ANOTHER. */
/* V7CPY.... COPIES ONE VECTOR TO ANOTHER. */
/* V7PRM.... PERMUTES A VECTOR. */
/*  V7SCL... SCALES AND COPIES ONE VECTOR TO ANOTHER. */
/*  V7SCP... SETS ALL COMPONENTS OF A VECTOR TO A SCALAR. */

/*  ***  LOCAL VARIABLES  *** */


/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA AR/110/, CNVCOD/55/, COVMAT/26/, COVREQ/15/, CSAVE/105/, */
/*    1     CVRQSV/106/, D/27/, FDH/74/, H/56/, IERS/108/, IPIVS/109/, */
/*    2     IV1SAV/104/, IVNEED/3/, J/70/, LMAT/42/, MODE/35/, */
/*    3     NEXTIV/46/, NEXTV/47/, NFCALL/6/, NFCOV/52/, NFGCAL/7/, */
/*    4     NGCALL/30/, NGCOV/53/, PERM/58/, R/61/, RCOND/53/, RDREQ/57/, */
/*    5     RDRQSV/107/, REGD/67/, REGD0/82/, RESTOR/9/, TOOBIG/2/, */
/*    6     VNEED/4/ */
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
	goto L370;
    }
    if (*l < 0) {
	goto L370;
    }
    if (*n <= *l) {
	goto L370;
    }
    if (*la < *n) {
	goto L370;
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
	goto L370;
    }
    ll1o2 = *l * (*l + 1) / 2;
    jlen = *n * *p;
    i__ = *l + *p;
    if (iv[57] > 0 && iv[15] != 0) {
	jlen = i__ * (*n + i__ + 1);
    }
    if (iv[1] != 13) {
	goto L10;
    }
    iv[3] += *l;
    iv[4] = iv[4] + *p + (*n << 1) + jlen + ll1o2 + *l;
L10:
    if (iv[58] <= 110) {
	iv[58] = 111;
    }
    rn2g_(&v[1], &v[1], &iv[1], liv, lv, n, n, &n1, &nml, p, &v[1], &v[1], &v[
	    1], &alf[1]);
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

/*  ***  IF F.D. HESSIAN WILL BE NEEDED (FOR COVARIANCE OR REG. */
/*  ***  DIAGNOSTICS), HAVE   RN2G COMPUTE ONLY THE PART CORRESP. */
/*  ***  TO ALF WITH C FIXED... */

    if (*l <= 0) {
	goto L30;
    }
    iv[106] = iv[15];
    if (abs(iv[15]) >= 3) {
	iv[15] = 0;
    }
    iv[107] = iv[57];
    if (iv[57] > 0) {
	iv[57] = -1;
    }

L30:
    n2 = nml;
    rn2g_(&v[d1], &v[dr1l], &iv[1], liv, lv, &nml, n, &n1, &n2, p, &v[r1l], &
	    v[rd1], &v[1], &alf[1]);
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
    nocov = md <= *p || abs(iv[15]) >= 3;
    fdh0 = dr1 + *n * (*p + *l);
    if (*nda <= 0) {
	goto L370;
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
	if (nocov) {
	    goto L180;
	}
	if (j1 > *l) {
	    goto L180;
	}
/*        ***  ADD IN (L,P) PORTION OF SECOND-ORDER PART OF HESSIAN */
/*        ***  FOR COVARIANCE OR REG. DIAG. COMPUTATIONS... */
	j1 += *p;
	k = fdh0 + j1 * (j1 - 1) / 2 + i1;
	v[k] -= d7tpr_(n, &v[r1], &da[i__ * da_dim1 + 1]);
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
    if (md > *p) {
	goto L240;
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
    if (*l <= 0) {
	goto L350;
    }
    iv[15] = iv[106];
    iv[57] = iv[107];
    if (iv[1] > 6) {
	goto L360;
    }
    if (iv[57] % 4 == 0) {
	goto L360;
    }
    if (iv[74] <= 0 && abs(iv[15]) < 3) {
	goto L360;
    }
    if (iv[67] > 0) {
	goto L360;
    }
    if (iv[26] > 0) {
	goto L360;
    }

/*  *** PREPARE TO FINISH COMPUTING COVARIANCE MATRIX AND REG. DIAG. *** */

    pp = *l + *p;
    i__ = 0;
    if (iv[57] % 4 >= 2) {
	i__ = 1;
    }
    if (iv[57] % 2 == 1 && abs(iv[15]) == 1) {
	i__ += 2;
    }
    iv[35] = pp + i__;
    i__ = dr1 + *n * pp;
    k = *p * (*p + 1) / 2;
    i1 = iv[42];
    v7cpy_(&k, &v[i__], &v[i1]);
    i__ += k;
    i__1 = pp * (pp + 1) / 2 - k;
    v7scp_(&i__1, &v[i__], &zero);
    ++iv[52];
    ++iv[6];
    iv[7] = iv[6];
    iv[55] = iv[1];
    iv[104] = -1;
    iv[1] = 1;
    ++iv[30];
    ++iv[53];
    goto L999;

/*  ***  FINISH COVARIANCE COMPUTATION  *** */

L240:
    i__ = dr1 + *n * *p;
    i__1 = *l;
    for (i1 = 1; i1 <= i__1; ++i1) {
	v7scl_(n, &v[i__], &negone, &a[i1 * a_dim1 + 1]);
	i__ += *n;
/* L250: */
    }
    pp = *l + *p;
    hsave = iv[56];
    k = dr1 + *n * pp;
    lh = pp * (pp + 1) / 2;
    if (abs(iv[15]) < 3) {
	goto L270;
    }
    i__ = iv[35] - 4;
    if (i__ >= pp) {
	goto L260;
    }
    v7scp_(&lh, &v[k], &zero);
    q7rad_(n, n, &pp, &v[1], &c_false, &v[k], &v[dr1], &v[1]);
    iv[35] = i__ + 8;
    iv[1] = 2;
    ++iv[30];
    ++iv[53];
    goto L160;

L260:
    iv[35] = i__;
    goto L300;

L270:
    pp1 = *p + 1;
    dri = dr1 + *n * *p;
    li = k + *p * pp1 / 2;
    i__1 = pp;
    for (i__ = pp1; i__ <= i__1; ++i__) {
	dri1 = dr1;
	i__2 = i__;
	for (i1 = 1; i1 <= i__2; ++i1) {
	    v[li] += d7tpr_(n, &v[dri], &v[dri1]);
	    ++li;
	    dri1 += *n;
/* L280: */
	}
	dri += *n;
/* L290: */
    }
    l7srt_(&pp1, &pp, &v[k], &v[k], &i__);
    if (i__ != 0) {
	goto L310;
    }
L300:
    temp1 = k + lh;
    t = l7svn_(&pp, &v[k], &v[temp1], &v[temp1]);
    if (t <= zero) {
	goto L310;
    }
    t /= l7svx_(&pp, &v[k], &v[temp1], &v[temp1]);
    v[53] = t;
    if (t > r7mdc_(&c__4)) {
	goto L320;
    }
L310:
    iv[67] = -1;
    iv[26] = -1;
    iv[74] = -1;
    goto L340;
L320:
    iv[56] = temp1;
    iv[74] = abs(hsave);
    if (iv[35] - pp < 2) {
	goto L330;
    }
    i__ = iv[56];
    v7scp_(&lh, &v[i__], &zero);
L330:
    n2lrd_(&v[dr1], &iv[1], &v[k], &lh, liv, lv, n, n, &pp, &v[r1], &v[rd1], &
	    v[1]);
L340:
    c7vfn_(&iv[1], &v[k], &lh, liv, lv, n, &pp, &v[1]);
    iv[56] = hsave;

L350:
    if (iv[67] == 1) {
	iv[67] = rd1;
    }
L360:
    if (iv[1] <= 11) {
	s7cpr_(&c__[1], &iv[1], l, liv);
    }
    if (iv[1] > 6) {
	goto L999;
    }
    i__1 = *p + *l;
    n2cvp_(&iv[1], liv, lv, &i__1, &v[1]);
    n2rdp_(&iv[1], liv, lv, n, &v[rd1], &v[1]);
    goto L999;

L370:
    iv[1] = 66;
    itsum_(&v[1], &v[1], &iv[1], liv, lv, p, &v[1], &alf[1]);

L999:
    return 0;

/*  ***  LAST CARD OF   RNSG FOLLOWS  *** */
} /* rnsg_ */

