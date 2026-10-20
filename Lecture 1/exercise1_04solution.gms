* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 4

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
eq3
eq4
eq5
;

of..    z =E= 2*x+y;
eq1..   x =L= 5;
eq2..   y =L= 3;
eq3..   1 =L= x;
eq4..   1 =L= y;
eq5..   y*(x-1) =L= x;

model exercise1_04 /all/;

solve exercise1_04 maximizing z using nlp;

display z.l, x.l, y.l;
