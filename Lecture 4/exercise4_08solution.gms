* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 4
* Exercise 8

options lp = cplex, optcr = 0;

sets
g       Generating units            /g1*g3/
gOld(g) Existing generating units   /g1/
gNew(g) Candidate generating units  /g2*g3/
k       Index of the loop           /k1*k11/
t       Representative time periods /t1*t4/
w       Scenarios                   /w1*w10/
;

Scalars
Alpha       Risk-aversion level [p.u.]      /0.95/
BetaScalar  Risk-weighting parameter [p.u.] 
CImax       Investment budget [€]           /200000/
CLS         Load-shedding cost [€\MWh]      /1000/
CRF         Capital recovery factor         /0.10086/
;

parameter BetaVector(k) Risk-weighting parameter in iteration k [p.u.]
/
k1  0
k2  0.1
k3  0.2
k4  0.3
k5  0.4
k6  0.5
k7  0.6
k8  0.7
k9  0.8
k10 0.9
k11 1
/
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
w9  0.15
w10 0.01
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

parameter CostWloop(w,k) Cost of scenario w and iteration k [€];

parameter CVaRloop(k) CVaR in iteration k [€];

parameter ExpectLoop(k) Expected value in iteration k [€];

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
t4.w10  990
/
;

parameter PGmaxOld(g) Capacity of existing generating unit g [MW]
/
g1  300
/
;

parameter PGmaxNew(g) Capacity built of generating unit g in iteration k [MW]
/
g2  400
g3  500
/
;

Parameter PGmaxLoop(g,k) Objective function value in iteration k [€];

variables
varphi  Value-at-risk [€]
zOF     Objective function value [€]
;

Parameter ZOFloop(k) Objective function value in iteration k [€];

positive variables
pG(g,t,w)   Power produced by generating unit g in representative time period t and scenario w [MW]
pGmax(g)    Capacity built of generating unit g [MW]
pLS(t,w)    Load-shedding power in representative time period t and scenario w [MW]
uW(w)       Auxiliary variable to compute the CVaR [€]
;

equations
of  Objective function
eq1 Lower limit of uW(w)
eq2 Investment cost limit
eq3 Upper limit of pGmax
eq4 Energy balance equation
eq5 Upper limit of pLS
eq6 Upper limit of pG for existing generating units g
eq7 Upper limit of pG for candidate generating units g
;

of..                    zOF =E= BetaScalar * ( sum(w, Prob(w) * sum(t, Rho(t) * ( CLS*pLS(t,w) + sum(g, CGV(g)*pG(g,t,w) ) ) ) ) + sum(g$gNew(g), CGI(g)*CRF*pGmax(g) ) ) + ( 1 - BetaScalar ) * ( varphi + ( 1 / ( 1 - Alpha ) ) * sum(w, Prob(w) * uW(w) ) );
eq1(w)..                uW(w) =G= sum(t, Rho(t) * ( CLS*pLS(t,w) + sum(g, CGV(g)*pG(g,t,w) ) ) ) + sum(g$gNew(g), CGI(g)*CRF*pGmax(g) ) - varphi;
eq2..                   sum(g$gNew(g), CGI(g)*CRF*pGmax(g) ) =L= CImax;
eq3(g)$gNew(g)..        pGmax(g) =L= PGmaxNew(g);
eq4(t,w)..              sum(g, pG(g,t,w) ) =E= PD(t,w) - pLS(t,w);
eq5(t,w)..              pLS(t,w) =L= PD(t,w);
eq6(g,t,w)$gOld(g)..    pG(g,t,w) =L= PGmaxOld(g);
eq7(g,t,w)$gNew(g)..    pG(g,t,w) =L= pGmax(g);

model exercise4_8 /all/;

LOOP(k,
    BetaScalar = BetaVector(k);
    solve exercise4_8 minimizing zOF using lp;
    CostWloop(w,k) = sum(t, Rho(t) * ( CLS*pLS.L(t,w) + sum(g, CGV(g)*pG.L(g,t,w) ) ) ) + sum(g$gNew(g), CGI(g)*CRF*pGmax.L(g) );
    ExpectLoop(k) = sum(w, Prob(w) * CostWloop(w,k) );
    CVaRloop(k) = varphi.L + ( 1 / ( 1 - Alpha ) ) * sum(w, Prob(w) * uW.L(w) );
    ZOFloop(k) = zOF.L;
    PGmaxLoop(g,k) = pGmax.L(g);
);

display ZOFloop, PGmaxLoop, CostWloop, ExpectLoop, CVaRloop;
