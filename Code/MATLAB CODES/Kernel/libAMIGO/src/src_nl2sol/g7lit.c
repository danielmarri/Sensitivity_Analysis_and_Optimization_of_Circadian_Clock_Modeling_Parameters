/* g7lit.f -- translated by f2c (version 20100827).
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
static real c_b11 = 0.f;
static real c_b23 = -1.f;
static real c_b44 = 1.f;
static integer c__9 = 9;
static integer c__4 = 4;

/* Subroutine */ int g7lit_(real *d__, real *g, integer *iv, integer *liv, 
	integer *lv, integer *p, integer *ps, real *v, real *x, real *y)
{
    /* System generated locals */
    integer i__1, i__2;
    real r__1;

    /* Local variables */
    static real e;
    static integer i__, j, k, l;
    static real t;
    static integer h1, s1;
    static real t1;
    static integer w1, g01, x01, hc1, dig1, qtr1, pp1o2;
    extern doublereal r7mdc_(integer *);
    extern /* Subroutine */ int f7hes_(real *, real *, integer *, integer *, 
	    integer *, integer *, integer *, real *, real *);
    static integer lmat1, rmat1, temp1, ipiv1, temp2, step1;
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int a7sst_(integer *, integer *, integer *, real *
	    ), l7vml_(integer *, real *, real *, real *), v7scp_(integer *, 
	    real *, real *);
    extern doublereal v2nrm_(integer *, real *);
    extern /* Subroutine */ int g7qts_(real *, real *, real *, integer *, 
	    real *, integer *, real *, real *, real *), l7mst_(real *, real *,
	     integer *, integer *, integer *, integer *, real *, real *, real 
	    *, real *, real *), l7sqr_(integer *, real *, real *);
    extern doublereal l7svn_(integer *, real *, real *, real *);
    extern /* Subroutine */ int l7tvm_(integer *, real *, real *, real *), 
	    l7srt_(integer *, integer *, real *, real *, integer *), s7lup_(
	    real *, real *, integer *, real *, real *, real *, real *, real *,
	     real *, real *), s7lvm_(integer *, real *, real *, real *), 
	    v2axy_(integer *, real *, real *, real *, real *), v7cpy_(integer 
	    *, real *, real *);
    extern doublereal l7svx_(integer *, real *, real *, real *);
    extern /* Subroutine */ int parck_(integer *, real *, integer *, integer *
	    , integer *, integer *, real *);
    extern doublereal rldst_(integer *, real *, real *, real *);
    static integer dummy;
    extern /* Subroutine */ int itsum_(real *, real *, integer *, integer *, 
	    integer *, integer *, real *, real *);
    extern logical stopx_(integer *);
    static integer stpmod, lstgst, rstrst;
    static real sttsst;


/*  ***  CARRY OUT NL2SOL-LIKE ITERATIONS FOR GENERALIZED LINEAR   *** */
/*  ***  REGRESSION PROBLEMS (AND OTHERS OF SIMILAR STRUCTURE)     *** */

/*  ***  PARAMETER DECLARATIONS  *** */


/* --------------------------  PARAMETER USAGE  -------------------------- */

/* D.... SCALE VECTOR. */
/* IV... INTEGER VALUE ARRAY. */
/* LIV.. LENGTH OF IV.  MUST BE AT LEAST 82. */
/* LH... LENGTH OF H = P*(P+1)/2. */
/* LV... LENGTH OF V.  MUST BE AT LEAST P*(3*P + 19)/2 + 7. */
/* G.... GRADIENT AT X (WHEN IV(1) = 2). */
/* P.... NUMBER OF PARAMETERS (COMPONENTS IN X). */
/* PS... NUMBER OF NONZERO ROWS AND COLUMNS IN S. */
/* V.... FLOATING-POINT VALUE ARRAY. */
/* X.... PARAMETER VECTOR. */
/* Y.... PART OF YIELD VECTOR (WHEN IV(1)= 2, SCRATCH OTHERWISE). */

/*  ***  DISCUSSION  *** */

/*        G7LIT PERFORMS NL2SOL-LIKE ITERATIONS FOR A VARIETY OF */
/*     REGRESSION PROBLEMS THAT ARE SIMILAR TO NONLINEAR LEAST-SQUARES */
/*     IN THAT THE HESSIAN IS THE SUM OF TWO TERMS, A READILY-COMPUTED */
/*     FIRST-ORDER TERM AND A SECOND-ORDER TERM.  THE CALLER SUPPLIES */
/*     THE FIRST-ORDER TERM OF THE HESSIAN IN HC (LOWER TRIANGLE, STORED */
/*     COMPACTLY BY ROWS IN V, STARTING AT IV(HC)), AND G7LIT BUILDS AN */
/*     APPROXIMATION, S, TO THE SECOND-ORDER TERM.  THE CALLER ALSO */
/*     PROVIDES THE FUNCTION VALUE, GRADIENT, AND PART OF THE YIELD */
/*     VECTOR USED IN UPDATING S.  G7LIT DECIDES DYNAMICALLY WHETHER OR */
/*     NOT TO USE S WHEN CHOOSING THE NEXT STEP TO TRY...  THE HESSIAN */
/*     APPROXIMATION USED IS EITHER HC ALONE (GAUSS-NEWTON MODEL) OR */
/*     HC + S (AUGMENTED MODEL). */

/*        IF PS .LT. P, THEN ROWS AND COLUMNS PS+1...P OF S ARE KEPT */
/*     CONSTANT.  THEY WILL BE ZERO UNLESS THE CALLER SETS IV(INITS) TO */
/*     1 OR 2 AND SUPPLIES NONZERO VALUES FOR THEM, OR THE CALLER SETS */
/*     IV(INITS) TO 3 OR 4 AND THE FINITE-DIFFERENCE INITIAL S THEN */
/*     COMPUTED HAS NONZERO VALUES IN THESE ROWS. */

/*        IF IV(INITS) IS 3 OR 4, THEN THE INITIAL S IS COMPUTED BY */
/*     FINITE DIFFERENCES.  3 MEANS USE FUNCTION DIFFERENCES, 4 MEANS */
/*     USE GRADIENT DIFFERENCES.  FINITE DIFFERENCING IS DONE THE SAME */
/*     WAY AS IN COMPUTING A COVARIANCE MATRIX (WITH IV(COVREQ) = -1, -2, */
/*     1, OR 2). */

/*        FOR UPDATING S, G7LIT ASSUMES THAT THE GRADIENT HAS THE FORM */
/*     OF A SUM OVER I OF RHO(I,X)*GRAD(R(I,X)), WHERE GRAD DENOTES THE */
/*     GRADIENT WITH RESPECT TO X.  THE TRUE SECOND-ORDER TERM THEN IS */
/*     THE SUM OVER I OF RHO(I,X)*HESSIAN(R(I,X)).  IF X = X0 + STEP, */
/*     THEN WE WISH TO UPDATE S SO THAT S*STEP IS THE SUM OVER I OF */
/*     RHO(I,X)*(GRAD(R(I,X)) - GRAD(R(I,X0))).  THE CALLER MUST SUPPLY */
/*     PART OF THIS IN Y, NAMELY THE SUM OVER I OF */
/*     RHO(I,X)*GRAD(R(I,X0)), WHEN CALLING G7LIT WITH IV(1) = 2 AND */
/*     IV(MODE) = 0 (WHERE MODE = 38).  G THEN CONTANS THE OTHER PART, */
/*     SO THAT THE DESIRED YIELD VECTOR IS G - Y.  IF PS .LT. P, THEN */
/*     THE ABOVE DISCUSSION APPLIES ONLY TO THE FIRST PS COMPONENTS OF */
/*     GRAD(R(I,X)), STEP, AND Y. */

/*        PARAMETERS IV, P, V, AND X ARE THE SAME AS THE CORRESPONDING */
/*     ONES TO NL2SOL (WHICH SEE), EXCEPT THAT V CAN BE SHORTER */
/*     (SINCE THE PART OF V THAT NL2SOL USES FOR STORING D, J, AND R IS */
/*     NOT NEEDED).  MOREOVER, COMPARED WITH NL2SOL, IV(1) MAY HAVE THE */
/*     TWO ADDITIONAL OUTPUT VALUES 1 AND 2, WHICH ARE EXPLAINED BELOW, */
/*     AS IS THE USE OF IV(TOOBIG) AND IV(NFGCAL).  THE VALUES IV(D), */
/*     IV(J), AND IV(R), WHICH ARE OUTPUT VALUES FROM NL2SOL (AND */
/*     NL2SNO), ARE NOT REFERENCED BY G7LIT OR THE SUBROUTINES IT CALLS. */

/*        WHEN G7LIT IS FIRST CALLED, I.E., WHEN G7LIT IS CALLED WITH */
/*     IV(1) = 0 OR 12, V(F), G, AND HC NEED NOT BE INITIALIZED.  TO */
/*     OBTAIN THESE STARTING VALUES, G7LIT RETURNS FIRST WITH IV(1) = 1, */
/*     THEN WITH IV(1) = 2, WITH IV(MODE) = -1 IN BOTH CASES.  ON */
/*     SUBSEQUENT RETURNS WITH IV(1) = 2, IV(MODE) = 0 IMPLIES THAT */
/*     Y MUST ALSO BE SUPPLIED.  (NOTE THAT Y IS USED FOR SCRATCH -- ITS */
/*     INPUT CONTENTS ARE LOST.  BY CONTRAST, HC IS NEVER CHANGED.) */
/*     ONCE CONVERGENCE HAS BEEN OBTAINED, IV(RDREQ) AND IV(COVREQ) MAY */
/*     IMPLY THAT A FINITE-DIFFERENCE HESSIAN SHOULD BE COMPUTED FOR USE */
/*     IN COMPUTING A COVARIANCE MATRIX.  IN THIS CASE G7LIT WILL MAKE A */
/*     NUMBER OF RETURNS WITH IV(1) = 1 OR 2 AND IV(MODE) POSITIVE. */
/*     WHEN IV(MODE) IS POSITIVE, Y SHOULD NOT BE CHANGED. */

/* IV(1) = 1 MEANS THE CALLER SHOULD SET V(F) (I.E., V(10)) TO F(X), THE */
/*             FUNCTION VALUE AT X, AND CALL G7LIT AGAIN, HAVING CHANGED */
/*             NONE OF THE OTHER PARAMETERS.  AN EXCEPTION OCCURS IF F(X) */
/*             CANNOT BE EVALUATED (E.G. IF OVERFLOW WOULD OCCUR), WHICH */
/*             MAY HAPPEN BECAUSE OF AN OVERSIZED STEP.  IN THIS CASE */
/*             THE CALLER SHOULD SET IV(TOOBIG) = IV(2) TO 1, WHICH WILL */
/*             CAUSE G7LIT TO IGNORE V(F) AND TRY A SMALLER STEP.  NOTE */
/*             THAT THE CURRENT FUNCTION EVALUATION COUNT IS AVAILABLE */
/*             IN IV(NFCALL) = IV(6).  THIS MAY BE USED TO IDENTIFY */
/*             WHICH COPY OF SAVED INFORMATION SHOULD BE USED IN COM- */
/*             PUTING G, HC, AND Y THE NEXT TIME G7LIT RETURNS WITH */
/*             IV(1) = 2.  SEE MLPIT FOR AN EXAMPLE OF THIS. */
/* IV(1) = 2 MEANS THE CALLER SHOULD SET G TO G(X), THE GRADIENT OF F AT */
/*             X.  THE CALLER SHOULD ALSO SET HC TO THE GAUSS-NEWTON */
/*             HESSIAN AT X.  IF IV(MODE) = 0, THEN THE CALLER SHOULD */
/*             ALSO COMPUTE THE PART OF THE YIELD VECTOR DESCRIBED ABOVE. */
/*             THE CALLER SHOULD THEN CALL G7LIT AGAIN (WITH IV(1) = 2). */
/*             THE CALLER MAY ALSO CHANGE D AT THIS TIME, BUT SHOULD NOT */
/*             CHANGE X.  NOTE THAT IV(NFGCAL) = IV(7) CONTAINS THE */
/*             VALUE THAT IV(NFCALL) HAD DURING THE RETURN WITH */
/*             IV(1) = 1 IN WHICH X HAD THE SAME VALUE AS IT NOW HAS. */
/*             IV(NFGCAL) IS EITHER IV(NFCALL) OR IV(NFCALL) - 1.  MLPIT */
/*             IS AN EXAMPLE WHERE THIS INFORMATION IS USED.  IF G OR HC */
/*             CANNOT BE EVALUATED AT X, THEN THE CALLER MAY SET */
/*             IV(TOOBIG) TO 1, IN WHICH CASE G7LIT WILL RETURN WITH */
/*             IV(1) = 15. */

/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY. */
/*     THIS SUBROUTINE WAS WRITTEN IN CONNECTION WITH RESEARCH */
/*     SUPPORTED IN PART BY D.O.E. GRANT EX-76-A-01-2295 TO MIT/CCREMS. */

/*        (SEE NL2SOL FOR REFERENCES.) */

/* +++++++++++++++++++++++++++  DECLARATIONS  ++++++++++++++++++++++++++++ */

/*  ***  LOCAL VARIABLES  *** */


/*     ***  CONSTANTS  *** */


/*  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  *** */


/* A7SST.... ASSESSES CANDIDATE STEP. */
/*  D7TPR... RETURNS INNER PRODUCT OF TWO VECTORS. */
/* F7HES.... COMPUTE FINITE-DIFFERENCE HESSIAN (FOR COVARIANCE). */
/* G7QTS.... COMPUTES GOLDFELD-QUANDT-TROTTER STEP (AUGMENTED MODEL). */
/* ITSUM.... PRINTS ITERATION SUMMARY AND INFO ON INITIAL AND FINAL X. */
/*  L7MST... COMPUTES LEVENBERG-MARQUARDT STEP (GAUSS-NEWTON MODEL). */
/* L7SRT.... COMPUTES CHOLESKY FACTOR OF (LOWER TRIANG. OF) SYM. MATRIX. */
/*  L7SQR... COMPUTES L * L**T FROM LOWER TRIANGULAR MATRIX L. */
/*  L7TVM... COMPUTES L**T * V, V = VECTOR, L = LOWER TRIANGULAR MATRIX. */
/*  L7SVX... ESTIMATES LARGEST SING. VALUE OF LOWER TRIANG. MATRIX. */
/*  L7SVN... ESTIMATES SMALLEST SING. VALUE OF LOWER TRIANG. MATRIX. */
/* L7VML.... COMPUTES L * V, V = VECTOR, L = LOWER TRIANGULAR MATRIX. */
/* PARCK.... CHECK VALIDITY OF IV AND V INPUT COMPONENTS. */
/*  RLDST... COMPUTES V(RELDX) = RELATIVE STEP SIZE. */
/*  R7MDC... RETURNS MACHINE-DEPENDENT CONSTANTS. */
/*  S7LUP... PERFORMS QUASI-NEWTON UPDATE ON COMPACTLY STORED LOWER TRI- */
/*             ANGLE OF A SYMMETRIC MATRIX. */
/* STOPX.... RETURNS .TRUE. IF THE BREAK KEY HAS BEEN PRESSED. */
/* V2AXY.... COMPUTES SCALAR TIMES ONE VECTOR PLUS ANOTHER. */
/* V7CPY.... COPIES ONE VECTOR TO ANOTHER. */
/*  V7SCP... SETS ALL ELEMENTS OF A VECTOR TO A SCALAR. */
/*  V2NRM... RETURNS THE 2-NORM OF A VECTOR. */

/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA CNVCOD/55/, COVMAT/26/, COVREQ/15/, DIG/37/, FDH/74/, H/56/, */
/*    1     HC/71/, IERR/75/, INITS/25/, IPIVOT/76/, IRC/29/, KAGQT/33/, */
/*    2     KALM/34/, LMAT/42/, MODE/35/, MODEL/5/, MXFCAL/17/, */
/*    3     MXITER/18/, NEXTV/47/, NFCALL/6/, NFGCAL/7/, NFCOV/52/, */
/*    4     NGCOV/53/, NGCALL/30/, NITER/31/, QTR/77/, RADINC/8/, */
/*    5     RDREQ/57/, REGD/67/, RESTOR/9/, RMAT/78/, S/62/, STEP/40/, */
/*    6     STGLIM/11/, STLSTG/41/, SUSED/64/, SWITCH/12/, TOOBIG/2/, */
/*    7     VNEED/4/, VSAVE/60/, W/65/, XIRC/13/, X0/43/ */
/* /7 */
/* / */

/*  ***  V SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA COSMIN/47/, DGNORM/1/, DSTNRM/2/, F/10/, FDIF/11/, FUZZ/45/, */
/*    1     F0/13/, GTSTEP/4/, INCFAC/23/, LMAX0/35/, LMAXS/36/, */
/*    2     NVSAVE/9/, PHMXFC/21/, PREDUC/7/, RADFAC/16/, RADIUS/8/, */
/*    3     RAD0/9/, RCOND/53/, RELDX/17/, SIZE/55/, STPPAR/5/, */
/*    4     TUNER4/29/, TUNER5/30/, WSCALE/56/ */
/* /7 */
/* / */


/* /6 */
/*     DATA HALF/0.5E+0/, NEGONE/-1.E+0/, ONE/1.E+0/, ONEP2/1.2E+0/, */
/*    1     ZERO/0.E+0/ */
/* /7 */
/* / */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    /* Parameter adjustments */
    --iv;
    --v;
    --y;
    --x;
    --g;
    --d__;

    /* Function Body */
    i__ = iv[1];
    if (i__ == 1) {
	goto L40;
    }
    if (i__ == 2) {
	goto L50;
    }

    if (i__ == 12 || i__ == 13) {
	iv[4] = iv[4] + *p * (*p * 3 + 19) / 2 + 7;
    }
    parck_(&c__1, &d__[1], &iv[1], liv, lv, p, &v[1]);
    i__ = iv[1] - 2;
    if (i__ > 12) {
	goto L999;
    }
    switch (i__) {
	case 1:  goto L290;
	case 2:  goto L290;
	case 3:  goto L290;
	case 4:  goto L290;
	case 5:  goto L290;
	case 6:  goto L290;
	case 7:  goto L170;
	case 8:  goto L120;
	case 9:  goto L170;
	case 10:  goto L10;
	case 11:  goto L10;
	case 12:  goto L20;
    }

/*  ***  STORAGE ALLOCATION  *** */

L10:
    pp1o2 = *p * (*p + 1) / 2;
    iv[62] = iv[42] + pp1o2;
    iv[43] = iv[62] + pp1o2;
    iv[40] = iv[43] + *p;
    iv[41] = iv[40] + *p;
    iv[37] = iv[41] + *p;
    iv[65] = iv[37] + *p;
    iv[56] = iv[65] + (*p << 2) + 7;
    iv[47] = iv[56] + pp1o2;
    if (iv[1] != 13) {
	goto L20;
    }
    iv[1] = 14;
    goto L999;

/*  ***  INITIALIZATION  *** */

L20:
    iv[31] = 0;
    iv[6] = 1;
    iv[30] = 1;
    iv[7] = 1;
    iv[35] = -1;
    iv[11] = 2;
    iv[2] = 0;
    iv[55] = 0;
    iv[26] = 0;
    iv[52] = 0;
    iv[53] = 0;
    iv[8] = 0;
    iv[9] = 0;
    iv[74] = 0;
    v[9] = 0.f;
    v[5] = 0.f;
    v[8] = v[35] / (v[21] + 1.f);

/*  ***  SET INITIAL MODEL AND S MATRIX  *** */

    iv[5] = 1;
    if (iv[62] < 0) {
	goto L999;
    }
    if (iv[25] > 1) {
	iv[5] = 2;
    }
    s1 = iv[62];
    if (iv[25] == 0 || iv[25] > 2) {
	i__1 = *p * (*p + 1) / 2;
	v7scp_(&i__1, &v[s1], &c_b11);
    }
    iv[1] = 1;
    j = iv[76];
    if (j <= 0) {
	goto L999;
    }
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	iv[j] = i__;
	++j;
/* L30: */
    }
    goto L999;

