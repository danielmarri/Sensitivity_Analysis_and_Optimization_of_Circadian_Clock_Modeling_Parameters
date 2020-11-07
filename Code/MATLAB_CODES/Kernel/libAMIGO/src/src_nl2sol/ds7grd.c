/* ds7grd.f -- translated by f2c (version 20100827).
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
static doublereal c_b12 = .33333333333333331;
static doublereal c_b13 = -.66666666666666663;
static doublereal c_b15 = .66666666666666663;

/* Subroutine */ int ds7grd_(doublereal *alpha, doublereal *d__, doublereal *
	eta0, doublereal *fx, doublereal *g, integer *irc, integer *n, 
	doublereal *w, doublereal *x)
{
    /* System generated locals */
    doublereal d__1, d__2;

    /* Builtin functions */
    double sqrt(doublereal), pow_dd(doublereal *, doublereal *);

    /* Local variables */
    static doublereal h__;
    static integer i__;
    static doublereal h0, gi, aai, agi, eta, afx, axi, hmin;
    extern doublereal dr7mdc_(integer *);
    static doublereal machep, alphai, axibar, afxeta, discon;


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
/*      D IN  SCALE VECTOR SUCH THAT D(I)*X(I), I = 1,...,N, ARE IN */
/*             COMPARABLE UNITS. */
/*   ETA0 IN  ESTIMATED BOUND ON RELATIVE ERROR IN THE FUNCTION VALUE... */
/*             (TRUE VALUE) = (COMPUTED VALUE)*(1+E),   WHERE */
/*             ABS(E) .LE. ETA0. */
/*     FX I/O ON INPUT,  FX  MUST BE THE COMPUTED VALUE OF F(X).  ON */
/*             OUTPUT WITH IRC = 0, FX HAS BEEN RESTORED TO ITS ORIGINAL */
/*             VALUE, THE ONE IT HAD WHEN DS7GRD WAS LAST CALLED WITH */
/*             IRC = 0. */
/*      G I/O ON INPUT WITH IRC = 0, G SHOULD CONTAIN AN APPROXIMATION */
/*             TO THE GRADIENT OF F NEAR X, E.G., THE GRADIENT AT THE */
/*             PREVIOUS ITERATE.  WHEN DS7GRD RETURNS WITH IRC = 0, G IS */
/*             THE DESIRED FINITE-DIFFERENCE APPROXIMATION TO THE */
/*             GRADIENT AT X. */
/*    IRC I/O INPUT/RETURN CODE... BEFORE THE VERY FIRST CALL ON DS7GRD, */
/*             THE CALLER MUST SET IRC TO 0.  WHENEVER DS7GRD RETURNS A */
/*             NONZERO VALUE FOR IRC, IT HAS PERTURBED SOME COMPONENT OF */
/*             X... THE CALLER SHOULD EVALUATE F(X) AND CALL DS7GRD */
/*             AGAIN WITH FX = F(X). */
/*      N IN  THE NUMBER OF VARIABLES (COMPONENTS OF X) ON WHICH F */
/*             DEPENDS. */
/*      X I/O ON INPUT WITH IRC = 0, X IS THE POINT AT WHICH THE */
/*             GRADIENT OF F IS DESIRED.  ON OUTPUT WITH IRC NONZERO, X */
/*             IS THE POINT AT WHICH F SHOULD BE EVALUATED.  ON OUTPUT */
/*             WITH IRC = 0, X HAS BEEN RESTORED TO ITS ORIGINAL VALUE */
/*             (THE ONE IT HAD WHEN DS7GRD WAS LAST CALLED WITH IRC = 0) */
/*             AND G CONTAINS THE DESIRED GRADIENT APPROXIMATION. */
/*      W I/O WORK VECTOR OF LENGTH 6 IN WHICH DS7GRD SAVES CERTAIN */
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

/* DR7MDC... RETURNS MACHINE-DEPENDENT CONSTANTS. */

/*     ***** INTRINSIC FUNCTIONS ***** */
/* /+ */
/* / */
/*     ***** LOCAL VARIABLES ***** */


/* /6 */
/*     DATA C2000/2.0D+3/, FOUR/4.0D+0/, HMAX0/0.02D+0/, HMIN0/5.0D+1/, */
/*    1     ONE/1.0D+0/, P002/0.002D+0/, THREE/3.0D+0/, */
/*    2     TWO/2.0D+0/, ZERO/0.0D+0/ */
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
    --alpha;
    --w;

    /* Function Body */
    if (*irc < 0) {
	goto L140;
    } else if (*irc == 0) {
	goto L100;
    } else {
	goto L210;
    }

/*     ***  FRESH START -- GET MACHINE-DEPENDENT CONSTANTS  *** */

/*     STORE MACHEP IN W(1) AND H0 IN W(2), WHERE MACHEP IS THE UNIT */
/*     ROUNDOFF (THE SMALLEST POSITIVE NUMBER SUCH THAT */
/*     1 + MACHEP .GT. 1  AND  1 - MACHEP .LT. 1),  AND  H0 IS THE */
/*     SQUARE-ROOT OF MACHEP. */

L100:
    w[1] = dr7mdc_(&c__3);
    w[2] = sqrt(w[1]);

    w[4] = *fx;

/*     ***  INCREMENT  I  AND START COMPUTING  G(I)  *** */

L110:
    i__ = abs(*irc) + 1;
    if (i__ > *n) {
	goto L300;
    }
    *irc = i__;
    afx = abs(w[4]);
    machep = w[1];
    h0 = w[2];
    hmin = machep * 50.;
    w[6] = x[i__];
    axi = (d__1 = x[i__], abs(d__1));
/* Computing MAX */
    d__1 = axi, d__2 = 1. / d__[i__];
    axibar = max(d__1,d__2);
    gi = g[i__];
    agi = abs(gi);
    eta = abs(*eta0);
    if (afx > 0.) {
/* Computing MAX */
	d__1 = eta, d__2 = agi * axi * machep / afx;
	eta = max(d__1,d__2);
    }
    alphai = alpha[i__];
    if (alphai == 0.) {
	goto L170;
    }
    if (gi == 0. || *fx == 0.) {
	goto L180;
    }
    afxeta = afx * eta;
    aai = abs(alphai);

/*        *** COMPUTE H = STEWART*S FORWARD-DIFFERENCE STEP SIZE. */

/* Computing 2nd power */
    d__1 = gi;
    if (d__1 * d__1 <= afxeta * aai) {
	goto L120;
    }
    h__ = sqrt(afxeta / aai) * 2.;
    h__ *= 1. - aai * h__ / (aai * 3. * h__ + agi * 4.);
    goto L130;
/* 120     H = TWO*(AFXETA*AGI/(AAI**2))**(ONE/THREE) */
L120:
    d__1 = afxeta * agi;
    h__ = pow_dd(&d__1, &c_b12) * 2. * pow_dd(&aai, &c_b13);
    h__ *= 1. - agi * 2. / (aai * 3. * h__ + agi * 4.);

/*        ***  ENSURE THAT  H  IS NOT INSIGNIFICANTLY SMALL  *** */

L130:
/* Computing MAX */
    d__1 = h__, d__2 = hmin * axibar;
    h__ = max(d__1,d__2);

/*        *** USE FORWARD DIFFERENCE IF BOUND ON TRUNCATION ERROR IS AT */
/*        *** MOST 10**-3. */

    if (aai * h__ <= agi * .002) {
	goto L160;
    }

/*        *** COMPUTE H = STEWART*S STEP FOR CENTRAL DIFFERENCE. */

    discon = afxeta * 2e3;
/* Computing 2nd power */
    d__1 = gi;
    h__ = discon / (agi + sqrt(d__1 * d__1 + aai * discon));

/*        ***  ENSURE THAT  H  IS NEITHER TOO SMALL NOR TOO BIG  *** */

/* Computing MAX */
    d__1 = h__, d__2 = hmin * axibar;
    h__ = max(d__1,d__2);
    if (h__ >= axibar * .02) {
	h__ = axibar * pow_dd(&h0, &c_b15);
    }

/*        ***  COMPUTE CENTRAL DIFFERENCE  *** */

    *irc = -i__;
    goto L200;

L140:
    h__ = -w[5];
    i__ = abs(*irc);
    if (h__ > 0.) {
	goto L150;
    }
    w[3] = *fx;
    goto L200;

L150:
    g[i__] = (w[3] - *fx) / (h__ * 2.);
    x[i__] = w[6];
    goto L110;

/*     ***  COMPUTE FORWARD DIFFERENCES IN VARIOUS CASES  *** */

L160:
    if (h__ >= axibar * .02) {
	h__ = h0 * axibar;
    }
    if (alphai * gi < 0.) {
	h__ = -h__;
    }
    goto L200;
L170:
    h__ = axibar;
    goto L200;
L180:
    h__ = h0 * axibar;

L200:
    x[i__] = w[6] + h__;
    w[5] = h__;
    goto L999;

/*     ***  COMPUTE ACTUAL FORWARD DIFFERENCE  *** */

L210:
    g[*irc] = (*fx - w[4]) / w[5];
    x[*irc] = w[6];
    goto L110;

/*  ***  RESTORE FX AND INDICATE THAT G HAS BEEN COMPUTED  *** */

L300:
    *fx = w[4];
    *irc = 0;

L999:
    return 0;
/*  ***  LAST CARD OF DS7GRD FOLLOWS  *** */
} /* ds7grd_ */

