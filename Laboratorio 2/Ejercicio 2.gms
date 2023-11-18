sets

c cientificos /c1*c6/
t area /t1*t4/

;
Scalar trabajadores_tot /4/;
Scalar tecnica_max /1/;
Scalar cobertura /1/;

$onText

Paola Andra Campiño p.campino


$offText

Table notas(t,c) link cost
        c1  c2  c3  c4  c5  c6
t1      85  88  87  82  91  86
t2      78  77  77  76  79  78
t3      82  81  82  80  86  81
t4      84  84  88  83  84  85;

$onText

t1: supervisado
t2: No supervisado
t3: dl
t4: rl


$offText

Variables
x(t,c)
z funcion objetivo;

Binary Variable x;
Equations
funcionObjetivo funcion objetivo
retriccion1 en total hay 4 cientificos
retriccion2 cada cientifico cubre 1 o 0 areas
retriccion3 todas las areas son cubiertas
;

funcionObjetivo ..  z =e= sum((t,c), notas(t,c)*x(t,c));
retriccion1  ..     sum((t,c),x(t,c)) =e= trabajadores_tot;
retriccion3(t)  ..  sum((c),x(t,c)) =e= 1;
retriccion2(c)  ..  sum((t),x(t,c)) =l= tecnica_max;

Model model2 /all/ ;

option mip=CPLEX;
Solve model2 using mip maximizing z;
Display x.l;

$onText
Al final se está maximizando la sumatoria de las notas de los 4 cientificos a seleccionar. Pues de esta forma
llegamos a seleccionar los mejores puntajes para cada técnica. En pantalla se muestra la maximización de las notas de todos.


$offText