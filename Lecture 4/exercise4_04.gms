* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 4
* Exercise 4

options lp = cplex, optcr = 0;

sets
g       Generating units            /g1*g3/
gOld(g) Existing generating units   /g1/
gNew(g) Candidate generating units  /g2*g3/
t       Representative time periods /t1*t4/
w       Scenarios                   /w1*w10/
;

Scalars
CImax   Investment budget [€]       /180000/
CLS     Load-shedding cost [€\MWh]  /10000/
CRF     Capital recovery factor     /0.10086/
;

parameter Prob(w) Probability of scenario w [p.u.]
/
w1  0.10
w2  0.05
w3  0.12
w4  0.07
w5  0.23
w6  0.08
w7  0.04
w8  0.15
w9  0.09
w10 0.07
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

parameter PD(t,w) Power demanded in representative time period t and scenario w [MW]
/
t1.w1   480
t2.w1   400
t3.w1   720
t4.w1   970
t1.w2   380
t2.w2   390
t3.w2   660
t4.w2   700
t1.w3   410
t2.w3   430
t3.w3   670
t4.w3   860
t1.w4   470
t2.w4   376
t3.w4   694
t4.w4   942
t1.w5   370
t2.w5   430
t3.w5   680
t4.w5   960
t1.w6   370
t2.w6   300
t3.w6   550
t4.w6   870
t1.w7   430
t2.w7   450
t3.w7   730
t4.w7   980
t1.w8   308
t2.w8   360
t3.w8   524
t4.w8   840
t1.w9   490
t2.w9   451
t3.w9   700.22
t4.w9   856.78
t1.w10  410
t2.w10  387
t3.w10  640
t4.w10  945
/
;
* I modify the values of PD(t,w) with respect to exercise 1 to create the set of out-of-sample scenarios.
* I do this for the sake of simplicity.
* For example, the out-of-sample analysis may involve a set of scenarios generated using:
* - Different probability density functions in comparison with the set of in-sample scenarios.
* - The same probability density function as the set of in-sample scenarios, but using more scenarios.
PD('t1',w) = PD('t1',w) * 0.9;
PD('t2',w) = PD('t2',w) * 1.15;
PD('t3',w) = PD('t3',w) * 1.1;
PD('t4',w) = PD('t4',w) * 0.94;

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
pG(g,t,w)   Power produced by generating unit g in representative time period t and scenario w [MW]
pGmax(g)    Capacity built of generating unit g [MW]
pLS(t,w)    Load-shedding power in representative time period t and scenario w [MW]
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

* The following lines should be included before solving the problem.
pGmax.fx('g2') = 396.8987;
pGmax.fx('g3') = 283.1013;
