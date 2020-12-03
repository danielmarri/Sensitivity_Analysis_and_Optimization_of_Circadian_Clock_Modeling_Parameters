      SUBROUTINE DB1SLC(X,Y,NB,IZE,BR,BI,NCALC)
C THIS ROUTINE CALCULATES BESSEL FUNCTIONS I AND J OF
C COMPLEX ARGUMENT AND INTEGER ORDER.
C
C
C      EXPLANATION OF VARIABLES IN THE CALLING SEQUENCE
C
C X     DOUBLE PRECISION REAL PART OF THE COMPLEX ARGUMENT
C       FOR WHICH I*S OR J*S ARE TO BE CALCULATED.  IF I*S
C       ARE TO BE CALCULATED, ABS(X) MUST NOT EXCEED EXPARG
C       (WHICH SEE BELOW).
C Y     IMAGINARY PART OF THE ARGUMENT.  IF J*S ARE TO BE
C       CALCULATED, ABS(Y) MUST NOT EXCEED EXPARG.
C NB    INTEGER TYPE.  1 + HIGHEST ORDER TO BE CALCULATED.
C       IT MUST BE POSITIVE.
C IZE   INTEGER TYPE.  ZERO IF J*S ARE TO BE CALCULATED, 1
C       IF I*S ARE TO BE CALCULATED.
C BR    DOUBLE PRECISION VECTOR OF LENGTH NB, NEED NOT BE
C       INITIALIZED BY USER.  IF THE ROUTINE TERMINATES
C       NORMALLY, (NCALC=NB), IT RETURNS THE REAL PART OF
C       J(OR I)-SUB-ZERO THROUGH J(OR I)-SUB-NB-MINUS-ONE
C       OF Z IN THIS VECTOR.
C BI    IMAGINARY ANALOG OF BR.
C NCALC INTEGER TYPE, NEED NOT BE INITIALIZED BY USER.
C       BEFORE USING THE RESULTS, THE USER SHOULD CHECK THAT
C       NCALC=NB, I.E. ALL ORDERS HAVE BEEN CALCULATED TO
C       THE DESIRED ACCURACY.  SEE ERROR RETURNS BELOW.
C
C
C       EXPLANATION OF MACHINE-DEPENDENT CONSTANTS
C
C NSIG  DECIMAL SIGNIFICANCE DESIRED.  SHOULD BE SET TO
C       IFIX(ALOG10(2)*NBIT+1), WHERE NBIT IS THE NUMBER OF
C       BITS IN THE MANTISSA OF A DOUBLE PRECISION VARIABLE.
C       SETTING NSIG HIGHER WILL INCREASE CPU TIME WITHOUT
C       INCREASING ACCURACY, WHILE SETTING NSIG LOWER WILL
C       DECREASE ACCURACY.  IF ONLY SINGLE-PRECISION
C       ACCURACY IS DESIRED, REPLACE NBIT BY THE NUMBER OF
C       BITS IN THE MANTISSA OF A SINGLE-PRECISION VARIABLE.
C       THE RELATIVE TRUNCATION ERROR IS LIMITED TO T=.5*10
C       **-NSIG FOR ORDER GREATER THAN ABS(Z), AND FOR ORDER
C       LESS THAN ABS(Z) (GENERAL TEST), THE RELATIVE ERROR
C       IS LIMITED TO T FOR FUNCTION VALUES OF MAGNITUDE AT
C       LEAST 1, AND THE ABSOLUTE ERROR IS LIMITED TO T FOR
C       SMALLER VALUES.
C NTEN  LARGEST INTEGER K SUCH THAT 10**K IS MACHINE-
C       REPRESENTABLE IN DOUBLE PRECISION.
C LARGEZ UPPER LIMIT ON THE MAGNITUDE OF Z.  BEAR IN MIND
C       THAT IF ABS(Z)=N, THEN AT LEAST N ITERATIONS OF THE
C       BACKWARD RECURSION WILL BE EXECUTED.
C EXPARG LARGEST DOUBLE PRECISION ARGUMENT THAT THE LIBRARY
C       DEXP ROUTINE CAN HANDLE.
C
C PORT NOTE, SEPTEMBER 16, 1976 -
C THE LARGEX AND EXPARG TESTS ARE MADE IN THE OUTER ROUTINES -
C DBESCJ AND DBESCI, WHICH CALL DB1SLR.
C
C
C
C                            ERROR RETURNS
C
C PORT NOTE, SEPTEMBER 16, 1976 -
C THE NOTES BELOW ARE KEPT IN FOR THE RECORD, BUT, AS ABOVE,
C THE ACTUAL TESTS ARE NOW IN THE OUTER CALLING ROUTINES.
C
C       LET G DENOTE EITHER I OR J.
C       IN CASE OF AN ERROR, NCALC.NE.NB, AND NOT ALL G*S
C  ARE CALCULATED TO THE DESIRED ACCURACY.
C       IF NCALC.LT.0, AN ARGUMENT IS OUT OF RANGE.  NB.LE.0
C  OR IZE IS NEITHER 0 NOR 1 OR IZE=0 AND ABS(Y).GT.EXPARG,
C  OR IZE=1 AND ABS(X).GT.EXPARG.  IN THIS CASE, THE VECTORS
C  BR AND BI ARE NOT CALCULATED, AND NCALC IS SET TO
C  MIN0(NB,0)-1 SO NCALC.NE.NB.
C       NB.GT.NCALC.GT.0 WILL OCCUR IF NB.GT.MAGZ AND ABS(G-
C  SUB-NB-OF-Z/G-SUB-MAGX+NP-OF-Z).LT.10.**(NTEN/2), I.E. NB
C  IS MUCH GREATER THAN MAGZ.  IN THIS CASE, BR(N) AND BI(N)
C  ARE CALCULATED TO THE DESIRED ACCURACY FOR N.LE.NCALC,
C  BUT FOR NCALC.LT.N.LE.NB, PRECISION IS LOST.  IF N.GT.
C  NCALC AND ABS(G(NCALC-1)/G(N-1)).EQ.10**-K, THEN THE LAST
C  K SIGNIFICANT FIGURES OF G(N-1) (=BR(N)+I*BI(N)) ARE
C  ERRONEOUS.  IF THE USER WISHES TO CALCULATE G(N-1) TO
C  HIGHER ACCURACY, HE SHOULD USE AN ASYMPTOTIC FORMULA FOR
C  LARGE ORDER.
C
      DOUBLE PRECISION DLOG10, DSQRT, DEXP, DCOS, DSIN,
     1 X,Y,BR,BI,PR,PI,PLASTR,PLASTI,POLDR,POLDI,PSAVER,
     2 PSAVEI,TEST,TOVER,TEMPAR,TEMPAI,TEMPBR,TEMPBI,
     3 TEMPCR,TEMPCI,SIGN,SUMR,SUMI,ZINVR,ZINVI,D1MACH
      DIMENSION BR(NB),BI(NB)
      DATA NSIG/0/, NTEN/0/
      IF(NSIG .NE. 0) GO TO 1
      NSIG = IFIX(-ALOG10(SNGL(D1MACH(3)))+1.)
      NTEN = DLOG10(D1MACH(2))
    1 TEMPAR=DSQRT(X*X+Y*Y)
      MAGZ=IFIX(SNGL(TEMPAR))
      SIGN=DBLE(FLOAT(1-2*IZE))
      NCALC=NB
