/* eigen.f -- translated by f2c (version 20100827).
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

union {
    struct {
	real dstak[500];
    } _1;
    struct {
	doublereal eqv_pad[500];
    } _2;
} cstak_;

#define cstak_1 (cstak_._1)
#define cstak_2 (cstak_._2)

/* Table of constant values */

static integer c__29 = 29;
static integer c__1 = 1;
static integer c__2 = 2;
static integer c__3 = 3;
static integer c__34 = 34;

/* Subroutine */ int eigen_(integer *nm, integer *n, real *a, real *wr, real *
	wi, real *z__)
{
    /* System generated locals */
    integer a_dim1, a_offset, z_dim1, z_offset;

    /* Local variables */
    extern /* Subroutine */ int hqr2_(integer *, integer *, integer *, 
	    integer *, real *, real *, real *, real *, integer *);
    static integer ierr, iort;
    extern /* Subroutine */ int orthe_(integer *, integer *, integer *, 
	    integer *, real *, real *);
#define rstak ((real *)&cstak_1)
    extern /* Subroutine */ int ortra_(integer *, integer *, integer *, 
	    integer *, real *, real *, real *), seterr_(char *, integer *, 
	    integer *, integer *, ftnlen);
    extern integer istkgt_(integer *, integer *);
    extern /* Subroutine */ int istkrl_(integer *);




/* EIGEN FINDS THE EIGENVALUES AND EIGENVECTORS */
/* OF A REAL MATRIX (NOT IMAGINARY) BY */
/* CALLING THE SEQUENCE OF SUBROUTINES */
/* ORTHE,ORTRA, AND HQR2, WHICH, IN TURN, ARE */
/* THE EISPACK ROUTINES ORTHES, ORTRAN, AND HQR2, */
/* ADJUSTED FOR USE IN THE PORT LIBRARY. */

/* ON INPUT - */

/*   NM - AN INTEGER INPUT VARIABLE SET EQUAL TO */
/*        THE ROW DIMENSION OF THE TWO-DIMENSIONAL ARRAYS */
/*        A AND Z AS SPECIFIED IN THE DIMENSION STATEMENTS */
/*        FOR A AND Z IN THE CALLING PROGRAM. */

/*   N -  AN INTEGER INPUT VARIABLE SET EQUAL TO THE */
/*        ORDER OF THE MATRIX A. */

/*     N MUST NOT BE GREATER THAN NM. */

/*   A - THE MATRIX, A REAL TWO-DIMENSIONAL */
/*       ARRAY WITH ROW DIMENSION NM AND COLUMN */
/*       DIMENSION AT LEAST N. */

/*     A IS OVERWRITTEN. */



/* ON OUTPUT - */

/*   WR - A REAL ARRAY OF DIMENSION */
/*        AT LEAST N CONTAINING THE REAL PARTS OF THE EIGENVALUES */

/*   WI - A REAL ARRAY OF DIMENSION */
/*        AT LEAST N CONTAINING THE IMAGINARY PARTS OF THE EIGENVALUES. */

/*     THE EIGENVALUES ARE UNORDERED EXCEPT THAT */
/*     COMPLEX CONJUGATE PAIRS OF EIGENVALUES */
/*     APPEAR CONSECUTIVELY WITH THE EIGENVALUE HAVING */
/*     THE POSITIVE IMAGINARY PART FIRST. */

/*   Z - A REAL TWO-DIMENSIONAL ARRAY */
/*       WITH ROW DIMENSION NM AND COLUMN DIMENSION */
/*       AT LEAST N CONTAINING THE REAL AND IMAGINARY PARTS */
/*       OF THE EIGENVECTORS. */

/*       IF THE J-TH EIGENVALUE IS REAL, THE J-TH */
/*       COLUMN OF Z CONTAINS ITS EIGENVECTOR. */

/*       IF THE J-TH EIGENVALUE IS COMPLEX WITH */
/*       POSITIVE REAL PART, THE J-TH AND (J+1)-TH */
/*       COLUMNS OF Z CONTAIN THE REAL AND IMAGINARY */
/*       PARTS OF ITS EIGENVECTOR. */

/*       THE CONJUGATE OF THIS VECTOR IS THE */
/*       EIGENVECTOR FOR THE CONJUGATE EIGENVALUE. */
/*       THE EIGENVECTORS ARE NOT NORMALIZED. */


/* ERROR STATES - */

/*          1 - N IS GREATER THAN NM */

/*          K - THE K-TH EIGENVALUE COULD NOT BE COMPUTED */
/*              WITHIN 30 ITERATIONS. */

/*              THE EIGENVALUES IN THE WR AND WRI ARRAYS */
/*              SHOULD BE CORRECT FOR INDICES */
/*              K+1, K+2,...,N, BUT NO EIGENVECTORS ARE COMPUTED. */




/* CHECK FOR INPUT ERROR IN N */

/* /6S */
/*     IF (N .GT. NM) CALL SETERR( */
/*    1   29H EIGEN - N IS GREATER THAN NM,29,1,2) */
/* /7S */
    /* Parameter adjustments */
    z_dim1 = *nm;
    z_offset = 1 + z_dim1;
    z__ -= z_offset;
    --wi;
    --wr;
    a_dim1 = *nm;
    a_offset = 1 + a_dim1;
    a -= a_offset;

    /* Function Body */
    if (*n > *nm) {
	seterr_(" EIGEN - N IS GREATER THAN NM", &c__29, &c__1, &c__2, (
		ftnlen)29);
    }
/* / */

/* ALLOCATE A SCRATCH VECTOR */
    iort = istkgt_(n, &c__3);

    orthe_(nm, n, &c__1, n, &a[a_offset], &rstak[iort - 1]);
    ortra_(nm, n, &c__1, n, &a[a_offset], &rstak[iort - 1], &z__[z_offset]);
    hqr2_(nm, n, &c__1, n, &a[a_offset], &wr[1], &wi[1], &z__[z_offset], &
	    ierr);

    if (ierr != 0) {
	goto L10;
    }
    istkrl_(&c__1);
    return 0;
/* /6S */
/* 10  CALL SETERR( */
/*    1   34H EIGEN - FAILED ON THAT EIGENVALUE,34,IERR,1) */
/* /7S */
L10:
    seterr_(" EIGEN - FAILED ON THAT EIGENVALUE", &c__34, &ierr, &c__1, (
	    ftnlen)34);
/* / */

    istkrl_(&c__1);
    return 0;
} /* eigen_ */

#undef rstak


