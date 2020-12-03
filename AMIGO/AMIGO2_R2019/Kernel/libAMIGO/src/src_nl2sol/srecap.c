/* srecap.f -- translated by f2c (version 20100827).
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

static integer c__500 = 500;
static integer c__4 = 4;

/* Subroutine */ int srecap_(integer *iwunit)
{
    /* Initialized data */

    static logical init = TRUE_;

    /* Format strings */
    static char fmt_9000[] = "(\0020STACK STATISTICS...\002//\002 OUTSTANDIN"
	    "G ALLOCATIONS\002,i8/\002 CURRENT ACTIVE LENGTH  \002,i8/\002 MA"
	    "XIMUM LENGTH USED    \002,i8/\002 MAXIMUM LENGTH ALLOWED \002,i8)"
	    ;

    /* Builtin functions */
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void);

    /* Local variables */
    extern /* Subroutine */ int i0tk00_(logical *, integer *, integer *), 
	    i0tk01_(void);
#define istak ((integer *)&cstak_1)
#define istats ((integer *)&cstak_1)

    /* Fortran I/O blocks */
    static cilist io___4 = { 0, 0, 0, fmt_9000, 0 };



/*  WRITES LOUT, LNOW, LUSED AND LMAX ON LOGICAL UNIT IWUNIT. */





    i0tk01_();
    if (init) {
	i0tk00_(&init, &c__500, &c__4);
    }

    io___4.ciunit = *iwunit;
    s_wsfe(&io___4);
    do_fio(&c__4, (char *)&istats[0], (ftnlen)sizeof(integer));
    e_wsfe();


    return 0;

} /* srecap_ */

#undef istats
#undef istak