/*  ***  NEW FUNCTION VALUE  *** */

L40:
    if (iv[35] == 0) {
	goto L290;
    }
    if (iv[35] > 0) {
	goto L520;
    }

    iv[1] = 2;
    if (iv[2] == 0) {
	goto L999;
    }
    iv[1] = 63;
    goto L999;

/*  ***  NEW GRADIENT  *** */

L50:
    iv[34] = -1;
    iv[33] = -1;
    iv[74] = 0;
    if (iv[35] > 0) {
	goto L520;
    }

/*  ***  MAKE SURE GRADIENT COULD BE COMPUTED  *** */

    if (iv[2] == 0) {
	goto L60;
    }
    iv[1] = 65;
    goto L999;
L60:
    if (iv[71] <= 0 && iv[78] <= 0) {
	goto L610;
    }

/*  ***  COMPUTE  D**-1 * GRADIENT  *** */

    dig1 = iv[37];
    k = dig1;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[k] = g[i__] / d__[i__];
	++k;
/* L70: */
    }
    v[1] = v2nrm_(p, &v[dig1]);

    if (iv[55] != 0) {
	goto L510;
    }
    if (iv[35] == 0) {
	goto L440;
    }
    iv[35] = 0;
    v[13] = v[10];
    if (iv[25] <= 2) {
	goto L100;
    }

