/* drmng.f -- translated by f2c (version 20100827).
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
static doublereal c_b13 = 0.;
static integer c_n1 = -1;
static integer c__1 = 1;
static doublereal c_b33 = 1.;
static doublereal c_b44 = -1.;

/* Subroutine */ int drmng_(doublereal *d__, doublereal *fx, doublereal *g, 
	integer *iv, integer *liv, integer *lv, integer *n, doublereal *v, 
	doublereal *x)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, k, l;
    static doublereal t;
    static integer w, z__, g01, x01, dg1, temp1, step1, dummy;
    extern /* Subroutine */ int dd7dog_(doublereal *, integer *, integer *, 
	    doublereal *, doublereal *, doublereal *);
    extern logical stopx_(integer *);
    extern /* Subroutine */ int dl7upd_(doublereal *, doublereal *, 
	    doublereal *, doublereal *, doublereal *, integer *, doublereal *,
	     doublereal *), dl7ivm_(integer *, doublereal *, doublereal *, 
	    doublereal *), dw7zbf_(doublereal *, integer *, doublereal *, 
	    doublereal *, doublereal *, doublereal *);
    extern doublereal dd7tpr_(integer *, doublereal *, doublereal *);
    extern /* Subroutine */ int da7sst_(integer *, integer *, integer *, 
	    doublereal *), dl7vml_(integer *, doublereal *, doublereal *, 
	    doublereal *), dv7scp_(integer *, doublereal *, doublereal *);
    extern doublereal dv2nrm_(integer *, doublereal *);
    extern /* Subroutine */ int dl7itv_(integer *, doublereal *, doublereal *,
	     doublereal *), dv7cpy_(integer *, doublereal *, doublereal *), 
	    dl7tvm_(integer *, doublereal *, doublereal *, doublereal *), 
	    dv2axy_(integer *, doublereal *, doublereal *, doublereal *, 
	    doublereal *), dv7vmp_(integer *, doublereal *, doublereal *, 
	    doublereal *, integer *);
    static integer nwtst1;
    extern /* Subroutine */ int dparck_(integer *, doublereal *, integer *, 
	    integer *, integer *, integer *, doublereal *);
    extern doublereal drldst_(integer *, doublereal *, doublereal *, 
	    doublereal *);
    extern /* Subroutine */ int divset_(integer *, integer *, integer *, 
	    integer *, doublereal *), ditsum_(doublereal *, doublereal *, 
	    integer *, integer *, integer *, integer *, doublereal *, 
	    doublereal *);
    static integer lstgst, rstrst;


/*  ***  CARRY OUT  DMNG (UNCONSTRAINED MINIMIZATION) ITERATIONS, USING */
/*  ***  DOUBLE-DOGLEG/BFGS STEPS. */

/*  ***  PARAMETER DECLARATIONS  *** */


/* --------------------------  PARAMETER USAGE  -------------------------- */

/* D.... SCALE VECTOR. */
/* FX... FUNCTION VALUE. */
/* G.... GRADIENT VECTOR. */
/* IV... INTEGER VALUE ARRAY. */
/* LIV.. LENGTH OF IV (AT LEAST 60). */
/* LV... LENGTH OF V (AT LEAST 71 + N*(N+13)/2). */
/* N.... NUMBER OF VARIABLES (COMPONENTS IN X AND G). */
/* V.... FLOATING-POINT VALUE ARRAY. */
/* X.... VECTOR OF PARAMETERS TO BE OPTIMIZED. */

/*  ***  DISCUSSION  *** */

/*        PARAMETERS IV, N, V, AND X ARE THE SAME AS THE CORRESPONDING */
/*     ONES TO  DMNG (WHICH SEE), EXCEPT THAT V CAN BE SHORTER (SINCE */
/*     THE PART OF V THAT  DMNG USES FOR STORING G IS NOT NEEDED). */
/*     MOREOVER, COMPARED WITH  DMNG, IV(1) MAY HAVE THE TWO ADDITIONAL */
/*     OUTPUT VALUES 1 AND 2, WHICH ARE EXPLAINED BELOW, AS IS THE USE */
/*     OF IV(TOOBIG) AND IV(NFGCAL).  THE VALUE IV(G), WHICH IS AN */
/*     OUTPUT VALUE FROM  DMNG (AND  DMNF), IS NOT REFERENCED BY */
/*     DRMNG OR THE SUBROUTINES IT CALLS. */
/*        FX AND G NEED NOT HAVE BEEN INITIALIZED WHEN DRMNG IS CALLED */
/*     WITH IV(1) = 12, 13, OR 14. */

