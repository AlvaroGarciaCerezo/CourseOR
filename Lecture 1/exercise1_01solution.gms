* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 1

options lp = cplex, optcr = 0;

variables
z
;

positive variables
x
y
;

equations
of
eq1
eq2
eq3
;

of..    z =E= 2*x+y;
eq1..   x =L= 5;
eq2..   y =L= 3;
eq3..   x + y =L= 4;

model exercise1_01 /all/;

solve exercise1_01 maximizing z using lp;

display z.l, x.l, y.l;
