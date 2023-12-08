$onText

solo:

Paola Andra campiño p.campino


$offText


sets

l lado /l1*l2/
c canción /c1*c8/
p propiedades /p1*p4/
;
Scalar tiempo_min /14/;
Scalar tiempo_max /16/;
Scalar blues_count /2/;
Scalar min_rr_a  /3/;





Table canciones (c,p) link cost
    p1  p2  p3  p4 
c1  4   1   0   0  
c2  5   0   1   0
c3  3   1   0   0  
c4  2   0   1   0
c5  4   1   0   0
c6  3   0   1   0
c7  5   0   0   1
c8  4   1   1   0;


$onText

p1 minutos


p2= 1 blues rock
p3 = 2 rock and roll
p4 = 3 sin genero

$offText



Variables
x(l,c)
z funcion objetivo;
Binary Variable x;
Equations
funcionObjetivo
limite_tempo_min limite de tiempo para cada lado
limite_tempo_max limite de tiempo maximo
c_una_cado_lado  la canción solo puede estar a un lado
req_blues requerimientos de musica minimo
req_rock_a rock and roll para lado a
cancion1_a si la canción 1 está en el lado a entonces canción 5 no puede estar en a
cancion2_4 si la canción 2 y 4 estan en lado a entoncces canción 1 está en lado b
;

funcionObjetivo(l) ..  z =e= sum((c),x(l,c));
limite_tempo_min(l)    ..  tiempo_min =l= sum(c, x(l,c)*canciones(c,'p1'))  ;
limite_tempo_max(l)      .. sum(c, x(l,c)*canciones(c,'p1')) =l= tiempo_max;
c_una_cado_lado(c)      .. sum (l, x(l,c))=e= 1;
req_blues(l)            .. sum(c, x(l,c)*canciones(c,'p2')) =e= blues_count;
req_rock_a               .. sum(c, x('l1',c)*canciones(c,'p3')) =e= min_rr_a;
cancion1_a               ..1-x('l1','c1')=g= x('l1','c5');
cancion2_4              .. x('l2','c5')=g= x('l1','c4') + x('l1','c2')-1;

Model model3 /all/ ;

option mip=CPLEX;
Solve model3 using mip maximizing z;


Display x.l;



$onText
En la solución se puede leer en reading solution form model :
l1: Lado A
l2: Lado B

C1..C8 = canción 1 ... canción 8
$offText
