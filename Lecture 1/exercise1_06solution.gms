* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 6

options lp = cplex, optcr = 0;

Set
i /i1*i4/
;

Scalar
B /10/
;

Parameter A(i)
/
i1  -2
i2  -1
i3  4
i4  1/
;

Parameter Xmax(i)
/
i1  4
i2  3
i3  5
i4  1/
;

variables
z
;

positive variables
x(i)
;

equations
of
eq1
eq2
;

of..        z =E= sum(i,A(i)*x(i));
eq1(i)..    x(i) =L= Xmax(i);
eq2..       sum(i,x(i)) =E= B;

model exercise1_06 /all/;

solve exercise1_06 minimizing z using lp;

display z.l, x.l;
