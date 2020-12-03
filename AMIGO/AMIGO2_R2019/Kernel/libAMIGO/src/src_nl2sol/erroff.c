/* erroff.f -- translated by f2c (version 20100827).
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
static integer c__0 = 0;
static logical c_true = TRUE_;

/* Subroutine */ int erroff_(void)
{
    static integer i__;
    extern integer i8save_(integer *, integer *, logical *);


/*  TURNS OFF THE ERROR STATE OFF BY SETTING LERROR=0. */

    i__ = i8save_(&c__1, &c__0, &c_true);
    return 0;

} /* erroff_ */

