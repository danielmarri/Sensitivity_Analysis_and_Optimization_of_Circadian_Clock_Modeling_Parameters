/* g7itb.f -- translated by f2c (version 20100827).
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
static real c_b15 = 0.f;
static integer c_n1 = -1;
static real c_b32 = -1.f;
static real c_b53 = 1.f;
static integer c__9 = 9;

/* Subroutine */ int g7itb_(real *b, real *d__, real *g, integer *iv, integer 
	*liv, integer *lv, integer *p, integer *ps, real *v, real *x, real *y)
{
    /* System generated locals */
    integer i__1, i__2;
    real r__1;

    /* Local variables */
    static real e;
    static integer i__, j, k, l;
    static real t;
    static integer h1, i1, p1, s1;
    static real t1;
    static integer w1, g01;
    static real gi;
    static integer x01;
    static real xi;
    static integer hc1, td1, tg1, pp1, ipi, ipn, dig1, wlm1, qtr1, pp1o2;
    extern /* Subroutine */ int f7dhb_(real *, real *, real *, integer *, 
	    integer *, integer *, integer *, integer *, real *, real *);
    static integer lmat1, p1len, rmat1;
    extern /* Subroutine */ int g7qsb_(real *, real *, real *, real *, 
	    integer *, integer *, integer *, integer *, real *, integer *, 
	    integer *, integer *, integer *, real *, real *, real *, real *, 
	    real *, real *, real *);
    static integer temp1, ipiv0, ipiv1, ipiv2, temp2;
    extern /* Subroutine */ int l7msb_(real *, real *, real *, integer *, 
	    integer *, integer *, integer *, integer *, real *, integer *, 
	    integer *, integer *, integer *, real *, real *, real *, real *, 
	    real *, real *, real *, real *, real *, real *);
    static integer step1;
    extern /* Subroutine */ int s7dmp_(integer *, real *, real *, real *, 
	    integer *);
    extern doublereal d7tpr_(integer *, real *, real *);
    extern /* Subroutine */ int a7sst_(integer *, integer *, integer *, real *
	    ), l7vml_(integer *, real *, real *, real *), v7scp_(integer *, 
	    real *, real *);
    extern doublereal v2nrm_(integer *, real *);
    extern /* Subroutine */ int q7rsh_(integer *, integer *, logical *, real *
	    , real *, real *), s7ipr_(integer *, integer *, real *), v7ipr_(
	    integer *, integer *, real *), l7sqr_(integer *, real *, real *), 
	    l7tvm_(integer *, real *, real *, real *), s7lup_(real *, real *, 
	    integer *, real *, real *, real *, real *, real *, real *, real *)
	    , s7lvm_(integer *, real *, real *, real *), v2axy_(integer *, 
	    real *, real *, real *, real *), v7cpy_(integer *, real *, real *)
	    , v7vmp_(integer *, real *, real *, real *, integer *), parck_(
	    integer *, real *, integer *, integer *, integer *, integer *, 
	    real *);
    static logical havrm;
    extern doublereal rldst_(integer *, real *, real *, real *);
    static integer dummy;
    extern /* Subroutine */ int itsum_(real *, real *, integer *, integer *, 
	    integer *, integer *, real *, real *);
    extern logical stopx_(integer *);
    extern /* Subroutine */ int i7shft_(integer *, integer *, integer *), 
	    i7copy_(integer *, integer *, integer *), i7pnvr_(integer *, 
	    integer *, integer *);
    static logical havqtr;
    static integer stpmod, lstgst, rstrst;
    static real sttsst;


/*  ***  CARRY OUT NL2SOL-LIKE ITERATIONS FOR GENERALIZED LINEAR   *** */
/*  ***  REGRESSION PROBLEMS (AND OTHERS OF SIMILAR STRUCTURE)     *** */
/*  ***  HAVING SIMPLE BOUNDS ON THE PARAMETERS BEING ESTIMATED.   *** */

/*  ***  PARAMETER DECLARATIONS  *** */


/* --------------------------  PARAMETER USAGE  -------------------------- */

/* B.... VECTOR OF LOWER AND UPPER BOUNDS ON X. */
/* D.... SCALE VECTOR. */
/* IV... INTEGER VALUE ARRAY. */
/* LIV.. LENGTH OF IV.  MUST BE AT LEAST 80. */
/* LH... LENGTH OF H = P*(P+1)/2. */
/* LV... LENGTH OF V.  MUST BE AT LEAST P*(3*P + 19)/2 + 7. */
/* G.... GRADIENT AT X (WHEN IV(1) = 2). */
/* HC... GAUSS-NEWTON HESSIAN AT X (WHEN IV(1) = 2). */
/* P.... NUMBER OF PARAMETERS (COMPONENTS IN X). */
/* PS... NUMBER OF NONZERO ROWS AND COLUMNS IN S. */
/* V.... FLOATING-POINT VALUE ARRAY. */
/* X.... PARAMETER VECTOR. */
/* Y.... PART OF YIELD VECTOR (WHEN IV(1)= 2, SCRATCH OTHERWISE). */

/*  ***  DISCUSSION  *** */

/*         G7ITB IS SIMILAR TO G7LIT, EXCEPT FOR THE EXTRA PARAMETER B */
/*     --  G7ITB ENFORCES THE BOUNDS  B(1,I) .LE. X(I) .LE. B(2,I), */
/*     I = 1(1)P. */
/*         G7ITB PERFORMS NL2SOL-LIKE ITERATIONS FOR A VARIETY OF */
/*     REGRESSION PROBLEMS THAT ARE SIMILAR TO NONLINEAR LEAST-SQUARES */
/*     IN THAT THE HESSIAN IS THE SUM OF TWO TERMS, A READILY-COMPUTED */
/*     FIRST-ORDER TERM AND A SECOND-ORDER TERM.  THE CALLER SUPPLIES */
/*     THE FIRST-ORDER TERM OF THE HESSIAN IN HC (LOWER TRIANGLE, STORED */
/*     COMPACTLY BY ROWS), AND  G7ITB BUILDS AN APPROXIMATION, S, TO THE */
/*     SECOND-ORDER TERM.  THE CALLER ALSO PROVIDES THE FUNCTION VALUE, */
/*     GRADIENT, AND PART OF THE YIELD VECTOR USED IN UPDATING S. */
/*      G7ITB DECIDES DYNAMICALLY WHETHER OR NOT TO USE S WHEN CHOOSING */
/*     THE NEXT STEP TO TRY...  THE HESSIAN APPROXIMATION USED IS EITHER */
/*     HC ALONE (GAUSS-NEWTON MODEL) OR HC + S (AUGMENTED MODEL). */
/*     IF PS .LT. P, THEN ROWS AND COLUMNS PS+1...P OF S ARE KEPT */
/*     CONSTANT.  THEY WILL BE ZERO UNLESS THE CALLER SETS IV(INITS) TO */
/*     1 OR 2 AND SUPPLIES NONZERO VALUES FOR THEM, OR THE CALLER SETS */
/*     IV(INITS) TO 3 OR 4 AND THE FINITE-DIFFERENCE INITIAL S THEN */
/*     COMPUTED HAS NONZERO VALUES IN THESE ROWS. */

/*        IF IV(INITS) IS 3 OR 4, THEN THE INITIAL S IS COMPUTED BY */
/*     FINITE DIFFERENCES.  3 MEANS USE FUNCTION DIFFERENCES, 4 MEANS */
/*     USE GRADIENT DIFFERENCES.  FINITE DIFFERENCING IS DONE THE SAME */
/*     WAY AS IN COMPUTING A COVARIANCE MATRIX (WITH IV(COVREQ) = -1, -2, */
/*     1, OR 2). */

/*        FOR UPDATING S,  G7ITB ASSUMES THAT THE GRADIENT HAS THE FORM */
/*     OF A SUM OVER I OF RHO(I,X)*GRAD(R(I,X)), WHERE GRAD DENOTES THE */
/*     GRADIENT WITH RESPECT TO X.  THE TRUE SECOND-ORDER TERM THEN IS */
/*     THE SUM OVER I OF RHO(I,X)*HESSIAN(R(I,X)).  IF X = X0 + STEP, */
/*     THEN WE WISH TO UPDATE S SO THAT S*STEP IS THE SUM OVER I OF */
/*     RHO(I,X)*(GRAD(R(I,X)) - GRAD(R(I,X0))).  THE CALLER MUST SUPPLY */
/*     PART OF THIS IN Y, NAMELY THE SUM OVER I OF */
/*     RHO(I,X)*GRAD(R(I,X0)), WHEN CALLING  G7ITB WITH IV(1) = 2 AND */
/*     IV(MODE) = 0 (WHERE MODE = 38).  G THEN CONTANS THE OTHER PART, */
/*     SO THAT THE DESIRED YIELD VECTOR IS G - Y.  IF PS .LT. P, THEN */
/*     THE ABOVE DISCUSSION APPLIES ONLY TO THE FIRST PS COMPONENTS OF */
/*     GRAD(R(I,X)), STEP, AND Y. */

/*        PARAMETERS IV, P, V, AND X ARE THE SAME AS THE CORRESPONDING */
/*     ONES TO   N2GB (AND NL2SOL), EXCEPT THAT V CAN BE SHORTER */
/*     (SINCE THE PART OF V THAT   N2GB USES FOR STORING D, J, AND R IS */
/*     NOT NEEDED).  MOREOVER, COMPARED WITH   N2GB (AND NL2SOL), IV(1) */
/*     MAY HAVE THE TWO ADDITIONAL OUTPUT VALUES 1 AND 2, WHICH ARE */
/*     EXPLAINED BELOW, AS IS THE USE OF IV(TOOBIG) AND IV(NFGCAL). */
/*     THE VALUES IV(D), IV(J), AND IV(R), WHICH ARE OUTPUT VALUES FROM */
/*       N2GB (AND   N2FB), ARE NOT REFERENCED BY  G7ITB OR THE */
/*     SUBROUTINES IT CALLS. */

/*        WHEN  G7ITB IS FIRST CALLED, I.E., WHEN  G7ITB IS CALLED WITH */
/*     IV(1) = 0 OR 12, V(F), G, AND HC NEED NOT BE INITIALIZED.  TO */
/*     OBTAIN THESE STARTING VALUES,  G7ITB RETURNS FIRST WITH IV(1) = 1, */
/*     THEN WITH IV(1) = 2, WITH IV(MODE) = -1 IN BOTH CASES.  ON */
/*     SUBSEQUENT RETURNS WITH IV(1) = 2, IV(MODE) = 0 IMPLIES THAT */
/*     Y MUST ALSO BE SUPPLIED.  (NOTE THAT Y IS USED FOR SCRATCH -- ITS */
/*     INPUT CONTENTS ARE LOST.  BY CONTRAST, HC IS NEVER CHANGED.) */
/*     ONCE CONVERGENCE HAS BEEN OBTAINED, IV(RDREQ) AND IV(COVREQ) MAY */
/*     IMPLY THAT A FINITE-DIFFERENCE HESSIAN SHOULD BE COMPUTED FOR USE */
/*     IN COMPUTING A COVARIANCE MATRIX.  IN THIS CASE  G7ITB WILL MAKE */
/*     A NUMBER OF RETURNS WITH IV(1) = 1 OR 2 AND IV(MODE) POSITIVE. */
/*     WHEN IV(MODE) IS POSITIVE, Y SHOULD NOT BE CHANGED. */

/* IV(1) = 1 MEANS THE CALLER SHOULD SET V(F) (I.E., V(10)) TO F(X), THE */
/*             FUNCTION VALUE AT X, AND CALL  G7ITB AGAIN, HAVING CHANGED */
/*             NONE OF THE OTHER PARAMETERS.  AN EXCEPTION OCCURS IF F(X) */
/*             CANNOT BE EVALUATED (E.G. IF OVERFLOW WOULD OCCUR), WHICH */
/*             MAY HAPPEN BECAUSE OF AN OVERSIZED STEP.  IN THIS CASE */
/*             THE CALLER SHOULD SET IV(TOOBIG) = IV(2) TO 1, WHICH WILL */
/*             CAUSE  G7ITB TO IGNORE V(F) AND TRY A SMALLER STEP.  NOTE */
/*             THAT THE CURRENT FUNCTION EVALUATION COUNT IS AVAILABLE */
/*             IN IV(NFCALL) = IV(6).  THIS MAY BE USED TO IDENTIFY */
/*             WHICH COPY OF SAVED INFORMATION SHOULD BE USED IN COM- */
/*             PUTING G, HC, AND Y THE NEXT TIME  G7ITB RETURNS WITH */
/*             IV(1) = 2.  SEE MLPIT FOR AN EXAMPLE OF THIS. */
/* IV(1) = 2 MEANS THE CALLER SHOULD SET G TO G(X), THE GRADIENT OF F AT */
/*             X.  THE CALLER SHOULD ALSO SET HC TO THE GAUSS-NEWTON */
/*             HESSIAN AT X.  IF IV(MODE) = 0, THEN THE CALLER SHOULD */
/*             ALSO COMPUTE THE PART OF THE YIELD VECTOR DESCRIBED ABOVE. */
/*             THE CALLER SHOULD THEN CALL  G7ITB AGAIN (WITH IV(1) = 2). */
/*             THE CALLER MAY ALSO CHANGE D AT THIS TIME, BUT SHOULD NOT */
/*             CHANGE X.  NOTE THAT IV(NFGCAL) = IV(7) CONTAINS THE */
/*             VALUE THAT IV(NFCALL) HAD DURING THE RETURN WITH */
/*             IV(1) = 1 IN WHICH X HAD THE SAME VALUE AS IT NOW HAS. */
/*             IV(NFGCAL) IS EITHER IV(NFCALL) OR IV(NFCALL) - 1.  MLPIT */
/*             IS AN EXAMPLE WHERE THIS INFORMATION IS USED.  IF G OR HC */
/*             CANNOT BE EVALUATED AT X, THEN THE CALLER MAY SET */
/*             IV(NFGCAL) TO 0, IN WHICH CASE  G7ITB WILL RETURN WITH */
/*             IV(1) = 15. */

/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY. */

/*        (SEE NL2SOL FOR REFERENCES.) */

/* +++++++++++++++++++++++++++  DECLARATIONS  ++++++++++++++++++++++++++++ */

/*  ***  LOCAL VARIABLES  *** */


/*     ***  CONSTANTS  *** */


/*  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  *** */


/* A7SST.... ASSESSES CANDIDATE STEP. */
/*  D7TPR... RETURNS INNER PRODUCT OF TWO VECTORS. */
/*  F7DHB... COMPUTE FINITE-DIFFERENCE HESSIAN (FOR INIT. S MATRIX). */
/*  G7QSB... COMPUTES GOLDFELD-QUANDT-TROTTER STEP (AUGMENTED MODEL). */
/* I7COPY.... COPIES ONE INTEGER VECTOR TO ANOTHER. */
/* I7PNVR... INVERTS PERMUTATION ARRAY. */
/* I7SHFT... SHIFTS AN INTEGER VECTOR. */
/* ITSUM.... PRINTS ITERATION SUMMARY AND INFO ON INITIAL AND FINAL X. */
/*  L7MSB... COMPUTES LEVENBERG-MARQUARDT STEP (GAUSS-NEWTON MODEL). */
/*  L7SQR... COMPUTES L * L**T FROM LOWER TRIANGULAR MATRIX L. */
/*  L7TVM... COMPUTES L**T * V, V = VECTOR, L = LOWER TRIANGULAR MATRIX. */
/* L7VML.... COMPUTES L * V, V = VECTOR, L = LOWER TRIANGULAR MATRIX. */
/* PARCK.... CHECK VALIDITY OF IV AND V INPUT COMPONENTS. */
/*  Q7RSH... SHIFTS A QR FACTORIZATION. */
/*  RLDST... COMPUTES V(RELDX) = RELATIVE STEP SIZE. */
/*  S7DMP... MULTIPLIES A SYM. MATRIX FORE AND AFT BY A DIAG. MATRIX. */
/*  S7IPR... APPLIES PERMUTATION TO (LOWER TRIANG. OF) SYM. MATRIX. */
/*  S7LUP... PERFORMS QUASI-NEWTON UPDATE ON COMPACTLY STORED LOWER TRI- */
/*             ANGLE OF A SYMMETRIC MATRIX. */
/*  S7LVM... MULTIPLIES COMPACTLY STORED SYM. MATRIX TIMES VECTOR. */
/* STOPX.... RETURNS .TRUE. IF THE BREAK KEY HAS BEEN PRESSED. */
/*  V2NRM... RETURNS THE 2-NORM OF A VECTOR. */
/* V2AXY.... COMPUTES SCALAR TIMES ONE VECTOR PLUS ANOTHER. */
/* V7CPY.... COPIES ONE VECTOR TO ANOTHER. */
/*  V7IPR... APPLIES A PERMUTATION TO A VECTOR. */
/*  V7SCP... SETS ALL ELEMENTS OF A VECTOR TO A SCALAR. */
/*  V7VMP... MULTIPLIES (DIVIDES) VECTORS COMPONENTWISE. */

/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/*  ***  (NOTE THAT P0 AND PC ARE STORED IN IV(G0) AND IV(STLSTG) RESP.) */

/* /6 */
/*     DATA CNVCOD/55/, COVMAT/26/, COVREQ/15/, DIG/37/, FDH/74/, H/56/, */
/*    1     HC/71/, IERR/75/, INITS/25/, IPIVOT/76/, IRC/29/, IVNEED/3/, */
/*    2     KAGQT/33/, KALM/34/, LMAT/42/, MODE/35/, MODEL/5/, */
/*    3     MXFCAL/17/, MXITER/18/, NEXTIV/46/, NEXTV/47/, NFCALL/6/, */
/*    4     NFGCAL/7/, NFCOV/52/, NGCOV/53/, NGCALL/30/, NITER/31/, */
/*    5     P0/48/, PC/41/, PERM/58/, QTR/77/, RADINC/8/, RDREQ/57/, */
/*    6     REGD/67/, RESTOR/9/, RMAT/78/, S/62/, STEP/40/, STGLIM/11/, */
/*    7     SUSED/64/, SWITCH/12/, TOOBIG/2/, VNEED/4/, VSAVE/60/, W/65/, */
/*    8     XIRC/13/, X0/43/ */
/* /7 */
/* / */

/*  ***  V SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA COSMIN/47/, DGNORM/1/, DSTNRM/2/, F/10/, FDIF/11/, FUZZ/45/, */
/*    1     F0/13/, GTSTEP/4/, INCFAC/23/, LMAX0/35/, LMAXS/36/, */
/*    2     NVSAVE/9/, PHMXFC/21/, PREDUC/7/, RADFAC/16/, RADIUS/8/, */
/*    3     RAD0/9/, RELDX/17/, SIZE/55/, STPPAR/5/, TUNER4/29/, */
/*    4     TUNER5/30/, WSCALE/56/ */
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
    b -= 3;

    /* Function Body */
    i__ = iv[1];
    if (i__ == 1) {
	goto L50;
    }
    if (i__ == 2) {
	goto L60;
    }

    if (i__ < 12) {
	goto L10;
    }
    if (i__ > 13) {
	goto L10;
    }
    iv[4] = iv[4] + *p * (*p * 3 + 25) / 2 + 7;
    iv[3] += *p << 2;
L10:
    parck_(&c__1, &d__[1], &iv[1], liv, lv, p, &v[1]);
    i__ = iv[1] - 2;
    if (i__ > 12) {
	goto L999;
    }
    switch (i__) {
	case 1:  goto L360;
	case 2:  goto L360;
	case 3:  goto L360;
	case 4:  goto L360;
	case 5:  goto L360;
	case 6:  goto L360;
	case 7:  goto L240;
	case 8:  goto L190;
	case 9:  goto L240;
	case 10:  goto L20;
	case 11:  goto L20;
	case 12:  goto L30;
    }

/*  ***  STORAGE ALLOCATION  *** */

L20:
    pp1o2 = *p * (*p + 1) / 2;
    iv[62] = iv[42] + pp1o2;
    iv[43] = iv[62] + pp1o2;
    iv[40] = iv[43] + (*p << 1);
    iv[37] = iv[40] + *p * 3;
    iv[65] = iv[37] + (*p << 1);
    iv[56] = iv[65] + (*p << 2) + 7;
    iv[47] = iv[56] + pp1o2;
    iv[76] = iv[58] + *p * 3;
    iv[46] = iv[76] + *p;
    if (iv[1] != 13) {
	goto L30;
    }
    iv[1] = 14;
    goto L999;

/*  ***  INITIALIZATION  *** */

L30:
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
    iv[41] = *p;
    v[9] = 0.f;
    v[5] = 0.f;
    v[8] = v[35] / (v[21] + 1.f);

/*  ***  CHECK CONSISTENCY OF B AND INITIALIZE IP ARRAY  *** */

    ipi = iv[76];
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	iv[ipi] = i__;
	++ipi;
	if (b[(i__ << 1) + 1] > b[(i__ << 1) + 2]) {
	    goto L680;
	}
/* L40: */
    }

