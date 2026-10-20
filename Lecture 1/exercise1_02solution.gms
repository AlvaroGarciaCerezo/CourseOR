* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 2

options mip = cplex, optcr = 0;

variables
z
;

integer variables
x
y
;

equations
of
eq1
eq2
eq3
eq4
;

of..    z =E= 2*x+y;
eq1..   x =L= 2.5;
eq2..   y =L= 3;
eq3..   1 =L= y;
eq4..   x + y =L= 4.7;

model exercise1_02 /all/;

solve exercise1_02 maximizing z using mip;

display z.l, x.l, y.l;