* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Example 10

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

model example10 /all/;

solve example10 maximizing z using nlp;

display z.l, x.l, y.l;
