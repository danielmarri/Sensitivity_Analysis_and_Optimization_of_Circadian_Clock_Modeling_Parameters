/* i8tsel.f -- translated by f2c (version 20100827).
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

integer i8tsel_(integer *inow)
{
    /* Initialized data */

    static integer ienter = 0;

    /* System generated locals */
    integer ret_val;


/*  TO RETURN I8TSEL = THE POINTER TO THE CURRENT ENTER-BLOCK AND */
/*  SET THE CURRENT POINTER TO INOW. */

/*  START WITH NO BACK-POINTER. */


    ret_val = ienter;
    if (*inow >= 0) {
	ienter = *inow;
    }

    return ret_val;

} /* i8tsel_ */

