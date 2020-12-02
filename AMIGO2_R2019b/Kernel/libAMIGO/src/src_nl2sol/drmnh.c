/* drmnh.f -- translated by f2c (version 20100827).
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

static integer c__2 = 2;
static doublereal c_b32 = 1.;

/* Subroutine */ int drmnh_(doublereal *d__, doublereal *fx, doublereal *g, 
	doublereal *h__, integer *iv, integer *lh, integer *liv, integer *lv, 
	integer *n, doublereal *v, doublereal *x)
{
    /* System generated locals */
    integer i__1, i__2;

    /* Local variables */
    static integer i__, j, k, l;
    static doublereal t;
    static integer w1, x01, dg1, nn1o2, temp1, step1, dummy;
    extern logical stopx_(integer *);
    extern /* Subroutine */ int dd7dup_(doublereal *, doublereal *, integer *,
	     integer *, integer *, integer *, doublereal *);
    extern doublereal dd7tpr_(integer *, doublereal *, doublereal *);
    extern /* Subroutine */ int da7sst_(integer *, integer *, integer *, 
	    doublereal *), dv7scp_(integer *, doublereal *, doublereal *);
    extern doublereal dv2nrm_(integer *, doublereal *);
    extern /* Subroutine */ int dg7qts_(doublereal *, doublereal *, 
	    doublereal *, integer *, doublereal *, integer *, doublereal *, 
	    doublereal *, doublereal *), ds7lvm_(integer *, doublereal *, 
	    doublereal *, doublereal *), dv2axy_(integer *, doublereal *, 
	    doublereal *, doublereal *, doublereal *), dv7cpy_(integer *, 
	    doublereal *, doublereal *), dparck_(integer *, doublereal *, 
	    integer *, integer *, integer *, integer *, doublereal *);
    extern doublereal drldst_(integer *, doublereal *, doublereal *, 
	    doublereal *);
    extern /* Subroutine */ int divset_(integer *, integer *, integer *, 
	    integer *, doublereal *), ditsum_(doublereal *, doublereal *, 
	    integer *, integer *, integer *, integer *, doublereal *, 
	    doublereal *);
    static integer lstgst, rstrst;


/*  ***  CARRY OUT  DMNH (UNCONSTRAINED MINIMIZATION) ITERATIONS, USING */
/*  ***  HESSIAN MATRIX PROVIDED BY THE CALLER. */

/*  ***  PARAMETER DECLARATIONS  *** */


/* --------------------------  PARAMETER USAGE  -------------------------- */

/* D.... SCALE VECTOR. */
/* FX... FUNCTION VALUE. */
/* G.... GRADIENT VECTOR. */
/* H.... LOWER TRIANGLE OF THE HESSIAN, STORED ROWWISE. */
/* IV... INTEGER VALUE ARRAY. */
/* LH... LENGTH OF H = P*(P+1)/2. */
/* LIV.. LENGTH OF IV (AT LEAST 60). */
/* LV... LENGTH OF V (AT LEAST 78 + N*(N+21)/2). */
/* N.... NUMBER OF VARIABLES (COMPONENTS IN X AND G). */
/* V.... FLOATING-POINT VALUE ARRAY. */
/* X.... PARAMETER VECTOR. */

/*  ***  DISCUSSION  *** */

/*        PARAMETERS IV, N, V, AND X ARE THE SAME AS THE CORRESPONDING */
/*     ONES TO  DMNH (WHICH SEE), EXCEPT THAT V CAN BE SHORTER (SINCE */
/*     THE PART OF V THAT  DMNH USES FOR STORING G AND H IS NOT NEEDED). */
/*     MOREOVER, COMPARED WITH  DMNH, IV(1) MAY HAVE THE TWO ADDITIONAL */
/*     OUTPUT VALUES 1 AND 2, WHICH ARE EXPLAINED BELOW, AS IS THE USE */
/*     OF IV(TOOBIG) AND IV(NFGCAL).  THE VALUE IV(G), WHICH IS AN */
/*     OUTPUT VALUE FROM  DMNH, IS NOT REFERENCED BY DRMNH OR THE */
/*     SUBROUTINES IT CALLS. */

/* IV(1) = 1 MEANS THE CALLER SHOULD SET FX TO F(X), THE FUNCTION VALUE */
/*             AT X, AND CALL DRMNH AGAIN, HAVING CHANGED NONE OF THE */
/*             OTHER PARAMETERS.  AN EXCEPTION OCCURS IF F(X) CANNOT BE */
/*             COMPUTED (E.G. IF OVERFLOW WOULD OCCUR), WHICH MAY HAPPEN */
/*             BECAUSE OF AN OVERSIZED STEP.  IN THIS CASE THE CALLER */
/*             SHOULD SET IV(TOOBIG) = IV(2) TO 1, WHICH WILL CAUSE */
/*             DRMNH TO IGNORE FX AND TRY A SMALLER STEP.  THE PARA- */
/*             METER NF THAT  DMNH PASSES TO CALCF (FOR POSSIBLE USE BY */
/*             CALCGH) IS A COPY OF IV(NFCALL) = IV(6). */
/* IV(1) = 2 MEANS THE CALLER SHOULD SET G TO G(X), THE GRADIENT OF F AT */
/*             X, AND H TO THE LOWER TRIANGLE OF H(X), THE HESSIAN OF F */
/*             AT X, AND CALL DRMNH AGAIN, HAVING CHANGED NONE OF THE */
/*             OTHER PARAMETERS EXCEPT PERHAPS THE SCALE VECTOR D. */
/*                  THE PARAMETER NF THAT  DMNH PASSES TO CALCG IS */
/*             IV(NFGCAL) = IV(7).  IF G(X) AND H(X) CANNOT BE EVALUATED, */
/*             THEN THE CALLER MAY SET IV(TOOBIG) TO 0, IN WHICH CASE */
/*             DRMNH WILL RETURN WITH IV(1) = 65. */
/*                  NOTE -- DRMNH OVERWRITES H WITH THE LOWER TRIANGLE */
/*             OF  DIAG(D)**-1 * H(X) * DIAG(D)**-1. */
/* . */
/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY (WINTER 1980).  REVISED SEPT. 1982. */
/*     THIS SUBROUTINE WAS WRITTEN IN CONNECTION WITH RESEARCH SUPPORTED */
/*     IN PART BY THE NATIONAL SCIENCE FOUNDATION UNDER GRANTS */
/*     MCS-7600324 AND MCS-7906671. */

/*        (SEE  DMNG AND  DMNH FOR REFERENCES.) */

/* +++++++++++++++++++++++++++  DECLARATIONS  ++++++++++++++++++++++++++++ */

/*  ***  LOCAL VARIABLES  *** */


/*     ***  CONSTANTS  *** */


/*  ***  NO INTRINSIC FUNCTIONS  *** */

/*  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  *** */


/* DA7SST.... ASSESSES CANDIDATE STEP. */
/* DIVSET.... PROVIDES DEFAULT IV AND V INPUT VALUES. */
/* DD7TPR... RETURNS INNER PRODUCT OF TWO VECTORS. */
/* DD7DUP.... UPDATES SCALE VECTOR D. */
/* DG7QTS.... COMPUTES OPTIMALLY LOCALLY CONSTRAINED STEP. */
/* DITSUM.... PRINTS ITERATION SUMMARY AND INFO ON INITIAL AND FINAL X. */
/* DPARCK.... CHECKS VALIDITY OF INPUT IV AND V VALUES. */
/* DRLDST... COMPUTES V(RELDX) = RELATIVE STEP SIZE. */
/* DS7LVM... MULTIPLIES SYMMETRIC MATRIX TIMES VECTOR, GIVEN THE LOWER */
/*             TRIANGLE OF THE MATRIX. */
/* STOPX.... RETURNS .TRUE. IF THE BREAK KEY HAS BEEN PRESSED. */
/* DV2AXY.... COMPUTES SCALAR TIMES ONE VECTOR PLUS ANOTHER. */
/* DV7CPY.... COPIES ONE VECTOR TO ANOTHER. */
/* DV7SCP... SETS ALL ELEMENTS OF A VECTOR TO A SCALAR. */
/* DV2NRM... RETURNS THE 2-NORM OF A VECTOR. */

/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA CNVCOD/55/, DG/37/, DTOL/59/, DTYPE/16/, IRC/29/, KAGQT/33/, */
/*    1     LMAT/42/, MODE/35/, MODEL/5/, MXFCAL/17/, MXITER/18/, */
/*    2     NEXTV/47/, NFCALL/6/, NFGCAL/7/, NGCALL/30/, NITER/31/, */
/*    3     RADINC/8/, RESTOR/9/, STEP/40/, STGLIM/11/, STLSTG/41/, */
/*    4     TOOBIG/2/, VNEED/4/, W/34/, XIRC/13/, X0/43/ */
/* /7 */
/* / */

/*  ***  V SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA DGNORM/1/, DINIT/38/, DSTNRM/2/, DTINIT/39/, D0INIT/40/, */
/*    1     F/10/, F0/13/, FDIF/11/, GTSTEP/4/, INCFAC/23/, LMAX0/35/, */
/*    2     LMAXS/36/, PHMXFC/21/, PREDUC/7/, RADFAC/16/, RADIUS/8/, */
/*    3     RAD0/9/, RELDX/17/, STPPAR/5/, TUNER4/29/, TUNER5/30/ */
/* /7 */
/* / */

/* /6 */
/*     DATA ONE/1.D+0/, ONEP2/1.2D+0/, ZERO/0.D+0/ */
/* /7 */
/* / */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    /* Parameter adjustments */
    --h__;
    --iv;
    --v;
    --x;
    --g;
    --d__;

    /* Function Body */
    i__ = iv[1];
    if (i__ == 1) {
	goto L30;
    }
    if (i__ == 2) {
	goto L40;
    }

/*  ***  CHECK VALIDITY OF IV AND V INPUT VALUES  *** */

    if (iv[1] == 0) {
	divset_(&c__2, &iv[1], liv, lv, &v[1]);
    }
    if (iv[1] == 12 || iv[1] == 13) {
	iv[4] = iv[4] + *n * (*n + 21) / 2 + 7;
    }
    dparck_(&c__2, &d__[1], &iv[1], liv, lv, n, &v[1]);
    i__ = iv[1] - 2;
    if (i__ > 12) {
	goto L999;
    }
    nn1o2 = *n * (*n + 1) / 2;
    if (*lh >= nn1o2) {
	switch (i__) {
	    case 1:  goto L220;
	    case 2:  goto L220;
	    case 3:  goto L220;
	    case 4:  goto L220;
	    case 5:  goto L220;
	    case 6:  goto L220;
	    case 7:  goto L160;
	    case 8:  goto L120;
	    case 9:  goto L160;
	    case 10:  goto L10;
	    case 11:  goto L10;
	    case 12:  goto L20;
	}
    }
    iv[1] = 66;
    goto L400;

/*  ***  STORAGE ALLOCATION  *** */

L10:
    iv[59] = iv[42] + nn1o2;
    iv[43] = iv[59] + (*n << 1);
    iv[40] = iv[43] + *n;
    iv[41] = iv[40] + *n;
    iv[37] = iv[41] + *n;
    iv[34] = iv[37] + *n;
    iv[47] = iv[34] + (*n << 2) + 7;
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
    iv[5] = 1;
    iv[11] = 1;
    iv[2] = 0;
    iv[55] = 0;
    iv[8] = 0;
    v[9] = 0.;
    v[5] = 0.;
    if (v[38] >= 0.) {
	dv7scp_(n, &d__[1], &v[38]);
    }
    k = iv[59];
    if (v[39] > 0.) {
	dv7scp_(n, &v[k], &v[39]);
    }
    k += *n;
    if (v[40] > 0.) {
	dv7scp_(n, &v[k], &v[40]);
    }
    iv[1] = 1;
    goto L999;

L30:
    v[10] = *fx;
    if (iv[35] >= 0) {
	goto L220;
    }
    v[13] = *fx;
    iv[1] = 2;
    if (iv[2] == 0) {
	goto L999;
    }
    iv[1] = 63;
    goto L400;

/*  ***  MAKE SURE GRADIENT COULD BE COMPUTED  *** */

L40:
    if (iv[2] == 0) {
	goto L50;
    }
    iv[1] = 65;
    goto L400;

/*  ***  UPDATE THE SCALE VECTOR D  *** */

L50:
    dg1 = iv[37];
    if (iv[16] <= 0) {
	goto L70;
    }
    k = dg1;
    j = 0;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	j += i__;
	v[k] = h__[j];
	++k;
/* L60: */
    }
    dd7dup_(&d__[1], &v[dg1], &iv[1], liv, lv, n, &v[1]);

