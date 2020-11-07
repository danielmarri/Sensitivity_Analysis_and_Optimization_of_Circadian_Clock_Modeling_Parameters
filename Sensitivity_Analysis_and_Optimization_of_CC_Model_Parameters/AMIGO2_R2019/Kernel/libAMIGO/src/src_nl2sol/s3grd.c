/* s3grd.f -- translated by f2c (version 20100827).
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

static integer c__3 = 3;
static doublereal c_b13 = .33333333333333331;
static doublereal c_b14 = -.66666666666666663;
static doublereal c_b16 = .66666666666666663;

/* Subroutine */ int s3grd_(real *alpha, real *b, real *d__, real *eta0, real 
	*fx, real *g, integer *irc, integer *p, real *w, real *x)
{
    /* System generated locals */
    real r__1, r__2;
    doublereal d__1, d__2;

    /* Builtin functions */
    double sqrt(doublereal), pow_dd(doublereal *, doublereal *);

    /* Local variables */
    static real h__;
    static integer i__;
    static real h0, gi, xi, aai, agi, eta, afx, axi;
    static logical hit;
    static real xih, hmin;
    extern doublereal r7mdc_(integer *);
    static real machep, alphai, axibar, afxeta, discon;


/*  ***  COMPUTE FINITE DIFFERENCE GRADIENT BY STWEART*S SCHEME  *** */

/*     ***  PARAMETERS  *** */


/* ....................................................................... */

/*     ***  PURPOSE  *** */

/*        THIS SUBROUTINE USES AN EMBELLISHED FORM OF THE FINITE-DIFFER- */
/*     ENCE SCHEME PROPOSED BY STEWART (REF. 1) TO APPROXIMATE THE */
/*     GRADIENT OF THE FUNCTION F(X), WHOSE VALUES ARE SUPPLIED BY */
/*     REVERSE COMMUNICATION. */

/*     ***  PARAMETER DESCRIPTION  *** */

/*  ALPHA IN  (APPROXIMATE) DIAGONAL ELEMENTS OF THE HESSIAN OF F(X). */
/*      B IN  ARRAY OF SIMPLE LOWER AND UPPER BOUNDS ON X.  X MUST */
/*             SATISFY B(1,I) .LE. X(I) .LE. B(2,I), I = 1(1)P. */
/*             FOR ALL I WITH B(1,I) .GE. B(2,I),  S3GRD SIMPLY */
/*             SETS G(I) TO 0. */
/*      D IN  SCALE VECTOR SUCH THAT D(I)*X(I), I = 1,...,P, ARE IN */
/*             COMPARABLE UNITS. */
/*   ETA0 IN  ESTIMATED BOUND ON RELATIVE ERROR IN THE FUNCTION VALUE... */
/*             (TRUE VALUE) = (COMPUTED VALUE)*(1+E),   WHERE */
/*             ABS(E) .LE. ETA0. */
/*     FX I/O ON INPUT,  FX  MUST BE THE COMPUTED VALUE OF F(X).  ON */
/*             OUTPUT WITH IRC = 0, FX HAS BEEN RESTORED TO ITS ORIGINAL */
/*             VALUE, THE ONE IT HAD WHEN  S3GRD WAS LAST CALLED WITH */
/*             IRC = 0. */
/*      G I/O ON INPUT WITH IRC = 0, G SHOULD CONTAIN AN APPROXIMATION */
/*             TO THE GRADIENT OF F NEAR X, E.G., THE GRADIENT AT THE */
/*             PREVIOUS ITERATE.  WHEN  S3GRD RETURNS WITH IRC = 0, G IS */
/*             THE DESIRED FINITE-DIFFERENCE APPROXIMATION TO THE */
/*             GRADIENT AT X. */
/*    IRC I/O INPUT/RETURN CODE... BEFORE THE VERY FIRST CALL ON  S3GRD, */
/*             THE CALLER MUST SET IRC TO 0.  WHENEVER  S3GRD RETURNS A */
/*             NONZERO VALUE (OF AT MOST P) FOR IRC, IT HAS PERTURBED */
/*             SOME COMPONENT OF X... THE CALLER SHOULD EVALUATE F(X) */
/*             AND CALL  S3GRD AGAIN WITH FX = F(X).  IF B PREVENTS */
/*             ESTIMATING G(I) I.E., IF THERE IS AN I WITH */
/*             B(1,I) .LT. B(2,I) BUT WITH B(1,I) SO CLOSE TO B(2,I) */
/*             THAT THE FINITE-DIFFERENCING STEPS CANNOT BE CHOSEN, */
/*             THEN  S3GRD RETURNS WITH IRC .GT. P. */
/*      P IN  THE NUMBER OF VARIABLES (COMPONENTS OF X) ON WHICH F */
/*             DEPENDS. */
/*      X I/O ON INPUT WITH IRC = 0, X IS THE POINT AT WHICH THE */
/*             GRADIENT OF F IS DESIRED.  ON OUTPUT WITH IRC NONZERO, X */
/*             IS THE POINT AT WHICH F SHOULD BE EVALUATED.  ON OUTPUT */
/*             WITH IRC = 0, X HAS BEEN RESTORED TO ITS ORIGINAL VALUE */
/*             (THE ONE IT HAD WHEN  S3GRD WAS LAST CALLED WITH IRC = 0) */
/*             AND G CONTAINS THE DESIRED GRADIENT APPROXIMATION. */
/*      W I/O WORK VECTOR OF LENGTH 6 IN WHICH  S3GRD SAVES CERTAIN */
/*             QUANTITIES WHILE THE CALLER IS EVALUATING F(X) AT A */
/*             PERTURBED X. */

/*     ***  APPLICATION AND USAGE RESTRICTIONS  *** */

/*        THIS ROUTINE IS INTENDED FOR USE WITH QUASI-NEWTON ROUTINES */
/*     FOR UNCONSTRAINED MINIMIZATION (IN WHICH CASE  ALPHA  COMES FROM */
/*     THE DIAGONAL OF THE QUASI-NEWTON HESSIAN APPROXIMATION). */

/*     ***  ALGORITHM NOTES  *** */

/*        THIS CODE DEPARTS FROM THE SCHEME PROPOSED BY STEWART (REF. 1) */
/*     IN ITS GUARDING AGAINST OVERLY LARGE OR SMALL STEP SIZES AND ITS */
/*     HANDLING OF SPECIAL CASES (SUCH AS ZERO COMPONENTS OF ALPHA OR G). */

/*     ***  REFERENCES  *** */

/* 1. STEWART, G.W. (1967), A MODIFICATION OF DAVidoN*S MINIMIZATION */
/*        METHOD TO ACCEPT DIFFERENCE APPROXIMATIONS OF DERIVATIVES, */
/*        J. ASSOC. COMPUT. MACH. 14, PP. 72-83. */

/*     ***  HISTORY  *** */

/*     DESIGNED AND CODED BY DAVID M. GAY (SUMMER 1977/SUMMER 1980). */

/*     ***  GENERAL  *** */

/*        THIS ROUTINE WAS PREPARED IN CONNECTION WITH WORK SUPPORTED BY */
/*     THE NATIONAL SCIENCE FOUNDATION UNDER GRANTS MCS76-00324 AND */
/*     MCS-7906671. */

/* ....................................................................... */

/*     *****  EXTERNAL FUNCTION  ***** */

/*  R7MDC... RETURNS MACHINE-DEPENDENT CONSTANTS. */

/*     ***** INTRINSIC FUNCTIONS ***** */
/* /+ */
/* / */
/*     ***** LOCAL VARIABLES ***** */


/* /6 */
/*     DATA C2000/2.0E+3/, FOUR/4.0E+0/, HMAX0/0.02E+0/, HMIN0/5.0E+1/, */
/*    1     ONE/1.0E+0/, P002/0.002E+0/, THREE/3.0E+0/, */
/*    2     TWO/2.0E+0/, ZERO/0.0E+0/ */
/* /7 */
/* / */
/* /6 */
/*     DATA FH/3/, FX0/4/, HSAVE/5/, XISAVE/6/ */
/* /7 */
/* / */

/* ---------------------------------  BODY  ------------------------------ */

    /* Parameter adjustments */
    --x;
    --g;
    --d__;
    b -= 3;
    --alpha;
    --w;

    /* Function Body */
    if (*irc < 0) {
	goto L80;
    } else if (*irc == 0) {
	goto L10;
    } else {
	goto L210;
    }

/*     ***  FRESH START -- GET MACHINE-DEPENDENT CONSTANTS  *** */

/*     STORE MACHEP IN W(1) AND H0 IN W(2), WHERE MACHEP IS THE UNIT */
/*     ROUNDOFF (THE SMALLEST POSITIVE NUMBER SUCH THAT */
/*     1 + MACHEP .GT. 1  AND  1 - MACHEP .LT. 1),  AND  H0 IS THE */
/*     SQUARE-ROOT OF MACHEP. */

L10:
    w[1] = r7mdc_(&c__3);
    w[2] = sqrt(w[1]);

    w[4] = *fx;

/*     ***  INCREMENT  I  AND START COMPUTING  G(I)  *** */

L20:
    i__ = abs(*irc) + 1;
    if (i__ > *p) {
	goto L220;
    }
    *irc = i__;
    if (b[(i__ << 1) + 1] < b[(i__ << 1) + 2]) {
	goto L30;
    }
    g[i__] = 0.f;
    goto L20;
L30:
    afx = dabs(w[4]);
    machep = w[1];
    h0 = w[2];
    hmin = machep * 50.f;
    xi = x[i__];
    w[6] = xi;
    axi = dabs(xi);
/* Computing MAX */
    r__1 = axi, r__2 = 1.f / d__[i__];
    axibar = dmax(r__1,r__2);
    gi = g[i__];
    agi = dabs(gi);
    eta = dabs(*eta0);
    if (afx > 0.f) {
/* Computing MAX */
	r__1 = eta, r__2 = agi * axi * machep / afx;
	eta = dmax(r__1,r__2);
    }
    alphai = alpha[i__];
    if (alphai == 0.f) {
	goto L130;
    }
    if (gi == 0.f || *fx == 0.f) {
	goto L140;
    }
    afxeta = afx * eta;
    aai = dabs(alphai);

/*        *** COMPUTE H = STEWART*S FORWARD-DIFFERENCE STEP SIZE. */

/* Computing 2nd power */
    r__1 = gi;
    if (r__1 * r__1 <= afxeta * aai) {
	goto L40;
    }
    h__ = sqrt(afxeta / aai) * 2.f;
    h__ *= 1.f - aai * h__ / (aai * 3.f * h__ + agi * 4.f);
    goto L50;
/* 40      H = TWO*(AFXETA*AGI/(AAI**2))**(ONE/THREE) */
L40:
    d__1 = (doublereal) (afxeta * agi);
    d__2 = (doublereal) aai;
    h__ = pow_dd(&d__1, &c_b13) * 2.f * pow_dd(&d__2, &c_b14);
    h__ *= 1.f - agi * 2.f / (aai * 3.f * h__ + agi * 4.f);

/*        ***  ENSURE THAT  H  IS NOT INSIGNIFICANTLY SMALL  *** */

L50:
/* Computing MAX */
    r__1 = h__, r__2 = hmin * axibar;
    h__ = dmax(r__1,r__2);

/*        *** USE FORWARD DIFFERENCE IF BOUND ON TRUNCATION ERROR IS AT */
/*        *** MOST 10**-3. */

    if (aai * h__ <= agi * .002f) {
	goto L120;
    }

/*        *** COMPUTE H = STEWART*S STEP FOR CENTRAL DIFFERENCE. */

    discon = afxeta * 2e3f;
/* Computing 2nd power */
    r__1 = gi;
    h__ = discon / (agi + sqrt(r__1 * r__1 + aai * discon));

/*        ***  ENSURE THAT  H  IS NEITHER TOO SMALL NOR TOO BIG  *** */

/* Computing MAX */
    r__1 = h__, r__2 = hmin * axibar;
    h__ = dmax(r__1,r__2);
    if (h__ >= axibar * .02f) {
	d__1 = (doublereal) h0;
	h__ = axibar * pow_dd(&d__1, &c_b16);
    }

/*        ***  COMPUTE CENTRAL DIFFERENCE  *** */

    xih = xi + h__;
    if (xi - h__ < b[(i__ << 1) + 1]) {
	goto L60;
    }
    *irc = -i__;
    if (xih <= b[(i__ << 1) + 2]) {
	goto L200;
    }
    h__ = -h__;
    xih = xi + h__;
    if (xi + h__ * 2.f < b[(i__ << 1) + 1]) {
	goto L190;
    }
    goto L70;
L60:
    if (xi + h__ * 2.f > b[(i__ << 1) + 2]) {
	goto L190;
    }
/*        *** MUST DO OFF-SIDE CENTRAL DIFFERENCE *** */
L70:
    *irc = -(i__ + *p);
    goto L200;

L80:
    i__ = -(*irc);
    if (i__ <= *p) {
	goto L100;
    }
    i__ -= *p;
    if (i__ > *p) {
	goto L90;
    }
    w[3] = *fx;
    h__ = w[5] * 2.f;
    xih = w[6] + h__;
    *irc -= *p;
    goto L200;

/*    *** FINISH OFF-SIDE CENTRAL DIFFERENCE *** */

L90:
    i__ -= *p;
    g[i__] = (w[3] * 4.f - *fx - w[4] * 3.f) / w[5];
    *irc = i__;
    x[i__] = w[6];
    goto L20;

L100:
    h__ = -w[5];
    if (h__ > 0.f) {
	goto L110;
    }
    w[3] = *fx;
    xih = w[6] + h__;
    goto L200;

L110:
    g[i__] = (w[3] - *fx) / (h__ * 2.f);
    x[i__] = w[6];
    goto L20;

/*     ***  COMPUTE FORWARD DIFFERENCES IN VARIOUS CASES  *** */

L120:
    if (h__ >= axibar * .02f) {
	h__ = h0 * axibar;
    }
    if (alphai * gi < 0.f) {
	h__ = -h__;
    }
    goto L150;
L130:
    h__ = axibar;
    goto L150;
L140:
    h__ = h0 * axibar;

L150:
    hit = FALSE_;
L160:
    xih = xi + h__;
    if (h__ > 0.f) {
	goto L170;
    }
    if (xih >= b[(i__ << 1) + 1]) {
	goto L200;
    }
    goto L180;
L170:
    if (xih <= b[(i__ << 1) + 2]) {
	goto L200;
    }
L180:
    if (hit) {
	goto L190;
    }
    hit = TRUE_;
    h__ = -h__;
    goto L160;

/*        *** ERROR RETURN... */
L190:
    *irc = i__ + *p;
    goto L230;

/*        *** RETURN FOR NEW FUNCTION VALUE... */
L200:
    x[i__] = xih;
    w[5] = h__;
    goto L999;

/*     ***  COMPUTE ACTUAL FORWARD DIFFERENCE  *** */

L210:
    g[*irc] = (*fx - w[4]) / w[5];
    x[*irc] = w[6];
    goto L20;

/*  ***  RESTORE FX AND INDICATE THAT G HAS BEEN COMPUTED  *** */

L220:
    *irc = 0;
L230:
    *fx = w[4];

L999:
    return 0;
/*  ***  LAST LINE OF  S3GRD FOLLOWS  *** */
} /* s3grd_ */

