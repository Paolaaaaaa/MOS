$onText

- Paola Andrea Campiño p.campino
- Daniel Alfonso Pilimur da.garciap1


$offText
sets
i empleados /e1*e4/
j horas de trabajo /t1*t4/;


Table datos(i,j) link cost

        t1  t2  t3  t4
e1      14  5   8   7  
e2      2   12  6   5
e3      7   8   3   9
e4      2   4   6   10;


Variables
x(i,j)
z funcion objetivo;

Binary Variable x;
Equations
funcionObjetivo funcion objetivo
todosTrabajan(i)
proy1Trabajador
;

funcionObjetivo ..  z =e= sum((j),sum((i), datos(i,j)*x(i,j)));
todosTrabajan(i) ..  sum(j, x(i,j) ) =e= 1;
proy1Trabajador(j) .. sum(i,x(i,j)) =e= 1;


Model model2 /all/ ;

option mip=CPLEX;
Solve model2 using mip minimizing z;
Display z.l;