/*  ***  SET INITIAL MODEL AND S MATRIX  *** */

    iv[5] = 1;
    iv[1] = 1;
    if (iv[62] < 0) {
	goto L710;
    }
    if (iv[25] > 1) {
	iv[5] = 2;
    }
    s1 = iv[62];
    if (iv[25] == 0 || iv[25] > 2) {
	i__1 = *p * (*p + 1) / 2;
	v7scp_(&i__1, &v[s1], &c_b15);
    }
    goto L710;

/*  ***  NEW FUNCTION VALUE  *** */

L50:
    if (iv[35] == 0) {
	goto L360;
    }
    if (iv[35] > 0) {
	goto L590;
    }

    if (iv[2] == 0) {
	goto L690;
    }
    iv[1] = 63;
    goto L999;

/*  ***  MAKE SURE GRADIENT COULD BE COMPUTED  *** */

L60:
    if (iv[2] == 0) {
	goto L70;
    }
    iv[1] = 65;
    goto L999;

/*  ***  NEW GRADIENT  *** */

L70:
    iv[34] = -1;
    iv[33] = -1;
    iv[74] = 0;
    if (iv[35] > 0) {
	goto L590;
    }
    if (iv[71] <= 0 && iv[78] <= 0) {
	goto L670;
    }

/*  ***  CHOOSE INITIAL PERMUTATION  *** */

    ipi = iv[76];
    ipn = ipi + *p - 1;
    ipiv2 = iv[58] - 1;
    k = iv[41];
    p1 = *p;
    pp1 = *p + 1;
    rmat1 = iv[78];
    havrm = rmat1 > 0;
    qtr1 = iv[77];
    havqtr = qtr1 > 0;
