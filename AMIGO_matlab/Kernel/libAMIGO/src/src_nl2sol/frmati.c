/* frmati.f -- translated by f2c (version 20100827).
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

static integer c__7 = 7;
static integer c__8 = 8;

/* Subroutine */ int frmati_(integer *iwidth)
{
    /* System generated locals */
    real r__1, r__2;

    /* Builtin functions */
    double r_lg10(real *);

    /* Local variables */
    extern integer iceil_(real *), i1mach_(integer *);


/*  THIS SUBROUTINE COMPUTES THE WIDTH, W=IWIDTH, IN THE FORMAT */
/*  SPECIFICATION FOR INTEGER VARIABLES. */

/*  FRMATI SETS IWIDTH TO THE NUMBER OF CHARACTER POSITIONS NEEDED */
/*  FOR WRITING OUT THE LARGEST INTEGER PLUS ONE POSITION FOR THE SIGN. */

/*  I1MACH(7) IS THE BASE, A, FOR INTEGER REPRESENTATION IN THE MACHINE. */
/*  I1MACH(8) IS THE (MAXIMUM) NUMBER OF BASE A DIGITS. */


    r__2 = (real) i1mach_(&c__7);
    r__1 = r_lg10(&r__2) * (real) i1mach_(&c__8);
    *iwidth = iceil_(&r__1) + 1;

    return 0;
} /* frmati_ */

