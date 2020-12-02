/* istkqu.f -- translated by f2c (version 20100827).
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
static integer c__47 = 47;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__33 = 33;

integer istkqu_(integer *itype)
{
    /* Initialized data */

    static logical init = TRUE_;

    /* System generated locals */
    integer ret_val, i__1;

    /* Local variables */
#define lmax ((integer *)&cstak_1 + 3)
#define lnow ((integer *)&cstak_1 + 1)
    extern /* Subroutine */ int i0tk00_(logical *, integer *, integer *);
#define lbook ((integer *)&cstak_1 + 4)
#define istak ((integer *)&cstak_1)
#define lused ((integer *)&cstak_1 + 2)
#define isize ((integer *)&cstak_1 + 5)
    extern /* Subroutine */ int seterr_(char *, integer *, integer *, integer 
	    *, ftnlen);


/*  RETURNS THE NUMBER OF ITEMS OF TYPE ITYPE THAT REMAIN */
/*  TO BE ALLOCATED IN ONE REQUEST. */

/*  ERROR STATES - */

/*    1 - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN */
/*    2 - ITYPE .LE. 0 .OR. ITYPE .GE. 6 */






    if (init) {
	i0tk00_(&init, &c__500, &c__4);
    }

/* /6S */
/*     IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR */
/*    1   (47HISTKQU - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN, */
/*    2    47,1,2) */
/* /7S */
    if (*lnow < *lbook || *lnow > *lused || *lused > *lmax) {
	seterr_("ISTKQU - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN", &c__47, &
		c__1, &c__2, (ftnlen)47);
    }
/* / */

/* /6S */
/*     IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR */
/*    1   (33HISTKQU - ITYPE.LE.0.OR.ITYPE.GE.6,33,2,2) */
/* /7S */
    if (*itype <= 0 || *itype >= 6) {
	seterr_("ISTKQU - ITYPE.LE.0.OR.ITYPE.GE.6", &c__33, &c__2, &c__2, (
		ftnlen)33);
    }
/* / */

/* Computing MAX */
    i__1 = (*lmax - 2) * isize[1] / isize[*itype - 1] - (*lnow * isize[1] - 1)
	     / isize[*itype - 1] - 1;
    ret_val = max(i__1,0);

    return ret_val;

} /* istkqu_ */

#undef isize
#undef lused
#undef istak
#undef lbook
#undef lnow
#undef lmax