C USE 2-TERM ASCENDING SERIES FOR SMALL Z
      IF(TEMPAR**4.LT..1D0**NSIG) GO TO 50
C INITIALIZE THE CALCULATION OF THE P*S
      NBMZ=NB-MAGZ
      N=MAGZ+1
      IF(DABS(X).LT.DABS(Y)) GO TO 2
      ZINVR=1.D0/(X+Y*Y/X)
      ZINVI=-Y*ZINVR/X
      GO TO 3
    2 ZINVI=-1.D0/(Y+X*X/Y)
      ZINVR=-X*ZINVI/Y
    3 PLASTR=1.D0
      PLASTI=0.D0
      PR=SIGN*DBLE(FLOAT(2*N))*ZINVR
      PI=SIGN*DBLE(FLOAT(2*N))*ZINVI
      TEST=2.D0*1.D1**NSIG
      M=0
      IF(NBMZ.LT.3) GO TO 6
C CALCULATE P*S UNTIL N=NB-1.  CHECK FOR POSSIBLE OVERFLOW.
      TOVER=1.D1**(NTEN-NSIG)
      NSTART=MAGZ+2
      NEND=NB-1
      DO 5 N=NSTART,NEND
      POLDR=PLASTR
      POLDI=PLASTI
      PLASTR=PR
      PLASTI=PI
      PR=SIGN*(DBLE(FLOAT(2*N))*(PLASTR*ZINVR-PLASTI*ZINVI)-POLDR)
      PI=SIGN*(DBLE(FLOAT(2*N))*(PLASTI*ZINVR+PLASTR*ZINVI)-POLDI)
      IF((PR/TOVER)**2+(PI/TOVER)**2-1.D0) 5,5,7
    5 CONTINUE
      N=NEND
