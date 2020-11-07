/* dsmnfb.f -- translated by f2c (version 20100827).
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

/* Common Block Declarations */

struct {
    doublereal dstak[500];
} cstak_;

#define cstak_1 cstak_

/* Table of constant values */

static integer c__0 = 0;
static integer c__14 = 14;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__19 = 19;
static integer c__18 = 18;
static integer c__3 = 3;
static integer c__4 = 4;
static integer c__26 = 26;
static integer c__27 = 27;
static integer c__5 = 5;
static integer c__24 = 24;
static integer c__6 = 6;
static integer c__32 = 32;
static integer c__7 = 7;
static integer c__43 = 43;
static integer c__8 = 8;

/* Subroutine */ int dsmnfb_(integer *p, doublereal *x, doublereal *b, U_fp 
	calcf, integer *mxfcal, doublereal *acc)
{
    /* System generated locals */
    integer i__1;
    doublereal d__1;

    /* Local variables */
    static integer i__, j, v1, id, iu, iv, lv;
    static doublereal ur;
    static integer idi, liv, idm1;
    extern /* Subroutine */ int dmnfb_(integer *, doublereal *, doublereal *, 
	    doublereal *, U_fp, integer *, integer *, integer *, doublereal *,
	     integer *, doublereal *, U_fp), leave_(void);
#define istak ((integer *)&cstak_1)
    extern /* Subroutine */ int enter_(integer *);
    extern /* Subroutine */ int dc6lcf_();
    extern /* Subroutine */ int divset_(integer *, integer *, integer *, 
	    integer *, doublereal *), seterr_(char *, integer *, integer *, 
	    integer *, ftnlen);
    extern integer istkgt_(integer *, integer *);


/* ** SIMPLIED VERSION OF DMNF */

/* INPUT PARAMETERS */
/* P    NUMBER OF UNKNOWNS */
/* X    APPROXIMATE SOLUTION */
/* B    FIRST ROW OF B GIVES LOWER BOUNDS ON X AND SECOND GIVES UPPER */
/*      BOUNDS */
/* CALCF SUBROUTINE TO EVALUATE FUNCTION */
/* MXFCAL MAXIMUM NUMBER OF PERMITTED FUNCTION EVALUATIONS */
/* ACC   ACCURACY IN X */
/* OUTPUT PARAMETERS */
/* X     SOLUTION */



/*  ***  LOCAL VARIABLES  *** */


/*  ***  BODY  *** */

    /* Parameter adjustments */
    b -= 3;
    --x;

    /* Function Body */
    enter_(&c__0);
/* /6S */
/*     IF (P.LT.1) */
/*    1CALL SETERR(14HDSMNFB- P.LT.1,14,1,2) */
/*     IF (MXFCAL.LT.1) */
/*    1CALL SETERR(19HDSMNFB- MXFCAL.LT.1,19,2,2) */
/*     IF (ACC.LT.0.0D0) */
/*    1CALL SETERR(18HDSMNFB-ACC .LT.0.0,18,3,2) */
/* /7S */
    if (*p < 1) {
	seterr_("DSMNFB- P.LT.1", &c__14, &c__1, &c__2, (ftnlen)14);
    }
    if (*mxfcal < 1) {
	seterr_("DSMNFB- MXFCAL.LT.1", &c__19, &c__2, &c__2, (ftnlen)19);
    }
    if (*acc < 0.) {
	seterr_("DSMNFB-ACC .LT.0.0", &c__18, &c__3, &c__2, (ftnlen)18);
    }
/* / */
    liv = *p + 59;
    lv = *p * (*p + 23) / 2 + 77;
    iv = istkgt_(&liv, &c__2);
    v1 = istkgt_(&lv, &c__4);
    divset_(&c__2, &istak[iv - 1], &liv, &lv, &cstak_1.dstak[v1 - 1]);
    istak[iv + 19] = 0;
    istak[iv + 15] = *mxfcal;
    istak[iv + 16] = *mxfcal;
    cstak_1.dstak[v1 + 31] = *acc;
    cstak_1.dstak[v1 + 30] = *acc;
    id = istkgt_(p, &c__4);
    idm1 = id - 1;
    i__1 = *p;
    for (i__ = 1; i__ <= i__1; ++i__) {
	idi = idm1 + i__;
	cstak_1.dstak[idi - 1] = 1.f;
	if (x[i__] != 0.f) {
	    cstak_1.dstak[idi - 1] = 1.f / (d__1 = x[i__], abs(d__1));
	}
/* L10: */
    }
    dmnfb_(p, &cstak_1.dstak[id - 1], &x[1], &b[3], (U_fp)dc6lcf_, &istak[iv 
	    - 1], &liv, &lv, &cstak_1.dstak[v1 - 1], &iu, &ur, (U_fp)calcf);
    j = istak[iv - 1];
    if (j < 7) {
	goto L20;
    }
/* /6S */
/*     IF (J.EQ.82)CALL SETERR(26HDSMNFB-INCONSISTENT BOUNDS,26,4,1) */
/*     IF (J.EQ.7)CALL SETERR(27HDSMNFB-SINGULAR CONVERGENCE,27,5,1) */
/*     IF(J.EQ.8)CALL SETERR(24HDSMNFB-FALSE CONVERGENCE,24,6,1) */
/*     IF(J.EQ.9)CALL SETERR(32HDSMNFB-FUNCTION EVALUATION LIMIT,32,7,1) */
/*     IF (J.EQ.63) */
/*    1CALL SETERR(43HDSMNFB-F(X) CANNOT BE COMPUTED AT INITIAL X,43,8,1) */
/* /7S */
    if (j == 82) {
	seterr_("DSMNFB-INCONSISTENT BOUNDS", &c__26, &c__4, &c__1, (ftnlen)
		26);
    }
    if (j == 7) {
	seterr_("DSMNFB-SINGULAR CONVERGENCE", &c__27, &c__5, &c__1, (ftnlen)
		27);
    }
    if (j == 8) {
	seterr_("DSMNFB-FALSE CONVERGENCE", &c__24, &c__6, &c__1, (ftnlen)24);
    }
    if (j == 9) {
	seterr_("DSMNFB-FUNCTION EVALUATION LIMIT", &c__32, &c__7, &c__1, (
		ftnlen)32);
    }
    if (j == 63) {
	seterr_("DSMNFB-F(X) CANNOT BE COMPUTED AT INITIAL X", &c__43, &c__8, 
		&c__1, (ftnlen)43);
    }
/* / */
L20:
    leave_();

    return 0;
/*  *** LAST LINE OF  DSMNFB FOLLOWS  *** */
} /* dsmnfb_ */

#undef istak