/*  ***  ARRANGE FOR FINITE-DIFFERENCE INITIAL S  *** */

    iv[13] = iv[15];
    iv[15] = -1;
    if (iv[25] > 3) {
	iv[15] = 1;
    }
    iv[55] = 70;
    goto L530;

/*  ***  COME TO NEXT STMT AFTER COMPUTING F.D. HESSIAN FOR INIT. S  *** */

L80:
    iv[55] = 0;
    iv[35] = 0;
    iv[52] = 0;
    iv[53] = 0;
    iv[15] = iv[13];
    s1 = iv[62];
    pp1o2 = *ps * (*ps + 1) / 2;
    hc1 = iv[71];
    if (hc1 <= 0) {
	goto L90;
    }
    v2axy_(&pp1o2, &v[s1], &c_b23, &v[hc1], &v[h1]);
    goto L100;
L90:
    rmat1 = iv[78];
    l7sqr_(ps, &v[s1], &v[rmat1]);
    v2axy_(&pp1o2, &v[s1], &c_b23, &v[s1], &v[h1]);
L100:
    iv[1] = 2;


/* -----------------------------  MAIN LOOP  ----------------------------- */


/*  ***  PRINT ITERATION SUMMARY, CHECK ITERATION LIMIT  *** */

L110:
    itsum_(&d__[1], &g[1], &iv[1], liv, lv, p, &v[1], &x[1]);
