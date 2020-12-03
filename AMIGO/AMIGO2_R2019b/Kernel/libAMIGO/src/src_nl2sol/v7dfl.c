/* v7dfl.f -- translated by f2c (version 20100827).
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
static integer c__4 = 4;
static doublereal c_b4 = .33333333333333331;
static integer c__5 = 5;

/* Subroutine */ int v7dfl_(integer *alg, integer *lv, real *v)
{
    /* System generated locals */
    real r__1, r__2, r__3;
    doublereal d__1;

    /* Builtin functions */
    double pow_dd(doublereal *, doublereal *);

    /* Local variables */
    extern doublereal r7mdc_(integer *);
    static real machep, mepcrt, sqteps;


/*  ***  SUPPLY ***SOL (VERSION 2.3) DEFAULT VALUES TO V  *** */

/*  ***  ALG = 1 MEANS REGRESSION CONSTANTS. */
/*  ***  ALG = 2 MEANS GENERAL UNCONSTRAINED OPTIMIZATION CONSTANTS. */


/*  R7MDC... RETURNS MACHINE-DEPENDENT CONSTANTS */


/*  ***  SUBSCRIPTS FOR V  *** */


/* /6 */
/*     DATA ONE/1.E+0/, THREE/3.E+0/ */
/* /7 */
/* / */

/*  ***  V SUBSCRIPT VALUES  *** */

/* /6 */
/*     DATA AFCTOL/31/, BIAS/43/, COSMIN/47/, DECFAC/22/, DELTA0/44/, */
/*    1     DFAC/41/, DINIT/38/, DLTFDC/42/, DLTFDJ/43/, DTINIT/39/, */
/*    2     D0INIT/40/, EPSLON/19/, ETA0/42/, FUZZ/45/, HUBERC/48/, */
/*    3     INCFAC/23/, LMAX0/35/, LMAXS/36/, PHMNFC/20/, PHMXFC/21/, */
/*    4     RDFCMN/24/, RDFCMX/25/, RFCTOL/32/, RLIMIT/46/, RSPTOL/49/, */
/*    5     SCTOL/37/, SIGMIN/50/, TUNER1/26/, TUNER2/27/, TUNER3/28/, */
/*    6     TUNER4/29/, TUNER5/30/, XCTOL/33/, XFTOL/34/ */
/* /7 */
/* / */

/* -------------------------------  BODY  -------------------------------- */

    /* Parameter adjustments */
    --v;

    /* Function Body */
    machep = r7mdc_(&c__3);
    v[31] = 1e-20f;
    if (machep > 1e-10f) {
/* Computing 2nd power */
	r__1 = machep;
	v[31] = r__1 * r__1;
    }
    v[22] = .5f;
    sqteps = r7mdc_(&c__4);
    v[41] = .6f;
    v[39] = 1e-6f;
    d__1 = (doublereal) machep;
    mepcrt = pow_dd(&d__1, &c_b4);
    v[40] = 1.f;
    v[19] = .1f;
    v[23] = 2.f;
    v[35] = 1.f;
    v[36] = 1.f;
    v[20] = -.1f;
    v[21] = .1f;
    v[24] = .1f;
    v[25] = 4.f;
/* Computing MAX */
/* Computing 2nd power */
    r__3 = mepcrt;
    r__1 = 1e-10f, r__2 = r__3 * r__3;
    v[32] = dmax(r__1,r__2);
    v[37] = v[32];
    v[26] = .1f;
    v[27] = 1e-4f;
    v[28] = .75f;
    v[29] = .5f;
    v[30] = .75f;
    v[33] = sqteps;
    v[34] = machep * 100.f;

    if (*alg >= 2) {
	goto L10;
    }

/*  ***  REGRESSION  VALUES */

/* Computing MAX */
    r__1 = 1e-6f, r__2 = machep * 100.f;
    v[47] = dmax(r__1,r__2);
    v[38] = 0.f;
    v[44] = sqteps;
    v[42] = mepcrt;
    v[43] = sqteps;
    v[45] = 1.5f;
    v[48] = .7f;
    v[46] = r7mdc_(&c__5);
    v[49] = .001f;
    v[50] = 1e-4f;
    goto L999;

/*  ***  GENERAL OPTIMIZATION VALUES */

L10:
    v[43] = .8f;
    v[38] = -1.f;
    v[42] = machep * 1e3f;

L999:
    return 0;
/*  ***  LAST CARD OF V7DFL FOLLOWS  *** */
} /* v7dfl_ */

