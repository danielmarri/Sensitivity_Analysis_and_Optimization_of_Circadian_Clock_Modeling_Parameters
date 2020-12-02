/* enter.f -- translated by f2c (version 20100827).
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
    doublereal dstack[500];
} cstak_;

#define cstak_1 cstak_

/* Table of constant values */

static integer c__35 = 35;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__3 = 3;

/* Subroutine */ int enter_(integer *irnew)
{
    /* Local variables */
    static integer inow;
#define lout ((integer *)&cstak_1)
    extern integer i8tsel_(integer *);
#define istack ((integer *)&cstak_1)
    extern /* Subroutine */ int entsrc_(integer *, integer *), seterr_(char *,
	     integer *, integer *, integer *, ftnlen);
    extern integer istkgt_(integer *, integer *);


/*  THIS ROUTINE SAVES */

/*    1) THE CURRENT NUMBER OF OUTSTANDING STORAGE ALLOCATIONS, LOUT, AND */
/*    2) THE CURRENT RECOVERY LEVEL, LRECOV, */

/*  IN AN ENTER-BLOCK IN THE STACK. */

/*  IT ALSO SETS LRECOV = IRNEW IF IRNEW = 1 OR 2. */
/*  IF IRNEW = 0, THEN THE RECOVERY LEVEL IS NOT ALTERED. */

/*  SCRATCH SPACE ALLOCATED - 3 INTEGER WORDS ARE LEFT ON THE STACK. */

/*  ERROR STATES - */

/*    1 - MUST HAVE IRNEW = 0, 1 OR 2. */


/* /6S */
/*     IF (0.GT.IRNEW .OR. IRNEW.GT.2) */
/*    1  CALL SETERR(35HENTER - MUST HAVE IRNEW = 0, 1 OR 2,35,1,2) */
/* /7S */
    if (0 > *irnew || *irnew > 2) {
	seterr_("ENTER - MUST HAVE IRNEW = 0, 1 OR 2", &c__35, &c__1, &c__2, (
		ftnlen)35);
    }
/* / */

/*  ALLOCATE SPACE FOR SAVING THE ABOVE 2 ITEMS */
/*  AND A BACK-POINTER FOR CHAINING THE ENTER-BLOCKS TOGETHER. */

    inow = istkgt_(&c__3, &c__2);

/*  SAVE THE CURRENT NUMBER OF OUTSTANDING ALLOCATIONS. */

    istack[inow - 1] = *lout;

/*  SAVE THE CURRENT RECOVERY LEVEL. */

    entsrc_(&istack[inow], irnew);

/*  SAVE A BACK-POINTER TO THE START OF THE PREVIOUS ENTER-BLOCK. */

    istack[inow + 1] = i8tsel_(&inow);

    return 0;

} /* enter_ */

#undef istack
#undef lout


