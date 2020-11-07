/* aprntd.f -- translated by f2c (version 20100827).
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

static integer c__27 = 27;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__22 = 22;
static integer c__3 = 3;
static integer c__21 = 21;
static integer c__4 = 4;
static integer c__10 = 10;
static integer c__15 = 15;
static integer c__16 = 16;

/* Subroutine */ int aprntd_(doublereal *a, integer *nitems, integer *iout, 
	integer *mcol, integer *w, integer *d__)
{
    /* Initialized data */

    static char blank[1] = " ";
    static char star[1] = "*";
    static integer indw = 7;
    static integer expent = 0;
    static struct {
	char e_1[20];
	} equiv_0 = { "(1A1,5X,2A1,  X,2A1)" };

    static struct {
	char e_1[18];
	} equiv_1 = { "(1A1,I7,1P D  .  )" };


    /* System generated locals */
    integer i__1, i__2, i__3, i__4;
    real r__1;

    /* Builtin functions */
    double r_lg10(real *);
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void);

    /* Local variables */
    static integer i__, j, k, dd, ww;
    static logical dup;
    static doublereal line[18];
    static integer emin, emax, ncol;
    static doublereal last[18];
#define ifmt1 ((char *)&equiv_0)
#define ifmt2 ((char *)&equiv_1)
    extern integer iceil_(real *), i10wid_(integer *);
    static integer iline, ilast, count;
    extern /* Subroutine */ int s88fmt_(integer *, integer *, char *, ftnlen);
    extern integer i1mach_(integer *);
#define ifmt1c ((char *)&equiv_0)
#define ifmt2c ((char *)&equiv_1)
    static real logeta;
    extern /* Subroutine */ int seterr_(char *, integer *, integer *, integer 
	    *, ftnlen);

    /* Fortran I/O blocks */
    static cilist io___23 = { 0, 0, 0, ifmt1c, 0 };
    static cilist io___24 = { 0, 0, 0, ifmt2c, 0 };
    static cilist io___26 = { 0, 0, 0, ifmt2c, 0 };



/*  THIS SUBROUTINE PRINTS OUT NITEMS FROM THE DOUBLE PRECISION ARRAY, */
/*  A, ON OUTPUT UNIT IOUT, USING A MAXIMUM OF MCOL PRINT SPACES. */
/*  THE OUTPUT FORMAT IS 1PDW.D. */
/*  THE PROGRAM PUTS AS MANY VALUES ON A LINE AS POSSIBLE. */
/*  W SHOULD BE INPUT AS THE ACTUAL WIDTH +1 FOR A SPACE BETWEEN VALUES. */

/*  DUPLICATE LINES ARE NOT ALL PRINTED, BUT ARE INDICATED BY ASTERISKS. */

/*  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, OCTOBER 21, 1982. */

/*  THE LINE WIDTH IS COMPUTED AS THE MINIMUM OF THE INPUT MCOL AND 160. */
/*  IF THE LINE WIDTH IS TO BE INCREASED ABOVE 160, THE BUFFERS LINE() */
/*  AND LAST(), WHICH THE VALUES TO BE PRINTED ON ONE LINE, MUST */
/*  BE DIMENSIONED ACCORDINGLY. */

/*  INPUT PARAMETERS - */

/*    A        - THE START OF THE DOUBLE PRECISION ARRAY TO BE PRINTED */

/*    NITEMS   - THE NUMBER OF ITEMS TO BE PRINTED */

/*    IOUT     - THE OUTPUT UNIT FOR PRINTING */

/*    MCOL     - THE NUMBER OF SPACES ACROSS THE LINE */

/*    W        - THE WIDTH OF THE PRINTED VALUE (1PDW.D) */

/*    D        - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT (1PDW.D) */


/*  ERROR STATES - */

/*    1 - NITEMS .LE. ZERO */

/*    2 - W .GT. MCOL */

/*    3 - D .LT. ZERO */

/*    4 - W .LT. D+6 */


/* /6S */
/*     INTEGER  IFMT1(20), IFMT1C(20), IFMT2(18), IFMT2C(18), BLANK, STAR */
/*     EQUIVALENCE (IFMT1(1),IFMT1C(1)), (IFMT2(1),IFMT2C(1)) */
/* /7S */
/* / */

/* /6S */
/*     DATA BLANK/1H /, STAR/1H+/, INDW/7/, EXPENT/0/ */
/* /7S */
    /* Parameter adjustments */
    --a;

    /* Function Body */
/* / */

/*  IFMT1 IS FOR THE ASTERISK LINES, IFMT2 FOR THE DATA LINES */