L120:
    k = iv[31];
    if (k < iv[18]) {
	goto L130;
    }
    iv[1] = 10;
    goto L999;
L130:
    iv[31] = k + 1;

/*  ***  UPDATE RADIUS  *** */

    if (k == 0) {
	goto L150;
    }
    step1 = iv[40];
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[step1] = d__[i__] * v[step1];
	++step1;
/* L140: */
    }
    step1 = iv[40];
    t = v[16] * v2nrm_(p, &v[step1]);
    if (v[16] < 1.f || t > v[8]) {
	v[8] = t;
    }

/*  ***  INITIALIZE FOR START OF NEXT ITERATION  *** */

L150:
    x01 = iv[43];
    v[13] = v[10];
    iv[29] = 4;
    iv[56] = -abs(iv[56]);
    iv[64] = iv[5];

/*     ***  COPY X TO X0  *** */

    v7cpy_(p, &v[x01], &x[1]);

/*  ***  CHECK STOPX AND FUNCTION EVALUATION LIMIT  *** */

L160:
    if (! stopx_(&dummy)) {
	goto L180;
    }
    iv[1] = 11;
    goto L190;

/*     ***  COME HERE WHEN RESTARTING AFTER FUNC. EVAL. LIMIT OR STOPX. */

L170:
    if (v[10] >= v[13]) {
	goto L180;
    }
    v[16] = 1.f;
    k = iv[31];
    goto L130;

