/* frmatr.f -- translated by f2c (version 20100827).
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

static integer c__10 = 10;
static integer c__11 = 11;
static integer c__12 = 12;
static integer c__13 = 13;

/* Subroutine */ int frmatr_(integer *wwidth, integer *ewidth)
{
    /* System generated locals */
    integer i__1, i__2;
    real r__1, r__2;

    /* Builtin functions */
    double r_lg10(real *);

    /* Local variables */
    static real base;
    extern integer iflr_(real *), iceil_(real *);
    static integer demin, demax;
    extern integer i1mach_(integer *);
    static integer expwid;


/*  THIS SUBROUTINE COMPUTES, FOR THE FORMAT SPECIFICATION, EW.E, THE */
/*  NUMBER OF DIGITS TO THE RIGHT OF THE DECIMAL POINT, E=EWIDTH, AND */
/*  THE FIELD WIDTH, W=WWIDTH. */

/*  WWIDTH INCLUDES THE FIVE POSITIONS NEEDED FOR THE SIGN OF THE */
/*  MANTISSA, THE SIGN OF THE EXPONENT, THE 0, THE DECIMAL POINT AND THE */
/*  CHARACTER IN THE OUTPUT - +0.XXXXXXXXXE+YYYY */

/*  THE FOLLOWING MACHINE-DEPENDENT VALUES ARE USED - */

/*  I1MACH(10) - THE BASE, B */
/*  I1MACH(11) - THE NUMBER OF BASE-B DIGITS IN THE MANTISSA */
/*  I1MACH(12) - THE SMALLEST EXPONENT, EMIN */
/*  I1MACH(13) - THE LARGEST EXPONENT, EMAX */


    base = (real) i1mach_(&c__10);

    r__1 = r_lg10(&base) * (real) i1mach_(&c__11);
    *ewidth = iceil_(&r__1);

    r__1 = r_lg10(&base) * (real) (i1mach_(&c__12) - 1);
    demin = iflr_(&r__1) + 1;
    r__1 = r_lg10(&base) * (real) i1mach_(&c__13);
    demax = iceil_(&r__1);
/* Computing MAX */
    i__1 = abs(demin), i__2 = abs(demax);
    r__2 = (real) max(i__1,i__2);
    r__1 = r_lg10(&r__2);
    expwid = iflr_(&r__1) + 1;
    *wwidth = *ewidth + expwid + 5;

    return 0;
} /* frmatr_ */

