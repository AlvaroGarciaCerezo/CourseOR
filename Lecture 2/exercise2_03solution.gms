* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 2
* Exercise 3

options mip = cplex, optcr = 0;

sets
t Hourly time periods /t1*t24/
;

Scalars
EtaBC   Charging efficiency of the battery [p.u.]                                   /0.9/
EtaBD   Discharging efficiency of the battery [p.u.]                                /0.9/
CPVV    Variable cost of the photovoltaic generating unit [€\MWh]                   /5/
EB0     Initial energy level of the battery [MWh]                                   /15/
EBF     Minimum energy level of the battery at the end of the time horizon [MWh]    /15/
EBmax   Maximum energy level of the battery [MWh]                                   /30/
EBmin   Minimum energy level of the battery [MWh]                                   /5/
PBCmax  Maximum charging power of the battery [MW]                                  /3/
PBDmax  Maximum discharging power of the battery [MW]                               /3/
PDAPmax Upper limit of the power purchased from the day-ahead market [MW]           /4/
PDASmax Upper limit of the power sold from the day-ahead market [MW]                /4/
PPVmax  Capacity of the photovoltaic generating unit [MW]                           /5/                    
;

parameter LambdaDAS(t) Selling day-ahead market price in time period t [€\MWh]
/
t1  200
t2  210
t3  220
t4  20
t5  50
t6  40
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

parameter LambdaDAP(t) Purchasing day-ahead market price in time period t [€\MWh]
;
LambdaDAP(t) = LambdaDAS(t)*1.2;

parameter APV(t) Availability of the production capacity of the photovoltaic generating unit in time period t [p.u.]
/
t1  0
t2  0
t3  0
t4  0
t5  0
t6  0.10
t7  0.20
t8  0.25
t9  0.30
t10 0.40
t11 0.60
t12 0.80
t13 0.85
t14 0.82
t15 0.70
t16 0.60
t17 0.55
t18 0.40
t19 0.20
t20 0.10
t21 0
t22 0
t23 0
t24 0
/
;

variables
zOF Objective function value
;

positive variables
eB(t)   Energy level of the battery [MWh]
pBC(t)  Charging power of the battery [MW]
pBD(t)  Discharging power of the battery [MW]
pDAP(t) Power purchased from the day-ahead market in time period t [MW]
pDAS(t) Power sold from the day-ahead market in time period t [MW]
pPV(t)  Power produced by the photovoltaic generating unit in time period t [MW]
;

binary variables
uB(t)   Charging\discharging status of the battery
;

equations
of  Objective function
eq1 Balance equation
eq2 Upper limit of pDAP
eq3 Upper limit of pDAS
eq4 Upper limit of pPV
eq5 Energy balance equation of the battery
eq6 Lower limit of eB
eq7 Upper limit of eB
eq8 Lower limit of eB at the end of the time horizon
eq9 Upper limit of pBC
eq10 Upper limit of pBD
;

of..                        zOF =E= sum(t, LambdaDAS(t)*pDAS(t) - LambdaDAP(t)*pDAP(t) - CPVV*pPV(t) );
eq1(t)..                    pDAS(t) - pDAP(t) =E= pPV(t) + pBD(t) - pBC(t);
eq2(t)..                    pDAP(t) =L= PDAPmax;
eq3(t)..                    pDAS(t) =L= PDASmax;
eq4(t)..                    pPV(t) =L= PPVmax*APV(t);
eq5(t)..                    eB(t) =E= EB0$(ord(t) = 1) + eB(t-1)$(ord(t) > 1) + pBC(t)*EtaBC - pBD(t)/EtaBD;
eq6(t)..                    EBmin =L= eB(t);
eq7(t)..                    eB(t) =L= EBmax;
eq8(t)$(ord(t) = card(t)).. eB(t) =G= EBF;
eq9(t)..                    pBC(t) =L= PBCmax*uB(t);
eq10(t)..                   pBD(t) =L= PBDmax*(1-uB(t));

model exercise2_3 /all/;

solve exercise2_3 maximizing zOF using mip;

display zOF.L;

execute_unload 'exercise2.3results.gdx' t, zOF.L, eB.L, pBC.L, pBD.L, pDAP.L, pDAS.L, pPV.L, pPV.L, uB.L;
