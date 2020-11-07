/* i10wid.f -- translated by f2c (version 20100827).
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

integer i10wid_(integer *ix)
{
    /* System generated locals */
    integer ret_val;

    /* Local variables */
    static integer iy, digits;

/*     THIS FUNCTION RETURNS THE NUMBER OF DECIMAL */
/*     DIGITS REQUIRED TO REPRESENT THE INTEGER, IX. */
    digits = 0;
    iy = abs(*ix);
L1:
    if (iy < 1) {
	goto L2;
    }
    ++digits;
    iy /= 10;
    goto L1;
L2:
    ret_val = digits;
    return ret_val;
} /* i10wid_ */

