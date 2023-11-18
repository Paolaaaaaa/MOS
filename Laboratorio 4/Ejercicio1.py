"""
Paola Andrea Campiño
"""
from __future__ import division

from pyomo.environ import *

from pyomo.opt import SolverFactory


Model = ConcreteModel()

origenes = 6
datos = 3
destinos =4
O=RangeSet(1, origenes)
T=RangeSet(1, datos)
D=RangeSet(1, destinos)


"""

t1: suministro
t2: 0=kernel 1= usuario
t3: 1= origen1 2= origen2 3 = origen 3
            t1          t2          t3
"""

Model.cost = Param(D, O, mutable=True)



# SETS & PARAMETERS********************************************************************

for i in D:
    for j in O:
        Model.cost[i,j]= 999

suminis = { (1,1):60,    (1,2):0,   (1,3):1,\
            (2,1):80,    (2,2):0,   (2,3):2,\
            (3,1):50,    (3,2):0,   (3,3):3,\
            (4,1):80,    (4,2):1,   (4,3):1,\
            (5,1):50,    (5,2):1,   (5,3):2,\
            (6,1):50,    (6,2):1,   (6,3):3,\
                            }

destinos = {(1,1):100,    (1,2):0,   (1,3):1,\
            (2,1):90,    (2,2):0,   (2,3):2,\
            (3,1):60,    (3,2):1,   (3,3):1,\
            (4,1):120,    (4,2):1,   (4,3):2,\

                            }

Model.cost[1,1]=300
Model.cost[1,2]=200
Model.cost[1,3]=600
Model.cost[2,1]=500
Model.cost[2,2]=300
Model.cost[2,3]=300
Model.cost[3,4]=300
Model.cost[3,5]=200
Model.cost[3,6]=600
Model.cost[4,4]=500
Model.cost[4,5]=300
Model.cost[4,6]=300

# VARIABLES****************************************************************************
Model.x = Var(D,O, domain=PositiveReals)

# OBJECTIVE FUNCTION*******************************************************************
Model.obj = Objective(expr = sum(Model.x[i,j]*Model.cost[i,j] for i in D for j in O))

# CONSTRAINTS**************************************************************************

# Lo suministrado tiene que ser igual a la demanda
def restriccion1(Model, i ):
    return sum(Model.x[i,j] for j in O) == destinos[i,1]
Model.res1=Constraint(D, rule=restriccion1)

# Lo suministrado no puede sobrepasar las capacidades
def restriccion2(Model, i ):
    return sum(Model.x[j,i] for j in D)<=suminis[i,1]
Model.res2=Constraint(O, rule=restriccion2)


#Solve
SolverFactory('glpk').solve(Model)
Model.display()


"""
se ha generado 6 origenes para diferenciar entre usuario y kernel, y se ha asumido 4
destinos que permiten diferenciar las difenrentes necesidades entre usuario y kernel.

En la sección de costos como se ha hecho esta diferencias, para hacer que un origen que solo da procesos de kernel no
de procesos de usuario se ha establecido que a todos los destinos de tipo usuario van a tener un valor sumamente grande (999)
de manera que esta no sea una opción dentro de la soluciones.


"""