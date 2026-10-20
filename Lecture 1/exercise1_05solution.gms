* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 5

options lp = cplex, optcr = 0;

variables
z
;

positive variables
x1
x2
x3
x4
;

equations
of
eq1
eq2
eq3
eq4
eq5
;

of..    z =E= - 2*x1 - x2 + 4*x3 + x4;
eq1..   x1 =L= 4;
eq2..   x2 =L= 3;
eq3..   x3 =L= 5;
eq4..   x4 =L= 1;
eq5..   x1 + x2 + x3 + x4 =E= 10;

model exercise1_05 /all/;

solve exercise1_05 minimizing z using qcp;

display z.l, x1.l, x2.l, x3.l, x4.l;
