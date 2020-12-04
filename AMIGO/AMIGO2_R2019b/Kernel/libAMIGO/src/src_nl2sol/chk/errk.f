C$TEST ERRK
C TO RUN AS A MAIN PROGRAM REMOVE NEXT LINE
      SUBROUTINE ERRK
C***********************************************************************
C
C  TEST OF THE PORT PROGRAM STKDMP
C
C***********************************************************************
C
C  TEST OF THE STACK DUMP,  STKDMP
C
C     WRITTEN JANUARY 15, 1983 BY P. FOX
C
C     ALLOCATES AND DEALLOCATES SPACE AND DUMPS THE STACK.
C     THEN WRITES OVER PART OF THE STACK AND DUMPS IT.
C
C     FINALLY WRITES OVER THE HEADING INFORMATION, WHICH
C     CAUSES THE ENTIRE STACK TO BE DUMPED.
C
      INTEGER  IPNTR, RPNTR, ISTKGT, J, K, KK
C
      COMMON  /CSTAK/   DSTAK
      DOUBLE PRECISION  DSTAK(500)
      INTEGER           ISTAK(1000)
      REAL              RSTAK(1000)
      LOGICAL           LSTAK(1000)
C/R
C     REAL              CMSTAK(2,500)
C/C
      COMPLEX           CMSTAK(500)
C/
C
      EQUIVALENCE (DSTAK(1), ISTAK(1))
      EQUIVALENCE (DSTAK(1), LSTAK(1))
      EQUIVALENCE (DSTAK(1), RSTAK(1))
C/R
C     EQUIVALENCE (DSTAK(1), CMSTAK(1,1))
C     REAL ONES(2)
C     DATA ONES(1),ONES(2)/1., -1./
C/C
      EQUIVALENCE (DSTAK(1), CMSTAK(1))
      COMPLEX  ONES
      DATA ONES/(1., -1.)/
C/
C
C
C  SET UP STACK LOCATIONS FOR EACH TYPE OF VARIABLE -
C  LOGICAL, INTEGER, REAL, DOUBLE-PRECISION, AND
C  COMPLEX, AND STORE A -1 OF THE APPROPRIATE TYPE
C  OR, FOR LOGICALS STORE AN F (.FALSE.).
C
      IPNTR = ISTKGT(25, 1)
      CALL SETL(25, .FALSE., LSTAK(IPNTR))
      IPNTR = ISTKGT(25, 2)
      CALL SETI(25, -1, ISTAK(IPNTR))
      IPNTR = ISTKGT(25, 3)
      CALL SETR(25, -1.0, RSTAK(IPNTR))
      IPNTR = ISTKGT(25, 4)
      CALL SETD(25, -1.0D0, DSTAK(IPNTR))
      IPNTR = ISTKGT(25, 5)
C/R
C     CALL SETC(25, ONES, CMSTAK(1,IPNTR))
C/C
      CALL SETC(25, ONES, CMSTAK(IPNTR))
C/
C
C  NOW CALL STACK DUMP
C
      CALL STKDMP
C
C  NOW RELEASE ALL BUT THE FIRST ALLOCATION.
C
      CALL ISTKRL(4)
C
C  AND CALL THE STACK DUMP AGAIN
C
      CALL STKDMP
C
C  NOW (SO IT WILL LOOK LIKE A FRESH START)
C  RELEASE THE ONE OUTSTANDING ALLOCATION AND
C  ZERO-OUT THE ENTIRE STACK (BELOW THE BOOKKEEPING PART)
C
      CALL ISTKRL(1)
      DO 1 J = 11,1000
  1    ISTAK(J) = 0
C
C  THEN ALLOCATE FIRST 10 INTEGERS AND THEN 10 REALS.
C
       IPNTR = ISTKGT(10,2)
       RPNTR = ISTKGT(10,3)
C
      DO 2 J=1,10
        K = IPNTR+J-1
       KK = RPNTR+J-1
        ISTAK(K) = J
  2     RSTAK(KK) = FLOAT(J)
C
C  CALL STACK DUMP
C
      CALL STKDMP
C
C  NOW OVERWRITE PART OF THE STACK, SAY WITH 77
C
      DO 3 J=25,35
  3     ISTAK(J) = 77
C
C  DUMP THIS
C
      CALL STKDMP
C
C  NOW OVERWRITE EVEN THE BOOKKEEPING PART OF THE STACK
C
C  AND DUMP THINGS.
C
      DO 4 J=1,10
  4     ISTAK(J) = 99
C
      CALL STKDMP
C
      STOP
      END
      SUBROUTINE SETC(N,V,B)
C
C     SETC SETS THE N COMPLEX ITEMS IN B TO V
C
C/R
C     REAL B(2,N), V(2), V1, V2
C     V1 = V(1)
C     V2 = V(2)
C/C
      COMPLEX B(N),V
C/
C
      IF(N .LE. 0) RETURN
C
      DO 10 I = 1, N
C/R
C       B(1,I) = V1
C10     B(2,I) = V2
C/C
 10     B(I) = V
C/
C
      RETURN
C
      END
      SUBROUTINE SETD(N,V,B)
C
C     SETD SETS THE N DOUBLE PRECISION ITEMS IN B TO V
C
      DOUBLE PRECISION B(N),V
C
      IF(N .LE. 0) RETURN
C
      DO 10 I = 1, N
 10     B(I) = V
C
      RETURN
C
      END
      SUBROUTINE SETI(N,V,B)
C
C     SETI SETS THE N INTEGER ITEMS IN B TO V
C
      INTEGER B(N),V
C
      IF(N .LE. 0) RETURN
C
      DO 10 I = 1, N
 10     B(I) = V
C
      RETURN
C
      END
      SUBROUTINE SETL(N,V,B)
C
C     SETL SETS THE N LOGICAL ITEMS IN B TO V
C
      LOGICAL B(N),V
C
      IF(N .LE. 0) RETURN
C
      DO 10 I = 1, N
 10     B(I) = V
C
      RETURN
C
      END
      SUBROUTINE SETR(N,V,B)
C
C     SETR SETS THE N REAL ITEMS IN B TO V
C
      REAL B(N),V
C
      IF(N .LE. 0) RETURN
C
      DO 10 I = 1, N
 10     B(I) = V
C
      RETURN
C
      END