/* s88fmt.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int s88fmt_(integer *n, integer *w, char *ifmt, ftnlen 
	ifmt_len)
{
    /* Initialized data */

    static char digits[1*10] = "0" "1" "2" "3" "4" "5" "6" "7" "8" "9";

    static integer nt, wt, idigit;


/*  S88FMT  REPLACES IFMT(1), ... , IFMT(N) WITH */
/*  THE CHARACTERS CORRESPONDING TO THE N LEAST SIGNIFICANT */
/*  DIGITS OF W. */

/* /6S */
/*     INTEGER IFMT(N) */
/* /7S */
/* / */


/* /6S */
/*     INTEGER DIGITS(10) */
/*     DATA DIGITS( 1) / 1H0 / */
/*     DATA DIGITS( 2) / 1H1 / */
/*     DATA DIGITS( 3) / 1H2 / */
/*     DATA DIGITS( 4) / 1H3 / */
/*     DATA DIGITS( 5) / 1H4 / */
/*     DATA DIGITS( 6) / 1H5 / */
/*     DATA DIGITS( 7) / 1H6 / */
/*     DATA DIGITS( 8) / 1H7 / */
/*     DATA DIGITS( 9) / 1H8 / */
/*     DATA DIGITS(10) / 1H9 / */
/* /7S */
    /* Parameter adjustments */
    --ifmt;

    /* Function Body */
/* / */

    nt = *n;
    wt = *w;

L10:
    if (nt <= 0) {
	return 0;
    }
    idigit = wt % 10;
    *(unsigned char *)&ifmt[nt] = *(unsigned char *)&digits[idigit];
    wt /= 10;
    --nt;
    goto L10;

} /* s88fmt_ */

