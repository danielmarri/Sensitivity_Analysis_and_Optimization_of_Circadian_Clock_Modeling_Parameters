/* u9dmp.f -- translated by f2c (version 20100827).
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

/* Table of constant values */

static integer c__4 = 4;

/* Subroutine */ int u9dmp_(integer *lng, integer *ncol, integer *wi, integer 
	*wr, integer *dr, integer *wd, integer *dd)
{
    /* Format strings */
    static char fmt_1[] = "(\0020LOGICAL STACK\002)";
    static char fmt_2[] = "(\0020INTEGER STACK\002)";
    static char fmt_3[] = "(\0020REAL STACK\002)";
    static char fmt_4[] = "(\0020DOUBLE PRECISION STACK\002)";
    static char fmt_5[] = "(\0020COMPLEX STACK\002)";

    /* Builtin functions */
    integer s_wsfe(cilist *), e_wsfe(void);

    /* Local variables */
#define istak ((integer *)&cstak_1)
#define lstak ((logical *)&cstak_1)
#define rstak ((real *)&cstak_1)
    extern integer i1mach_(integer *);
    extern /* Subroutine */ int a9rntc_(complex *, integer *, integer *, 
	    integer *, integer *, integer *), a9rntd_(doublereal *, integer *,
	     integer *, integer *, integer *, integer *), a9rnti_(integer *, 
	    integer *, integer *, integer *, integer *), a9rntl_(logical *, 
	    integer *, integer *, integer *), a9rntr_(real *, integer *, 
	    integer *, integer *, integer *, integer *);
#define cmstak ((complex *)&cstak_1)
    static integer errout;

    /* Fortran I/O blocks */
    static cilist io___6 = { 0, 0, 0, fmt_1, 0 };
    static cilist io___7 = { 0, 0, 0, fmt_2, 0 };
    static cilist io___8 = { 0, 0, 0, fmt_3, 0 };
    static cilist io___9 = { 0, 0, 0, fmt_4, 0 };
    static cilist io___10 = { 0, 0, 0, fmt_5, 0 };



/*  THIS SUBROUTINE ASSUMES THAT THE TYPE (INTEGER, ETC.) OF THE DATA */
/*  IN THE PORT STACK IS NOT KNOWN - SO IT PRINTS OUT, IN ALL FORMATS */
/*  THE STACK CONTENTS, USING THE ARRAY OUTPUT ROUTINES APRNTX. */

/*  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, NOVEMBER 8, 1982. */

/*  INPUT PARAMETERS - */

/*    LNG      - AN INTEGER VECTOR ARRAY CONTAINING IN */
/*               LNG(1) THE LENGTH OF THE ARRAY IF LOGICAL */
/*               LNG(2) THE LENGTH OF THE ARRAY IF INTEGER */
/*               LNG(3) THE LENGTH OF THE ARRAY IF REAL */
/*               LNG(4) THE LENGTH OF THE ARRAY IF DOUBLE PRECISION */
/*               LNG(5) THE LENGTH OF THE ARRAY IF COMPLEX */

/*    NCOL     - THE NUMBER OF SPACES ACROSS A PRINTED LINE */

/*    WI       - THE FORMAT WIDTH FOR AN INTEGER */

/*    WR       - THE FORMAT WIDTH FOR A REAL (W IN 1PEW.D) */

/*    DR       - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT */
/*               (THE D IN THE 1PEW.D FORMULA) */

/*    WD       - THE FORMAT WIDTH FOR A REAL (W IN 1PDW.D) */

/*    DD       - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT */
/*               (THE D IN THE 1PDW.D FORMULA) */


/*  ERROR STATES - NONE.  U9DMP IS CALLED BY SETERR, */
/*  SO IT CANNOT CALL SETERR. */


/* /R */
/*     REAL CMSTAK(2,500) */
/*     EQUIVALENCE (DSTAK(1), CMSTAK(1,1)) */
/* /C */
/* / */

    /* Parameter adjustments */
    --lng;

    /* Function Body */
    errout = i1mach_(&c__4);

    io___6.ciunit = errout;
    s_wsfe(&io___6);
    e_wsfe();
    a9rntl_(lstak, &lng[1], &errout, ncol);
    io___7.ciunit = errout;
    s_wsfe(&io___7);
    e_wsfe();
    a9rnti_(istak, &lng[2], &errout, ncol, wi);
    io___8.ciunit = errout;
    s_wsfe(&io___8);
    e_wsfe();
    a9rntr_(rstak, &lng[3], &errout, ncol, wr, dr);
    io___9.ciunit = errout;
    s_wsfe(&io___9);
    e_wsfe();
    a9rntd_(cstak_1.dstak, &lng[4], &errout, ncol, wd, dd);
    io___10.ciunit = errout;
    s_wsfe(&io___10);
    e_wsfe();
    a9rntc_(cmstak, &lng[5], &errout, ncol, wr, dr);

    return 0;
} /* u9dmp_ */

#undef cmstak
#undef rstak
#undef lstak
#undef istak