/*     *** MAKE SURE V(QTR1) IS LEGAL (EVEN WHEN NOT REFERENCED) *** */
    w1 = iv[65];
    if (! havqtr) {
	qtr1 = w1 + *p;
    }

    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	i1 = iv[ipn];
	--ipn;
	if (b[(i1 << 1) + 1] >= b[(i1 << 1) + 2]) {
	    goto L80;
	}
	xi = x[i1];
	gi = g[i1];
	if (xi <= b[(i1 << 1) + 1] && gi > 0.f) {
	    goto L80;
	}
	if (xi >= b[(i1 << 1) + 2] && gi < 0.f) {
	    goto L80;
	}
/*           *** DISALLOW CONVERGENCE IF X(I1) HAS JUST BEEN FREED *** */
	j = ipiv2 + i1;
	if (iv[j] > k) {
	    iv[55] = 0;
	}
	goto L100;
L80:
	if (i1 >= p1) {
	    goto L90;
	}
	i1 = pp1 - i__;
	i7shft_(&p1, &i1, &iv[ipi]);
	if (havrm) {
	    q7rsh_(&i1, &p1, &havqtr, &v[qtr1], &v[rmat1], &v[w1]);
	}
L90:
	--p1;
L100:
	;
    }
    iv[41] = p1;