C CALCULATE SPECIAL SIGNIFICANCE TEST FOR NBMZ.GT.2.
      TEMPBI=DMAX1(DABS(PR),DABS(PI))
      TEMPBI=TEMPBI*DSQRT(2.D0*1.D1**NSIG*DSQRT(((PR/TEMPBI)**2
     1+(PI/TEMPBI)**2)*((PLASTR/TEMPBI)**2+(PLASTI/TEMPBI)**2)))
      TEST=DMAX1(TEST,TEMPBI)
C CALCULATE P*S UNTIL SIGNIFICANCE TEST IS PASSED.
    6 N=N+1
      POLDR=PLASTR
      POLDI=PLASTI
      PLASTR=PR
      PLASTI=PI
      PR=SIGN*(DBLE(FLOAT(2*N))*(PLASTR*ZINVR-PLASTI*ZINVI)-POLDR)
      PI=SIGN*(DBLE(FLOAT(2*N))*(PLASTI*ZINVR+PLASTR*ZINVI)-POLDI)
      IF((PR/TEST)**2+(PI/TEST)**2.LT.1.D0) GO TO 6
      IF(M.EQ.1) GO TO 12
C CALCULATE STRICT VARIANT OF SIGNIFICANCE TEST, AND
C CALCULATE P*S UNTIL THIS TEST IS PASSED.
      M=1
      TEMPBI=DMAX1(DABS(PR),DABS(PI))
      TEMPBR=DSQRT(((PR/TEMPBI)**2+(PI/TEMPBI)**2)/
     1 ((PLASTR/TEMPBI)**2+(PLASTI/TEMPBI)**2))
      TEMPBI=DBLE(FLOAT(N+1))/TEMPAR
      IF(TEMPBR+1.D0/TEMPBR.GT.2.D0*TEMPBI) TEMPBR=TEMPBI
     1 +DSQRT(TEMPBI**2-1.D0)
      TEST=TEST/DSQRT(TEMPBR-1.D0/TEMPBR)
      IF((PR/TEST)**2+(PI/TEST)**2-1.D0) 6,12,12
    7 NSTART=N+1
C TO AVOID OVERFLOW, NORMALIZE P*S BY DIVIDING BY TOVER.
C CALCULATE P*S UNTIL UNNORMALIZED P WOULD OVERFLOW.
      PR=PR/TOVER
      PI=PI/TOVER
      PLASTR=PLASTR/TOVER
      PLASTI=PLASTI/TOVER
      PSAVER=PR
      PSAVEI=PI
      TEMPCR=PLASTR
      TEMPCI=PLASTI
      TEST=1.D1**(2*NSIG)
    8 N=N+1
      POLDR=PLASTR
      POLDI=PLASTI
      PLASTR=PR
      PLASTI=PI
      PR=SIGN*(DBLE(FLOAT(2*N))*(PLASTR*ZINVR-PLASTI*ZINVI)-POLDR)
      PI=SIGN*(DBLE(FLOAT(2*N))*(PLASTI*ZINVR+PLASTR*ZINVI)-POLDI)
      IF(PR**2+PI**2.LE.TEST) GO TO 8
