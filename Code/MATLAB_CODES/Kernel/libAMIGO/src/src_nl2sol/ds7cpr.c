/* ds7cpr.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int ds7cpr_(doublereal *c__, integer *iv, integer *l, 
	integer *liv)
{
    /* Format strings */
    static char fmt_10[] = "(/\002 LINEAR PARAMETERS...\002//(1x,i5,d16.6))";

    /* System generated locals */
    integer i__1;

    /* Builtin functions */
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void);

    /* Local variables */
    static integer i__, pu;

    /* Fortran I/O blocks */
    static cilist io___2 = { 0, 0, 0, fmt_10, 0 };



/*  ***  PRINT C FOR   DNSG (ETC.)  *** */




/* /6 */
/*     DATA PRUNIT/21/, SOLPRT/22/ */
/* /7 */
/* / */
/*  ***  BODY  *** */

    /* Parameter adjustments */
    --c__;
    --iv;

    /* Function Body */
    if (iv[1] > 11) {
	goto L999;
    }
    if (iv[22] == 0) {
	goto L999;
    }
    pu = iv[21];
    if (pu == 0) {
	goto L999;
    }
    if (*l > 0) {
	io___2.ciunit = pu;
	s_wsfe(&io___2);
	i__1 = *l;
	for (i__ = 1; i__ <= i__1; ++i__) {
	    do_fio(&c__1, (char *)&i__, (ftnlen)sizeof(integer));
	    do_fio(&c__1, (char *)&c__[i__], (ftnlen)sizeof(doublereal));
	}
	e_wsfe();
    }

L999:
    return 0;
/*  ***  LAST LINE OF DS7CPR FOLLOWS  *** */
} /* ds7cpr_ */