L180:
    if (iv[6] < iv[17] + iv[52]) {
	goto L200;
    }
    iv[1] = 9;
L190:
    if (v[10] >= v[13]) {
	goto L999;
    }

/*        ***  IN CASE OF STOPX OR FUNCTION EVALUATION LIMIT WITH */
/*        ***  IMPROVED V(F), EVALUATE THE GRADIENT AT X. */

    iv[55] = iv[1];
    goto L430;

/* . . . . . . . . . . . . .  COMPUTE CANDIDATE STEP  . . . . . . . . . . */

L200:
    step1 = iv[40];
    w1 = iv[65];
    h1 = iv[56];
    t1 = 1.f;
    if (iv[5] == 2) {
	goto L210;
    }
    t1 = 0.f;

/*        ***  COMPUTE LEVENBERG-MARQUARDT STEP IF POSSIBLE... */

    rmat1 = iv[78];
    if (rmat1 <= 0) {
	goto L210;
    }
    qtr1 = iv[77];
    if (qtr1 <= 0) {
	goto L210;
    }
    ipiv1 = iv[76];
    l7mst_(&d__[1], &g[1], &iv[75], &iv[ipiv1], &iv[34], p, &v[qtr1], &v[
	    rmat1], &v[step1], &v[1], &v[w1]);