/* /6S */
/*     DATA IFMT1( 1) /1H(/,  IFMT2( 1) /1H(/ */
/*     DATA IFMT1( 2) /1H1/,  IFMT2( 2) /1H1/ */
/*     DATA IFMT1( 3) /1HA/,  IFMT2( 3) /1HA/ */
/*     DATA IFMT1( 4) /1H1/,  IFMT2( 4) /1H1/ */
/*     DATA IFMT1( 5) /1H,/,  IFMT2( 5) /1H,/ */
/*     DATA IFMT1( 6) /1H5/,  IFMT2( 6) /1HI/ */
/*     DATA IFMT1( 7) /1HX/,  IFMT2( 7) /1H7/ */
/*     DATA IFMT1( 8) /1H,/,  IFMT2( 8) /1H,/ */
/*     DATA IFMT1( 9) /1H2/,  IFMT2( 9) /1H1/ */
/*     DATA IFMT1(10) /1HA/,  IFMT2(10) /1HP/ */
/*     DATA IFMT1(11) /1H1/,  IFMT2(11) /1H / */
/*     DATA IFMT1(12) /1H,/,  IFMT2(12) /1HD/ */
/*     DATA IFMT1(13) /1H /,  IFMT2(13) /1H / */
/*     DATA IFMT1(14) /1H /,  IFMT2(14) /1H / */
/*     DATA IFMT1(15) /1HX/,  IFMT2(15) /1H./ */
/*     DATA IFMT1(16) /1H,/,  IFMT2(16) /1H / */
/*     DATA IFMT1(17) /1H2/,  IFMT2(17) /1H / */
/*     DATA IFMT1(18) /1HA/,  IFMT2(18) /1H)/ */
/*     DATA IFMT1(19) /1H1/ */
/*     DATA IFMT1(20) /1H)/ */
/* /7S */
/* / */

/* /6S */
/*     IF (NITEMS .LE. 0) CALL */
/*    1  SETERR(27H  APRNTD - NITEMS .LE. ZERO, 27, 1, 2) */
/* /7S */
    if (*nitems <= 0) {
	seterr_("  APRNTD - NITEMS .LE. ZERO", &c__27, &c__1, &c__2, (ftnlen)
		27);
    }
/* / */

/* /6S */
/*     IF (W .GT. MCOL) CALL */
/*    1  SETERR(22H  APRNTD - W .GT. MCOL, 22, 2, 2) */
/* /7S */
    if (*w > *mcol) {
	seterr_("  APRNTD - W .GT. MCOL", &c__22, &c__2, &c__2, (ftnlen)22);
    }
/* / */

/* /6S */
/*     IF (D .LT. 0) CALL */
/*    1  SETERR(22H  APRNTD - D .LT. ZERO, 22, 3, 2) */
/* /7S */
    if (*d__ < 0) {
	seterr_("  APRNTD - D .LT. ZERO", &c__22, &c__3, &c__2, (ftnlen)22);
    }
/* / */

/* /6S */
/*     IF (W .LT. D+6) CALL */
/*    1  SETERR(21H  APRNTD - W .LT. D+6, 21, 4, 2) */
/* /7S */
    if (*w < *d__ + 6) {
	seterr_("  APRNTD - W .LT. D+6", &c__21, &c__4, &c__2, (ftnlen)21);
    }
/* / */

/*     EXPENT IS USED AS A FIRST-TIME SWITCH TO SIGNAL IF THE */
/*     MACHINE-VALUE CONSTANTS HAVE BEEN COMPUTED. */

    if (expent > 0) {
	goto L10;
    }
    r__1 = (real) i1mach_(&c__10);
    logeta = r_lg10(&r__1);
    r__1 = logeta * (i__1 = i1mach_(&c__15) - 1, (real) abs(i__1));
    emin = iceil_(&r__1);
    r__1 = logeta * (real) i1mach_(&c__16);
    emax = iceil_(&r__1);
    i__1 = max(emin,emax);
    expent = i10wid_(&i__1);

/*     COMPUTE THE FORMATS. */

L10:
/* Computing MIN */
/* Computing MAX */
    i__3 = *w, i__4 = expent + 5;
    i__1 = 99, i__2 = max(i__3,i__4);
    ww = min(i__1,i__2);
    s88fmt_(&c__2, &ww, ifmt2 + 12, (ftnlen)1);
/* Computing MIN */
    i__1 = *d__, i__2 = ww - (expent + 5);
    dd = min(i__1,i__2);
    s88fmt_(&c__2, &dd, ifmt2 + 15, (ftnlen)1);

/*  NCOL IS THE NUMBER OF VALUES TO BE PRINTED ACROSS THE LINE. */