/*  ***  COMPUTE SCALED GRADIENT AND ITS NORM  *** */

L70:
    dg1 = iv[37];
    k = dg1;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[k] = g[i__] / d__[i__];
	++k;
/* L80: */
    }
    v[1] = dv2nrm_(n, &v[dg1]);

/*  ***  COMPUTE SCALED HESSIAN  *** */

    k = 1;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	t = 1. / d__[i__];
	i__2 = i__;
	for (j = 1; j <= i__2; ++j) {
	    h__[k] = t * h__[k] / d__[j];
	    ++k;
/* L90: */
	}
/* L100: */
    }

    if (iv[55] != 0) {
	goto L390;
    }
    if (iv[35] == 0) {
	goto L350;
    }

/*  ***  ALLOW FIRST STEP TO HAVE SCALED 2-NORM AT MOST V(LMAX0)  *** */

    v[8] = v[35] / (v[21] + 1.);

    iv[35] = 0;


/* -----------------------------  MAIN LOOP  ----------------------------- */


/*  ***  PRINT ITERATION SUMMARY, CHECK ITERATION LIMIT  *** */

L110:
    ditsum_(&d__[1], &g[1], &iv[1], liv, lv, n, &v[1], &x[1]);
L120:
    k = iv[31];
    if (k < iv[18]) {
	goto L130;
    }
    iv[1] = 10;
    goto L400;

