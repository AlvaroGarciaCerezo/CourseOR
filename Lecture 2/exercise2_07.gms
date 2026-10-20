* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 2
* Exercise 7

options lp = cplex, optcr = 0;

sets
g       Generating units            /g1*g3/
gOld(g) Existing generating units   /g1/
gNew(g) Candidate generating units  /g2*g3/
t       Representative time periods /t1*t4/
;

Scalars
* Case a)
CImax   Investment budget [€]       /200000/
* Case b)
*CImax   Investment budget [€]   /180000/
* Case c)
*CImax   Investment budget [€]   /145000/  
CLS     Load-shedding cost [€\MWh]  /10000/
CRF     Capital recovery factor     /0.10086/
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

parameter PGmaxNew(g) Maximum capacity of candidate generating unit g [MW]
/
g2  400
g3  500
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

equations
of  Objective function
eq1 Investment cost limit
eq2 Upper limit of pGmax
eq3 Energy balance equation
eq4 Upper limit of pLS
eq5 Upper limit of pG for existing generating units g
eq6 Upper limit of pG for candidate generating units g
;
