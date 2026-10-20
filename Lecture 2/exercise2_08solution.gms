* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 2
* Exercise 8

options mip = cplex, optcr = 0;

sets
c       Options of candidate generating units   /c1*c10/
g       Generating units                        /g1*g3/
gOld(g) Existing generating units               /g1/
gNew(g) Candidate generating units              /g2*g3/
t       Representative time periods             /t1*t4/
;

Scalars
CLS     Load-shedding cost [€\MWh]  /10000/
CRF     Capital recovery factor     /0.10086/
CImax   Investment budget [€]       /180000/
;

parameter Rho(t) Weight of representative time period t [h]
/
t1  2000
t2  3500
t3  800
t4  2460
/
;

parameter CGI(g) Investment cost of generating unit g [€\MW]
/
g2  2000
g3  3500
/
;

parameter CGV(g) Variable cost of generating unit g [€\MWh]
/
g1  10
g2  15
g3  8
/
;

parameter PD(t) Power demanded in representative time period t [MW]
/
t1  400
t2  400
t3  650
t4  900
/
;

parameter PGmaxOld(g) Capacity of existing generating unit g [MW]
/
g1  300
/
;

parameter PGmaxNew(g,c) Maximum capacity of candidate generating unit g and option c [MW]
/
g2.c1   50
g2.c2   100
g2.c3   150
g2.c4   200
g2.c5   400
g3.c1   50
g3.c2   100
g3.c3   150
g3.c4   200
g3.c5   250
g3.c6   300
g3.c7   350
g3.c8   400
g3.c9   450
g3.c10  500
/
;

variables
zOF Objective function value [€]
;

positive variables
pG(g,t)     Power produced by generating unit g in representative time period t [MW]
pGmax(g)    Capacity built of generating unit g [MW]
pLS(t)      Load-shedding power in representative time period t [MW]
;

binary variables
vG(g,c)     Binary variable associated with the investment in option c of candidate generating unit g
;

equations
of  Objective function
eq1 Investment cost limit
eq2 Definition of pGmax
eq3 Upper limit of the sum of vG
eq4 Energy balance equation
eq5 Upper limit of pLS
eq6 Upper limit of pG for existing generating units
eq7 Upper limit of pG for candidate generating units
;

of..                zOF =E= sum(t, Rho(t) * ( CLS*pLS(t) + sum(g, CGV(g)*pG(g,t) ) ) ) + sum(g$gNew(g), CGI(g)*CRF*pGmax(g) );
eq1..               sum(g$gNew(g), CGI(g)*CRF*pGmax(g) ) =L= CImax;
eq2(g)$gNew(g)..    pGmax(g) =E= sum(c, PGmaxNew(g,c)*vG(g,c) );
eq3(g)$gNew(g)..    sum(c, vG(g,c) ) =L= 1;
eq4(t)..            sum(g, pG(g,t) ) =E= PD(t) - pLS(t);
eq5(t)..            pLS(t) =L= PD(t);
eq6(g,t)$gOld(g)..  pG(g,t) =L= PGmaxOld(g);
eq7(g,t)$gNew(g)..  pG(g,t) =L= pGmax(g);

model exercise2_8 /all/;

solve exercise2_8 minimizing zOF using mip;

display zOF.L;
