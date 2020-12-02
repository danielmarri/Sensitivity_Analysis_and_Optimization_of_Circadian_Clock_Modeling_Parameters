/* dxtrap.f -- translated by f2c (version 20100827).
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
    doublereal ds[500];
} cstak_;

#define cstak_1 cstak_

/* Table of constant values */

static integer c__15 = 15;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__18 = 18;
static integer c__19 = 19;
static integer c__3 = 3;
static integer c__4 = 4;
static integer c__38 = 38;
static integer c__5 = 5;

/* Subroutine */ int dxtrap_(doublereal *tm, integer *m, integer *nvar, 
	doublereal *ng, integer *kmax, logical *xpoly, doublereal *t, real *
	error, real *ebest)
{
    /* System generated locals */
    integer t_dim1, t_offset, error_dim1, error_offset, i__1, i__2;

    /* Local variables */
    static integer i__;
#define rs ((real *)&cstak_1)
#define ws ((doublereal *)&cstak_1)
    static integer irhg, iemag;
    static logical esave;
    extern /* Subroutine */ int d0xtrp_(doublereal *, integer *, integer *, 
	    doublereal *, integer *, logical *, doublereal *, real *, real *, 
	    doublereal *, real *, logical *), seterr_(char *, integer *, 
	    integer *, integer *, ftnlen);
    extern integer istkgt_(integer *, integer *);
    extern /* Subroutine */ int istkrl_(integer *);


/*  ASSUME AN EXPANSION FOR THE VECTOR VALUED FUNCTION T(H) OF THE FORM */

/*            T(H) = T(0) + SUM(J=1,2,3,...)(A(J)*H**(J*GAMMA)) */

/*  WHERE THE A(J) ARE CONSTANT VECTORS AND GAMMA IS A POSITIVE CONSTANT. */

/*  GIVEN T(H(M)), WHERE H(M)=H0/N(M), M=1,2,3,..., THIS ROUTINE USES */
/*  POLYNOMIAL (XPOLY), OR RATIONAL (.NOT.XPOLY), EXTRAPOLATION TO */
/*  SEQUENTIALLY APPROXIMATE T(0). */

/*  INPUT */

/*    TM     - TM = T(H(M)) FOR THIS CALL. */
/*    M      - H(M) WAS USED TO OBTAIN TM. */
/*    NVAR   - THE LENGTH OF THE VECTOR TM. */
/*    NG     - THE DOUBLE PRECISION VALUES */

/*                 NG(I) = N(I)**GAMMA */

/*             FOR I=1,...,M. NG MUST BE A MONOTONE INCREASING ARRAY. */
/*    KMAX   - THE MAXIMUM NUMBER OF COLUMNS TO BE USED IN THE */
/*             EXTRAPOLATION PROCESS. */
/*    XPOLY  - IF XPOLY=.TRUE., THEN USE POLYNOMIAL EXTRAPOLATION. */
/*             IF XPOLY=.FALSE., THEN USE RATIONAL EXTRAPOLATION. */
/*    T      - THE BOTTOM EDGE OF THE EXTRAPOLATION LOZENGE. */
/*             T(I,J) SHOULD CONTAIN THE J-TH EXTRAPOLATE OF THE I-TH */
/*             COMPONENT OF T(H) BASED ON THE SEQUENCE H(1),...,H(M-1), */
/*             FOR I=1,...,NVAR AND J=1,...,MIN(M-1,KMAX). */

/*             WHEN M=1, T MAY CONTAIN ANYTHING. */

/*             FOR M.GT.1, NOTE THAT THE OUTPUT VALUE OF T AT THE */
/*             (M-1)-ST CALL IS THE INPUT FOR THE M-TH CALL. */
/*             THUS, THE USER NEED NEVER PUT ANYTHING INTO T, */
/*             BUT HE CAN NOT ALTER ANY ELEMENT OF T BETWEEN */
/*             CALLS TO DXTRAP. */

/*  OUTPUT */

/*    TM     - TM(I)=THE MOST ACCURATE APPROXIMATION IN THE LOZENGE */
/*             FOR THE I-TH VARIABLE, I=1,...,NVAR. */
/*    T      - T(I,J) CONTAINS THE J-TH EXTRAPOLATE OF THE I-TH */
/*             COMPONENT OF T(H) BASED ON THE SEQUENCE H(1),...,H(M), */
/*             FOR I=1,...,NVAR AND J=1,...,MIN(M,KMAX). */
/*    ERROR  - ERROR(I,J) GIVES THE SIGNED BULIRSCH-STOER ESTIMATE OF THE */
/*             ERROR IN THE J-TH EXTRAPOLATE OF THE I-TH COMPONENT OF */
/*             T(H) BASED ON THE SEQUENCE H(1),...,H(M-1), */
/*             FOR I=1,...,NVAR AND J=1,...,MIN(M-1,KMAX). */
/*             IF ERROR=EBEST AS ARRAYS, THEN THE ABOVE ELEMENTS */
/*             ARE NOT STORED. RATHER, EBEST=ERROR IS LOADED AS DESCRIBED */
/*             BELOW. */
/*    EBEST  - EBEST(I)=THE ABSOLUTE VALUE OF THE ERROR IN TM(I), */
/*             I=1,...,NVAR. THIS ARRAY IS FULL OF GARBAGE WHEN M=1. */

/*  SCRATCH SPACE ALLOCATED - MIN(M-1,KMAX) DOUBLE PRECISION WORDS + */

/*                            MIN(M-1,KMAX) INTEGER WORDS. */

/*  ERROR STATES - */

/*    1 - M.LT.1. */
/*    2 - NVAR.LT.1. */
/*    3 - NG(1).LT.1. */
/*    4 - KMAX.LT.1. */
/*    5 - NG IS NOT MONOTONE INCREASING. */

/*     DOUBLE PRECISION T(NVAR,MIN(M,KMAX)) */
/*     REAL ERROR(NVAR,MIN(M-1,KMAX)) */



/* ... CHECK THE INPUT. */

/* /6S */
/*     IF (M.LT.1) CALL SETERR(15HDXTRAP - M.LT.1,15,1,2) */
/*     IF (NVAR.LT.1) CALL SETERR(18HDXTRAP - NVAR.LT.1,18,2,2) */
/*     IF (NG(1).LT.1.0D0) CALL SETERR(19HDXTRAP - NG(1).LT.1,19,3,2) */
/*     IF (KMAX.LT.1) CALL SETERR(18HDXTRAP - KMAX.LT.1,18,4,2) */
/* /7S */
    /* Parameter adjustments */
    --ng;
    --ebest;
    error_dim1 = *nvar;
    error_offset = 1 + error_dim1;
    error -= error_offset;
    t_dim1 = *nvar;
    t_offset = 1 + t_dim1;
    t -= t_offset;
    --tm;

    /* Function Body */
    if (*m < 1) {
	seterr_("DXTRAP - M.LT.1", &c__15, &c__1, &c__2, (ftnlen)15);
    }
    if (*nvar < 1) {
	seterr_("DXTRAP - NVAR.LT.1", &c__18, &c__2, &c__2, (ftnlen)18);
    }
    if (ng[1] < 1.) {
	seterr_("DXTRAP - NG(1).LT.1", &c__19, &c__3, &c__2, (ftnlen)19);
    }
    if (*kmax < 1) {
	seterr_("DXTRAP - KMAX.LT.1", &c__18, &c__4, &c__2, (ftnlen)18);
    }
/* / */

    if (*m == 1) {
	goto L20;
    }

    i__1 = *m;
    for (i__ = 2; i__ <= i__1; ++i__) {
/* /6S */
/*        IF (NG(I-1).GE.NG(I)) CALL SETERR */
/*    1      (38HDXTRAP - NG IS NOT MONOTONE INCREASING,38,5,2) */
/* /7S */
	if (ng[i__ - 1] >= ng[i__]) {
	    seterr_("DXTRAP - NG IS NOT MONOTONE INCREASING", &c__38, &c__5, &
		    c__2, (ftnlen)38);
	}
/* / */
/* L10: */
    }

/* ... SEE IF ERROR=EBEST AS ARRAYS. IF (ESAVE), THEN LOAD ERROR. */

L20:
    error[error_dim1 + 1] = 1.f;
    ebest[1] = 2.f;
    esave = error[error_dim1 + 1] != ebest[1];

/* ... ALLOCATE SCRATCH SPACE. */

    irhg = 1;
    iemag = 1;
    if (*m > 1) {
/* Computing MIN */
	i__2 = *m - 1;
	i__1 = min(i__2,*kmax);
	irhg = istkgt_(&i__1, &c__4);
    }
    if (*m > 1) {
/* Computing MIN */
	i__2 = *m - 1;
	i__1 = min(i__2,*kmax);
	iemag = istkgt_(&i__1, &c__3);
    }

    d0xtrp_(&tm[1], m, nvar, &ng[1], kmax, xpoly, &t[t_offset], &error[
	    error_offset], &ebest[1], &ws[irhg - 1], &rs[iemag - 1], &esave);

    if (*m > 1) {
	istkrl_(&c__2);
    }

    return 0;

} /* dxtrap_ */

#undef ws
#undef rs


