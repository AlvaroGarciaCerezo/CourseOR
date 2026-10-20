* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 3

options optcr = 0;

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
;

of..    z=E=2*x+y;
eq1..   1 =L= x*x + y*y;
eq2..   x*x + y*y =L= 9;

model exercise1_03 /all/;

solve exercise1_03 maximizing z using qcp;

display z.l, x.l, y.l;