C CALCULATE BACKWARD TEST, AND FIND NCALC, THE HIGHEST N
C SUCH THAT THE TEST IS PASSED.
      TEMPBR=DSQRT((PLASTR**2+PLASTI**2)/(POLDR**2+POLDI**2))
      TEMPBI=DBLE(FLOAT(N))/TEMPAR
      IF(TEMPBR+1.D0/TEMPBR.GT.2.D0*TEMPBI) TEMPBR=TEMPBI+
     1 DSQRT(TEMPBI**2-1.D0)
      TEST=.5D0*(1.D0-1.D0/TEMPBR**2)/1.D1**NSIG
      TEST=((PLASTR**2+PLASTI**2)*TEST)*((POLDR**2+POLDI**2)*TEST)
      PR=PLASTR*TOVER
      PI=PLASTI*TOVER
      N=N-1
      NEND=MIN0(NB,N)
      DO 9 NCALC=NSTART,NEND
      POLDR=TEMPCR
      POLDI=TEMPCI
      TEMPCR=PSAVER
      TEMPCI=PSAVEI
      PSAVER=SIGN*(DBLE(FLOAT(2*N))*(TEMPCR*ZINVR-TEMPCI*ZINVI)-POLDR)
      PSAVEI=SIGN*(DBLE(FLOAT(2*N))*(TEMPCI*ZINVR+TEMPCR*ZINVI)-POLDI)
      IF((PSAVER**2+PSAVEI**2)*(TEMPCR**2+TEMPCI**2)-TEST) 9,9,10
    9 CONTINUE
      NCALC=NEND+1
   10 NCALC=NCALC-1
C THE COEFFICIENT OF B(N) IN THE NORMALIZATION SUM IS
C M*SQRT(-1)**IMAG, WHERE M=-2,0, OR 2, AND IMAG IS 0 OR 1.
C CALCULATE RECURSION RULES FOR M AND IMAG, AND INITIALIZE
C THEM.
   12 N=N+1
      TEMPBR=DBLE(FLOAT(IZE))*X+DBLE(FLOAT(1-IZE))*Y
      IPOS=0
      IF(TEMPBR) 13,14,13
   13 IPOS=IFIX(SNGL(1.1D0*TEMPBR/DABS(TEMPBR)))
   14 MRECUR=4*((2+IZE+IPOS)/2)-3-2*(IZE+IPOS)
      K=2+IPOS+2*IZE*IPOS**2-IZE
      L=N-4*(N/4)
      MLAST=2+8*((K*L)/4)-4*((K*L)/2)
      IF(IPOS.EQ.0.AND.(L.EQ.1.OR.L.EQ.3)) MLAST=0
      L=L+3-4*((L+3)/4)
      M    =2+8*((K*L)/4)-4*((K*L)/2)
      IF(IPOS.EQ.0.AND.(L.EQ.1.OR.L.EQ.3)) M=0
      IMRECR=(1-IZE)*IPOS**2
      IMAG=IMRECR*(L-2*(L/2))
C INITIALIZE THE BACKWARD RECURSION AND THE NORMALIZATION
C SUM.
      TEMPBR=0.D0
      TEMPBI=0.D0
      IF(DABS(PI).GT.DABS(PR)) GO TO 15
      TEMPAR=1.D0/(PR+PI*(PI/PR))
      TEMPAI=-(PI*TEMPAR)/PR
      GO TO 16
   15 TEMPAI=-1.D0/(PI+PR*(PR/PI))
      TEMPAR=-(PR*TEMPAI)/PI
   16 IF(IMAG.NE.0) GO TO 17
      SUMR=DBLE(FLOAT(M))*TEMPAR
      SUMI=DBLE(FLOAT(M))*TEMPAI
      GO TO 18
   17 SUMR=-DBLE(FLOAT(M))*TEMPAI
      SUMI=DBLE(FLOAT(M))*TEMPAR
   18 NEND=N-NB
      IF(NEND) 26,22,19