/*        *** H IS STORED IN THE END OF W AND HAS JUST BEEN OVERWRITTEN, */
/*        *** SO WE MARK IT INVALID... */
    iv[56] = -abs(h1);
/*        *** EVEN IF H WERE STORED ELSEWHERE, IT WOULD BE NECESSARY TO */
/*        *** MARK INVALID THE INFORMATION G7QTS MAY HAVE STORED IN V... */
    iv[33] = -1;
    goto L260;

L210:
    if (h1 > 0) {
	goto L250;
    }

/*     ***  SET H TO  D**-1 * (HC + T1*S) * D**-1.  *** */

    h1 = -h1;
    iv[56] = h1;
    iv[74] = 0;
    j = iv[71];
    if (j > 0) {
	goto L220;
    }
    j = h1;
    rmat1 = iv[78];
    l7sqr_(p, &v[h1], &v[rmat1]);
L220:
    s1 = iv[62];
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	t = 1.f / d__[i__];
	i__2 = i__;
	for (k = 1; k <= i__2; ++k) {
	    v[h1] = t * (v[j] + t1 * v[s1]) / d__[k];
	    ++j;
	    ++h1;
	    ++s1;
/* L230: */
	}
/* L240: */
    }
    h1 = iv[56];
    iv[33] = -1;

/*  ***  COMPUTE ACTUAL GOLDFELD-QUANDT-TROTTER STEP  *** */

L250:
    dig1 = iv[37];
    lmat1 = iv[42];
    g7qts_(&d__[1], &v[dig1], &v[h1], &iv[33], &v[lmat1], p, &v[step1], &v[1],
	     &v[w1]);
    if (iv[34] > 0) {
	iv[34] = 0;
    }

L260:
    if (iv[29] != 6) {
	goto L270;
    }
    if (iv[9] != 2) {
	goto L290;
    }
    rstrst = 2;
    goto L300;

/*  ***  CHECK WHETHER EVALUATING F(X0 + STEP) LOOKS WORTHWHILE  *** */

L270:
    iv[2] = 0;
    if (v[2] <= 0.f) {
	goto L290;
    }
    if (iv[29] != 5) {
	goto L280;
    }
    if (v[16] <= 1.f) {
	goto L280;
    }
    if (v[7] > v[11] * 1.2f) {
	goto L280;
    }
    step1 = iv[40];
    x01 = iv[43];
    v2axy_(p, &v[step1], &c_b23, &v[x01], &x[1]);
    if (iv[9] != 2) {
	goto L290;
    }
    rstrst = 0;
    goto L300;

/*  ***  COMPUTE F(X0 + STEP)  *** */

L280:
    x01 = iv[43];
    step1 = iv[40];
    v2axy_(p, &x[1], &c_b44, &v[step1], &v[x01]);
    ++iv[6];
    iv[1] = 1;
    goto L999;

/* . . . . . . . . . . . . .  ASSESS CANDIDATE STEP  . . . . . . . . . . . */

L290:
    rstrst = 3;
L300:
    x01 = iv[43];
    v[17] = rldst_(p, &d__[1], &x[1], &v[x01]);
    a7sst_(&iv[1], liv, lv, &v[1]);
    step1 = iv[40];
    lstgst = iv[41];
    i__ = iv[9] + 1;
    switch (i__) {
	case 1:  goto L340;
	case 2:  goto L310;
	case 3:  goto L320;
	case 4:  goto L330;
    }
L310:
    v7cpy_(p, &x[1], &v[x01]);
    goto L340;
L320:
    v7cpy_(p, &v[lstgst], &v[step1]);
    goto L340;
L330:
    v7cpy_(p, &v[step1], &v[lstgst]);
    v2axy_(p, &x[1], &c_b44, &v[step1], &v[x01]);
    v[17] = rldst_(p, &d__[1], &x[1], &v[x01]);
    iv[9] = rstrst;