/* Computing MAX */
/* Computing MIN */
    i__3 = 9, i__4 = (min(*mcol,160) - indw) / ww;
    i__1 = 1, i__2 = min(i__3,i__4);
    ncol = max(i__1,i__2);
    s88fmt_(&c__1, &ncol, ifmt2 + 10, (ftnlen)1);
    ww += -2;
/*  THE ASTERISKS ARE POSITIONED RIGHT-ADJUSTED IN THE W-WIDTH SPACE. */
    s88fmt_(&c__2, &ww, ifmt1 + 12, (ftnlen)1);

/*  I COUNTS THE NUMBER OF ITEMS TO BE PRINTED, */
/*  J COUNTS THE NUMBER ON A GIVEN LINE, */
/*  COUNT COUNTS THE NUMBER OF DUPLICATE LINES. */

    i__ = 1;
    j = 0;
    count = 0;

/*  THE LOGICAL OF THE FOLLOWING IS ROUGHLY THIS - */
/*  IF THERE ARE STILL MORE ITEMS TO BE PRINTED, A LINE- */
/*  FULL IS PUT INTO THE ARRAY, LINE. */
/*  WHENEVER A LINE IS PRINTED OUT, IT IS ALSO STUFFED INTO */
/*  THE ARRAY, LAST, TO COMPARE WITH THE NEXT ONE COMING IN */
/*  TO CHECK FOR REPEAT OR DUPLICATED LINES. */
/*  ALSO WHENEVER A LINE IS WRITTEN OUT, THE DUPLICATION */
/*  COUNTER, COUNT, IS SET TO ONE. */
/*  THE ONLY MILDLY TRICKY PART IS TO NOTE THAT COUNT HAS TO */
/*  GO TO 3 BEFORE A LINE OF ASTERISKS IS PRINTED BECAUSE */
/*  OF COURSE NO SUCH LINE IS PRINTED FOR JUST A PAIR OF */
/*  DUPLICATE LINES. */

/*  ILINE IS PRINTED AS THE INDEX OF THE FIRST ARRAY ELEMENT */
/*  IN A LINE. */

L20:
    if (i__ > *nitems) {
	goto L90;
    }
    ++j;
    line[j - 1] = a[i__];
    if (j == 1) {
	iline = i__;
    }
    if (j < ncol && i__ < *nitems) {
	goto L80;
    }
    if (count == 0) {
	goto L50;
    }
    dup = TRUE_;
    i__1 = ncol;
    for (k = 1; k <= i__1; ++k) {
/* L30: */
	if (last[k - 1] != line[k - 1]) {
	    dup = FALSE_;
	}
    }
    if (i__ == *nitems && j < ncol) {
	dup = FALSE_;
    }
    if (! dup && count == 1) {
	goto L50;
    }
    if (! dup) {
	goto L40;
    }
    ++count;
    if (count == 3) {
	io___23.ciunit = *iout;
	s_wsfe(&io___23);
	do_fio(&c__1, blank, (ftnlen)1);
	do_fio(&c__1, star, (ftnlen)1);
	do_fio(&c__1, star, (ftnlen)1);
	do_fio(&c__1, star, (ftnlen)1);
	do_fio(&c__1, star, (ftnlen)1);
	e_wsfe();
    }
    if (i__ == *nitems) {
	goto L50;
    }
    goto L70;
L40:
    io___24.ciunit = *iout;
    s_wsfe(&io___24);
    do_fio(&c__1, blank, (ftnlen)1);
    do_fio(&c__1, (char *)&ilast, (ftnlen)sizeof(integer));
    i__1 = ncol;
    for (k = 1; k <= i__1; ++k) {
	do_fio(&c__1, (char *)&last[k - 1], (ftnlen)sizeof(doublereal));
    }
    e_wsfe();
L50:
    io___26.ciunit = *iout;
    s_wsfe(&io___26);
    do_fio(&c__1, blank, (ftnlen)1);
    do_fio(&c__1, (char *)&iline, (ftnlen)sizeof(integer));
    i__1 = j;
    for (k = 1; k <= i__1; ++k) {
	do_fio(&c__1, (char *)&line[k - 1], (ftnlen)sizeof(doublereal));
    }
    e_wsfe();
    count = 1;
    i__1 = ncol;
    for (k = 1; k <= i__1; ++k) {
/* L60: */
	last[k - 1] = line[k - 1];
    }
L70:
    ilast = iline;
    j = 0;
L80:
    ++i__;
    goto L20;
L90:
    return 0;
} /* aprntd_ */

#undef ifmt2c
#undef ifmt1c
#undef ifmt2
#undef ifmt1


