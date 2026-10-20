* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 8

options lp = cplex, optcr = 0;

VARIABLES
zSW Social welfare [€]
;

POSITIVE VARIABLES
pc1b1 Power of consumer 1 and bid 1 [MW]
pc1b2 Power of consumer 1 and bid 2 [MW]
pc2b1 Power of consumer 2 and bid 1 [MW]
pc2b2 Power of consumer 2 and bid 2 [MW]
pg1o1 Power of producer 1 and offer 1 [MW]
pg1o2 Power of producer 1 and offer 2 [MW]
pg2o1 Power of producer 2 and offer 1 [MW]
pg2o2 Power of producer 2 and offer 2 [MW]
;

EQUATIONS
objectiveFunction Objective function
UpperLimitC1B1 Upper limit of the power of consumer 1 and bid 1
UpperLimitC1B2 Upper limit of the power of consumer 2 and bid 2
UpperLimitC2B1 Upper limit of the power of consumer 1 and bid 1
UpperLimitC2B2 Upper limit of the power of consumer 2 and bid 2
UpperLimitG1O1 Upper limit of the power of producer 1 and offer 1
UpperLimitG1O2 Upper limit of the power of producer 1 and offer 2
UpperLimitG2O1 Upper limit of the power of producer 2 and offer 1
UpperLimitG2O2 Upper limit of the power of producer 2 and offer 2
EqBalance Balance equation
;

objectiveFunction..     zSW =E= pc1b1*25 + pc1b2*23 + pc2b1* 19 + pc2b2*18 - ( pg1o1*18 + pg1o2*20 + pg2o1*25 + pg2o2*21 );
UpperLimitC1B1..        pc1b1 =L= 240;
UpperLimitC1B2..        pc1b2 =L= 180;
UpperLimitC2B1..        pc2b1 =L= 147;
UpperLimitC2B2..        pc2b2 =L= 110;
UpperLimitG1O1..        pg1o1 =L= 217;
UpperLimitG1O2..        pg1o2 =L= 200;
UpperLimitG2O1..        pg2o1 =L= 250;
UpperLimitG2O2..        pg2o2 =L= 220;
EqBalance..             pc1b1 + pc1b2 + pc2b1 + pc2b2 =E= pg1o1 + pg1o2 + pg2o1 + pg2o2;

MODEL exercise1_08 /all/;

SOLVE exercise1_08 using LP maximizing zSW;

DISPLAY zSW.L, EqBalance.M;