C RECUR BACKWARD VIA DIFFERENCE EQUATION CALCULATING (BUT
C NOT STORING) BR(N) AND BI(N) UNTIL N=NB.
   19 DO 21 L=1,NEND
      N=N-1
      TEMPCR=TEMPBR
      TEMPCI=TEMPBI
      TEMPBR=TEMPAR
      TEMPBI=TEMPAI
      PR=DBLE(FLOAT(2*N))*ZINVR
      PI=DBLE(FLOAT(2*N))*ZINVI
      TEMPAR=PR*TEMPBR-PI*TEMPBI-SIGN*TEMPCR
      TEMPAI=PR*TEMPBI+PI*TEMPBR-SIGN*TEMPCI
      IMAG=(1-IMAG)*IMRECR
      K=MLAST
      MLAST=M
      M=K*MRECUR
      IF(IMAG.NE.0) GO TO 20
      SUMR=SUMR+DBLE(FLOAT(M))*TEMPAR
      SUMI=SUMI+DBLE(FLOAT(M))*TEMPAI
      GO TO 21
   20 SUMR=SUMR-DBLE(FLOAT(M))*TEMPAI
      SUMI=SUMI+DBLE(FLOAT(M))*TEMPAR
   21 CONTINUE
C STORE BR(NB), BI(NB)
   22 BR(N)=TEMPAR
      BI(N)=TEMPAI
      IF(N.GT.1) GO TO 23
C NB=1.  SINCE 2*TEMPAR AND 2*TEMPAI WERE ADDED TO SUMR AND
C SUMI RESPECTIVELY, WE MUST SUBTRACT TEMPAR AND TEMPAI
      SUMR=SUMR-TEMPAR
      SUMI=SUMI-TEMPAI
      GO TO 35
C CALCULATE AND STORE BR(NB-1),BI(NB-1)
   23 N=N-1
      PR=DBLE(FLOAT(2*N))*ZINVR
      PI=DBLE(FLOAT(2*N))*ZINVI
      BR(N)=PR*TEMPAR-PI*TEMPAI-SIGN*TEMPBR
      BI(N)=PR*TEMPAI+PI*TEMPAR-SIGN*TEMPBI
      IF(N.EQ.1) GO TO 34
      IMAG=(1-IMAG)*IMRECR
      K=MLAST
      MLAST=M
      M=K*MRECUR
      IF(IMAG.NE.0) GO TO 24
      SUMR=SUMR+DBLE(FLOAT(M))*BR(N)
      SUMI=SUMI+DBLE(FLOAT(M))*BI(N)
      GO TO 30
   24 SUMR=SUMR-DBLE(FLOAT(M))*BI(N)
      SUMI=SUMI+DBLE(FLOAT(M))*BR(N)
      GO TO 30
C N.LT.NB, SO STORE BR(N), BI(N), AND SET HIGHER ORDERS ZERO
   26 BR(N)=TEMPAR
      BI(N)=TEMPAI
      NEND=-NEND
      DO 27 L=1,NEND
      NPL=N+L
      BR(NPL)=0.D0
   27 BI(NPL)=0.D0
   30 NEND=N-2
      IF(NEND.EQ.0) GO TO 33