/*  ***  COMPUTE V(DGNORM) (AN OUTPUT VALUE IF WE STOP NOW)  *** */

    v[1] = 0.f;
    if (p1 <= 0) {
	goto L110;
    }
    dig1 = iv[37];
    v7vmp_(p, &v[dig1], &g[1], &d__[1], &c_n1);
    v7ipr_(p, &iv[ipi], &v[dig1]);
    v[1] = v2nrm_(&p1, &v[dig1]);
L110:
    if (iv[55] != 0) {
	goto L580;
    }
    if (iv[35] == 0) {
	goto L510;
    }
    iv[35] = 0;
    v[13] = v[10];
    if (iv[25] <= 2) {
	goto L170;
    }

/*  ***  ARRANGE FOR FINITE-DIFFERENCE INITIAL S  *** */

    iv[13] = iv[15];
    iv[15] = -1;
    if (iv[25] > 3) {
	iv[15] = 1;
    }
    iv[55] = 70;
    goto L600;

/*  ***  COME TO NEXT STMT AFTER COMPUTING F.D. HESSIAN FOR INIT. S  *** */

L120:
    h1 = iv[74];
    if (h1 <= 0) {
	goto L660;
    }
    iv[55] = 0;
    iv[35] = 0;
    iv[52] = 0;
    iv[53] = 0;
    iv[15] = iv[13];
    s1 = iv[62];
    pp1o2 = *ps * (*ps + 1) / 2;
    hc1 = iv[71];
    if (hc1 <= 0) {
	goto L130;
    }
    v2axy_(&pp1o2, &v[s1], &c_b32, &v[hc1], &v[h1]);
    goto L140;
