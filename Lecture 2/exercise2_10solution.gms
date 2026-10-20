* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 2
* Exercise 10

options mip = cplex, optcr = 0;

sets
c   Options of candidate generating units   /c1*c5/
t   Representative time periods /t1*t4/
;

scalar
CGF     Fixed cost of generating unit g [€]                             /100/
CGI     Investment cost [€\MW]                                          /5000/
CGV     Variable cost of generating unit g [€\MWh]                      /20/
CImax   Investment budget [€]                                           /180000/
CRF     Capital recovery factor                                         /0.10086/
PDASmax Upper limit of the power sold from the day-ahead market [MW]    /400/
;

parameter LambdaDAS(t) Selling day-ahead market price in representative time period t [€\MWh]
/
t1  200
t2  15
t3  140
t4  80
/
;

parameter Rho(t) Weight of representative time period t [h]
/
t1  2000
t2  3500
t3  800
t4  2460
/
;

parameter PGminNew(c) Minimum power output of candidate option c [MW]
/
c1  30
c2  35
c3  40
c4  45
c5  50
/
;

Scalar
PGminimum Minimum value of PGminNew(c) for all c [MW] /30/
;

parameter PGmaxNew(c) Capacity of candidate option c [MW]
/
c1  300
c2  350
c3  400
c4  450
c5  500
/
;

Scalar
PGmaximum Maximum value of PGmaxNew(c) for all c [MW] /500/
;

variables
zOF Objective function value [€]
;

positive variables
pG      Power produced by generating unit g [MW]
pGmax   Maximum capacity of generating unit built [MW]
pGmin   Minimum power output of generating unit built [MW]
;

binary variables
uG      Commitment status of generating unit
vG(c)   Binary variable associated with the investment in candidate option c
;

equations
of      Objective function
eq1     Definition of pg associated with PDASmax
eq2     Investment cost limit
eq3     Definition of pGmax
eq4     Upper limit of the sum of vG
eq5     Definition of pGmin
eq6     First upper limit of pG resulting from linearizing uG*vG 
eq7     First lower limit of pG resulting from linearizing uG*vG
eq8     Second upper limit of pG resulting from linearizing uG*vG 
eq9     Second lower limit of pG resulting from linearizing uG*vG
eq10    Upper limit of vG associated with the sum of vG
;

of..        zOF =E= sum(t, Rho(t)*( LambdaDAS(t)*pG(t) - CGF*uG(t) - CGV*pG(t) ) ) - CGI*CRF*pGmax;
eq1(t)..    pG(t) =L= PDASmax;
eq2..       CGI*CRF*pGmax =L= CImax;
eq3..       pGmax =E= sum(c, PGmaxNew(c)*vG(c) );
eq4..       sum(c, vG(c) ) =L= 1;
eq5..       pGmin =E= sum(c, PGminNew(c)*vG(c) );
eq6(t)..    pG(t) =L= pGmax;
eq7(t)..    pGmin - PGmaximum*(1-uG(t)) =L= pG(t);
eq8(t)..    pG(t) =L= PGmaximum*uG(t);
eq9(t)..    PGminimum*uG(t) =L= pG(t);
eq10(t)..   uG(t) =L= sum(c, vG(c) );

model exercise2_10 /all/;

solve exercise2_10 maximizing zOF using mip;

display zOF.L;
