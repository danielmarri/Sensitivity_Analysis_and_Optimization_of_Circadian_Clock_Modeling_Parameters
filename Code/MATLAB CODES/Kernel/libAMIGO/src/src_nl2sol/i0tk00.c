/* i0tk00.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int i0tk00_(logical *larg, integer *nitems, integer *itype)
{
    /* Initialized data */

    static logical init = FALSE_;

    /* System generated locals */
    integer i__1;

    /* Local variables */
#define lmax ((integer *)&cstak_1 + 3)
#define lnow ((integer *)&cstak_1 + 1)
#define lout ((integer *)&cstak_1)
#define lbook ((integer *)&cstak_1 + 4)
#define istak ((integer *)&cstak_1)
#define lused ((integer *)&cstak_1 + 2)
#define isize ((integer *)&cstak_1 + 5)


/*  INITIALIZES THE STACK TO NITEMS OF TYPE ITYPE */





    *larg = FALSE_;
    if (init) {
	return 0;
    }

/*  HERE TO INITIALIZE */

    init = TRUE_;

/*  SET DATA SIZES APPROPRIATE FOR A STANDARD CONFORMING */
/*  FORTRAN SYSTEM USING THE FORTRAN STORAGE UNIT AS THE */
/*  MEASURE OF SIZE. */

/*  LOGICAL */
    isize[0] = 1;
/*  INTEGER */
    isize[1] = 1;
/*  REAL */
    isize[2] = 1;
/*  DOUBLE PRECISION */
    isize[3] = 2;
/*  COMPLEX */
    isize[4] = 2;

    *lbook = 10;
    *lnow = *lbook;
    *lused = *lbook;
/* Computing MAX */
    i__1 = *nitems * isize[*itype - 1] / isize[1];
    *lmax = max(i__1,12);
    *lout = 0;

    return 0;

} /* i0tk00_ */

#undef isize
#undef lused
#undef istak
#undef lbook
#undef lout
#undef lnow
#undef lmax


