
$onText
solo:
- Paola Andrea Campiño p.campino


$offText


sets

t  /t1*t7/
j jugador /j1*j7/
l limites /l1*l2/
v values /v1/


;
Scalar max_jugador /5/;

Table rol_range(t,l) link cost
    l1  l2
t5  4   999
t6  2   999
t7  1   999;


Table promedio (t,v) link cost
    v1
t1  2
t2  2
t3  2
t4  2;

Table capacidad(j,t) link cost
        t1  t2  t3  t4  t5  t6  t7
j1      3   3   1   3   0   1   0
j2      2   1   3   2   0   0   1
j3      2   3   2   2   1   1   0
j4      1   3   3   1   1   0   1
j5      3   3   3   3   1   1   0
j6      3   1   2   3   1   0   1
j7      3   2   2   1   1   1   0
;

$onText
t1: Control balón
t2: disparo
t3: rebotes
t4: Defensa
t5: rol defenza
t6: rol ataque
t7: rol centro

$offText


Variables
x(j)
z funcion objetivo;


Binary Variable x;
Equations
funcionObjetivo funcion objetivo
restriccion1_equ5 jugadores titulares
minJugadorsRol  minimos jugadores por roles
promedio_min    minimo promedio x area
j2_o_j3         si j2 no j3 y si j3 no j2

;


funcionObjetivo ..  z =e= sum((j) ,capacidad(j,'t4')*x(j));
restriccion1_equ5 .. max_jugador =e= sum(j,x(j));
minJugadorsRol(t) .. sum(j,x(j)*capacidad(j,t)) =g= rol_range(t,'l1');
promedio_min(t) .. sum(j,x(j)*capacidad(j,t))/max_jugador =g= promedio(t,'v1');
j2_o_j3         .. 1-x('j2')=g= x('j3')




Model model2 /all/ ;

option mip=CPLEX;
Solve model2 using mip maximizing z;
Display x.l;