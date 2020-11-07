/* retsrc.f -- translated by f2c (version 20100827).
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
static logical c_true = TRUE_;
static integer c__0 = 0;
static logical c_false = FALSE_;

/* Subroutine */ int retsrc_(integer *irold)
{
    /* Builtin functions */
    /* Subroutine */ int s_stop(char *, ftnlen);

    /* Local variables */
    static integer itemp;
    extern integer i8save_(integer *, integer *, logical *);
    extern /* Subroutine */ int eprint_(void), seterr_(char *, integer *, 
	    integer *, integer *, ftnlen);


/*  THIS ROUTINE SETS LRECOV = IROLD. */

/*  IF THE CURRENT ERROR BECOMES UNRECOVERABLE, */
/*  THE MESSAGE IS PRINTED AND EXECUTION STOPS. */

/*  ERROR STATES - */

/*    1 - ILLEGAL VALUE OF IROLD. */

/* /6S */
/*     IF (IROLD.LT.1 .OR. IROLD.GT.2) */
/*    1  CALL SETERR(31HRETSRC - ILLEGAL VALUE OF IROLD,31,1,2) */
/* /7S */
    if (*irold < 1 || *irold > 2) {
	seterr_("RETSRC - ILLEGAL VALUE OF IROLD", &c__31, &c__1, &c__2, (
		ftnlen)31);
    }
/* / */

    itemp = i8save_(&c__2, irold, &c_true);

/*  IF THE CURRENT ERROR IS NOW UNRECOVERABLE, PRINT AND STOP. */

    if (*irold == 1 || i8save_(&c__1, &c__0, &c_false) == 0) {
	return 0;
    }

    eprint_();
    s_stop("", (ftnlen)0);

    return 0;
} /* retsrc_ */