L130:
    iv[31] = k + 1;

/*  ***  INITIALIZE FOR START OF NEXT ITERATION  *** */

    dg1 = iv[37];
    x01 = iv[43];
    v[13] = v[10];
    iv[29] = 4;
    iv[33] = -1;

/*     ***  COPY X TO X0  *** */

    dv7cpy_(n, &v[x01], &x[1]);

/*  ***  UPDATE RADIUS  *** */

    if (k == 0) {
	goto L150;
    }
    step1 = iv[40];
    k = step1;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[k] = d__[i__] * v[k];
	++k;
/* L140: */
    }
    v[8] = v[16] * dv2nrm_(n, &v[step1]);

/*  ***  CHECK STOPX AND FUNCTION EVALUATION LIMIT  *** */

L150:
    if (! stopx_(&dummy)) {
	goto L170;
    }
    iv[1] = 11;
    goto L180;

/*     ***  COME HERE WHEN RESTARTING AFTER FUNC. EVAL. LIMIT OR STOPX. */

L160:
    if (v[10] >= v[13]) {
	goto L170;
    }
    v[16] = 1.;
    k = iv[31];
    goto L130;

L170:
    if (iv[6] < iv[17]) {
	goto L190;
    }
    iv[1] = 9;
L180:
    if (v[10] >= v[13]) {
	goto L400;
    }