/* IV(1) = 1 MEANS THE CALLER SHOULD SET FX TO F(X), THE FUNCTION VALUE */
/*             AT X, AND CALL DRMNG AGAIN, HAVING CHANGED NONE OF THE */
/*             OTHER PARAMETERS.  AN EXCEPTION OCCURS IF F(X) CANNOT BE */
/*             (E.G. IF OVERFLOW WOULD OCCUR), WHICH MAY HAPPEN BECAUSE */
/*             OF AN OVERSIZED STEP.  IN THIS CASE THE CALLER SHOULD SET */
/*             IV(TOOBIG) = IV(2) TO 1, WHICH WILL CAUSE DRMNG TO IG- */
/*             NORE FX AND TRY A SMALLER STEP.  THE PARAMETER NF THAT */
/*              DMNG PASSES TO CALCF (FOR POSSIBLE USE BY CALCG) IS A */
/*             COPY OF IV(NFCALL) = IV(6). */
/* IV(1) = 2 MEANS THE CALLER SHOULD SET G TO G(X), THE GRADIENT VECTOR */
/*             OF F AT X, AND CALL DRMNG AGAIN, HAVING CHANGED NONE OF */
/*             THE OTHER PARAMETERS EXCEPT POSSIBLY THE SCALE VECTOR D */
/*             WHEN IV(DTYPE) = 0.  THE PARAMETER NF THAT  DMNG PASSES */
/*             TO CALCG IS IV(NFGCAL) = IV(7).  IF G(X) CANNOT BE */
/*             EVALUATED, THEN THE CALLER MAY SET IV(TOOBIG) TO 0, IN */
/*             WHICH CASE DRMNG WILL RETURN WITH IV(1) = 65. */
/* . */
/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY (DECEMBER 1979).  REVISED SEPT. 1982. */
/*     THIS SUBROUTINE WAS WRITTEN IN CONNECTION WITH RESEARCH SUPPORTED */
/*     IN PART BY THE NATIONAL SCIENCE FOUNDATION UNDER GRANTS */
/*     MCS-7600324 AND MCS-7906671. */

/*        (SEE  DMNG FOR REFERENCES.) */

/* +++++++++++++++++++++++++++  DECLARATIONS  ++++++++++++++++++++++++++++ */

/*  ***  LOCAL VARIABLES  *** */


/*     ***  CONSTANTS  *** */


/*  ***  NO INTRINSIC FUNCTIONS  *** */

/*  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  *** */


/* DA7SST.... ASSESSES CANDIDATE STEP. */
/* DD7DOG.... COMPUTES DOUBLE-DOGLEG (CANDIDATE) STEP. */
/* DIVSET.... SUPPLIES DEFAULT IV AND V INPUT COMPONENTS. */
/* DD7TPR... RETURNS INNER PRODUCT OF TWO VECTORS. */
/* DITSUM.... PRINTS ITERATION SUMMARY AND INFO ON INITIAL AND FINAL X. */
/* DL7ITV... MULTIPLIES INVERSE TRANSPOSE OF LOWER TRIANGLE TIMES VECTOR. */
/* DL7IVM... MULTIPLIES INVERSE OF LOWER TRIANGLE TIMES VECTOR. */
/* DL7TVM... MULTIPLIES TRANSPOSE OF LOWER TRIANGLE TIMES VECTOR. */
/* LUPDT.... UPDATES CHOLESKY FACTOR OF HESSIAN APPROXIMATION. */
/* DL7VML.... MULTIPLIES LOWER TRIANGLE TIMES VECTOR. */
/* DPARCK.... CHECKS VALIDITY OF INPUT IV AND V VALUES. */
/* DRLDST... COMPUTES V(RELDX) = RELATIVE STEP SIZE. */
/* STOPX.... RETURNS .TRUE. IF THE BREAK KEY HAS BEEN PRESSED. */
/* DV2AXY.... COMPUTES SCALAR TIMES ONE VECTOR PLUS ANOTHER. */
/* DV7CPY.... COPIES ONE VECTOR TO ANOTHER. */
/* DV7SCP... SETS ALL ELEMENTS OF A VECTOR TO A SCALAR. */
/* DV7VMP... MULTIPLIES VECTOR BY VECTOR RAISED TO POWER (COMPONENTWISE). */
/* DV2NRM... RETURNS THE 2-NORM OF A VECTOR. */
/* DW7ZBF... COMPUTES W AND Z FOR DL7UPD CORRESPONDING TO BFGS UPDATE. */

/*  ***  SUBSCRIPTS FOR IV AND V  *** */


