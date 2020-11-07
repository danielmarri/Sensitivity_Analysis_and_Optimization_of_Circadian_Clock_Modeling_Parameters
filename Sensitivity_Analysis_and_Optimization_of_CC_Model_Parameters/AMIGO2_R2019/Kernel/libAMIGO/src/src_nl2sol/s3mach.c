/* s3mach.f -- translated by f2c (version 20100827).
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

doublereal s3mach_(doublereal *xd, integer *base, integer *exp__)
{
    /* System generated locals */
    doublereal ret_val;

    /* Local variables */
    static integer n;
    static doublereal tbase;


/* S3MACH = XD * BASE**EXP */

/*     (17-JUN-85) -- REVISED TO MAKE OVERFLOW LESS LIKELY */

    tbase = (real) (*base);
    ret_val = *xd;

    n = *exp__;
    if (n >= 0) {
	goto L20;
    }

    n = -n;
    tbase = 1. / tbase;

L20:
    if (n % 2 != 0) {
	ret_val *= tbase;
    }
    n /= 2;
    if (n < 2) {
	goto L30;
    }
    tbase *= tbase;
    goto L20;

L30:
    if (n == 1) {
	ret_val = ret_val * tbase * tbase;
    }
    return ret_val;

} /* s3mach_ */