L130:
    rmat1 = iv[78];
    lmat1 = iv[42];
    l7sqr_(p, &v[lmat1], &v[rmat1]);
    ipi = iv[76];
    ipiv1 = iv[58] + *p;
    i7pnvr_(p, &iv[ipiv1], &iv[ipi]);
    s7ipr_(p, &iv[ipiv1], &v[lmat1]);
    v2axy_(&pp1o2, &v[s1], &c_b32, &v[lmat1], &v[h1]);

/*     *** ZERO PORTION OF S CORRESPONDING TO FIXED X COMPONENTS *** */

L140:
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	if (b[(i__ << 1) + 1] < b[(i__ << 1) + 2]) {
	    goto L160;
	}
	k = s1 + i__ * (i__ - 1) / 2;
	v7scp_(&i__, &v[k], &c_b15);
	if (i__ >= *p) {
	    goto L170;
	}
	k = k + (i__ << 1) - 1;
	i1 = i__ + 1;
	i__2 = *p;
	for (j = i1; j <= i__2; ++j) {
	    v[k] = 0.f;
	    k += j;
/* L150: */
	}
L160:
	;
    }

L170:
    iv[1] = 2;


/* -----------------------------  MAIN LOOP  ----------------------------- */


/*  ***  PRINT ITERATION SUMMARY, CHECK ITERATION LIMIT  *** */

L180:
    itsum_(&d__[1], &g[1], &iv[1], liv, lv, p, &v[1], &x[1]);
L190:
    k = iv[31];
    if (k < iv[18]) {
	goto L200;
    }
    iv[1] = 10;
    goto L999;
L200:
    iv[31] = k + 1;

/*  ***  UPDATE RADIUS  *** */

    if (k == 0) {
	goto L220;
    }
    step1 = iv[40];
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[step1] = d__[i__] * v[step1];
	++step1;
