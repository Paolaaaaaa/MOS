"""
Paola Andrea Campiño
"""
from __future__ import division

from pyomo.environ import *

from pyomo.opt import SolverFactory
import matplotlib.pyplot as plt


Model = ConcreteModel()

inicial= 4
final = 6

nodos = 7
coordenadas = 2

N=RangeSet(1, nodos)
# SETS & PARAMETERS********************************************************************

nodos = {   (1,1):20,    (1,2):6,   
            (2,1):22,    (2,2):1,   
            (3,1):9,    (3,2):2,   
            (4,1):3,     (4,2):25,   
            (5,1):21,    (5,2):10,   
            (6,1):29,    (6,2):2,   
            (7,1):14,    (7,2):12,   
                            }


Model.distancia = Param(N, N, mutable=True)

Model.costo = Param(N, N, mutable=True)

for i in N:
    for j in N:
        distancia_calc= (((nodos[i,1]-nodos[j,1])**2) +((nodos[i,2]-nodos[j,2])**2))**(1/2)
        Model.distancia[i,j]= distancia_calc
       
        if (distancia_calc<=20):
            Model.costo[i,j]=distancia_calc
        else:
            Model.costo[i,j]=9999
        if (i ==j):
            Model.costo[i,j]=9999



# VARIABLES****************************************************************************
Model.x = Var(N,N, domain=Binary)

# OBJECTIVE FUNCTION*******************************************************************
Model.obj = Objective(expr = sum(Model.x[i,j]*Model.costo[i,j] for i in N for j in N))

# CONSTRAINTS**************************************************************************

def restriccion1(Model, i ):
    if i ==inicial:
        return sum(Model.x[i,j] for j in N) == 1
    else:
        return Constraint.Skip
Model.res1=Constraint(N, rule=restriccion1)

def restriccion2(Model, i ):
    if i ==final:
        return sum(Model.x[j,i] for j in N) == 1
    else:
        return Constraint.Skip
Model.res2=Constraint(N, rule=restriccion2)



def restriccion3(Model, i ):
    if i !=final and i !=inicial:
        return sum(Model.x[i,j] for j in N) == sum(Model.x[j,i] for j in N)
    else:
        return Constraint.Skip
Model.res3=Constraint(N, rule=restriccion3)
#Solve
SolverFactory('glpk').solve(Model)
Model.display()




## Graph

x = []
y=[]
for i in N:
    x.append(nodos[i,1])
    y.append(nodos[i,2])

figure_1 = plt.figure(figsize=(12, 7))
ax_1 = figure_1.add_subplot(1,1,1)



lines_x=[]
lines_y=[]

for i in N:
    for j in N:
        distancia =  Model.costo[i,j].value
        if distancia!=9999:
                        
            lines_x=[x[i-1],x[j-1]]
            lines_y=[y[i-1],y[j-1]]
            ax_1.plot(lines_x,lines_y, "--",color="black",marker='o')




for i in N:
    for j in N:
        distancia =  Model.x[i,j].value
        if distancia==1:
                        
            lines_x=[x[i-1],x[j-1]]
            lines_y=[y[i-1],y[j-1]]
            ax_1.plot(lines_x,lines_y,color="red")



for i in range(0,len(x)):
            ax_1.text(x[i]-0.1,y[i]+0.5,str(i+1), size=10 )

ax_1.set_xlabel('x')
ax_1.set_ylabel('y')
ax_1.set_title(" Grafica:  y vs x")
plt.show()

