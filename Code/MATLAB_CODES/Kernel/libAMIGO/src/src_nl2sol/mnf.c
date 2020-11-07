/* mnf.f -- translated by f2c (version 20100827).
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

/* Subroutine */ int mnf_(integer *n, real *d__, real *x, S_fp calcf, integer 
	*iv, integer *liv, integer *lv, real *v, integer *uiparm, real *
	urparm, U_fp ufparm)
{
    static integer nf;
    static real fx;
    extern /* Subroutine */ int rmnf_(real *, real *, integer *, integer *, 
	    integer *, integer *, real *, real *);


/*  ***  MINIMIZE GENERAL UNCONSTRAINED OBJECTIVE FUNCTION USING */
/*  ***  FINITE-DIFFERENCE GRADIENTS AND SECANT HESSIAN APPROXIMATIONS. */

/*     DIMENSION V(77 + N*(N+17)/2), UIPARM(*), URPARM(*) */

/*  ***  PURPOSE  *** */

/*        THIS ROUTINE INTERACTS WITH SUBROUTINE   RMNF  IN AN ATTEMPT */
/*     TO FIND AN N-VECTOR  X*  THAT MINIMIZES THE (UNCONSTRAINED) */
/*     OBJECTIVE FUNCTION COMPUTED BY  CALCF.  (OFTEN THE  X*  FOUND IS */
/*     A LOCAL MINIMIZER RATHER THAN A GLOBAL ONE.) */

/*  ***  PARAMETERS  *** */

/*        THE PARAMETERS FOR   MNF ARE THE SAME AS THOSE FOR   MNG */
/*     (WHICH SEE), EXCEPT THAT CALCG IS OMITTED.  INSTEAD OF CALLING */
/*     CALCG TO OBTAIN THE GRADIENT OF THE OBJECTIVE FUNCTION AT X, */
/*       MNF CALLS  S7GRD, WHICH COMPUTES AN APPROXIMATION TO THE */
/*     GRADIENT BY FINITE (FORWARD AND CENTRAL) DIFFERENCES USING THE */
/*     METHOD OF REF. 1.  THE FOLLOWING INPUT COMPONENT IS OF INTEREST */
/*     IN THIS REGARD (AND IS NOT DESCRIBED IN   MNG). */

/* V(ETA0)..... V(42) IS AN ESTIMATED BOUND ON THE RELATIVE ERROR IN THE */
/*             OBJECTIVE FUNCTION VALUE COMPUTED BY CALCF... */
/*                  (TRUE VALUE) = (COMPUTED VALUE) * (1 + E), */
/*             WHERE ABS(E) .LE. V(ETA0).  DEFAULT = MACHEP * 10**3, */
/*             WHERE MACHEP IS THE UNIT ROUNDOFF. */

/*        THE OUTPUT VALUES IV(NFCALL) AND IV(NGCALL) HAVE DIFFERENT */
/*     MEANINGS FOR   MNF THAN FOR   MNG... */

/* IV(NFCALL)... IV(6) IS THE NUMBER OF CALLS SO FAR MADE ON CALCF (I.E., */
/*             FUNCTION EVALUATIONS) EXCLUDING THOSE MADE ONLY FOR */
/*             COMPUTING GRADIENTS.  THE INPUT VALUE IV(MXFCAL) IS A */
/*             LIMIT ON IV(NFCALL). */
/* IV(NGCALL)... IV(30) IS THE NUMBER OF FUNCTION EVALUATIONS MADE ONLY */
/*             FOR COMPUTING GRADIENTS.  THE TOTAL NUMBER OF FUNCTION */
/*             EVALUATIONS IS THUS  IV(NFCALL) + IV(NGCALL). */

/*  ***  REFERENCE  *** */

/* 1. STEWART, G.W. (1967), A MODIFICATION OF DAVidoN*S MINIMIZATION */
/*        METHOD TO ACCEPT DIFFERENCE APPROXIMATIONS OF DERIVATIVES, */
/*        J. ASSOC. COMPUT. MACH. 14, PP. 72-83. */
/* . */
/*  ***  GENERAL  *** */

/*     CODED BY DAVID M. GAY (WINTER 1980).  REVISED SEPT. 1982. */
/*     THIS SUBROUTINE WAS WRITTEN IN CONNECTION WITH RESEARCH */
/*     SUPPORTED IN PART BY THE NATIONAL SCIENCE FOUNDATION UNDER */
/*     GRANTS MCS-7600324, DCR75-10143, 76-14311DSS, MCS76-11989, */
/*     AND MCS-7906671. */


/* ----------------------------  DECLARATIONS  --------------------------- */


/*  RMNF.... OVERSEES COMPUTATION OF FINITE-DIFFERENCE GRADIENT AND */
/*         CALLS  RMNG TO CARRY OUT   MNG ALGORITHM. */


/*  ***  SUBSCRIPTS FOR IV   *** */


/* /6 */
/*     DATA NFCALL/6/, TOOBIG/2/ */
/* /7 */
/* / */

/* +++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++ */

    /* Parameter adjustments */
    --x;
    --d__;
    --iv;
    --v;
    --uiparm;
    --urparm;

    /* Function Body */
L10:
    rmnf_(&d__[1], &fx, &iv[1], liv, lv, n, &v[1], &x[1]);
    if (iv[1] > 2) {
	goto L999;
    }

/*     ***  COMPUTE FUNCTION  *** */

    nf = iv[6];
    (*calcf)(n, &x[1], &nf, &fx, &uiparm[1], &urparm[1], (U_fp)ufparm);
    if (nf <= 0) {
	iv[2] = 1;
    }
    goto L10;


L999:
    return 0;
/*  ***  LAST CARD OF   MNF FOLLOWS  *** */
} /* mnf_ */

