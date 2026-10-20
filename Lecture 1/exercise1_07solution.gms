* Course OR
* Álvaro García Cerezo
* 2026
* Lecture 1
* Exercise 7

options lp = cplex, optcr = 0;

Set
i /i1*i4/
k /k1*k5/
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

Parameter Bloop(k)
/
k1  0
k2  3
k3  8
k4  12
k5  21/
;

Parameter Xmax(i)
/
i1  4
i2  3
i3  5
i4  1/
;

Parameter Zloop(k), Xloop(i,k)
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

model exercise1_07 /all/;

LOOP(k,
    B = Bloop(k);
    solve exercise1_07 minimizing z using lp;
    Zloop(k) = z.L;
    Xloop(i,k) = x.L(i);
);

display Zloop, Xloop;
