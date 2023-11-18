$onText

- Paola Andrea Campiño p.campino
- Daniel Alfonso Pilimur da.garciap1


$offText


sets
i valor /a1*a5/
j peso /c1*c5/;

Parameter a(i) valor de cada articulo
    /a1 12, a2 5, a3 9, a4 6, a5 4 /;
    

Parameter c(j) peso de cada articulo
    /c1 9, c2 2, c3 2, c4 1, c5 3 /;
    
Variables
x(i) 

z       funcionObjetivo  ;

Binary Variable x;

Equations

funcionObjetivo funcion objetivo

peso restriccíon de peso
;

funcionObjetivo                                  ..  z =e= sum((i), a(i) * x(i));
peso                                             ..  sum((j,i)$(ord(j)=ord(i)), c(j) * x(i)) =l= 10;




Model model1 /all/ ;

option mip=CPLEX;
Solve model1 using mip maximizing z;
Display x.l;
Display peso.l;

Display z.l;



