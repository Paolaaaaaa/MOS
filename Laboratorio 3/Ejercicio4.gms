$onText

solo:

Paola Andra campiño p.campino


$offText


sets

c /c1*c4/
f/f1*f5/
t /t1*t7/
;


Table map_tiles (f,c,t) crop data

     c1.t1  c1.t2   c1.t3   c1.t4   c2.t5   c2.t3   c2.t6   c3.t5   c3.t6   c4.t7   c3.t7 
f1   1       0       0       0       1       0       0       1       0       0       0           
f2   1       1       0       0       1       0       0       1       0       1       0   
f3   0       1       1       0       0       1       1       0       1       1       0 
f4   0       0       1       1       0       1       1       0       1       1       0
f5   0       0       0       1       0       0       0       0       0       1       0;    


$onText
c = columna
f = fila
t tuberías, 

$offText


Variables
x(f,c)
z funcion objetivo;
Binary Variable x;
Equations
funcionObjetivo
todo_tubo
;

funcionObjetivo ..  z =e= sum((c,f),x(f,c));
todo_tubo(t)       .. 1 =l= sum((f,c),x(f,c)*map_tiles(f,c,t));
Model model4 /all/ ;

option mip=CPLEX;
Solve model4 using mip minimizing z;

Display map_tiles;
Display x.l;

$onText
Como resultado se muestra una matriz de f x c
c = columnas
f = son las filas

1 = para levantar la sección

$offText
