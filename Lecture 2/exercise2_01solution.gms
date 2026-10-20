* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 2
* Exercise 1

options mip = cplex, optcr = 0;

sets
g Generating units /g1*g2/
t Hourly time periods /t1*t5/
;

parameter CGF(g) fixed cost of generating unit g [€]
/
g1  4
g2  5
/
;

parameter CGSD(g) Shut-down cost of generating unit g [€]
/
g1  1
g2  0.5
/
;

parameter CGSU(g) Start-up cost of generating unit g [€]
/
g1  20
g2  15
/
;

parameter CGV(g) Variable cost of generating unit g [€\MWh]
/
g1  0.1
g2  0.15
/
;

parameter PD(t) Power demanded in time period t [MW]
/
t1  40
t2  200
t3  150
t4  300
t5  130
/
;

parameter PG0(g) Initial power produced of generating unit g [MW]
/
g1  0
g2  0
/
;

parameter PGmin(g) Minimum power output of generating unit g [MW]
/
g1  30
g2  40
/
;

parameter PGmax(g) Capacity of generating unit g [MW]
/
g1  300
g2  400
/
;

parameter RGD(g) Ramping-down limit of generating unit g [MW\h]
/
g1  120
g2  180
/
;

parameter RGSD(g) Shut-down ramping limit of generating unit g [MW\h]
/
g1  80
g2  100
/
;

parameter RGSU(g) Start-up ramping limit of generating unit g [MW\h]
/
g1  50
g2  60
/
;

parameter RGU(g) Ramping-up limit of generating unit g [MW\h]
/
g1  100
g2  120
/
;

parameter UG0(g) Initial commitment status of generating unit g
/
g1  0
g2  0
/
;

variables
zOF Objective function value [€]
;

positive variables
pG(g,t) Power produced by generating unit g in time period t [MW]
;

binary variables
uG(g,t) Commitment status of generating unit g in time period t
yG(g,t) Start-up status of generating unit g in time period t
zG(g,t) Shut-down status of generating unit g in time period t
;

equations
of  Objective function
eq1 Relationship of uG yG and zG
eq2 Constraint to impose that yG + zG <= 1
eq3 Lower limit of pG
eq4 Upper limit of pG
eq5 Ramping-up and start-up ramping limits
eq6 Ramping-down and shut-down ramping limits
eq7 Energy balance equation
;

of..        zOF =E= sum(t, sum(g, CGF(g)*uG(g,t) + CGV(g)*pG(g,t) + CGSU(g)*yG(g,t) + CGSD(g)*zG(g,t) ) );
eq1(g,t)..  yG(g,t) - zG(g,t) =E= uG(g,t) - uG(g,t-1)$(ord(t) > 1) - UG0(g)$(ord(t) = 1);
eq2(g,t)..  yG(g,t) + zG(g,t) =L= 1;
eq3(g,t)..  PGmin(g)*uG(g,t) =L= pG(g,t);
eq4(g,t)..  pG(g,t) =L= PGmax(g)*uG(g,t);
eq5(g,t)..  pG(g,t) - pG(g,t-1)$(ord(t) > 1) - PG0(g)$(ord(t) = 1) =L= RGU(g)*( uG(g,t-1)$(ord(t) > 1) + UG0(g)$(ord(t) = 1) ) + RGSU(g)*yG(g,t);
eq6(g,t)..  pG(g,t-1)$(ord(t) > 1) + PG0(g)$(ord(t) = 1) - pG(g,t) =L= RGD(g)*uG(g,t) + RGSD(g)*zG(g,t);
eq7(t)..    sum(g, pG(g,t) ) =E= PD(t);

model exercise2_1 /all/;

solve exercise2_1 minimizing zOF using mip;

display zOF.L;