/*        ***  IN CASE OF STOPX OR FUNCTION EVALUATION LIMIT WITH */
/*        ***  IMPROVED V(F), EVALUATE THE GRADIENT AT X. */

    iv[55] = iv[1];
    goto L340;

/* . . . . . . . . . . . . .  COMPUTE CANDIDATE STEP  . . . . . . . . . . */

L190:
    step1 = iv[40];
    dg1 = iv[37];
    l = iv[42];
    w1 = iv[34];
    dg7qts_(&d__[1], &v[dg1], &h__[1], &iv[33], &v[l], n, &v[step1], &v[1], &
	    v[w1]);
    if (iv[29] != 6) {
	goto L200;
    }
    if (iv[9] != 2) {
	goto L220;
    }
    rstrst = 2;
    goto L230;

/*  ***  CHECK WHETHER EVALUATING F(X0 + STEP) LOOKS WORTHWHILE  *** */

L200:
    iv[2] = 0;
    if (v[2] <= 0.) {
	goto L220;
    }
    if (iv[29] != 5) {
	goto L210;
    }
    if (v[16] <= 1.) {
	goto L210;
    }
    if (v[7] > v[11] * 1.2) {
	goto L210;
    }
    if (iv[9] != 2) {
	goto L220;
    }
    rstrst = 0;
    goto L230;

/*  ***  COMPUTE F(X0 + STEP)  *** */

L210:
    x01 = iv[43];
    step1 = iv[40];
    dv2axy_(n, &x[1], &c_b32, &v[step1], &v[x01]);
    ++iv[6];
    iv[1] = 1;
    goto L999;

/* . . . . . . . . . . . . .  ASSESS CANDIDATE STEP  . . . . . . . . . . . */

L220:
    rstrst = 3;