/* L210: */
    }
    step1 = iv[40];
    t = v[16] * v2nrm_(p, &v[step1]);
    if (v[16] < 1.f || t > v[8]) {
	v[8] = t;
    }

/*  ***  INITIALIZE FOR START OF NEXT ITERATION  *** */

L220:
    x01 = iv[43];
    v[13] = v[10];
    iv[29] = 4;
    iv[56] = -abs(iv[56]);
    iv[64] = iv[5];

/*     ***  COPY X TO X0  *** */

    v7cpy_(p, &v[x01], &x[1]);

/*  ***  CHECK STOPX AND FUNCTION EVALUATION LIMIT  *** */

L230:
    if (! stopx_(&dummy)) {
	goto L250;
    }
    iv[1] = 11;
    goto L260;

/*     ***  COME HERE WHEN RESTARTING AFTER FUNC. EVAL. LIMIT OR STOPX. */

L240:
    if (v[10] >= v[13]) {
	goto L250;
    }
    v[16] = 1.f;
    k = iv[31];
    goto L200;

L250:
    if (iv[6] < iv[17] + iv[52]) {
	goto L270;
    }
    iv[1] = 9;
L260:
    if (v[10] >= v[13]) {
	goto L999;
    }

/*        ***  IN CASE OF STOPX OR FUNCTION EVALUATION LIMIT WITH */
/*        ***  IMPROVED V(F), EVALUATE THE GRADIENT AT X. */

    iv[55] = iv[1];
    goto L500;

/* . . . . . . . . . . . . .  COMPUTE CANDIDATE STEP  . . . . . . . . . . */

L270:
    step1 = iv[40];
    tg1 = iv[37];
    td1 = tg1 + *p;
    x01 = iv[43];
    w1 = iv[65];
    h1 = iv[56];
    p1 = iv[41];
    ipi = iv[58];
    ipiv1 = ipi + *p;
    ipiv2 = ipiv1 + *p;
    ipiv0 = iv[76];
    if (iv[5] == 2) {
	goto L280;
    }

/*        ***  COMPUTE LEVENBERG-MARQUARDT STEP IF POSSIBLE... */

    rmat1 = iv[78];
    if (rmat1 <= 0) {
	goto L280;
    }
    qtr1 = iv[77];
    if (qtr1 <= 0) {
	goto L280;
    }
    lmat1 = iv[42];
    wlm1 = w1 + *p;
    l7msb_(&b[3], &d__[1], &g[1], &iv[75], &iv[ipiv0], &iv[ipiv1], &iv[ipiv2],
	     &iv[34], &v[lmat1], lv, p, &iv[48], &iv[41], &v[qtr1], &v[rmat1],
	     &v[step1], &v[td1], &v[tg1], &v[1], &v[w1], &v[wlm1], &x[1], &v[
	    x01]);
/*        *** H IS STORED IN THE END OF W AND HAS JUST BEEN OVERWRITTEN, */
/*        *** SO WE MARK IT INVALID... */
    iv[56] = -abs(h1);
/*        *** EVEN IF H WERE STORED ELSEWHERE, IT WOULD BE NECESSARY TO */
/*        *** MARK INVALID THE INFORMATION G7QTS MAY HAVE STORED IN V... */
    iv[33] = -1;
    goto L330;

L280:
    if (h1 > 0) {
	goto L320;
    }

/*     ***  SET H TO  D**-1 * (HC + T1*S) * D**-1.  *** */

    p1len = p1 * (p1 + 1) / 2;
    h1 = -h1;
    iv[56] = h1;
    iv[74] = 0;
    if (p1 <= 0) {
	goto L320;
    }
/*        *** MAKE TEMPORARY PERMUTATION ARRAY *** */
    i7copy_(p, &iv[ipi], &iv[ipiv0]);
    j = iv[71];
    if (j > 0) {
	goto L290;
    }
    j = h1;
    rmat1 = iv[78];
    l7sqr_(&p1, &v[h1], &v[rmat1]);
    goto L300;
L290:
    i__1 = *p * (*p + 1) / 2;
    v7cpy_(&i__1, &v[h1], &v[j]);
    s7ipr_(p, &iv[ipi], &v[h1]);
L300:
    if (iv[5] == 1) {
	goto L310;
    }
    lmat1 = iv[42];
    s1 = iv[62];
    i__1 = *p * (*p + 1) / 2;
    v7cpy_(&i__1, &v[lmat1], &v[s1]);
    s7ipr_(p, &iv[ipi], &v[lmat1]);
    v2axy_(&p1len, &v[h1], &c_b53, &v[lmat1], &v[h1]);
L310:
    v7cpy_(p, &v[td1], &d__[1]);
    v7ipr_(p, &iv[ipi], &v[td1]);
    s7dmp_(&p1, &v[h1], &v[h1], &v[td1], &c_n1);
    iv[33] = -1;

/*  ***  COMPUTE ACTUAL GOLDFELD-QUANDT-TROTTER STEP  *** */

L320:
    lmat1 = iv[42];
    g7qsb_(&b[3], &d__[1], &v[h1], &g[1], &iv[ipi], &iv[ipiv1], &iv[ipiv2], &
	    iv[33], &v[lmat1], lv, p, &iv[48], &p1, &v[step1], &v[td1], &v[
	    tg1], &v[1], &v[w1], &x[1], &v[x01]);
    if (iv[34] > 0) {
	iv[34] = 0;
    }

L330:
    if (iv[29] != 6) {
	goto L340;
    }
    if (iv[9] != 2) {
	goto L360;
    }
    rstrst = 2;
    goto L370;