/*  ***  IV SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA CNVCOD/55/, DG/37/, G0/48/, INITH/25/, IRC/29/, KAGQT/33/, */
/*    1     MODE/35/, MODEL/5/, MXFCAL/17/, MXITER/18/, NFCALL/6/, */
/*    2     NFGCAL/7/, NGCALL/30/, NITER/31/, NWTSTP/34/, RADINC/8/, */
/*    3     RESTOR/9/, STEP/40/, STGLIM/11/, STLSTG/41/, TOOBIG/2/, */
/*    4     VNEED/4/, XIRC/13/, X0/43/ */
/* /7 */
/* / */

/*  ***  V SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA DGNORM/1/, DINIT/38/, DSTNRM/2/, DST0/3/, F/10/, F0/13/, */
/*    1     FDIF/11/, GTHG/44/, GTSTEP/4/, INCFAC/23/, LMAT/42/, */
/*    2     LMAX0/35/, LMAXS/36/, NEXTV/47/, NREDUC/6/, PREDUC/7/, */
/*    3     RADFAC/16/, RADIUS/8/, RAD0/9/, RELDX/17/, TUNER4/29/, */
/*    4     TUNER5/30/ */
/* /7 */
/* / */

/* /6 */
/*     DATA HALF/0.5D+0/, NEGONE/-1.D+0/, ONE/1.D+0/, ONEP2/1.2D+0/, */
/*    1     ZERO/0.D+0/ */
/* /7 */
/* / */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    /* Parameter adjustments */
    --iv;
    --v;
    --x;
    --g;
    --d__;

    /* Function Body */
    i__ = iv[1];
    if (i__ == 1) {
	goto L50;
    }
    if (i__ == 2) {
	goto L60;
    }

/*  ***  CHECK VALIDITY OF IV AND V INPUT VALUES  *** */

    if (iv[1] == 0) {
	divset_(&c__2, &iv[1], liv, lv, &v[1]);
    }
    if (iv[1] == 12 || iv[1] == 13) {
	iv[4] += *n * (*n + 13) / 2;
    }
    dparck_(&c__2, &d__[1], &iv[1], liv, lv, n, &v[1]);
    i__ = iv[1] - 2;
    if (i__ > 12) {
	goto L999;
    }
    switch (i__) {
	case 1:  goto L190;
	case 2:  goto L190;
	case 3:  goto L190;
	case 4:  goto L190;
	case 5:  goto L190;
	case 6:  goto L190;
	case 7:  goto L120;
	case 8:  goto L90;
	case 9:  goto L120;
	case 10:  goto L10;
	case 11:  goto L10;
	case 12:  goto L20;
    }

/*  ***  STORAGE ALLOCATION  *** */

L10:
    l = iv[42];
    iv[43] = l + *n * (*n + 1) / 2;
    iv[40] = iv[43] + *n;
    iv[41] = iv[40] + *n;
    iv[48] = iv[41] + *n;
    iv[34] = iv[48] + *n;
    iv[37] = iv[34] + *n;
    iv[47] = iv[37] + *n;
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
    if (v[38] >= 0.) {
	dv7scp_(n, &d__[1], &v[38]);
    }
    if (iv[25] != 1) {
	goto L40;
    }

/*     ***  SET THE INITIAL HESSIAN APPROXIMATION TO DIAG(D)**-2  *** */

    l = iv[42];
    i__1 = *n * (*n + 1) / 2;
    dv7scp_(&i__1, &v[l], &c_b13);
    k = l - 1;
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	k += i__;
	t = d__[i__];
	if (t <= 0.) {
	    t = 1.;
	}
	v[k] = t;
/* L30: */
    }

/*  ***  COMPUTE INITIAL FUNCTION VALUE  *** */

L40:
    iv[1] = 1;
    goto L999;

L50:
    v[10] = *fx;
    if (iv[35] >= 0) {
	goto L190;
    }
    v[13] = *fx;
    iv[1] = 2;
    if (iv[2] == 0) {
	goto L999;
    }
    iv[1] = 63;
    goto L350;

/*  ***  MAKE SURE GRADIENT COULD BE COMPUTED  *** */

L60:
    if (iv[2] == 0) {
	goto L70;
    }
    iv[1] = 65;
    goto L350;

L70:
    dg1 = iv[37];
    dv7vmp_(n, &v[dg1], &g[1], &d__[1], &c_n1);
    v[1] = dv2nrm_(n, &v[dg1]);

    if (iv[55] != 0) {
	goto L340;
    }
    if (iv[35] == 0) {
	goto L300;
    }

/*  ***  ALLOW FIRST STEP TO HAVE SCALED 2-NORM AT MOST V(LMAX0)  *** */

    v[8] = v[35];

    iv[35] = 0;


