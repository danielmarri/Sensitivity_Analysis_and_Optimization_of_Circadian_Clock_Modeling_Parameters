/* entsrc.f -- translated by f2c (version 20100827).
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

static integer c__31 = 31;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__0 = 0;
static logical c_false = FALSE_;
static integer c__39 = 39;

/* Subroutine */ int entsrc_(integer *irold, integer *irnew)
{
    /* System generated locals */
    logical L__1;

    /* Local variables */
    extern integer i8save_(integer *, integer *, logical *);
    extern /* Subroutine */ int seterr_(char *, integer *, integer *, integer 
	    *, ftnlen);


/*  THIS ROUTINE RETURNS IROLD = LRECOV AND SETS LRECOV = IRNEW. */

/*  IF THERE IS AN ACTIVE ERROR STATE, THE MESSAGE IS PRINTED */
/*  AND EXECUTION STOPS. */

/*  IRNEW = 0 LEAVES LRECOV UNCHANGED, WHILE */
/*  IRNEW = 1 GIVES RECOVERY AND */
/*  IRNEW = 2 TURNS RECOVERY OFF. */

/*  ERROR STATES - */

/*    1 - ILLEGAL VALUE OF IRNEW. */
/*    2 - CALLED WHILE IN AN ERROR STATE. */

/* /6S */
/*     IF (IRNEW.LT.0 .OR. IRNEW.GT.2) */
/*    1   CALL SETERR(31HENTSRC - ILLEGAL VALUE OF IRNEW,31,1,2) */
/* /7S */
    if (*irnew < 0 || *irnew > 2) {
	seterr_("ENTSRC - ILLEGAL VALUE OF IRNEW", &c__31, &c__1, &c__2, (
		ftnlen)31);
    }
/* / */

    L__1 = *irnew != 0;
    *irold = i8save_(&c__2, irnew, &L__1);

/*  IF HAVE AN ERROR STATE, STOP EXECUTION. */

/* /6S */
/*     IF (I8SAVE(1,0,.FALSE.) .NE. 0) CALL SETERR */
/*    1   (39HENTSRC - CALLED WHILE IN AN ERROR STATE,39,2,2) */
/* /7S */
    if (i8save_(&c__1, &c__0, &c_false) != 0) {
	seterr_("ENTSRC - CALLED WHILE IN AN ERROR STATE", &c__39, &c__2, &
		c__2, (ftnlen)39);
    }
/* / */

    return 0;

} /* entsrc_ */

