$onText

- Paola Andrea Campiño p.campino


$offText


sets

o origen /o1*o6/
t suministros /t1*t3/
d suministros /d1*d4/

;


Table suminis(o,t) link cost
        t1  t2  t3 
o1      60  0   1
o2      80  0   2
o3      50  0   3
o4      80  1   1
o5      50  1   2
o6      50  1   3;

$onText

t1: suministro
t2: 0=kernel 1= usuario
t3: 1= origen1 2= origen2 3 = origen 3


$offText

Table costos(d,o) link cost
        o1  o2  o3  o4  o5  o6
d1      300 200 600 999 999 999
d2      500 300 300 999 999 999
d3      999 999 999 300 200 600
d4      999 999 999 500 300 300;

$onText
Cuando no hay link se pone un valor sumamente alto 999
$offText


Table destinos(d,t) link cost
        t1  t2  t3 
d1      100 0   1 
d2      90  0   2
d3      60  1   1
d4      120 1   2
;


$onText

t1: suministro necesitado
t2: 0=kernel 1= usuario
t3: 1= destino1 2= destino2 


$offText

Variables
x(d,o)
z funcion objetivo;

Positive  Variable x;
Equations
funcionObjetivo funcion objetivo
retriccion1
retriccion2

;

funcionObjetivo ..  z =e= sum((d,o),costos(d,o)*x(d,o));
retriccion1(d)  ..  destinos(d,'t1')=e= sum(o,x(d,o));
retriccion2(o) ..  sum(d,x(d,o))=l= suminis(o,'t1');
Model model1 /all/ ;

option mip=CPLEX;
Solve model1 using mip minimizing z;


Display x.l;

$onText

Cabe resalta para hacer este proceso se ha generado 6 origenes para diferenciar entre usuario y kernel, y se ha asumido 4
destinos que permiten diferenciar las difenrentes necesidades entre usuario y kernel.

En la sección de costos como se ha hecho esta diferencias, para hacer que un origen que solo da procesos de kernel no
de procesos de usuario se ha establecido que a todos los destinos de tipo usuario van a tener un valor sumamente grande (999)
de manera que esta no sea una opción dentro de la soluciones.




$offText