/* -----------------------------  MAIN LOOP  ----------------------------- */


/*  ***  PRINT ITERATION SUMMARY, CHECK ITERATION LIMIT  *** */

L80:
    ditsum_(&d__[1], &g[1], &iv[1], liv, lv, n, &v[1], &x[1]);
L90:
    k = iv[31];
    if (k < iv[18]) {
	goto L100;
    }
    iv[1] = 10;
    goto L350;

/*  ***  UPDATE RADIUS  *** */

L100:
    iv[31] = k + 1;
    if (k > 0) {
	v[8] = v[16] * v[2];
    }

/*  ***  INITIALIZE FOR START OF NEXT ITERATION  *** */

    g01 = iv[48];
    x01 = iv[43];
    v[13] = v[10];
    iv[29] = 4;
    iv[33] = -1;

/*     ***  COPY X TO X0, G TO G0  *** */

    dv7cpy_(n, &v[x01], &x[1]);
    dv7cpy_(n, &v[g01], &g[1]);

/*  ***  CHECK STOPX AND FUNCTION EVALUATION LIMIT  *** */

L110:
    if (! stopx_(&dummy)) {
	goto L130;
    }
    iv[1] = 11;
    goto L140;

/*     ***  COME HERE WHEN RESTARTING AFTER FUNC. EVAL. LIMIT OR STOPX. */

L120:
    if (v[10] >= v[13]) {
	goto L130;
    }
    v[16] = 1.;
    k = iv[31];
    goto L100;

L130:
    if (iv[6] < iv[17]) {
	goto L150;
    }
    iv[1] = 9;
L140:
    if (v[10] >= v[13]) {
	goto L350;
    }

/*        ***  IN CASE OF STOPX OR FUNCTION EVALUATION LIMIT WITH */
/*        ***  IMPROVED V(F), EVALUATE THE GRADIENT AT X. */

    iv[55] = iv[1];
    goto L290;

/* . . . . . . . . . . . . .  COMPUTE CANDIDATE STEP  . . . . . . . . . . */

L150:
    step1 = iv[40];
    dg1 = iv[37];
    nwtst1 = iv[34];
    if (iv[33] >= 0) {
	goto L160;
    }
    l = iv[42];
    dl7ivm_(n, &v[nwtst1], &v[l], &g[1]);
    v[6] = dd7tpr_(n, &v[nwtst1], &v[nwtst1]) * .5;
    dl7itv_(n, &v[nwtst1], &v[l], &v[nwtst1]);
    dv7vmp_(n, &v[step1], &v[nwtst1], &d__[1], &c__1);
    v[3] = dv2nrm_(n, &v[step1]);
    dv7vmp_(n, &v[dg1], &v[dg1], &d__[1], &c_n1);
    dl7tvm_(n, &v[step1], &v[l], &v[dg1]);
    v[44] = dv2nrm_(n, &v[step1]);
    iv[33] = 0;
L160:
    dd7dog_(&v[dg1], lv, n, &v[nwtst1], &v[step1], &v[1]);
    if (iv[29] != 6) {
	goto L170;
    }
    if (iv[9] != 2) {
	goto L190;
    }
    rstrst = 2;
    goto L200;

/*  ***  CHECK WHETHER EVALUATING F(X0 + STEP) LOOKS WORTHWHILE  *** */

L170:
    iv[2] = 0;
    if (v[2] <= 0.) {
	goto L190;
    }
    if (iv[29] != 5) {
	goto L180;
    }
    if (v[16] <= 1.) {
	goto L180;
    }
    if (v[7] > v[11] * 1.2) {
	goto L180;
    }
    if (iv[9] != 2) {
	goto L190;
    }
    rstrst = 0;
    goto L200;

/*  ***  COMPUTE F(X0 + STEP)  *** */

L180:
    x01 = iv[43];
    step1 = iv[40];
    dv2axy_(n, &x[1], &c_b33, &v[step1], &v[x01]);
    ++iv[6];
    iv[1] = 1;
    goto L999;

/* . . . . . . . . . . . . .  ASSESS CANDIDATE STEP  . . . . . . . . . . . */

L190:
    rstrst = 3;
L200:
    x01 = iv[43];
    v[17] = drldst_(n, &d__[1], &x[1], &v[x01]);
    da7sst_(&iv[1], liv, lv, &v[1]);
    step1 = iv[40];
    lstgst = iv[41];
    i__ = iv[9] + 1;
    switch (i__) {
	case 1:  goto L240;
	case 2:  goto L210;
	case 3:  goto L220;
	case 4:  goto L230;
    }
