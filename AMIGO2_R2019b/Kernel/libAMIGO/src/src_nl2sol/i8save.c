/* i8save.f -- translated by f2c (version 20100827).
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

integer i8save_(integer *isw, integer *ivalue, logical *set)
{
    /* Initialized data */

    static struct {
	integer e_1[2];
	} equiv_1 = { 0, 2 };


    /* System generated locals */
    integer ret_val;

    /* Local variables */
#define iparam ((integer *)&equiv_1)
#define lrecov ((integer *)&equiv_1 + 1)
#define lerror ((integer *)&equiv_1)


/*  IF (ISW = 1) I8SAVE RETURNS THE CURRENT ERROR NUMBER AND */
/*               SETS IT TO IVALUE IF SET = .TRUE. . */

/*  IF (ISW = 2) I8SAVE RETURNS THE CURRENT RECOVERY SWITCH AND */
/*               SETS IT TO IVALUE IF SET = .TRUE. . */



/*  START EXECUTION ERROR FREE AND WITH RECOVERY TURNED OFF. */


    ret_val = iparam[(0 + (0 + (*isw - 1 << 2))) / 4];
    if (*set) {
	iparam[*isw - 1] = *ivalue;
    }

    return ret_val;

} /* i8save_ */

#undef lerror
#undef lrecov
#undef iparam


