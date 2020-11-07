/* istkst.f -- translated by f2c (version 20100827).
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
static integer c__33 = 33;
static integer c__1 = 1;
static integer c__2 = 2;

integer istkst_(integer *nfact)
{
    /* Initialized data */

    static logical init = TRUE_;

    /* System generated locals */
    integer ret_val;

    /* Local variables */
    extern /* Subroutine */ int i0tk00_(logical *, integer *, integer *);
#define istak ((integer *)&cstak_1)
    extern /* Subroutine */ int seterr_(char *, integer *, integer *, integer 
	    *, ftnlen);
#define istats ((integer *)&cstak_1)


/*  RETURNS CONTROL INFORMATION AS FOLLOWS */

/*  NFACT    ITEM RETURNED */

/*    1         LOUT,  THE NUMBER OF CURRENT ALLOCATIONS */
/*    2         LNOW,  THE CURRENT ACTIVE LENGTH */
/*    3         LUSED, THE MAXIMUM USED */
/*    4         LMAX,  THE MAXIMUM ALLOWED */





    if (init) {
	i0tk00_(&init, &c__500, &c__4);
    }

/* /6S */
/*     IF (NFACT.LE.0.OR.NFACT.GE.5) CALL SETERR */
/*    1   (33HISTKST - NFACT.LE.0.OR.NFACT.GE.5,33,1,2) */
/* /7S */
    if (*nfact <= 0 || *nfact >= 5) {
	seterr_("ISTKST - NFACT.LE.0.OR.NFACT.GE.5", &c__33, &c__1, &c__2, (
		ftnlen)33);
    }
/* / */

    ret_val = istats[*nfact - 1];

    return ret_val;

} /* istkst_ */

#undef istats
#undef istak


