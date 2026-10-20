* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 2
* Exercise 2

options lp = cplex, optcr = 0;

sets
t Hourly time periods /t1*t24/
;

Scalars
EDFmin  Minimum total consumption of the flexible demand [MWh]      /90/
PDF0    Initial power consumed by the flexible demand [MW]          /4/
PDAPmax Upper limit of the power purchased from the day-ahead market [MW]  /10/
RDD     Ramping-down limit of the flexible demand [MW\h]            /2/
RDU     Ramping-up limit of the flexible demand [MW\h]              /2/
;

parameter LambdaDAP(t) Purchasing day-ahead market price in time period t [€\MWh]
/
t1  200
t2  210
t3  220
t4  205
t5  190
t6  198
t7  190
t8  180
t9  100
t10 20
t11 30
t12 20
t13 10
t14 15
t15 25
t16 20
t17 50
t18 100
t19 150
t20 190
t21 200
t22 220
t23 210
t24 205
/
;

parameter PDFmin(t) Lower limit of the power consumed by the flexible demand in time period t [MW]
/
t1  1
t2  0.5
t3  2
t4  2.5
t5  3
t6  1
t7  2
t8  4
t9  5
t10 2
t11 6
t12 2
t13 1
t14 5
t15 4
t16 0.5
t17 2
t18 5
t19 1
t20 4
t21 5
t22 3
t23 1
t24 1
/
;

parameter PDFmax(t) Upper limit of the power consumed by the flexible demand in time period t [MW]
/
t1  6
t2  5
t3  8
t4  9
t5  10
t6  6
t7  7
t8  8
t9  7
t10 8
t11 11
t12 7
t13 9
t14 7
t15 9
t16 5
t17 6
t18 8
t19 4
t20 6
t21 7
t22 4
t23 6
t24 6
/
;

variables
zOF Objective function value
;

positive variables
pDF(t) Power consumed by the flexible demand in time period t [MW]
;

equations
of  Objective function
eq1 Upper limit of pDF associated with PDAPmax
eq2 Lower limit of pDF
eq3 Upper limit of pDF
eq4 Ramping-up limits of the flexible demand
eq5 Ramping-down limits of the flexible demand
eq6 Minimum total energy consumption
;

of..        zOF =E= sum(t, LambdaDAP(t)*pDF(t) );
eq1(t)..    pDF(t) =L= PDAPmax;
eq2(t)..    PDFmin(t) =L= pDF(t);
eq3(t)..    pDF(t) =L= PDFmax(t);
eq4(t)..    pDF(t) - pDF(t-1)$(ord(t) > 1) - PDF0$(ord(t) = 1) =L= RDU;
eq5(t)..    pDF(t-1)$(ord(t) > 1) + PDF0$(ord(t) = 1) - pDF(t) =L= RDD;
eq6..       sum(t,pDF(t)) =G= EDFmin;

model exercise2_2 /all/;

solve exercise2_2 minimizing zOF using mip;

display zOF.L;

execute_unload 'exercise2.2results.gdx' t, zOF.L, pDF.L, PDFmin, PDFmax;

