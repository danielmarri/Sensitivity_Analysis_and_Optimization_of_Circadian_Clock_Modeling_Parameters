#pragma once
#include<AMIGO_problem.h>
#include <f2c.h>
#include <de.h>

//static int c__2 = 2;

int dn2fb_(integer *n, integer *p, doublereal *x, doublereal *b, 
           integer *iv, integer *liv, integer *lv, doublereal *v, 
           integer *ui, 
           doublereal *ur, void* data);

int dn2gb_(integer *n, integer *p, doublereal *x, doublereal *b,
           integer *iv, integer *liv, integer *lv, doublereal *v,
           integer *uiparm, doublereal *urparm,void* data);

int calcr_(int *n, int *p, double *x, int *nf, double *r__, int *lty, 
           double *ty, void*data);

int divset_(integer *alg, integer *iv, integer *liv, integer 
            *lv, doublereal *v);


EXPORTIT int NL2SOL_AMIGO_pe(AMIGO_problem* amigo_problem, int gradient);

EXPORTIT int sres_AMIGO_pe(AMIGO_problem* amigo_problem);

EXPORTIT int DE_AMIGO_pe(AMIGO_problem* amigo_problem);