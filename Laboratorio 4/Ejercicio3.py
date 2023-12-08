"""
Paola Andrea Campiño
"""
from __future__ import division

from pyomo.environ import *

from pyomo.opt import SolverFactory


Model = ConcreteModel()

columnas= 4
filas = 5
tile= 7

C= RangeSet(1,columnas)
F=RangeSet(1, filas)
T= RangeSet(1,tile)


Model.map_tiles = Param(F, C, T,mutable=True)


for i in F:
    for j in C:
        for t in T:
            Model.map_tiles[i,j,t]=0


data  = {
    (1, 1, 1): 1, (1, 1, 2): 0, (1, 1, 3): 0, (1, 1, 4): 0, (1, 2, 5): 1, (1, 2, 3): 0, (1, 2, 6): 0, (1, 3, 5): 1, (1, 3, 6): 0, (1, 4, 7): 0, (1, 3, 7): 0,
    (2, 1, 1): 1, (2, 1, 2): 1, (2, 1, 3): 0, (2, 1, 4): 0, (2, 2, 5): 1, (2, 2, 3): 0, (2, 2, 6): 0, (2, 3, 5): 1, (2, 3, 6): 0, (2, 4, 7): 1, (2, 3, 7): 0,
    (3, 1, 1): 0, (3, 1, 2): 1, (3, 1, 3): 1, (3, 1, 4): 0, (3, 2, 5): 0, (3, 2, 3): 1, (3, 2, 6): 1, (3, 3, 5): 0, (3, 3, 6): 1, (3, 4, 7): 1, (3, 3, 7): 0,
    (4, 1, 1): 0, (4, 1, 2): 0, (4, 1, 3): 1, (4, 1, 4): 1, (4, 2, 5): 0, (4, 2, 3): 1, (4, 2, 6): 1, (4, 3, 5): 0, (4, 3, 6): 1, (4, 4, 7): 1, (4, 3, 7): 0,
    (5, 1, 1): 0, (5, 1, 2): 0, (5, 1, 3): 0, (5, 1, 4): 1, (5, 2, 5): 0, (5, 2, 3): 0, (5, 2, 6): 0, (5, 3, 5): 0, (5, 3, 6): 0, (5, 4, 7): 1, (5, 3, 7): 1,
}

for key, value in data.items():
    Model.map_tiles[key].set_value(value)
# VARIABLES****************************************************************************

Model.x = Var(F,C, domain=Binary)
# OBJECTIVE FUNCTION*******************************************************************
Model.obj = Objective(expr = sum(Model.x[i,j] for i in F for j in C))


# CONSTRAINTS**************************************************************************
#Todo tubo es visitado 1 vez
def restriccion1(Model, i ):
    return sum(Model.x[k,j]*Model.map_tiles[k,j,i] for k in F for j in C) >= 1
Model.res1=Constraint(T, rule=restriccion1)
#Solve
SolverFactory('glpk').solve(Model)
Model.display()