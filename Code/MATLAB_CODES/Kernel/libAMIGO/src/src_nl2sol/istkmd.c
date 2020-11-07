/* istkmd.f -- translated by f2c (version 20100827).
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

static integer c__1 = 1;
static integer c__35 = 35;
static integer c__2 = 2;

integer istkmd_(integer *nitems)
{
    /* System generated locals */
    integer ret_val;

    /* Local variables */
#define lnow ((integer *)&cstak_1 + 1)
#define istak ((integer *)&cstak_1)
    static integer itype, lnowo;
    extern /* Subroutine */ int seterr_(char *, integer *, integer *, integer 
	    *, ftnlen);
    extern integer istkgt_(integer *, integer *);
    extern /* Subroutine */ int istkrl_(integer *);


/*  CHANGES THE LENGTH OF THE FRAME AT THE TOP OF THE STACK */
/*  TO NITEMS. */

/*  ERROR STATES - */

/*    1 - LNOW OVERWRITTEN */
/*    2 - ISTAK(LNOWO-1) OVERWRITTEN */




    lnowo = *lnow;
    istkrl_(&c__1);

    itype = istak[lnowo - 2];

/* /6S */
/*     IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR */
/*    1   (35HISTKMD - ISTAK(LNOWO-1) OVERWRITTEN,35,1,2) */
/* /7S */
    if (itype <= 0 || itype >= 6) {
	seterr_("ISTKMD - ISTAK(LNOWO-1) OVERWRITTEN", &c__35, &c__1, &c__2, (
		ftnlen)35);
    }
/* / */

    ret_val = istkgt_(nitems, &itype);

    return ret_val;

} /* istkmd_ */

#undef istak
#undef lnow


