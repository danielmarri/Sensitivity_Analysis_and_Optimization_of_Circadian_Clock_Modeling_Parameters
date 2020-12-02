/* eprint.f -- translated by f2c (version 20100827).
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

static integer c__1 = 1;
static logical c_false = FALSE_;

/* Subroutine */ int eprint_(void)
{
    static char messg[1*1];
    extern /* Subroutine */ int e9rint_(char *, integer *, integer *, logical 
	    *, ftnlen);


/*  THIS SUBROUTINE PRINTS THE LAST ERROR MESSAGE, IF ANY. */

/* /6S */
/*     INTEGER MESSG(1) */
/* /7S */
/* / */

    e9rint_(messg, &c__1, &c__1, &c_false, (ftnlen)1);
    return 0;

} /* eprint_ */