/*  ***  CHECK WHETHER EVALUATING F(X0 + STEP) LOOKS WORTHWHILE  *** */

L340:
    iv[2] = 0;
    if (v[2] <= 0.f) {
	goto L360;
    }
    if (iv[29] != 5) {
	goto L350;
    }
    if (v[16] <= 1.f) {
	goto L350;
    }
    if (v[7] > v[11] * 1.2f) {
	goto L350;
    }
    step1 = iv[40];
    x01 = iv[43];
    v2axy_(p, &v[step1], &c_b32, &v[x01], &x[1]);
    if (iv[9] != 2) {
	goto L360;
    }
    rstrst = 0;
    goto L370;

/*  ***  COMPUTE F(X0 + STEP)  *** */

L350:
    x01 = iv[43];
    step1 = iv[40];
    v2axy_(p, &x[1], &c_b53, &v[step1], &v[x01]);
    ++iv[6];
    iv[1] = 1;
    goto L710;

/* . . . . . . . . . . . . .  ASSESS CANDIDATE STEP  . . . . . . . . . . . */

L360:
    rstrst = 3;
L370:
    x01 = iv[43];
    v[17] = rldst_(p, &d__[1], &x[1], &v[x01]);
    a7sst_(&iv[1], liv, lv, &v[1]);
    step1 = iv[40];
    lstgst = x01 + *p;
    i__ = iv[9] + 1;
    switch (i__) {
	case 1:  goto L410;
	case 2:  goto L380;
	case 3:  goto L390;
	case 4:  goto L400;
    }
L380:
    v7cpy_(p, &x[1], &v[x01]);
    goto L410;
L390:
    v7cpy_(p, &v[lstgst], &v[step1]);
    goto L410;
L400:
    v7cpy_(p, &v[step1], &v[lstgst]);
    v2axy_(p, &x[1], &c_b53, &v[step1], &v[x01]);
    v[17] = rldst_(p, &d__[1], &x[1], &v[x01]);
    iv[9] = rstrst;

/*  ***  IF NECESSARY, SWITCH MODELS  *** */

L410:
    if (iv[12] == 0) {
	goto L420;
    }
    iv[56] = -abs(iv[56]);
    iv[64] += 2;
    l = iv[60];
    v7cpy_(&c__9, &v[1], &v[l]);
L420:
    l = iv[29] - 4;
    stpmod = iv[5];
    if (l > 0) {
	switch (l) {
	    case 1:  goto L440;
	    case 2:  goto L450;
	    case 3:  goto L460;
	    case 4:  goto L460;
	    case 5:  goto L460;
	    case 6:  goto L460;
	    case 7:  goto L460;
	    case 8:  goto L460;
	    case 9:  goto L570;
	    case 10:  goto L510;
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
	goto L430;
    }

/*     ***  SWITCH MODELS  *** */

    iv[5] = 3 - iv[5];
    if (-2 < l) {
	goto L470;
    }
    iv[56] = -abs(iv[56]);
    iv[64] += 2;
    l = iv[60];
    v7cpy_(&c__9, &v[l], &v[1]);
    goto L230;

L430:
    if (-3 < l) {
	goto L470;
    }

/*     ***  RECOMPUTE STEP WITH DIFFERENT RADIUS  *** */

L440:
    v[8] = v[16] * v[2];
    goto L230;

/*  ***  COMPUTE STEP OF LENGTH V(LMAXS) FOR SINGULAR CONVERGENCE TEST */

L450:
    v[8] = v[36];
    goto L270;

/*  ***  CONVERGENCE OR FALSE CONVERGENCE  *** */

L460:
    iv[55] = l;
    if (v[10] >= v[13]) {
	goto L580;
    }
    if (iv[13] == 14) {
	goto L580;
    }
    iv[13] = 14;

/* . . . . . . . . . . . .  PROCESS ACCEPTABLE STEP  . . . . . . . . . . . */

L470:
    iv[26] = 0;
    iv[67] = 0;

/*  ***  SEE WHETHER TO SET V(RADFAC) BY GRADIENT TESTS  *** */

    if (iv[29] != 3) {
	goto L500;
    }
    step1 = iv[40];
    temp1 = step1 + *p;
    temp2 = iv[43];

/*     ***  SET  TEMP1 = HESSIAN * STEP  FOR USE IN GRADIENT TESTS  *** */

    hc1 = iv[71];
    if (hc1 <= 0) {
	goto L480;
    }
    s7lvm_(p, &v[temp1], &v[hc1], &v[step1]);
    goto L490;
L480:
    rmat1 = iv[78];
    ipiv0 = iv[76];
    v7cpy_(p, &v[temp1], &v[step1]);
    v7ipr_(p, &iv[ipiv0], &v[temp1]);
    l7tvm_(p, &v[temp1], &v[rmat1], &v[temp1]);
    l7vml_(p, &v[temp1], &v[rmat1], &v[temp1]);
    ipiv1 = iv[58] + *p;
    i7pnvr_(p, &iv[ipiv1], &iv[ipiv0]);
    v7ipr_(p, &iv[ipiv1], &v[temp1]);

L490:
    if (stpmod == 1) {
	goto L500;
    }
    s1 = iv[62];
    s7lvm_(ps, &v[temp2], &v[s1], &v[step1]);
    v2axy_(ps, &v[temp1], &c_b53, &v[temp2], &v[temp1]);

/*  ***  SAVE OLD GRADIENT AND COMPUTE NEW ONE  *** */

L500:
    ++iv[30];
    g01 = iv[65];
    v7cpy_(p, &v[g01], &g[1]);
    goto L690;

/*  ***  INITIALIZATIONS -- G0 = G - G0, ETC.  *** */

L510:
    g01 = iv[65];
    v2axy_(p, &v[g01], &c_b32, &v[g01], &g[1]);
    step1 = iv[40];
    temp1 = step1 + *p;
    temp2 = iv[43];
    if (iv[29] != 3) {
	goto L540;
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
/* L520: */
    }

/*        ***  DO GRADIENT TESTS  *** */

    if (v2nrm_(p, &v[temp1]) <= v[1] * v[29]) {
	goto L530;
    }
    if (d7tpr_(p, &g[1], &v[step1]) >= v[4] * v[30]) {
	goto L540;
    }
L530:
    v[16] = v[23];

/*  ***  COMPUTE Y VECTOR NEEDED FOR UPDATING S  *** */

L540:
    v2axy_(ps, &y[1], &c_b32, &y[1], &g[1]);

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
	goto L550;
    }
    s7lvm_(ps, &v[g01], &v[hc1], &v[step1]);
    goto L560;