L230:
    x01 = iv[43];
    v[17] = drldst_(n, &d__[1], &x[1], &v[x01]);
    da7sst_(&iv[1], liv, lv, &v[1]);
    step1 = iv[40];
    lstgst = iv[41];
    i__ = iv[9] + 1;
    switch (i__) {
	case 1:  goto L270;
	case 2:  goto L240;
	case 3:  goto L250;
	case 4:  goto L260;
    }
L240:
    dv7cpy_(n, &x[1], &v[x01]);
    goto L270;
L250:
    dv7cpy_(n, &v[lstgst], &v[step1]);
    goto L270;
L260:
    dv7cpy_(n, &v[step1], &v[lstgst]);
    dv2axy_(n, &x[1], &c_b32, &v[step1], &v[x01]);
    v[17] = drldst_(n, &d__[1], &x[1], &v[x01]);
    iv[9] = rstrst;

L270:
    k = iv[29];
    switch (k) {
	case 1:  goto L280;
	case 2:  goto L310;
	case 3:  goto L310;
	case 4:  goto L310;
	case 5:  goto L280;
	case 6:  goto L290;
	case 7:  goto L300;
	case 8:  goto L300;
	case 9:  goto L300;
	case 10:  goto L300;
	case 11:  goto L300;
	case 12:  goto L300;
	case 13:  goto L380;
	case 14:  goto L350;
    }

/*     ***  RECOMPUTE STEP WITH NEW RADIUS  *** */

L280:
    v[8] = v[16] * v[2];
    goto L150;

/*  ***  COMPUTE STEP OF LENGTH V(LMAXS) FOR SINGULAR CONVERGENCE TEST. */

L290:
    v[8] = v[36];
    goto L190;

/*  ***  CONVERGENCE OR FALSE CONVERGENCE  *** */

L300:
    iv[55] = k - 4;
    if (v[10] >= v[13]) {
	goto L390;
    }
    if (iv[13] == 14) {
	goto L390;
    }
    iv[13] = 14;

/* . . . . . . . . . . . .  PROCESS ACCEPTABLE STEP  . . . . . . . . . . . */

L310:
    if (iv[29] != 3) {
	goto L340;
    }
    temp1 = lstgst;

/*     ***  PREPARE FOR GRADIENT TESTS  *** */
/*     ***  SET  TEMP1 = HESSIAN * STEP + G(X0) */
/*     ***             = DIAG(D) * (H * STEP + G(X0)) */

/*        USE X0 VECTOR AS TEMPORARY. */
    k = x01;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[k] = d__[i__] * v[step1];
	++k;
	++step1;
/* L320: */
    }
    ds7lvm_(n, &v[temp1], &h__[1], &v[x01]);
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[temp1] = d__[i__] * v[temp1] + g[i__];
	++temp1;
/* L330: */
    }

/*  ***  COMPUTE GRADIENT AND HESSIAN  *** */

L340:
    ++iv[30];
    iv[2] = 0;
    iv[1] = 2;
    goto L999;

L350:
    iv[1] = 2;
    if (iv[29] != 3) {
	goto L110;
    }

/*  ***  SET V(RADFAC) BY GRADIENT TESTS  *** */

    temp1 = iv[41];
    step1 = iv[40];

/*     ***  SET  TEMP1 = DIAG(D)**-1 * (HESSIAN*STEP + (G(X0)-G(X)))  *** */

    k = temp1;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	v[k] = (v[k] - g[i__]) / d__[i__];
	++k;
/* L360: */
    }

/*     ***  DO GRADIENT TESTS  *** */

    if (dv2nrm_(n, &v[temp1]) <= v[1] * v[29]) {
	goto L370;
    }
    if (dd7tpr_(n, &g[1], &v[step1]) >= v[4] * v[30]) {
	goto L110;
    }
L370:
    v[16] = v[23];
    goto L110;

/* . . . . . . . . . . . . . .  MISC. DETAILS  . . . . . . . . . . . . . . */

/*  ***  BAD PARAMETERS TO ASSESS  *** */

L380:
    iv[1] = 64;
    goto L400;

/*  ***  PRINT SUMMARY OF FINAL ITERATION AND OTHER REQUESTED ITEMS  *** */

L390:
    iv[1] = iv[55];
    iv[55] = 0;
L400:
    ditsum_(&d__[1], &g[1], &iv[1], liv, lv, n, &v[1], &x[1]);

L999:
    return 0;

/*  ***  LAST CARD OF DRMNH FOLLOWS  *** */
} /* drmnh_ */

