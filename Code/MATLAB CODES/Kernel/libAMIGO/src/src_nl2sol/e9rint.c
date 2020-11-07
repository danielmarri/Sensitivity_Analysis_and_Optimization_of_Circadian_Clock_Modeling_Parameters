/* e9rint.f -- translated by f2c (version 20100827).
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
static logical c_false = FALSE_;
static integer c__4 = 4;
static integer c__2 = 2;

/* Subroutine */ int e9rint_(char *messg, integer *nw, integer *nerr, logical 
	*save, ftnlen messg_len)
{
    /* Initialized data */

    static char messgp[1*72] = "1";
    static integer nwp = 0;
    static integer nerrp = 0;
    static struct {
	char e_1[10];
	} equiv_0 = { "(3X,72AXX)" };


    /* Format strings */
    static char fmt_9000[] = "(\002 ERROR \002,i4,\002 IN \002)";

    /* System generated locals */
    integer i__1;

    /* Builtin functions */
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void);

    /* Local variables */
    static integer i__;
#define fmt ((char *)&equiv_0)
#define fmt10 ((char *)&equiv_0)
    extern /* Subroutine */ int s88fmt_(integer *, integer *, char *, ftnlen);
    extern integer i1mach_(integer *), i8save_(integer *, integer *, logical *
	    );
    static integer iwunit;

    /* Fortran I/O blocks */
    static cilist io___8 = { 0, 0, 0, fmt_9000, 0 };
    static cilist io___9 = { 0, 0, 0, fmt10, 0 };



/*  THIS ROUTINE STORES THE CURRENT ERROR MESSAGE OR PRINTS THE OLD ONE, */
/*  IF ANY, DEPENDING ON WHETHER OR NOT SAVE = .TRUE. . */

/*  CHANGED, BY P.FOX, MAY 18, 1983, FROM THE ORIGINAL VERSION IN ORDER */
/*  TO GET RID OF THE FORTRAN CARRIAGE CONTROL LINE OVERWRITE */
/*  CHARACTER +, WHICH HAS ALWAYS CAUSED TROUBLE. */
/*  FOR THE RECORD, THE PREVIOUS VERSION HAD THE FOLLOWING ARRAY */
/*  AND CALLS -   (WHERE CCPLUS WAS DECLARED OF TYPE INTEGER) */

/*      DATA CCPLUS  / 1H+ / */

/*      DATA FMT( 1) / 1H( / */
/*      DATA FMT( 2) / 1HA / */
/*      DATA FMT( 3) / 1H1 / */
/*      DATA FMT( 4) / 1H, / */
/*      DATA FMT( 5) / 1H1 / */
/*      DATA FMT( 6) / 1H4 / */
/*      DATA FMT( 7) / 1HX / */
/*      DATA FMT( 8) / 1H, / */
/*      DATA FMT( 9) / 1H7 / */
/*      DATA FMT(10) / 1H2 / */
/*      DATA FMT(11) / 1HA / */
/*      DATA FMT(12) / 1HX / */
/*      DATA FMT(13) / 1HX / */
/*      DATA FMT(14) / 1H) / */

/*        CALL S88FMT(2,I1MACH(6),FMT(12)) */
/*        WRITE(IWUNIT,FMT) CCPLUS,(MESSGP(I),I=1,NWP) */

/* /6S */
/*     INTEGER MESSG(NW) */
/* /7S */
/* / */

/*  MESSGP STORES AT LEAST THE FIRST 72 CHARACTERS OF THE PREVIOUS */
/*  MESSAGE. ITS LENGTH IS MACHINE DEPENDENT AND MUST BE AT LEAST */

/*       1 + 71/(THE NUMBER OF CHARACTERS STORED PER INTEGER WORD). */

/* /6S */
/*     INTEGER MESSGP(36),FMT(10), FMT10(10) */
/*     EQUIVALENCE (FMT(1),FMT10(1)) */
/* /7S */
/* / */

/*  START WITH NO PREVIOUS MESSAGE. */

/* /6S */
/*     DATA MESSGP(1)/1H1/, NWP/0/, NERRP/0/ */
/* /7S */
    /* Parameter adjustments */
    --messg;

    /* Function Body */
/* / */

/*  SET UP THE FORMAT FOR PRINTING THE ERROR MESSAGE. */
/*  THE FORMAT IS SIMPLY (A1,14X,72AXX) WHERE XX=I1MACH(6) IS THE */
/*  NUMBER OF CHARACTERS STORED PER INTEGER WORD. */

/* /6S */
/*     DATA FMT( 1) / 1H( / */
/*     DATA FMT( 2) / 1H3 / */
/*     DATA FMT( 3) / 1HX / */
/*     DATA FMT( 4) / 1H, / */
/*     DATA FMT( 5) / 1H7 / */
/*     DATA FMT( 6) / 1H2 / */
/*     DATA FMT( 7) / 1HA / */
/*     DATA FMT( 8) / 1HX / */
/*     DATA FMT( 9) / 1HX / */
/*     DATA FMT(10) / 1H) / */
/* /7S */
/* / */

    if (! (*save)) {
	goto L20;
    }

/*  SAVE THE MESSAGE. */

    nwp = *nw;
    nerrp = *nerr;
    i__1 = *nw;
    for (i__ = 1; i__ <= i__1; ++i__) {
/* L10: */
	*(unsigned char *)&messgp[i__ - 1] = *(unsigned char *)&messg[i__];
    }

    goto L30;

L20:
    if (i8save_(&c__1, &c__0, &c_false) == 0) {
	goto L30;
    }

/*  PRINT THE MESSAGE. */

    iwunit = i1mach_(&c__4);
    io___8.ciunit = iwunit;
    s_wsfe(&io___8);
    do_fio(&c__1, (char *)&nerrp, (ftnlen)sizeof(integer));
    e_wsfe();

/* /6S */
/*       CALL S88FMT(2,I1MACH(6),FMT( 8)) */
/* /7S */
    s88fmt_(&c__2, &c__1, fmt + 7, (ftnlen)1);
/* / */
    io___9.ciunit = iwunit;
    s_wsfe(&io___9);
    i__1 = nwp;
    for (i__ = 1; i__ <= i__1; ++i__) {
	do_fio(&c__1, messgp + (i__ - 1), (ftnlen)1);
    }
    e_wsfe();

L30:
    return 0;

} /* e9rint_ */

#undef fmt10
#undef fmt


