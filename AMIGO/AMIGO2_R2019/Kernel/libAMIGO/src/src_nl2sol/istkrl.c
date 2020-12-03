/* istkrl.f -- translated by f2c (version 20100827).
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

static integer c__500 = 500;
static integer c__4 = 4;
static integer c__20 = 20;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__47 = 47;
static integer c__55 = 55;
static integer c__3 = 3;

/* Subroutine */ int istkrl_(integer *number)
{
    /* Initialized data */

    static logical init = TRUE_;

    /* Local variables */
    static integer in;
#define lmax ((integer *)&cstak_1 + 3)
#define lnow ((integer *)&cstak_1 + 1)
#define lout ((integer *)&cstak_1)
    extern /* Subroutine */ int i0tk00_(logical *, integer *, integer *);
#define lbook ((integer *)&cstak_1 + 4)
#define istak ((integer *)&cstak_1)
#define lused ((integer *)&cstak_1 + 2)
    extern /* Subroutine */ int seterr_(char *, integer *, integer *, integer 
	    *, ftnlen);


/*  DE-ALLOCATES THE LAST (NUMBER) ALLOCATIONS MADE IN THE STACK */
/*  BY ISTKGT. */

/*  ERROR STATES - */

/*    1 - NUMBER .LT. 0 */
/*    2 - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN */
/*    3 - ATTEMPT TO DE-ALLOCATE NON-EXISTENT ALLOCATION */
/*    4 - THE POINTER AT ISTAK(LNOW) OVERWRITTEN */





    if (init) {
	i0tk00_(&init, &c__500, &c__4);
    }

/* /6S */
/*     IF (NUMBER.LT.0) CALL SETERR(20HISTKRL - NUMBER.LT.0,20,1,2) */
/* /7S */
    if (*number < 0) {
	seterr_("ISTKRL - NUMBER.LT.0", &c__20, &c__1, &c__2, (ftnlen)20);
    }
/* / */

/* /6S */
/*     IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR */
/*    1   (47HISTKRL - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN, */
/*    2    47,2,2) */
/* /7S */
    if (*lnow < *lbook || *lnow > *lused || *lused > *lmax) {
	seterr_("ISTKRL - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN", &c__47, &
		c__2, &c__2, (ftnlen)47);
    }
/* / */

    in = *number;
L10:
    if (in == 0) {
	return 0;
    }

/* /6S */
/*        IF (LNOW.LE.LBOOK) CALL SETERR */
/*    1   (55HISTKRL - ATTEMPT TO DE-ALLOCATE NON-EXISTENT ALLOCATION, */
/*    2    55,3,2) */
/* /7S */
    if (*lnow <= *lbook) {
	seterr_("ISTKRL - ATTEMPT TO DE-ALLOCATE NON-EXISTENT ALLOCATION", &
		c__55, &c__3, &c__2, (ftnlen)55);
    }
/* / */

/*     CHECK TO MAKE SURE THE BACK POINTERS ARE MONOTONE. */

/* /6S */
/*        IF (ISTAK(LNOW).LT.LBOOK.OR.ISTAK(LNOW).GE.LNOW-1) CALL SETERR */
/*    1   (47HISTKRL - THE POINTER AT ISTAK(LNOW) OVERWRITTEN, */
/*    2    47,4,2) */
/* /7S */
    if (istak[*lnow - 1] < *lbook || istak[*lnow - 1] >= *lnow - 1) {
	seterr_("ISTKRL - THE POINTER AT ISTAK(LNOW) OVERWRITTEN", &c__47, &
		c__4, &c__2, (ftnlen)47);
    }
/* / */

    --(*lout);
    *lnow = istak[*lnow - 1];
    --in;
    goto L10;

} /* istkrl_ */

#undef lused
#undef istak
#undef lbook
#undef lout
#undef lnow
#undef lmax


