/* i0tk01.f -- translated by f2c (version 20100827).
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

static integer c__4 = 4;

/* Subroutine */ int i0tk01_(void)
{
    /* Initialized data */

    static logical done = FALSE_;

    /* Format strings */
    static char fmt_100[] = "(\0021\002,\002 YOU HAVE USED, DIRECTLY OR INDI"
	    "RECTLY, ONE OF THE STORAGE AL-\002/\002 LOCATION  PROGRAMS  IALL"
	    "OC, DALLOC, STINIT, NIRALL, MTSTAK OR\002/\002 SRECAP.  THESE AR"
	    "E BASED ON THE ASSUMPTION THAT ONE -UNIT- OF\002/\002 STORAGE  I"
	    "S  ALLOCATED  TO  DATA OF TYPE LOGICAL, INTEGER AND\002/\002 REA"
	    "L AND THAT TWO -UNITS- OF STORAGE ARE ALLOCATED TO DATA OF\002"
	    "/\002 TYPE  DOUBLE PRECISION AND COMPLEX.  THIS ASSUMPTION PREVE"
	    "NTS\002/\002 MOVING PORT TO MANY MINI-COMPUTERS.                "
	    "          \002/\002                                             "
	    "                 \002/\002 TO OVERCOME THIS DIFFICULTY, THE PACK"
	    "AGE HAS  BEEN  REWRITTEN\002/\002 WITH  NEW  NAMES AND SIMILAR C"
	    "ALLING SEQUENCES.  CALLS TO THE\002/\002 OLD SUBPROGRAMS SHOULD "
	    " BE  REPLACED  BY  CALLS  TO  THE  NEW\002/\002 PACKAGE  WHEN  C"
	    "ONVENIENT.   TO AVOID OBSOLETING OLD PROGRAMS\002/\002 THE OLD C"
	    "ALLING SEQUENCES WILL CONTINUE TO BE SUPPORTED.     \002/\002   "
	    "                                                           \002/)"
	    ;
    static char fmt_200[] = "(\002 THE OLD AND NEW CALLING SEQUENCES ARE AS "
	    "FOLLOWS-            \002/\002                                   "
	    "                           \002/\002 FUNCTION   OLD             "
	    "          NEW                     \002/\002                     "
	    "                                         \002/\002 GET        IX"
	    " = IALLOC(NDATA,ISIZE)  IX = ISTKGT(NDATA,ITYPE)\002/\002 RELEAS"
	    "E    CALL DALLOC(NFRAMES)      CALL ISTKRL(NFRAMES)    \002/\002"
	    " INITIALIZE CALL STINIT(NDATA,ISIZE)  CALL ISTKIN(NDATA,ITYPE"
	    ")\002/\002 MODIFY     IX = MTSTAK(NDATA)        IX = ISTKMD(NDAT"
	    "A)      \002/\002 STATISTICS CALL SRECAP(IUNIT)        - NO EQUI"
	    "VALENT -       \002/\002 QUERY      N  = NIRALL(ISIZE)        N "
	    " = ISTKQU(ITYPE)      \002/\002                                 "
	    "                             \002/)";
    static char fmt_300[] = "(\002 IN THE ABOVE ITYPE IS AS FOLLOWS-        "
	    "                    \002/\002                                   "
	    "                           \002/\002 1          LOGICAL         "
	    "                                  \002/\002 2          INTEGER  "
	    "                                         \002/\002 3          RE"
	    "AL                                              \002/\002 4     "
	    "     DOUBLE PRECISION                                  \002/\002"
	    " 5          COMPLEX                                          "
	    " \002/\002                                                      "
	    "        \002/\002 NOTE ALSO  THAT ALLOCATIONS SHOULD  NOT  BE SP"
	    "LIT INTO SUBAL-\002/\002 LOCATIONS  OF  DIFFERENT  TYPE  AS THIS"
	    " ALSO COMPROMISES POR-\002/\002 TABILITY.                       "
	    "                             \002/)";

    /* Builtin functions */
    integer s_wsfe(cilist *), e_wsfe(void);

    /* Local variables */
    static integer iunit;
    extern integer i1mach_(integer *);

    /* Fortran I/O blocks */
    static cilist io___3 = { 0, 0, 0, fmt_100, 0 };
    static cilist io___4 = { 0, 0, 0, fmt_200, 0 };
    static cilist io___5 = { 0, 0, 0, fmt_300, 0 };





    if (done) {
	return 0;
    }
    done = TRUE_;
    iunit = i1mach_(&c__4);

    io___3.ciunit = iunit;
    s_wsfe(&io___3);
    e_wsfe();
    io___4.ciunit = iunit;
    s_wsfe(&io___4);
    e_wsfe();
    io___5.ciunit = iunit;
    s_wsfe(&io___5);
    e_wsfe();

    return 0;




} /* i0tk01_ */