/*  ***  IF NECESSARY, SWITCH MODELS  *** */

L340:
    if (iv[12] == 0) {
	goto L350;
    }
    iv[56] = -abs(iv[56]);
    iv[64] += 2;
    l = iv[60];
    v7cpy_(&c__9, &v[1], &v[l]);
L350:
    l = iv[29] - 4;
    stpmod = iv[5];
    if (l > 0) {
	switch (l) {
	    case 1:  goto L370;
	    case 2:  goto L380;
	    case 3:  goto L390;
	    case 4:  goto L390;
	    case 5:  goto L390;
	    case 6:  goto L390;
	    case 7:  goto L390;
	    case 8:  goto L390;
	    case 9:  goto L500;
	    case 10:  goto L440;
	}
    }

/*  ***  DECIDE WHETHER TO CHANGE MODELS  *** */

    e = v[7] - v[11];
    s1 = iv[62];
    s7lvm_(ps, &y[1], &v[s1], &v[step1]);
    sttsst = d7tpr_(ps, &v[step1], &y[1]) * .5f;
    if (iv[5] == 1) {
	sttsst = -sttsst;
    }
    if ((r__1 = e + sttsst, dabs(r__1)) * v[45] >= dabs(e)) {
	goto L360;
    }

/*     ***  SWITCH MODELS  *** */

    iv[5] = 3 - iv[5];
    if (-2 < l) {
	goto L400;
    }
    iv[56] = -abs(iv[56]);
    iv[64] += 2;
    l = iv[60];
    v7cpy_(&c__9, &v[l], &v[1]);
    goto L160;

L360:
    if (-3 < l) {
	goto L400;
    }

/*  ***  RECOMPUTE STEP WITH NEW RADIUS  *** */

L370:
    v[8] = v[16] * v[2];
    goto L160;

/*  ***  COMPUTE STEP OF LENGTH V(LMAXS) FOR SINGULAR CONVERGENCE TEST */

L380:
    v[8] = v[36];
    goto L200;

/*  ***  CONVERGENCE OR FALSE CONVERGENCE  *** */

L390:
    iv[55] = l;
    if (v[10] >= v[13]) {
	goto L510;
    }
    if (iv[13] == 14) {
	goto L510;
    }
    iv[13] = 14;

/* . . . . . . . . . . . .  PROCESS ACCEPTABLE STEP  . . . . . . . . . . . */

L400:
    iv[26] = 0;
    iv[67] = 0;

/*  ***  SEE WHETHER TO SET V(RADFAC) BY GRADIENT TESTS  *** */

    if (iv[29] != 3) {
	goto L430;
    }
    step1 = iv[40];
    temp1 = iv[41];
    temp2 = iv[65];

/*     ***  SET  TEMP1 = HESSIAN * STEP  FOR USE IN GRADIENT TESTS  *** */

    hc1 = iv[71];
    if (hc1 <= 0) {
	goto L410;
    }
    s7lvm_(p, &v[temp1], &v[hc1], &v[step1]);
    goto L420;
L410:
    rmat1 = iv[78];
    l7tvm_(p, &v[temp1], &v[rmat1], &v[step1]);
    l7vml_(p, &v[temp1], &v[rmat1], &v[temp1]);

L420:
    if (stpmod == 1) {
	goto L430;
    }
    s1 = iv[62];
    s7lvm_(ps, &v[temp2], &v[s1], &v[step1]);
    v2axy_(ps, &v[temp1], &c_b44, &v[temp2], &v[temp1]);

/*  ***  SAVE OLD GRADIENT AND COMPUTE NEW ONE  *** */

L430:
    ++iv[30];
    g01 = iv[65];
    v7cpy_(p, &v[g01], &g[1]);
    iv[1] = 2;
    iv[2] = 0;
    goto L999;

/*  ***  INITIALIZATIONS -- G0 = G - G0, ETC.  *** */

L440:
    g01 = iv[65];
    v2axy_(p, &v[g01], &c_b23, &v[g01], &g[1]);
    step1 = iv[40];
    temp1 = iv[41];
    temp2 = iv[65];
    if (iv[29] != 3) {
	goto L470;
    }

/*  ***  SET V(RADFAC) BY GRADIENT TESTS  *** */

/*     ***  SET  TEMP1 = D**-1 * (HESSIAN * STEP  +  (G(X0) - G(X)))  *** */

    k = temp1;
    l = g01;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[k] = (v[k] - v[l]) / d__[i__];
	++k;
	++l;
/* L450: */
    }

/*        ***  DO GRADIENT TESTS  *** */

    if (v2nrm_(p, &v[temp1]) <= v[1] * v[29]) {
	goto L460;
    }
    if (d7tpr_(p, &g[1], &v[step1]) >= v[4] * v[30]) {
	goto L470;
    }
L460:
    v[16] = v[23];

/*  ***  COMPUTE Y VECTOR NEEDED FOR UPDATING S  *** */

L470:
    v2axy_(ps, &y[1], &c_b23, &y[1], &g[1]);