L550:
    rmat1 = iv[78];
    ipiv0 = iv[76];
    v7cpy_(p, &v[g01], &v[step1]);
    i__ = g01 + *ps;
    if (*ps < *p) {
	i__1 = *p - *ps;
	v7scp_(&i__1, &v[i__], &c_b15);
    }
    v7ipr_(p, &iv[ipiv0], &v[g01]);
    l7tvm_(p, &v[g01], &v[rmat1], &v[g01]);
    l7vml_(p, &v[g01], &v[rmat1], &v[g01]);
    ipiv1 = iv[58] + *p;
    i7pnvr_(p, &iv[ipiv1], &iv[ipiv0]);
    v7ipr_(p, &iv[ipiv1], &v[g01]);

L560:
    v2axy_(ps, &v[g01], &c_b53, &y[1], &v[g01]);

/*  ***  UPDATE S  *** */

    s7lup_(&v[s1], &v[47], ps, &v[55], &v[step1], &v[temp1], &v[temp2], &v[
	    g01], &v[56], &y[1]);
    iv[1] = 2;
    goto L180;

/* . . . . . . . . . . . . . .  MISC. DETAILS  . . . . . . . . . . . . . . */

/*  ***  BAD PARAMETERS TO ASSESS  *** */

L570:
    iv[1] = 64;
    goto L999;


/*  ***  CONVERGENCE OBTAINED -- SEE WHETHER TO COMPUTE COVARIANCE  *** */

L580:
    if (iv[57] == 0) {
	goto L660;
    }
    if (iv[74] != 0) {
	goto L660;
    }
    if (iv[55] >= 7) {
	goto L660;
    }
    if (iv[67] > 0) {
	goto L660;
    }
    if (iv[26] > 0) {
	goto L660;
    }
    if (abs(iv[15]) >= 3) {
	goto L640;
    }
    if (iv[9] == 0) {
	iv[9] = 2;
    }
    goto L600;

/*  ***  COMPUTE FINITE-DIFFERENCE HESSIAN FOR COMPUTING COVARIANCE  *** */

L590:
    iv[9] = 0;
L600:
    f7dhb_(&b[3], &d__[1], &g[1], &i__, &iv[1], liv, lv, p, &v[1], &x[1]);
    switch (i__) {
	case 1:  goto L610;
	case 2:  goto L620;
	case 3:  goto L630;
    }
L610:
    ++iv[52];
    ++iv[6];
    iv[1] = 1;
    goto L710;

L620:
    ++iv[53];
    ++iv[30];
    iv[7] = iv[6] + iv[53];
    goto L690;

L630:
    if (iv[55] == 70) {
	goto L120;
    }
    goto L660;

L640:
    h1 = abs(iv[56]);
    iv[74] = h1;
    iv[56] = -h1;
    hc1 = iv[71];
    if (hc1 <= 0) {
	goto L650;
    }
    i__1 = *p * (*p + 1) / 2;
    v7cpy_(&i__1, &v[h1], &v[hc1]);
    goto L660;
L650:
    rmat1 = iv[78];
    l7sqr_(p, &v[h1], &v[rmat1]);

L660:
    iv[35] = 0;
    iv[1] = iv[55];
    iv[55] = 0;
    goto L999;

/*  ***  SPECIAL RETURN FOR MISSING HESSIAN INFORMATION -- BOTH */
/*  ***  IV(HC) .LE. 0 AND IV(RMAT) .LE. 0 */

L670:
    iv[1] = 1400;
    goto L999;

/*  ***  INCONSISTENT B  *** */

L680:
    iv[1] = 82;
    goto L999;

/*  *** SAVE, THEN INITIALIZE IPIVOT ARRAY BEFORE COMPUTING G *** */

L690:
    iv[1] = 2;
    j = iv[76];
    ipi = iv[58];
    i7pnvr_(p, &iv[ipi], &iv[j]);
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	iv[j] = i__;
	++j;
/* L700: */
    }

/*  ***  PROJECT X INTO FEASIBLE REGION (PRIOR TO COMPUTING F OR G)  *** */

L710:
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	if (x[i__] < b[(i__ << 1) + 1]) {
	    x[i__] = b[(i__ << 1) + 1];
	}
	if (x[i__] > b[(i__ << 1) + 2]) {
	    x[i__] = b[(i__ << 1) + 2];
	}
/* L720: */
    }
    iv[2] = 0;

L999:
    return 0;

/*  ***  LAST LINE OF  G7ITB FOLLOWS  *** */
} /* g7itb_ */

