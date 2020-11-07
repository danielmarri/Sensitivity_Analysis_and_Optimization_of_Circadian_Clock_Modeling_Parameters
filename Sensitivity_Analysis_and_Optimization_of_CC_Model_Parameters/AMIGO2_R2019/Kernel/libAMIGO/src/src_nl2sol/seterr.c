/* seterr.f -- translated by f2c (version 20100827).
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
static logical c_true = TRUE_;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__0 = 0;
static logical c_false = FALSE_;

/* Subroutine */ int seterr_(char *messg, integer *nmessg, integer *nerr, 
	integer *iopt, ftnlen messg_len)
{
    /* Format strings */
    static char fmt_9000[] = "(\0021ERROR    1 IN SETERR - MESSAGE LENGTH NO"
	    "T POSITIVE.\002)";
    static char fmt_9001[] = "(\0021ERROR    2 IN SETERR - CANNOT HAVE NER"
	    "R=0\002//\002 THE CURRENT ERROR MESSAGE FOLLOWS\002///)";
    static char fmt_9002[] = "(\0021ERROR    3 IN SETERR -\002,\002 AN UNREC"
	    "OVERED ERROR FOLLOWED BY ANOTHER ERROR.\002//\002 THE PREVIOUS A"
	    "ND CURRENT ERROR MESSAGES FOLLOW.\002///)";
    static char fmt_9003[] = "(\0021ERROR    4 IN SETERR - BAD VALUE FOR I"
	    "OPT\002//\002 THE CURRENT ERROR MESSAGE FOLLOWS\002///)";

    /* Builtin functions */
    integer s_wsfe(cilist *), e_wsfe(void);
    /* Subroutine */ int s_stop(char *, ftnlen);

    /* Local variables */
    static integer nw, itemp;
    extern /* Subroutine */ int sdump_(void);
    extern integer i1mach_(integer *), i8save_(integer *, integer *, logical *
	    );
    extern /* Subroutine */ int e9rint_(char *, integer *, integer *, logical 
	    *, ftnlen), eprint_(void);
    static integer iwunit;

    /* Fortran I/O blocks */
    static cilist io___2 = { 0, 0, 0, fmt_9000, 0 };
    static cilist io___4 = { 0, 0, 0, fmt_9001, 0 };
    static cilist io___6 = { 0, 0, 0, fmt_9002, 0 };
    static cilist io___7 = { 0, 0, 0, fmt_9003, 0 };



/*  SETERR SETS LERROR = NERR, OPTIONALLY PRINTS THE MESSAGE AND DUMPS */
/*  ACCORDING TO THE FOLLOWING RULES... */

/*    IF IOPT = 1 AND RECOVERING      - JUST REMEMBER THE ERROR. */
/*    IF IOPT = 1 AND NOT RECOVERING  - PRINT AND STOP. */
/*    IF IOPT = 2                     - PRINT, DUMP AND STOP. */

/*  INPUT */

/*    MESSG  - THE ERROR MESSAGE. */
/*    NMESSG - THE LENGTH OF THE MESSAGE, IN CHARACTERS. */
/*    NERR   - THE ERROR NUMBER. MUST HAVE NERR NON-ZERO. */
/*    IOPT   - THE OPTION. MUST HAVE IOPT=1 OR 2. */

/*  ERROR STATES - */

/*    1 - MESSAGE LENGTH NOT POSITIVE. */
/*    2 - CANNOT HAVE NERR=0. */
/*    3 - AN UNRECOVERED ERROR FOLLOWED BY ANOTHER ERROR. */
/*    4 - BAD VALUE FOR IOPT. */

/*  ONLY THE FIRST 72 CHARACTERS OF THE MESSAGE ARE PRINTED. */

/*  THE ERROR HANDLER CALLS A SUBROUTINE NAMED SDUMP TO PRODUCE A */
/*  SYMBOLIC DUMP. */

/* /6S */
/*     INTEGER MESSG(1) */
/* /7S */
/* / */

/*  THE UNIT FOR ERROR MESSAGES. */

    /* Parameter adjustments */
    --messg;

    /* Function Body */
    iwunit = i1mach_(&c__4);

    if (*nmessg >= 1) {
	goto L10;
    }

/*  A MESSAGE OF NON-POSITIVE LENGTH IS FATAL. */

    io___2.ciunit = iwunit;
    s_wsfe(&io___2);
    e_wsfe();
    goto L60;

/*  NW IS THE NUMBER OF WORDS THE MESSAGE OCCUPIES. */
/*  (I1MACH(6) IS THE NUMBER OF CHARACTERS PER WORD.) */

/* /6S */
/* 10   NW=(MIN0(NMESSG,72)-1)/I1MACH(6)+1 */
/* /7S */
L10:
    nw = min(*nmessg,72);
/* / */

    if (*nerr != 0) {
	goto L20;
    }

/*  CANNOT TURN THE ERROR STATE OFF USING SETERR. */
/*  (I8SAVE SETS A FATAL ERROR HERE.) */

    io___4.ciunit = iwunit;
    s_wsfe(&io___4);
    e_wsfe();
    e9rint_(messg + 1, &nw, nerr, &c_true, (ftnlen)1);
    itemp = i8save_(&c__1, &c__1, &c_true);
    goto L50;

/*  SET LERROR AND TEST FOR A PREVIOUS UNRECOVERED ERROR. */

L20:
    if (i8save_(&c__1, nerr, &c_true) == 0) {
	goto L30;
    }

    io___6.ciunit = iwunit;
    s_wsfe(&io___6);
    e_wsfe();
    eprint_();
    e9rint_(messg + 1, &nw, nerr, &c_true, (ftnlen)1);
    goto L50;

/*  SAVE THIS MESSAGE IN CASE IT IS NOT RECOVERED FROM PROPERLY. */

L30:
    e9rint_(messg + 1, &nw, nerr, &c_true, (ftnlen)1);

    if (*iopt == 1 || *iopt == 2) {
	goto L40;
    }

/*  MUST HAVE IOPT = 1 OR 2. */

    io___7.ciunit = iwunit;
    s_wsfe(&io___7);
    e_wsfe();
    goto L50;

/*  IF THE ERROR IS FATAL, PRINT, DUMP, AND STOP */

L40:
    if (*iopt == 2) {
	goto L50;
    }

/*  HERE THE ERROR IS RECOVERABLE */

/*  IF THE RECOVERY MODE IS IN EFFECT, OK, JUST RETURN */

    if (i8save_(&c__2, &c__0, &c_false) == 1) {
	return 0;
    }

/*  OTHERWISE PRINT AND STOP */

    eprint_();
    s_stop("", (ftnlen)0);

L50:
    eprint_();
L60:
    sdump_();
    s_stop("", (ftnlen)0);

    return 0;
} /* seterr_ */