/*  ***  DETERMINE SIZING FACTOR V(SIZE)  *** */

/*     ***  SET TEMP1 = S * STEP  *** */
    s1 = iv[62];
    s7lvm_(ps, &v[temp1], &v[s1], &v[step1]);

    t1 = (r__1 = d7tpr_(ps, &v[step1], &v[temp1]), dabs(r__1));
    t = (r__1 = d7tpr_(ps, &v[step1], &y[1]), dabs(r__1));
    v[55] = 1.f;
    if (t < t1) {
	v[55] = t / t1;
    }

/*  ***  SET G0 TO WCHMTD CHOICE OF FLETCHER AND AL-BAALI  *** */

    hc1 = iv[71];
    if (hc1 <= 0) {
	goto L480;
    }
    s7lvm_(ps, &v[g01], &v[hc1], &v[step1]);
    goto L490;

L480:
    rmat1 = iv[78];
    l7tvm_(ps, &v[g01], &v[rmat1], &v[step1]);
    l7vml_(ps, &v[g01], &v[rmat1], &v[g01]);

L490:
    v2axy_(ps, &v[g01], &c_b44, &y[1], &v[g01]);

/*  ***  UPDATE S  *** */

    s7lup_(&v[s1], &v[47], ps, &v[55], &v[step1], &v[temp1], &v[temp2], &v[
	    g01], &v[56], &y[1]);
    iv[1] = 2;
    goto L110;

/* . . . . . . . . . . . . . .  MISC. DETAILS  . . . . . . . . . . . . . . */

/*  ***  BAD PARAMETERS TO ASSESS  *** */

L500:
    iv[1] = 64;
    goto L999;


/*  ***  CONVERGENCE OBTAINED -- SEE WHETHER TO COMPUTE COVARIANCE  *** */

L510:
    if (iv[57] == 0) {
	goto L600;
    }
    if (iv[74] != 0) {
	goto L600;
    }
    if (iv[55] >= 7) {
	goto L600;
    }
    if (iv[67] > 0) {
	goto L600;
    }
    if (iv[26] > 0) {
	goto L600;
    }
    if (abs(iv[15]) >= 3) {
	goto L560;
    }
    if (iv[9] == 0) {
	iv[9] = 2;
    }
    goto L530;

/*  ***  COMPUTE FINITE-DIFFERENCE HESSIAN FOR COMPUTING COVARIANCE  *** */

L520:
    iv[9] = 0;
L530:
    f7hes_(&d__[1], &g[1], &i__, &iv[1], liv, lv, p, &v[1], &x[1]);
    switch (i__) {
	case 1:  goto L540;
	case 2:  goto L550;
	case 3:  goto L580;
    }
L540:
    ++iv[52];
    ++iv[6];
    iv[1] = 1;
    goto L999;

L550:
    ++iv[53];
    ++iv[30];
    iv[7] = iv[6] + iv[53];
    iv[1] = 2;
    goto L999;

L560:
    h1 = abs(iv[56]);
    iv[56] = -h1;
    pp1o2 = *p * (*p + 1) / 2;
    rmat1 = iv[78];
    if (rmat1 <= 0) {
	goto L570;
    }
    lmat1 = iv[42];
    v7cpy_(&pp1o2, &v[lmat1], &v[rmat1]);
    v[53] = 0.f;
    goto L590;
L570:
    hc1 = iv[71];
    iv[74] = h1;
    i__1 = *p * (*p + 1) / 2;
    v7cpy_(&i__1, &v[h1], &v[hc1]);

/*  ***  COMPUTE CHOLESKY FACTOR OF FINITE-DIFFERENCE HESSIAN */
/*  ***  FOR USE IN CALLER*S COVARIANCE CALCULATION... */

L580:
    lmat1 = iv[42];
    h1 = iv[74];
    if (h1 <= 0) {
	goto L600;
    }
    if (iv[55] == 70) {
	goto L80;
    }
    l7srt_(&c__1, p, &v[lmat1], &v[h1], &i__);
    iv[74] = -1;
    v[53] = 0.f;
    if (i__ != 0) {
	goto L600;
    }

L590:
    iv[74] = -1;
    step1 = iv[40];
    t = l7svn_(p, &v[lmat1], &v[step1], &v[step1]);
    if (t <= 0.f) {
	goto L600;
    }
    t /= l7svx_(p, &v[lmat1], &v[step1], &v[step1]);
    if (t > r7mdc_(&c__4)) {
	iv[74] = h1;
    }
    v[53] = t;

L600:
    iv[35] = 0;
    iv[1] = iv[55];
    iv[55] = 0;
    goto L999;

/*  ***  SPECIAL RETURN FOR MISSING HESSIAN INFORMATION -- BOTH */
/*  ***  IV(HC) .LE. 0 AND IV(RMAT) .LE. 0 */

L610:
    iv[1] = 1400;

L999:
    return 0;

/*  ***  LAST LINE OF G7LIT FOLLOWS  *** */
} /* g7lit_ */

