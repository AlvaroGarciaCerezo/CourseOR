* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 8

options lp = cplex, optcr = 0;

sets
b bids /b1*b2/
c consumers /c1*c2/
g producers /g1*g2/
o offers /o1*o2/
;

Parameter PmaxC(c,b) Maximum power associated with consumer c and bid b [MW]
/
c1.b1   240
c1.b2   180
c2.b1   147
c2.b2   110
/;

Parameter PmaxG(g,o) Maximum power associated with producer g and offer o [MW]
/
g1.o1   217
g1.o2   200
g2.o1   220
g2.o2   250
/;

Parameter PriceC(c,b) Price associated with consumer c and bid b [€\MWh]
/
c1.b1   25
c1.b2   23
c2.b1   19
c2.b2   18
/;

Parameter PriceG(g,o) Price associated with producer g and offer o [€\MWh]
/
g1.o1   18
g1.o2   20
g2.o1   21
g2.o2   25
/;

VARIABLES
zSW Social welfare
;

POSITIVE VARIABLES
pC(c,b) Power of consumer c and bid b
pG(g,o) Power of producer g and offer o
;

EQUATIONS
objectiveFunction   Objective function
UpperLimitCB        Upper limit of the power of consumer c and bid b
UpperLimitGO        Upper limit of the power of producer g and offer o
EqBalance           Balance equation
;

objectiveFunction..     zSW =E= sum((c,b),pC(c,b)*PriceC(c,b)) - sum((g,o),pG(g,o)*PriceG(g,o));
UpperLimitCB(c,b)..     pC(c,b) =L= PmaxC(c,b);
UpperLimitGO(g,o)..     pG(g,o) =L= PmaxG(g,o);
EqBalance..             sum((c,b),pC(c,b)) =E= sum((g,o),pG(g,o));

MODEL exercise1_08compacted /all/;

SOLVE exercise1_08compacted using LP maximizing zSW;

DISPLAY zSW.L, EqBalance.M;