C CALCULATE VIA DIFFERENCE EQUATION AND STORE BR(N),BI(N),
C UNTIL N=2
      DO 32 L=1,NEND
      N=N-1
      PR=DBLE(FLOAT(2*N))*ZINVR
      PI=DBLE(FLOAT(2*N))*ZINVI
      BR(N)=PR*BR(N+1)-PI*BI(N+1)-SIGN*BR(N+2)
      BI(N)=PR*BI(N+1)+PI*BR(N+1)-SIGN*BI(N+2)
      IMAG=(1-IMAG)*IMRECR
      K=MLAST
      MLAST=M
      M=K*MRECUR
      IF(IMAG.NE.0) GO TO 31
      SUMR=SUMR+DBLE(FLOAT(M))*BR(N)
      SUMI=SUMI+DBLE(FLOAT(M))*BI(N)
      GO TO 32
   31 SUMR=SUMR-DBLE(FLOAT(M))*BI(N)
      SUMI=SUMI+DBLE(FLOAT(M))*BR(N)
   32 CONTINUE
C CALCULATE AND STORE BR(1), BI(1)
   33 BR(1)=2.D0*(BR(2)*ZINVR-BI(2)*ZINVI)-SIGN*BR(3)
      BI(1)=2.D0*(BR(2)*ZINVI+BI(2)*ZINVR)-SIGN*BI(3)
   34 SUMR=SUMR+BR(1)
      SUMI=SUMI+BI(1)
C CALCULATE NORMALIZATION FACTOR, TEMPAR +I*TEMPAI
   35 IF(IZE.EQ.1) GO TO 36
      TEMPCR=DBLE(FLOAT(IPOS))*Y
      TEMPCI=DBLE(FLOAT(-IPOS))*X
      GO TO 37
   36 TEMPCR=DBLE(FLOAT(IPOS))*X
      TEMPCI=DBLE(FLOAT(IPOS))*Y
   37 TEMPCR=DEXP(TEMPCR)
      TEMPBR=DCOS(TEMPCI)
      TEMPBI=DSIN(TEMPCI)
      IF(DABS(SUMR).LT.DABS(SUMI)) GO TO 38
      TEMPCI=SUMI/SUMR
      TEMPCR=(TEMPCR/SUMR)/(1.D0+TEMPCI*TEMPCI)
      TEMPAR=TEMPCR*(TEMPBR+TEMPBI*TEMPCI)
      TEMPAI=TEMPCR*(TEMPBI-TEMPBR*TEMPCI)
      GO TO 39
   38 TEMPCI=SUMR/SUMI
      TEMPCR=(TEMPCR/SUMI)/(1.D0+TEMPCI*TEMPCI)
      TEMPAR=TEMPCR*(TEMPBR*TEMPCI+TEMPBI)
      TEMPAI=TEMPCR*(TEMPBI*TEMPCI-TEMPBR)
C NORMALIZE
   39 DO 40 N=1,NB
      TEMPBR=BR(N)*TEMPAR-BI(N)*TEMPAI
      BI(N)=BR(N)*TEMPAI+BI(N)*TEMPAR
   40 BR(N)=TEMPBR
      RETURN
C TWO-TERM ASCENDING SERIES FOR SMALL Z
   50 TEMPAR=1.D0
      TEMPAI=0.D0
      TEMPCR=.25D0*(X*X-Y*Y)
      TEMPCI=.5D0*X*Y
      BR(1)=1.D0-SIGN*TEMPCR
      BI(1)=-SIGN*TEMPCI
      IF(NB.EQ.1) GO TO 52
      DO 51 N=2,NB
      TEMPBR=(TEMPAR*X-TEMPAI*Y)/DBLE(FLOAT(2*N-2))
      TEMPAI=(TEMPAR*Y+TEMPAI*X)/DBLE(FLOAT(2*N-2))
      TEMPAR=TEMPBR
      TEMPBR=DBLE(FLOAT(N))
      BR(N)=TEMPAR*(1.D0-SIGN*TEMPCR/TEMPBR)+TEMPAI*TEMPCI/TEMPBR
   51 BI(N)=TEMPAI*(1.D0-SIGN*TEMPCR/TEMPBR)-TEMPAR*TEMPCI/TEMPBR
   52 RETURN
      END
