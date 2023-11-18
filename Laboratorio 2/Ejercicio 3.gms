sets

c zonas /c1*c12/
a zonas /a1*a12/

;


Scalar cobertura /1/;


$onText

Paola Andra Campiño p.campino


$offText


table zonas(a,c) link cost
        c1  c2  c3  c4  c5  c6  c7  c8  c9  c10 c11 c12
a1      1   1   1   0   1   0   0   0   0   0   0   0 
a2      1   1   0   0   1   0   0   0   0   0   0   0
a3      1   0   1   1   1   1   1   1   0   0   0   0
a4      0   0   1   1   1   1   0   0   0   0   1   0
a5      1   1   1   1   1   0   0   0   0   1   1   0
a6      0   0   1   1   0   1   0   1   0   0   1   0
a7      0   0   1   0   0   0   1   1   0   0   0   1
a8      0   0   1   0   0   1   1   1   1   0   1   1
a9      0   0   0   0   0   0   0   1   1   1   1   1
a10     0   0   0   0   1   0   0   0   1   1   1   0
a11     0   0   0   1   1   1   0   1   1   1   1   0
a12     0   0   0   0   0   0   1   1   1   0   0   1;

$onText
Una matriz simetrica que contiene las zonas cuebiertas al ser seleccionada dicha zona. 

$offText
Variables
x(c)
z funcion objetivo;

Binary Variable x;
Equations
funcionObjetivo funcion objetivo
retriccion1 total de zonas cubiertas == 12;
funcionObjetivo ..  z =e= sum((c), x(c));
retriccion1(a) ..   cobertura=l=sum((c),x(c)*zonas(a,c));


$onText

se minimiza la cantidad de zonas.

para todas las zonas en donde la sumatoria de todos los c tiene que se igual o mayor  a 1. De esta
manera confirmamos que todas las zonas son cuebiertas.
$offText

Model model3 /all/ ;

option mip=CPLEX;
Solve model3 using mip minimicing z;
Display x.l;



