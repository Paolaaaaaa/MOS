$onText
solo:

Paola Andra campiño p.campino


$offText


sets

p /p1*p6/
a /a1*a6/


;

Scalar cobertura /1/;





Table publo_t(a,p) link post
        p1  p2  p3  p4  p5  p6
a1      0   10  20  30  30  20
a2      10  0   25  35  20  10
a3      20  25  0   15  30  20
a4      30  35  15  0   15  25
a5      30  20  30  15   0  14
a6      20  10  20  25  14  0;


Parameter  tiempos_validos(a,p);



loop((a,p),
    if(publo_t(a,p) <= 15,
    tiempos_validos(a,p) = 1;
else
    tiempos_validos(a,p) = 0;
);

    
);





Variables
x(a)
z funcion objetivo;


Binary Variable x;
Equations
funcionObjetivo
retriccion1 minima cobertura por zona =1
;

funcionObjetivo ..  z =e= sum(a,x(a));
retriccion1(p) ..   cobertura=l=sum((a),x(a)*tiempos_validos(a,p));

Model model2 /all/ ;

option mip=CPLEX;
Solve model2 using mip minimizing z;


Display x.l;
