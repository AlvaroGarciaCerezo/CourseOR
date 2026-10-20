* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 2
* Exercise 6
*
* One time period is considered for the sake of simplicity.
* Neglect ramping limits along with start-up and shut-down costs.

options mip = cplex, optcr = 0;

sets
g   Generating units    /g1/
i   Intervals           /i1*i3/;

scalar
* Case a)
PD  Power demanded [MW] /80/
* Case b)
*PD  Power demanded [MW] /140/
* Case c)
*PD  Power demanded [MW] /260/
;

parameter CGF(g) fixed cost of generating unit g [€]
/
g1  10
/
;

parameter CGV(g,i) Variable cost of generating unit g associated with interval i [€\MWh]
/
g1.i1   0.35
g1.i2   0.10
g1.i3   0.20
/
;

parameter PGmin(g) Minimum power output of generating unit g [MW]
/
g1  30
/
;

parameter PGmax(g) Capacity of generating unit g [MW]
/
g1  300
/
;

parameter PGmaxI(g,i) Capacity of generating unit g associated with interval i [MW]
/
g1.i1   100
g1.i2   150
g1.i3   300
/
;

variables
zOF Objective function value [€]
;

positive variables
pG(g)       Power produced by generating unit g [MW]
pGI(g,i)    Power produced by generating unit g associated with interval i [MW]
;

binary variables
uG(g) Commitment status of generating unit g
vGI(g,i) Filled status of generating unit g associated with interval i
;

equations
of  Objective function
eq1 Definition of pg
eq2 Lower limit of pGI
eq3 Upper limit of pGI
eq4 Lower limit of pG
eq5 Upper limit of pG
eq6 Energy balance equation
;

of..        zOF =E= sum(g, CGF(g)*uG(g) + sum(i, CGV(g,i)*pGI(g,i) ) );
eq1(g)..    pG(g) =E= PGmin(g)*uG(g) + sum(i, pGI(g,i) );
eq2(g,i)..  (PGmaxI(g,i) - PGmin(g)$(ord(i) = 1) - PGmaxI(g,i-1)$(ord(i) > 1))*vGI(g,i) =L= pGI(g,i);
eq3(g,i)..  pGI(g,i) =L= (PGmaxI(g,i) - PGmin(g))$(ord(i) = 1) + (PGmaxI(g,i) - PGmaxI(g,i-1))*vGI(g,i-1)$(ord(i) > 1);
eq4(g)..    PGmin(g)*uG(g) =L= pG(g);
eq5(g)..    pG(g) =L= PGmax(g)*uG(g);
eq6..       sum(g, pG(g) ) =E= PD;

model exercise2_6 /all/;

solve exercise2_6 minimizing zOF using mip;

display zOF.L;
