"""
Paola Andrea Campiño
"""
from __future__ import division

from pyomo.environ import *

from pyomo.opt import SolverFactory

Model = ConcreteModel()

pueblos= 6
a = 6

P= RangeSet(1,pueblos)
A=RangeSet(1, a)


cobertura_min_pueblo =1


#Parametros

tiempos = { (1,1):0,     (1,2):10,   (1,3):20,  (1,4):30,    (1,5):30,   (1,6):20,\
            (2,1):10,    (2,2):0,    (2,3):25,  (2,4):35,    (2,5):20,   (2,6):10,\
            (3,1):20,    (3,2):25,   (3,3):0,   (3,4):15,    (3,5):30,   (3,6):20,\
            (4,1):30,    (4,2):35,   (4,3):15,  (4,4):0,     (4,5):15,   (4,6):25,\
            (5,1):30,    (5,2):20,   (5,3):30,  (5,4):15,    (5,5):0,    (5,6):14,\
            (6,1):20,    (6,2):10,   (6,3):20,  (6,4):25,    (6,5):14,   (6,6):0,\
                            }


Model.tvalidos = Param(A,P, mutable=True)

for i in range(1,pueblos+1):
    for j in range(1,pueblos+1):
        if (tiempos[i,j]<=15):
            Model.tvalidos[i,j]=1
        else:
            Model.tvalidos[i,j]=0


# VARIABLES****************************************************************************

Model.x = Var(A, domain=Binary)

# OBJECTIVE FUNCTION*******************************************************************
Model.obj = Objective(expr = sum(Model.x[i] for i in A ))
# CONSTRAINTS**************************************************************************
def restriccion1(Model, i ):
    return sum(Model.x[j]*Model.tvalidos[j,i] for j in A) >= cobertura_min_pueblo
Model.res1=Constraint(P, rule=restriccion1)


#Solve
SolverFactory('glpk').solve(Model)
Model.display()