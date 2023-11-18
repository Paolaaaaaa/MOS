sets

c coordenas /c1*c2/
n zonas /n1*n7/
alias(i,n);


;

Scalar nodo_inic /4/;

Scalar nodo_fin /6/;


$onText

Paola Andra Campiño p.campino


$offText

table nodos(n,c) link cost
        c1  c2   
n1      20  6    
n2      22  1   
n3      9   2   
n4      3   25
n5      21  10   
n6      29  2   
n7      14  12   
  
;

Parameter  distancia(n,i);
Parameter  costos(n,i);


loop((n,i),
    distancia(n,i) = sqrt(sqr(nodos(n,'c1')-nodos(i,'c1')) + sqr(nodos(n,'c2')-nodos(i,'c2')));

);

$onText

Calculo de distancias
$offText

loop((n,i),
    if(distancia(n,i) <= 20,
    costos(n,i) = distancia(n,i);
else
    costos(n,i) = 9999;

    
);


);


$onText
Si la distancia es menor a 20 se agrega en la matriz de costos, en caso contrario se pone un valor muy alto
para representar que no hay camino. Como no hay cambino a si mismas el valor entre el mismo nodo también es igual a 9999.
$offText
costos(n,n) = 9999;

Variables
x(n,i)
z funcion objetivo;



Binary Variable x;
Equations
funcionObjetivo funcion objetivo
sourceNode(n)            source node
destinationNode(i)       destination node
intermediateNode         intermediate node;
funcionObjetivo ..  z =e= sum((n,i),costos(n,i)*x(n,i));


sourceNode(n)$(ord(n) = nodo_inic)                 ..  sum((i), x(n,i)) =e= 1;

destinationNode(i)$(ord(i) = nodo_fin)                    ..  sum((n), x(n,i)) =e= 1;

intermediateNode(n)$(ord(n) <> nodo_inic and ord(n) ne nodo_fin)  ..  sum((i), x(n,i)) - sum((i), x(i,n)) =e= 0;


$onText
Mismas restricciones de camino de costo minimo y minimizar el costo de nodo 4 a nodo 6.
$offText

Model model4 /all/ ;

option mip=CPLEX;
Solve model4 using mip minimicing z;
Display x.l;
Display costos;