L210:
    dv7cpy_(n, &x[1], &v[x01]);
    goto L240;
L220:
    dv7cpy_(n, &v[lstgst], &v[step1]);
    goto L240;
L230:
    dv7cpy_(n, &v[step1], &v[lstgst]);
    dv2axy_(n, &x[1], &c_b33, &v[step1], &v[x01]);
    v[17] = drldst_(n, &d__[1], &x[1], &v[x01]);
    iv[9] = rstrst;

L240:
    k = iv[29];
    switch (k) {
	case 1:  goto L250;
	case 2:  goto L280;
	case 3:  goto L280;
	case 4:  goto L280;
	case 5:  goto L250;
	case 6:  goto L260;
	case 7:  goto L270;
	case 8:  goto L270;
	case 9:  goto L270;
	case 10:  goto L270;
	case 11:  goto L270;
	case 12:  goto L270;
	case 13:  goto L330;
	case 14:  goto L300;
    }

/*     ***  RECOMPUTE STEP WITH CHANGED RADIUS  *** */

L250:
    v[8] = v[16] * v[2];
    goto L110;

/*  ***  COMPUTE STEP OF LENGTH V(LMAXS) FOR SINGULAR CONVERGENCE TEST. */

L260:
    v[8] = v[36];
    goto L150;

/*  ***  CONVERGENCE OR FALSE CONVERGENCE  *** */

L270:
    iv[55] = k - 4;
    if (v[10] >= v[13]) {
	goto L340;
    }
    if (iv[13] == 14) {
	goto L340;
    }
    iv[13] = 14;

/* . . . . . . . . . . . .  PROCESS ACCEPTABLE STEP  . . . . . . . . . . . */

L280:
    if (iv[29] != 3) {
	goto L290;
    }
    step1 = iv[40];
    temp1 = iv[41];

/*     ***  SET  TEMP1 = HESSIAN * STEP  FOR USE IN GRADIENT TESTS  *** */

    l = iv[42];
    dl7tvm_(n, &v[temp1], &v[l], &v[step1]);
    dl7vml_(n, &v[temp1], &v[l], &v[temp1]);

/*  ***  COMPUTE GRADIENT  *** */

L290:
    ++iv[30];
    iv[1] = 2;
    goto L999;

/*  ***  INITIALIZATIONS -- G0 = G - G0, ETC.  *** */

L300:
    g01 = iv[48];
    dv2axy_(n, &v[g01], &c_b44, &v[g01], &g[1]);
    step1 = iv[40];
    temp1 = iv[41];
    if (iv[29] != 3) {
	goto L320;
    }

/*  ***  SET V(RADFAC) BY GRADIENT TESTS  *** */

/*     ***  SET  TEMP1 = DIAG(D)**-1 * (HESSIAN*STEP + (G(X0)-G(X)))  *** */

    dv2axy_(n, &v[temp1], &c_b44, &v[g01], &v[temp1]);
    dv7vmp_(n, &v[temp1], &v[temp1], &d__[1], &c_n1);

/*        ***  DO GRADIENT TESTS  *** */

    if (dv2nrm_(n, &v[temp1]) <= v[1] * v[29]) {
	goto L310;
    }
    if (dd7tpr_(n, &g[1], &v[step1]) >= v[4] * v[30]) {
	goto L320;
    }
L310:
    v[16] = v[23];

/*  ***  UPDATE H, LOOP  *** */

L320:
    w = iv[34];
    z__ = iv[43];
    l = iv[42];
    dw7zbf_(&v[l], n, &v[step1], &v[w], &v[g01], &v[z__]);

/*     ** USE THE N-VECTORS STARTING AT V(STEP1) AND V(G01) FOR SCRATCH.. */
    dl7upd_(&v[temp1], &v[step1], &v[l], &v[g01], &v[l], n, &v[w], &v[z__]);
    iv[1] = 2;
    goto L80;

/* . . . . . . . . . . . . . .  MISC. DETAILS  . . . . . . . . . . . . . . */

/*  ***  BAD PARAMETERS TO ASSESS  *** */

L330:
    iv[1] = 64;
    goto L350;

/*  ***  PRINT SUMMARY OF FINAL ITERATION AND OTHER REQUESTED ITEMS  *** */

L340:
    iv[1] = iv[55];
    iv[55] = 0;
L350:
    ditsum_(&d__[1], &g[1], &iv[1], liv, lv, n, &v[1], &x[1]);

L999:
    return 0;

/*  ***  LAST LINE OF DRMNG FOLLOWS  *** */
} /* drmng_ */

