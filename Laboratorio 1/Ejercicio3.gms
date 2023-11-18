$onText

- Paola Andrea Campiño p.campino
- Daniel Alfonso Pilimur da.garciap1


$offText


sets

o origen /o1*o4/
s suministros /s1/
d suministros /d1*d4/

;


Table suminis(o,s) link cost
        s1 
o1      300
o2      500
o3      200;

Table costos(d,o) link cost
        o1  o2  o3 
d1      8   9   14
d2      6   12  9
d3      10  13  16
d4      9   7   5;

Table destinos(d,s) link cost
        s1 
d1      200
d2      300
d3      100
d4      400;



Variables
x(d,o)
z funcion objetivo;


Positive  Variable x;
Equations
funcionObjetivo funcion objetivo
restriccion1
restriccion2
;

funcionObjetivo ..  z =e= sum((d,o),costos(d,o)*x(d,o));
restriccion1(d)..  sum(o,x(d,o)) =e= destinos(d,'s1');
restriccion2(o).. sum(d,x(d,o))=l= suminis(o,'s1');


Model model1 /all/ ;

option mip=CPLEX;
Solve model1 using mip minimizing z;
Display x.l;