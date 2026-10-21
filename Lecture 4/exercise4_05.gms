* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 4
* Exercise 5

options optcr = 0;

sets
t   Hourly time periods /t1*t24/
w   Scenarios           /w1*w10/
;

Scalars
CGV     Variable cost of the conventional generating unit [€\MWh]                   /30/
EtaBC   Charging efficiency of the battery [p.u.]                                   /0.9/
EtaBD   Discharging efficiency of the battery [p.u.]                                /0.9/
EB0     Initial energy level of the battery [MWh]                                   /15/
EBF     Minimum energy level of the battery at the end of the time horizon [MWh]    /15/
EBmax   Maximum energy level of the battery [MWh]                                   /30/
EBmin   Minimum energy level of the battery [MWh]                                   /5/
EDFmin  Minimum total consumption of the flexible demand [MWh]                      /90/
PBCmax  Maximum charging power of the battery [MW]                                  /3/
PBDmax  Maximum discharging power of the battery [MW]                               /3/
PDAPmax Upper limit of the power purchased from the day-ahead market [MW]           /4/
PDASmax Upper limit of the power sold from the day-ahead market [MW]                /4/
PGmax   Capacity of the the conventional generating unit [MW]                       /5/
PPVmax  Capacity of the photovoltaic generating unit [MW]                           /5/
;

Table LambdaDA(t,w) Day-ahead market price in time period t and scenario w [€\MWh]
        w1      w2      w3      w4      w5      w6      w7      w8      w9      w10
t1      77.84   61.62   62.40   68.44   83.76   58.52   59.92   63.13   77.62   80.14
t2      53.50   52.93   43.30   64.25   70.64   54.84   62.17   59.75   66.81   89.09
t3      68.88   77.73   48.27   62.00   63.23   62.30   75.45   65.90   75.86   93.70
t4      102.52  75.59   65.90   75.77   82.37   63.92   86.87   70.16   80.23   81.39
t5      74.52   73.65   74.40   76.48   56.72   64.24   82.86   77.68   77.47   71.08
t6      89.95   85.34   70.70   98.08   87.73   91.75   93.66   87.86   97.75   110.25
t7      95.02   98.91   107.85  110.29  110.34  103.80  127.42  108.74  112.85  84.68
t8      90.73   100.19  113.90  96.76   103.31  104.61  114.19  92.93   101.78  85.60
t9      68.83   56.23   91.70   71.93   80.81   78.25   90.53   65.73   96.05   66.82
t10     30.91   13.46   35.15   35.03   19.95   42.91   41.98   21.80   42.01   39.91
t11     22.11   12.21   48.22   35.70   36.73   51.25   49.14   29.40   19.15   61.87
t12     34.29   25.70   31.67   30.47   14.06   32.42   44.03   32.75   35.10   46.85
t13     64.15   27.24   38.91   32.96   2.02    36.30   13.82   45.45   35.54   11.49
t14     34.01   6.59    23.03   23.28   6.96    16.80   14.45   35.54   25.69   11.23
t15     10.73   11.77   13.48   8.29    13.86   18.11   9.94    34.09   16.81   26.37
t16     40.53   1.03    20.54   9.45    4.03    34.57   4.52    33.75   -0.08   26.14
t17     33.38   16.29   38.38   28.69   17.62   31.67   13.22   23.91   33.36   24.62
t18     43.04   20.03   30.03   17.93   20.54   25.10   25.95   17.02   -0.91   25.65
t19     47.47   38.86   28.85   42.35   33.16   35.81   34.91   35.92   35.63   31.74
t20     63.37   57.59   71.67   63.19   41.35   76.77   80.00   55.12   54.24   74.08
t21     108.01  89.38   99.04   94.92   83.15   92.78   107.99  115.20  95.49   111.88
t22     78.07   73.46   91.58   71.37   96.29   81.06   86.44   100.48  81.98   90.29
t23     58.24   40.48   51.44   57.19   72.31   69.63   50.23   49.56   52.61   44.70
t24     42.64   49.98   39.54   43.81   49.32   64.18   32.74   51.22   50.69   44.72
;

parameter LambdaC(t,w) Tolls and charges added to the day-ahead electricity market price in time period t and scenario w [€\MWh]
;
LambdaC(t,w) = 0.3 * abs(LambdaDA(t,w));

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

parameter PDI(t) Power consumed by the inflexible demand in time period t [MW]
/
t1  0.2
t2  0.55
t3  1.1
t4  0.6
t5  0.8
t6  1.3
t7  0.6
t8  2.2
t9  3.1
t10 0.7
t11 2.6
t12 0.4
t13 2.3
t14 1
t15 0.9
t16 0.2
t17 1.6
t18 3.4
t19 2.2
t20 1.5
t21 1.3
t22 2.4
t23 0.3
t24 0.7
/
;

variables
zOF Objective function value [€]
;

positive variables
eB(t,w)     Energy level of the battery in time period t and scenario w [MWh]
pBC(t,w)    Charging power of the battery in time period t and scenario w [MW]
pBD(t,w)    Discharging power of the battery in time period t and scenario w [MW]
pD(t,w)     Total power consumed by the demand in time period t and scenario w [MW]
pDAP(t)     Power purchased from the day-ahead market in time period t [MW]
pDAS(t)     Power sold from the day-ahead market in time period t [MW]
pDF(t,w)    Power consumed by the flexible demand in time period t and scenario w [MW]
pG(t,w)     Power produced by the conventional generating unit in time period t and scenario w [MW]
pPV(t,w)    Power produced by the photovoltaic generating unit in time period t and scenario w [MW]
;

binary variables
uB(t,w)   Charging\discharging status of the battery
;

equations
of      Objective function
eq1     Upper limit of pDAP
eq2     Upper limit of pDAS
eq3     Balance equation
eq4     Upper limit of pG
eq5     Upper limit of pPV
eq6     Energy balance equation of the battery
eq7     Lower limit of eB
eq8     Upper limit of eB
eq9     Lower limit of eB at the end of the time horizon
eq10    Upper limit of pBC
eq11    Upper limit of pBD
eq12    Definition of pD
eq13    Lower limit of pDF
eq14    Upper limit of pDF
eq15    Minimum total energy consumption
;
