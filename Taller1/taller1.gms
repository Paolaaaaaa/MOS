sets

n dato_nutricional /n1*n6/
r  rango minimo maximo /r1*r2/


c dato_nutricional_producto /c1*c6/
p  producto /p1*p9/
;
$onText

- Paola Andrea Campiño p.campino
- Daniel Alfonso Pilimur da.garciap1


$offText

Table datos(n,r) link cost
        r1      r2
n1      67      9999
n2      0       50
n3      0       25
n4      0       200
n5      1500   9999;

$onText
                minimo  maximo
proteinas       67      9999
grasas          0       50
azucar          0       25
carbohidratos   0       200
calorias        1500    9999


$offText

Table productos (p,n) link cost


        n1      n2      n3     n4      n5      n6
p1      26      19.3    0      0       287      3000
p2      4.2     0.5     0.01   44.1    204      1000
p3      8       0.5     13     11      146      600
p4      6       0.8     25     55      245      700;
$onText

        n1      n2      n3      n4      n5      n6
p1      95      0.5     19      0.3     250      1000
p2      105     1.3     17.2    0.4     270      800
p3      215     4.5     0       1.5     450      1500
p4      165     31.2    0       3.6     150      4500
p5      150     5.5     9       5.1     170      2000
p6      70      6       0.6     4.8     0.6      350
p7      83      8.3     12.5    0.2     100      1200
p8      206     25      0       13      141      8000
p9      55      5.6     1.2     0.5     110      900;
$offText        
$onText

        Calorías      Proteínas      Azúcar      Grasa      Carbohidratos      Precio
Manzana 95            0.5            19          0.3        25                  1000
Plátano 105           1.3            17.2        0.4        27                  800
Arroz   215           4.5            0           1.5        45                  1500
Pollo   165           31.2           0           3.6        0                   4500
Yogur   150           5.5            9           5.1        17                  2000
Huevo   70            6              0.6         4.8        0.6                 350
Leche   83            8.3            12.5        0.2        10                  1200
Salmon  206           25             0           13         0                   8000
Broccoli55            5.6            1.2         0.5        11                  900
    
$offText

Variables
x(p)
z funcion objetivo;

Positive  Variable x;
Equations
funcionObjetivo funcion objetivo
restriccion1
restriccion2;


funcionObjetivo ..  z =e= sum((p),sum(n$(ord(n) eq 6), productos(p,n)*x(p)));
restriccion1(n)$(ord(n)ne 6) ..  sum(p, productos(p, n) * x(p)) =l= datos(n, 'r2');
    
restriccion2(n)$(ord(n)ne 6) .. datos(n, 'r1') =l= sum(p, productos(p, n) * x(p));
Model model1 /all/ ;

option mip=CPLEX;
Solve model1 using mip minimizing z;
Display x.l;
